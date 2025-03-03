document.addEventListener('DOMContentLoaded', function () {
    const signUpLink = document.getElementById('signUpBtn');
    const loginLink = document.getElementById("loginBtn")
    const expLink = document.getElementById('cta-button')

    signUpLink.addEventListener('click', function (event) {
        event.preventDefault();
        window.location.href = "/signup";
    });

    loginLink.addEventListener("click", function(event){
        event.preventDefault()
        window.location.href = "/login"
    })

    expLink.addEventListener("click", function(event){
        console.log("B clicked")
        event.preventDefault()
        window.location.href = "/explore"
    })


});