const subjectContainer: HTMLElement = document.getElementById('subjectContainer');
const searchResultsContainer = document.getElementById('searchResultsContainer');
const searchInputView: HTMLInputElement = document.getElementById('searchInput') as HTMLInputElement;
const searchButtonView: HTMLElement = document.getElementById('searchButton');

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

searchInputView.oninput = search;
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