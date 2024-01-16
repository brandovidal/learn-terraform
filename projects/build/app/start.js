"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const BackendApp_1 = require("./BackendApp");
try {
    void new BackendApp_1.BackendApp().start().catch(handleError);
}
catch (err) {
    handleError(err);
}
process.on('uncaughtException', err => {
    console.log('uncaughtException', err);
    process.exit(1);
});
process.on('uncaughtException', err => {
    console.log('uncaughtException', err);
    process.exit(1);
});
process.on('SIGINT', async () => {
    process.exit(0);
});
process.on('SIGTERM', async () => {
    process.exit(0);
});
function handleError(error) {
    console.log(error);
    process.exit(1);
}
