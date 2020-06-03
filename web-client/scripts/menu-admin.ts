const populateWelcomeMessage = () => {
    let xhr = new XMLHttpRequest();
    xhr.open('get', '/user-info', true);
    
    xhr.onload = () => {
        let res = JSON.parse(xhr.response)['object'];
        document.getElementById('welcomeMessage').innerHTML = `${res['nombre']}`;
    };
    
    xhr.send();
}
populateWelcomeMessage();

const optionsContainer = document.getElementById('optionsContainer');
const optionView = (name, object) => `
    <a href="${object['href']}">
        <div class="menu-item">
            <i class="material-icons">${object['icon']}</i>
            <p>${name}</p>
        </div>
    </a>
`;
const getMenuAdmin = () => {
    let xhr = new XMLHttpRequest();
    xhr.open('get', '/getMenu', false);
    
    xhr.onload = () => {
        const response = JSON.parse(xhr.response);

        if (response.code <= 0) {
            alert(response.message);
            location.reload();
            return;
        }

        const o = response.object;

        Object.keys(o['main']).forEach(key => {
            if (key == 'Inicio') return;
            optionsContainer.innerHTML += optionView(key, o['main'][key]);
        });
        Object.keys(o['secondary']).forEach(key => {
            optionsContainer.innerHTML += optionView(key, o['secondary'][key]);
        });

    };
    
    xhr.send();
}
getMenuAdmin();