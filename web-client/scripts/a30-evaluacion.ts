const proyectoPlaceholderView: HTMLSpanElement = document.getElementById('proyectoPlaceholderView') as HTMLSpanElement;
const residentePlaceholderView: HTMLSpanElement = document.getElementById('residentePlaceholderView') as HTMLSpanElement;
const numCPlaceholderView: HTMLSpanElement = document.getElementById('numCPlaceholderView') as HTMLSpanElement;

const obsView: HTMLTextAreaElement = document.getElementById('obsView') as HTMLTextAreaElement;

const sendInfoButton: HTMLButtonElement = document.getElementById('finishButton') as HTMLButtonElement;

/* ================================================================================================

    Get residence information.

================================================================================================ */
const urlId = location.search.substring('?id='.length);

const fillInfo = (uid: string) => {
    let xhr = new XMLHttpRequest();
    xhr.open('get', `/infoAnexo30DesdeURL?id=${uid}`, true);
    
    xhr.onload = () => {
        const response = JSON.parse(xhr.response);
        
        if (response.code != 1) {
            alert(response.message);
            window.open('/', '_self');
            return;
        }

        proyectoPlaceholderView.innerHTML = response.object[0]['proyecto'].toUpperCase();
        residentePlaceholderView.innerHTML = response.object[0]['residente'];
        numCPlaceholderView.innerHTML = response.object[0]['correo_residente'].substring(1, 9);
    };
    
    xhr.send();
}
fillInfo(urlId);

/* ================================================================================================

    Enviar evaluación

================================================================================================ */
const sendEvaluation = () => {
    const inputs: HTMLInputElement[] = Array.from(document.getElementsByClassName('evaluation-input')).map(e => e as HTMLInputElement);
    
    let evaluations: number[] = [];
    for (const idx in inputs) {
        const i = inputs[idx];

        if (i.value.trim() == '') {
            alert('Por favor, califique cada uno de los rubros indicados');
            return;
        }

        if (Number(i.value.trim()) < Number(i.min) || Number(i.value.trim()) > Number(i.max)) {
            alert('Una calificación no cumple con el límite establecido');
            return;
        }

        evaluations.push(Number(i.value.trim()));
    }

    const evaluationString: string = evaluations.join(',');
    const observations: string = obsView.value.trim();

    if (observations == '') {
        alert('Por favor, provea información al campo de observaciones')
        return;
    }

    let xhr = new XMLHttpRequest();
    xhr.open('post', `/registrarEvaluacionA30`, true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    
    xhr.onload = () => {
        const response = JSON.parse(xhr.response);

        if (response.code != 1) {
            alert(response.message);
            return;
        }

        alert('Residencia evaluada con éxito');
        window.open('/', '_self');
    };
    
    xhr.send(
        `id=${encodeURI(urlId)}&` +
        `evaluacion=${encodeURI(evaluationString)}&` +
        `observaciones=${encodeURI(observations)}&` 
    );
}
sendInfoButton.onclick = sendEvaluation;