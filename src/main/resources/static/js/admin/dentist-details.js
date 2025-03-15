document.addEventListener('DOMContentLoaded', function() {
    // Initialize the modal functionality
    initModal();

    // Initialize any other features specific to dentist details
});

function initModal() {
    // Get modal elements
    const modal = document.getElementById('addClinicModal');
    const modalTrigger = document.querySelector('[data-toggle="modal"]');
    const closeButtons = document.querySelectorAll('[data-dismiss="modal"]');
    
    // Show modal function
    function showModal() {
        if (modal) {
            modal.style.display = 'flex';
            modal.classList.add('show');
            document.body.style.overflow = 'hidden'; // Prevent scrolling
        }
    }
    
    // Hide modal function
    function hideModal() {
        if (modal) {
            modal.style.display = 'none';
            modal.classList.remove('show');
            document.body.style.overflow = ''; // Re-enable scrolling
        }
    }
    
    // Modal trigger
    if (modalTrigger) {
        modalTrigger.addEventListener('click', function(e) {
            e.preventDefault();
            showModal();
        });
    }
    
    // Close buttons
    closeButtons.forEach(button => {
        button.addEventListener('click', hideModal);
    });
    
    // Close on click outside
    window.addEventListener('click', function(e) {
        if (e.target === modal) {
            hideModal();
        }
    });
    
    // Form validation
    const addClinicForm = document.getElementById('addClinicForm');
    if (addClinicForm) {
        addClinicForm.addEventListener('submit', function(e) {
            const clinicSelect = document.getElementById('clinicId');
            if (!clinicSelect.value) {
                e.preventDefault();
                alert('Please select a clinic');
            }
        });
    }
}