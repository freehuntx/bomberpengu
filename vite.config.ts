// vite.config.ts
import { defineConfig } from 'vite'
import { resolve } from 'path'
import fs from 'fs'
import path from 'path'

// Needed for hosting via github pages
const BASE_PATH = process.env.NODE_ENV === 'production' ? '/bomberpengu/' : '/'

function getAllFilesSync(dir: string): string[] {
  const entries = fs.readdirSync(dir, { withFileTypes: true })
  const files = entries.map((entry) => {
    const res = resolve(dir, entry.name)
    return entry.isDirectory() ? getAllFilesSync(res) : [res]
  })
  return files.flat()
}

// Helper function to modify Ruffle files content if needed
function processRuffleFile(content: Buffer | string, fileName: string): Buffer | string {
  if (fileName.endsWith('.js')) {
    let textContent = content.toString()
    // Modify paths in Ruffle JS files to account for base path
    if (process.env.NODE_ENV === 'production') {
      textContent = textContent.replace(/\/ruffle\//g, BASE_PATH + 'ruffle/')
    }
    return textContent
  }
  return content
}

export default defineConfig({
  base: BASE_PATH,
  optimizeDeps: {
    exclude: ['@ruffle-rs/ruffle'/*, 'msw'*/]
  },
  build: {
    rollupOptions: {
      output: {
        assetFileNames: (assetInfo) => {
          if (assetInfo.name?.endsWith('.wasm')) {
            return 'ruffle/[name][extname]'
          }
          return 'assets/[name]-[hash][extname]'
        }
      }
    }
  },
  server: {
    headers: {
      'Content-Security-Policy-Report-Only': '',
      'Content-Security-Policy': ''
    }
  },
  plugins: [
    {
      name: 'setup-files',
      generateBundle() {
        const rufflePath = resolve(__dirname, 'node_modules/@ruffle-rs/ruffle')
        const ruffleFiles = getAllFilesSync(rufflePath)
        
        for (const file of ruffleFiles) {
          const content = fs.readFileSync(file)
          const relativePath = path.relative(rufflePath, file)
          this.emitFile({
            type: 'asset',
            fileName: `ruffle/${relativePath}`,
            source: processRuffleFile(content, file)
          })
        }

        /*const mswPath = resolve(__dirname, 'node_modules/msw/lib/mockServiceWorker.js')
        const mswContent = fs.readFileSync(mswPath, 'utf-8')
        this.emitFile({
          type: 'asset',
          fileName: 'mockServiceWorker.js',
          source: mswContent
        })*/
      },
      configureServer(server) {
        const rufflePath = resolve(__dirname, 'node_modules/@ruffle-rs/ruffle')

        // File serving middleware
        server.middlewares.use((req, res, next) => {
          const url = req.url || '';
          
          /*if (url === '/mockServiceWorker.js') {
            const mswPath = resolve(__dirname, 'node_modules/msw/lib/mockServiceWorker.js')
            const content = fs.readFileSync(mswPath, 'utf-8')
            res.setHeader('Content-Type', 'application/javascript')
            // Add CSP headers specifically for the service worker
            //res.setHeader('Content-Security-Policy', "default-src 'self'; worker-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval';")
            return res.end(content)
          }
          
          if (url === '/mockServiceWorker.js') {
            const mswPath = resolve(__dirname, 'node_modules/msw/lib/mockServiceWorker.js')
            const content = fs.readFileSync(mswPath, 'utf-8')
            res.setHeader('Content-Type', 'application/javascript')
            return res.end(content)
          }*/
          
          if (url.startsWith('/ruffle/')) {
            const filePath = url.replace('/ruffle/', '')
            const fullPath = resolve(rufflePath, filePath)
            
            if (!fullPath.startsWith(rufflePath)) {
              return next()
            }

            try {
              const content = fs.readFileSync(fullPath)
              if (url.endsWith('.wasm')) {
                res.setHeader('Content-Type', 'application/wasm')
              } else if (url.endsWith('.js')) {
                res.setHeader('Content-Type', 'application/javascript')
                return res.end(processRuffleFile(content, fullPath))
              }
              return res.end(content)
            } catch (e) {
              return next()
            }
          }
          
          next()
        })
      }
    }
  ]
})
