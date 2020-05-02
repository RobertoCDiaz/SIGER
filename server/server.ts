import { Keys } from "./Keys";
import { Response } from "./Response";
import { Mailer, Mail } from "./Mailer";

const express   = require("express");
const session   = require("express-session");
const bParser   = require("body-parser");
const mysql     = require("mysql");
const AES       = require("aes.js-wrapper");

const server = express();
const port: number = 8080;
const website: string = `http://localhost:${port}`;

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
        return;
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
        case USER_CLASSES.DOCENTE:
        {
            con.query('select * from docentes where email = ?',[email],
            (e,results,fi)=>
            {
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
                    class: USER_CLASSES.DOCENTE,
                    info: {
                        email: results[0]['email'],
                        nombre: results[0]['nombre'],
                        apellido_paterno: results[0]['apellido_paterno'],
                        apellido_materno: results[0]['apellido_materno'],
                        residente:''
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

        res.sendFile("menu-docentes.html", { root: "../web-client/" });
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
        res.redirect('/home');
        return;
    }

    getResidentState(req.session.user.info.email).then(state => {
        if (state != 1) {
            res.redirect('/home');
            return;
        }

        res.sendFile('reportepreliminar.html', { root: '../web-client/' });
    }).catch(error => {
        res.redirect('/home');
    });
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
    let idres=0;
    const entradas = JSON.parse(req.body.entradas);
    const salidas = JSON.parse(req.body.salidas);
    const counter = req.body.counter;

    con.query('call SP_RegistroResidencia(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);',
    [
        nombre_proyecto,objetivo,justificacion,periodo,ano,actividades,
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
                (error, numeroHorario) => { // onError
                    con.query('delete from residencias where idresidencias = ?;', idres);
                    res.send(Response.unknownError(error.toString()));
                }
            );
        }
    );
});

/**
 * Función recursiva que asocia un conjunto de horarios a una residencia.
 * 
 * @param idResidencia ID de la residencia a la cual asociar horarios.
 * @param entradas Arreglo de horas de entrada. La correspondencia entre horas de entrada - salida será "entradas[i] - salidas[i]".
 * @param salidas Arreglo de horas de salida. La correspondencia entre horas de entrada - salida será "entradas[i] - salidas[i]".
 * @param horarios Número de horarios a restantes por insertar. Al llamarse por primera vez, deberá ser [entradas.length] o [salidas.length], de ahí, en cada llamada recursiva irá disminuyendo en 1.
 * @param onDone Qué hacer cuando todo termine y haya sido exitoso.
 * @param onError Qué hacer si ocurre un error en alguna inserción, siendo [error] el mensaje de error, y [númeroHorario] el número del índice de horario en el cual ocurrió el error.
 */
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

            if (rows[0].length == 0) {
                res.send(Response.userError('No hay ninguna residencia disponible'))
            }

            res.send(Response.success(rows[0]));
        }
    );
});


server.get('/avance-proyecto', (req, res) => {
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.RESIDENTE) {
        res.redirect('/home');
        return;
    }

    getResidentState(req.session.user.info.email).then(state => {
        if (state != 2) {
            res.redirect('/home');
            return;
        }

        res.sendFile('avance.html', { root: '../web-client/' });
    }).catch(error => {
        res.redirect('/home');
    });
});

server.get('/aprobado',(req,res)=>
{
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.RESIDENTE) {
        res.redirect('/home');
        return;
    }
    con.query('call SP_MostrarAprobado(?);',
    [
        req.session.user.info.email
    ],
    (er,rows,fields)=>
        {
            if(er)
            {
                console.log(er);
                return;
            }
            try
            {
                if(rows[0][0]['aprobado']==0)
                {
                    const message = 0;
                    const a = String(rows[0][0]['aprobado']);
                    const p = String(rows[0][0]['proyecto']);
                    const n = String(req.session.user.info.nombre);
                    const ap = String(req.session.user.info.apellido_paterno);
                    const am = String(req.session.user.info.apellido_materno);
                    const em = String(req.session.user.info.email);
                    const fecha = String(rows[0][0]['fecha']);

                    res.json({message:message,proyecto:p,n:n,ap:ap,am:am,em:em,fecha:fecha});
                }
                const message = 1;
                const a = String(rows[0][0]['aprobado']);
                const p = String(rows[0][0]['proyecto']);
                const n = String(req.session.user.info.nombre);
                const ap = String(req.session.user.info.apellido_paterno);
                const am = String(req.session.user.info.apellido_materno);
                const em = String(req.session.user.info.email);
                const fecha = String(rows[0][0]['fecha']);

                res.json({message:message,proyecto:p,n:n,ap:ap,am:am,em:em,fecha:fecha});
                }
                catch(e)
                {
                    if(e instanceof TypeError)
                    {
                        const message = -3;
                        const n = String(req.session.user.info.nombre);
                        const ap = String(req.session.user.info.apellido_paterno);
                        const am = String(req.session.user.info.apellido_materno);
                        const em = String(req.session.user.info.email);
                        res.json({message:message,n:n,ap:ap,am:am,em:em});
                    }
                }
        });          
});

server.get('/asesor',(req,res)=>
{
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.RESIDENTE) {
        res.redirect('/home');
        return;
    }
    con.query('call SP_MostrarAsesor(?);',
    [
        req.session.user.info.email
    ],
    (er,rows,fields)=>
    {
        if(er)
        {
            console.log(er);
            return;
        }
        try {
            const message = 1;
            const nasesor = String(rows[0][0]['nombre']);
            const apasesor = String(rows[0][0]['ap']);
            const amasesor = String(rows[0][0]['am']);

            res.json({message:message,nombre:nasesor,paternoasesor:apasesor,maternoasesor:amasesor});
        } catch (e) {
            if(e instanceof TypeError)
            {
                const message = 0;
                res.json({message:message});
            }
        }
    });
});

server.get('/revisores',(req,res)=>
{
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.RESIDENTE) {
        res.redirect('/home');
        return;
    }
    con.query('call SP_MostrarRevisores(?);',
    [
        req.session.user.info.email
    ],
    (er,rows,fields)=>
    {
        if(er)
        {
            console.log(er);
            return;
        }
        try {
            const message = 1;
            const n1 = String(rows[0][0]['nombre']);
            const ap1 = String(rows[0][0]['ap']);
            const am1 = String(rows[0][0]['am']);
            const n2 = String(rows[0][1]['nombre']);
            const ap2 = String(rows[0][1]['ap']);
            const am2 = String(rows[0][1]['am']);

            res.json({message:message,n1:n1,ap1:ap1,am1:am1,n2:n2,ap2:ap2,am2:am2});
        } catch (e) {
            if(e instanceof TypeError)
            {
                const message = 0;
                res.json({message:message});
            }
        }
    });
});

server.get('/cal1',(req,res)=>
{
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.RESIDENTE) {
        res.redirect('/home');
        return;
    }

    con.query('call SP_MostrarAnexo29 (?);',
    [
        req.session.user.info.email
    ],
    (er,rows,fields)=>
    {
        if(er)
        {
            console.log(er);
            return;
        }
        try 
        {
            const message = 1;
            const ee = String(rows[0][0]['ee']);
            const oe = String(rows[0][0]['oe']);
            const ei = String(rows[0][0]['ei']);
            const oi = String(rows[0][0]['oi']);
            res.json({message:message,ee:ee,oe:oe,ei:ei,oi:oi});
        }
        catch (e)
        {
            if(e instanceof TypeError)
            {
                const message = 0;
                res.json({message:message});
            }
        }
    });
});

server.get('/cal2',(req,res)=>
{
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.RESIDENTE) {
        res.redirect('/home');
        return;
    }
    con.query('call SP_MostrarAnexo30 (?);',
    [
        req.session.user.info.email
    ],
    (er,rows,fields)=>
    {
        if(er)
        {
            console.log(er);
            return;
        }
        try 
        {
            const message = 1;
            const ee = String(rows[0][0]['ee']);
            const oe = String(rows[0][0]['oe']);
            const ei = String(rows[0][0]['ei']);
            const oi = String(rows[0][0]['oi']);
            res.json({message:message,ee:ee,oe:oe,ei:ei,oi:oi});
        }
        catch (e)
        {
            if(e instanceof TypeError)
            {
                const message = 0;
                res.json({message:message});
            }
        }
        
    });
});

server.get('/docs', (req, res) => {
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.RESIDENTE) {
        res.redirect('/home');
        return;
    }

    getResidentState(req.session.user.info.email).then(state => {
        if (state <= 0) {
            res.redirect('/home');
            return;
        }

        res.sendFile('documentos.html', { root: '../web-client/' });
    }).catch(error => {
        res.redirect('/home');
    });
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
        res.redirect('/home');
        return;
    }

    if (!req.query.id) {
        res.redirect('/panel-residencias');
        return;
    }

    res.sendFile('residencia.html', { root: '../web-client/' });
});

server.get('/activar-evaluacion', (req, res) => {
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.ADMIN) {
        res.redirect('/home');
        return;
    }

    res.sendFile('activar-evaluacion.html', { root: '../web-client/' });
});


/**
 * Dado un id de residencia [id], regresa al cliente la información
 * necesaria para llenar el formato de reporte preliminar, siempre 
 * y cuando el adminsitrador esté a cargo de la carrera del residente.
 */
server.get('/getInformacionReportePreliminar', (req, res) => {
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

            if (rows[0].length == 0) {
                res.send(Response.userError('No se ha encontrado ningún docente con este criterio de búsqueda'));
                return;
            }

            res.send(Response.success(rows[0]));
        }
    );
});


/**
 * Asigna al proyecto con id [resId] los docentes de la siguiente
 * manera:
 *      Docente con id [ai] -> Asesor Interno.
 *      Docente con id [r1] -> Revisor 1.
 *      Docente con id [r2] -> Revisor 2.
 */
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

server.get('/mis-residentes',(req,res)=>
{
    if (!req.session.loggedin || req.session.user.class != USER_CLASSES.DOCENTE) {
        res.send(Response.authError());
        return;
    }
    res.sendFile('residentesasesorados.html', { root: '../web-client/' });

});


server.get('/asesorados',(req,res)=>
{
    if (!req.session.loggedin || req.session.user.class != USER_CLASSES.DOCENTE) {
        res.send(Response.authError());
        return;
    }
    con.query('call SP_MostrarAsesorados(?);',
    [
        req.session.user.info.email
    ],
    (e,rows,f)=>
    {
        if(e)
        {
            console.log(e);
            return;
        }
        try
        {
            let residentes=[{}];
            residentes.pop();
            for(let i = 0; i < rows[0].length; i++)
            {
                residentes.push(rows[0][i]);
            }
            residentes.push({length:rows[0].length});
            res.json(residentes);
        }
        catch(e)
        {
            if(e instanceof TypeError)
            {
                const message = 0;
                res.json({message:message});
            }
        }
    });
});

server.get('/avancedemiresidente',(req,res)=>
{
    if (!req.session.loggedin || req.session.user.class != USER_CLASSES.DOCENTE) {
        res.send(Response.authError());
        return;
    }
    req.session.user.info.residente=req.query.email;
    res.sendFile('ravance.html', { root: '../web-client/'});
});

server.get('/asesor-aprobado',(req,res)=>
{
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.DOCENTE) {
        // TODO: Agregar pantalla de Acesso No Autorizado.
        res.redirect('/home');
        return;
    }
    console.log('email del residente: ' + req.session.user.info.residente);
    con.query('call SP_MostrarAprobado(?);',
    [
        req.session.user.info.residente
    ],
    (er,rows,fields)=>
        {
            if(er)
            {
                console.log(er);
                return;
            }
            try
            {
                if(rows[0][0]['aprobado']==0)
                {
                    const message = 0;
                    const a = String(rows[0][0]['aprobado']);
                    const p = String(rows[0][0]['proyecto']);
                    const n = String(rows[0][0]['nombre']);
                    const ap = String(rows[0][0]['ap']);
                    const am = String(rows[0][0]['am']);
                    const em = String(req.session.user.info.residente);
                    const fecha = String(rows[0][0]['fecha']);

                    res.json({message:message,proyecto:p,n:n,ap:ap,am:am,em:em,fecha:fecha});
                }
                const message = 1;
                const a = String(rows[0][0]['aprobado']);
                const p = String(rows[0][0]['proyecto']);
                const n = String(rows[0][0]['nombre']);
                const ap = String(rows[0][0]['ap']);
                const am = String(rows[0][0]['am']);
                const em = String(req.session.user.info.residente);
                const fecha = String(rows[0][0]['fecha']);

                res.json({message:message,proyecto:p,n:n,ap:ap,am:am,em:em,fecha:fecha});
                }
                catch(e)
                {
                    if(e instanceof TypeError)
                    {
                        const message = -3;
                        const n = String(rows[0][0]['nombre']);
                        const ap = String(rows[0][0]['ap']);
                        const am = String(rows[0][0]['am']);
                        const em = String(req.session.user.info.email);
                        res.json({message:message,n:n,ap:ap,am:am,em:em});
                    }
                }
        });          
});

server.get('/asesor-asesor',(req,res)=>
{
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.DOCENTE) {
        // TODO: Agregar pantalla de Acesso No Autorizado.
        res.redirect('/home');
        return;
    }
    con.query('call SP_MostrarAsesor(?);',
    [
        req.session.user.info.residente
    ],
    (er,rows,fields)=>
    {
        if(er)
        {
            console.log(er);
            return;
        }
        try {
            const message = 1;
            const nasesor = String(rows[0][0]['nombre']);
            const apasesor = String(rows[0][0]['ap']);
            const amasesor = String(rows[0][0]['am']);

            res.json({message:message,nombre:nasesor,paternoasesor:apasesor,maternoasesor:amasesor});
        } catch (e) {
            if(e instanceof TypeError)
            {
                const message = 0;
                res.json({message:message});
            }
        }
    });
});

server.get('/asesor-revisores',(req,res)=>
{
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.DOCENTE) {
        // TODO: Agregar pantalla de Acesso No Autorizado.
        res.redirect('/home');
        return;
    }
    con.query('call SP_MostrarRevisores(?);',
    [
        req.session.user.info.residente
    ],
    (er,rows,fields)=>
    {
        if(er)
        {
            console.log(er);
            return;
        }
        try {
            const message = 1;
            const n1 = String(rows[0][0]['nombre']);
            const ap1 = String(rows[0][0]['ap']);
            const am1 = String(rows[0][0]['am']);
            const n2 = String(rows[0][1]['nombre']);
            const ap2 = String(rows[0][1]['ap']);
            const am2 = String(rows[0][1]['am']);

            res.json({message:message,n1:n1,ap1:ap1,am1:am1,n2:n2,ap2:ap2,am2:am2});
        } catch (e) {
            if(e instanceof TypeError)
            {
                const message = 0;
                res.json({message:message});
            }
        }
    });
});

server.get('/asesor-cal1',(req,res)=>
{
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.DOCENTE) {
        // TODO: Agregar pantalla de Acceso No Autorizado.
        res.redirect('/home');
        return;
    }

    con.query('call SP_MostrarAnexo29 (?);',
    [
        req.session.user.info.residente
    ],
    (er,rows,fields)=>
    {
        if(er)
        {
            console.log(er);
            return;
        }
        try 
        {
            const message = 1;
            const ee = String(rows[0][0]['ee']);
            const oe = String(rows[0][0]['oe']);
            const ei = String(rows[0][0]['ei']);
            const oi = String(rows[0][0]['oi']);
            res.json({message:message,ee:ee,oe:oe,ei:ei,oi:oi});
        }
        catch (e)
        {
            if(e instanceof TypeError)
            {
                const message = 0;
                res.json({message:message});
            }
        }
    });
});

server.get('/asesor-cal2',(req,res)=>
{
    if (!req.session.loggedin) {
        res.redirect('/login');
        return;
    }

    if (req.session.user.class != USER_CLASSES.DOCENTE) {
        // TODO: Agregar pantalla de Acceso No Autorizado.
        res.redirect('/home');
        return;
    }
    con.query('call SP_MostrarAnexo30 (?);',
    [
        req.session.user.info.residente
    ],
    (er,rows,fields)=>
    {
        if(er)
        {
            console.log(er);
            return;
        }
        try 
        {
            const message = 1;
            const ee = String(rows[0][0]['ee']);
            const oe = String(rows[0][0]['oe']);
            const ei = String(rows[0][0]['ei']);
            const oi = String(rows[0][0]['oi']);
            res.json({message:message,ee:ee,oe:oe,ei:ei,oi:oi});
        }
        catch (e)
        {
            if(e instanceof TypeError)
            {
                const message = 0;
                res.json({message:message});
            }
        }
        
    });
});


/**
 * Dependiendo del tipo de usuario, regresa un menú
 * personalizado indicando las acciones que puede
 * realizar dentro del sistema. 
 * 
 * Un menú, para funcionar y mostrarse de manera
 * correcta en el sistema, deberá seguir la siguiente estructura:
 * 
 * {
 *      "main": {
 *          "opción1": {            Nombre de la opción. Este será el que se visualice.
 *              "href": ...,        Direccionamiento acorde a la opción, p.e: "/docs"
 *              "icon": ...         Ícono de la opción, de https://material.io/icons
 *          },
 *          "opción2": {...},
 *          ...
 *      },
 *      "secondary": {
 *          "opción3": {...},
 *          "opción4": {...},
 *          ...
 *      }
 * }
 * 
 * Donde [main] son las opciones "principales" que aparecerán en la
 * parte superior de la barra lateral. Las opciones de [secondary]
 * aparecerá en la parte inferior.
 * Para el menú principal en /home, la organización en [main] y 
 * [secondary] serán irrelevantes y aparecerán todas juntas, una después
 * de otra.
 */
server.get('/getMenu', (req, res) => {
    if (!req.session.loggedin) {
        res.send(Response.authError());
        return;
    }

    switch (req.session.user.class) {
        case USER_CLASSES.ADMIN: {
            res.send(Response.success(getAdminMenu()));
            break;
        };

        case USER_CLASSES.DOCENTE: {
            getTeacherMenu(
                req.session.user.info.email,
                (teacherMenu) =>
                    res.send(Response.success(teacherMenu))
            )
            break;
        };

        case USER_CLASSES.RESIDENTE: {
            getResidentMenu(
                req.session.user.info.email,
                (residentMenu) =>
                    res.send(Response.success(residentMenu))
            )
            break;
        };
    }
});


/**
 * Regresa al cliente una lista de materias que cumplan
 * con el criterio [q].
 */
server.get('/buscarMateria', (req, res) => {
    const query = req.query.q;
    if (!query) {
        res.send(Response.userError("Ingrese un criterio de búsqueda"));
        return;
    }

    con.query(
        `call SP_BuscarMateria(?);`,
        query,
        (e, rows, f) => {
            if (e) {
                res.send(Response.unknownError(e.toString()));
                return;
            }

            res.send(Response.success(rows[0]));
        }
    );
});

server.post('/registrarDocente', (req, res) => {
    if (req.session.loggedin) {
        res.send(Response.authError());
        return;
    }

    const email: string = req.body.email;
    const pass: string = req.body.pass;
    const nombre: string = req.body.nombre;
    const apPat: string = req.body.apPat;
    const apMat: string = req.body.apMat;
    const tel: string = req.body.tel;
    const claves: Array<string> = JSON.parse(req.body.clavesArr) ?? [];

    if (!email || !pass || !nombre || !apPat || !tel) {
        res.send(Response.notEnoughParams());
        return;
    }

    const encryptedPass = encrypt(pass);
    const randomUrl = encrypt(new Date().getTime().toString());

    con.query(
        `call SP_RegistrarDocente(?, ?, ?, ?, ?, ?, ?);`,
        [email, encryptedPass, nombre, apPat, apMat ?? "null", tel, randomUrl],
        (e, rows, f) => {
            if (e) {
                res.send(Response.unknownError(e.toString()));
                return;
            }

            if (rows[0][0]['output'] == -1) {
                res.send(Response.sqlError(rows[0][0]['message']));
                return;
            }

            if (rows[0][0]['output'] == 0) {
                res.send(Response.userError(rows[0][0]['message']));
                return;
            }

            if (claves.length > 0) {
                asociarDocenteConMateria(
                    email, 
                    claves, 
                    claves.length,
                    () => {
                        console.log(`El proceso de asociación de materias ha terminado para [${email}]`);
                    },
                    (error, clave) => {
                        console.log(`(${clave}): ${error}`);
                    }
                );
            }
            
            sendEmail(
                email, 
                'Registro como docente', 
                `
                <p>Usted ha recibido este correo porque su dirección de correo electrónico ha sido registrada como docente en el Sistema Gestor de Residencias (SIGER) del Instituto Tecnológico de Piedras Negras.</p>

                <p>Actualmente la cuenta se encuentra inactiva. Podrá iniciar sesión y acceder al sitio web, pero no será capaz de realizar ninguna operación relevante. Para activar su cuenta de usuario, presione siguiente botón.</p>

                <a href="${website}/confirmarDocente?id=${randomUrl}">ACTIVAR CUENTA DE USUARIO</a>

                <p><i>Si usted no se ha registrado en el SIGER, ignore este correo.</i></p>
                `,
                (error, info) => {
                    if (error) {
                        res.send(Response.unknownError(`Ha ocurrido un error, el registro se revertirá. Error: ${error}`));
                        con.query('delete from docentes where email = ?;', email);
                        return;
                    }
                    res.send(Response.success(info, "El registro ha sido un éxito. Busque en su correo electrónico un email de confirmación y siga las instrucciones ahí descritas."));
                }
            );            
        }
    )
});


/**
 * Procedimiento recursivo que define a un docente como competente en un conjunto de asignaturas.
 * 
 * @param email Correo electrónico del docente.
 * @param claves Arreglo con las claves a asociar.
 * @param materiasRestantes Número restante de materias a asociar. En la primer llamada de la rutina tiene que ser [claves.length].
 * @param onDone Qué hacer al terminar de asociar todas las materias.
 * @param ifError Qué hacer si ocurre un error, siendo [error] el mensaje de error y [clave] la clave de la materia donde ocurrió el error. NOTA: Si ocurre un error, el procedimiento no se detendrá y seguirá asociando el resto de materias.
 */
const asociarDocenteConMateria = (
    email: string, claves: Array<string>, materiasRestantes: number, 
    onDone: () => void, ifError: (error: string, clave: string) => void
) => {
    con.query(
        `call SP_AsociarDocenteMateria(?, ?);`,
        [email, claves[materiasRestantes - 1]],
        (e, rows, f) => {
            if (e) {
                ifError(e.toString(), claves[materiasRestantes - 1]);
            }

            if (rows[0][0]['output'] != 1) {
                ifError(rows[0][0]['message'], claves[materiasRestantes - 1]);
            }

            if (materiasRestantes > 1)
                asociarDocenteConMateria(email, claves, materiasRestantes - 1, onDone, ifError);
            else 
                onDone();
        }
    );
}


/**
 * Dirección enviada a los correos electrónicos para confirmación de docentes.
 * Confirma el registro de un docente que tiene el id de confirmación [id].
 */
server.get('/confirmarDocente', (req, res) => {
    const id: string = req.query.id;

    if (!id) {
        res.redirect('/');
    }

    con.query(
        `call SP_ConfirmarDocente(?);`,
        id,
        (e, rows, f) => {
            if (e) {
                res.redirect('/nuevo-docente');
                return;
            }

            if (rows[0][0]['output'] != 1) {
                res.redirect('/');
                return;
            }

            res.redirect('/login');
        }
    )
});


/**
 * Regresa al cliente una lista de todas las residencias aptas para iniciar
 * un periodo de evaluación.
 * 
 * El criterio utilizado para determinar si una residencia es apta o no es que 
 * la residencia debe estar aprobada, NO estar terminada, y NO contar con
 * ninguna evaluación pendiente (Anexo 29 o 30).
 */
server.get('/residenciasAptasParaEvaluacion', (req, res) => {
    if (!req.session.loggedin || req.session.user.class != USER_CLASSES.ADMIN) {
        res.send(Response.authError());
        return;
    }

    const adminEmail = req.session.user.info.email;
    con.query(
        'call SP_ResidenciasDisponiblesEvaluacion(?);',
        adminEmail,
        (e, rows, f) => {
            if (e) {
                res.send(Response.unknownError(e.toString()));
                return;
            }

            if (rows[0].length == 0) {
                res.send(Response.userError('No hay ninguna residencia apta para iniciar una evaluación'));
                return;
            }

            res.send(Response.success(rows[0]));
        }
    );
});


/**
 * Regresa al cliente una lista de las residencia que actualmente están siendo
 * evaluadas.
 * 
 * La información que incluirá cada fila será el ID de la residencia,
 * el nombre del proyecto, nombre completo del residente, anexo pendiente,
 * email y nombre del A.I y A.E, además de si indicar cuál de los asesores 
 * aún está pendiente de evaluación.
 */
server.get('/residenciasEnEvaluacion', (req, res) => {
    if (!req.session.loggedin || req.session.user.class != USER_CLASSES.ADMIN) {
        res.send(Response.authError());
        return;
    }

    const adminEmail = req.session.user.info.email;
    con.query(
        'call SP_ResidenciasEnEvaluacion(?);',
        adminEmail,
        (e, rows, f) => {
            if (e) {
                res.send(Response.unknownError(e.toString()));
                return;
            }

            if (rows[0].length == 0) {
                res.send(Response.userError('Por el momento no hay ninguna residencia en periodo de evaluación'));
                return;
            }

            res.send(Response.success(rows[0]));
        }
    );
});


/**
 * Activa el periodo de evaluación con el anexo 29 para todas las residencias
 * con IDs incluidos en el arreglo [resArr].
 */
server.get('/activarAnexo29', (req, res) => {
    if (!req.session.loggedin || req.session.user.class != USER_CLASSES.ADMIN) {
        res.send(Response.authError());
        return;
    }

    const residences: Object[] = JSON.parse(req.query.resArr);
    if (!residences || residences.length == 0) {
        res.send(Response.notEnoughParams());
        return;
    }

    let errors: string[] = [];
    activarA29Residencias(req.session.user.info.email, residences, residences.length, () => {
        res.send(Response.success(errors));
    }, (errorMsg, idx) => {
        errors.push(`Ha ocurrido un error en la residencia con índice [${idx.toString()}]: "${errorMsg}"`);
    });
});


/**
 * Activa una evaluación con anexo 29 para un conjunto de 
 * residencias.
 * 
 * @param arr       Arreglo de IDs de residencias a activar. 
 * 
 * @param count     Número de residencias a activar. Al principio de la 
 *                  recursión debe ser [arr.length].
 * 
 * @param onDone    Qué hacer cuándo haya terminado el proceso.
 * 
 * @param onError   Qué hacer en caso de error. [msg] será el mensaje de 
 *                  error, y [n] será el número de residencia con error.
 * 
 * NOTA: Si ocurre un error, el proceso no es cancelado. Tal vez una a una 
 * residencia no se le activará su evaluación, pero el procedimiento 
 * intenrtará seguir con las demás.
 */
const activarA29Residencias = (
    adminEmail:string, arr: Object[], count: number, 
    onDone: () => void, 
    onError: (msg: string, n: number) => void
) => {
    const currIdx: number = count - 1;
    const aiID: string = encrypt(new Date().getTime().toString());
    const aeID: string = encrypt((new Date().getTime() + 1000).toString());

    con.query(
        `call SP_ActivarAnexo29(?, ?, ?, ?);`,
        [arr[currIdx], adminEmail, aiID, aeID],
        (e, rows, f) => {
            if (e) {
                onError(e.toString(), currIdx);
            }

            if (rows[0][0]['output'] != 1) {
                onError(rows[0][0]['message'], currIdx);
            }

            const aiEmail: string       = rows[0][0]['ai_email'];
            const aeEmail: string       = rows[0][0]['ae_email'];
            const projectName: string   = rows[0][0]['proyecto'];
            const resident: string      = rows[0][0]['residente'];

            if (currIdx == 0) {
                const template = (url) => `
                    <style>
                    p {
                        text-align: justify;
                    }
                    .signature {
                        text-align: center;
                        margin: 3em;
                    }
                    </style>
                    <p>Hola,</p>
                    <p>Usted ha recibido este correo automático porque es asesor del proyecto ${projectName.toUpperCase()}, del residente ${resident}.</p>
                    <p>Al momento de recibir este email dió inicio el periodo de evaluación del avance del proyecto, por lo que le pedimos que, cuando tenga tiempo, entre al siguiente enlace y califique el progreso de la residencia profesional. Le recordamos que su evaluación es de vital importancia para certificar el avance de la Residencia Profesional, por lo que es fundamental que no ignore este correo electrónico.</p>
                    <p><a href="${website}/${url}">ACCEDER AL FORMULARIO DE EVALUACIÓN</a></p>
                    <p>Sin más que añadir, deseamos que tenga un buen día.</p>
                    <p class="signature">SIGER, ITPN.</p>
                `;

                sendEmail(
                    aiEmail,
                    `Evaluación de Residencia Profesional :: SIGER`,
                    template(`evaluacion-a29-ai?id=${encodeURI(aiID)}`)
                );
                    
                sendEmail(
                    aeEmail,
                    `Evaluación de Residencia Profesional :: SIGER`,
                    template(`evaluacion-a29-ae?id=${encodeURI(aeID)}`)
                );

                onDone();
            } else {
                activarA29Residencias(adminEmail, arr, count - 1, onDone, onError);
            }
        }
    );
}


/**
 * Activa el periodo de evaluación con el anexo 30 para todas las residencias
 * con IDs incluidos en el arreglo [resArr].
 */
server.get('/activarAnexo30', (req, res) => {
    if (!req.session.loggedin || req.session.user.class != USER_CLASSES.ADMIN) {
        res.send(Response.authError());
        return;
    }

    const residences: Object[] = JSON.parse(req.query.resArr);
    if (!residences || residences.length == 0) {
        res.send(Response.notEnoughParams());
        return;
    }

    let errors: string[] = [];
    activarA30Residencias(req.session.user.info.email, residences, residences.length, () => {
        res.send(Response.success(errors));
    }, (errorMsg, idx) => {
        errors.push(`Ha ocurrido un error en la residencia con índice [${idx.toString()}]: "${errorMsg}"`);
    });
});


/**
 * Activa una evaluación con anexo 30 para un conjunto de 
 * residencias.
 * 
 * @param arr       Arreglo de IDs de residencias a activar. 
 * 
 * @param count     Número de residencias a activar. Al principio de la 
 *                  recursión debe ser [arr.length].
 * 
 * @param onDone    Qué hacer cuándo haya terminado el proceso.
 * 
 * @param onError   Qué hacer en caso de error. [msg] será el mensaje de 
 *                  error, y [n] será el número de residencia con error.
 * 
 * NOTA: Si ocurre un error, el proceso no es cancelado. Tal vez una a una 
 * residencia no se le activará su evaluación, pero el procedimiento 
 * intenrtará seguir con las demás.
 */
const activarA30Residencias = (
    adminEmail:string, arr: Object[], count: number, 
    onDone: () => void, 
    onError: (msg: string, n: number) => void
) => {
    const currIdx: number = count - 1;
    const aiID: string = encrypt(new Date().getTime().toString());
    const aeID: string = encrypt((new Date().getTime() + 1000).toString());

    con.query(
        `call SP_ActivarAnexo30(?, ?, ?, ?);`,
        [arr[currIdx], adminEmail, aiID, aeID],
        (e, rows, f) => {
            if (e) {
                onError(e.toString(), currIdx);
            }

            if (rows[0][0]['output'] != 1) {
                onError(rows[0][0]['message'], currIdx);
            }

            const aiEmail: string       = rows[0][0]['ai_email'];
            const aeEmail: string       = rows[0][0]['ae_email'];
            const projectName: string   = rows[0][0]['proyecto'];
            const resident: string      = rows[0][0]['residente'];

            if (currIdx == 0) {
                const template = (url) => `
                    <style>
                    p {
                        text-align: justify;
                    }
                    .signature {
                        text-align: center;
                        margin: 3em;
                    }
                    </style>
                    <p>Hola,</p>
                    <p>Usted ha recibido este correo automático porque es asesor del proyecto ${projectName.toUpperCase()}, del residente ${resident}.</p>
                    <p>Al momento de recibir este email dió inicio el último periodo de evaluación del avance del proyecto, por lo que le pedimos que, cuando tenga tiempo, entre al siguiente enlace y califique el progreso de la residencia profesional. Le recordamos que su evaluación es de vital importancia para finalizar la Residencia Profesional, por lo que es fundamental que no ignore este correo electrónico.</p>
                    <p><a href="${website}/${url}">ACCEDER AL FORMULARIO DE EVALUACIÓN</a></p>
                    <p>Sin más que añadir, deseamos que tenga un buen día.</p>
                    <p class="signature">SIGER, ITPN.</p>
                `;

                sendEmail(
                    aiEmail,
                    `Última evaluación de Residencia Profesional :: SIGER`,
                    template(`evaluacion-a30?id=${encodeURI(aiID)}`)
                );
                    
                sendEmail(
                    aeEmail,
                    `Última evaluación de Residencia Profesional :: SIGER`,
                    template(`evaluacion-a30?id=${encodeURI(aeID)}`)
                );

                onDone();
            } else {
                activarA30Residencias(adminEmail, arr, count - 1, onDone, onError);
            }
        }
    );
}


/**
 * Regresa al cliente la información destacable de una residencia
 * que puede ser mostrada durante la evaluación usando el Anexo 29.
 * 
 * @param id ID único del enlace de evaluación del asesor.
 */
server.get('/infoAnexo29DesdeURL', (req, res) => {
    const id: string = req.query.id;
    if (!id) {
        res.send(Response.notEnoughParams());
        return;
    }

    con.query(
        'call SP_InformacionResidenciaParaAnexo29(?);',
        id,
        (e, rows, f) => {
            if (e) {
                res.send(Response.unknownError(e.toString()));
                return;
            }

            if (rows[0][0]['output'] != 1) {
                res.send(Response.userError(rows[0][0]['message']));
                return;
            }

            if (rows[0].length == 0) {
                res.send(Response.userError('URL inválido. Vuelva a entrar con el mismo enlace. Si el problema persiste, comuníquese con algún administrador del sistema, un desarrollador, o a scepisoftware@gmail.com'));
                return;
            }

            res.send(Response.success(rows[0]));
        }
    );
});


/**
 * Regresa al cliente la información destacable de una residencia
 * que puede ser mostrada durante la evaluación usando el Anexo 30.
 * 
 * @param id ID único del enlace de evaluación del asesor.
 */
server.get('/infoAnexo30DesdeURL', (req, res) => {
    const id: string = req.query.id;
    if (!id) {
        res.send(Response.notEnoughParams());
        return;
    }

    con.query(
        'call SP_InformacionResidenciaParaAnexo30(?);',
        id,
        (e, rows, f) => {
            if (e) {
                res.send(Response.unknownError(e.toString()));
                return;
            }

            if (rows[0][0]['output'] != 1) {
                res.send(Response.userError(rows[0][0]['message']));
                return;
            }

            if (rows[0].length == 0) {
                res.send(Response.userError('URL inválido. Vuelva a entrar con el mismo enlace. Si el problema persiste, comuníquese con algún administrador del sistema, un desarrollador, o a scepisoftware@gmail.com'));
                return;
            }

            res.send(Response.success(rows[0]));
        }
    );
});


/**
 * Registra en la base de datos la evaluación de un 
 * asesor (Ya sea interno o externo) sobre una residencia
 * profesional, usando el anexo 29.
 * 
 * @param id            ID único de la evaluación.
 * 
 * @param evaluacion    Cadena de texto que contiene la evaluacion
 *                      en cada rubro, separadas por coma.
 *                      Por ejemplo, "4,2,6,10,15,4".
 * 
 * @param observaciones Observaciones personales del asesor.
 */
server.post('/registrarEvaluacionA29', (req, res) => {
    const id: string = req.body.id;
    const evaluacionString: string = req.body.evaluacion;
    const observaciones: string = req.body.observaciones;

    if (!id || !evaluacionString || !observaciones) {
        res.send(Response.notEnoughParams());
        return;
    }

    con.query(
        `call SP_EvaluacionA29(?, ?, ?);`,
        [id, evaluacionString, observaciones],
        (e, rows, f) => {
            if (e) {
                res.send(Response.unknownError(e.toString()));
                return;
            }

            if (rows[0][0]['output'] == -1) {
                res.send(Response.sqlError(rows[0][0]['message']));
                return;
            }

            if (rows[0][0]['output'] != 1) {
                res.send(Response.userError(rows[0][0]['message']));
                return;
            }

            res.send(Response.success());
        }
    );
});


/**
 * Registra en la base de datos la evaluación de un 
 * asesor (Ya sea interno o externo) sobre una residencia
 * profesional, usando el anexo 30.
 * 
 * @param id            ID único de la evaluación.
 * 
 * @param evaluacion    Cadena de texto que contiene la evaluacion
 *                      en cada rubro, separadas por coma.
 *                      Por ejemplo, "4,2,6,10,15,4".
 * 
 * @param observaciones Observaciones personales del asesor.
 */
server.post('/registrarEvaluacionA30', (req, res) => {
    const id: string = req.body.id;
    const evaluacionString: string = req.body.evaluacion;
    const observaciones: string = req.body.observaciones;

    if (!id || !evaluacionString || !observaciones) {
        res.send(Response.notEnoughParams());
        return;
    }

    con.query(
        `call SP_EvaluacionA30(?, ?, ?);`,
        [id, evaluacionString, observaciones],
        (e, rows, f) => {
            if (e) {
                res.send(Response.unknownError(e.toString()));
                return;
            }

            if (rows[0][0]['output'] == -1) {
                res.send(Response.sqlError(rows[0][0]['message']));
                return;
            }

            if (rows[0][0]['output'] != 1) {
                res.send(Response.userError(rows[0][0]['message']));
                return;
            }

            res.send(Response.success());
        }
    );
});


/* ================================================================================================

    Endpoints.

================================================================================================ */
/**
 * Direcciones para las evaluaciones correspondientes a un anexo 29.
 * Estas no requieren de autenticación por dos principales motivos:
 *      1. Las personas que entren a este tipo de enlaces, son los únicos
 *         con el ID único para acceder y evaluar.
 *      2. Los asesores externos no tienen una cuenta para autenticar.
 */
// Asesor interno.
server.get('/evaluacion-a29-ai', (req, res) => {
    const id = req.query.id;
    if (!id) {
        res.send(Response.notEnoughParams());
        return;
    }

    res.sendFile('anexo-29-1-ai.html', { root: '../web-client/'});
});

// Asesor externo.
server.get('/evaluacion-a29-ae', (req, res) => {
    const id = req.query.id;
    if (!id) {
        res.send(Response.notEnoughParams());
        return;
    }

    res.sendFile('anexo-29-1-ae.html', { root: '../web-client/'});
});


/**
 * Direcciones para las evaluaciones correspondientes a un anexo 30.
 * Estas no requieren de autenticación por dos principales motivos:
 *      1. Las personas que entren a este tipo de enlaces, son los únicos
 *         con el ID único para acceder y evaluar.
 *      2. Los asesores externos no tienen una cuenta para autenticar.
 */
server.get('/evaluacion-a30', (req, res) => {
    const id = req.query.id;
    if (!id) {
        res.send(Response.notEnoughParams());
        return;
    }

    res.sendFile('anexo30.html', { root: '../web-client/'});
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

const getAdminMenu: () => Object = () => ({
    'main': {
        'Inicio': {
            'href': '/home',
            'icon': 'home'
        },
        'Validar residentes': {
            'href': '/validar-residentes',
            'icon': 'how_to_reg'
        },
        'Panel de residencias': {
            'href': '/panel-residencias',
            'icon': 'ballot'
        },
        'Activar evaluaciones': {
            'href': '/activar-evaluacion',
            'icon': 'assignment_turned_in'
        }
    },
    'secondary': {
        'Cerrar sesión': {
            'href': '/logout',
            'icon': 'exit_to_app'
        }
    }
});

/**
 * Consigue el menú con las opciones específicas del estado de un residente.
 * 
 * @param email Correo electrónico del residente del cual se quiere conocer su menú.
 * @param onDone Qué hacer cuándo un menú sea "calculado".
 */
const getResidentMenu: (residentEmail: string, onDone: (resultMenu :Object) => void) => Object =
    async (email, onDone) => {
        con.query(
            `select estadoResidente(?) as estado;`,
            email,
            (e, rows, f) => {
                let menu: Object = {
                    'main': {
                        'Inicio': {
                            'href': '/home',
                            'icon': 'home'
                        }
                    },
                    'secondary': {
                        'Cerrar sesión': {
                            'href': '/logout',
                            'icon': 'exit_to_app'
                        }
                    }
                };

                const state: number = Number(rows[0]['estado']);

                switch (state) {
                    case 0: menu = {
                        'main': {
                            'Inicio': {
                                'href': '/home',
                                'icon': 'home'
                            }
                        },
                        'secondary': {
                            'Cerrar sesión': {
                                'href': '/logout',
                                'icon': 'exit_to_app'
                            }
                        }
                    }; break;

                    case 1: menu = {
                        'main': {
                            'Inicio': {
                                'href': '/home',
                                'icon': 'home'
                            },
                            'Nuevo proyecto': {
                                'href': '/nuevo-proyecto',
                                'icon': 'note_add'
                            },
                            'Documentos': {
                                'href': '/docs',
                                'icon': 'description'
                            }
                        },
                        'secondary': {
                            'Cerrar sesión': {
                                'href': '/logout',
                                'icon': 'exit_to_app'
                            }
                        }
                    }; break;

                    case 2: menu = {
                        'main': {
                            'Inicio': {
                                'href': '/home',
                                'icon': 'home'
                            },
                            'Progreso actual': {
                                'href': '/avance-proyecto',
                                'icon': 'flag'
                            },
                            'Documentos': {
                                'href': '/docs',
                                'icon': 'description'
                            },
                            'Chat': {
                                'href': '/#',
                                'icon': 'chat'
                            }
                        },
                        'secondary': {
                            'Cerrar sesión': {
                                'href': '/logout',
                                'icon': 'exit_to_app'
                            }
                        }
                    }; break;
                }
                
                onDone(menu);
            }
        );
    };

    
/**
 * Consigue el menú con las opciones específicas del estado de un docente.
 * 
 * @param email Correo electrónico del docente del cual se quiere conocer su menú.
 * @param onDone Qué hacer cuándo un menú sea "calculado".
 */
const getTeacherMenu: (teacherEmail: string, onDone: (resultMenu :Object) => void) => Object =
    async (email, onDone) => {
        con.query(
            `select estadoDocente(?) as estado;`,
            email,
            (e, rows, f) => {
                let menu: Object = {
                    'main': {
                        'Inicio': {
                            'href': '/home',
                            'icon': 'home'
                        }
                    },
                    'secondary': {
                        'Cerrar sesión': {
                            'href': '/logout',
                            'icon': 'exit_to_app'
                        }
                    }
                };

                const state: number = Number(rows[0]['estado']);

                switch (state) {
                    case 0: menu = {
                        'main': {
                            'Inicio': {
                                'href': '/home',
                                'icon': 'home'
                            }
                        },
                        'secondary': {
                            'Cerrar sesión': {
                                'href': '/logout',
                                'icon': 'exit_to_app'
                            }
                        }
                    }; break;

                    case 1: menu = {
                        'main': {
                            'Inicio': {
                                'href': '/home',
                                'icon': 'home'
                            },
                            'Lista de residentes': {
                                'href': '/mis-residentes',
                                'icon': 'menu_open'
                            }
                        },
                        'secondary': {
                            'Cerrar sesión': {
                                'href': '/logout',
                                'icon': 'exit_to_app'
                            }
                        }
                    }; break;

                }
                
                onDone(menu);
            }
        );
    };


/**
 * Consigue de manera asíncrona el estado actual de un residente
 * en el sistema.
 * 
 * Regresa un valor numérico indicando el estado, acorde a
 * los siguientes valores:
 * 
 *      0: Sin confirmar.
 * 
 *      1: Confirmado.
 * 
 *      2: Con residencia aprobada.
 * 
 * @param email Correo electrónico del residente.
 */
const getResidentState: (residentEmail: string) => Promise<number>
    = (email) => new Promise((resolve, reject) => {
        con.query(
            `select estadoResidente(?) as estado;`,
            email,
            (e, rows, f) => {
                if (e) {
                    reject(e.toString());
                    return;
                }

                resolve(rows[0]['estado']);
            }
        )
    });


/**
 * Envía un email usando la cuenta de correo definida en el archivo [Keys.ts].
 * Se usará como plantilla para el contenido el archivo HTML [plantilla_correo.html].
 * 
 * @param to Correo electrónico del destinatario.
 * @param subject Asunto del correo.
 * @param content Contenido del correo electrónico. Puede ser en HTML.
 * @param onDone Qué hacer cuando el proceso haya terminado. Para más información, consultar la estructura de una función callback en https://nodemailer.com/usage/#sending-mail.
 */
const sendEmail: (to: string, subject: string, content: string, onDone?: (error: string, info: string) => void) => void = 
(to, subject, content, onDone) => {
    const mailer: Mailer = new Mailer(Keys.GMAIL_EMAIL, Keys.GMAIL_PASSWORD);
            
    mailer.sendEmail({
        "to": to,
        "from": "SIGER",
        "subject": subject,
        "content": content.trim()
    }, onDone);
}

/* ================================================================================================

    Start server.

================================================================================================ */
server.listen(
    port,
    () => console.log(`SIGER corriendo en el puerto ${port}`)
);