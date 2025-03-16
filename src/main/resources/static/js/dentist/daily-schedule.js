document.addEventListener('DOMContentLoaded', function() {
    // Debug helper
    console.log("Initializing appointment timeline...");
    
    // Populate the timeline with appointments
    const appointments = document.querySelectorAll('.appointment-card');
    console.log(`Found ${appointments.length} appointments to display`);
    
    appointments.forEach(appointment => {
        // Get the time data attributes
        const startTime = appointment.getAttribute('data-start');
        const endTime = appointment.getAttribute('data-end');
        
        console.log(`Processing appointment: ${startTime} - ${endTime}`);
        
        // Extract hours and calculate position
        const startHour = parseInt(startTime.split(':')[0], 10);
        const startMinute = parseInt(startTime.split(':')[1], 10);
        
        const endHour = parseInt(endTime.split(':')[0], 10);
        const endMinute = parseInt(endTime.split(':')[1], 10);
        
        console.log(`Parsed time: ${startHour}:${startMinute} to ${endHour}:${endMinute}`);
        
        // Calculate duration in minutes
        const durationMinutes = (endHour - startHour) * 60 + (endMinute - startMinute);
        console.log(`Appointment duration: ${durationMinutes} minutes`);
        
        // Find the timeline slot to place this appointment
        const timeSlot = document.querySelector(`.time-content[data-hour="${startHour}"]`);
        
        if (timeSlot) {
            console.log(`Found timeslot for hour ${startHour}`);
            
            // Create a visual representation of the appointment in the timeline
            const appointmentVisual = document.createElement('div');
            appointmentVisual.className = 'timeline-appointment';
            
            // Make sure height is sufficient to show content
            const heightInPixels = Math.max(durationMinutes, 30);
            appointmentVisual.style.height = `${heightInPixels}px`;
            appointmentVisual.style.top = `${startMinute}px`;
            
            // Add appointment details
            const patientName = appointment.querySelector('h4').textContent.trim();
            appointmentVisual.innerHTML = `
                <div class="timeline-appointment-content">
                    <div class="timeline-appointment-time">
                        ${startTime.substring(0, 5)} - ${endTime.substring(0, 5)}
                    </div>
                    <div class="timeline-appointment-patient">${patientName}</div>
                </div>
            `;
            
            // Match the status color
            try {
                const statusElement = appointment.querySelector('.appointment-status');
                if (statusElement) {
                    const statusClasses = statusElement.className.split(' ');
                    for (let i = 0; i < statusClasses.length; i++) {
                        if (statusClasses[i].startsWith('status-')) {
                            appointmentVisual.classList.add(statusClasses[i]);
                            break;
                        }
                    }
                }
            } catch (e) {
                console.error("Error applying status class:", e);
            }
            
            // Add to timeline
            timeSlot.appendChild(appointmentVisual);
            console.log(`Added appointment visual to timeline slot ${startHour}`);
            
            // Link timeline appointment to card for highlighting
            appointmentVisual.addEventListener('mouseover', () => {
                appointment.classList.add('highlight');
            });
            
            appointmentVisual.addEventListener('mouseout', () => {
                appointment.classList.remove('highlight');
            });
            
            appointment.addEventListener('mouseover', () => {
                appointmentVisual.classList.add('highlight');
            });
            
            appointment.addEventListener('mouseout', () => {
                appointmentVisual.classList.remove('highlight');
            });
        } else {
            console.warn(`Could not find timeslot for hour ${startHour}`);
        }
    });
});