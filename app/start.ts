import serverless from 'serverless-http'

import { BackendApp } from './BackendApp'

let application
let handler

try {
  application = new BackendApp()
  void application.start()

  handler = serverless(application.getServer)

} catch (e) {
  console.log(e)
  process.exit(1)
}

process.on('uncaughtException', err => {
  console.log('uncaughtException', err)
  process.exit(1)
})

console.log({ server: handler.length, handler })
export { handler }
