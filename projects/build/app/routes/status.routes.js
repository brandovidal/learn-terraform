"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const http_status_1 = __importDefault(require("http-status"));
function register(router) {
    router.get('/status', (_req, res) => {
        // const body = {
        //   success: true,
        //   message: 'Health check retrieved successfully'
        // }
        res.status(http_status_1.default.OK).json({
            status: http_status_1.default.OK,
            message: 'Health check retrieved successfully'
        });
        // return res.status(httpStatus.OK).send({
        //   statusCode: 200,
        //   headers: {
        //     'Access-Control-Allow-Origin': '*'
        //   },
        //   body: JSON.stringify(body, null, 2)
        // })
    });
}
exports.default = register;
