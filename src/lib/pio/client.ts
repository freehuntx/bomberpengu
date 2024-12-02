import { TypedEventEmitter } from "../typed-events";
import { promisify } from "./helper";

export class PioRoom extends TypedEventEmitter<{
  joined: [],
  left: [],
  event: [name: string, ...args: any[]]
  xml: [xml: string]
}> {
  #pio: PioClient
  #room: any
  #roomId: string
  #roomType: string

  get id() { return this.#roomId }
  get roomType() { return this.#roomType }

  constructor(pio: PioClient, roomId: string, roomType: string) {
    super()
    this.#pio = pio
    this.#roomId = roomId
    this.#roomType = roomType
  }

  async sendEvent(name: string, ...args: any[]) {
    this.#room?.send('event', JSON.stringify([name, ...args]))
  }

  async sendXml(xml: string) {
    this.#room?.send('xml', xml)
  }

  async join(options: any = {}) {
    this.#pio.client.multiplayer.useSecureConnections = location.protocol === 'https:'
    this.#room = await promisify(this.#pio.client.multiplayer.createJoinRoom)(this.#roomId, this.#roomType, false, options.roomData || null, options.joinData || null)
    
    this.#room.addMessageCallback("event", (message: any) => {
      const event: [name: string, ...rest: any[]] = JSON.parse(message.getString(0))
      this.emit('event', ...event)
    })
    
    this.#room.addMessageCallback("xml", (message: any) => {
      this.emit('xml', message.getString(0))
    })

    this.#room.addDisconnectCallback(() => {
      if (!this.#room) return

      this.#room = null
      this.emit('left')
    })

    this.emit('joined')
  }
}

export class PioClient extends TypedEventEmitter<{
  connected: [],
  joinedRoom: [room: PioRoom],
  leftRoom: [room: PioRoom]
}>{
  #gameId: string
  #client: any
  #dev = false
  #joinedRooms = new Map<string, PioRoom>()
  #joiningRooms = new Set<string>()

  get client() { return this.#client }

  constructor(gameId: string, dev=false) {
    super()
    this.#gameId = gameId
    this.#dev = dev
  }

  async connect() {
    if (this.#client) throw new Error('Already connected')
    this.#client = await promisify(window.PlayerIO.authenticate)(this.#gameId, 'public', { userId: 'Guest' }, {})

    if (this.#dev) {
      this.#client.multiplayer.developmentServer = 'localhost:8184'
    }
    
    this.emit('connected')
  }
  
  async joinRoom(roomId: string, roomType: string, options: any = {}): Promise<PioRoom> {
    if (!this.#client) throw new Error('Not connected')
    if (this.#joinedRooms.has(roomId)) throw new Error('Already joined')
    if (this.#joiningRooms.has(roomId)) throw new Error('Already joining')

    const room = new PioRoom(this, roomId, roomType)
    this.#joiningRooms.add(roomId)

    room.on('joined', () => {
      this.#joinedRooms.set(room.id, room)
      this.emit('joinedRoom', room)
    })

    room.on('left', () => {
      this.#joinedRooms.delete(room.id)
      this.emit('leftRoom', room)
    })

    await room.join(options).finally(() => {
      this.#joiningRooms.delete(roomId)
    })

    return room
  }
}
/*
export class PioClient2 extends TypedEventEmitter<{
  connected: [],
  joinedRoom: [room: any]
  leftRoom: [room: any]
  roomEvent: [room: any, name: string, ...args: any[]]
}> {
  client: any
  rooms = new Map<string, any>()

  constructor() {
    super()
  }

  async login(name: string) {
    if (this.client) throw new Error('Already logged in')

      this.client = await new Promise((resolve, reject) => {
        PlayerIO.authenticate("bomberpengu-b3s34ovekbapmidml5oq", "public", { userId: name }, {}, resolve, reject)
      })
			this.client.multiplayer.developmentServer = 'localhost:8184'
      console.log('Login success!')
      this.emit('connected')
  }

  async joinRoom(roomId: string, roomType: string) {
    if (!this.client) throw new Error('Not logged in')
    if (this.rooms.has(roomId)) throw new Error('Already joined room')

    try {
      const room = await new Promise((resolve, reject) => {
        this.client.multiplayer.createJoinRoom(roomId, roomType, false, null, null, resolve, reject)
      })
      this.rooms.set(roomId, room)
      this.emit('joinedRoom', room)

      room.addMessageCallback("*", message => {
        const [name, ...args] = message.getString(0).split(';')
        console.log(name, args)
        this.emit('roomEvent', name, args)
      })

      room.addDisconnectCallback(() => {
        this.rooms.delete(roomId)
        this.emit('leftRoom', room)
      })

      console.log('Room join success!')

      return room
    } catch (err) {
      console.error('Room join failed:', err)
    }

    return null
  }
}
*/