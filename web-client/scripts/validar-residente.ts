// import { Response } from "../../server/Response";


/* ================================================================================================

    Cargar residentes no validados.

================================================================================================ */
const residentsContainerView = document.getElementById('residentsContainerView');

const getResidentsList = (): Promise<Object> => new Promise((resolve, reject) => {
    let xhr = new XMLHttpRequest();
    xhr.open('get', '/residentesNoValidados', true);

    xhr.onload = () => {
        let response = JSON.parse(xhr.response);
        // let response: Response = Response.fromStringifiedJSON(xhr.response);

        if (response['code'] != 1) {
        // if (!response.isSuccessful()) {
            reject(response['message']);
            return;
        }

        resolve(response['object']);
    };

    xhr.send();
});

const timestampToLegibleDate = (ts) => {
    const monthsArr: String[] = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];

    const d: Date = new Date(ts);

    return `${d.getDate()} de ${monthsArr[d.getMonth()]} del ${d.getFullYear()}`;
}

const residentView = (r) => `
<div class="list-item" onclick='openInfo(${JSON.stringify(r)});'>
    <p class="controlNumber">${r.noControl}</p>
    <p class="fullName">${(`${r.nombre} ${r.apellido_paterno} ${r.apellido_materno ?? ""}`).toUpperCase()}</p>
    <p class="date">${timestampToLegibleDate(Number.parseInt(r.fecha_creacion))}</p>
</div>
`;

const populateList = async () => {
    getResidentsList().then(res => {
        for (const o in res) {
            residentsContainerView.innerHTML += residentView(res[o]);
        }
    }).catch(e => alert(e));
}
populateList();

/* ================================================================================================

    Mostrar información individual del residente.

================================================================================================ */
const residenteView = document.getElementById('residenteView');

const nameView = document.getElementById('nameView');
const controlNumberView = document.getElementById('controlNumberView');
const careerView = document.getElementById('careerView');
const dateView = document.getElementById('dateView');
const emailView = document.getElementById('emailView');
const cellPhoneView = document.getElementById('cellPhoneView');
const phoneView = document.getElementById('phoneView');
const validateButtonView = document.getElementById('validateButtonView');

const openInfo = (r) => {
    nameView.innerHTML = `${r.nombre} ${r.apellido_paterno} ${r.apellido_materno ?? ""}`;
    controlNumberView.innerHTML = r['noControl'];
    careerView.innerHTML = r['carrera'];
    dateView.innerHTML = timestampToLegibleDate(Number.parseInt(r['fecha_creacion']));
    emailView.innerHTML = r['email'];
    cellPhoneView.innerHTML = r['celular'];
    phoneView.innerHTML = r['tel'];

    validateButtonView.onclick = () => validar(r['email']);

    residenteView.style.display = 'flex';
}

const closeInfo = () => {
    residenteView.style.display = 'none';
}

/* ================================================================================================

    Validar residente.

================================================================================================ */
const validar = (email: string) => {
    let xhr = new XMLHttpRequest();
    xhr.open('post', '/validarResidente', true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

    xhr.onload = () => {
        const response = JSON.parse(xhr.response);

        alert(response['message']);

        location.reload();
    };
    
    xhr.send(`email_residente=${email}`);
}