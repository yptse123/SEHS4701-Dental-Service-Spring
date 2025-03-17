document.addEventListener('DOMContentLoaded', function() {
    // Initialize date picker
    const today = new Date();
    const maxDate = new Date();
    maxDate.setDate(today.getDate() + 30); // Allow booking 30 days in advance
    
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
    
    // Highlight selected clinic in the table
    document.getElementById('clinicId').addEventListener('change', function() {
        const selectedClinicId = this.value;
        const clinicRows = document.querySelectorAll('.clinics-table tbody tr');
        
        clinicRows.forEach(function(row, index) {
            if (index === parseInt(selectedClinicId) - 1) {
                row.classList.add('selected-clinic');
            } else {
                row.classList.remove('selected-clinic');
            }
        });
    });
});