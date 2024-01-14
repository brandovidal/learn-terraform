import serverless from 'serverless-http'

import { BackendApp } from './BackendApp'

let application

try {
  application = new BackendApp()
  void application.start()
} catch (e) {
  console.log(e)
  process.exit(1)
}

process.on('uncaughtException', err => {
  console.log('uncaughtException', err)
  process.exit(1)
})

const handler = serverless(application.server.getHTTPServer)
console.log({ handler })
export { handler }
