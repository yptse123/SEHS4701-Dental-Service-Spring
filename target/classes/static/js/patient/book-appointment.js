/**
 * Book Appointment Page JavaScript
 */
document.addEventListener('DOMContentLoaded', function() {
    // Initialize date picker
    const today = new Date();
    const maxDate = new Date();
    maxDate.setDate(today.getDate() + 90); // Allow booking 30 days in advance
    
    flatpickr("#appointmentDate", {
        minDate: "today",
        maxDate: maxDate,
        dateFormat: "Y-m-d",
        disable: [
            function(date) {
                // Disable Sundays
                return date.getDay() === 0;
            }
        ],
        locale: {
            firstDayOfWeek: 1 // Start week on Monday
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
    
    // Handle clinic selection
    const clinicSelect = document.getElementById('clinicId');
    const clinicRows = document.querySelectorAll('.clinics-table tbody tr');
    
    if (clinicSelect && clinicRows.length > 0) {
        // When dropdown selection changes
        clinicSelect.addEventListener('change', function() {
            const selectedClinicId = this.value;
            
            // Remove selection from all rows
            clinicRows.forEach(row => row.classList.remove('selected-clinic'));
            
            // Add selection to the chosen row
            if (selectedClinicId) {
                clinicRows.forEach((row, index) => {
                    if (index === parseInt(selectedClinicId) - 1) {
                        row.classList.add('selected-clinic');
                        // Scroll to the row if needed
                        row.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                });
            }
        });
        
        // Allow clicking on table rows to select a clinic
        clinicRows.forEach((row, index) => {
            row.addEventListener('click', function() {
                const clinicId = index + 1;
                clinicSelect.value = clinicId;
                
                // Trigger change event to update UI
                const event = new Event('change', { bubbles: true });
                clinicSelect.dispatchEvent(event);
                
                // Focus on date picker after selecting clinic
                setTimeout(() => {
                    document.getElementById('appointmentDate').click();
                }, 300);
            });
        });
    }
    
    // Form validation
    const bookingForm = document.querySelector('form[action*="/select-date"]');
    if (bookingForm) {
        bookingForm.addEventListener('submit', function(e) {
            const clinicId = document.getElementById('clinicId').value;
            const appointmentDate = document.getElementById('appointmentDate').value;
            
            if (!clinicId || !appointmentDate) {
                e.preventDefault();
                
                // Create alert if doesn't exist
                let alert = document.querySelector('.alert.alert-danger');
                if (!alert) {
                    alert = document.createElement('div');
                    alert.className = 'alert alert-danger';
                    alert.innerHTML = `
                        <i class="fas fa-exclamation-circle"></i>
                        Please select both a clinic and an appointment date.
                        <button type="button" class="close-alert">&times;</button>
                    `;
                    
                    const pageHeader = document.querySelector('.page-header');
                    pageHeader.parentNode.insertBefore(alert, pageHeader.nextSibling);
                    
                    // Add close functionality
                    alert.querySelector('.close-alert').addEventListener('click', function() {
                        alert.style.display = 'none';
                    });
                }
                
                alert.style.display = 'flex';
                
                // Auto-hide after 5 seconds
                setTimeout(function() {
                    alert.style.display = 'none';
                }, 5000);
                
                // Highlight missing fields
                if (!clinicId) {
                    document.getElementById('clinicId').focus();
                } else if (!appointmentDate) {
                    document.getElementById('appointmentDate').click();
                }
            }
        });
    }
});