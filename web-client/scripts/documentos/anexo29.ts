const searchJSON = {};
const updateSearchJSON = () => location.search.substring(1).split('&').forEach(pair => {
    searchJSON[decodeURI(pair.split('=')[0])] = decodeURI(pair.split('=')[1]);
})
updateSearchJSON();

/* ================================================================================================

    Llenar la vista web con información.

================================================================================================ */
const populateDocument = () => {
    if (!searchJSON['id']) {
        window.open('/documents/anexo-29', '_self');
        return;
    }
    
    // Views
    const residenteView = document.getElementById('residenteView');
    const noControlView = document.getElementById('noControlView');
    const proyectoView = document.getElementById('proyectoView');
    const programaView = document.getElementById('programaView');
    const periodoView = document.getElementById('periodoView');
    const calificacionView = document.getElementById('calificacionView');
    const aePlaceholders = Array.from(document.getElementsByClassName('ae-cal'));
    const aeObsView = document.getElementById('aeObsView');
    const aeCalView = document.getElementById('aeCalView');
    const aeFechaView = document.getElementById('aeFechaView');
    const aiPlaceholders = Array.from(document.getElementsByClassName('ai-cal'));
    const aiObsView = document.getElementById('aiObsView');
    const aiCalView = document.getElementById('aiCalView');
    const aiFechaView = document.getElementById('aiFechaView');

    const anexoId = searchJSON['id'];

    let infoXHR = new XMLHttpRequest();
    infoXHR.open('get', `/getAnexo29Info?id=${encodeURI(anexoId)}`, true);
    
    infoXHR.onload = () => {
        const response = JSON.parse(infoXHR.response);

        if (response['code'] <= 0) {
            alert(response['message']);
            window.open('/documentos', '_self');
            return;
        }

        const a = response['object'];

        residenteView.innerHTML = a['residente'];
        noControlView.innerHTML = a['noControl'];
        proyectoView.innerHTML = a['proyecto'];
        programaView.innerHTML = a['programa'];
        periodoView.innerHTML = a['periodo'];
        calificacionView.innerHTML = a['calificacion'];

        for (let idx: number = 0; idx < aePlaceholders.length; ++idx) {
            aePlaceholders[idx].innerHTML = a[`ae-${idx + 1}`];
        }
        aeObsView.innerHTML = a['ae-observaciones'];
        aeCalView.innerHTML = a['ae-total'];
        aeFechaView.innerHTML = a['ae-fecha'];

        for (let idx: number = 0; idx < aiPlaceholders.length; ++idx) {
            aiPlaceholders[idx].innerHTML = a[`ai-${idx + 1}`];
        }
        aiObsView.innerHTML = a['ai-observaciones'];
        aiCalView.innerHTML = a['ai-total'];
        aiFechaView.innerHTML = a['ai-fecha'];


    };
    
    infoXHR.send();

}
populateDocument();

/* ================================================================================================

    Descarga de documentos.

================================================================================================ */

document.getElementById('emptyDownloadButton').onclick = () => getDocument(`formato-anexo-29.docx`, `/getAnexo29`);
document.getElementById('infoDownloadButton').onclick = () => getDocument(`anexo-29-${searchJSON['id']}.docx`, `/getAnexo29?id=${encodeURI(searchJSON['id'])}`);