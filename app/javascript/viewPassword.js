const togglePasswordButtons = document.querySelectorAll('.togglePassword');

togglePasswordButtons.forEach((toggleButton) => {
    toggleButton.addEventListener('click', function () {
        const passwordInput = this.previousElementSibling;
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);
        this.querySelector('i').className = type === 'password' ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye';
    });
});
