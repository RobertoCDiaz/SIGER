import { Keys } from "./Keys";
import { Response } from "./Response";

const express   = require("express");
const session   = require("express-session");
const bParser   = require("body-parser");
const mysql     = require("mysql");
const AES       = require("aes.js-wrapper");

const server = express();
const port: number = 8080;

/* ================================================================================================

    Database configuration.

================================================================================================ */
const con = mysql.createConnection({
    host: Keys.DB_CONNECTION.host,
    user: Keys.DB_CONNECTION.user,
    password: Keys.DB_CONNECTION.password,

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

enum USER_CLASSES {
    RESIDENTE = 1,
    ADMIN = 2,
    DOCENTE = 3
}

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
                res.send(Response.unknownError(e.toString()));
                return;
            }

            res.send(Response.success(rows[0]));
        }
    );
});

server.get('/residentesNoValidados', (req, res) => {
    if (!req.session.loggedin || req.session.user.class != USER_CLASSES.ADMIN) {
        res.send(Response.authError());
        return;
    }

    con.query(
        `call SP_ResidentesNoValidados();`,
        (e, rows, f) => {
            if (e) {
                res.send(Response.unknownError(e.toString()));
                return;
            }

            res.send(Response.success(rows[0]));
        }
    );
});

server.post('/validarResidente', (req, res) => {
    if (!req.session.loggedin || req.session.user.class != USER_CLASSES.ADMIN) {
        res.send(Response.authError());
        return;
    }

    const emailResidente = req.body.email_residente;
    if (!emailResidente) {
        res.send(Response.notEnoughParams());
        return;
    }

    con.query(
        `call SP_ValidarResidente(?)`,
        emailResidente,
        (e, rows, f) => {
            if (rows[0][0]['output'] != 1) {
                res.send(Response.sqlError(rows[0][0]['message']));
                return;
            }

            res.send(Response.success(undefined, rows[0][0]['message']));
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
        res.send(Response.notEnoughParams());
        return;
    }

    con.query(
        'call SP_RegistroResidente(?, ?, ?, ?, ?, ?, ?, ?, ?);',
        [
            req.body.email, encrypt(req.body.pass), req.body.name, req.body.patSurname,
            (req.body.matSurname || "null"), new Date().getTime().toString(), req.body.career, req.body.cellNumber, 
            req.body.phoneNumber    
        ],
        (e, rows, f) => {

            if (e) {
                console.log(e);
                res.send(Response.unknownError(e.toString()));
                return;
            }

            if (rows[0][0]['output'] != 1) {
                res.send(Response.sqlError(rows[0][0]['message']));
                return;
            }

            res.send(Response.success());
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
    if (req.session.loggedin) {
        res.redirect('/home');
        return;
    }

    res.sendFile("login.html", { root: "../web-client/" }); 
});
    
server.post('/auth', (req,res) =>{
    const email = req.body.email;
    const pass = req.body.pass;
    const userClass = req.body.class;

    if (!email || !pass || !userClass) { // Esto es por si falta algún parámetro. Solo por si acaso.
        res.send(Response.notEnoughParams());
        return
    }

    switch (parseInt(userClass)) {
        case USER_CLASSES.RESIDENTE: {
            con.query('select * from residentes where email = ?',[email],(e,results,fi)=> {
                if (e) {
                    // res.send(e);
                    res.send(Response.unknownError(e.toString()));
                    return;
                }
                
                if (results.length == 0) {
                    // res.send('El correo electrónico ingresado no está registrado.'); 
                    res.send(Response.userError("El correo electrónico ingresado no está registrado."));
                    return;
                }
        
                if (pass != decrypt(results[0]['contrasena'])) {
                    // res.send('La contraseña no es correcta, verifique.');
                    res.send(Response.userError("La contraseña no es correcta, verifique."));
                    return;
                }
        
                req.session.user = {
                    class: USER_CLASSES.RESIDENTE,
                    info: {
                        email: results[0]['email'],
                        nombre: results[0]['nombre'],
                        apellido_paterno: results[0]['apellido_paterno'],
                        apellido_materno: results[0]['apellido_materno']
                    }
                };
        
                req.session.loggedin = true;
        
                res.send(Response.success());
            });  
            break;  
        }     

        case USER_CLASSES.ADMIN: {
            con.query('select * from administradores where email = ?',[email],(e,results,fi)=> {
                if (e) {
                    res.send(Response.unknownError(e.toString()));
                    return;
                }
                
                if (results.length == 0) {
                    res.send(Response.userError("El correo electrónico ingresado no está registrado."));
                    return;
                }
        
                if (pass != decrypt(results[0]['contrasena'])) {
                    res.send(Response.userError("La contraseña no es correcta, verifique."));
                    return;
                }
        
                req.session.user = {
                    class: USER_CLASSES.ADMIN,
                    info: {
                        email: results[0]['email'],
                        nombre: results[0]['nombre'],
                        apellido_paterno: results[0]['apellido_paterno'],
                        apellido_materno: results[0]['apellido_materno']
                    }
                };
        
                req.session.loggedin = true;
        
                res.send(Response.success());
            });  
            break;  
        }
    }

});

server.get('/home',(req,res)=> {
    if(req.session.loggedin){
        if (req.session.user.class == USER_CLASSES.RESIDENTE) {
            res.sendFile("menu-residentes.html", { root: "../web-client/" });
            return
        }

        if (req.session.user.class == USER_CLASSES.ADMIN) {
            res.sendFile("menu-admin.html", { root: "../web-client/" });
            return
        }

        res.sendFile("registro-docentes.html", { root: "../web-client/" });
        return;
    }
    res.redirect('/login');    
});

server.get('/validar-residentes', (req, res) => {
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.ADMIN) {
        // TODO: Agregar pantalla de Acesson No Autorizado.
        res.redirect('/home');
        return;
    }

    res.sendFile('validar-residente.html', { root: '../web-client/' });
});

server.get('/nuevo-proyecto', (req, res) => {
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.RESIDENTE) {
        // TODO: Agregar pantalla de Acesson No Autorizado.
        res.redirect('/home');
        return;
    }

    res.sendFile('reportepreliminar.html', { root: '../web-client/' });
});

server.get('/avance-proyecto', (req, res) => {
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.RESIDENTE) {
        // TODO: Agregar pantalla de Acesson No Autorizado.
        res.redirect('/home');
        return;
    }

    res.sendFile('avance.html', { root: '../web-client/' });
});

server.get('/docs', (req, res) => {
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.RESIDENTE) {
        // TODO: Agregar pantalla de Acesson No Autorizado.
        res.redirect('/home');
        return;
    }

    res.sendFile('documentos.html', { root: '../web-client/' });
});

server.get('/logout', (req, res) => {
    req.session.loggedin = false;

    res.redirect('/');
});

server.get('/nuevo-residente', (req, res) => {
    if (req.session.loggedin) {
        res.redirect('/home');
        return;
    }

    res.sendFile('registro-residentes.html', { root: '../web-client/' })
});
server.get('/nuevo-docente', (req, res) => {
    if (req.session.loggedin) {
        res.redirect('/home');
        return;
    }

    res.sendFile('registro-docentes.html', { root: '../web-client/' })
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