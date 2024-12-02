declare global {
  interface Window {
    RufflePlayer: {
      config: {
        publicPath?: string;
        polyfills?: boolean;
      };
      newest: () => {
        createPlayer: () => RufflePlayer;
      };
    };
  }

  class RufflePlayer extends HTMLElement {
    load(options: {
      url?: string;
      data?: ArrayBuffer;
      autoplay?: 'on' | 'auto';
      backgroundColor?: string;
      letterbox?: 'on' | 'off' | 'fullscreen';
      unmuteOverlay?: 'visible' | 'hidden';
      preloader?: boolean;
      splashScreen?: boolean;
      upgradeToHttps?: boolean;
      preferredRenderer?: 'auto' | 'webgpu' | 'wgpu' | 'webgl';
      contextMenu?: 'on' | 'off';
      scale?: 'noborder' | 'showAll' | 'exactFit' | 'noBorder';
      salign?: 'none' | 'l' | 'r' | 't' | 'b' | 'tl' | 'tr' | 'bl' | 'br';
      quality?: 'low' | 'medium' | 'high' | 'best';
      forceAlign?: boolean;
      forceScale?: boolean;
      parameters?: Record<string, any>
      logLevel?: 'error' | 'warn' | 'info'
      socketProxy?: Array<{
        host: string
        port: number
        proxyUrl: string
      }>
    }): void;
    destroy(): void;
  }

  interface HTMLElementTagNameMap {
    'ruffle-player': RufflePlayer;
  }
}

export {};


/*declare global {
  interface RufflePlayerComponent extends HTMLElement {
    load: (options: any) => any
  }
  
  interface RufflePlayerInstance {
    createPlayer: () => RufflePlayerComponent
    version: string
  }

  interface RufflePlayerConfig {
    socketProxy?: any[]
  }

  interface RufflePlayer {
    config?: RufflePlayerConfig
    sources: {
      local: RufflePlayerInstance
    }
    newest: () => RufflePlayerInstance
  }

  interface Window {
    RufflePlayer: RufflePlayer
  }
}

export {}
*/