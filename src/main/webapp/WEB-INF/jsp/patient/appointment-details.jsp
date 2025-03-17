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
    <title>Appointment Details - HKDC System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/appointments.css'/>">
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
                <!-- Page Header with Action Buttons -->
                <div class="page-header">
                    <div>
                        <h1>Appointment Details</h1>
                        <p>View your appointment information</p>
                    </div>
                    <div class="view-actions">
                        <a href="<c:url value='/patient/appointments'/>" class="btn-outline">
                            <i class="fas fa-arrow-left"></i> Back to Appointments
                        </a>
                        
                        <c:if test="${appointment.status == 'SCHEDULED'}">
                            <a href="<c:url value='/patient/appointments/${appointment.id}/cancel'/>" class="btn-outline btn-danger">
                                <i class="fas fa-times-circle"></i> Cancel Appointment
                            </a>
                        </c:if>
                    </div>
                </div>

                <!-- Success Message -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> ${successMessage}
                        <button type="button" class="close-alert">&times;</button>
                    </div>
                </c:if>

                <div class="row">
                    <!-- Left Column - Appointment Details -->
                    <div class="col-lg-8">
                        <!-- Main Appointment Card -->
                        <div class="card">
                            <div class="card-header">
                                <div class="appointment-header">
                                    <div class="appointment-date">
                                        <div class="date-badge">
                                            <i class="far fa-calendar-alt"></i> ${formattedDate}
                                        </div>
                                        <div class="time-badge">
                                            <i class="fas fa-clock"></i> ${formattedTime}
                                        </div>
                                    </div>
                                    <div class="status-badge status-${fn:toLowerCase(appointment.status)}">
                                        ${fn:replace(fn:toLowerCase(appointment.status), '_', ' ')}
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="appointment-details">
                                    <!-- Dentist Information Section -->
                                    <div class="detail-row">
                                        <div class="detail-label">Dentist</div>
                                        <div class="detail-value">
                                            Dr. ${appointment.dentist.firstName} ${appointment.dentist.lastName}
                                        </div>
                                    </div>
                                    
                                    <!-- Clinic Information Section -->
                                    <div class="detail-row">
                                        <div class="detail-label">Clinic</div>
                                        <div class="detail-value">${appointment.clinic.name}</div>
                                    </div>
                                    
                                    <div class="detail-row">
                                        <div class="detail-label">Location</div>
                                        <div class="detail-value">
                                            ${appointment.clinic.address},
                                            ${appointment.clinic.city}, 
                                            ${appointment.clinic.postalCode}
                                        </div>
                                    </div>
                                    
                                    <div class="detail-row">
                                        <div class="detail-label">Phone</div>
                                        <div class="detail-value">${appointment.clinic.phoneNumber}</div>
                                    </div>
                                    
                                    <!-- System Information Section -->
                                    <div class="detail-row">
                                        <div class="detail-label">Created</div>
                                        <div class="detail-value">${createdAtFormatted}</div>
                                    </div>
                                    
                                    <c:if test="${not empty updatedAtFormatted}">
                                        <div class="detail-row">
                                            <div class="detail-label">Last Updated</div>
                                            <div class="detail-value">${updatedAtFormatted}</div>
                                        </div>
                                    </c:if>
                                    
                                    <!-- Notes Section -->
                                    <c:if test="${not empty appointment.notes}">
                                        <div class="detail-row notes-section">
                                            <div class="detail-label">Notes</div>
                                            <div class="detail-value">
                                                <div class="appointment-notes">
                                                    <c:set var="notesWithLineBreaks" value="${fn:replace(appointment.notes, '&#10;', '<br/>')}" />
                                                    ${notesWithLineBreaks}
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Clinic Map Section (optional) -->
                        <div class="card">
                            <div class="card-header">
                                <h3><i class="fas fa-map-marker-alt"></i> Clinic Location</h3>
                            </div>
                            <div class="card-body p-0">
                                <div class="map-container">
                                    <img src="https://maps.googleapis.com/maps/api/staticmap?center=${appointment.clinic.address},${appointment.clinic.city},${appointment.clinic.postalCode}&zoom=15&size=600x300&markers=color:red%7C${appointment.clinic.address},${appointment.clinic.city},${appointment.clinic.postalCode}&key=YOUR_GOOGLE_MAPS_API_KEY" 
                                         alt="Clinic location map" class="clinic-map">
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Right Column - Actions and Info -->
                    <div class="col-lg-4">
                        <!-- Quick Actions Card -->
                        <div class="card">
                            <div class="card-header">
                                <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
                            </div>
                            <div class="card-body">
                                <div style="display: flex; flex-direction: column; gap: 10px;">
                                    <c:if test="${appointment.status == 'SCHEDULED'}">
                                        <a href="<c:url value='/patient/appointments/${appointment.id}/cancel'/>" class="btn-outline status-update-btn" style="width: 100%;">
                                            <i class="fas fa-times-circle"></i> Cancel Appointment
                                        </a>
                                    </c:if>
                                    
                                    <a href="<c:url value='/patient/book'/>" class="btn-outline" style="width: 100%;">
                                        <i class="fas fa-plus-circle"></i> Book New Appointment
                                    </a>
                                    
                                    <a href="tel:${appointment.clinic.phoneNumber}" class="btn-outline" style="width: 100%;">
                                        <i class="fas fa-phone"></i> Call Clinic
                                    </a>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Appointment Information Card -->
                        <div class="card">
                            <div class="card-header">
                                <h3><i class="fas fa-info-circle"></i> Important Information</h3>
                            </div>
                            <div class="card-body">
                                <div class="info-item">
                                    <h4><i class="fas fa-exclamation-triangle"></i> Cancellation Policy</h4>
                                    <p>Please cancel at least 24 hours before your appointment to avoid any cancellation fees.</p>
                                </div>
                                
                                <div class="info-item">
                                    <h4><i class="fas fa-user-clock"></i> Arrival Time</h4>
                                    <p>Please arrive 15 minutes before your appointment time to complete any paperwork.</p>
                                </div>
                                
                                <div class="info-item">
                                    <h4><i class="fas fa-tooth"></i> Preparation</h4>
                                    <p>Brush and floss your teeth before your appointment. Bring a list of any medications you're taking.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Recent Appointments Section -->
                <div class="section-header">
                    <h2>Your Recent Appointments</h2>
                    <a href="<c:url value='/patient/appointments'/>" class="view-all">View All</a>
                </div>
                
                <div class="card">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="recent-appointments-table">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Dentist</th>
                                        <th>Clinic</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty recentAppointments}">
                                            <c:forEach items="${recentAppointments}" var="recentAppointment">
                                                <tr class="${recentAppointment.id == appointment.id ? 'current-appointment' : ''}">
                                                    <td>
                                                        <div class="date-badge small">
                                                            <fmt:parseDate value="${recentAppointment.appointmentDate}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                                            <fmt:formatDate value="${parsedDate}" pattern="MMM d, yyyy" />
                                                        </div>
                                                        <div class="time-badge small">
                                                            <fmt:parseDate value="${recentAppointment.startTime}" pattern="HH:mm" var="parsedStartTime" type="time" />
                                                            <fmt:formatDate value="${parsedStartTime}" pattern="h:mm a" />
                                                        </div>
                                                    </td>
                                                    <td>Dr. ${recentAppointment.dentist.firstName} ${recentAppointment.dentist.lastName}</td>
                                                    <td>${recentAppointment.clinic.name}</td>
                                                    <td>
                                                        <span class="status-badge status-${fn:toLowerCase(recentAppointment.status)} small">
                                                            ${fn:replace(fn:toLowerCase(recentAppointment.status), '_', ' ')}
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="4" class="no-data">No previous appointments found.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- JavaScript -->
    <script src="<c:url value='/js/common/sidebar.js'/>"></script>
    <script src="<c:url value='/js/patient/appointment-details.js'/>"></script>
</body>
</html>