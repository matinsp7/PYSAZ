document.addEventListener('DOMContentLoaded', function () {
    const signUpLink = document.getElementById('signUpBtn');

    signUpLink.addEventListener('click', function (event) {
        event.preventDefault();
        window.location.href = "/signup";
    });
});