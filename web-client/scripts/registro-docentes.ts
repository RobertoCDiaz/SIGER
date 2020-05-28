const subjectContainer: HTMLElement = document.getElementById('subjectContainer');
const searchResultsContainer = document.getElementById('searchResultsContainer');
const searchInputView: HTMLInputElement = document.getElementById('searchInput') as HTMLInputElement;
const searchButtonView: HTMLElement = document.getElementById('searchButton');

const emailDView: HTMLInputElement = document.getElementById('emailView') as HTMLInputElement;
const passView: HTMLInputElement = document.getElementById('passView') as HTMLInputElement;
const repeatPassView: HTMLInputElement = document.getElementById('repeatPassView') as HTMLInputElement;
const nameDView: HTMLInputElement = document.getElementById('nameView') as HTMLInputElement;
const patSurnameView: HTMLInputElement = document.getElementById('patSurnameView') as HTMLInputElement;
const matSurnameView: HTMLInputElement = document.getElementById('matSurnameView') as HTMLInputElement;
const phoneNumberView: HTMLInputElement = document.getElementById('phoneNumberView') as HTMLInputElement;
const finishButton = document.getElementById('finishButton');

interface Materia {
    clave: string,
    nombre: string
}

// Arreglo de materias. Cada elemento de este arreglo es del tipo [Materia].
let subjects: Array<Materia> = [];


/* ================================================================================================

    Asociación de materias al docente.

================================================================================================ */
const fetchSubjects: (query: string) => Promise<Object> =
    (query) => new Promise((resolve, reject) => {
        let xhr = new XMLHttpRequest();
        xhr.open('get', `/buscarMateria?q=${encodeURI(query)}`, true);

        xhr.onload = () => {
            const response = JSON.parse(xhr.response);

            if (response.code != 1) {
                reject(response.message);
                return;
            }

            resolve(response.object);
        };

        xhr.send();
    });

const resultsView = (s) =>
    `<div class="subject" onclick="addSubject('${s['clave']}', '${s['nombre']}');"><p class="name">${s['nombre']}</p><p class="id">${s['clave'].toUpperCase()}</p></div>`;

const search = () => {
    const query = searchInputView.value.trim();

    fetchSubjects(query).then(subjects => {
        searchResultsContainer.innerHTML = '';
        (subjects as Array<Object>).forEach(s =>
            searchResultsContainer.innerHTML += resultsView(s)
        );
    }).catch(error => {
        searchResultsContainer.innerHTML = `<p style="margin: .5em;">${error}</p>`;
    })
}

// searchInputView.oninput = search;
searchInputView.onkeypress = e => {
    if (e.charCode == 13)
        search();
}
searchButtonView.onclick = search;

const addSubject = (clave: string, nombre: string) => {
    let subject: Materia = {
        'clave': clave,
        'nombre': nombre
    };

    if (subjects.findIndex((v, i, o) => v.clave == clave) != -1) {
        alert("Ya ha marcado esta materia");
        return;
    }

    subjects.push(subject);

    updateSubjectUI();
}

const removeSubject = (clave: string) => {
    const idx = subjects.findIndex((v, i, o) => v.clave == clave);
    subjects.splice(idx, 1);

    updateSubjectUI();
}


const subjectView = (s: Materia) => `
    <div class="subject">
        <i onclick="removeSubject('${s.clave}');" class="material-icons">close</i>
        <p class="name">${s.nombre}</p>
        <p class="id">${s.clave.toUpperCase()}</p>
    </div>
`;

const updateSubjectUI = () => {
    subjectContainer.innerHTML = '';
    subjects
        .sort((s1, s2) => s1.clave > s2.clave ? 1 : -1) // Ordena las materias alfabéticamente basado en clave.
        .forEach(s => {
            subjectContainer.innerHTML += subjectView(s);
        });
}

/* ================================================================================================

    Registro de docentes.

================================================================================================ */
const register = () => {
    if (
        emailDView.value.trim() == "" ||
        passView.value == "" ||
        repeatPassView.value == "" ||
        nameDView.value.trim() == "" ||
        patSurnameView.value.trim() == "" ||
        phoneNumberView.value.trim() == ""
    ) {
        alert("Por favor, llene todos los campos marcados con un asterísco");
        return;
    }

    if (passView.value != repeatPassView.value) {
        alert("Las contraseñas no coinciden");
        return;
    }

    if (!(new RegExp(`[A-z]+\.[A-z]{2}@piedrasnegras\.tecnm\.mx`).test(emailDView.value.trim()))) {
        alert('El correo electrónico dado no cumple con la estructura de un correo electrónico institucional de un docente.')
        return;
    }

    let xhr = new XMLHttpRequest();
    xhr.open('post', '/registrarDocente', true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

    xhr.onload = () => {
        const response = JSON.parse(xhr.response);

        alert(response.message);

        if (response.code == 1) {
            window.open('/home', '_self');
        }
    };

    xhr.send(
        `email=${encodeURI(emailDView.value.trim())}&` +
        `pass=${encodeURI(passView.value)}&` +
        `nombre=${encodeURI(nameDView.value.trim())}&` +
        `apPat=${encodeURI(patSurnameView.value.trim())}&` +
        `apMat=${encodeURI(matSurnameView.value.trim())}&` +
        `tel=${encodeURI(phoneNumberView.value.trim())}&` +
        `clavesArr=${encodeURI(JSON.stringify(subjects.map(s => s.clave)))}`
    );
}

finishButton.onclick = register;
