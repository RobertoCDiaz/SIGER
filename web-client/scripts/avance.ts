let ts;
        let proyecto;
        let fechareporte
        let nresidente;
        let apresidente;
        let amresidente;
        let ncontrol;

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
                maininfo.appendChild(h);

                if(response['message']==1)
                {
                    proyecto = response['proyecto'];
                    ts=Number.parseInt(String(response['fecha']));
                    fechareporte = timeToString(ts);
                    let tl = document.getElementById('timelinedef');
                    let contleft = document.createElement('div');
                    contleft.className='container right';
                    let cont = document.createElement('div');
                    cont.className='contentt';
                    let title = document.createElement('h2');
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
                    contright.className='container left';
                    let cont = document.createElement('div');
                    cont.className='contentt';
                    let title = document.createElement('h2');
                    title.innerText='Calificaciones parciales (Anexo 29)';
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
        