/**
 * Book Appointment Time Selection Page JavaScript
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log("Book appointment time script loaded");
    
    // Get form and critical elements
    const appointmentForm = document.getElementById('appointmentForm');
    const clinicIdField = document.getElementById('clinicIdField');
    
    // Log initial clinic ID value
    console.log("Initial clinic ID value:", clinicIdField ? clinicIdField.value : "not found");
    
    // Setup time slot selection
    setupTimeSlotSelection();
    
    // Setup form submission
    if (appointmentForm) {
        appointmentForm.addEventListener('submit', function(e) {
            // Prevent default form submission temporarily
            e.preventDefault();
            
            // Get required form fields
            const selectedTimeSlot = document.querySelector('input[name="timeSlot"]:checked');
            const selectedDentist = document.querySelector('input[name="dentistId"]:checked');
            const termsCheckbox = document.querySelector('input[name="terms"]');
            
            // Validate all required fields
            let errorMessage = '';
            
            // Check clinic ID
            if (!clinicIdField || !clinicIdField.value || clinicIdField.value.trim() === '') {
                errorMessage += 'Missing clinic information. Please use the "Fix ID" button. ';
                console.error("Missing clinic ID!");
            } else {
                console.log("Using clinic ID:", clinicIdField.value);
            }
            
            // Check other required fields
            if (!selectedTimeSlot) errorMessage += 'Please select an appointment time. ';
            if (!selectedDentist) errorMessage += 'Please select a dentist. ';
            if (!termsCheckbox || !termsCheckbox.checked) errorMessage += 'Please agree to the terms. ';
            
            // If any validation errors, show alert and stop submission
            if (errorMessage) {
                alert(errorMessage.trim());
                return;
            }
            
            // Process time slot data
            const timeSlotValue = selectedTimeSlot.value;
            const timeParts = timeSlotValue.split('|');
            
            if (timeParts.length === 2) {
                // Get or create the hidden time fields
                let startTimeField = document.querySelector('input[name="startTime"]');
                let endTimeField = document.querySelector('input[name="endTime"]');
                
                // If fields don't exist, create them
                if (!startTimeField) {
                    startTimeField = document.createElement('input');
                    startTimeField.type = 'hidden';
                    startTimeField.name = 'startTime';
                    appointmentForm.appendChild(startTimeField);
                }
                
                if (!endTimeField) {
                    endTimeField = document.createElement('input');
                    endTimeField.type = 'hidden';
                    endTimeField.name = 'endTime';
                    appointmentForm.appendChild(endTimeField);
                }
                
                // Set the values
                startTimeField.value = timeParts[0];
                endTimeField.value = timeParts[1];
                
                console.log("Set start time:", startTimeField.value);
                console.log("Set end time:", endTimeField.value);
            }
            
            // Show form data before submission
            const formData = new FormData(appointmentForm);
            console.log("=== FORM SUBMISSION VALUES ===");
            for (const [name, value] of formData.entries()) {
                console.log(`${name}: ${value}`);
            }
            console.log("===============================");
            
            // Show loading state on button
            const submitBtn = document.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = `<i class="fas fa-spinner fa-spin"></i> Processing...`;
            }
            
            // Submit the form
            console.log("Submitting form...");
            appointmentForm.submit();
        });
    } else {
        console.error("Appointment form not found!");
    }
    
    // Make recoverClinicId function available globally
    window.recoverClinicId = function() {
        const clinicId = prompt("Enter the clinic ID:", "");
        if (clinicId && !isNaN(clinicId)) {
            if (clinicIdField) {
                clinicIdField.value = clinicId;
                console.log("Manually set clinic ID to:", clinicId);
                
                // Update visual display
                const clinicIdValue = document.getElementById('clinicIdValue');
                if (clinicIdValue) {
                    clinicIdValue.textContent = `(ID: ${clinicId})`;
                    clinicIdValue.style.color = '#2e7d32';
                }
                
                alert("Clinic ID has been set to: " + clinicId);
            } else {
                alert("Error: Could not find clinic ID field in the form");
            }
        } else {
            alert("Invalid clinic ID. Please enter a valid number.");
        }
    };
});

/**
 * Setup time slot selection behavior
 */
function setupTimeSlotSelection() {
    const timeSlots = document.querySelectorAll('.time-slot input[type="radio"]');
    timeSlots.forEach(function(slot) {
        slot.addEventListener('change', function() {
            if (this.checked) {
                document.querySelectorAll('.time-period').forEach(function(period) {
                    period.classList.remove('active-period');
                });
                
                const parentPeriod = this.closest('.time-period');
                if (parentPeriod) {
                    parentPeriod.classList.add('active-period');
                }
            }
        });
    });
}