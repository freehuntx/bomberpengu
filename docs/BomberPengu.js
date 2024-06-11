import { joinRoom, selfId } from 'https://cdn.skypack.dev/trystero/nostr'
import { EventEmitter } from "./EventEmitter.js"

function preprocessXML(xmlStr) {
  const regex = /(<\/?)(\d+)([^>]*>)/g;
  return xmlStr.replace(regex, (_match, p1, p2, p3) => p1 + 'tag' + p2 + p3);
}

function postprocessXML(xmlDoc) {
  const serializer = new XMLSerializer();
  return serializer.serializeToString(xmlDoc).replace(
    /(<\/?)tag(\d+)([^>]*>)/g,
    (_match, p1, p2, p3) => {
      return p1 + p2 + p3;
    }
  );
}

class LobbyPlayer {
  id = ""
  name = ""
  wins = 0
  loss = 0
  draw = 0
  state = 0

  constructor(id, name, state=0, wins=0, loss=0, draw=0) {
    this.id = id
    this.name = name
    this.state = state
    this.wins = wins
    this.loss = loss
    this.draw = draw
  }

  get skill() { return `${this.wins}/${this.loss}/${this.draw}` }
}

export class BomberPengu extends EventEmitter {
  _lobbyRoom = null
  _user = null
  _lobbyPlayers = []
  
  constructor() {
    super()
    this.addLobbyPlayer(new LobbyPlayer("", "[Bot] Afk"))
  }

  recv(data) {
    data = data.replace(/\0*$/, '\0')
    this.emit('recv', `${data}\0`)
  }

  addLobbyPlayer(lobbyPlayer) {
    this._lobbyPlayers.push(lobbyPlayer)
    this.recv(`<newPlayer name="${lobbyPlayer.name}" skill="${lobbyPlayer.skill}" state="${lobbyPlayer.state}" />`)
  }

  removeLobbyPlayer(lobbyPlayer) {
    this._lobbyPlayers.splice(this._lobbyPlayers.indexOf(lobbyPlayer), 1)
    this.recv(`<playerLeft name="${lobbyPlayer.name}" />`)
  }

  async onSend(data) {
    const buffer = Array.from(new Uint8Array(data));
    const xml = buffer.map((e) => String.fromCharCode(e)).join('').replace(/\0*$/, '');
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
      const data = Array.from(doc.attributes).reduce((a,e) => Object.assign(a, { [e.name]: e.value }), {})
      this.onSendAuth(data.name, data.version, data.hash)
    }


    /*if (doc.tagName === 'auth') {
      setTimeout(async () => {
        this.recv(
          `<userList><player name="[Bot] Afk" skill="1/2/3" state="0" /></userList>`
        );
        / *this.recv(
          `<userList><player name="asd0" skill="1/2/3" state="0" /><player name="asd1" skill="1/2/3" state="1" /><player name="asd2" skill="1/2/3" state="2" /><player name="asd3" skill="1/2/3" state="3" /><player name="asd4" skill="1/2/3" state="13" /><player name="asd5" skill="1/2/3" state="23" /><player name="asd6" skill="1/2/3" state="5" /></userList>`
        );* /
        / *return;
        this.recv(`<startGame name="asd0" />`);
        this.recv(`<16 s="0.05" />`); // Random seed
        await new Promise((resolve) => setTimeout(resolve, 1000));* /
        / *this.recv(`<17 xp="10" yp="10" x="1" y="1" c="1" />`); // bomb pos & player pos
        this.recv(`<18 xp="10" yp="10" s="1" x="1" y="1" c="1" />`); // Remove powerup
        this.recv(
          `<19 xp="10" yp="10" dx="1" dy="1" t="1" i="1" x="1" y="1" c="1" />` // Kick bomb
        );* /
        //await new Promise((resolve) => setTimeout(resolve, 1000));
        //this.recv(`<14 p="10" f="10" />`); // ping/fps of other user
        //this.recv(`<11 xp="1" yp="1" t="1" x="1" y="1" c="1" />`); // Stop bomb
        //this.recv(`<10 xp="1" yp="1" i="1" x="1" y="1" c="1" />`); // Explode
        //this.recv(`<12 x="100" y="100" c="0000" />`); // xy pos of other user
      }, 1000);

      setTimeout(() => {
        / *this.recv(
          `<playerUpdate name="asd0" skill="3/3/3" state="1" />`
        );* /
      }, 1500);

      setTimeout(() => {
        / *this.recv(
          `<newPlayer name="asd" skill="993/399/399" state="1" />`
        );* /
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
    if (doc.tagName === "challengeAll") {

    }
    if (doc.tagName === "challenge") {
      const name = doc.attributes['name'].value
      if (name === "[Bot] Afk") {
        await this.recv(`<startGame name="${name}" />`)
        await this.recv(`<16 s="${Math.floor(Math.random() * 9999)}" />`, 100)
      }
    }
    if (doc.tagName === 'ping') {
      this.recv('<pong />');
    }
    if (doc.tagName === 'surrender') {
      //this.recv('<endGame winner="peter" />');
      //this.recv('<surrender winner="peter" />');
      //this.recv('<playAgain />');
    }*/
  }

  onSendAuth(name, version, hash) {
    this._user = { id: selfId, name }
    this._lobbyRoom = joinRoom({appId: 'com.freehuntx.bomberpengu'}, 'lobby')

    const [sendJoin, getJoin] = this._lobbyRoom.makeAction('join')

    for (const lobbyPlayer of this._lobbyPlayers) {
      this.recv(`<newPlayer name="${lobbyPlayer.name}" skill="${lobbyPlayer.skill}" state="${lobbyPlayer.state}" />`)
    }

    this.addLobbyPlayer(new LobbyPlayer(selfId, name, 5))

    this._lobbyRoom.onPeerJoin(peerId => {
      console.log('[Lobby] peer joined', peerId)
      sendJoin({ name }, peerId)
    })

    this._lobbyRoom.onPeerLeave(peerId => {
      console.log('[Lobby] peer left', peerId)

      const lobbyPlayer = this._lobbyPlayers.find(e => e.id === peerId)

      if (lobbyPlayer) {
        this.removeLobbyPlayer(lobbyPlayer)
      }
    })

    getJoin((data, peerId) => {
      this.addLobbyPlayer(new LobbyPlayer(peerId, data.name, 2))
    })
  }
}