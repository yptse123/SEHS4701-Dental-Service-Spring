<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.example.webapp.util.DateTimeUtils" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>Appointment Details - HKDC Admin</title>
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
                
                <div class="page-header">
                    <div>
                        <h1>Appointment Details</h1>
                        <p>View appointment information</p>
                    </div>
                    <div class="page-actions">
                        <a href="<c:url value='/admin/appointments'/>" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Appointments
                        </a>
                        
                        <c:if test="${appointment.status == 'SCHEDULED'}">
                            <a href="<c:url value='/admin/appointments/${appointment.id}/edit'/>" class="btn btn-primary">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                        </c:if>
                    </div>
                </div>
                
                <div class="detail-container">
                    <!-- Appointment Status Card -->
                    <div class="detail-card status-card">
                        <div class="status-header status-${appointment.status.toLowerCase()}">
                            <h2>
                                <i class="fas ${appointment.status == 'SCHEDULED' ? 'fa-calendar-check' : 
                                               appointment.status == 'COMPLETED' ? 'fa-check-circle' : 
                                               appointment.status == 'CANCELLED' ? 'fa-times-circle' : 'fa-user-slash'}"></i>
                                ${appointment.status}
                            </h2>
                        </div>
                        
                        <div class="status-actions">
                            <c:if test="${appointment.status == 'SCHEDULED'}">
                                <form action="<c:url value='/admin/appointments/${appointment.id}/complete'/>" method="post" class="inline-form">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <button type="submit" class="btn btn-success">
                                        <i class="fas fa-check-circle"></i> Mark as Completed
                                    </button>
                                </form>
                                
                                <form action="<c:url value='/admin/appointments/${appointment.id}/no-show'/>" method="post" class="inline-form">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <button type="submit" class="btn btn-warning">
                                        <i class="fas fa-user-slash"></i> Mark as No-Show
                                    </button>
                                </form>
                                
                                <form action="<c:url value='/admin/appointments/${appointment.id}/cancel'/>" method="post" class="inline-form">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to cancel this appointment?')">
                                        <i class="fas fa-times-circle"></i> Cancel Appointment
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                    
                    <!-- Appointment Details Card -->
                    <div class="detail-card">
                        <h3>Appointment Information</h3>
                        
                        <div class="info-group">
                            <div class="info-label">Date & Time</div>
                            <div class="info-value">
                                <div class="detail-item">
                                    <i class="fas fa-calendar"></i>
                                    <c:set var="formattedLongDate" value="${DateTimeUtils.formatLongDate(appointment.appointmentDate)}" />
                                    ${formattedLongDate}
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-clock"></i>
                                    <c:set var="startTime" value="${DateTimeUtils.formatTime(appointment.startTime)}" />
                                    <c:set var="endTime" value="${DateTimeUtils.formatTime(appointment.endTime)}" />
                                    ${startTime} - ${endTime}
                                </div>
                            </div>
                        </div>
                        
                        <div class="info-group">
                            <div class="info-label">Clinic</div>
                            <div class="info-value">
                                <div class="detail-item">
                                    <i class="fas fa-hospital"></i>
                                    <a href="<c:url value='/admin/clinics/${appointment.clinic.id}'/>">${appointment.clinic.name}</a>
                                </div>
                                <div class="detail-item text-muted">
                                    <i class="fas fa-map-marker-alt"></i>
                                    ${appointment.clinic.address}
                                </div>
                                <div class="detail-item text-muted">
                                    <i class="fas fa-phone"></i>
                                    ${appointment.clinic.phoneNumber}
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Patient Information Card -->
                    <div class="detail-card">
                        <h3>Patient Information</h3>
                        
                        <div class="info-group">
                            <div class="info-label">Name</div>
                            <div class="info-value">
                                <a href="<c:url value='/admin/patients/${appointment.patient.id}'/>">
                                    ${appointment.patient.firstName} ${appointment.patient.lastName}
                                </a>
                            </div>
                        </div>
                        
                        <div class="info-group">
                            <div class="info-label">Contact</div>
                            <div class="info-value">
                                <div class="detail-item">
                                    <i class="fas fa-phone"></i>
                                    ${appointment.patient.phoneNumber}
                                </div>
                                <div class="detail-item">
                                    <i class="fas fa-envelope"></i>
                                    ${appointment.patient.user.email}
                                </div>
                            </div>
                        </div>
                        
                        <c:if test="${not empty appointment.patient.dateOfBirth}">
                            <div class="info-group">
                                <div class="info-label">Date of Birth</div>
                                <div class="info-value">
                                    <fmt:formatDate value="${appointment.patient.dateOfBirth}" pattern="MMMM d, yyyy" />
                                </div>
                            </div>
                        </c:if>
                    </div>
                    
                    <!-- Dentist Information Card -->
                    <div class="detail-card">
                        <h3>Dentist Information</h3>
                        
                        <div class="info-group">
                            <div class="info-label">Name</div>
                            <div class="info-value">
                                <a href="<c:url value='/admin/dentists/${appointment.dentist.id}'/>">
                                    Dr. ${appointment.dentist.firstName} ${appointment.dentist.lastName}
                                </a>
                            </div>
                        </div>
                        
                        <div class="info-group">
                            <div class="info-label">Specialization</div>
                            <div class="info-value">
                                ${appointment.dentist.specialization}
                            </div>
                        </div>
                        
                        <div class="info-group">
                            <div class="info-label">Contact</div>
                            <div class="info-value">
                                <div class="detail-item">
                                    <i class="fas fa-envelope"></i>
                                    ${appointment.dentist.user.email}
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Notes Card -->
                    <c:if test="${not empty appointment.notes}">
                        <div class="detail-card">
                            <h3>Notes</h3>
                            <div class="notes-content">
                                ${appointment.notes}
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>
    </div>
    
    <!-- JavaScript Imports -->
    <script src="<c:url value='/js/common/sidebar.js'/>"></script>
</body>
</html>