document.addEventListener('DOMContentLoaded', function () {
    // Add password form validation
    const passwordForm = document.querySelector('form[action*="update-password"]');
    if (passwordForm) {
        passwordForm.addEventListener('submit', function (e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            if (newPassword !== confirmPassword) {
                e.preventDefault();

                // Show error message
                const errorDiv = document.createElement('div');
                errorDiv.className = 'alert alert-danger';
                errorDiv.textContent = 'Passwords do not match';

                // Remove any existing error messages
                const existingErrors = document.querySelectorAll('.alert-danger');
                existingErrors.forEach(el => el.remove());

                // Insert error before the form
                passwordForm.parentNode.insertBefore(errorDiv, passwordForm);

                // Scroll to error
                errorDiv.scrollIntoView({ behavior: 'smooth' });
            }
        });
    }
});