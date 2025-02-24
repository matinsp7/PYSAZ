let address
const message = document.getElementById("message")
function setValueInHtml()
{   

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
    let len = 0

    if (length <= 1){ len = length * "100" + "px"}
    
    else{len = length * "50" + "px"}
    
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

    const url = "http://localhost:8080/user/getAddress"

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
            const result = await response.json()
            message.style.display = "inline"
            message.style.backgroundColor = "#EC407A"
            message.style.color = "#212121"
            message.innerHTML = result["error"]
            setTimeout(function(){message.style.display = "none"}, 2000) 
        }

    }

    catch(error)
    {
        message.style.display = "inline"
        message.style.backgroundColor = "#EC407A"
        message.style.color = "#212121"
        message.innerHTML = error
        setTimeout(function(){message.style.display = "none"}, 2000) 
    }
}

async function setBaskets() {
    
    const url = "http://localhost:8080/user/basketShop"

    const userData = localStorage.getItem("userData")
    const result = JSON.parse(userData)
    const token = result["token"]

    try
    {
        const response = await fetch(url, {
            method: "POST",
            headers: {"Authorization": token} 
        })

        if (response.status === 200)
        {   
            const result = await response.json()
            console.log(result)
        }
    }

    catch(error)
    {
        message.style.display = "inline"
        message.style.backgroundColor = "#EC407A"
        message.style.color = "#212121"
        message.innerHTML = error
        setTimeout(function(){message.style.display = "none"}, 2000)
    }
}

async function getBasketInfo(){

    const url = "http://localhost:8080/user/getBasketInfo"

    const userData = localStorage.getItem("userData")
    const result = JSON.parse(userData)
    const token = result["token"]

    try
    {
        const response = await fetch(url, {
            method: "POST",
            headers: {"Authorization": token} 
        })

        if (response.status === 200)
        {   
            const result = await response.json()
            console.log(result)
        }

        else
        {   
            const result = await response.json()
            message.style.display = "inline"
            message.style.backgroundColor = "#EC407A"
            message.style.color = "#212121"
            message.innerHTML = result["error"]
            setTimeout(function(){message.style.display = "none"}, 2000)        
        }
    }

    catch(error)
    {
        message.style.display = "inline"
        message.style.backgroundColor = "#EC407A"
        message.style.color = "#212121"
        message.innerHTML = error
        setTimeout(function(){message.style.display = "none"}, 2000)
    }
}

async function getCompatible()
{   
    const url = "http://localhost:8080/compatiblityFinder/ramMotherBoard"

    const userData = localStorage.getItem("userData")
    const result = JSON.parse(userData)
    const token = result["token"]

    try
    {
        const response = await fetch(url, {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify({model:"ModelQ", brand: "BrandA", src: "Motherboard_ID", dest:"RAM_ID"})
        })

        if (response.status === 200)
        {   
            const result = await response.json()
            
            for(let number in result)
            {   
                console.log(number+":",result[number]["brand"], result[number]["model"])
            }
        }

        else
        {
            const result = await response.json()
            message.style.display = "inline"
            message.style.backgroundColor = "#EC407A"
            message.style.color = "#212121"
            message.innerHTML = result["error"]
            setTimeout(function(){message.style.display = "none"}, 2000)  
        }
    }

    catch(error)
    {
        message.style.display = "inline"
        message.style.backgroundColor = "#EC407A"
        message.style.color = "#212121"
        message.innerHTML = error
        setTimeout(function(){message.style.display = "none"}, 2000)
    }
}

getAddress()
setValueInHtml()
getBasketInfo()
setBaskets()
getCompatible()