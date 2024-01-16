"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.BackendApp = void 0;
const server_1 = require("./server");
class BackendApp {
    server;
    async bootstrap() {
        const port = process.env.PORT || '5000';
        this.server = new server_1.Server(port);
    }
    async start() {
        await this.bootstrap();
        const server = this.server;
        if (!server) {
            throw new Error('Server not bootstrapped.');
        }
        await server.listen();
    }
    get serverApp() {
        return this.server?.expressApp();
    }
    get httpServer() {
        return this.server?.getHTTPServer();
    }
    async stop() {
        await this.server?.stop();
    }
}
exports.BackendApp = BackendApp;
