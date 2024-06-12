import { joinRoom, selfId } from 'https://cdn.skypack.dev/trystero/nostr'

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

const readAttributes = (doc) => {
  return Array.from(doc.attributes).reduce((a,e) => Object.assign(a, { [e.name]: e.value }), {})
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

export class BomberPengu {
  _socket = null
  _lobbyPlayers = []
  _game = null
  _sendMessage = null
  _sendUpdate = null

  get localLobbyPlayer() { return this._lobbyPlayers.find(e => e.id === selfId) }
  
  constructor(socket) {
    this._socket = socket

    this._socket.addEventListener('send', event => {
      const xml = new TextDecoder().decode(event.data).replace(/\0*$/, '')
      this.onSendXml(xml)
    })
  }

  async recvXml(xml, delay=0) {
    await new Promise(resolve => setTimeout(resolve, delay))
    const buffer = new TextEncoder().encode(xml.replace(/\0*$/, '\0')).buffer
    this._socket.recv(buffer)
  }

  addLobbyPlayer(lobbyPlayer) {
    if (this._lobbyPlayers.indexOf(lobbyPlayer) !== -1) return

    this._lobbyPlayers.push(lobbyPlayer)
    const isLocalPlayer = lobbyPlayer === this.localLobbyPlayer
    this.recvXml(`<newPlayer name="${lobbyPlayer.name}" skill="${lobbyPlayer.skill}" state="${isLocalPlayer ? 5 : lobbyPlayer.state}" />`)
  }

  removeLobbyPlayer(lobbyPlayer) {
    const index = this._lobbyPlayers.indexOf(lobbyPlayer)
    if (index === -1) return

    this._lobbyPlayers.splice(index, 1)
    this.recvXml(`<playerLeft name="${lobbyPlayer.name}" />`)
  }

  onSendXml(xml) {
    const parser = new DOMParser();
    const doc = parser.parseFromString(
      preprocessXML(xml),
      'text/xml'
    ).documentElement;

    //this.recv(`<msgPlayer name="System" msg="Send: ${doc.tagName}" />`);
    //this.recv(`<msgAll name="System" msg="Send: ${doc.tagName}" />`);
    console.log('Send:', doc);

    if (doc.tagName === 'auth') {
      const data = readAttributes(doc)
      this.onSendAuth(data.name, data.version, data.hash)
    }
    else if (doc.tagName === 'challenge') {
      const data = readAttributes(doc)
      const lobbyPlayer = this._lobbyPlayers.find(e => e.name === data.name)

      if (!lobbyPlayer) return
      // TODO: Implement challenge logic
    }
    else if (doc.tagName === 'startGame') {
      const data = readAttributes(doc)
      this.onStartGame(data.name)
    }
    else if (doc.tagName === 'playAgain') {
      this.onPlayAgain()
    }
    else if (doc.tagName === 'toRoom') {
      this.onToRoom()
    }
    else if (doc.tagName === 'surrender') {
      // TODO: Implement surrender logic
    }
    else if (doc.tagName === 'msgAll') {
      const data = readAttributes(doc)
      this._sendMessage({ msg: data.msg })
    }
    else if (doc.tagName === 'msgAll' || doc.tagName === 'msgPlayer') {
      const data = readAttributes(doc)
      this._sendMessage({ msg: data.msg })
    }
    else if (doc.tagname === 'ping') {
      this.recvXml('<pong />')
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

  onSendAuth(name, _version, _hash) {
    this._user = { id: selfId, name }
    this._lobbyRoom = joinRoom({appId: 'com.freehuntx.bomberpengu'}, 'lobby')

    const [sendJoin, getJoin] = this._lobbyRoom.makeAction('join')
    const [sendMessage, getMessage] = this._lobbyRoom.makeAction('message')
    const [sendUpdate, getUpdate] = this._lobbyRoom.makeAction('update')
    this._sendMessage = sendMessage
    this._sendUpdate = sendUpdate

    this._lobbyPlayers = []
    this._game = null
    this.addLobbyPlayer(new LobbyPlayer("", "[Bot] Afk", 1))
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
      this.addLobbyPlayer(new LobbyPlayer(peerId, data.name, 0))
    })

    getMessage((data, peerId) => {
      const lobbyPlayer = this._lobbyPlayers.find(e => e.id === peerId)
      if (!lobbyPlayer) return

      if (this._game && this._game.enemy === lobbyPlayer) {
        this.recvXml(`<msgPlayer name="${lobbyPlayer.name}" msg="${data.msg}" />`)
      } else {
        this.recvXml(`<msgAll name="${lobbyPlayer.name}" msg="${data.msg}" />`)
      }
    })

    getUpdate((data, peerId) => {
      const lobbyPlayer = this._lobbyPlayers.find(e => e.id === peerId)
      if (!lobbyPlayer) return

      lobbyPlayer.state = data.state
      this.recvXml(`<playerUpdate name="${lobbyPlayer.name}" skill="${lobbyPlayer.skill}" state="${lobbyPlayer.state}" />`)
    })
  }

  onStartGame(playerName) {
    const lobbyPlayer = this._lobbyPlayers.find(e => e.name === playerName)
    if (!lobbyPlayer) return

    this._game = {
      enemy: lobbyPlayer
    }
    this._sendUpdate({ state: 3 })
  }

  async onPlayAgain() {
    if (!this._game) return
    if (this._game.enemy.id === "") { // If is bot
      await this.recvXml(`<startGame name="${this._game.enemy.name}" />`, 100)
      await this.recvXml(`<16 s="${Math.floor(Math.random() * 9999)}" />`, 100)
    }
  }

  onToRoom() {
    if (!this._game) return
    const { enemy } = this._game
    
    if (enemy.id === "") { // If is bot
      enemy.state = 1
      this.recvXml(`<playerUpdate name="${enemy.name}" skill="${enemy.skill}" state="${enemy.state}" />`, 100)
      this._game = null
    }

    this._sendUpdate({ state: 0 })
  }
}