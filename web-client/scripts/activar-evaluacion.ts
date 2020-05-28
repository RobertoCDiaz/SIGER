const residenciasContainerView: HTMLDivElement = document.getElementById('residenciasContainerView') as HTMLDivElement;
const residenciasEvaluacionContainer: HTMLDivElement = document.getElementById('residenciasEvaluacionContainer') as HTMLDivElement;
const anexo29Button: HTMLButtonElement = document.getElementById('anexo29Button') as HTMLButtonElement;
const anexo30Button: HTMLButtonElement = document.getElementById('anexo30Button') as HTMLButtonElement;

/* ================================================================================================

    Enlistar residencias aptas para iniciar evaluación.

================================================================================================ */

// Estructura de objetos resultado de la petición [/residenciasAptasParaEvaluacion].
interface SuitableResidence {
    id: number,
    proyecto: string,
    residente: string,
    empresa: string,
    anexos29: number
}

const fetchSuitableResidences = () => new Promise<SuitableResidence[]>((resolve, reject) => {
    let xhr = new XMLHttpRequest();
    xhr.open('get', '/residenciasAptasParaEvaluacion', true);

    xhr.onload = () => {
        const response = JSON.parse(xhr.response);

        if (response.code != 1) {
            reject(response.message);
            return;
        }

        resolve(response.object.map(o => o as SuitableResidence));
    };

    xhr.send();
});

const suitableResidenceView = (r: SuitableResidence) => `
    <div class="residencia list-row">
        <input type="checkbox" onclick="toggleResidencia(this, ${r.id});">
        <p>${r.proyecto}</p>
        <p>${r.residente}</p>
        <p>${r.empresa}</p>
        <p>${r.anexos29.toString()}</p>
    </div>
`

const fillSuitableResidences = async () => {
    fetchSuitableResidences().then(list => {
        residenciasContainerView.innerHTML = '';
        list.forEach(r => {
            residenciasContainerView.innerHTML += suitableResidenceView(r);
        });
    }).catch(errorMessage => {
        residenciasContainerView.innerHTML = `<p>${errorMessage}</p>`;
    })
}
fillSuitableResidences();

/* ================================================================================================

    Enlistar residencias en evaluación.

================================================================================================ */
interface NotSuitableResidence {
    id: number,
    proyecto: string,
    residente: string,
    empresa: string,
    ae_email: string,
    ae_nombre: string,
    ae_pendiente: number
    ai_email: string,
    ai_nombre: string,
    ai_pendiente: number,
    anexo_pendiente: number
}

const notSuitableResidenceView = (r: NotSuitableResidence) => `
    <div class="residencia list-row">
        <p>${r.proyecto}</p>
        <p>${r.residente}</p>
        <p>${r.empresa}</p>
        <p>${r.ae_nombre} (${r.ae_email}) (${r.ae_pendiente == 0 ? "Evaluación enviada" : "Pendiente de evaluar"})</p>
        <p>${r.ai_nombre} (${r.ai_email}) (${r.ai_pendiente == 0 ? "Evaluación enviada" : "Pendiente de evaluar"})</p>
        <p>Anexo ${r.anexo_pendiente}</p>
    </div>
`;

const fetchNotSuitableResidences = () => new Promise<NotSuitableResidence[]>((resolve, reject) => {
    let xhr = new XMLHttpRequest();
    xhr.open('get', '/residenciasEnEvaluacion', true);

    xhr.onload = () => {
        const response = JSON.parse(xhr.response);

        if (response.code != 1) {
            reject(response.message);
            return;
        }

        resolve(response.object.map(o => o as NotSuitableResidence));
    };

    xhr.send();
});

const fillNotSuitableResidences = async () => {
    fetchNotSuitableResidences().then(list => {
        residenciasEvaluacionContainer.innerHTML = '';
        list.forEach(r => {
            residenciasEvaluacionContainer.innerHTML += notSuitableResidenceView(r);
        });
    }).catch(errorMessage => {
        residenciasEvaluacionContainer.innerHTML = `<p>${errorMessage}</p>`;
    })
}
fillNotSuitableResidences();


/* ================================================================================================

    Selección de residencias.

================================================================================================ */
let selectedResidences: number[] = [];

const toggleResidencia = (e: HTMLInputElement, id: number) => {
    const parent: HTMLDivElement = e.parentElement as HTMLDivElement;
    if (selectedResidences.includes(id)) {
        // Quita la residencia de la lista.
        const idxInArray = selectedResidences.findIndex((v, i, o) => v == id);
        selectedResidences.splice(idxInArray, 1);
        parent.classList.remove('selected');
    } else {
        // Pone la residencia en la lista.
        selectedResidences.push(id);
        parent.classList.add('selected');
    }
}

const toggleSelected = () => {
    const checkboxes = Array.from(document.getElementsByTagName('input')).filter(e => e.type = 'checkbox');

    checkboxes.forEach(chk => chk.click());
}

const selectAll = () => {
    const unselectedCheckboxes = Array.from(document.getElementsByTagName('input')).filter(e => e.type == 'checkbox' && !e.checked);

    unselectedCheckboxes.forEach(chk => chk.click());
}
const unselectAll = () => {
    const selectedCheckboxes = Array.from(document.getElementsByTagName('input')).filter(e => e.type == 'checkbox' && e.checked);

    selectedCheckboxes.forEach(chk => chk.click());
}

/* ================================================================================================

    Activación de anexos.

================================================================================================ */
const activarAnexo29 = () => {
    if (selectedResidences.length == 0) {
        alert('Seleccione por lo menos una residencia');
        return;
    }

    let xhr = new XMLHttpRequest();
    xhr.open('get', `/activarAnexo29?resArr=${JSON.stringify(selectedResidences)}`, true);

    xhr.onload = () => {
        const response = JSON.parse(xhr.response);

        if (response.code != 1) {
            alert(response.message);
            return;
        }

        alert('El periodo de evaluación de las residencias seleccionadas ha comenzado');
        if (Object.keys(response.object).length != 0) {
            let errorMsg: string = 'Han ocurrido los siguientes errores: \n'
            response.object.forEach(msg => errorMsg += `${msg}\n`);

            alert(errorMsg);
        }
        location.reload();
    };

    xhr.send();
}
anexo29Button.onclick = activarAnexo29;

const activarAnexo30 = () => {
    if (selectedResidences.length == 0) {
        alert('Seleccione por lo menos una residencia');
        return;
    }

    let xhr = new XMLHttpRequest();
    xhr.open('get', `/activarAnexo30?resArr=${JSON.stringify(selectedResidences)}`, true);

    xhr.onload = () => {
        const response = JSON.parse(xhr.response);

        if (response.code != 1) {
            alert(response.message);
            return;
        }

        alert('El periodo de evaluación de las residencias seleccionadas ha comenzado');
        if (Object.keys(response.object).length != 0) {
            let errorMsg: string = 'Han ocurrido los siguientes errores: \n'
            response.object.forEach(msg => errorMsg += `${msg}\n`);

            alert(errorMsg);
        }
        location.reload();
    };

    xhr.send();
}
anexo30Button.onclick = activarAnexo30;
