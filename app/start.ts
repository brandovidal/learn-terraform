import { BackendApp } from './BackendApp'

try {
  void new BackendApp().start().catch(handleError)
} catch (err) {
  handleError(err)
}

process.on('uncaughtException', err => {
  console.log('uncaughtException', err)
  process.exit(1)
})

process.on('uncaughtException', err => {
  console.log('uncaughtException', err)
  process.exit(1)
})

process.on('SIGINT', async () => {
  process.exit(0)
})

process.on('SIGTERM', async () => {
  process.exit(0)
})

function handleError (error: any) {
  console.log(error)
  process.exit(1)
}
