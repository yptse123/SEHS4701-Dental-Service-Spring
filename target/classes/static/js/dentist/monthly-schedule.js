document.addEventListener('DOMContentLoaded', function() {
    // Handle clicks on appointments
    const appointments = document.querySelectorAll('.month-appointment');
    appointments.forEach(appointment => {
        appointment.addEventListener('click', function() {
            const appointmentId = this.getAttribute('data-id');
            window.location.href = `/admin/appointments/${appointmentId}`;
        });
    });
    
    // Handle clicks on "more" indicators
    const moreIndicators = document.querySelectorAll('.month-more-indicator');
    moreIndicators.forEach(indicator => {
        indicator.addEventListener('click', function() {
            const date = this.getAttribute('data-date');
            window.location.href = `/dentist/schedule?view=daily&date=${date}`;
        });
    });
});