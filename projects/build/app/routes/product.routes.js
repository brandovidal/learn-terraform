"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const http_status_1 = __importDefault(require("http-status"));
let products = [];
function register(router) {
    router.get('/products', (_req, res) => {
        const data = products;
        res.status(http_status_1.default.OK).send({
            statusCode: http_status_1.default.OK,
            success: true,
            message: 'products retrieved successfully',
            data
        });
    });
    router.post('/product', (req, res) => {
        const { name = 'test', price = 0 } = req.body;
        const transaction = {
            id: products.length + 1,
            name,
            price
        };
        products.push(transaction);
        res.status(http_status_1.default.CREATED).send({
            statusCode: http_status_1.default.CREATED,
            success: true,
            message: 'Transaction created successfully',
            data: transaction
        });
    });
}
exports.default = register;
