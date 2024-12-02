import { EventEmitter } from 'events';

export class WebSocketClient extends EventEmitter {
  static CONNECTING: 0 = 0;
  static OPEN: 1 = 1;
  static CLOSING: 2 = 2;
  static CLOSED: 3 = 3;
  CONNECTING: 0 = 0;
  OPEN: 1 = 1;
  CLOSING: 2 = 2;
  CLOSED: 3 = 3;

  readonly bufferedAmount = 0;
  binaryType: 'arraybuffer' | 'blob' = 'arraybuffer';
  protocol = '';
  readyState: number = WebSocketClient.CONNECTING;
  url = '';
  extensions = {};
  isPaused = false;
  _ping = 0
  _events = new EventTarget();

  onopen: ((ev: Event) => any) | null = null;
  onmessage: ((ev: MessageEvent) => any) | null = null;
  onerror: ((ev: Event) => any) | null = null;
  onclose: ((ev: CloseEvent) => any) | null = null;

  constructor(url: string | URL, protocols: string | string[] = []) {
    super();
    this.url = typeof url === 'string' ? url : url.href;
    this.protocol =
      typeof protocols === 'string' ? protocols : protocols.join(',');

    this.on('open', () => {
      this.readyState = WebSocketClient.OPEN;
      const evt = new Event('open');
      this.onopen?.(evt);
      this.dispatchEvent(evt);
    });

    this.on('message', (data) => {
      const evt = new MessageEvent('message', { data });
      this.onmessage?.(evt);
      this.dispatchEvent(evt);
    });

    this.on('close', (code, reason) => {
      this.readyState = WebSocketClient.CLOSED;
      const evt = new CloseEvent('close', { code, reason });
      this.onclose?.(evt);
      this.dispatchEvent(evt);
    });

    this.on('error', (error) => {
      const evt = new ErrorEvent('error', { error });
      this.onerror?.(evt);
      this.dispatchEvent(evt);
    });
  }

  setPing(ping: number) {
    this._ping = ping < 0 ? 0 : ping
  }

  send(data: String | ArrayBuffer | ArrayBufferTypes) {
    if (this.binaryType === "arraybuffer") {
      if (typeof data === "string") {
        data = new TextEncoder().encode(data).buffer
      } else if (ArrayBuffer.isView(data)) {
        data = data.buffer
      }
    }

    setTimeout(() => {
      this.emit('send', data); // Custom send event
    }, this._ping/2);
  }

  pause() {
    if (this.readyState === WebSocketClient.CONNECTING) return;
    if (this.readyState === WebSocketClient.CLOSED) return;
    throw new Error('pause not implemented');
  }

  ping(_data: any, _mask: boolean, _callback: Function) {
    throw new Error('ping not implemented');
  }

  pong(_data: any, _mask: boolean, _callback: Function) {
    throw new Error('pong not implemented');
  }

  resume() {
    if (this.readyState === WebSocketClient.CONNECTING) return;
    if (this.readyState === WebSocketClient.CLOSED) return;
    throw new Error('resume not implemented');
  }

  close(code = 1000, reason = '') {
    if (this.readyState === WebSocketClient.OPEN) {
      this.readyState = WebSocketClient.CLOSING
    }

    if (this.readyState != WebSocketClient.CLOSED) {
      this.readyState = WebSocketClient.CLOSED

      setTimeout(() => {
        this.emit('close', code, reason);
      }, this._ping/2);
    }
  }

  terminate() {
    throw new Error('terminate not implemented');
  }

  addEventListener(type: string, listener: EventListenerOrEventListenerObject) {
    this._events.addEventListener(type, listener);
  }

  removeEventListener(
    type: string,
    listener: EventListenerOrEventListenerObject
  ) {
    this._events.removeEventListener(type, listener);
  }

  dispatchEvent(event: Event): boolean {
    return this._events.dispatchEvent(event);
  }
}
