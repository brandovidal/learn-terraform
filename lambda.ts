import serverless from 'serverless-http';
import { BackendApp } from './app/BackendApp';

export const handler = async (event: Object, context: Object) => {
  const app = new BackendApp();
  await app.bootstrap()
  const expressApp = app.serverApp;

  if (!expressApp) {
    throw new Error('Server not bootstrapped.');
  }

  const promiseHandler = serverless(expressApp);
  return await promiseHandler(event, context);
};