// const menu = {
//     'main': {
//         'Inicio': {
//             'href': '/home',
//             'icon': 'home'
//         },
//         'Validar residentes': {
//             'href': '/validar-residentes',
//             'icon': 'how_to_reg'
//         },
//         'Panel de residencias': {
//             'href': '/panel-residencias',
//             'icon': 'assignment'
//         },
//     },
//     'secondary': {
//         'Cerrar sesión': {
//             'href': '/logout',
//             'icon': 'exit_to_app'
//         }
//     }
// }

const getMenu: () => Promise<Object> = 
    () => new Promise((resolve, reject) => {
        let xhr = new XMLHttpRequest();
        xhr.open('get', '/getMenu', false);
        
        xhr.onload = () => {
            let response= JSON.parse(xhr.response);

            if (response.code <= 0) {
                reject(response.message);
                return;
            }

            resolve(response.object);
        };
        
        xhr.send();
    });

const menuItem = (name, o) => `
<a href="${o['href']}"><div class="menu-item">
    <i class="material-icons">${o['icon']}</i>
    <p>${name}</p>
</div></a>
`;

const menuView = (o) => {
    return `
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        :root {
            /*--menu-color: rgb(29, 34, 59);*/
            /*--menu-color: var(--footer-background);*/
            --menu-color: var(--azul-tec);
            --slide-duration: 150ms;
        }
    
        .menu-container {
            display: flex;
            flex-direction: row;
            align-items: stretch;
            transform: translateX(-6em);
            position: fixed;
            height: 100%;
            transition-duration: var(--slide-duration);
            transition-timing-function: ease;
        }
    
        .menu-bar {
            background-color: var(--menu-color);
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
        }
    
        .menu-bar * {
            color: white;
            margin: 0;
            padding: 0;
            text-align: center;
            box-sizing: border-box;
            word-wrap: break-word;
        }
    
        .menu-bar * a {
            text-decoration: none;
        }
    
        .menu-item {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: .5em;
            cursor: pointer;
            border-left: 2px solid transparent;
    
            width: 6em;
            height: 5em;
        }
    
        .menu-item > i {
            margin-bottom: .25em;
            font-size: 1.3em;
        }

        .menu-item > p {
            font-size: 12px;
        }
    
        .menu-item:hover {
            border-left: 2px solid white;
            background-color: rgba(255, 255, 255, 0.25);
        }
    
        .main-options {
            flex: 1;
        }
    
        .toggle-menu-button {
            /* content: '<i class="material-icons">burger</i>'; */
            /* content: '>>'; */
            display: flex;
            align-items: center;
        }
    
        /*.toggle-menu-button i {*/
        #toggleMenuButton {
            cursor: pointer;
            background-color: var(--menu-color);
            border-top-right-radius: 2px;
            border-bottom-right-radius: 2px;
        }
        #toggleMenuButton > i {
            color: white;
            padding: .3em;
        }
    </style>
    <div id="menuContainer" class="menu-container prevent-selection">
        <div id="menuBar" class="menu-bar">
            <div class="main-options">
                ${
                    Object.keys(o['main']).map(key => menuItem(key, o['main'][key])).join('')
                }
            </div>
            <div class="secondary-options">
                ${
                    Object.keys(o['secondary']).map(key => menuItem(key, o['secondary'][key])).join('')
                }           
            </div>
        </div>
        <div class="toggle-menu-button"><div id="toggleMenuButton"><i class="material-icons">double_arrow</i></div></div>
    </div>
    `
};

let toggleMenuButton;
let menuContainer;
let menuActive = false;

const putMenuOnDOM = async () => {
    //document.body.innerHTML += menuView(await getMenu());
    const template = document.createElement('template');
    template.innerHTML =  menuView(await getMenu());
    Array.from(template.content.children).forEach(n=>document.body.appendChild(n as Node));
    
    toggleMenuButton = document.getElementById('toggleMenuButton');
    menuContainer = document.getElementById('menuContainer');

    
    toggleMenuButton.onclick = () => {
        const menuWidth = document.getElementById('menuBar').offsetWidth;
        console.log(menuWidth * -1);
        menuContainer.style.transform = `translateX(${ !menuActive ? '0' : /*'-6em'*/ (menuWidth * -1).toString()}px)`;
        menuActive = !menuActive;
    
        (toggleMenuButton.children[0] as HTMLElement).style.transition = 'var(--slide-duration)';
        (toggleMenuButton.children[0] as HTMLElement).style.transform = `rotate(${ !menuActive ? '0deg' : '180deg'})`;
    }
}
    
putMenuOnDOM();

