document.addEventListener('DOMContentLoaded', function() {
    // Initialize the modal functionality
    initModal();

    // Initialize any other features specific to dentist details
    // Modal handling
    const scheduleModal = document.getElementById('scheduleModal');
    const addScheduleBtn = document.getElementById('addScheduleBtn');
    const closeModalButtons = document.querySelectorAll('[data-dismiss="modal"]');
    const saveScheduleBtn = document.getElementById('saveScheduleBtn');
    const scheduleForm = document.getElementById('scheduleForm');
    const validationMsg = document.getElementById('scheduleValidationMsg');
    
    // CSRF token for AJAX requests
    const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute('content');
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');
    
    // Show modal for adding new schedule
    addScheduleBtn.addEventListener('click', function() {
        document.getElementById('scheduleModalTitle').textContent = 'Add Schedule';
        scheduleForm.reset();
        document.getElementById('scheduleId').value = '';
        validationMsg.classList.add('d-none');
        showModal(scheduleModal);
    });
    
    // Close modal handlers
    closeModalButtons.forEach(button => {
        button.addEventListener('click', function() {
            hideModal(scheduleModal);
        });
    });
    
    // Handle clicks outside the modal
    window.addEventListener('click', function(event) {
        if (event.target === scheduleModal) {
            hideModal(scheduleModal);
        }
    });
    
    // Edit schedule button handlers
    document.querySelectorAll('.edit-schedule-btn').forEach(button => {
        button.addEventListener('click', function() {
            const scheduleId = this.getAttribute('data-schedule-id');
            const clinicId = this.getAttribute('data-clinic-id');
            const dayOfWeek = this.getAttribute('data-day');
            const startTime = this.getAttribute('data-start');
            const endTime = this.getAttribute('data-end');
            
            document.getElementById('scheduleModalTitle').textContent = 'Edit Schedule';
            document.getElementById('scheduleId').value = scheduleId;
            document.getElementById('clinicId').value = clinicId;
            document.getElementById('dayOfWeek').value = dayOfWeek;
            document.getElementById('startTime').value = formatTimeForInput(startTime);
            document.getElementById('endTime').value = formatTimeForInput(endTime);
            
            validationMsg.classList.add('d-none');
            showModal(scheduleModal);
        });
    });
    
    // Delete schedule button handlers
    document.querySelectorAll('.delete-schedule-btn').forEach(button => {
        button.addEventListener('click', function() {
            if (confirm('Are you sure you want to delete this schedule?')) {
                const scheduleId = this.getAttribute('data-schedule-id');
                deleteSchedule(scheduleId);
            }
        });
    });
    
    // Save schedule button handler
    saveScheduleBtn.addEventListener('click', function() {
        if (validateScheduleForm()) {
            const formData = new FormData(scheduleForm);
            const scheduleId = formData.get('scheduleId');
            
            if (scheduleId) {
                updateSchedule(Object.fromEntries(formData));
            } else {
                createSchedule(Object.fromEntries(formData));
            }
        }
    });
    
    // Form validation
    function validateScheduleForm() {
        const startTime = document.getElementById('startTime').value;
        const endTime = document.getElementById('endTime').value;
        const clinicId = document.getElementById('clinicId').value;
        const dayOfWeek = document.getElementById('dayOfWeek').value;
        
        if (!clinicId || !dayOfWeek || !startTime || !endTime) {
            showValidationError('Please fill in all fields');
            return false;
        }
        
        if (startTime >= endTime) {
            showValidationError('Start time must be before end time');
            return false;
        }
        
        return true;
    }
    
    function showValidationError(message) {
        validationMsg.textContent = message;
        validationMsg.classList.remove('d-none');
    }
    
    // AJAX functions for CRUD operations
    function createSchedule(scheduleData) {
        fetch('/admin/schedules', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                [csrfHeader]: csrfToken
            },
            body: JSON.stringify(scheduleData)
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            hideModal(scheduleModal);
            // Refresh the page to show the new schedule
            location.reload();
        })
        .catch(error => {
            showValidationError('Error saving schedule: ' + error.message);
        });
    }
    
    function updateSchedule(scheduleData) {
        fetch('/admin/schedules/' + scheduleData.scheduleId, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
                [csrfHeader]: csrfToken
            },
            body: JSON.stringify(scheduleData)
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            hideModal(scheduleModal);
            // Refresh the page to show the updated schedule
            location.reload();
        })
        .catch(error => {
            showValidationError('Error updating schedule: ' + error.message);
        });
    }
    
    function deleteSchedule(scheduleId) {
        fetch('/admin/schedules/' + scheduleId, {
            method: 'DELETE',
            headers: {
                [csrfHeader]: csrfToken
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            // Remove the row from the table
            const row = document.querySelector(`tr[data-schedule-id="${scheduleId}"]`);
            if (row) {
                row.remove();
                
                // Check if we need to show the "no schedules" message
                const remainingRows = document.querySelectorAll('#scheduleTable tbody tr:not(#no-schedules-row)');
                if (remainingRows.length === 0) {
                    const noSchedulesRow = `
                        <tr id="no-schedules-row">
                            <td colspan="5" class="no-results">
                                <i class="fas fa-calendar-times"></i>
                                No schedules found for this dentist
                            </td>
                        </tr>
                    `;
                    document.querySelector('#scheduleTable tbody').innerHTML = noSchedulesRow;
                }
            }
        })
        .catch(error => {
            alert('Error deleting schedule: ' + error.message);
        });
    }
    
    // Helper functions for modals
    function showModal(modal) {
        modal.style.display = 'block';
        modal.classList.add('show');
        document.body.classList.add('modal-open');
    }
    
    function hideModal(modal) {
        modal.style.display = 'none';
        modal.classList.remove('show');
        document.body.classList.remove('modal-open');
    }
    
    // Format time from HH:MM:SS to HH:MM for input fields
    function formatTimeForInput(timeString) {
        if (!timeString) return '';
        // Handle both HH:MM:SS and HH:MM formats
        const parts = timeString.split(':');
        return parts.length >= 2 ? `${parts[0]}:${parts[1]}` : timeString;
    }
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