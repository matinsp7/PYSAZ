let address
const compatibility = document.getElementById("compatibility")
const userData = localStorage.getItem("userData")
const result = JSON.parse(userData)


compatibility.addEventListener("click", function(e)
{   
    e.preventDefault()

    if(result["isVIP"] != "")
    {
        window.location.href = "/compatibility"
    }

    else
    {   
        console.log(result)
        message.style.display = "block"
        message.style.backgroundColor = "#EC407A"
        message.style.color = "#212121"
        message.innerHTML = "this is for VIP users only"
        setTimeout(function(){message.style.display = "none"}, 2000) 
    }
})

async function setValueInHtml()
{   
    
    const userData = localStorage.getItem("userData")
    const result = JSON.parse(userData)
    const userResult = result["user"]
    const isVIP = result["isVIP"]
    const numOfIntr = result["NumberOfIntroduction"]
    const token = result["token"]
    
    const values = document.getElementsByClassName("values")
    // const valuess = document.getElementsByClassName("valuess")
    
    values[0].innerHTML = userResult["FirstName"]
    values[1].innerHTML = userResult["LastName"]
    values[2].innerHTML = userResult["PhoneNumber"]
    values[3].innerHTML = userResult["RefferalCode"]
    values[4].innerHTML = userResult["WalletBalance"]
    values[5].innerHTML = userResult["TimeStamp"]
    values[6].innerHTML = numOfIntr
    console.log("lolo: ", await conutGiftCodes())
    values[8].innerHTML = await conutGiftCodes()

    if (isVIP === '') {
        values[9].innerHTML = "You are not VIP"
        values[9].style.color = "red"
        const infos = document.getElementsByClassName ("info")
        const btn = document.createElement('button')
        btn.className = 'VIPBtn'
        btn.innerHTML = "Become a VIP"
        infos[9].append(btn)
        values[7].innerHTML = 0
    }
    else {
        values[9].innerHTML = "You are VIP until"
        values[9].style.color = "green"
        const infos = document.getElementsByClassName ("info")
        const EXDate = document.createElement('span')
        EXDate.innerHTML = isVIP
        EXDate.style.color = "green"
        infos[9].append(EXDate)
        const res = await fetch("/user/monthlyBounes", {
            method: "GET",
            headers: {"Authorization": token} 
        })
        console.log("ggg", res.status)
        if (res.status === 200)
        {
            a = await res.json()
            // console.log("mmm", a["monthlyBonus"])
            values[7].innerHTML = a["monthlyBonus"]
        }
        else {
            console.log("lll98po")
        }
    }
}

async function getAddress()
{   

    const url = "/user/getAddress"
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

function setAddress(address)
{   

    const container = document.getElementById("table")
    
    // console.log(address)
    
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

async function getDisCodes () {
    const url = "/user/getDisCodes"
    const token = result["token"]


    try
    {
        const response = await fetch(url, {
            method: "GET",
            headers: {"Authorization": token} 
        })

        if (response.status === 200)
        {   
            codes = await response.json()
            setDisCodes (codes)
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
        console.log(error) 
        message.style.display = "inline"
        message.style.backgroundColor = "#EC407A"
        message.style.color = "#212121"
        message.innerHTML = error
        setTimeout(function(){message.style.display = "none"}, 2000)
    }
}

async function setDisCodes (codes) {
    // console.log(codes)
    // console.log(codes["codes"])
    const codeList = codes["codes"]
    // console.log(codeList[0])
    // console.log(codeList[0].Code)

    const container = document.getElementById("codeTable")

    for (let key in codeList){

        console.log("key: ", key)

        const openTr = document.createElement("tr")

        
        const Code = document.createElement("td")
        const Amount = document.createElement("td")
        const Code_limit = document.createElement("td")
        const Usage_count = document.createElement("td")
        const Expiration_date = document.createElement("td")


        Code.innerHTML = codeList[key].Code
        Amount.innerHTML = codeList[key].Amount
        if (codeList[key].Code_limit === null) {
            Code_limit.innerHTML = "No limit"
        }
        else {
            Code_limit.innerHTML = codeList[key].Code_limit
        }
        Usage_count.innerHTML = codeList[key].Usage_count
        Expiration_date.innerHTML = codeList[key].Expiration_date

        openTr.append(Code, Amount, Code_limit, Usage_count, Expiration_date)

        container.append(openTr)
        
    }
}

async function getCarts() {
    const url = "/user/getShoppingCart"

    const token = result["token"]

    try {

        const response = await fetch(url, {
            method: "GET",
            headers: {"Authorization": token} 
        })

        if (response.status === 200) {   
            carts = await response.json()
            setCarts(carts)
        }
    
        else
        {   
            const result = await response.json()
            message.style.display = "inline"
            message.style.backgroundColor = "#EC407A"
            message.style.color = "#212121"
            message.innerHTML = result["error"]
            console.assert.log(result["error"])
            setTimeout(function(){message.style.display = "none"}, 2000) 
        }

    } catch(error) {
        console.log(error) 
        message.style.display = "inline"
        message.style.backgroundColor = "#EC407A"
        message.style.color = "#212121"
        message.innerHTML = error
        setTimeout(function(){message.style.display = "none"}, 2000)
    }

}

async function setCarts (carts) {
    // console.log(201)
    // console.log(carts)
    // console.log(carts["carts"])
    const cartList = carts["carts"]
    // console.log(codeList[0])
    // console.log(codeList[0].Code)

    const container = document.getElementById("shopTable")

    for (let key in cartList){

        // console.log("key: ", key)

        const openTr = document.createElement("tr")

        
        const number = document.createElement("td")
        const status = document.createElement("td")


        number.innerHTML = cartList[key].number
        // const tdTable = document.get("order-table")
        if (cartList[key].status === "active") {
            status.innerHTML = "active"
            status.style.backgroundColor = "green"
        }
        else if (cartList[key].status === "locked"){
            status.innerHTML = "locked"
            status.style.backgroundColor = "blue"
        }
        else {
            status.innerHTML = "blocked"
            status.style.backgroundColor = "red"
        }

        openTr.append(number, status)

        container.append(openTr)
        
    }
}


function setBaskets(baskets)
{
    const flipcarts = document.getElementsByClassName("flip-cards")
    const NoOrder = document.getElementById("NoOrder")
    
    let counter = 0;   
    const values = document.getElementsByClassName("values-flip-cards") 
    
    
    for(let key in baskets)
    {   
            
        NoOrder.style.display = "none"
        flipcarts[key - 1].style.display = "block"  

        values[counter].innerHTML = baskets[key]["time"]
        counter++
        values[counter].innerHTML = baskets[key]["price"]
        counter++
        values[counter].innerHTML = baskets[key]["number"]
        counter++

        const back = document.getElementsByClassName("flip-card-back")

        const len = baskets[key]["products"].length * 60
        
        // console.log(baskets[key]["products"].length * 75)
        // console.log(len)

        if (baskets[key]["products"].length >= 3)
        {   
            // back.style.height = "400px"
            back[key - 1].style.height = len + "px"
        } 

        let cc = 1

        for(let product in baskets[key]["products"])
        {   
            // console.log(baskets[key]["products"][0]["brand"])
            const h5 = document.createElement("h5")
            h5.style.textAlign = "left"
            h5.style.fontWeight = "500"
            h5.style.fontSize = "15px"
            h5.innerHTML = cc + ". " + baskets[key]["products"][product]["number"] + " * " + baskets[key]["products"][product]["brand"] + " " + baskets[key]["products"][product]["model"] + 
            " " + " " + baskets[key]["products"][product]["price"]
            
            back[key - 1].append(h5)
            cc++
        }
    }
}

async function getBaskets() {
    
    const url = "/user/getBaskets"

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
            

            if (result["error"] == null){setBaskets(result)}
    
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

    const url = "/user/getBasketInfo"

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
            console.log("salam",result)
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


async function conutGiftCodes() {
    console.log("joooo")
    const url = "/user/conutGiftCodes"

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
            const result = await response.json()
            console.log("mongol: ", result["conut_gift_codes"])
            return result["conut_gift_codes"]
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

async function addAddress(Province, Remainder) {

    const url = "/user/addAddress"
    const token = result["token"]


    try
    {
        const response = await fetch(url, {
            method:"POST",
            headers: {"Authorization": token},
            body: JSON.stringify({province: Province, remainder: Remainder})
        })

        if (response.status != 200)
        {   
            console.log("khar")
            const result = await response.json()
            message.style.display = "inline"
            message.style.backgroundColor = "#EC407A"
            message.style.color = "#212121"
            message.innerHTML = result["error"]
            setTimeout(function(){message.style.display = "none"}, 2000) 
        }

        else
        {
            console.log("sag")
        }
    }

    catch(error)
    {

        message.style.display = "inline"
        message.style.backgroundColor = "#EC407A"
        message.style.color = "#212121"
        message.innerHTML = result["error"]
        setTimeout(function(){message.style.display = "none"}, 2000) 
    }
    
}

async function editInformation(FirstName, LastName, PhoneNumber) {
    
    const url = "/user/editInforamtion" 
    const token = result["token"]

    try
    {
        const response = await fetch(url, {
            method: "POST",
            headers: {"Authorization": token},
            body: JSON.stringify({firstname: FirstName, lastname: LastName, phonenumber: PhoneNumber})
        })

        if(response.status != 200)
        {   
            const result = await response.json()
            alert(result["error"])
        }
    }

    catch(error)
    {
        message.style.display = "inline"
        message.style.backgroundColor = "#EC407A"
        message.style.color = "#212121"
        message.innerHTML = result["error"]
        setTimeout(function(){message.style.display = "none"}, 2000) 
    }
}

getAddress()
getDisCodes()
getCarts()
setValueInHtml()
getBaskets()

// Get the modal, button, and close elements
const modal = document.getElementById("addressModal");
const btn = document.getElementById("btn_addAddress");
const span = document.getElementsByClassName("close")[1];

const editModal = document.getElementById("edditModal")
const btnEdit = document.getElementById("btn_eddit")
const editClose = document.getElementsByClassName("close")[0]


// When the user clicks the button, open the modal
btn.onclick = function() {
    modal.style.display = "flex";
}

// When the user clicks on <span> (x), close the modal
span.onclick = function() {
    closeModal();
}

// When the user clicks anywhere outside the modal, close it
window.onclick = function(event) {
    if (event.target == editModal) {
        closeModal()
    }
}

// Save button functionality
document.getElementById("saveButton").onclick = function() {
    const province = document.getElementById("province").value;
    const remainder = document.getElementById("remainder").value
    alert("your Address succesfully added!")
    addAddress(province, remainder)
    closeModal() // Close the modal after saving
}

document.getElementById("editSaveButton").onclick = function(){
    const firstname = document.getElementsByClassName("edit")[0].value
    const lastname = document.getElementsByClassName("edit")[1].value
    const phonenumber = document.getElementsByClassName("edit")[2].value

    editInformation(firstname, lastname, phonenumber)
    closeEditModal()
}   

function closeModal() {
    modal.classList.add("closing"); // Add closing class for fade-out animation
    setTimeout(() => {
        modal.style.display = "none"; // Hide the modal after animation
        modal.classList.remove("closing"); // Remove closing class
    }, 300); // Match the duration of the fade-out animation (300ms)
}

function closeEditModal(){
    editModal.classList.add("closing")
    setTimeout(() => {
        editModal.style.display = "none"
        editModal.classList.remove("closing")
    }, 300);
}

btnEdit.onclick = function(){
    editModal.style.display = "flex"
}

editClose.onclick = function(){
    closeEditModal()
}

window.onclick = function(event){
    if(event.target == modal)
    {
        closeEditModal()
    }
}



