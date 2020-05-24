const uploader: HTMLDivElement = document.querySelector('#uploader');
const fileInputView: HTMLInputElement = document.querySelector('#fileInputView');
const fileNameView: HTMLParagraphElement = document.querySelector('#fileNameView');
const goBackButton: HTMLButtonElement = document.querySelector('#goBackButton');
const uploadButton: HTMLButtonElement = document.querySelector('#uploadButton');

uploader.onclick = () => fileInputView.click();

const anexar = (file) => new Promise((resolve, reject) => {
    let xhr = new XMLHttpRequest();
    xhr.open('post', `/anexarCartaAceptacion`, true);
    // xhr.setRequestHeader('Content-type', 'application/binary');

    let postData = new FormData();
    postData.append('file', file);
    
    xhr.onload = () => {
        const response = JSON.parse(xhr.response);

        if (response['code'] != 1) {
            reject(response['message']);
            return;
        }
        
        resolve(response['object']);
    };
    
    xhr.send(postData);
});

let img: File;
fileInputView.onchange = () => {
    if (!/image\/[A-z]+/.test(fileInputView.files[0].type)) {
        alert('Solo se admiten archivos de imagen');
        return;
    }

    img = fileInputView.files[0];
    fileNameView.innerHTML = img.name;
}

uploadButton.onclick = () => {
    if (!img) {
        alert('Por favor, seleccione una fotografía de su carta de aceptación')
        return;
    }

    anexar(img).then(obj => {
        alert("Se ha subido la carta de aceptación con éxito");
        window.open('/home', '_self');
    }).catch(error => {
        alert(error);
    });
}
