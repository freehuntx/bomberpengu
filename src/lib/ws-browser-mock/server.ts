import { EventEmitter } from 'events';
import { WebSocketClient } from './client'

interface WebSocketServerOptions {
  ping?: number
  host?: string;
  port?: number;
  url?: string;
}

export class WebSocketServer extends EventEmitter {
  _host: string
  _port: number
  _ping: number
  _url?: string

  get ping(): number { return this._ping }

  constructor(options: WebSocketServerOptions = {}) {
    super();
    this._ping = options.ping ?? 0
    this._host = options.host ?? '0.0.0.0'
    this._port = options.port ?? (location.protocol === 'https:' ? 443 : 80)
    this._url = options.url

    this._hookWebSocket();
  }

  address() {
    return {
      family: this._host?.indexOf(':') !== -1 ? 'IPv6' : 'IPv4',
      address: this._host,
      port: this._port,
    };
  }

  _hookWebSocket() {
    const server = this;
    const OriginalWebSocket = window.WebSocket;

    class WebSocketHook extends EventTarget implements WebSocket {
      static CONNECTING: 0 = 0;
      static OPEN: 1 = 1;
      static CLOSING: 2 = 2;
      static CLOSED: 3 = 3;
      CONNECTING: 0 = 0;
      OPEN: 1 = 1;
      CLOSING: 2 = 2;
      CLOSED: 3 = 3;

      _binaryType: BinaryType = 'blob';

      get binaryType() { return this._binaryType }
      set binaryType(binaryType: BinaryType) {
        this._binaryType = binaryType

        if (binaryType === 'arraybuffer') {
          this.wsClient.binaryType = binaryType
        }
      }

      readonly bufferedAmount = 0;
      protocol = '';
      readyState = 0;
      url = '';
      extensions = '';
      wsClient: WebSocketClient = null as unknown as WebSocketClient;

      onopen: ((ev: Event) => any) | null = null;
      onmessage: ((ev: MessageEvent) => any) | null = null;
      onerror: ((ev: Event) => any) | null = null;
      onclose: ((ev: CloseEvent) => any) | null = null;

      constructor(
        url: string | URL,
        protocols: string | string[] | undefined = []
      ) {
        super();

        this.url = typeof url === 'string' ? url : url.href;
        let shouldHook = false;

        if (server._url) {
          shouldHook = new RegExp(server._url.replace(/[|\\{}()[\]^$+*?.]/g, '\\$&')).test(this.url);
        } else {
          const serverAddress = server.address();
          
          shouldHook =
            this.url.indexOf(
              `://${serverAddress.address}:${serverAddress.port}`
            ) !== -1;
        }


        if (!shouldHook) {
          return new OriginalWebSocket(url, protocols) as WebSocketHook;
        }

        this.readyState = WebSocketHook.CONNECTING;
        this.protocol =
          typeof protocols === 'string' ? protocols : protocols.join(',');

        this.wsClient = new WebSocketClient(url, protocols);

        this.wsClient.on('open', () => {
          server.emit('connection', this.wsClient);
        });

        this.wsClient.on('send', (data) => {

          
          const event = new MessageEvent("message", { data })
          this.dispatchEvent(event)
        })

        this.addEventListener('open', (event) => {
          this.onopen?.(event);

          setTimeout(() => {
            this.wsClient.emit('open');
          }, server.ping/2);
        });

        this.addEventListener('message', (event) => {
          this.onmessage?.(event as MessageEvent);
        });

        this.addEventListener('close', (event) => {
          this.onclose?.(event as CloseEvent);

          setTimeout(() => {
            this.wsClient.emit('close'); // TODO: Implement code & reason
          }, server.ping/2);
        });

        this.addEventListener('error', (event) => {
          this.onerror?.(event);

          /*setTimeout(() => {
            this.wsClient.emit('error', event);
          }, 1);*/
        });

        // Simulate WebSocket connection
        setTimeout(() => {
          this.readyState = WebSocketHook.OPEN;
          this.dispatchEvent(new Event('open'));
        }, 100);
      }

      close() {
        if (
          this.readyState === WebSocketHook.CLOSING ||
          this.readyState === WebSocketHook.CLOSED
        ) {
          throw new Error('WebSocket is not open');
        }

        this.readyState = WebSocketHook.CLOSING;
        this.readyState = WebSocketHook.CLOSED;
        this.dispatchEvent(new Event('close'));
      }

      send(data: string | ArrayBufferLike | Blob | ArrayBufferView) {
        if (this.readyState !== WebSocketHook.OPEN) {
          throw new Error('WebSocket is not open');
        }

        if (ArrayBuffer.isView(data)) {
          const buffer = data.buffer.slice(data.byteOffset, data.byteOffset + data.byteLength);
          data = Reflect.construct(data.constructor, [buffer]);
        }
        else if (data instanceof ArrayBuffer) {
          data = data.slice(0)
        }

        if (this.binaryType === "arraybuffer") {
          if (typeof data === "string") {
            data = new TextEncoder().encode(data).buffer
          } else if (ArrayBuffer.isView(data)) {
            data = data.buffer
          }
        }

        setTimeout(() => {
          this.wsClient.emit('message', data);
        }, server.ping/2);
      }
    }

    window.WebSocket = WebSocketHook;
  }
}