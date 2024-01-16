"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.handler = void 0;
const serverless_http_1 = __importDefault(require("serverless-http"));
const BackendApp_1 = require("./app/BackendApp");
const handler = async (event, context) => {
    const app = new BackendApp_1.BackendApp();
    await app.bootstrap();
    const expressApp = app.serverApp;
    if (!expressApp) {
        throw new Error('Server not bootstrapped.');
    }
    const promiseHandler = (0, serverless_http_1.default)(expressApp);
    return await promiseHandler(event, context);
};
exports.handler = handler;
