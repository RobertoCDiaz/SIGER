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
let openedConversationEmail = urlGetParameters['open'] ?? 'noOpenedChat';


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


/* ================================================================================================

    Clases.

================================================================================================ */

class Message {
    id: number;
    content: string;
    date: Date;
    remitent_email: string;
    remitent_fullname: string;
    receiver_email: string;
    receiver_fullname: string;
    isMine: boolean;

    constructor(obj: Object, receiverEmail: string) {
        this.id = obj['id'];
        this.content = obj['contenido'];
        this.date = new Date(Number(obj['timestamp']));
        this.remitent_email = obj['remitente_email'];
        this.remitent_fullname = obj['nombre_email1'];
        this.receiver_email = obj['destinatario_email'];
        this.receiver_fullname = obj['nombre_email2'];

        this.isMine = this.receiver_email == receiverEmail;
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
            const displayDate = `${d.getDate()} / ${d.getMonth()} / ${d.getFullYear()}`;

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
    <p class="content">
        ${msg.content}
    </p>
    <p class="hour prevent-selection">${twoDigits(msg.date.getHours())}:${twoDigits(msg.date.getMinutes())}</p>
</div>
`

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
        (conversation[0][date] as Message[]).forEach(msg => {
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
    <div onclick="changeChat('${convObj['contacto_email']}')" class="contact">
        <p class="name">${convObj['contacto_nombre']}</p>
        <p class="message" title="${convObj['contenido']}">
            <i class="material-icons">call_${convObj['enviado'] == 1 ? "made" : "received"}</i>
            ${convObj['contenido'].substring(0, 30)}${convObj['contenido'].substring(0, 30).length == 30 ? "..." : ""}
        </p>
    </div>`;
};


/* ================================================================================================

    Enviar mensajes.

================================================================================================ */
const sendMessage = () => {
    const messageView: HTMLTextAreaElement = document.querySelector('#messageView') as HTMLTextAreaElement;
    const msg: string = messageView.value.trim();

    if (msg == '')
        return;
    
    let xhr = new XMLHttpRequest();
    xhr.open('post', `/sendMessage`, true);
    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    
    xhr.onload = () => {
        const response = JSON.parse(xhr.response);
        
        if (response['code'] < 1) {
            alert(response['message']);
            return;
        }

        messageView.value = '';
        triggerChatRetrieval();
    };

    xhr.send(`content=${encodeURI(msg)}&toEmail=${encodeURI(openedConversationEmail)}`);
}


/* ================================================================================================

    Misceláneo.

================================================================================================ */
/**
 * Abre una conversación.
 * 
 * @param contactEmail Correo electrónico del contacto cuyo chat se abrirá.
 */
const changeChat = (contactEmail: string) => {
    // Limpia el cuadro de escritura.
    (document.querySelector('#messageView') as HTMLTextAreaElement).value = '';

    openedConversationEmail = contactEmail;
    triggerChatRetrieval();
}


/**
 * Desencadena todo el proceso para cargar un chat en 
 * pantalla, además de encargarse de hacer la petición
 * para actualizar dicho chat cada cierto tiempo.
 * 
 * @param email Correo del otro usuario.
 */
const triggerChatRetrieval = async () => {
    const email = openedConversationEmail;
    if (!email)
        return;

    try {
        const conversationObject = await getConversationWith(email);
        const listObject = await getConversationsList();

        displayConversation(conversationObject);
        displayConversationsList(listObject);
    } catch (error) {
        alert(error);
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
triggerChatRetrieval();
