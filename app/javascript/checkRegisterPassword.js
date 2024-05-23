document.getElementById('signupForm').addEventListener('submit', function(event) {
    var password = document.getElementById('password').value;
    var passwordHelpBlock = document.getElementById('passwordHelpBlock');

    // Regular expression to match the password requirements
    var passwordPattern = /^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{8,20}$/;


    if (!passwordPattern.test(password)) {
        event.preventDefault();
        passwordHelpBlock.textContent = "Your password must be 8-20 characters long, contain letters and numbers, and must not contain spaces, special characters, or emoji.";
        passwordHelpBlock.style.color = 'red';
    } else {
        passwordHelpBlock.style.color = 'black';
    }
});