var form = document.getElementById('signupForm');

if (!form) {
    form = document.getElementById('changePasswordForm');
}

form.addEventListener('submit', function (event) {
    var password = document.getElementById('password');

    if (!password) {
        var password = document.getElementById('current_password');
    }

    const passwordValue = password.value;

    var passwordHelpBlock = document.getElementById('passwordHelpBlock');
    passwordHelpBlock.style.marginBottom = "5px";

    // Regular expression to match the password requirements
    var passwordPattern = /^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{8,20}$/;

    console.log(passwordPattern.test(passwordValue))


    if (!passwordPattern.test(passwordValue)) {
        event.preventDefault();
        passwordHelpBlock.textContent = "Your password must be 8-20 characters long, contain letters and numbers, and must not contain spaces, special characters, or emoji.";
        passwordHelpBlock.style.color = 'red';
    } else {
        passwordHelpBlock.style.color = 'black';
    }
});
