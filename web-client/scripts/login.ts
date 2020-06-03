            const loginemailView = document.getElementById('emailView') as HTMLInputElement;
            const loginpassView = document.getElementById('passView') as HTMLInputElement;
            const submitButton = document.getElementById('submitButtonView');
            submitButton.onclick = () =>{
                if(
                    loginemailView.value.trim() == "" ||
                    loginpassView.value == ""
                ){
                    alert("Por favor, llene todos los campos.");
                    return;
                }

                let userClass;

                if (new RegExp('L[0-9]{8}@piedrasnegras\.tecnm\.mx').test(loginemailView.value.trim())) {
                    userClass = 1;
                } else if (new RegExp('[A-z]+\.[A-z]{2}@piedrasnegras\.tecnm\.mx').test(loginemailView.value.trim())) {
                    userClass = 2;
                }


                let xhr = new XMLHttpRequest();
                xhr.open('POST','/auth',true);
                xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                
                xhr.onreadystatechange = () => {
                    if(xhr.readyState==4 && xhr.status==200){
                        const response = JSON.parse(xhr.responseText);

                        if (response.code < 0) {
                            alert(response['message']);
                            return;
                        }

                        if (response.code == 1) {
                            window.open('/home', '_self');
                            return;
                        }
                    }
                };
                xhr.send(
                    `email=${encodeURI(loginemailView.value.trim())}&` +
                    `pass=${encodeURI(loginpassView.value)}&` +
                    `class=${encodeURI(userClass)}`
                );
            };