
function openNav() {
    document.getElementById("mySidenav").style.width = "300px";
    document.getElementById("mySidenav").style.borderRight = "2px solid white"
    //document.getElementById("main").style.marginLeft = "250px";
    document.body.style.backgroundColor = "rgba(0,0,0,0.4)";
    
    }

    
    function closeNav() {
    document.getElementById("mySidenav").style.width = "0";
    document.getElementById("mySidenav").style.borderRight = "0px"
    //document.getElementById("main").style.marginLeft = "0";
    document.body.style.backgroundColor = "#EAEAEA";
    
    }