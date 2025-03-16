document.addEventListener('DOMContentLoaded', function() {
    // Modal handling
    const modal = document.getElementById('statusUpdateModal');
    const updateStatusBtn = document.getElementById('updateStatusBtn');
    const closeBtn = document.querySelector('.close');
    const cancelBtn = document.getElementById('modalCancelBtn');
    
    // Open modal when update status button is clicked
    if (updateStatusBtn) {
        updateStatusBtn.addEventListener('click', function() {
            modal.style.display = 'flex';
        });
    }
    
    // Close modal
    closeBtn.addEventListener('click', () => modal.style.display = 'none');
    cancelBtn.addEventListener('click', () => modal.style.display = 'none');
    
    // Close modal when clicking outside
    window.addEventListener('click', event => {
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    });
    
    // Alert close button handling
    const alertCloseBtn = document.querySelector('.close-alert');
    if (alertCloseBtn) {
        alertCloseBtn.addEventListener('click', function() {
            this.parentElement.style.display = 'none';
        });
    }
    
    // Auto-hide alerts after 5 seconds
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            alert.style.display = 'none';
        });
    }, 5000);
});