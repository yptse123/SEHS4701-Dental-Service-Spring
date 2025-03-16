<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

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
                <div class="page-header">
                    <div>
                        <h1>Appointment Details</h1>
                        <p>View and manage appointment information</p>
                    </div>
                    <div class="view-actions">
                        <a href="<c:url value='/dentist/appointments'/>" class="btn-outline">
                            <i class="fas fa-arrow-left"></i> Back to Appointments
                        </a>
                        
                        <c:if test="${appointment.status == 'SCHEDULED'}">
                            <button id="updateStatusBtn" class="btn-primary">
                                <i class="fas fa-edit"></i> Update Status
                            </button>
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

                <!-- Appointment Information -->
                <div class="card">
                    <div class="card-header">
                        <div class="appointment-header">
                            <div class="appointment-date">
                                <div class="date-badge">
                                    <fmt:parseDate value="${appointment.appointmentDate}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                    <fmt:formatDate value="${parsedDate}" pattern="EEEE, MMMM d, yyyy" />
                                </div>
                                <div class="time-badge">
                                    <i class="fas fa-clock"></i>
                                    <c:if test="${appointment.startTime != null && appointment.endTime != null}">
                                        <fmt:parseDate value="${appointment.startTime}" pattern="HH:mm" var="parsedStartTime" type="time" />
                                        <fmt:parseDate value="${appointment.endTime}" pattern="HH:mm" var="parsedEndTime" type="time" />
                                        <fmt:formatDate value="${parsedStartTime}" pattern="h:mm a" /> - 
                                        <fmt:formatDate value="${parsedEndTime}" pattern="h:mm a" />
                                    </c:if>
                                </div>
                            </div>
                            <div class="status-badge status-${fn:toLowerCase(appointment.status)}">
                                ${fn:replace(fn:toLowerCase(appointment.status), '_', ' ')}
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="appointment-details">
                            <div class="detail-row">
                                <div class="detail-label">Patient</div>
                                <div class="detail-value">
                                    <a href="<c:url value='/dentist/patients/${appointment.patient.id}'/>" class="entity-link">
                                        ${appointment.patient.firstName} ${appointment.patient.lastName}
                                    </a>
                                </div>
                            </div>
                            
                            <div class="detail-row">
                                <div class="detail-label">Patient ID</div>
                                <div class="detail-value">${appointment.patient.patientId}</div>
                            </div>
                            
                            <div class="detail-row">
                                <div class="detail-label">Contact</div>
                                <div class="detail-value">
                                    <div>${appointment.patient.phoneNumber}</div>
                                    <div>${appointment.patient.email}</div>
                                </div>
                            </div>
                            
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
                                <div class="detail-label">Created</div>
                                <div class="detail-value">
                                    <fmt:formatDate value="${appointment.createdAt}" pattern="MMM d, yyyy h:mm a" />
                                </div>
                            </div>
                            
                            <c:if test="${appointment.updatedAt != null}">
                                <div class="detail-row">
                                    <div class="detail-label">Last Updated</div>
                                    <div class="detail-value">
                                        <fmt:formatDate value="${appointment.updatedAt}" pattern="MMM d, yyyy h:mm a" />
                                    </div>
                                </div>
                            </c:if>
                            
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
                
                <!-- Patient's Recent Appointments Section -->
                <div class="section-header">
                    <h2>Patient's Recent Appointments</h2>
                </div>
                
                <div class="table-responsive">
                    <table class="data-table recent-appointments-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Dentist</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="recentAppointments" value="${appointmentService.findByPatient(appointment.patient, 5)}" />
                            <c:choose>
                                <c:when test="${empty recentAppointments}">
                                    <tr>
                                        <td colspan="4" class="no-data">No previous appointments found.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="recentAppointment" items="${recentAppointments}">
                                        <tr class="${recentAppointment.id == appointment.id ? 'current-appointment' : ''}">
                                            <td>
                                                <div class="date-badge small">
                                                    <fmt:parseDate value="${recentAppointment.appointmentDate}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="MMM d, yyyy" />
                                                </div>
                                            </td>
                                            <td>
                                                <span class="status-badge status-${fn:toLowerCase(recentAppointment.status)} small">
                                                    ${fn:replace(fn:toLowerCase(recentAppointment.status), '_', ' ')}
                                                </span>
                                            </td>
                                            <td>${recentAppointment.dentist.firstName} ${recentAppointment.dentist.lastName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty recentAppointment.notes}">
                                                        <c:set var="truncatedNotes" value="${fn:substring(recentAppointment.notes, 0, 50)}" />
                                                        ${truncatedNotes}${fn:length(recentAppointment.notes) > 50 ? '...' : ''}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">No notes</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Status Update Modal -->
    <div class="modal" id="statusUpdateModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Update Appointment Status</h3>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <form action="<c:url value='/dentist/appointments/${appointment.id}/update-status'/>" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    
                    <div class="form-group">
                        <label for="status">Status:</label>
                        <select name="status" id="status" class="form-control" required>
                            <c:forEach var="option" items="${statusOptions}">
                                <option value="${option}" ${appointment.status == option ? 'selected' : ''}>
                                    ${fn:replace(fn:toLowerCase(option), '_', ' ')}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="notes">Additional Notes:</label>
                        <textarea name="notes" id="notes" rows="4" class="form-control"
                                  placeholder="Enter any additional notes about this status update..."></textarea>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn-outline" id="modalCancelBtn">Cancel</button>
                        <button type="submit" class="btn-primary">Update Status</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- JavaScript Imports -->
    <script src="<c:url value='/js/common/sidebar.js'/>"></script>
    <script src="<c:url value='/js/dentist/appointment-details.js'/>"></script>
</body>
</html>