import { Server } from './server'

export class BackendApp {
  server!: Server

  async bootstrap () {
    const port = process.env.PORT || '5000'
    this.server = new Server(port)
  }

  async start () {
    await this.bootstrap()

    const server = this.server

    if (!server) {
      throw new Error('Server not bootstrapped.')
    }

    await server.listen()
  }

  get serverApp () {
    return this.server?.expressApp()
  }

  get httpServer () {
    return this.server?.getHTTPServer()
  }

  async stop () {
    await this.server?.stop()
  }
}
