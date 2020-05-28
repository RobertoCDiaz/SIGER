const conta = document.getElementById('container');

const materia = document.getElementById('txtMateria') as HTMLInputElement;

const searchBtn = document.getElementById('searchButton');
const selMaterias = document.getElementById('seleccionMaterias');

const selView = (name) => `<li onclick="listaCompetentes('${name}')">${name}</li>`;
const getSubjects = () => {
    while(conta.firstChild)
        conta.removeChild(conta.lastChild);
    while(selMaterias.firstChild)
        selMaterias.removeChild(selMaterias.lastChild);
    let xhr = new XMLHttpRequest();
    xhr.open('get', `/buscarMateria?q=`+materia.value, true);
    xhr.onload = () => {
        let response = JSON.parse(xhr.responseText).object;

        for (let i = 0; i < response.length; ++i) {
            let c = response[i];
            selMaterias.innerHTML += selView(c['nombre']);
        }
    }
    xhr.send();
}
searchBtn.addEventListener('click',getSubjects);

const materiaSeleccionadaView = (name) => `<h1>${name}</h1>`;
let resu;
let count;
const listaCompetentes = (materiaSeleccionada : string) =>
{
    while(selMaterias.firstChild)
        selMaterias.removeChild(selMaterias.lastChild);


    while(conta.firstChild)
        conta.removeChild(conta.lastChild);

    conta.innerHTML+=materiaSeleccionadaView(materiaSeleccionada);

    let xhr = new XMLHttpRequest();
    xhr.open('get', '/lista-competentes?materia='+materiaSeleccionada, true);
    xhr.onload = () =>
    {
        resu = JSON.parse(xhr.response);
        count = resu['length']-1;
        try
        {
            for(let i = 0; i < count; i++)
            {
                conta.innerHTML += competentesView(resu[i]);
            }
        }
        catch(err){
            alert(err);
        };
    }
    xhr.send();
};



/* ================================================================================================

    Desplegar lista de residentes.

================================================================================================ */


const competentesView = (r) => `
<div class="residencia">
<div class="title">

    <div class="projectNameContainer">
    <p class="projectName"><a href="/chat?open=${r['email']}">${r['nombre']}</a></p>
</div>


</div>
<p>Correo: <b>${r['email']}</b></p>
</div>
`


/* ================================================================================================

    Contactar con el docente.

================================================================================================ */
const contact = (email:string) => window.open(`/?email=${email}`);