<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
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
    <link rel="stylesheet" href="<c:url value='/css/appointment-details.css'/>">
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
                        <h1>Appointment Details</h1>
                        <p>View and manage appointment information</p>
                    </div>
                    <div class="page-actions">
                        <a href="<c:url value='/admin/appointments'/>" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Appointments
                        </a>
                        
                        <c:if test="${appointment.status == 'SCHEDULED'}">
                            <a href="<c:url value='/admin/appointments/${appointment.id}/edit'/>" class="btn btn-primary">
                                <i class="fas fa-edit"></i> Edit Appointment
                            </a>
                        </c:if>
                    </div>
                </div>
                
                <!-- Success/Error Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> ${successMessage}
                    </div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                    </div>
                </c:if>
                
                <div class="row">
                    <!-- Appointment Details Card -->
                    <div class="col-md-8">
                        <div class="card mb-4">
                            <div class="card-header">
                                <h3><i class="fas fa-calendar-check"></i> Appointment Information</h3>
                            </div>
                            <div class="card-body">
                                <div class="appointment-header">
                                    <div class="appointment-date">
                                        <div class="date-badge">
                                            <!-- Add null check -->
                                            <c:choose>
                                                <c:when test="${appointment.appointmentDate != null}">
                                                    <c:set var="formattedDate" value="${DateTimeUtils.formatLongDate(appointment.appointmentDate)}" />
                                                    ${formattedDate}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Date not available</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="time-badge">
                                            <i class="fas fa-clock"></i>
                                            <!-- Add null checks -->
                                            <c:choose>
                                                <c:when test="${appointment.startTime != null && appointment.endTime != null}">
                                                    <c:set var="startTime" value="${DateTimeUtils.formatTime(appointment.startTime)}" />
                                                    <c:set var="endTime" value="${DateTimeUtils.formatTime(appointment.endTime)}" />
                                                    ${startTime} - ${endTime}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Time not available</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="status-badge status-${fn:toLowerCase(appointment.status)}">
                                        ${appointment.status}
                                    </div>
                                </div>
                                
                                <div class="appointment-details">
                                    <div class="detail-row">
                                        <div class="detail-label">Patient</div>
                                        <div class="detail-value">
                                            <a href="<c:url value='/admin/patients/${appointment.patient.id}'/>" class="entity-link">
                                                <i class="fas fa-user"></i>
                                                ${appointment.patient.firstName} ${appointment.patient.lastName}
                                            </a>
                                            <div class="detail-secondary">${appointment.patient.phoneNumber}</div>
                                        </div>
                                    </div>
                                    
                                    <div class="detail-row">
                                        <div class="detail-label">Dentist</div>
                                        <div class="detail-value">
                                            <a href="<c:url value='/admin/dentists/${appointment.dentist.id}'/>" class="entity-link">
                                                <i class="fas fa-user-md"></i>
                                                Dr. ${appointment.dentist.firstName} ${appointment.dentist.lastName}
                                            </a>
                                            <div class="detail-secondary">${appointment.dentist.specialization}</div>
                                        </div>
                                    </div>
                                    
                                    <div class="detail-row">
                                        <div class="detail-label">Clinic</div>
                                        <div class="detail-value">
                                            <a href="<c:url value='/admin/clinics/${appointment.clinic.id}'/>" class="entity-link">
                                                <i class="fas fa-hospital"></i>
                                                ${appointment.clinic.name}
                                            </a>
                                            <div class="detail-secondary">${appointment.clinic.address}</div>
                                        </div>
                                    </div>
                                    
                                    <div class="detail-row">
                                        <div class="detail-label">Duration</div>
                                        <div class="detail-value">
                                            <i class="fas fa-hourglass-half"></i>
                                            ${appointment.getDurationMinutes()} minutes
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty appointment.notes}">
                                        <div class="detail-row">
                                            <div class="detail-label">Notes</div>
                                            <div class="detail-value notes-box">
                                                ${appointment.notes}
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <div class="detail-row">
                                        <div class="detail-label">Created</div>
                                        <div class="detail-value">
                                            <c:set var="createdAt" value="${DateTimeUtils.formatDate(appointment.createdAt.toLocalDate())}" />
                                            ${createdAt}
                                        </div>
                                    </div>
                                    
                                    <c:if test="${appointment.createdAt ne appointment.updatedAt}">
                                        <div class="detail-row">
                                            <div class="detail-label">Last Updated</div>
                                            <div class="detail-value">
                                                <c:set var="updatedAt" value="${DateTimeUtils.formatDate(appointment.updatedAt.toLocalDate())}" />
                                                ${updatedAt}
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Action Sidebar -->
                    <div class="col-md-4">
                        <div class="card mb-4">
                            <div class="card-header">
                                <h3><i class="fas fa-tasks"></i> Actions</h3>
                            </div>
                            <div class="card-body">
                                <div class="actions-list">
                                    <c:if test="${appointment.status == 'SCHEDULED'}">
                                        <form action="<c:url value='/admin/appointments/${appointment.id}/complete'/>" method="post" class="action-form">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button type="submit" class="btn btn-success btn-block">
                                                <i class="fas fa-check-circle"></i> Mark as Completed
                                            </button>
                                        </form>
                                        
                                        <form action="<c:url value='/admin/appointments/${appointment.id}/no-show'/>" method="post" class="action-form">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button type="submit" class="btn btn-warning btn-block">
                                                <i class="fas fa-user-slash"></i> Mark as No-Show
                                            </button>
                                        </form>
                                        
                                        <form action="<c:url value='/admin/appointments/${appointment.id}/cancel'/>" method="post" class="action-form" 
                                              onsubmit="return confirm('Are you sure you want to cancel this appointment?')">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button type="submit" class="btn btn-danger btn-block">
                                                <i class="fas fa-times-circle"></i> Cancel Appointment
                                            </button>
                                        </form>
                                    </c:if>
                                    
                                    <a href="<c:url value='/admin/appointments/new?patientId=${appointment.patient.id}'/>" class="btn btn-outline-primary btn-block">
                                        <i class="fas fa-plus"></i> New Appointment for Same Patient
                                    </a>
                                    
                                    <c:if test="${appointment.status != 'SCHEDULED'}">
                                        <a href="<c:url value='/admin/appointments/new?patientId=${appointment.patient.id}&dentistId=${appointment.dentist.id}&clinicId=${appointment.clinic.id}'/>" class="btn btn-outline-primary btn-block">
                                            <i class="fas fa-calendar-plus"></i> Reschedule Appointment
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- JavaScript Imports -->
    <script src="<c:url value='/js/common/sidebar.js'/>"></script>
</body>
</html>