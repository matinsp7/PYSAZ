

function setValueInHtml()
{   

    const userData = localStorage.getItem('userData');

    const result = JSON.parse(userData);
    const values = document.getElementsByClassName("values")
    
    values[0].innerHTML = result["FirstName"]
    values[1].innerHTML = result["LastName"]
    values[2].innerHTML = result["PhoneNumber"]
    values[3].innerHTML = result["RefferalCode"]
    values[4].innerHTML = result["WalletBalance"]
    values[5].innerHTML = result["TimeStamp"]
}

setValueInHtml()
