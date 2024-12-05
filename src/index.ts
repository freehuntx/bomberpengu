import { MpRuffle } from "./lib/mp-ruffle";
import { PioClient, PioRoom } from "./lib/pio/client";

const playerName = new URLSearchParams(location.search).get('name') ?? `Player${Math.floor(Math.random() * (99999 - 1000 + 1) + 1000)}`

let pio: PioClient
let lobby: PioRoom

new MpRuffle({
  targetElement: document.body,
  swfUrl: 'game.swf',
  swfParameters: {
    surl: 'penis',
    sport: 4444,
    sound: 1,
    user: playerName,
    hash: '1bf6093ea530924697ca9cebd7bf4abb'
  },
  proxies: [
    {
      host: 'penis',
      port: 4444,
      async onConnect(socket) {
        const disconnect = (reason: string) => {
          if (reason) socket.send(`<errorMsg>${reason}</errorMsg>\0`)
          socket.close()
          throw new Error(reason)
        }

        if (pio || lobby) {
          disconnect('Already connected')
        }

        pio = new PioClient('bomberpengu-b3s34ovekbapmidml5oq')

        try {
          if (!pio) throw new Error('pio not found')
          await pio.connect()
          lobby = await pio.joinRoom('lobby', 'Lobby', { joinData: { name: playerName } })
        } catch (err) {
          console.error(err)
          disconnect('Connecting failed!')
        }

        const motd = new URLSearchParams(location.search).get('motd')
        if (motd) {
          if (motd.split(':').length > 1) {
            const [name, msg] = motd.split(':')
            socket.send(`<msgAll name="${name}" msg="${msg}" />\0`)
          } else {
            socket.send(`<msgAll name="System" msg="${motd}" />\0`)
          }
        }

        lobby.on('xml', (xml: string) => {
          xml = xml.replace(/\0*$/, '\0').replace(/(<[ \t/]*)Tag(\d)/g, '$1$2')
          xml = xml.replace(/\n\0$/g, '\0')

          socket.send(xml)
        })

        lobby.on('left', () => {
          disconnect('Disconnected')
        })
      },
      onDisconnect(_socket) {
      },
      async onMessage(_socket, buffer) {   
        const xml = new TextDecoder().decode(buffer).replace(/\0*$/, '').replace(/(<[ \t/]*)(\d)/g, '$1Tag$2')
        if (/<beat\//.test(xml)) return

        lobby?.sendXml(xml)
      }
    }
  ]
})
