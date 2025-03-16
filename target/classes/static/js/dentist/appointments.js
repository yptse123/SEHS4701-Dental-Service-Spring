/**
 * Dentist Appointments JavaScript functionality
 */
document.addEventListener('DOMContentLoaded', function() {
    // Modal handling
    const modal = document.getElementById('statusUpdateModal');
    const modalTitle = document.getElementById('modalTitle');
    const statusForm = document.getElementById('statusUpdateForm');
    const statusInput = document.getElementById('statusInput');
    const closeBtn = document.querySelector('.close');
    const cancelBtn = document.getElementById('modalCancelBtn');
    const statusButtons = document.querySelectorAll('.status-update-btn');
    
    // Open modal when status buttons are clicked
    statusButtons.forEach(button => {
        button.addEventListener('click', function() {
            const appointmentId = this.getAttribute('data-id');
            const status = this.getAttribute('data-status');
            
            statusForm.action = `/dentist/appointments/${appointmentId}/update-status`;
            statusInput.value = status;
            
            // Format status text for display
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
    closeBtn.addEventListener('click', () => modal.style.display = 'none');
    cancelBtn.addEventListener('click', () => modal.style.display = 'none');
    
    // Close modal when clicking outside
    window.addEventListener('click', event => {
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    });
    
    // Highlight today's appointments
    const today = new Date().toISOString().split('T')[0];
    document.querySelectorAll('.appointments-table tr').forEach(row => {
        const dateCell = row.querySelector('.date-cell');
        if (dateCell) {
            const dateValue = dateCell.getAttribute('data-date');
            if (dateValue === today) {
                row.classList.add('today');
            }
        }
    });
    
    // Initialize date inputs
    const startDate = document.getElementById('startDate');
    const endDate = document.getElementById('endDate');
    
    // Set min/max constraints for dates
    if (startDate && endDate) {
        startDate.addEventListener('change', function() {
            endDate.min = this.value;
            if (endDate.value && new Date(endDate.value) < new Date(this.value)) {
                endDate.value = this.value;
            }
        });
        
        endDate.addEventListener('change', function() {
            startDate.max = this.value;
            if (startDate.value && new Date(startDate.value) > new Date(this.value)) {
                startDate.value = this.value;
            }
        });
    }
});