"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.Server = void 0;
const express_1 = __importStar(require("express"));
const cors_1 = __importDefault(require("cors"));
const morgan_1 = __importDefault(require("morgan"));
const routes_1 = require("./routes");
const http_status_1 = __importDefault(require("http-status"));
class Server {
    express;
    port;
    httpServer;
    constructor(port) {
        this.port = port;
        this.express = (0, express_1.default)();
        this.express.use((0, express_1.json)());
        this.express.use((0, express_1.urlencoded)({ extended: true, limit: '10kb' }));
        this.express.use((0, cors_1.default)({ origin: '*', optionsSuccessStatus: http_status_1.default.OK }));
        this.express.use((0, morgan_1.default)('combined'));
        this.express.use(express_1.default.static('public'));
        const router = (0, express_1.Router)();
        this.express.use('/v1', router);
        void (0, routes_1.registerRoutes)(router);
        this.express.use('/', (req, res) => {
            console.error(` Route ${req.url} not found \n`);
            res.status(http_status_1.default.NOT_FOUND).send({
                success: false,
                message: 'Not found'
            });
        });
    }
    async listen() {
        return await new Promise(resolve => {
            this.httpServer = this.express.listen(this.port, () => {
                console.log(`  Node Backend App is running at http://localhost:${this.port} in ${this.express.get('env')} mode`);
                console.log('  Press CTRL-C to stop\n');
                resolve();
            });
        });
    }
    expressApp() {
        return this.express;
    }
    getHTTPServer() {
        return this.httpServer;
    }
    async stop() {
        await new Promise((resolve, reject) => {
            if (this.httpServer !== null && this.httpServer !== undefined) {
                this.httpServer.close(error => {
                    if (error !== null) {
                        reject(error);
                    }
                });
            }
            resolve(1);
        });
    }
}
exports.Server = Server;
