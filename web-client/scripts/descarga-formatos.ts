/**
 * Desencadena el proceso de petición al server por un archivo,
 * además de comenzar la descarga una vez se obtenga una respuesta.
 * 
 * @param output        Nombre que se le dará al archivo a descargar. DEBE agregar la extensión. 
 *                      La mayoría de navegadores dejan al usuario final cambiar este nombre.
 * 
 * @param httpPetition  Petición que hará que el server regrese el archivo.
 */
const getDocument = (output: string, httpPetition: string)  => {
    let xhr = new XMLHttpRequest();
    xhr.responseType = 'blob';
    xhr.open('get', httpPetition, true);
    
    xhr.onload = () => {
        try {
            if (!xhr.response.message) {
                throw "Es archivo";
                return;
            }
            alert(xhr.response.message);
        } catch(e) {
            downloadFile(xhr.response, `${output}`);
        }
    };
    
    xhr.send();
}

const downloadFile = (blob, fileName) => {
    const link = document.createElement('a');

    link.href = URL.createObjectURL(blob);
    link.download = fileName;

    document.body.append(link);

    link.click();

    link.remove();
    window.addEventListener('focus', e => URL.revokeObjectURL(link.href), {once:true});
};
