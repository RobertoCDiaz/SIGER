const container = document.getElementById('container');

const fillUserEmail = () => {
    const adminEmailView = document.getElementById('adminEmailView');

    let xhr = new XMLHttpRequest();
    xhr.open('get', '/user-info', true);   
    xhr.onload = () => {
        let response = JSON.parse(xhr.response);

        adminEmailView.innerHTML = response.object.email;
    };
    xhr.send();
}

fillUserEmail();

/* ================================================================================================

    Desplegar lista de residencias.

================================================================================================ */
const tsToString = (ts: number) => {
    const monthsArr: String[] = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];

    const d: Date = new Date(ts);

    return `${d.getDate()} de ${monthsArr[d.getMonth()]} del ${d.getFullYear()}`;
}

const residenciaView = (r) => `
<div class="residencia" onclick="abrirResidencia(${r['id']});">
<div class="title">
    <div class="projectNameContainer">
        <p class="projectName">${r['proyecto']}</p>
        <p>${r['empresa']}</p>
    </div>
    
    <div class="period">
        <p>${r['periodo'] == 1 ? 'Enero - Junio' : 'Agosto - Diciembre'}</p>
        <p>${r['ano']}</p>        
    </div>
</div>
<p>${r['carrera']}</p>
<p>${r['residente']}</p>   
<p>${tsToString(Number(r['fecha']))}</p> 
</div>
`

const getList: (string) => Promise<Object> = (query: string) => new Promise((resolve, reject) => {
    let xhr = new XMLHttpRequest();
    xhr.open('get', '/listaResidenciasSinDocentes', true);
    
    xhr.onload = () => {
        let response = JSON.parse(xhr.response);

        if (response.code <= 0) {
            reject(response.message);
            return;
        }

        resolve(response.object);        
    };
    
    xhr.send(`q=${query}`);
});

const populate = (query: string) => {
    getList(query).then(res => {
        for (const o in res) {
            container.innerHTML += residenciaView(res[o]);
        }
    }).catch(err => {
        alert(err);
        window.open('/home', '_self');
    });
}

populate('');

/* ================================================================================================

    Abrir detalles de residencia.

================================================================================================ */
const abrirResidencia = (id: number) => window.open(`/residencia?id=${id}`, '_self');