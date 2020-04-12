const fechaView = document.getElementById('fechaView');
const proyectoView = document.getElementById('proyectoView');
const objView = document.getElementById('objView');
const justView = document.getElementById('justView');
const periodoAnoView = document.getElementById('periodoAnoView');
const actsView = document.getElementById('actsView');

const empresaView = document.getElementById('empresaView');
const repreView = document.getElementById('repreView');
const direccionEView = document.getElementById('direccionEView');
const telefonoEView = document.getElementById('telefonoEView');
const ciudadEView = document.getElementById('ciudadEView');
const emailEView = document.getElementById('emailEView');

const departamentoView = document.getElementById('departamentoView');
const nombreAEView = document.getElementById('nombreAEView');
const puestoAEView = document.getElementById('puestoAEView');
const gradoAEView = document.getElementById('gradoAEView');
const telAEView = document.getElementById('telAEView');
const emailAEView = document.getElementById('emailAEView');

const nombreRView = document.getElementById('nombreRView');
const noControlView = document.getElementById('noControlView');
const carreraView = document.getElementById('carreraView');
const telRView = document.getElementById('telRView');
const celRView = document.getElementById('celRView');
const emailRView = document.getElementById('emailRView');
const horariosRView = document.getElementById('horariosRView');

const searchInput = document.getElementById('searchInput');
const searchButton = document.getElementById('searchButton');
const resultsContainer = document.getElementById('resultsContainer');


/* ================================================================================================

    Llenar reporte preliminar.

================================================================================================ */
const timestampToString = (ts: number) => {
    const monthsArr: String[] = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];

    const d: Date = new Date(ts);

    return `${d.getDate()} de ${monthsArr[d.getMonth()]} del ${d.getFullYear()}`;
}


const getReport: () => Promise<Object> = () => new Promise((resolve, reject) => {
    let xhr = new XMLHttpRequest();
    xhr.open('get', `/reporte-preliminar${location.search ?? ''}`, true);
    
    xhr.onload = () => {
        let response = JSON.parse(xhr.response);
        if (response.code <= 0) {
            reject(response.message);
            return;
        }

        resolve(response.object);
    };
    
    xhr.send();
})

const fillReport = () => {
    getReport().then(r => {

        fechaView.innerHTML = timestampToString(Number(r['fecha']));
        proyectoView.innerHTML = r['proyecto'];
        objView.innerHTML = r['objetivo'];
        justView.innerHTML = r['justificacion'];
        periodoAnoView.innerHTML = `${r['periodo'] == 1 ? 'Enero a Junio' : 'Agosto a Diciembre'} del ${r['ano']}`;
        actsView.innerHTML = r['actividades'];
        empresaView.innerHTML = r['empresa'];
        repreView.innerHTML = r['representante_e'];
        direccionEView.innerHTML = r['direccion_e'];
        telefonoEView.innerHTML = r['telefono_e'];
        ciudadEView.innerHTML = r['ciudad_e'];
        emailEView.innerHTML = r['email_e'];
        departamentoView.innerHTML = r['departamento_e'];
        nombreAEView.innerHTML = r['nombre_ae'];
        puestoAEView.innerHTML = r['puesto_ae'];
        gradoAEView.innerHTML = r['grado_ae'];
        telAEView.innerHTML = r['telefono_ae'];
        emailAEView.innerHTML = r['email_ae'];
        nombreRView.innerHTML = r['nombre_res'];
        noControlView.innerHTML = r['noControl_res'];
        carreraView.innerHTML = r['carrera'];
        telRView.innerHTML = r['tel_casa'];
        celRView.innerHTML = r['celular'];
        emailRView.innerHTML = r['email_res'];
        horariosRView.innerHTML = r['horarios'];

    }).catch(err => {
        alert(err);
        window.open('/panel-residencias', '_self');
    })
}

fillReport();

/* ================================================================================================

    Búsqueda de docentes.

================================================================================================ */
const searchTeachersPromise: (string) => Promise<Object> = 
    (query: string) => new Promise((resolve, reject) => {
        let xhr = new XMLHttpRequest();
        xhr.open('get', `/buscarDocente?q=${query}`, true);
        
        xhr.onload = () => {
            let response = JSON.parse(xhr.response);

            if (response.code <= 0) {
                reject(response.message);
                return;
            }

            resolve(response.object);          
        };
        
        xhr.send();
    });

const resultView = (result) => `
<div class="result">
    <i class="material-icons">person_add</i>
    <p>${result['nombre']} (${result['email']})</p>
</div>
`;

const searchAndPopulate = () => {
    const query: string = searchInput['value'].trim();

    searchTeachersPromise(query).then(list => {
        resultsContainer.innerHTML = '';
        for (const o in list) {
            resultsContainer.innerHTML += resultView(list[o]);
        }
    }).catch(error => {
        resultsContainer.innerHTML = `
            <p style="padding: 1em;">${error}</p>
        `;
    });
}

searchButton.onclick = searchAndPopulate;
searchInput.oninput = searchAndPopulate;