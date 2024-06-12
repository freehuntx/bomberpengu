import { BomberPengu } from './BomberPengu.js'

window.RufflePlayer = window.RufflePlayer || {};

window.addEventListener('load', (_event) => {
  const ruffle = window.RufflePlayer.newest();
  const player = ruffle.createPlayer();
  document.body.appendChild(player);

  player.load({
    url: 'game.swf',
    parameters: {
      surl: 'pengu.test',
      sport: 1234,
      sound: 0,
      user: new URLSearchParams(location.search).get('playerName') ??  `Player${Math.floor(Math.random() * (99999 - 10000 + 1) + 10000)}`,
      hash: '1bf6093ea530924697ca9cebd7bf4abb',
    },
    autoplay: 'on',
    logLevel: new URLSearchParams(location.search).get('logLevel') ?? 'error',
    socketProxy: [
      {
        host: 'pengu.test',
        port: 1234,
        proxyUrl: 'ws://pengu.test:1234',
      },
    ],
  });
});

window.oWebSocket = window.oWebSocket || window.WebSocket;
window.WebSocket = function (url, protocols) {
  if (!/pengu\.test/.test(url)) {
    return new window.oWebSocket(url, protocols);
  }

  class WebSocketMock {
    static CONNECTING = 0
    static OPEN = 1
    static CLOSING = 2
    static CLOSED = 3
    _events = new EventTarget()
    _closed = false
    onopen = null
    onmessage = null
    onclose = null
    onerror = null

    get readyState() { return this._closed ? WebSocketMock.CLOSED : WebSocketMock.OPEN }
    get bufferedAmount() { return 0 }
    get binaryType() { return 'blob' }
    set binaryType(_type) {}
    get url() { return url }
    get protocol() {
      return protocols
        ? Array.isArray(protocols)
          ? protocols.join(',')
          : protocols
        : '';
    }

    constructor() {
      this.addEventListener('open', event => {
        if (this.onopen) this.onopen(event)
      })
      this.addEventListener('message', event => {
        if (this.onmessage) this.onmessage(event)
      })
      this.addEventListener('close', event => {
        if (this.onclose) this.onclose(event)
      })
      this.addEventListener('error', event => {
        if (this.onerror) this.onerror(event)
      })

      this.open()
    }

    addEventListener(...args) {
      return this._events.addEventListener(...args);
    }

    removeEventListener(...args) {
      return this._events.removeEventListener(...args);
    }

    dispatchEvent(...args) {
      return this._events.dispatchEvent(...args);
    }

    send(data) {
      if (this._closed) {
        throw new Error('WebSocket is closed');
      }

      if (typeof data === "string") data = new TextEncoder().encode(data).buffer

      const event = new Event('send')
      event.data = data
      this.dispatchEvent(event)
    }

    recv(buffer) {
      const event = new Event('message');
      event.data = buffer
      this.dispatchEvent(event);
    }

    close(code, reason) {
      this._closed = true;
      const event = new Event('close');
      event.code = code || 1000;
      event.reason = reason || '';
      this.dispatchEvent(event);
    }

    open() {
      setTimeout(() => {
        const event = new Event('open');
        this.dispatchEvent(event);
      }, 10);
    }
  }

  const socket = new WebSocketMock()
  const bomberPengu = new BomberPengu(socket)

  return socket

  /*const socket = {
    _events: new EventTarget(),
    _closed: false,
    _sentMessages: [],

    addEventListener(...args) {
      return this._events.addEventListener(...args);
    },

    removeEventListener(...args) {
      return this._events.removeEventListener(...args);
    },

    dispatchEvent(...args) {
      return this._events.dispatchEvent(...args);
    },
    send(data) {
      if (this._closed) {
        throw new Error('WebSocket is closed');
      }

      bomberPengu.onSend(data)
    },
    async recv(data, delay=0) {
      if (data[data.length - 1] !== '\0') data += '\0';
      await new Promise(resolve => setTimeout(resolve, delay))
      const event = new Event('message');
      event.data = new Uint8Array(
        data.split('').map((e) => e.charCodeAt(0))
      ).buffer;
      this.dispatchEvent(event);
    },
    close(code, reason) {
      this._closed = true;
      const event = new Event('close');
      event.code = code || 1000;
      event.reason = reason || '';
      this.dispatchEvent(event);
    },
    get readyState() {
      return this._closed ? 3 : 1; // 3 = CLOSED, 1 = OPEN
    },

    get bufferedAmount() {
      return 0;
    },
    get binaryType() {
      return 'blob';
    },
    set binaryType(_type) {},
    get url() {
      return url;
    },
    get protocol() {
      return protocols
        ? Array.isArray(protocols)
          ? protocols.join(',')
          : protocols
        : '';
    },
    open() {
      setTimeout(() => {
        const event = new Event('open');
        this.dispatchEvent(event);
      }, 10);
    },
  };

  // Mimic connection open
  setTimeout(() => {
    socket.open();
  }, 10);

  bomberPengu.on('recv', data => {
    socket.recv(data)
  })

  return socket;*/
};