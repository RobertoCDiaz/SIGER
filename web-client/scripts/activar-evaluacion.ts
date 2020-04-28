const residenciasContainerView = document.getElementById('residenciasContainerView');

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
        <input type="checkbox" onclick="toggleResidencia(${r.id});">
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

    Selección de residencias.

================================================================================================ */
let selectedResidences: number[] = [];
const toggleResidencia = (id: number) => {
    if (selectedResidences.includes(id)) {
        // Quita la residencia de la lista.
        const idxInArray = selectedResidences.findIndex((v, i, o) => v == id);
        selectedResidences.splice(idxInArray, 1);
    } else {
        // Pone la residencia en la lista.
        selectedResidences.push(id);
    }
}