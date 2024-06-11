import { joinRoom, selfId } from 'https://cdn.skypack.dev/trystero/nostr'

function preprocessXML(xmlStr) {
  // Regular expression to match tags that start with numbers
  const regex = /(<\/?)(\d+)([^>]*>)/g;

  // Replace invalid tags with valid ones (e.g., prefix with a letter)
  const modifiedXML = xmlStr.replace(regex, (match, p1, p2, p3) => {
    return p1 + 'tag' + p2 + p3;
  });

  return modifiedXML;
}

function postprocessXML(xmlDoc) {
  // Serialize the modified XML document back to a string
  const serializer = new XMLSerializer();
  let xmlStr = serializer.serializeToString(xmlDoc);

  // Replace the prefixed tags back to their original form
  xmlStr = xmlStr.replace(
    /(<\/?)tag(\d+)([^>]*>)/g,
    (_match, p1, p2, p3) => {
      return p1 + p2 + p3;
    }
  );

  return xmlStr;
}

const room = joinRoom({appId: 'com.freehuntx.bomberpengu'}, 'default')
const playerName = new URLSearchParams(location.search).get('playerName') ??  `Player${Math.floor(Math.random() * (99999 - 10000 + 1) + 10000)}`

room.onPeerJoin(peer => console.log('peer joined', peer))
// const [sendMove, getMove] = room.makeAction('mouseMove')

window.RufflePlayer = window.RufflePlayer || {};

window.addEventListener('load', (event) => {
  const ruffle = window.RufflePlayer.newest();
  const player = ruffle.createPlayer();
  document.body.appendChild(player);

  player.load({
    url: 'game.swf',
    parameters: {
      surl: 'pengu.test',
      sport: 1234,
      sound: 0,
      user: playerName,
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

  const socket = {
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

      const buffer = Array.from(new Uint8Array(data));
      let xml = buffer.map((e) => String.fromCharCode(e)).join('');
      if (xml[xml.length - 1] === '\0') xml = xml.slice(0, -1);

      const parser = new DOMParser();
      const doc = parser.parseFromString(
        preprocessXML(xml),
        'text/xml'
      ).documentElement;

      //this.recv(`<msgPlayer name="System" msg="Send: ${doc.tagName}" />`);
      //this.recv(`<msgAll name="System" msg="Send: ${doc.tagName}" />`);
      console.log('Send:', doc);

      if (doc.tagName === 'auth') {
        setTimeout(async () => {
          this.recv(
            `<userList><player name="[Bot] Afk" skill="0/0/0" state="1" /></userList>`
          );
          /*this.recv(
            `<userList><player name="asd0" skill="1/2/3" state="0" /><player name="asd1" skill="1/2/3" state="1" /><player name="asd2" skill="1/2/3" state="2" /><player name="asd3" skill="1/2/3" state="3" /><player name="asd4" skill="1/2/3" state="13" /><player name="asd5" skill="1/2/3" state="23" /><player name="asd6" skill="1/2/3" state="5" /></userList>`
          );*/
          /*return;
          this.recv(`<startGame name="asd0" />`);
          this.recv(`<16 s="0.05" />`); // Random seed
          await new Promise((resolve) => setTimeout(resolve, 1000));*/
          /*this.recv(`<17 xp="10" yp="10" x="1" y="1" c="1" />`); // bomb pos & player pos
          this.recv(`<18 xp="10" yp="10" s="1" x="1" y="1" c="1" />`); // Remove powerup
          this.recv(
            `<19 xp="10" yp="10" dx="1" dy="1" t="1" i="1" x="1" y="1" c="1" />` // Kick bomb
          );*/
          //await new Promise((resolve) => setTimeout(resolve, 1000));
          //this.recv(`<14 p="10" f="10" />`); // ping/fps of other user
          //this.recv(`<11 xp="1" yp="1" t="1" x="1" y="1" c="1" />`); // Stop bomb
          //this.recv(`<10 xp="1" yp="1" i="1" x="1" y="1" c="1" />`); // Explode
          //this.recv(`<12 x="100" y="100" c="0000" />`); // xy pos of other user
        }, 1000);

        setTimeout(() => {
          /*this.recv(
            `<playerUpdate name="asd0" skill="3/3/3" state="1" />`
          );*/
        }, 1500);

        setTimeout(() => {
          /*this.recv(
            `<newPlayer name="asd" skill="993/399/399" state="1" />`
          );*/
        }, 2000);

        setTimeout(() => {
          //this.recv(`<request name="asd" />`);
        }, 2100);

        setTimeout(() => {
          //this.recv(`<remRequest name="asd" />`);
        }, 2500);

        setTimeout(() => {
          //this.recv(`<startGame name="asd" />`);
        }, 2800);
      }
      if (doc.tagName === 'ping') {
        this.recv('<pong />');
      }
      if (doc.tagName === 'surrender') {
        //this.recv('<endGame winner="peter" />');
        //this.recv('<surrender winner="peter" />');
        //this.recv('<playAgain />');
      }
    },
    recv(data) {
      if (data[data.length - 1] !== '\0') data += '\0';
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
    set binaryType(type) {},
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

  return socket;
};