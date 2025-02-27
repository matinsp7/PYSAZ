// const flipcarts = document.getElementsByClassName("flip-cards")

// flipcarts[0].style.display = "block"
// // flipcarts[2].style.display = "block"
// // flipcarts[3].style.display = "block"

// const ordermess = document.getElementById("NoOrder")
// ordermess.style.display = "none"

// const backCart = document.getElementsByClassName("flip-card-back")

// backCart[0].style.height = "300px"

// number = 5
// pname = "CPU"
// price = 1000


// const h5 = document.createElement("h5")
// h5.style.position = "relative"
// h5.style.textAlign = "left"
// h5.style.fontSize = "14px"
// h5.style.paddingTop = "10px"
// h5.style.marginLeft = "10px"
// h5.innerText = number + " * " + pname + price

// backCart[0].append(h5)



let address
// const message = document.getElementById("message")

function setValueInHtml()
{   

    const userData = localStorage.getItem("userData")
    const result = JSON.parse(userData)
    const userResult = result["user"]

    console.log(userResult)
    
    
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
    const container = document.getElementById("table")
    let len = 0
    
    console.log(address)
    
    for (let key in  address){

        const openTr = document.createElement("tr")

        
        const number = document.createElement("td")
        const province = document.createElement("td")
        const remainder = document.createElement("td")


        number.innerHTML = key
        province.innerHTML = address[key]["province"]
        remainder.innerHTML = address[key]["remainder"]

        openTr.append(number, province, remainder)

        container.append(openTr)
        
    }
}

function setBaskets(baskets)
{
    const flipcarts = document.getElementsByClassName("flip-cards")
    const NoOrder = document.getElementById("NoOrder")
    NoOrder.style.display = "none"

    let counter = 0;  

    
    for(let key in baskets)
    {   
        flipcarts[key - 1].style.display = "block"  

        const values = document.getElementsByClassName("values-flip-cards")
        // values[counter]
        values[counter].innerHTML = baskets[key]["time"]
        counter++
        values[counter].innerHTML = baskets[key]["price"]
        counter++
        values[counter].innerHTML = baskets[key]["number"]

        const back = document.getElementsByClassName("flip-card-back")

        const len = baskets[key]["products"].length * 60
        
        // console.log(baskets[key]["products"].length * 75)
        console.log(len)

        if (baskets[key]["products"].length >= 3)
        {   
            // back.style.height = "400px"
            back[key - 1].style.height = len + "px"
        } 

        for(let product in baskets[key]["products"])
        {   
            // console.log(baskets[key]["products"][0]["brand"])
            const h5 = document.createElement("h5")
            h5.style.textAlign = "left"
            h5.style.fontWeight = "500"
            h5.style.fontSize = "15px"
            h5.innerHTML = product + ". " + baskets[key]["products"][product]["number"] + " * " + baskets[key]["products"][product]["brand"] + " " + baskets[key]["products"][product]["model"] + 
            " " + " " + baskets[key]["products"][product]["price"]
            
            back[key - 1].append(h5)
        }
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

async function getBaskets() {
    
    const url = "http://localhost:8080/user/getBaskets"

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
            setBaskets(result)
        }

        else 
        {
            message.style.display = "inline"
            message.style.backgroundColor = "#EC407A"
            message.style.color = "#212121"
            message.innerHTML = error
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
        console.log(error)
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
// getBasketInfo()
getBaskets()
// getCompatible()


