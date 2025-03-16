<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>${appointment.id == null ? 'New Appointment' : 'Edit Appointment'} - HKDC Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
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
                        <h1>${appointment.id == null ? 'Schedule New Appointment' : 'Edit Appointment'}</h1>
                        <p>Manage appointment details</p>
                    </div>
                    <div class="page-actions">
                        <a href="<c:url value='/admin/appointments'/>" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Appointments
                        </a>
                    </div>
                </div>
                
                <!-- Success/Error Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        ${successMessage}
                    </div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        ${errorMessage}
                    </div>
                </c:if>
                
                <!-- Appointment Form -->
                <div class="form-container">
                    <form:form action="/admin/appointments" method="post" modelAttribute="appointment">
                        <form:hidden path="id" />
                        <form:hidden path="createdAt" />
                        
                        <div class="form-section">
                            <div class="form-section-title">Appointment Details</div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <form:label path="appointmentDate">Date <span class="required">*</span></form:label>
                                    <form:input path="appointmentDate" type="date" class="form-control" required="true" />
                                    <form:errors path="appointmentDate" cssClass="invalid-feedback" />
                                </div>
                                
                                <div class="form-group">
                                    <form:label path="startTime">Start Time <span class="required">*</span></form:label>
                                    <form:input path="startTime" type="time" class="form-control" required="true" />
                                    <form:errors path="startTime" cssClass="invalid-feedback" />
                                </div>
                                
                                <div class="form-group">
                                    <form:label path="endTime">End Time <span class="required">*</span></form:label>
                                    <form:input path="endTime" type="time" class="form-control" required="true" />
                                    <form:errors path="endTime" cssClass="invalid-feedback" />
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <form:label path="patientId">Patient <span class="required">*</span></form:label>
                                <form:select path="patient.id" class="form-control" required="true">
                                    <form:option value="" label="-- Select Patient --" />
                                    <c:forEach items="${patients}" var="patient">
                                        <form:option value="${patient.id}" label="${patient.firstName} ${patient.lastName} (${patient.phoneNumber})" />
                                    </c:forEach>
                                </form:select>
                                <form:errors path="patient" cssClass="invalid-feedback" />
                            </div>
                            
                            <div class="form-group">
                                <form:label path="dentistId">Dentist <span class="required">*</span></form:label>
                                <form:select path="dentist.id" id="dentistSelect" class="form-control" required="true">
                                    <form:option value="" label="-- Select Dentist --" />
                                    <c:forEach items="${dentists}" var="dentist">
                                        <form:option value="${dentist.id}" label="Dr. ${dentist.firstName} ${dentist.lastName} - ${dentist.specialization}" />
                                    </c:forEach>
                                </form:select>
                                <form:errors path="dentist" cssClass="invalid-feedback" />
                            </div>
                            
                            <div class="form-group">
                                <form:label path="clinicId">Clinic <span class="required">*</span></form:label>
                                <form:select path="clinic.id" id="clinicSelect" class="form-control" required="true">
                                    <form:option value="" label="-- Select Clinic --" />
                                    <c:forEach items="${clinics}" var="clinic">
                                        <form:option value="${clinic.id}" label="${clinic.name} - ${clinic.address}" />
                                    </c:forEach>
                                </form:select>
                                <form:errors path="clinic" cssClass="invalid-feedback" />
                                <small class="text-muted">Choose a clinic where the dentist works.</small>
                            </div>
                            
                            <c:if test="${appointment.id != null}">
                                <div class="form-group">
                                    <form:label path="status">Status</form:label>
                                    <form:select path="status" class="form-control">
                                        <c:forEach items="${statuses}" var="status">
                                            <form:option value="${status}" />
                                        </c:forEach>
                                    </form:select>
                                    <form:errors path="status" cssClass="invalid-feedback" />
                                </div>
                            </c:if>
                            
                            <div class="form-group">
                                <form:label path="notes">Notes</form:label>
                                <form:textarea path="notes" class="form-control" rows="3" placeholder="Enter any additional notes or instructions" />
                                <form:errors path="notes" cssClass="invalid-feedback" />
                            </div>
                        </div>
                        
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
        </main>
    </div>
    
    <!-- JavaScript Imports -->
    <script src="<c:url value='/js/common/sidebar.js'/>"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Variables for form elements
            const dentistSelect = document.getElementById('dentistSelect');
            const clinicSelect = document.getElementById('clinicSelect');
            const dateInput = document.querySelector('input[name="appointmentDate"]');
            const startTimeInput = document.querySelector('input[name="startTime"]');
            const endTimeInput = document.querySelector('input[name="endTime"]');
            
            // Ensure time inputs have default values if empty
            if (!startTimeInput.value) {
                startTimeInput.value = '09:00';
            }
            
            if (!endTimeInput.value) {
                // Set 1 hour later by default
                endTimeInput.value = '10:00';
            }
            
            // Ensure date input has a default value if empty
            if (!dateInput.value) {
                const tomorrow = new Date();
                tomorrow.setDate(tomorrow.getDate() + 1);
                const formattedDate = tomorrow.toISOString().split('T')[0];
                dateInput.value = formattedDate;
            }
            
            // Function to validate the form before submission
            const form = document.querySelector('form');
            form.addEventListener('submit', function(e) {
                // Check if start time is before end time
                if (startTimeInput.value >= endTimeInput.value) {
                    e.preventDefault();
                    alert('End time must be after start time');
                    return false;
                }
                
                // Check if date is not in the past
                const selectedDate = new Date(dateInput.value);
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                
                if (selectedDate < today) {
                    e.preventDefault();
                    alert('Cannot schedule appointments in the past');
                    return false;
                }
                
                return true;
            });
        });
    </script>
</body>
</html>