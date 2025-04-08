function initializeDentistScheduleDisplay() {
    const dentistOptions = document.querySelectorAll('.dentist-option');

    dentistOptions.forEach(option => {
        const scheduleDisplay = option.querySelector('.schedule-time');
        if (scheduleDisplay) {
            try {
                // Safely parse JSON with better error handling
                let scheduleData = [];
                try {
                    const rawData = option.dataset.schedule || '[]';
                    scheduleData = JSON.parse(rawData);
                    console.log("Raw schedule data:", rawData);
                    console.log("Parsed schedule data:", scheduleData);
                } catch (parseError) {
                    console.error('Error parsing schedule JSON:', parseError);
                    scheduleData = [];
                }

                if (Array.isArray(scheduleData) && scheduleData.length > 0) {
                    const times = scheduleData.map(schedule => {
                        const startTime = formatTime(schedule.startTime ? schedule.startTime.substring(0, 5) : '');
                        const endTime = formatTime(schedule.endTime ? schedule.endTime.substring(0, 5) : '');
                        return `${startTime} - ${endTime}`;
                    });
                    scheduleDisplay.textContent = times.join(', ');
                } else {
                    scheduleDisplay.textContent = 'Schedule not available';
                    console.log('No schedule data found for dentist');
                }
            } catch (e) {
                console.error('Error displaying schedule:', e);
                scheduleDisplay.textContent = 'Schedule not available';
            }
        }
    });
}

// Make sure formatTime is correctly implemented and doesn't have syntax errors
function formatTime(timeStr) {
    if (!timeStr) return '';
    const [hours, minutes] = timeStr.split(':');
    let h = parseInt(hours);
    const ampm = h >= 12 ? 'PM' : 'AM';
    h = h % 12;
    h = h ? h : 12; // Convert 0 to 12
    return `${h}:${minutes} ${ampm}`;
}

document.addEventListener('DOMContentLoaded', function () {
    // Add this to the beginning of the DOMContentLoaded function
    const style = document.createElement('style');
    style.textContent = `
        .dentist-option.disabled {
            opacity: 0.7;
            position: relative;
            pointer-events: auto; /* Allow clicks to see details */
        }
        
        .dentist-option.disabled::after {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.05);
            border-radius: 4px;
        }
        
        .dentist-option.disabled label {
            cursor: not-allowed;
        }
        
        .unavailable-reason {
            font-size: 12px;
            color: #dc3545;
            font-style: italic;
            margin-top: 5px;
        }
    `;
    document.head.appendChild(style);

    // Get important elements
    const timeSlotInputs = document.querySelectorAll('input[name="timeSlot"]');
    const dentistOptions = document.querySelectorAll('.dentist-option');
    const appointmentForm = document.getElementById('appointmentForm');

    // Store initial dentist data
    const dentistData = [];
    dentistOptions.forEach(option => {
        const input = option.querySelector('input');
        const dentistId = input.value;

        // Add debug output to help diagnose the issue
        console.log(`Dentist ${dentistId} schedule data:`, option.dataset.schedule);

        dentistData.push({
            id: dentistId,
            element: option,
            scheduleData: safeParseJson(option.dataset.schedule),
            appointmentData: safeParseJson(option.dataset.appointments)
        });
    });

    // Initialize - filter dentists based on clinic and date
    filterDentistsByClinicAndDate();

    // Add event listeners to time slot inputs
    timeSlotInputs.forEach(input => {
        input.addEventListener('change', function() {
            if (this.checked) {
                const startTime = this.dataset.start;
                const endTime = this.dataset.end;
                
                // Update hidden fields
                document.querySelector('input[name="startTime"]').value = startTime;
                document.querySelector('input[name="endTime"]').value = endTime;
                
                // Filter dentists based on selected time slot but keep all visible
                filterDentistsByTimeSlot(startTime, endTime);
            }
        });
    });

    // Function to filter dentists based on clinic and date
    function filterDentistsByClinicAndDate() {
        const clinicId = document.getElementById('clinicIdField').value;
        const appointmentDate = document.querySelector('input[name="appointmentDate"]').value;
        const dayOfWeek = getDayOfWeek(appointmentDate);

        // Show loading state
        setDentistSectionLoading(true);

        // Check each dentist
        dentistData.forEach(dentist => {
            const isAvailable = dentistWorksAtClinicOnDay(dentist, clinicId, dayOfWeek);
            toggleDentistVisibility(dentist, isAvailable);
        });

        // Update UI state
        updateDentistSelectionUI();
        setDentistSectionLoading(false);
    }

    // Function to filter dentists based on time slot
    function filterDentistsByTimeSlot(startTime, endTime) {
        const clinicId = document.getElementById('clinicIdField').value;
        const appointmentDate = document.querySelector('input[name="appointmentDate"]').value;
        const dayOfWeek = getDayOfWeek(appointmentDate);

        // Show loading state
        setDentistSectionLoading(true);

        // Deselect all dentists first
        deselectAllDentists();

        // Check each dentist - SHOW ALL who work that day but disable those not available at the time
        dentistData.forEach(dentist => {
            // First check if dentist works on this day at this clinic
            const worksOnDay = dentistWorksAtClinicOnDay(dentist, clinicId, dayOfWeek);

            if (worksOnDay) {
                // Dentist works today, now check if available at the specific time
                const worksOnTime = dentistWorksAtTime(dentist, clinicId, startTime, endTime);
                const isBooked = hasDentistBookingConflict(dentist, appointmentDate, startTime, endTime);

                // Show the dentist but disable if not available at this specific time
                toggleDentistVisibility(dentist, true); // Always show

                if (!worksOnTime || isBooked) {
                    // Make it disabled but visible and add reason
                    dentist.element.classList.add('disabled');
                    dentist.element.querySelector('input').disabled = true;

                    // Add reason why unavailable
                    const reasonEl = dentist.element.querySelector('.unavailable-reason') ||
                        createUnavailableReasonElement();

                    if (!worksOnTime) {
                        reasonEl.textContent = "Not available at this time";
                    } else if (isBooked) {
                        reasonEl.textContent = "Already booked";
                    }

                    dentist.element.appendChild(reasonEl);
                } else {
                    // Available at this time
                    dentist.element.classList.remove('disabled');
                    dentist.element.querySelector('input').disabled = false;

                    // Remove reason if exists
                    const reasonEl = dentist.element.querySelector('.unavailable-reason');
                    if (reasonEl) reasonEl.remove();
                }
            } else {
                // Doesn't work today at all - hide completely
                toggleDentistVisibility(dentist, false);
            }
        });

        // Update UI state - but don't hide all dentists
        updateDentistSelectionUIWithoutHiding();
        setDentistSectionLoading(false);
    }

    // Create unavailable reason element
    function createUnavailableReasonElement() {
        const el = document.createElement('div');
        el.className = 'unavailable-reason';
        el.style.fontSize = '12px';
        el.style.color = '#dc3545';
        el.style.fontStyle = 'italic';
        el.style.marginTop = '5px';
        return el;
    }

    // Modified UI update function that doesn't hide all dentists
    function updateDentistSelectionUIWithoutHiding() {
        const availableDentists = document.querySelectorAll('.dentist-option:not(.disabled)');
        const dentistContainer = document.querySelector('.dentist-selection');

        // Always show dentist container
        dentistContainer.style.display = 'flex';

        // Remove empty state if it exists
        const empty = document.querySelector('.dentist-selection + .empty-state');
        if (empty) empty.remove();

        // If no dentists are available, show a message but keep them visible
        if (availableDentists.length === 0) {
            const messageEl = document.querySelector('.no-available-dentists-message') || createNoAvailableDentistsMessage();
            if (!document.querySelector('.no-available-dentists-message')) {
                dentistContainer.parentNode.insertBefore(messageEl, dentistContainer.nextSibling);
            }
        } else {
            // Dentists available - remove message if exists
            const messageEl = document.querySelector('.no-available-dentists-message');
            if (messageEl) messageEl.remove();
        }
    }

    // Create message for when no dentists are available at the selected time
    function createNoAvailableDentistsMessage() {
        const div = document.createElement('div');
        div.className = 'no-available-dentists-message alert-info';
        div.style.padding = '10px';
        div.style.marginTop = '10px';
        div.style.borderRadius = '4px';
        div.style.backgroundColor = '#cff4fc';
        div.style.color = '#055160';
        div.innerHTML = `
        <i class="fas fa-info-circle"></i>
        <span style="margin-left: 8px;">No dentists are available for the selected time slot. You can select a different time or choose a different day.</span>
    `;
        return div;
    }

    // Helper function to determine day of week from date
    function getDayOfWeek(dateString) {
        const date = new Date(dateString);
        const days = ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'];
        return days[date.getDay()];
    }

    // Check if dentist works at the clinic on a specific day
    function dentistWorksAtClinicOnDay(dentist, clinicId, dayOfWeek) {
        // If no schedule data, assume the dentist is available
        // (since they're in the UI, they must work at this clinic)
        if (!dentist.scheduleData || !Array.isArray(dentist.scheduleData) || dentist.scheduleData.length === 0) {
            console.log(`No schedule data for dentist ${dentist.id} - assuming available`);
            return true;
        }

        // Check if dentist has a schedule entry for this clinic and day
        return dentist.scheduleData.some(schedule => {
            return schedule && schedule.clinicId == clinicId && schedule.dayOfWeek === dayOfWeek;
        });
    }

    // Check if dentist works at the specified time
    function dentistWorksAtTime(dentist, clinicId, startTime, endTime) {
        if (!dentist.scheduleData || !Array.isArray(dentist.scheduleData)) {
            return false;
        }

        // Check if the selected time slot falls within any of dentist's working hours
        return dentist.scheduleData.some(schedule => {
            if (schedule.clinicId != clinicId) return false;

            // Convert times to minutes for easier comparison
            const scheduleStart = convertTimeToMinutes(schedule.startTime);
            const scheduleEnd = convertTimeToMinutes(schedule.endTime);
            const slotStart = convertTimeToMinutes(startTime);
            const slotEnd = convertTimeToMinutes(endTime);

            // Time slot must be fully contained within schedule
            return slotStart >= scheduleStart && slotEnd <= scheduleEnd;
        });
    }

    // Check if the dentist already has a booking that conflicts
    function hasDentistBookingConflict(dentist, date, startTime, endTime) {
        if (!dentist.appointmentData || !Array.isArray(dentist.appointmentData)) {
            return false;
        }

        // Convert selected time slot to minutes
        const slotStart = convertTimeToMinutes(startTime);
        const slotEnd = convertTimeToMinutes(endTime);

        // Check for any overlapping appointments
        return dentist.appointmentData.some(appointment => {
            if (appointment.appointmentDate !== date) return false;

            const apptStart = convertTimeToMinutes(appointment.startTime);
            const apptEnd = convertTimeToMinutes(appointment.endTime);

            // Check if there's any overlap
            return (slotStart < apptEnd && slotEnd > apptStart);
        });
    }

    // Convert time string (HH:mm) to minutes for easier comparison
    function convertTimeToMinutes(timeString) {
        const [hours, minutes] = timeString.split(':').map(Number);
        return (hours * 60) + minutes;
    }

    // Toggle visibility of dentist option
    function toggleDentistVisibility(dentist, isVisible) {
        if (isVisible) {
            dentist.element.classList.remove('disabled');
            dentist.element.querySelector('input').disabled = false;
        } else {
            dentist.element.classList.add('disabled');
            dentist.element.querySelector('input').disabled = true;
            dentist.element.querySelector('input').checked = false;
        }
    }

    // Deselect all dentists
    function deselectAllDentists() {
        document.querySelectorAll('input[name="dentistId"]').forEach(input => {
            input.checked = false;
        });
    }

    // Update the dentist selection UI based on available dentists
    function updateDentistSelectionUI() {
        const availableDentists = document.querySelectorAll('.dentist-option:not(.disabled)');
        const dentistContainer = document.querySelector('.dentist-selection');
        const emptyState = document.querySelector('.dentist-selection + .empty-state') ||
            createEmptyState('No dentists available for the selected time');

        if (availableDentists.length === 0) {
            // No dentists available
            if (!document.querySelector('.dentist-selection + .empty-state')) {
                dentistContainer.after(emptyState);
            }
            dentistContainer.style.display = 'none';
        } else {
            // Dentists available
            const empty = document.querySelector('.dentist-selection + .empty-state');
            if (empty) empty.remove();
            dentistContainer.style.display = 'flex';
        }
    }

    // Create empty state message
    function createEmptyState(message) {
        const div = document.createElement('div');
        div.className = 'empty-state';
        div.innerHTML = `
            <i class="fas fa-user-md"></i>
            <p>${message}</p>
            <button type="button" class="btn-outline" onclick="history.back()">
                Choose a Different Time
            </button>
        `;
        return div;
    }

    // Set loading state for dentist section
    function setDentistSectionLoading(isLoading) {
        const dentistCard = document.querySelector('.dentist-selection').closest('.card');

        if (isLoading) {
            dentistCard.classList.add('loading');
            if (!document.querySelector('.loading-overlay')) {
                const overlay = document.createElement('div');
                overlay.className = 'loading-overlay';
                overlay.innerHTML = '<div class="spinner"></div><p>Finding available dentists...</p>';
                dentistCard.appendChild(overlay);
            }
        } else {
            dentistCard.classList.remove('loading');
            const overlay = document.querySelector('.loading-overlay');
            if (overlay) overlay.remove();
        }
    }

    function safeParseJson(jsonString) {
        if (!jsonString || jsonString === '[]') return [];

        try {
            const parsed = JSON.parse(jsonString);
            return Array.isArray(parsed) ? parsed : [];
        } catch (err) {
            console.error('JSON parse error:', err);
            return [];
        }
    }

    // Fix clinic ID function from debug panel
    window.recoverClinicId = function () {
        const urlParams = new URLSearchParams(window.location.search);
        const clinicId = urlParams.get('clinicId');
        if (clinicId) {
            document.getElementById('clinicIdField').value = clinicId;
            document.getElementById('clinicIdValue').textContent = '(ID: ' + clinicId + ')';
            filterDentistsByClinicAndDate();
        }
    };

    // Validate form before submission
    if (appointmentForm) {
        appointmentForm.addEventListener('submit', function (e) {
            const selectedTime = document.querySelector('input[name="timeSlot"]:checked');
            const selectedDentist = document.querySelector('input[name="dentistId"]:checked');

            if (!selectedTime) {
                e.preventDefault();
                alert('Please select an appointment time');
                return false;
            }

            if (!selectedDentist) {
                e.preventDefault();
                alert('Please select a dentist');
                return false;
            }

            // All checks passed, form will submit
        });
    }

    initializeDentistScheduleDisplay();
});