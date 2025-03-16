<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page import="com.example.webapp.util.DateTimeUtils" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>${appointment.id == null ? 'Schedule New' : 'Edit'} Appointment - HKDC Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/appointment-form.css'/>">
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
                <div class="page-header">
                    <div>
                        <h1>${appointment.id == null ? 'Schedule New' : 'Edit'} Appointment</h1>
                        <p>${appointment.id == null ? 'Create a new appointment' : 'Modify existing appointment details'}</p>
                    </div>
                    <div class="page-actions">
                        <a href="<c:url value='/admin/appointments'/>" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Appointments
                        </a>
                    </div>
                </div>
                
                <!-- Error messages -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                    </div>
                </c:if>
                
                <!-- Appointment Form -->
                <div class="card">
                    <div class="card-body">
                        <form:form action="/admin/appointments" method="post" modelAttribute="appointment" id="appointmentForm">
                            <!-- Hidden ID for edit mode -->
                            <form:hidden path="id" />
                            
                            <div class="form-grid">
                                <!-- Patient Selection -->
                                <div class="form-group">
                                    <label for="patient.id">
                                        <i class="fas fa-user"></i> Patient <span class="required">*</span>
                                    </label>
                                    <form:select path="patient.id" id="patient.id" class="form-control" required="true">
                                        <option value="">-- Select Patient --</option>
                                        <c:forEach items="${patients}" var="patient">
                                            <option value="${patient.id}" ${appointment.patient != null && appointment.patient.id == patient.id ? 'selected' : ''}>
                                                ${patient.firstName} ${patient.lastName} (${patient.phoneNumber})
                                            </option>
                                        </c:forEach>
                                    </form:select>
                                    <form:errors path="patient" cssClass="text-danger" />
                                </div>
                                
                                <!-- Dentist Selection -->
                                <div class="form-group">
                                    <label for="dentist.id">
                                        <i class="fas fa-user-md"></i> Dentist <span class="required">*</span>
                                    </label>
                                    <form:select path="dentist.id" id="dentist.id" class="form-control" required="true">
                                        <option value="">-- Select Dentist --</option>
                                        <c:forEach items="${dentists}" var="dentist">
                                            <option value="${dentist.id}" ${appointment.dentist != null && appointment.dentist.id == dentist.id ? 'selected' : ''}>
                                                Dr. ${dentist.firstName} ${dentist.lastName} (${dentist.specialization})
                                            </option>
                                        </c:forEach>
                                    </form:select>
                                    <form:errors path="dentist" cssClass="text-danger" />
                                </div>
                                
                                <!-- Clinic Selection -->
                                <div class="form-group">
                                    <label for="clinic.id">
                                        <i class="fas fa-hospital"></i> Clinic <span class="required">*</span>
                                    </label>
                                    <form:select path="clinic.id" id="clinic.id" class="form-control" required="true">
                                        <option value="">-- Select Clinic --</option>
                                        <c:forEach items="${clinics}" var="clinic">
                                            <option value="${clinic.id}" ${appointment.clinic != null && appointment.clinic.id == clinic.id ? 'selected' : ''}>
                                                ${clinic.name} (${clinic.address})
                                            </option>
                                        </c:forEach>
                                    </form:select>
                                    <form:errors path="clinic" cssClass="text-danger" />
                                </div>
                                
                                <!-- Appointment Date -->
                                <div class="form-group">
                                    <label for="appointmentDate">
                                        <i class="fas fa-calendar"></i> Date <span class="required">*</span>
                                    </label>
                                    <form:input path="appointmentDate" type="date" id="appointmentDate" class="form-control" required="true" />
                                    <form:errors path="appointmentDate" cssClass="text-danger" />
                                </div>
                                
                                <!-- Start Time -->
                                <div class="form-group">
                                    <label for="startTime">
                                        <i class="fas fa-clock"></i> Start Time <span class="required">*</span>
                                    </label>
                                    <form:input path="startTime" type="time" id="startTime" class="form-control" required="true" />
                                    <form:errors path="startTime" cssClass="text-danger" />
                                </div>
                                
                                <!-- End Time -->
                                <div class="form-group">
                                    <label for="endTime">
                                        <i class="fas fa-clock"></i> End Time <span class="required">*</span>
                                    </label>
                                    <form:input path="endTime" type="time" id="endTime" class="form-control" required="true" />
                                    <form:errors path="endTime" cssClass="text-danger" />
                                </div>
                                
                                <!-- Status (Only shown in edit mode) -->
                                <c:if test="${appointment.id != null}">
                                    <div class="form-group">
                                        <label for="status">
                                            <i class="fas fa-tag"></i> Status
                                        </label>
                                        <form:select path="status" id="status" class="form-control">
                                            <c:forEach items="${statuses}" var="status">
                                                <option value="${status}" ${appointment.status == status ? 'selected' : ''}>
                                                    ${status}
                                                </option>
                                            </c:forEach>
                                        </form:select>
                                        <form:errors path="status" cssClass="text-danger" />
                                    </div>
                                </c:if>
                                
                                <!-- Notes -->
                                <div class="form-group full-width">
                                    <label for="notes">
                                        <i class="fas fa-sticky-note"></i> Notes
                                    </label>
                                    <form:textarea path="notes" id="notes" class="form-control" rows="3" />
                                    <form:errors path="notes" cssClass="text-danger" />
                                </div>
                            </div>
                            
                            <!-- Form Actions -->
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> ${appointment.id == null ? 'Schedule Appointment' : 'Update Appointment'}
                                </button>
                                <a href="<c:url value='/admin/appointments'/>" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                            </div>
                        </form:form>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- JavaScript Imports -->
    <script src="<c:url value='/js/common/sidebar.js'/>"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Form validation
            const appointmentForm = document.getElementById('appointmentForm');
            const startTimeInput = document.getElementById('startTime');
            const endTimeInput = document.getElementById('endTime');
            
            appointmentForm.addEventListener('submit', function(event) {
                const startTime = startTimeInput.value;
                const endTime = endTimeInput.value;
                
                if (startTime >= endTime) {
                    event.preventDefault();
                    alert('End time must be after start time');
                    return false;
                }
            });
            
            // Availability checking (could be implemented with AJAX)
            const dentistSelect = document.getElementById('dentist.id');
            const dateInput = document.getElementById('appointmentDate');
            
            // Example of how to check availability when dentist or date changes
            function checkAvailability() {
                const dentistId = dentistSelect.value;
                const date = dateInput.value;
                const start = startTimeInput.value;
                const end = endTimeInput.value;
                
                if (dentistId && date && start && end && start < end) {
                    // Here you could make an AJAX call to check availability
                    // For now we'll just log to console
                    console.log(`Checking availability for dentist ${dentistId} on ${date} from ${start} to ${end}`);
                }
            }
            
            dentistSelect.addEventListener('change', checkAvailability);
            dateInput.addEventListener('change', checkAvailability);
            startTimeInput.addEventListener('change', checkAvailability);
            endTimeInput.addEventListener('change', checkAvailability);
        });
    </script>
</body>
</html>