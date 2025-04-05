document.addEventListener('DOMContentLoaded', function() {
    // Setup popovers for appointment details
    const appointments = document.querySelectorAll('.weekly-appointment');
    const popover = document.getElementById('appointmentPopover');
    const popoverClose = document.querySelector('.popover-close');
    const popoverTime = document.getElementById('popoverTime');
    const popoverPatient = document.getElementById('popoverPatient');
    const popoverClinic = document.getElementById('popoverClinic');
    const popoverStatus = document.getElementById('popoverStatus');
    const popoverViewLink = document.getElementById('popoverViewLink');
    
    appointments.forEach(appointment => {
        appointment.addEventListener('click', function(event) {
            event.preventDefault();
            
            // Get appointment data
            const appointmentId = this.getAttribute('data-id');
            const timeText = this.querySelector('.weekly-appointment-time').textContent;
            const patientText = this.querySelector('.weekly-appointment-patient').textContent;
            
            // Fetch additional data if needed via AJAX
            // For now, we'll just use what we have
            
            // Populate popover
            popoverTime.textContent = timeText;
            popoverPatient.textContent = patientText;
            popoverViewLink.href = `/dentist/appointments/${appointmentId}`;
            
            // Calculate position
            const rect = this.getBoundingClientRect();
            popover.style.top = `${rect.top + window.scrollY}px`;
            popover.style.left = `${rect.right + 10 + window.scrollX}px`;
            
            // Show popover
            popover.classList.add('active');
        });
    });
    
    // Close popover
    popoverClose.addEventListener('click', function() {
        popover.classList.remove('active');
    });
    
    // Close popover when clicking outside
    document.addEventListener('click', function(event) {
        if (!popover.contains(event.target) && !event.target.closest('.weekly-appointment')) {
            popover.classList.remove('active');
        }
    });
});