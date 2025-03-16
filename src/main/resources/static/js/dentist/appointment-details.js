document.addEventListener('DOMContentLoaded', function() {
    // Modal handling
    const modal = document.getElementById('statusUpdateModal');
    const modalTitle = document.getElementById('modalTitle');
    const statusForm = document.getElementById('statusUpdateForm');
    const statusInput = document.getElementById('statusInput');
    const updateStatusBtn = document.getElementById('updateStatusBtn');
    const closeBtn = document.querySelector('.close');
    const cancelBtn = document.getElementById('modalCancelBtn');
    const statusButtons = document.querySelectorAll('.status-update-btn');
    
    // Open modal when status buttons are clicked
    if (updateStatusBtn) {
        updateStatusBtn.addEventListener('click', function() {
            modal.style.display = 'flex';
        });
    }
    
    // Open modal with specific status when quick action buttons are clicked
    statusButtons.forEach(button => {
        button.addEventListener('click', function() {
            const status = this.getAttribute('data-status');
            
            statusInput.value = status;
            
            let statusText = status.toLowerCase().replace('_', ' ');
            statusText = statusText.charAt(0).toUpperCase() + statusText.slice(1);
            modalTitle.textContent = `Mark Appointment as ${statusText}`;
            
            // Customize modal styling based on status
            const modalContent = document.querySelector('.modal-content');
            modalContent.className = 'modal-content'; // Reset classes
            
            if (status === 'COMPLETED') {
                modalContent.classList.add('status-completed');
                document.getElementById('modalConfirmBtn').textContent = "Mark as Completed";
            } else if (status === 'NO_SHOW') {
                modalContent.classList.add('status-no-show');
                document.getElementById('modalConfirmBtn').textContent = "Mark as No-Show";
            }
            
            modal.style.display = 'flex';
        });
    });
    
    // Close modal
    if (closeBtn) {
        closeBtn.addEventListener('click', function() {
            modal.style.display = 'none';
        });
    }
    
    if (cancelBtn) {
        cancelBtn.addEventListener('click', function() {
            modal.style.display = 'none';
        });
    }
    
    // Close modal when clicking outside
    window.addEventListener('click', function(event) {
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    });
    
    // Alert close functionality
    const closeAlerts = document.querySelectorAll('.close-alert');
    closeAlerts.forEach(function(button) {
        button.addEventListener('click', function() {
            this.parentElement.style.display = 'none';
        });
    });
    
    // Auto-hide alerts after 5 seconds
    setTimeout(function() {
        document.querySelectorAll('.alert').forEach(function(alert) {
            alert.style.display = 'none';
        });
    }, 5000);
});