const message = document.getElementById("message")
let result = null

function getInformation()
{
    const info = document.getElementsByTagName("input")

    sendPostRequest(info[0].value, info[1].value)
}


async function sendPostRequest(PhoneNumber, Password) {
    const url = 'http://localhost:8080/user/login'

    try {
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.parse(PhoneNumber, Password)
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

    
            setTimeout(function(){window.location.href = "../clientpage/page.html"}, 500)
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

        // return result
        
    } catch (error) {
        console.error('Error:', error);
    }

}

// fetchData()