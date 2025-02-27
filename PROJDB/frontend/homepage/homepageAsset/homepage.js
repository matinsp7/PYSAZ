document.addEventListener('DOMContentLoaded', function () {
    const signUpLink = document.getElementById('signUpBtn');
    const loginLink = document.getElementById("loginBtn")

    signUpLink.addEventListener('click', function (event) {
        event.preventDefault();
        window.location.href = "/signup";
    });

    loginLink.addEventListener("click", function(event){
        event.preventDefault()
        window.location.href = "/login"
    })

});