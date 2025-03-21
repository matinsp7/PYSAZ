const message = document.getElementById("message")
let result = null

document.getElementById("btn_login").addEventListener("click", function(event){
    const info = document.getElementsByTagName("input")
    sendPostRequest(info[0].value, info[1].value)   
})

async function sendPostRequest(phoneNumber, password) {
    const url = '/user/login'

    try {
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({PhoneNumber: phoneNumber, Password: password})
        })
        
        if(response.status === 200)
        {
            result = await response.json();

            message.style.display = "inline"
            message.style.backgroundColor = "#4DB6AC"
            message.style.color = "#006064"
            message.innerHTML = "login is successful!"
            setTimeout(function(){message.style.display = "none"}, 3000)      

            localStorage.setItem('userData', JSON.stringify(result))

    
            setTimeout(function(){window.location.href = "/client"}, 500)
        }

        else 
        {   
            const err = await response.json();
            message.style.display = "inline"
            message.style.backgroundColor = "#EC407A"
            message.style.color = "#212121"
            message.innerHTML = err["message"]
            setTimeout(function(){message.style.display = "none"}, 2000)      


        }

        
    } catch (error) {
        console.error('Error:', error);
    }

}
