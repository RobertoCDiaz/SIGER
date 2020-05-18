const searchJSONr = {};
const updateSearchJSONr = () => location.search.substring(1).split('&').forEach(pair => {
    searchJSONr[decodeURI(pair.split('=')[0])] = decodeURI(pair.split('=')[1]);
})
updateSearchJSONr();

/* ================================================================================================

    Llenar la vista web con información.

================================================================================================ */
const populateDocumentr = () => {
    if (!searchJSONr['id']) {
        window.open('/documentos/reporte-preliminar', '_self');
        return;
    }
    
    // Views
    const projectView = document.getElementById('projectView');
    const fechaView = document.getElementById('fechaView');
    const objectiveView = document.getElementById('objectiveView');
    const justificationView = document.getElementById('justificationView');
    const periodView = document.getElementById('periodView');
    const yearView = document.getElementById('yearView');
    const activitiesView = document.getElementById('activitiesView');
    const companyView = document.getElementById('companyView');
    const representativeView = document.getElementById('representativeView');
    const addressView = document.getElementById('addressView');
    const companyPhoneView = document.getElementById('companyPhoneView');
    const companyCityView = document.getElementById('companyCityView');
    const companyEmailView = document.getElementById('companyEmailView');
    const companyDeptView = document.getElementById('companyDeptView');
    const aeNameView = document.getElementById('aeNameView');
    const aePositionView = document.getElementById('aePositionView');
    const aeLevelOfStudyView = document.getElementById('aeLevelOfStudyView');
    const aePhoneView = document.getElementById('aePhoneView');
    const aeEmailView = document.getElementById('aeEmailView');
    const residentNameView = document.getElementById('residentNameView');
    const controlNumberView = document.getElementById('controlNumberView');
    const carreerView = document.getElementById('carreerView');
    const residentLandlineView = document.getElementById('residentLandlineView');
    const residentCellphoneView = document.getElementById('residentCellphoneView');
    const residentEmailView = document.getElementById('residentEmailView');
    const residentSchedules = document.getElementById('residentSchedulesView');
    const firmaAEView = document.getElementById('firmaAEView');
    const firmaAIView = document.getElementById('firmaAIView');

    const idResidencia = searchJSONr['id'];
    //const idResidencia = '1';

    let infoXHR = new XMLHttpRequest();
    infoXHR.open('get', `/getReportePreliminarInfo?id=${encodeURI(idResidencia)}`, true);
    
    infoXHR.onload = () => {
        const response = JSON.parse(infoXHR.response);

        if (response['code'] <= 0) {
            alert(response['message']);
            window.open('/documentos', '_self');
            return;
        }

        const a = response['object'];
        fechaView.innerHTML = a['fecha'];
        projectView.innerHTML = a['proyecto'];
        objectiveView.innerHTML = a['objetivo'];
        justificationView.innerHTML = a['justificacion'];
        periodView.innerHTML = a['periodo'];
        yearView.innerHTML = a['ano'];
        activitiesView.innerHTML = a['actividades'];
        companyView.innerHTML = a['empresa'];
        representativeView.innerHTML = a['representante_e'];
        addressView.innerHTML = a['direccion_e'];
        companyPhoneView.innerHTML = a['telefono_e'];
        companyCityView.innerHTML = a['ciudad_e'];
        companyEmailView.innerHTML = a['email_e'];
        companyDeptView.innerHTML = a['departamento_e'];
        aeNameView.innerHTML = a['nombre_ae'];
        aePositionView.innerHTML = a['puesto_ae'];
        aeLevelOfStudyView.innerHTML = a['grado_ae'];
        aePhoneView.innerHTML = a['telefono_ae'];
        aeEmailView.innerHTML = a['email_ae'];
        residentNameView.innerHTML = a['nombre_res'];
        controlNumberView.innerHTML = a['noControl_res'];
        carreerView.innerHTML = a['carrera'];
        residentLandlineView.innerHTML = a['tel_casa'];
        residentCellphoneView.innerHTML = a['celular'];
        residentEmailView.innerHTML = a['email_res'];
        residentSchedules.innerHTML = a['horarios'];
        firmaAEView.innerHTML = a['nombre_ae'];
        firmaAIView.innerHTML = a['nombre_ai']
    };
    infoXHR.send();
}
populateDocumentr();

/* ================================================================================================

    Descarga de documentos.

================================================================================================ */

//document.getElementById('emptyDownloadButton').onclick = () => getDocument(`reporte-preliminar`, `/getReportePreliminar`);

document.getElementById('downloadButton').onclick = () =>
getDocument(`reporte-preliminar-${searchJSONr['id']}`,
`/getReportePreliminar?id=${encodeURI(searchJSONr['id'])}`);