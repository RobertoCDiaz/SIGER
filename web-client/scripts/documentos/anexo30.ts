{const searchJSON = {};
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

    const anexoId = searchJSON['id'];
    
    // Calificaciones
    const aePlaceholders = Array.from(document.getElementsByClassName('ae-cal'));
    const aiPlaceholders = Array.from(document.getElementsByClassName('ai-cal'));

    let infoXHR = new XMLHttpRequest();
    infoXHR.open('get', `/getAnexo30Info?id=${encodeURI(anexoId)}`, true);
    
    infoXHR.onload = () => {
        const response = JSON.parse(infoXHR.response);

        if (response['code'] <= 0) {
            alert(response['message']);
            window.open('/documentos', '_self');
            return;
        }

        const a = response['object'];

        for (let idx: number = 0; idx < aePlaceholders.length; ++idx) {
            aePlaceholders[idx].innerHTML = a[`ae-${idx + 1}`];
            delete a[`ae-${idx + 1}`];
        }

        for (let idx: number = 0; idx < aiPlaceholders.length; ++idx) {
            aiPlaceholders[idx].innerHTML = a[`ai-${idx + 1}`];
            delete a[`ai-${idx + 1}`];
        }
        
        Object.keys(a).forEach(key => {
            document.getElementById(`${key}View`).innerHTML = a[key];
        });
    };
    
    infoXHR.send();
}
populateDocument();

/* ================================================================================================

    Descarga de documentos.

================================================================================================ */

document.getElementById('emptyDownloadButton').onclick = () => getDocument(`formato-anexo-30.docx`, `/getAnexo30`);
document.getElementById('infoDownloadButton').onclick = () => getDocument(`anexo-30-${searchJSON['id']}.docx`, `/getAnexo30?id=${encodeURI(searchJSON['id'])}`);}