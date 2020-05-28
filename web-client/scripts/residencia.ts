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

const cleanButton = document.getElementById('cleanButton');
const assignButton = document.getElementById('assignButton');

const goBack = () => {
    window.open('/panel-residencias', '_self');
}

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
    xhr.open('get', `/getInformacionReportePreliminar${location.search ?? ''}`, true);

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
<div class="result" onclick="asignar('${result['email']}', '${result['nombre']}');">
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

/* ================================================================================================

    Asignar docentes.

================================================================================================ */

// "?id=123" -> "123"
const residenciaId: number = Number(location.search.substring(4));

const docentesArr: string[] = [];

const asignar: (email: string, name: string) => void =
    (email: string, name: string) => {
        const identifier: string = `${email},${name}`;

        if (docentesArr.includes(identifier)) {
            alert('Este docente ya ha sido elegido');
            return;
        }

        if (docentesArr.length >= 3) {
            alert('Ya han sido elegidos tres docentes')
            return;
        }

        docentesArr.push(identifier);
        updateUI();
    }

const desasignar: (index: number) => void =
    (idx: number) => {
        docentesArr.splice(idx, 1);

        updateUI();
    }

const updateUI = () => {
    for (const o in docentesArr) {
        const email = docentesArr[o].split(',')[0];
        const name = docentesArr[o].split(',')[1];

        const teacherContainer = document.getElementById(`teacher${o}`);
        teacherContainer.innerHTML = `
        <i class="material-icons" onclick="desasignar(${o});">close</i> ${name} (${email})
        `;
    }

    for (let i = 3; i > docentesArr.length; --i) {
        const teacherContainer = document.getElementById(`teacher${i - 1}`);
        teacherContainer.innerHTML = '-';
    }
}

const asignarDocentesPromise: (aiEmail: string, r1Email: string, r2Email: string) => Promise<Object> =
    (ai, r1, r2) => new Promise((resolve, reject) => {
        let xhr = new XMLHttpRequest();
        xhr.open('post', '/asignar-docentes', true);
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

        xhr.onload = () => {
            let response = JSON.parse(xhr.response);
            if (response.code <= 0) {
                reject(response.message);
                return;
            }

            resolve("Se han asignado los docentes");
        };

        xhr.send(
            `residencia_id=${residenciaId}&` +
            `ai=${ai}&` +
            `r1=${r1}&` +
            `r2=${r2}`
        );
    });

cleanButton.onclick = () => {
    docentesArr.splice(0, docentesArr.length);

    updateUI();
}

assignButton.onclick = () => {
    if (docentesArr.length != 3) {
        alert('Se requieren de exactamente 3 docentes elegidos para poder continuar');
        return;
    }

    asignarDocentesPromise(
        docentesArr[0].split(',')[0],
        docentesArr[1].split(',')[0],
        docentesArr[2].split(',')[0]
    ).then(msg => {
        alert(msg);
        window.open('/panel-residencias', '_self');
    }).catch(error => {
        alert(error);
    })
}

/* ================================================================================================

    Descarga de reporte preliminar.

================================================================================================ */
{const searchJSON = {};
const updateSearchJSON = () => location.search.substring(1).split('&').forEach(pair => {
    searchJSON[decodeURI(pair.split('=')[0])] = decodeURI(pair.split('=')[1]);
})
updateSearchJSON();

const downloadButton: HTMLButtonElement = document.querySelector('#downloadButton');
downloadButton.onclick = () =>
    getDocument(`reporte-preliminar-${searchJSON['id']}.docx`, `/getReportePreliminar?id=${searchJSON['id']}`);}