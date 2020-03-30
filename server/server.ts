import { Keys } from "./Keys";

const express   = require("express");
const session   = require("express-session");
const bParser   = require("body-parser");
const mysql     = require("mysql");
const AES       = require("aes.js-wrapper");
const path      = require("path");

const server = express();
const port: number = 8080;

/* ================================================================================================

    Database configuration.

================================================================================================ */
const con = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'Tec_123*',

    database: 'siger',
    multipleStatements: true,
});

/* ================================================================================================

    Server setup.

================================================================================================ */
server.use(express.static("../web-client/"));
server.use(bParser.json());
server.use(bParser.urlencoded({ extended: true }));
server.use(session({
    secret:'secret',
    resave: true,
    saveUninitialized: true
}));

/* ================================================================================================

    Petitions.

================================================================================================ */
/**
 * Regresa al cliente una lista simplificada de las carreras en la base de datos. Esta lista 
 * contendrá únicamente la clave de la carrera, así como el nombre de esta.
 * 
 * Si ocurre algún error, regresará un objeto de error al cliente.
 */
server.get('/listaSimpleDeCarreras', (req, res) => {
    con.query(
        `call SP_MostrarCarreras()`,
        (e, rows, f) => {
            if (e) {
                res.send({errorCode: '-1', errorMessage: e}); 
                return;
            }
            res.send(rows[0]);
        }
    );
});

server.post('/registrarResidente', (req, res) => {
    if (
        !req.body.email ||
        !req.body.pass ||
        !req.body.name ||
        !req.body.patSurname ||
        !req.body.career ||
        !req.body.cellNumber ||
        !req.body.phoneNumber
    ) {
        res.send("0");
        return;
    }

    con.query(
        'call SP_RegistroResidente(?, ?, ?, ?, ?, ?, ?, ?);',
        [
            req.body.email, encrypt(req.body.pass), req.body.name, req.body.patSurname,
            (req.body.matSurname || "null"), req.body.career, req.body.cellNumber, 
            req.body.phoneNumber    
        ],
        (e, rows, f) => {

            if (e) {
                console.log(e);
                res.send(e);
                return;
            }

            res.send(rows[0][0]);
            return;
        }
    );
});

/**
 * Login simple
 * 
 * Si ocurre algún error, regresará un objeto de error al cliente.
 */

server.get('/login', (req, res) => {
    res.sendFile(path.join(__dirname + '/../web-client/login.html')); });
    
server.post('/auth', (req,res) =>{
    const email = req.body.email;
    const pass = req.body.pass;
    let nombre = null;
    if (!email || !pass) { // Esto es por si falta algún parámetro. Solo por si acaso.
        res.send("0");
        return
    }

    con.query('select nombre, contrasena from residentes where email = ?',[email],(e,results,fi)=>
    {
        if (results.length == 0) {
            res.send('El correo electrónico ingresado no está registrado.'); 
            return;
        }

        if (pass != decrypt(results[0]['contrasena'])) {
            res.send('La contraseña no es correcta, verifique.');
            return;
        }

        res.send('Bienvenido(a), '+results[0]['nombre']+'.');
    });

    // if(email && pass){con.query('select * from residentes where email = ? and contrasena = ?',
    //     [email,contra],(e,resp,f)=>{
    //         if(resp.length>0){
    //             console.log(req.session.email)
    //             req.session.loggedin = true;
    //             req.session.email = email;
    //             resp.send(1);
    //             return;
    //         }
    //         else{
    //             resp.send('0');
    //             return;}
    //         resp.send(-1);
    //     });
    // }
    // else{
    //     res.send({errorCode: '0'}); 
    //     res.end();
    // }
});

server.get('/home',(req,res)=>
{
    if(req.session.loggedin)
    {
        res.send('Bienvenido, ' + req.session.email + '.');
    }
    else
    {
        res.send('Inicia sesión para ingresar al sistema.');
    }
    res.end();
});


/* ================================================================================================

    Misc.

================================================================================================ */
/**
 * Escucha la peticón GET de la forma /encrypt?text=[txt]. 
 * 
 * Regresa al cliente el texto [txt] ya encriptado, o un cero si no se 
 * proporcionó el parámetro text a la petición.
 */
server.get('/encrypt', (req, res) => {
    const text: string = req.query.text;

    if (!text) {
        res.send("0");
        return;
    }

    res.send(encrypt(text));
});

// Toma como parámetro un string [txt], y regresa un string conteniendo el parámetro ya encriptado usando la clave secreta de [Keys.ts].
const encrypt = (txt: string) => 
    AES.encrypt(txt, Keys.SECRET_KEY);

// Toma como parámetro un string [txt], que debe ser una cadena de texto encriptada usando la clave de [Keys.ts]. Regresa el texto desencriptado.
const decrypt = (txt: string) => 
    AES.decrypt(txt, Keys.SECRET_KEY);


/* ================================================================================================

    Start server.

================================================================================================ */
server.listen(
    port,
    () => console.log(`SIGER corriendo en el puerto ${port}`)
);