const urlGetParameters = {};
const populateUrlGetParametersObject = () => {
    location.search.substring(1).split('&').forEach(pair =>
        urlGetParameters[decodeURI(pair.split('=')[0])] = decodeURI(pair.split('=')[1])
    );
}
populateUrlGetParametersObject();

/**
 * Email del contacto cuyo chat está actualmente abierto.
 */
let openedConversationEmail = urlGetParameters['open'];


/* ================================================================================================

    Clases.

================================================================================================ */
/**
 * Modelo de un mensaje recibido desde el servidor.
 */
class Message {
    id: number;
    content: string;
    date: Date;
    remitent_email: string;
    remitent_fullname: string;
    receiver_email: string;
    receiver_fullname: string;
    isMine: boolean;
    attachedFiles: AttachedFile[];

    constructor(obj: Object, receiverEmail: string) {
        this.id = obj['id'];
        this.content = obj['contenido'];
        this.date = new Date(Number(obj['timestamp']));
        this.remitent_email = obj['remitente_email'];
        this.remitent_fullname = obj['nombre_email1'];
        this.receiver_email = obj['destinatario_email'];
        this.receiver_fullname = obj['nombre_email2'];
        this.attachedFiles = obj['archivos'].map(o => new AttachedFile(o));

        this.isMine = this.receiver_email == receiverEmail;
    }
}


/**
 * Modelo que representa a un archivo de la base de datos.
 */
class AttachedFile {
    id: number;
    route: string;
    name: string;

    constructor(obj: Object) {
        this.id = obj['id'];
        this.route = obj['ruta'];
        this.name = obj['nombre'];
    }
}


/* ================================================================================================

    Cargar conversaciones.

================================================================================================ */
/**
 * Pide al servidor una conversación con otro usuario.
 *
 * @param withEmail Correo del otro usuario.
 *
 * @returns conversationObject  Un objecto conteniendo todos
 *                              los mensajes de la conversación,
 *                              ordenados por fecha. Cada entrada
 *                              de este JSON tiene como clave
 *                              la fecha del día, y como valor un
 *                              arreglo de mensajes de dicho día.
 */
const getConversationWith = (withEmail: string) => new Promise<Object>((resolve, reject) => {
    let xhr = new XMLHttpRequest();
    xhr.open('get', `/getChatConversation?with=${withEmail}`, true);

    xhr.onload = () => {
        const response = JSON.parse(xhr.response);

        if (response['code'] < 1) {
            reject(response['message']);
        }

        const conversation = {};
        (response['object'][0] as Object[]).map(o => new Message(o, withEmail)).forEach(msg => {
            const d = msg.date;
            const displayDate = `${d.getDate()} / ${d.getMonth() + 1} / ${d.getFullYear()}`;

            if (!conversation[displayDate])
                conversation[displayDate] = [];

            (conversation[displayDate] as Message[]).push(msg);
        });

        Object.keys(conversation).forEach(key =>
            (conversation[key] as Message[]).sort((m1, m2) =>
                m1.date.getTime > m2.date.getTime ? 1 : -1
            )
        );

        resolve([conversation, response['object'][1]]);
    };

    xhr.send();
});


/**
 * Regresa un string con el código HTML para generar un separador
 * de fechas en el chat.
 *
 * @param displayDate Fecha a mostrar en el separador.
 */
const daySeparatorView = (displayDate: string) =>
    `<p class="date prevent-selection">${displayDate}</p>`;


/**
 * Regresa la estructura HTML de un nuevo mensaje.
 *
 * @param msg Objeto a partir del cuál se creará el mensaje.
 */
const msgView = (msg: Message) => `
<div class="message ${msg.isMine ? "mine" : ""}">
<div class="attachedFiles ${msg.attachedFiles.length == 0 ? "hidden-container" : ""}">
    <p>Archivos anexados</p>
    <div class="list">
        ${msg.attachedFiles.map(f => `
            <div class="file" onclick="openAttachedFile('${f.route}');">
                <i class="material-icons">attachment</i>
                <p class="name">${f.name}</p>
            </div>
        `).join("")}
    </div>
    </div>
    <p class="content">
        ${msg.content}
    </p>
    <p class="hour prevent-selection">${twoDigits(msg.date.getHours())}:${twoDigits(msg.date.getMinutes())}</p>
</div>`;

const openAttachedFile = (route: string) => window.open(`/siger-cloud/files/${route}`);

// const attachedFilesViews = (files: AttachedFile[]) =>

/**
 * Regresa un string de dos caracteres representando un número
 * con dos dígitos.
 *
 * Por ejemplo:
 *
 *      $ twoDigits(1)
 *          -> "01"
 *
 *      $ twoDigits(8)
 *          -> "08"
 *
 *      $ twoDigits(14)
 *          -> "14"
 *
 *      $ twoDigits(256)
 *          -> "56"
 *
 * @param n Número a formatear.
 */
const twoDigits = (n: number) => ("0" + n).slice(-2);


/**
 * Muestra en la UI una conversación.
 *
 * @param conversation Objeto a mostrar. Este objeto debe
 * resultado del promise [getConversationWith()].
 */
const displayConversation = (conversation) => {
    const messagesContainer = document.querySelector('#messagesContainer');
    const contactNameView = document.querySelector('#contactNameView');
    const emailInputView: HTMLInputElement = document.querySelector('#emailInputView');

    messagesContainer.innerHTML = '';

    contactNameView.innerHTML = conversation[1]['nombre_email2'];
    emailInputView.value = conversation[1]['email2'];

    Object.keys(conversation[0]).forEach(date => {
        messagesContainer.innerHTML += daySeparatorView(date);
        (conversation[0][date] as Message[]).sort((msg1, msg2) => msg1['id'] > msg2['id'] ? 1 : -1).forEach(msg => {
            messagesContainer.innerHTML += msgView(msg);
        })
    })
}


/* ================================================================================================

    Panel de conversaciones.

================================================================================================ */
/**
 * Se trae del servidor la lista de todas las conversaciones en las que el usuario
 * participa.
 */
const getConversationsList = () => new Promise<Object>((resolve, reject) => {
    let xhr = new XMLHttpRequest();
    xhr.open('get', `/getListaDeConversaciones`, true);

    xhr.onload = () => {
        const response = JSON.parse(xhr.response);

        if (response['code'] < 1) {
            reject(response['message']);
            return;
        }

        resolve(response['object']);
    };

    xhr.send();
});


/**
 * Muestra las conversaciones en el panel lateral.
 *
 * @param list Objeto con las conversaciones. Este objeto debe ser
 * resultado de la promise [getConversationsList()].
 */
const displayConversationsList = (list) => {
    const conversationsListView = document.querySelector('#conversationsListView');

    conversationsListView.innerHTML = '';

    list.forEach(msg => {
        conversationsListView.innerHTML += contactView(msg);
    });
}


/**
 * Estructura HTML de una conversación individual a mostrar en el
 * panel lateral.
 *
 * @param convObj Objeto de conversación individual.
 */
const contactView = (convObj: Object) => {

    return `
    <div onclick="changeChat('${convObj['contacto_email']}')" class="contact ${convObj['contacto_email'] == openedConversationEmail ? "active" : ""}">
        <p class="name">${convObj['contacto_nombre']}</p>
        <p class="message" title="${convObj['contenido']}">
            <i class="material-icons">call_${convObj['enviado'] == 1 ? "made" : "received"}</i>
            ${convObj['contenido'].substring(0, 30)}${convObj['contenido'].substring(0, 30).length == 30 ? "..." : ""}
        </p>
    </div>`;
};


/* ================================================================================================

    Anexar archivos.

================================================================================================ */
/**
 * Contienen todos los archivos actualmente anexados al mensaje en marcha.
 */
let attachedFiles: Object = {};


/**
 * Función que acciona el selector de archivos del navegador.
 */
const openFilePicker = () => {
    const fileInput: HTMLInputElement = document.querySelector('#fileInput');
    fileInput.click();
}


/**
 * Estructura HTML de una archivo anexado.
 *
 * @param file Archivo a mapear.
 */
const attachedFileView = (file: File) => `
    <div class="file">
        <i class="material-icons" onclick="unattachFile('${file.name}');">close</i>
        <p class="name">${file.name}</p>
    </div>`;


/**
 * Al seleccionar uno o más archivos desde el selector del navegador,
 * estos archivos son agregados al objeto que mantiene un control de todos
 * los archivos anexados al mensaje actual.
 */
(document.querySelector('#fileInput') as HTMLInputElement).oninput = () => {
    const fileInput: HTMLInputElement = document.querySelector('#fileInput');

    Array.from(fileInput.files).forEach(f => attachedFiles[f.name] = f);

    updateAttachedFilesUI();
};


/**
 * Actualiza la parte de la UI encargada de mostrar los archivos
 * anexados al mensaje actual.
 */
const updateAttachedFilesUI = () => {
    const attachedFilesContainer = document.querySelector('#attachedFilesContainer');
    const attachedFilesListView = document.querySelector('#attachedFilesListView');

    if (Object.keys(attachedFiles).length == 0)  {
        attachedFilesContainer.classList.add('hidden-container');
        return;
    }

    attachedFilesContainer.classList.remove('hidden-container');

    attachedFilesListView.innerHTML = '';
    Object.keys(attachedFiles).forEach(k => {
        attachedFilesListView.innerHTML += attachedFileView(attachedFiles[k]);
    });
}


/**
 * Quita de la lista de archivos anexados un archivo.
 *
 * @param fileNameKey Nombre del archivo a eliminar.
 */
const unattachFile = (fileNameKey: string) => {
    if (delete attachedFiles[fileNameKey]) {
        console.log(`unattaching ${fileNameKey}`);
        updateAttachedFilesUI();
    }
}

/* ================================================================================================

    Enviar mensajes.

================================================================================================ */
/**
 * Desencadena el proceso que envía un mensaje, además de anexarle
 * los archivos necesarios (si es que lo requiere)/
 */
const sendMessage = () => {
    const messageView: HTMLTextAreaElement = document.querySelector('#messageView') as HTMLTextAreaElement;
    const msg: string = messageView.value.trim();

    if (msg == '' || !openedConversationEmail)
        return;

    let xhr = new XMLHttpRequest();
    xhr.open('post', `/sendMessage`, true);

    xhr.onload = () => {
        const response = JSON.parse(xhr.response);

        if (response['code'] < 1) {
            alert(response['message']);
            return;
        }

        // Limpiar escritor.
        messageView.value = '';
        Object.keys(attachedFiles).forEach(k => delete attachedFiles[k]);
        updateAttachedFilesUI();

        triggerChatRetrieval();
    };

    let data: FormData = new FormData();
    data.append('content', msg);
    data.append('toEmail', openedConversationEmail);

    let fileIdx: number = 0;
    Object.keys(attachedFiles).forEach(key => {
        data.append(`file${fileIdx}`, attachedFiles[key]);

        ++fileIdx;
    });

    xhr.send(data);
}


/* ================================================================================================

    Búsqueda de usuarios

================================================================================================ */
/**
 * Estructura HTML para mostrar mensajes, sobre todo, de error.
 * @param msg Mensaje a mostrar.
 */
const searchMessageView = (msg: string) => `
    <div class="message">
        <i class="material-icons">person_add_disabled</i>
        <p>${msg}</p>
    </div> `;


/**
 * Representa en HTML un resultado de búsqueda.
 *
 * @param resultObject Objeto a mapear.
 */
const searchResultView = (resultObject: Object) => `
    <div class="contactSearchResult" onclick="changeChat('${resultObject['email']}');" title="Abrir conversación con ${resultObject['nombre']}">
        <i class="material-icons">add_comment</i>
        <div class="info-container">
            <p class="name">${resultObject['nombre']}</p>
            <p class="email">${resultObject['email']}</p>
        </div>
    </div>`;


/**
 * Limpia el buscador, además de esconder el panel de resultados.
 */
const clearSearchInput = () => {
    const searchResultsContainer = document.querySelector('#searchResultsContainer');
    const conversationsListView = document.querySelector('#conversationsListView');
    const inputView = document.querySelector('#searchUserInputView') as HTMLInputElement

    conversationsListView.classList.remove('hidden-container');
    searchResultsContainer.classList.add('hidden-container');
    inputView.value = '';
}


/**
 * Se encarga de hace la búsqueda de usuarios del SIGER cada vez
 * que el input de búsqueda es editado.
 */
(document.querySelector('#searchUserInputView') as HTMLInputElement).oninput = () => {
    const searchResultsContainer = document.querySelector('#searchResultsContainer');
    const conversationsListView = document.querySelector('#conversationsListView');

    const query = (document.querySelector('#searchUserInputView') as HTMLInputElement).value.trim();

    if (query == '') {
        conversationsListView.classList.remove('hidden-container');
        searchResultsContainer.classList.add('hidden-container');
        return;
    }

    let xhr = new XMLHttpRequest();
    xhr.open('get', `/buscarEnChat?q=${encodeURI(query)}`, true);

    xhr.onload = () => {
        const response = JSON.parse(xhr.response);

        searchResultsContainer.innerHTML = '';
        if (response['code'] < 1) {
            searchResultsContainer.innerHTML = searchMessageView(response['message']);
        } else {
            (response['object'] as Object[]).forEach(o => {
                searchResultsContainer.innerHTML += searchResultView(o);
            })
        }

        conversationsListView.classList.add('hidden-container');
        searchResultsContainer.classList.remove('hidden-container');
    };

    xhr.send();
};


/* ================================================================================================

    Misceláneo.

================================================================================================ */
/**
 * Copia al portapapeles el correo electrónico del chat abierto.
 */
const copyEmail = () => {
    const emailInputView: HTMLInputElement = document.getElementById('emailInputView') as HTMLInputElement;

    emailInputView.focus();
    emailInputView.select();
    emailInputView.setSelectionRange(0, 99999);

    try {
        document.execCommand('copy');
        alert('Correo copiado al portapapeles');
    } catch (e) {
        alert(`Ocurrió un error: ${e.toString()}`);
    }
}


/**
 * Quita el mensaje por defecto y muestra la ventana
 * de conversación.
 */
const toggleConversationDisplay = () => {
    if (openedConversationEmail) {
        const noOpenConversationView = document.querySelector('#noOpenConversationView');
        const messagesSideView = document.querySelector('#messagesSideView');

        noOpenConversationView.classList.add('hidden-container');
        messagesSideView.classList.remove('hidden-container');
    }
}


/**
 * Abre una conversación.
 *
 * @param contactEmail Correo electrónico del contacto cuyo chat se abrirá.
 */
const changeChat = (contactEmail: string) => {
    // Limpia el cuadro de escritura.
    (document.querySelector('#messageView') as HTMLTextAreaElement).value = '';
    Object.keys(attachedFiles).forEach(k => delete attachedFiles[k]);
    updateAttachedFilesUI();

    openedConversationEmail = contactEmail;
    clearSearchInput();
    triggerChatRetrieval(() => {
        const messagesContainer = document.querySelector('#messagesContainer');
        messagesContainer.scrollTop = messagesContainer.scrollHeight;

        toggleConversationDisplay();
    });
}


/**
 * Desencadena todo el proceso para cargar un chat en
 * pantalla, además de encargarse de hacer la petición
 * para actualizar dicho chat cada cierto tiempo.
 */
const triggerChatRetrieval = async (onDone: () => void = () => {}) => {
    try {
        if (openedConversationEmail) {
            const conversationObject = await getConversationWith(openedConversationEmail);
            displayConversation(conversationObject);
        }
        const listObject = await getConversationsList();
        displayConversationsList(listObject);

        onDone();
    } catch (error) {
        alert(error);
        window.open('/home', '_self');
    }
}


/**
 * Se encarga de actualizar la conversación abierta cada
 * cierto tiempo.
 *
 * TODO: Mejorar esto.
 */
const updateChat = () => {
    triggerChatRetrieval();
    setTimeout(() => updateChat(), 2000);
}
updateChat();


/**
 * Se encarga de cargar el chat abierto a través de la URL.
 */
triggerChatRetrieval(() => toggleConversationDisplay());
