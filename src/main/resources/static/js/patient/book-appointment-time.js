/**
 * Book Appointment Time Selection Page JavaScript
 */
document.addEventListener('DOMContentLoaded', function() {
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
    
    // Handle time slot selection - visual feedback
    const timeSlots = document.querySelectorAll('.time-slot input[type="radio"]');
    timeSlots.forEach(function(slot) {
        slot.addEventListener('change', function() {
            // Highlight the selected time period section
            if (this.checked) {
                document.querySelectorAll('.time-period').forEach(function(period) {
                    period.classList.remove('active-period');
                });
                
                // Find parent time period and add active class
                const parentPeriod = this.closest('.time-period');
                if (parentPeriod) {
                    parentPeriod.classList.add('active-period');
                    
                    // Scroll to make sure it's visible if needed
                    parentPeriod.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                }
            }
        });
    });
    
    // Form submission handling - extract time slot values
    const appointmentForm = document.getElementById('appointmentForm');
    if (appointmentForm) {
        appointmentForm.addEventListener('submit', function(e) {
            const selectedTimeSlot = document.querySelector('input[name="timeSlot"]:checked');
            const selectedDentist = document.querySelector('input[name="dentistId"]:checked');
            const termsCheckbox = document.querySelector('input[name="terms"]');
            
            if (!selectedTimeSlot || !selectedDentist || !termsCheckbox.checked) {
                e.preventDefault();
                
                // Show error message
                let errorMessage = '';
                if (!selectedTimeSlot) {
                    errorMessage += 'Please select an appointment time. ';
                }
                if (!selectedDentist) {
                    errorMessage += 'Please select a dentist. ';
                }
                if (!termsCheckbox.checked) {
                    errorMessage += 'Please agree to the terms.';
                }
                
                // Create alert if doesn't exist
                let alert = document.querySelector('.alert.alert-danger');
                if (!alert) {
                    alert = document.createElement('div');
                    alert.className = 'alert alert-danger';
                    alert.innerHTML = `
                        <i class="fas fa-exclamation-circle"></i>
                        ${errorMessage}
                        <button type="button" class="close-alert">&times;</button>
                    `;
                    
                    const pageHeader = document.querySelector('.page-header');
                    pageHeader.parentNode.insertBefore(alert, pageHeader.nextSibling);
                    
                    // Add close functionality
                    alert.querySelector('.close-alert').addEventListener('click', function() {
                        alert.style.display = 'none';
                    });
                } else {
                    alert.innerHTML = `
                        <i class="fas fa-exclamation-circle"></i>
                        ${errorMessage}
                        <button type="button" class="close-alert">&times;</button>
                    `;
                    alert.style.display = 'flex';
                }
                
                return;
            }
            
            // Extract start time and end time from selected time slot
            const timeSlotValue = selectedTimeSlot.value;
            const [startTime, endTime] = timeSlotValue.split('|');
            
            // Add hidden fields for start and end time
            let startTimeInput = document.querySelector('input[name="startTime"]');
            if (!startTimeInput) {
                startTimeInput = document.createElement('input');
                startTimeInput.type = 'hidden';
                startTimeInput.name = 'startTime';
                appointmentForm.appendChild(startTimeInput);
            }
            startTimeInput.value = startTime;
            
            let endTimeInput = document.querySelector('input[name="endTime"]');
            if (!endTimeInput) {
                endTimeInput = document.createElement('input');
                endTimeInput.type = 'hidden';
                endTimeInput.name = 'endTime';
                appointmentForm.appendChild(endTimeInput);
            }
            endTimeInput.value = endTime;
        });
    }
});