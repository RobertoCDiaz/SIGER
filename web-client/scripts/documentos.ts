const misDocumentosContainer = document.getElementById('misDocumentosContainer');

interface DocumentInfo {
    id: number,
    fecha: string
}

class Documentos {
    preliminar: DocumentInfo;
    anexos_29: DocumentInfo[];
    anexos_30: DocumentInfo[];

    constructor(idRes: any, fechaRes: string, anexos_29: string, fechas_a29: string, anexos_30: string, fechas_a30: string) {
        this.preliminar = {id: Number(idRes), fecha: new Date(Number(fechaRes)).toDateString()};
        this.anexos_29 = anexos_29?.split(',').map((id, index) => {
            let a: DocumentInfo = {id: Number(id), fecha: new Date(Number(fechas_a29.split(',')[index])).toDateString()};

            return a;
        });
        this.anexos_30 = anexos_30?.split(',').map((id, index) => {
            let a: DocumentInfo = {id: Number(id), fecha: new Date(Number(fechas_a30.split(',')[index])).toDateString()};
            
            return a;
        });
    }
}

const getDocuments = () => new Promise<Documentos>((resolve, reject) => {
    getPetition('/idDeMiResidencia', idResponse => {
        if (idResponse['code'] <= 0) {
            reject(idResponse['message']);
            return;
        }

        const id = idResponse['object'];

        getPetition(`/documentosDeResidencia?id=${id}`, docResponse => {
            if (docResponse['code'] <= 0) {
                reject(docResponse['message']);
                return;
            }

            const docs: Object = docResponse['object'];

            resolve(new Documentos(docs['reporte_preliminar'], docs['fecha_reporte_preliminar'], docs['anexos_29'], docs['fechas_anexos_29'], docs['anexos_30'], docs['fechas_anexos_30']));
        });
    });
});

const getPetition = (petition: string, callback: (response: JSON) => void) => {
    let xhr = new XMLHttpRequest();
    xhr.open('get', `${petition}`, true);
    
    xhr.onload = () => {
        const response = JSON.parse(xhr.response);
        
        callback(response);
    };
    
    xhr.send();
}

const documentView = (name: string, fecha: string, href: string) => `
    <div class="column">
        <div class="contentt">
        <a href="${href}"><img src="assets/images/word.png" style="width:50%"></a>
        <h3>${name}</h3>
        <p>Fecha de creación: ${fecha}</p>
        </div>
    </div>
`

const populateDocuments = () => {

    getDocuments().then(docs => {

        if (docs.preliminar) {
            misDocumentosContainer.innerHTML += documentView('Reporte preliminar', docs.preliminar.fecha, `/documentos/reporte-preliminar?id=${docs.preliminar.id}`)
        }

        if (docs.anexos_29) {
            docs.anexos_29.forEach(a => {
                misDocumentosContainer.innerHTML +=
                    documentView('Anexo 29 (Evaluación intermedia)', a.fecha, `/documentos/anexo-29?id=${a.id}`);
            })
        }

        if (docs.anexos_30) {
            docs.anexos_30.forEach(a => {
                misDocumentosContainer.innerHTML +=
                    documentView('Anexo 30 (Evaluación intermedia)', a.fecha, `/documentos/anexo-30?id=${a.id}`);
            })
        }
        

    }).catch(error => alert(error));

}

populateDocuments();