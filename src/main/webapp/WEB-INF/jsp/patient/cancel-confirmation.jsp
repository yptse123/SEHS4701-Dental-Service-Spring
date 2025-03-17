<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>Cancel Appointment - HKDC System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/appointments.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/patient/cancel-confirmation.css'/>">
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
                        <h1>Cancel Appointment</h1>
                        <p>Please confirm that you want to cancel this appointment</p>
                    </div>
                    <div class="view-actions">
                        <a href="<c:url value='/patient/appointments'/>" class="btn-outline">
                            <i class="fas fa-arrow-left"></i> Back to Appointments
                        </a>
                    </div>
                </div>

                <!-- Cancellation Warning Card -->
                <div class="card cancellation-warning">
                    <div class="card-body">
                        <div class="warning-icon">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <div class="warning-content">
                            <h3>Important Notice</h3>
                            <p>You are about to cancel your dental appointment. Please note our cancellation policy:</p>
                            <ul>
                                <li>Cancellations made within 24 hours of the appointment may incur a cancellation fee.</li>
                                <li>This slot will be made available to other patients once cancelled.</li>
                                <li>The cancellation cannot be undone once confirmed.</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Appointment Details Card -->
                <div class="card">
                    <div class="card-header">
                        <h3>Appointment Details</h3>
                    </div>
                    <div class="card-body">
                        <div class="appointment-summary">
                            <div class="summary-row">
                                <div class="summary-label">Date</div>
                                <div class="summary-value">
                                    <fmt:parseDate value="${appointment.appointmentDate}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                    <fmt:formatDate value="${parsedDate}" pattern="EEEE, MMMM d, yyyy" />
                                </div>
                            </div>
                            
                            <div class="summary-row">
                                <div class="summary-label">Time</div>
                                <div class="summary-value">
                                    <fmt:parseDate value="${appointment.startTime}" pattern="HH:mm" var="parsedStartTime" type="time" />
                                    <fmt:formatDate value="${parsedStartTime}" pattern="h:mm a" /> - 
                                    <fmt:parseDate value="${appointment.endTime}" pattern="HH:mm" var="parsedEndTime" type="time" />
                                    <fmt:formatDate value="${parsedEndTime}" pattern="h:mm a" />
                                </div>
                            </div>
                            
                            <div class="summary-row">
                                <div class="summary-label">Dentist</div>
                                <div class="summary-value">Dr. ${appointment.dentist.firstName} ${appointment.dentist.lastName}</div>
                            </div>
                            
                            <div class="summary-row">
                                <div class="summary-label">Clinic</div>
                                <div class="summary-value">${appointment.clinic.name}</div>
                            </div>
                            
                            <div class="summary-row">
                                <div class="summary-label">Address</div>
                                <div class="summary-value">
                                    ${appointment.clinic.address},
                                    ${appointment.clinic.city}, 
                                    ${appointment.clinic.postalCode}
                                </div>
                            </div>
                            
                            <c:if test="${not empty appointment.notes}">
                                <div class="summary-row">
                                    <div class="summary-label">Notes</div>
                                    <div class="summary-value">
                                        <c:set var="notesWithLineBreaks" value="${fn:replace(appointment.notes, '&#10;', '<br/>')}" />
                                        ${notesWithLineBreaks}
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Cancellation Form Card -->
                <div class="card">
                    <div class="card-header">
                        <h3>Cancellation Reason</h3>
                    </div>
                    <div class="card-body">
                        <form action="<c:url value='/patient/appointments/${appointment.id}/cancel'/>" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            
                            <div class="form-group">
                                <label for="cancellationReason">Please tell us why you're cancelling (optional):</label>
                                <select id="cancellationReason" name="cancellationReason" class="form-control">
                                    <option value="">-- Select a reason --</option>
                                    <option value="Schedule conflict">Schedule conflict</option>
                                    <option value="Health reasons">Health reasons</option>
                                    <option value="Transportation issues">Transportation issues</option>
                                    <option value="Found another dentist">Found another dentist</option>
                                    <option value="No longer needed">No longer needed</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            
                            <div id="otherReasonField" class="form-group" style="display:none;">
                                <label for="otherReason">Please specify:</label>
                                <textarea id="otherReason" name="otherReason" class="form-control" rows="3"></textarea>
                            </div>

                            <div class="form-actions">
                                <a href="<c:url value='/patient/appointments/${appointment.id}'/>" class="btn-outline">
                                    <i class="fas fa-times"></i> Keep Appointment
                                </a>
                                <button type="submit" class="btn-primary btn-danger">
                                    <i class="fas fa-check"></i> Confirm Cancellation
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- JavaScript -->
    <script src="<c:url value='/js/common/sidebar.js'/>"></script>
    <script src="<c:url value='/js/patient/cancel-confirmation.js'/>"></script>
</body>
</html>