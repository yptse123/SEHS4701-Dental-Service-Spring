<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>Select Time - HKDC System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/appointments.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/patient/book-appointment-time.css'/>">
</head>
<body>
    <div class="dashboard-container">
        <!-- Include sidebar partial -->
        <jsp:include page="../partials/sidebar.jsp" />
        
        <!-- Main Content -->
        <main class="main-content">
            <!-- Include header partial -->
            <jsp:include page="../partials/header.jsp" />
            
            <div class="content-wrapper">
                <!-- Page Header with Steps -->
                <div class="page-header">
                    <div>
                        <h1>Book an Appointment</h1>
                        <p>Step 2: Select time and dentist</p>
                    </div>
                    <div class="view-actions">
                        <button type="button" class="btn-outline" onclick="history.back()">
                            <i class="fas fa-arrow-left"></i> Back to Previous Step
                        </button>
                    </div>
                </div>

                <!-- Error Message -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                        <button type="button" class="close-alert">&times;</button>
                    </div>
                </c:if>

                <!-- Booking Steps Indicator -->
                <div class="booking-steps">
                    <div class="step completed">
                        <div class="step-number"><i class="fas fa-check"></i></div>
                        <div class="step-label">Choose Clinic & Date</div>
                    </div>
                    <div class="step-connector completed"></div>
                    <div class="step active">
                        <div class="step-number">2</div>
                        <div class="step-label">Select Time & Dentist</div>
                    </div>
                    <div class="step-connector"></div>
                    <div class="step">
                        <div class="step-number">3</div>
                        <div class="step-label">Confirm Booking</div>
                    </div>
                </div>

                <!-- Selected Options Summary -->
                <div class="booking-summary">
                    <div class="summary-item">
                        <div class="summary-label">Selected Clinic:</div>
                        <div class="summary-value">${appointment.clinic.name}</div>
                    </div>
                    <div class="summary-item">
                        <div class="summary-label">Selected Date:</div>
                        <div class="summary-value">
                            <fmt:parseDate value="${appointment.appointmentDate}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                            <fmt:formatDate value="${parsedDate}" pattern="EEEE, MMMM d, yyyy" />
                        </div>
                    </div>
                </div>

                <div id="clinicDebugBanner" class="card" style="margin-bottom: 15px; background-color: #e8f5e9; border-left: 4px solid #2e7d32;">
                    <div class="card-body" style="padding: 10px 15px;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <h4 style="margin: 0; font-size: 1.1rem;">Appointment Information</h4>
                            <button onclick="this.parentNode.parentNode.style.display='none'" 
                                    style="background: none; border: none; cursor: pointer; font-size: 1.2rem;">&times;</button>
                        </div>
                        <p style="margin: 10px 0 5px;">
                            <strong>Clinic:</strong> 
                            <span id="clinicNameDisplay">${not empty appointment.clinic.name ? appointment.clinic.name : 'Not selected'}</span>
                            <span id="clinicIdValue" style="margin-left: 10px; font-size: 0.8rem; color: #777;">(ID: ${not empty appointment.clinic.id ? appointment.clinic.id : param.clinicId})</span>
                            <button onclick="recoverClinicId()" style="margin-left: 10px; padding: 2px 8px; background: #4caf50; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 0.8rem;">Fix ID</button>
                        </p>
                        <p style="margin: 5px 0;">
                            <strong>Date:</strong> 
                            <span>${appointment.appointmentDate}</span>
                        </p>
                    </div>
                </div>

                <!-- Time Selection Card -->
                <form action="<c:url value='/patient/book/confirm'/>" method="post" id="appointmentForm">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    
                    <!-- Add a clinic ID input with a direct value (not nested property access) -->
                    <c:set var="clinicIdValue" value="${not empty appointment.clinic.id ? appointment.clinic.id : param.clinicId}" />
                    <input type="hidden" id="clinicIdField" name="clinicId" value="${clinicIdValue}" />
                    
                    <!-- Add direct appointment date value -->
                    <input type="hidden" name="appointmentDate" value="${appointment.appointmentDate}" />
                    
                    <!-- These will be populated by JavaScript -->
                    <input type="hidden" name="startTime" value="" />
                    <input type="hidden" name="endTime" value="" />

                    <div class="card">
                        <div class="card-header">
                            <h3><i class="fas fa-clock"></i> Select Appointment Time</h3>
                        </div>
                        <div class="card-body">
                            <div class="time-slots-container">
                                <c:choose>
                                    <c:when test="${not empty availableSlots}">
                                        <!-- Organize time slots by period (morning, afternoon, evening) -->
                                        <c:set var="morningSlots" value="${availableSlots.stream().filter(slot -> slot[0] < '12:00').toList()}" />
                                        <c:set var="afternoonSlots" value="${availableSlots.stream().filter(slot -> slot[0] >= '12:00' && slot[0] < '17:00').toList()}" />
                                        <c:set var="eveningSlots" value="${availableSlots.stream().filter(slot -> slot[0] >= '17:00').toList()}" />
                                        
                                        <!-- Morning Section -->
                                        <c:if test="${not empty morningSlots}">
                                            <div class="time-period morning">
                                                <div class="time-period-header">
                                                    <div class="time-period-icon">
                                                        <i class="fas fa-sun"></i>
                                                    </div>
                                                    <h4>Morning</h4>
                                                </div>
                                                <div class="time-slots-grid">
                                                    <c:forEach items="${morningSlots}" var="slot" varStatus="status">
                                                        <div class="time-slot morning">
                                                            <input type="radio" name="timeSlot" id="slot-morning-${status.index}" 
                                                                   value="${slot[0]}|${slot[1]}" required
                                                                   data-start="${slot[0]}" data-end="${slot[1]}">
                                                            <label for="slot-morning-${status.index}">
                                                                <fmt:parseDate value="${slot[0]}" pattern="HH:mm" var="parsedStartTime" type="time" />
                                                                <fmt:formatDate value="${parsedStartTime}" pattern="h:mm a" /> - 
                                                                <fmt:parseDate value="${slot[1]}" pattern="HH:mm" var="parsedEndTime" type="time" />
                                                                <fmt:formatDate value="${parsedEndTime}" pattern="h:mm a" />
                                                            </label>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <!-- Afternoon Section -->
                                        <c:if test="${not empty afternoonSlots}">
                                            <div class="time-period afternoon">
                                                <div class="time-period-header">
                                                    <div class="time-period-icon">
                                                        <i class="fas fa-cloud-sun"></i>
                                                    </div>
                                                    <h4>Afternoon</h4>
                                                </div>
                                                <div class="time-slots-grid">
                                                    <c:forEach items="${afternoonSlots}" var="slot" varStatus="status">
                                                        <div class="time-slot afternoon">
                                                            <input type="radio" name="timeSlot" id="slot-afternoon-${status.index}" 
                                                                   value="${slot[0]}|${slot[1]}" required
                                                                   data-start="${slot[0]}" data-end="${slot[1]}">
                                                            <label for="slot-afternoon-${status.index}">
                                                                <fmt:parseDate value="${slot[0]}" pattern="HH:mm" var="parsedStartTime" type="time" />
                                                                <fmt:formatDate value="${parsedStartTime}" pattern="h:mm a" /> - 
                                                                <fmt:parseDate value="${slot[1]}" pattern="HH:mm" var="parsedEndTime" type="time" />
                                                                <fmt:formatDate value="${parsedEndTime}" pattern="h:mm a" />
                                                            </label>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <!-- Evening Section -->
                                        <c:if test="${not empty eveningSlots}">
                                            <div class="time-period evening">
                                                <div class="time-period-header">
                                                    <div class="time-period-icon">
                                                        <i class="fas fa-moon"></i>
                                                    </div>
                                                    <h4>Evening</h4>
                                                </div>
                                                <div class="time-slots-grid">
                                                    <c:forEach items="${eveningSlots}" var="slot" varStatus="status">
                                                        <div class="time-slot evening">
                                                            <input type="radio" name="timeSlot" id="slot-evening-${status.index}" 
                                                                   value="${slot[0]}|${slot[1]}" required
                                                                   data-start="${slot[0]}" data-end="${slot[1]}">
                                                            <label for="slot-evening-${status.index}">
                                                                <fmt:parseDate value="${slot[0]}" pattern="HH:mm" var="parsedStartTime" type="time" />
                                                                <fmt:formatDate value="${parsedStartTime}" pattern="h:mm a" /> - 
                                                                <fmt:parseDate value="${slot[1]}" pattern="HH:mm" var="parsedEndTime" type="time" />
                                                                <fmt:formatDate value="${parsedEndTime}" pattern="h:mm a" />
                                                            </label>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <!-- If no time slots in any period -->
                                        <c:if test="${empty morningSlots && empty afternoonSlots && empty eveningSlots}">
                                            <div class="empty-state">
                                                <i class="fas fa-calendar-times"></i>
                                                <p>No available time slots for the selected date.</p>
                                                <button type="button" class="btn-outline" onclick="history.back()">
                                                    Choose a Different Date
                                                </button>
                                            </div>
                                        </c:if>
                                        
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <i class="fas fa-calendar-times"></i>
                                            <p>No available time slots for the selected date.</p>
                                            <button type="button" class="btn-outline" onclick="history.back()">
                                                Choose a Different Date
                                            </button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Dentist Selection Card -->
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="fas fa-user-md"></i> Select Dentist</h3>
                        </div>
                        <div class="card-body">
                            <div class="form-group">
                                <c:choose>
                                    <c:when test="${not empty dentists}">
                                        <div class="dentist-selection">
                                            <c:forEach items="${dentists}" var="dentist">
                                                <div class="dentist-option">
                                                    <input type="radio" name="dentistId" id="dentist${dentist.id}" 
                                                           value="${dentist.id}" required>
                                                    <label for="dentist${dentist.id}">
                                                        <div class="dentist-name">Dr. ${dentist.firstName} ${dentist.lastName}</div>
                                                    </label>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <i class="fas fa-user-md"></i>
                                            <p>No dentists available at this clinic.</p>
                                            <button type="button" class="btn-outline" onclick="history.back()">
                                                Choose a Different Clinic
                                            </button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Additional Information Card -->
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="fas fa-file-medical"></i> Additional Information</h3>
                        </div>
                        <div class="card-body">
                            <div class="form-group">
                                <label for="notes">Reason for Visit / Additional Notes (Optional)</label>
                                <textarea name="notes" id="notes" class="form-control" rows="4" 
                                          placeholder="Please briefly describe the reason for your visit or any specific concerns..."></textarea>
                            </div>

                            <div class="form-group">
                                <label class="checkbox-container">
                                    <input type="checkbox" name="terms" required>
                                    <span class="checkmark"></span>
                                    I understand that I should arrive 15 minutes before my appointment time and that a cancellation fee may apply if I cancel with less than 24 hours notice.
                                </label>
                            </div>

                            <div class="form-actions">
                                <button type="button" class="btn-outline" onclick="history.back()">Back</button>
                                <button type="submit" class="btn-primary" id="confirmButton">
                                    Continue to Confirm <i class="fas fa-arrow-right"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <!-- Debug information - only visible in development -->
                    <div id="debugPanel" style="display: none; margin-top: 20px; padding: 15px; background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px;">
                        <h5>Form Debug Information</h5>
                        <p><strong>Clinic ID:</strong> <span id="debug-clinic-id">${clinicIdValue}</span></p>
                        <p><strong>Date:</strong> <span id="debug-date">${appointment.appointmentDate}</span></p>
                        <button type="button" class="btn-outline" onclick="showFormValues()">Show All Form Values</button>
                        <div id="formValuesDisplay" style="margin-top: 10px;"></div>
                    </div>

                    <script>
                        function showFormValues() {
                            const form = document.getElementById('appointmentForm');
                            const display = document.getElementById('formValuesDisplay');
                            if (form && display) {
                                const formData = new FormData(form);
                                let html = '<ul style="list-style-type: none; padding-left: 0;">';
                                
                                for (const [name, value] of formData.entries()) {
                                    html += `<li><strong>${name}:</strong> ${value}</li>`;
                                }
                                
                                html += '</ul>';
                                display.innerHTML = html;
                            }
                        }
                        
                        // Press Ctrl+D to show debug panel
                        document.addEventListener('keydown', function(e) {
                            if (e.ctrlKey && e.key === 'd') {
                                e.preventDefault();
                                const panel = document.getElementById('debugPanel');
                                if (panel) {
                                    panel.style.display = panel.style.display === 'none' ? 'block' : 'none';
                                    if (panel.style.display === 'block') {
                                        showFormValues();
                                    }
                                }
                            }
                        });
                    </script>
                </form>
            </div>
        </main>
    </div>

    <!-- JavaScript -->
    <script src="<c:url value='/js/common/sidebar.js'/>"></script>
    <script src="<c:url value='/js/patient/book-appointment-time.js'/>"></script>
</body>
</html>