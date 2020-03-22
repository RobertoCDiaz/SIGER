const express   = require("express");
const mysql     = require("mysql");

const server = express();
const port: number = 8080;

server.use(express.static("../web-client/"));

server.listen(
    port,
    () => console.log(`SIGER corriendo en el puerto ${port}`)
);