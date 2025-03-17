document.addEventListener('DOMContentLoaded', function() {
    const appointmentForm = document.getElementById('appointmentForm');
    const confirmButton = document.getElementById('confirmButton');
    const timeSlotInputs = document.querySelectorAll('input[name="timeSlot"]');
    
    // Handle form submission
    appointmentForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Get selected time slot
        const selectedTimeSlot = document.querySelector('input[name="timeSlot"]:checked');
        if (!selectedTimeSlot) {
            alert('Please select a time slot');
            return;
        }
        
        // Get selected dentist
        const selectedDentist = document.querySelector('input[name="dentistId"]:checked');
        if (!selectedDentist) {
            alert('Please select a dentist');
            return;
        }
        
        // Terms checkbox
        const termsChecked = document.querySelector('input[name="terms"]').checked;
        if (!termsChecked) {
            alert('Please agree to the terms');
            return;
        }
        
        // Extract start and end times from the selected time slot
        const [startTime, endTime] = selectedTimeSlot.value.split('|');
        
        // Add hidden fields for start and end times
        const startTimeInput = document.createElement('input');
        startTimeInput.type = 'hidden';
        startTimeInput.name = 'startTime';
        startTimeInput.value = startTime;
        appointmentForm.appendChild(startTimeInput);
        
        const endTimeInput = document.createElement('input');
        endTimeInput.type = 'hidden';
        endTimeInput.name = 'endTime';
        endTimeInput.value = endTime;
        appointmentForm.appendChild(endTimeInput);
        
        // Submit the form
        appointmentForm.submit();
    });
    
    // Alert close functionality
    const closeAlerts = document.querySelectorAll('.close-alert');
    closeAlerts.forEach(function(button) {
        button.addEventListener('click', function() {
            this.parentElement.style.display = 'none';
        });
    });
});