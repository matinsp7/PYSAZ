let address

function setValueInHtml()
{   

    // const userData = localStorage.getItem('userData');
    // const result = JSON.parse(userData);
    // const userResult = result["user"]

    const userData = localStorage.getItem("userData")
    const result = JSON.parse(userData)
    const userResult = result["user"]
    
    
    const values = document.getElementsByClassName("values")
    
    values[0].innerHTML = userResult["FirstName"]
    values[1].innerHTML = userResult["LastName"]
    values[2].innerHTML = userResult["PhoneNumber"]
    values[3].innerHTML = userResult["RefferalCode"]
    values[4].innerHTML = userResult["WalletBalance"]
    values[5].innerHTML = userResult["TimeStamp"]
}

function setAddress(address)
{   
    const length = Object.keys(address).length
    const container = document.getElementById("adr")

    const len = length * "50" + "px"
    container.style.height = len
    

    for (let key in  address){
        
        const span = document.createElement("span")

        span.textContent = key + "." + address[key]
        span.style.display = "block"
        span.style.marginTop = "20px"
        // span.style.color = "#616161"
        // span.style.color = "#B71C1C"
        span.style.color = "#1A237E"
        container.append(span) 
        
    }
}


async function getAddress()
{   

    const url = "http://localhost:8080/getAddress"

    const userData = localStorage.getItem("userData")
    const result = JSON.parse(userData)
    const token = result["token"]


    try
    {
        const response = await fetch(url, {
            method: "GET",
            headers: {"Authorization": token} 
        })

        if (response.status === 200)
        {   

            address = await response.json()
            setAddress(address)
        }

        else
        {
            //set a message
        }

    }

    catch
    {

    }
}

getAddress()
setValueInHtml()
