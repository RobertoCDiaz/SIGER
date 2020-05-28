const cont = document.getElementById('container');

const fillTeacherEmail = () => {
    const teacherEmailView = document.getElementById('teacherEmailView');

    let xhr = new XMLHttpRequest();
    xhr.open('get', '/user-info', true);
    xhr.onload = () => {
        let response = JSON.parse(xhr.response);

        teacherEmailView.innerHTML = response.object.email;
    };
    xhr.send();
}

fillTeacherEmail();

let res;
let cantidad;
const listaAsesorados = () =>
{
    let xhr = new XMLHttpRequest();
    xhr.open('get', '/asesorados', true);
    xhr.onload = () =>
    {
        res = JSON.parse(xhr.response);
        cantidad = res['length']-1;
        try
        {
            for(let i = 0; i < cantidad; i++)
            {
                container.innerHTML += asesoradosView(res[i]);
            }
        }
        catch(err){
            alert(err);
        };
    }
    xhr.send();
}
listaAsesorados();

/* ================================================================================================

    Desplegar lista de residentes.

================================================================================================ */


const asesoradosView = (r) => `
<div class="residencia" onclick="abrirAsesorado('${r['remail']}');">
<div class="title">
    <div class="projectNameContainer">
        <p class="projectName">${r['nombre']+' '+r['ap']}</p>
    </div>

    <div class="period">
        <p>${r['periodo'] == 1 ? 'Enero - Junio' : 'Agosto - Diciembre'}</p>
        <p>${r['ano']}</p>
    </div>
</div>
<p>Proyecto: <b>${r['proyecto']}</b></p>
<p>${r['carrera']}</p>
</div>
`


/* ================================================================================================

    Abrir detalles de residencia.

================================================================================================ */
const abrirAsesorado = (email:string) => window.open(`/avancedemiresidente?email=${email}`, '_self');