document.addEventListener("DOMContentLoaded", function () {
    const currentPassword = document.getElementById('current_password');
    const newPassword = document.getElementById('new_password');
    const confirmPassword = document.getElementById('confirm_password');
    const messageDisplay = document.getElementById('password_message');
    const changePasswordBtn = document.getElementById('change_password_btn');

    function validateForm() {
        const passwordsMatch = newPassword.value === confirmPassword.value;
        const allFieldsFilled = currentPassword.value && newPassword.value && confirmPassword.value;

        if (!passwordsMatch) {
            messageDisplay.textContent = 'Passwords do not match!';
            confirmPassword.classList.add('error-border');
        } else {
            messageDisplay.textContent = '';
            confirmPassword.classList.remove('error-border');
        }

        // Enable the button only if all fields are filled and passwords match
        changePasswordBtn.disabled = !allFieldsFilled || !passwordsMatch;
    }

    // Attach the validateForm function to keyup events
    currentPassword.addEventListener('keyup', validateForm);
    newPassword.addEventListener('keyup', validateForm);
    confirmPassword.addEventListener('keyup', validateForm);
});
