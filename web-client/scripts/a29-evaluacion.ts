const projectPlaceholderView: HTMLSpanElement = document.getElementById('projectPlaceholderView') as HTMLSpanElement;
const namePlaceholderView: HTMLSpanElement = document.getElementById('namePlaceholderView') as HTMLSpanElement;
const numPlaceholderView: HTMLSpanElement = document.getElementById('numPlaceholderView') as HTMLSpanElement;

const observacionesView: HTMLTextAreaElement = document.getElementById('observacionesView') as HTMLTextAreaElement;

const evaluateButton: HTMLButtonElement = document.getElementById('evaluateButton') as HTMLButtonElement;

/* ================================================================================================

    Get residence information.

================================================================================================ */
const id = location.search.substring('?id='.length);

const populateInfo = (uid: string) => {
    let xhr = new XMLHttpRequest();
    xhr.open('get', `/infoAnexo29DesdeURL?id=${uid}`, true);

    xhr.onload = () => {
        const response = JSON.parse(xhr.response);

        if (response.code != 1) {
            alert(response.message);
            window.open('/', '_self');
            return;
        }

        projectPlaceholderView.innerHTML = response.object[0]['proyecto'].toUpperCase();
        namePlaceholderView.innerHTML = response.object[0]['residente'];
        numPlaceholderView.innerHTML = response.object[0]['correo_residente'].substring(1, 9);
    };

    xhr.send();
}
populateInfo(id);

/* ================================================================================================

    Enviar evaluación

================================================================================================ */
const evaluate = () => {
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
    const observations: string = observacionesView.value.trim();

    if (observations == '') {
        alert('Por favor, provea información al campo de observaciones')
        return;
    }

    let xhr = new XMLHttpRequest();
    xhr.open('post', `/registrarEvaluacionA29`, true);
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
        `id=${encodeURI(id)}&` +
        `evaluacion=${encodeURI(evaluationString)}&` +
        `observaciones=${encodeURI(observations)}&`
    );
}
evaluateButton.onclick = evaluate;