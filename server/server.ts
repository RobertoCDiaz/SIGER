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

/**
 * Regresa al cliente una lista de los residentes sin confirmar de las 
 * carreras que el administrador actual maneja.
 */
server.get('/residentesNoValidados', (req, res) => {
    if (!req.session.loggedin || req.session.user.class != USER_CLASSES.ADMIN) {
        res.send(Response.authError());
        return;
    }

    con.query(
        `call SP_ResidentesNoValidados(?);`,
        req.session.user.info.email,
        (e, rows, f) => {
            if (e) {
                res.send(Response.unknownError(e.toString()));
                return;
            }

            res.send(Response.success(rows[0]));
        }
    );
});


/**
 * Valida la cuenta de residente registrada bajo el correo
 * electrónico que se pase al argumento [email_residente].
 */
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
        `call SP_ValidarResidente(?, ?);`,
        [emailResidente, req.session.user.info.email],
        (e, rows, f) => {
            if (rows[0][0]['output'] != 1) {
                res.send(Response.sqlError(rows[0][0]['message']));
                return;
            }

            res.send(Response.success(undefined, rows[0][0]['message']));
        }
    );

});


/**
 * Con la información proporcionada desde el cliente, esta petición intentará
 * registrar a un nuevo residente en el sistema.
 */
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
    

/**
 * Intenta autenticar una cuenta de usuario del sistema.
 * 
 * Dependiendo del tipo de usuario que intenta logearse (adminstradores, 
 * docentes, o residentes) se ejecutará la lógica apropiada.
 * 
 * En caso de que el login tenga éxito, se registrará la información
 * básica del usuario que podría usarse en el server en [req.session.user].
 * Actualmente, el objeto [req.session.user] tiene esta estructura:
 * 
 * {
 *      'class': Tipo de usuario identificado. Ver enum [USER_CLASSES].
 *      'info': { Información del usuario
 *          'email': Correo electrónico asociado a la cuenta abierta.
 *          'nombre': Nombre almacenado en la base de datos.
 *          'apellido_paterno': Dato almacenado en la base de datos.
 *          'apellido_materno': Dato almacenado en la base de datos.
 *      }
 * }
 */
server.post('/auth', (req,res) =>{
    const email = req.body.email;
    const pass = req.body.pass;
    const userClass = req.body.class;

    if (!email || !pass || !userClass) { 
        res.send(Response.notEnoughParams());
        return
    }

    switch (parseInt(userClass)) {
        case USER_CLASSES.RESIDENTE: {
            con.query('select * from residentes where email = ?',[email],(e,results,fi)=> {
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
            con.query('select * from administradores where email = ?',[email],(e,results,fi) => {
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
        // TODO: Agregar pantalla de Acceso No Autorizado.
        res.redirect('/home');
        return;
    }

    res.sendFile('validar-residente.html', { root: '../web-client/' });
});

server.get('/user-info', (req, res) => {
    if (!req.session.loggedin) {
        res.send(Response.authError("No hay ninguna sesión iniciada"));
        return;
    }

    res.send(Response.success(req.session.user.info));
});

server.get('/nuevo-proyecto', (req, res) => {
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.RESIDENTE) {
        // TODO: Agregar pantalla de Acceso No Autorizado.
        res.redirect('/home');
        return;
    }

    res.sendFile('reportepreliminar.html', { root: '../web-client/' });
});

//Registro de residencia
server.post('/registro-residencia',(req,res)=>
{
    
    if (!req.session.loggedin || req.session.user.class != USER_CLASSES.RESIDENTE) {
        res.send(Response.authError());
        return;
    }

    const nombre_proyecto = req.body.nombre_proyecto;
    const objetivo = req.body.objetivo;
    const justificacion = req.body.justificacion;
    const periodo = req.body.periodo;
    const ano = req.body.ano;
    const actividades = req.body.actividades;
    const fecha_elaboracion = req.body.fecha_elaboracion;
    const empresa = req.body.empresa;
    const representante = req.body.representante;
    const direccion = req.body.direccion;
    const telEmpresa = req.body.telEmpresa;
    const ciudad = req.body.ciudad;
    const emailEmpresa = req.body.emailEmpresa;
    const depto = req.body.depto;
    const nombreAE = req.body.nombreAE;
    const puesto = req.body.puesto;
    const grado = req.body.grado;
    const telAE = req.body.telAE;
    const emailAE = req.body.emailAE;
    const emailResidente = req.session.user.info.email;
    const aprobado = 0;
    let idres=0;
    const entradas = JSON.parse(req.body.entradas);
    const salidas = JSON.parse(req.body.salidas);
    const counter = req.body.counter;

    con.query('call SP_RegistroResidencia(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);',
    [
        nombre_proyecto,objetivo,justificacion,periodo,ano,actividades,aprobado,
        emailResidente,fecha_elaboracion,empresa,representante,direccion,ciudad,
        telEmpresa,emailEmpresa,depto,emailAE,nombreAE,puesto,grado,telAE
    ],
    (e,rows,f)=>
        {
            if(e)
            {
                res.send(Response.unknownError(e.toString()));
                return;
            }
            if(rows[0][0]['output']!=1)
            {
                res.send(Response.sqlError(rows[0][0]['message']));
                return;
            }
            idres=Number(rows[0][0]['idresidencia']);

            // for(let i = 0;i<counter;i++)
            // {
            //     con.query('call SP_RegistraHorarios(?,?,?);',
            //         [
            //             entradas[i],salidas[i],idres
            //         ],
            //     (er,r,fi)=>
            //     {
            //         if(er)
            //         {
            //             res.send(Response.unknownError(er.toString()));
            //             return;
            //         }
            //         if(r[0][0]['output']!=1)
            //         {
            //             res.send(Response.sqlError(r[0][0]['message']));
            //             return;
            //         }
            //     });
            // }
            // res.send(Response.success());

            registrarHorarios(
                idres, entradas, salidas, counter, 
                () => { // onDone
                    res.send(Response.success());
                },
                (error, horarioN) => { // onError
                    res.send(Response.unknownError(error.toString()));
                }
            );
        }
    );
});


/**
 * Regresa al cliente una lista de residencias que aún no han sido confirmadas
 * (No se han asignado docentes como asesores internos o revisores) de las carreras
 * que administra el usuario actual.
 * 
 * Opcionalmente, se puede pasar una consulta en el parámetro [q] que se usará para 
 * buscar residencias basándose en el nombre del proyecto, nombre de la empresa, 
 * nombre del residente, o correo electrónico del residente (y por extensión, su
 * número de control).
 */
server.get('/listaResidenciasSinDocentes', (req, res) => {
    if (!req.session.loggedin || req.session.user.class != USER_CLASSES.ADMIN) {
        res.send(Response.authError());
        return;
    }

    const query = req.query.q ?? '';
    const adminEmail = req.session.user.info.email; 

    con.query(
        `call SP_ListaResidenciasSinDocentes(?, ?);`,
        [adminEmail, query],
        (e, rows, f) => {
            if (e) {
                res.send(Response.unknownError(e.toString()));
                return;
            }

            res.send(Response.success(rows[0]));
        }
    );
});

const registrarHorarios = (
    idResidencia: number, entradas: string[], salidas: string[], 
    horarios: number, onDone: () => void, onError: (error, numeroHorario) => void
) => {
    con.query(
        `call SP_RegistraHorarios(?,?,?);`,
        [entradas[horarios - 1], salidas[horarios - 1], idResidencia],
        (err, rows, f) => {
            
            if (err) {
                onError(err, horarios - 1);
                return;
            }
            if (rows[0][0]['output'] != 1) {
                onError(`SQL Error: ${rows[0][0]['message']}`, horarios - 1);
                return;
            }

            if (horarios - 1 > 0)
                registrarHorarios(idResidencia, entradas, salidas, horarios - 1, onDone, onError);
            else 
                onDone();
        }
    );
}

server.get('/avance-proyecto', (req, res) => {
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.RESIDENTE) {
        // TODO: Agregar pantalla de Acceso No Autorizado.
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
        // TODO: Agregar pantalla de Acceso No Autorizado.
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

server.get('/panel-residencias', (req, res) => {
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.ADMIN) {
        // TODO: Agregar pantalla de Acceso No Autorizado.
        res.redirect('/home');
        return;
    }

    res.sendFile('panel-residencias.html', { root: '../web-client/' });
});

server.get('/residencia', (req, res) => {
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.ADMIN) {
        // TODO: Agregar pantalla de Acceso No Autorizado.
        res.redirect('/home');
        return;
    }

    if (!req.query.id) {
        res.redirect('/panel-residencias');
        return;
    }

    res.sendFile('residencia.html', { root: '../web-client/' });
});


/**
 * Dado un id de residencia [id], regresa al cliente la información
 * necesaria para llenar el formato de reporte preliminar, siempre 
 * y cuando el adminsitrador esté a cargo de la carrera del residente.
 */
server.get('/reporte-preliminar', (req, res) => {
    if (!req.session.loggedin || req.session.user.class != USER_CLASSES.ADMIN) {
        res.send(Response.authError());
        return;
    }

    const idResidencia = req.query.id;
    const adminEmail = req.session.user.info.email;
    if (!idResidencia) {
        res.send(Response.notEnoughParams());
        return;
    }

    con.query(
        'call SP_FormatoPreliminar(?, ?);',
        [idResidencia, adminEmail], 
        (e, rows, f) => {
            if (e) {
                res.send(Response.unknownError(e.toString()));
                return;
            }

            if (rows[0].length == 0) {
                res.send(Response.userError(`No se encontró esta residencia`));
                return;
            }

            res.send(Response.success(rows[0][0]));
        }
    )

});


/**
 * Dado un criterio de búsqueda [q], regresa al cliente una lista
 * de docentes que cumplan con [q] en su correo electrónico o nombre completo.
 */
server.get('/buscarDocente', (req, res) => {
    if (!req.session.loggedin || req.session.user.class != USER_CLASSES.ADMIN) {
        res.send(Response.authError());
        return;
    }

    const query = req.query.q;
    if (!query) {
        res.send(Response.userError("Introduzca un criterio de búsqueda"));
        return;
    }

    con.query(
        'call SP_BuscarDocente(?);',
        query,
        (e, rows, f) => {
            if (e) {
                res.send(Response.unknownError(e.toString()));
                return;
            }

            // console.log(rows);
            if (rows[0].length == 0) {
                res.send(Response.userError('No se ha encontrado ningún docente con este criterio de búsqueda'));
                return;
            }

            res.send(Response.success(rows[0]));
        }
    );
});

server.post('/asignar-docentes', (req, res) => {
    if (!req.session.loggedin || req.session.user.class != USER_CLASSES.ADMIN) {
        res.send(Response.authError());
        return;
    }

    const resId: number = Number(req.body.residencia_id);
    const ai: string    = req.body.ai;
    const r1: string    = req.body.r1;
    const r2: string    = req.body.r2;
    if (!resId || !ai || !r1 || !r2) {
        res.send(Response.notEnoughParams());
        return;
    }

    con.query(
        'call SP_AsignarDocentesAProyecto(?, ?, ?, ?);',
        [resId, ai, r1, r2],
        (e, rows, f) => {
            if (e) {
                res.send(Response.unknownError(e.toString()));
                return;
            }

            if (rows[0][0]['ouput'] == -1) {
                res.send(Response.sqlError(rows[0][0]['message']));
            }

            if (rows[0][0]['ouput'] == 0) {
                res.send(Response.userError(rows[0][0]['message']));
                return;
            }

            res.send(Response.success());
        }
    )
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