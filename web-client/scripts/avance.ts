        let ts;
        let proyecto;
        let fechareporte
        let nresidente;
        let apresidente;
        let amresidente;
        let ncontrol;
        //
        let id_residencia;

        const timeToString = (ts: number) => {
            const monthsArr: String[] = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];

            const d: Date = new Date(ts);

            return `${d.getDate()} de ${monthsArr[d.getMonth()]} del ${d.getFullYear()}`;
        }

        const getAprobado=()=>
        {
            let xhr = new XMLHttpRequest();
            xhr.open('get',`/aprobado`,false);
            xhr.onload=()=>
            {
                let response = JSON.parse(xhr.responseText);
                nresidente=response['n'];
                apresidente=response['ap'];
                amresidente=response['am'];
                
                ncontrol=response['em'].substring(1,9);

                const maininfo = document.getElementById('maininfo');
                let h = document.createElement('p');
                if(amresidente!='null')
                    h.innerText='Se muestra el avance del(la) alumno(a) '+nresidente+' '+apresidente+' '+' '+amresidente+' con número de control '+ ncontrol +' respecto a su residencia profesional.';
                else
                    h.innerText='Se muestra el avance del(la) alumno(a) '+nresidente+' '+apresidente+' '+'  con número de control '+ ncontrol +' respecto a su residencia profesional.';

                let info = document.createElement('p');
                info.innerText = 'Si desea ir a la vista web del documento relacionado al evento de progreso, por favor haga click en el nombre del mismo.';
                let br = document.createElement('br');
                maininfo.appendChild(h);
                maininfo.appendChild(br);
                maininfo.appendChild(info);

                if(response['message']==1)
                {
                    //
                    id_residencia = response['id_residencia']
                    proyecto = response['proyecto'];
                    ts=Number.parseInt(String(response['fecha']));
                    fechareporte = timeToString(ts);
                    let tl = document.getElementById('timelinedef');
                    let contleft = document.createElement('div');
                    contleft.className='container right';
                    let cont = document.createElement('div');
                    cont.className='contentt';
                    let title = document.createElement('h2');
                    title.id = 'linkReportePreliminar';
                    title.innerText='Reporte preliminar enviado para aprobación';
                    title.style.cursor = 'pointer';
                    let inf = document.createElement('p');
                    inf.innerText = 'Proyecto: '+ proyecto + '\nFecha de elaboración: ' + fechareporte;
                    cont.appendChild(title);
                    cont.appendChild(inf);
                    contleft.appendChild(cont);
                    tl.appendChild(contleft);

                    tl = document.getElementById('timelinedef');
                    contleft = document.createElement('div');
                    contleft.className='container left';
                    cont = document.createElement('div');
                    cont.className='contentt';
                    title = document.createElement('h2');
                    title.innerText='Residencia aprobada.';
                    cont.appendChild(title);
                    contleft.appendChild(cont);
                    tl.appendChild(contleft);
                }
                else if (response['message']==0)
                {
                    proyecto = response['proyecto'];
                    ts=Number.parseInt(String(response['fecha']));
                    fechareporte = new Date(ts);
                    let tl = document.getElementById('timelinedef');
                    let contleft = document.createElement('div');
                    contleft.className='container right';
                    let cont = document.createElement('div');
                    cont.className='contentt';
                    let title = document.createElement('h2');
                    title.id = 'linkReportePreliminar';
                    title.style.cursor='pointer';
                    title.innerText='Reporte preliminar enviado para aprobación';
                    let inf = document.createElement('p');
                    inf.innerText = 'Proyecto: '+ proyecto + '\nFecha de elaboración: ' + fechareporte;
                    cont.appendChild(title);
                    cont.appendChild(inf);
                    contleft.appendChild(cont);
                    tl.appendChild(contleft);

                    tl = document.getElementById('timelinedef');
                    contleft = document.createElement('div');
                    contleft.className='container left';
                    cont = document.createElement('div');
                    cont.className='contentt';
                    title = document.createElement('h2');
                    title.innerText='Proyecto pendiente para aprobación.';
                    cont.appendChild(title);
                    contleft.appendChild(cont);
                    tl.appendChild(contleft);
                }
                else if (response['message']==-3)
                {
                    let tl = document.getElementById('timelinedef');
                    let contleft = document.createElement('div');
                    contleft.className='container left';
                    let cont = document.createElement('div');
                    cont.className='contentt';
                    let title = document.createElement('h2');
                    title.innerText='Aún no hay avance para mostrar.';
                    let inf = document.createElement('p');
                    cont.appendChild(title);
                    contleft.appendChild(cont);
                    tl.appendChild(contleft);
                }
            }
            xhr.send();
        }
        getAprobado();

        

        

        const getAsesor=()=>
        {
            let b = new XMLHttpRequest();b.open('get',`/asesor`,false);
            b.onload=()=>
            {
                let response = JSON.parse(b.responseText);
                if(response['message']==1)
                {
                    const na = response['nombre'];
                    const apa = response['paternoasesor'];
                    const ama = response['maternoasesor'];

                    let tl = document.getElementById('timelinedef');
                    let contright = document.createElement('div');
                    contright.className='container right';
                    let cont = document.createElement('div');
                    cont.className='contentt';
                    cont.id='asesorevisores';
                    let title = document.createElement('h2');
                    title.innerText='Asesor y revisores asignados';
                    let inf = document.createElement('p');
                    inf.innerText = 'Asesor interno: '+ na + ' ' + apa + ' ' + ama +'.';
                    cont.appendChild(title);
                    cont.appendChild(inf);
                    contright.appendChild(cont);
                    tl.appendChild(contright);
                }
                
            }
            b.send();
        }
        getAsesor();

        const getRevisores=()=>
        {
            let c = new XMLHttpRequest();c.open('get',`/revisores`,false);
            c.onload=()=>
            {
                let response = JSON.parse(c.responseText);
                if(response['message']==1)
                {
                    const n1 = response['n1'];
                    const ap1 = response['ap1'];
                    const am1 = response['am1'];
                    const n2 = response['n2'];
                    const ap2 = response['ap2'];
                    const am2 = response['am2'];
                    let cont = document.getElementById('asesorevisores');
                    let inf = document.createElement('p');
                    inf.innerText = 'Revisores: '+ n1 + ' ' + ap1 + ' ' + am1 +' y ' + n2 + ' ' + ap2 + ' ' + am2 + '.';
                    cont.appendChild(inf);
                }
                
            }
            c.send();
        }
        getRevisores();
        let routes;
        const getCartaAceptacion = () =>
        {
            let ca = new XMLHttpRequest();
            ca.open('get','/muestra-carta-aceptacion', false);
            ca.onload = () =>
            {
                let response = JSON.parse(ca.responseText);
                if(response['message']==1)
                {
                    routes = response['ruta'];
                    let ts=Number.parseInt(String(response['fecha']));
                    const fecha = timeToString(ts);
                    let tl = document.getElementById('timelinedef');
                    let contright = document.createElement('div');
                    contright.className='container left';
                    let cont = document.createElement('div');
                    cont.className='contentt';
                    let title = document.createElement('h2');
                    title.style.cursor='pointer';
                    title.innerText='Carta de aceptación subida al sistema';
                    title.id = 'linkCartaAceptacion';
                    let inf = document.createElement('p');
                    inf.innerText = 'Fecha: '+ fecha;
                    cont.appendChild(title);
                    cont.appendChild(inf);
                    contright.appendChild(cont);
                    tl.appendChild(contright);
                }
            }
            ca.send();
        };
        getCartaAceptacion();

        const getCal1=()=>
        {
            let d = new XMLHttpRequest();d.open('get',`/cal1`,false);
            d.onload=()=>
            {
                let response = JSON.parse(d.responseText);
                if(response['message']==1)
                {
                    const ee = response['ee'];
                    const oe = response['oe'];
                    const ei = response['ei'];
                    const oi = response['oi'];
                    let totalee=0;
                    let totalei=0;
                    const aee = String(ee).split(',');
                    for(let i=0;i<aee.length;i++)
                    {
                        totalee+=Number.parseInt(aee[i]);
                    }
                    const aei = ei.split(',');
                    for(let i=0;i<aei.length;i++)
                    {
                        totalei+=Number.parseInt(aei[i]);
                    }

                    let tl = document.getElementById('timelinedef');
                    let contright = document.createElement('div');
                    contright.className='container right';
                    let cont = document.createElement('div');
                    cont.className='contentt';
                    let title = document.createElement('h2');
                    title.innerText='Calificaciones parciales (Anexo 29_1)';
                    title.id = 'linkAnexo29_1';
                    let inf = document.createElement('p');
                    inf.innerText = 'Calificación externa: '+ totalee+ '\nCalificación interna: ' + totalei;
                    cont.appendChild(title);
                    cont.appendChild(inf);
                    contright.appendChild(cont);
                    tl.appendChild(contright);
                }
            }
            d.send();
        }
        getCal1();

        const getCal1_2=()=>
        {
            let f = new XMLHttpRequest();f.open('get',`/cal1_2`,false);
            f.onload=()=>
            {
                let response = JSON.parse(f.responseText);
                if(response['message']==1)
                {
                    const ee = response['ee'];
                    const oe = response['oe'];
                    const ei = response['ei'];
                    const oi = response['oi'];
                    let totalee=0;
                    let totalei=0;
                    const aee = String(ee).split(',');
                    for(let i=0;i<aee.length;i++)
                    {
                        totalee+=Number.parseInt(aee[i]);
                    }
                    const aei = ei.split(',');
                    for(let i=0;i<aei.length;i++)
                    {
                        totalei+=Number.parseInt(aei[i]);
                    }

                    let tl = document.getElementById('timelinedef');
                    let contright = document.createElement('div');
                    contright.className='container left';
                    let cont = document.createElement('div');
                    cont.className='contentt';
                    let title = document.createElement('h2');
                    title.id = 'linkAnexo29_2';
                    title.innerText='Calificaciones parciales (Anexo 29_2)';
                    let inf = document.createElement('p');
                    inf.innerText = 'Calificación externa: '+ totalee+ '\nCalificación interna: ' + totalei;
                    cont.appendChild(title);
                    cont.appendChild(inf);
                    contright.appendChild(cont);
                    tl.appendChild(contright);
                }
            }
            f.send();
        }
        getCal1_2();

        const getCal2=()=>
        {
            let e = new XMLHttpRequest();e.open('get',`/cal2`,false);
            e.onload=()=>
            {
                let response = JSON.parse(e.responseText);
                if(response['message']==1)
                {
                    const ee = response['ee'];
                    const oe = response['oe'];
                    const ei = response['ei'];
                    const oi = response['oi'];
                    let totalee=0;
                    let totalei=0;
                    const aee = String(ee).split(',');
                    for(let i=0;i<aee.length;i++)
                    {
                        totalee+=Number.parseInt(aee[i]);
                    }
                    const aei = ei.split(',');
                    for(let i=0;i<aei.length;i++)
                    {
                        totalei+=Number.parseInt(aei[i]);
                    }

                    let tl = document.getElementById('timelinedef');
                    let contright = document.createElement('div');
                    contright.className='container right';
                    let cont = document.createElement('div');
                    cont.className='contentt';
                    let title = document.createElement('h2');
                    title.id = 'linkAnexo30';
                    title.innerText='Calificaciones parciales (Anexo 30)';
                    let inf = document.createElement('p');
                    inf.innerText = 'Calificación externa: '+ totalee+ '\nCalificación interna: ' + totalei;
                    cont.appendChild(title);
                    cont.appendChild(inf);
                    contright.appendChild(cont);
                    tl.appendChild(contright);
                }
            }
            e.send();
        }
        getCal2();

        //------------------------------------------------------
        //const misDocumentosContainer = document.getElementById('misDocumentosContainer');
        const linkReportePreliminar = document.getElementById('linkReportePreliminar');
        const linkAnexo29_1 = document.getElementById('linkAnexo29_1');
        const linkAnexo29_2 = document.getElementById('linkAnexo29_2');
        const linkAnexo30 = document.getElementById('linkAnexo30');
        const linkCarta = document.getElementById('linkCartaAceptacion');
        interface DocumentInfo {
            id: number,
            fecha: string
        }

        class Documents {
            preliminar: DocumentInfo;
            carta_aceptacion: DocumentInfo;
            anexos_29: DocumentInfo[];
            anexos_30: DocumentInfo[];
        
            constructor(
                idRes: number, fechaRes: string, 
                idCartaAceptacion: number, fechaCartaAceptacion: string, 
                anexos_29: string, fechas_a29: string, 
                anexos_30: string, fechas_a30: string
            ) {
                this.preliminar = {id: Number(idRes), fecha: new Date(Number(fechaRes)).toDateString()};
        
                this.carta_aceptacion = {id: idCartaAceptacion, fecha: new Date(Number(fechaCartaAceptacion)).toDateString()}
        
                this.anexos_29 = anexos_29?.split(',').map((id, index) => {
                    let a: DocumentInfo = {id: Number(id), fecha: new Date(Number(fechas_a29.split(',')[index])).toDateString()};
        
                    return a;
                });
                this.anexos_30 = anexos_30?.split(',').map((id, index) => {
                    let a: DocumentInfo = {id: Number(id), fecha: new Date(Number(fechas_a30.split(',')[index])).toDateString()};
                    
                    return a;
                });
            }
        }
        
        const getDocumentos = () => new Promise<Documents>((resolve, reject) => {
            get_Petition('/idDeMiResidencia', idResponse => {
                if (idResponse['code'] <= 0) {
                    reject(idResponse['message']);
                    return;
                }

                const id = idResponse['object'];

                get_Petition(`/documentosDeResidencia?id=${id}`, docResponse => {
                    if (docResponse['code'] <= 0) {
                        reject(docResponse['message']);
                        return;
                    }

                    const docs: Object = docResponse['object'];

                    resolve(new Documents(
                        docs['reporte_preliminar'], docs['fecha_reporte_preliminar'],
                        docs['carta_aceptacion'], docs['fecha_carta_aceptacion'],
                        docs['anexos_29'], docs['fechas_anexos_29'],
                        docs['anexos_30'], docs['fechas_anexos_30']
                    ));
                });
            });
        });

        const get_Petition = (petition: string, callback: (response: JSON) => void) => {
            let xhr = new XMLHttpRequest();
            xhr.open('get', `${petition}`, true);
            
            xhr.onload = () => {
                const response = JSON.parse(xhr.response);
                
                callback(response);
            };
            
            xhr.send();
        }

        const createLinks = () => {

            getDocumentos().then(docs => {

                if (docs.preliminar) {

                    linkReportePreliminar.addEventListener('click',()=>
                    {
                        location.href=`/documentos/reporte-preliminar?id=${docs.preliminar.id}`;
                    });
                    
                }

                if (docs.anexos_29) {
                        if(linkAnexo29_1)
                        {
                            linkAnexo29_1.addEventListener('click',()=>
                            {
                                location.href=`/documentos/anexo-29?id=${docs.anexos_29[0].id}`;
                            });
                        }
                        if(linkAnexo29_2)
                        {
                            linkAnexo29_2.addEventListener('click',()=>
                            {
                                location.href=`/documentos/anexo-29?id=${docs.anexos_29[1].id}`;
                            });
                        }
                }

                if (docs.anexos_30) {
                    if(linkAnexo30)
                    {
                        linkAnexo30.addEventListener('click',()=>
                        {
                            location.href=`/documentos/anexo-30?id=${docs.anexos_30[0].id}`;
                        });
                    }
                        
                }
                if(docs.carta_aceptacion)
                {
                    if(linkCarta)
                        linkCarta.addEventListener('click',()=>
                        {
                            location.href=`siger-cloud/files/`+String(routes);
                        });
                }
                

            }).catch(error => alert(error));

        }

        createLinks();
        //------------------------------------------------------
        