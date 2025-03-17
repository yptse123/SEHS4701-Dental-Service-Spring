<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>Daily Schedule - HKDC System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/schedule.css'/>">
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
                        <h1>Daily Schedule</h1>
                        <p>View and manage your appointments for ${formattedDate}</p>
                    </div>
                    <div class="schedule-nav">
                        <div class="schedule-views">
                            <a href="<c:url value='/dentist/schedule?view=daily&date=${selectedDate}'/>" class="view-btn active">
                                <i class="fas fa-calendar-day"></i> Day
                            </a>
                            <a href="<c:url value='/dentist/schedule?view=weekly&date=${selectedDate}'/>" class="view-btn">
                                <i class="fas fa-calendar-week"></i> Week
                            </a>
                            <a href="<c:url value='/dentist/schedule?view=monthly&date=${selectedDate}'/>" class="view-btn">
                                <i class="fas fa-calendar-alt"></i> Month
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Date Navigation -->
                <div class="date-navigation">
                    <a href="<c:url value='/dentist/schedule?view=daily&date=${previousDay}'/>" class="nav-btn">
                        <i class="fas fa-chevron-left"></i> Previous Day
                    </a>
                    <h2>${formattedDate}</h2>
                    <a href="<c:url value='/dentist/schedule?view=daily&date=${nextDay}'/>" class="nav-btn">
                        Next Day <i class="fas fa-chevron-right"></i>
                    </a>
                </div>

                <!-- Daily Schedule -->
                <div class="schedule-container">
                    <div class="daily-timeline">
                        <!-- Time slots from 9 AM to 5 PM -->
                        <c:forEach var="hour" begin="9" end="17">
                            <div class="time-slot">
                                <div class="time-label">${hour}:00</div>
                                <div class="time-content" data-hour="${hour}">
                                    <!-- Appointments will be placed here by JavaScript -->
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Appointments List -->
                    <div class="appointments-list">
                        <h3>
                            <i class="fas fa-clipboard-list"></i> 
                            Appointments for Today 
                            <span class="appointment-count">${appointments.size()}</span>
                        </h3>
                        
                        <c:choose>
                            <c:when test="${empty appointments}">
                                <div class="no-appointments">
                                    <i class="fas fa-calendar-check"></i>
                                    <p>No appointments scheduled for this day.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="appointment-cards">
                                    <c:forEach var="appointment" items="${appointments}">
                                        <div class="appointment-card" 
                                            data-start="${appointment.startTime}" 
                                            data-end="${appointment.endTime}"
                                            data-id="${appointment.id}"
                                            data-status="${appointment.status}">
                                            <div class="appointment-time">
                                                <c:choose>
                                                    <c:when test="${appointment.startTime != null && appointment.endTime != null}">
                                                        <fmt:parseDate value="${appointment.startTime}" pattern="HH:mm" var="parsedStartTime" type="time" />
                                                        <fmt:parseDate value="${appointment.endTime}" pattern="HH:mm" var="parsedEndTime" type="time" />
                                                        <fmt:formatDate value="${parsedStartTime}" pattern="h:mm a" /> - 
                                                        <fmt:formatDate value="${parsedEndTime}" pattern="h:mm a" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        Time not specified
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="appointment-details">
                                                <h4>
                                                    <i class="fas fa-user"></i> 
                                                    ${appointment.patient.firstName} ${appointment.patient.lastName}
                                                </h4>
                                                <p class="appointment-location">
                                                    <i class="fas fa-clinic-medical"></i> 
                                                    ${appointment.clinic.name}
                                                </p>
                                                <c:if test="${not empty appointment.notes}">
                                                    <p class="appointment-notes">${appointment.notes}</p>
                                                </c:if>
                                                <div class="appointment-status status-${fn:toLowerCase(appointment.status)}">
                                                    ${appointment.status}
                                                </div>
                                            </div>
                                            <div class="appointment-actions">
                                                <a href="<c:url value='/dentist/appointments/${appointment.id}'/>" class="action-btn">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- JavaScript Imports -->
    <script src="<c:url value='/js/dentist/daily-schedule.js'/>"></script>
</body>
</html>