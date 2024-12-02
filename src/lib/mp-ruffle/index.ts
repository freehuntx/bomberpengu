import { WebSocketServer, WebSocketClient } from "../ws-browser-mock"

interface MpRuffleOptions {
  targetElement: HTMLElement
  swfUrl: string
  swfParameters?: Record<string, any>
  ruffle?: Record<string, any>
  proxies?: Array<{
    host: string;
    port: number;
    onConnect?: (socket: WebSocketClient) => void
    onDisconnect?: (socket: WebSocketClient, code?: number, reason?: string) => void
    onMessage?: (socket: WebSocketClient, buffer: ArrayBuffer) => void
  }>
}

export class MpRuffle {
  constructor(options: MpRuffleOptions) {    
    const ruffle = window.RufflePlayer.newest()
    const player = ruffle.createPlayer()
    options.targetElement.appendChild(player)

    const loadOptions: any = {
      autoplay: 'on',
      unmuteOverlay: "hidden",
      preloader: false,
      splashScreen: false,
      logLevel: 'error',
      ...options.ruffle,
      url: options.swfUrl,
      parameters: {
        ...options.ruffle?.parameters,
        ...options.swfParameters
      },
      socketProxy: []
    }

    for (const proxy of options.proxies || []) {
      loadOptions.socketProxy.push({
        host: proxy.host,
        port: proxy.port,
        proxyUrl: `wss://${proxy.host}:${proxy.port}`
      })

      const server = new WebSocketServer({ host: proxy.host, port: proxy.port })

      server.on('connection', (socket: WebSocketClient) => {
        proxy.onConnect?.(socket)

        socket.on('message', (buffer: ArrayBuffer) => {
          proxy.onMessage?.(socket, buffer)
        })

        socket.on('close', (code, reason) => {
          proxy.onDisconnect?.(socket, code, reason)
        })
      })
    }

    console.log(loadOptions)

    player.load(loadOptions)
  }
}