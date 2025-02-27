let firstName
let lastName
let phoneNumber
let password
let errorMessage 
document.getElementById('signupForm').addEventListener('submit', function (e) {

    console.log('salam')
    e.preventDefault(); // Prevent form submission

    firstName = document.getElementById('firstName').value.trim();
    lastName = document.getElementById('lastName').value.trim();
    phoneNumber = document.getElementById('phoneNumber').value.trim();
    password = document.getElementById('password').value.trim();
    errorMessage = document.getElementById('errorMessage');

    // Clear previous error message
    errorMessage.textContent = '';
    errorMessage.style.display = 'none';

    // if (!phoneNumber || !/^\d{11}$/.test(phoneNumber)) {
    //     showError('Please enter a valid 10-digit phone number.');
    //     return;
    // }

    console.log('khoobi')
    if (postSignupForm() == 1) {
        this.reset(); // Reset the form
    }
});

function showError(message) {
    const errorMessage = document.getElementById('errorMessage');
    errorMessage.textContent = message;
    errorMessage.style.display = 'block';
}

async function postSignupForm()
{   
    console.log('33')
    // an endpoint on the server that handles user registration
    const url = "/signup"

    try
    {
        // This part sends the user's signup data to the server using the fetch function
        const respone = await fetch(url, {
            method:"POST",
            headers:{"Content-Type":"application/json"},
            body:JSON.stringify({FirstName:firstName, LastName:lastName, PhoneNumber:phoneNumber, Password:password})
        })

        console.log('44')

        const result = await respone.json()
        console.log(result)
        
        if (respone.status == 200)
        {
            return 1;
        }

        else if (respone.status == 409) {
            showError("Phone number already exists.");
        }

        return 0;
    }

    catch(error)
    {
        console.log(error)
    }
}
