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
    <title>My Appointments - HKDC System</title>
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
                        <h1>My Appointments</h1>
                        <p>View and manage your dental appointments</p>
                    </div>
                    <div class="view-actions">
                        <a href="<c:url value='/patient/book'/>" class="btn-primary">
                            <i class="fas fa-plus-circle"></i> Book New Appointment
                        </a>
                    </div>
                </div>

                <!-- Success Message -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> ${successMessage}
                        <button type="button" class="close-alert">&times;</button>
                    </div>
                </c:if>
                
                <!-- Error Message -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                        <button type="button" class="close-alert">&times;</button>
                    </div>
                </c:if>

                <!-- Upcoming Appointments Section -->
                <div class="section-header">
                    <h2>Upcoming Appointments</h2>
                </div>
                
                <div class="card">
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty upcomingAppointments}">
                                <div class="table-responsive">
                                    <table class="appointments-table">
                                        <thead>
                                            <tr>
                                                <th>Date</th>
                                                <th>Time</th>
                                                <th>Dentist</th>
                                                <th>Clinic</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${upcomingAppointments}" var="appointment">
                                                <tr>
                                                    <td>
                                                        <fmt:parseDate value="${appointment.appointmentDate}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                                        <fmt:formatDate value="${parsedDate}" pattern="MMM d, yyyy" />
                                                    </td>
                                                    <td>
                                                        <fmt:parseDate value="${appointment.startTime}" pattern="HH:mm" var="parsedStartTime" type="time" />
                                                        <fmt:formatDate value="${parsedStartTime}" pattern="h:mm a" /> - 
                                                        <fmt:parseDate value="${appointment.endTime}" pattern="HH:mm" var="parsedEndTime" type="time" />
                                                        <fmt:formatDate value="${parsedEndTime}" pattern="h:mm a" />
                                                    </td>
                                                    <td>Dr. ${appointment.dentist.firstName} ${appointment.dentist.lastName}</td>
                                                    <td>${appointment.clinic.name}</td>
                                                    <td>
                                                        <span class="status-badge status-${fn:toLowerCase(appointment.status)}">
                                                            ${fn:replace(fn:toLowerCase(appointment.status), '_', ' ')}
                                                        </span>
                                                    </td>
                                                    <td class="actions">
                                                        <a href="<c:url value='/patient/appointments/${appointment.id}'/>" class="btn-view">
                                                            <i class="fas fa-eye"></i> View
                                                        </a>
                                                        <c:if test="${appointment.status == 'SCHEDULED'}">
                                                            <a href="<c:url value='/patient/appointments/${appointment.id}/cancel'/>" class="btn-cancel">
                                                                <i class="fas fa-times"></i> Cancel
                                                            </a>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-calendar-xmark"></i>
                                    <p>You don't have any upcoming appointments</p>
                                    <a href="<c:url value='/patient/book'/>" class="btn-primary">Book Now</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Past Appointments Section -->
                <div class="section-header">
                    <h2>Past Appointments</h2>
                </div>
                
                <div class="card">
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty pastAppointments}">
                                <div class="table-responsive">
                                    <table class="appointments-table">
                                        <thead>
                                            <tr>
                                                <th>Date</th>
                                                <th>Time</th>
                                                <th>Dentist</th>
                                                <th>Clinic</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${pastAppointments}" var="appointment">
                                                <tr>
                                                    <td>
                                                        <fmt:parseDate value="${appointment.appointmentDate}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                                        <fmt:formatDate value="${parsedDate}" pattern="MMM d, yyyy" />
                                                    </td>
                                                    <td>
                                                        <fmt:parseDate value="${appointment.startTime}" pattern="HH:mm" var="parsedStartTime" type="time" />
                                                        <fmt:formatDate value="${parsedStartTime}" pattern="h:mm a" /> - 
                                                        <fmt:parseDate value="${appointment.endTime}" pattern="HH:mm" var="parsedEndTime" type="time" />
                                                        <fmt:formatDate value="${parsedEndTime}" pattern="h:mm a" />
                                                    </td>
                                                    <td>Dr. ${appointment.dentist.firstName} ${appointment.dentist.lastName}</td>
                                                    <td>${appointment.clinic.name}</td>
                                                    <td>
                                                        <span class="status-badge status-${fn:toLowerCase(appointment.status)}">
                                                            ${fn:replace(fn:toLowerCase(appointment.status), '_', ' ')}
                                                        </span>
                                                    </td>
                                                    <td class="actions">
                                                        <a href="<c:url value='/patient/appointments/${appointment.id}'/>" class="btn-view">
                                                            <i class="fas fa-eye"></i> View
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-history"></i>
                                    <p>No past appointments found</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- JavaScript -->
    <script src="<c:url value='/js/common/sidebar.js'/>"></script>
    <script src="<c:url value='/js/patient/appointments.js'/>"></script>
</body>
</html>