<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>Weekly Schedule - HKDC System</title>
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
                        <h1>Weekly Schedule</h1>
                        <p>View and manage your appointments for the week of ${weekRange}</p>
                    </div>
                    <div class="schedule-nav">
                        <div class="schedule-views">
                            <a href="<c:url value='/dentist/schedule?view=daily&date=${selectedDate}'/>" class="view-btn">
                                <i class="fas fa-calendar-day"></i> Day
                            </a>
                            <a href="<c:url value='/dentist/schedule?view=weekly&date=${selectedDate}'/>" class="view-btn active">
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
                    <a href="<c:url value='/dentist/schedule?view=weekly&date=${previousWeek}'/>" class="nav-btn">
                        <i class="fas fa-chevron-left"></i> Previous Week
                    </a>
                    <h2>${weekRange}</h2>
                    <a href="<c:url value='/dentist/schedule?view=weekly&date=${nextWeek}'/>" class="nav-btn">
                        Next Week <i class="fas fa-chevron-right"></i>
                    </a>
                </div>

                <!-- Weekly Calendar -->
                <div class="weekly-calendar">
                    <!-- Week days header -->
                    <div class="weekly-header">
                        <c:forEach var="entry" items="${weeklySchedule}">
                            <c:set var="day" value="${entry.key}" />
                            <c:set var="dayOfWeek" value="${day.dayOfWeek}" />
                            <c:set var="isToday" value="${day.equals(LocalDate.now())}" />
                            
                            <div class="weekly-day-header ${isToday ? 'today' : ''}">
                                <div class="day-name">${day.format(DateTimeFormatter.ofPattern('EEEE'))}</div>
                                <div class="day-date">${day.format(DateTimeFormatter.ofPattern('d MMM'))}</div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Week grid -->
                    <div class="weekly-grid">
                        <c:forEach var="entry" items="${weeklySchedule}">
                            <c:set var="day" value="${entry.key}" />
                            <c:set var="appointments" value="${entry.value}" />
                            <c:set var="dayOfWeek" value="${day.dayOfWeek.value}" />
                            <c:set var="isWeekend" value="${dayOfWeek == 6 || dayOfWeek == 7}" />
                            <c:set var="isToday" value="${day.equals(LocalDate.now())}" />
                            
                            <div class="weekly-day-column ${isWeekend ? 'weekend' : ''} ${isToday ? 'today' : ''}">
                                <c:choose>
                                    <c:when test="${empty appointments}">
                                        <div class="no-appointments-day">
                                            <p>No appointments</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="appointment" items="${appointments}">
                                            <div class="weekly-appointment status-${fn:toLowerCase(appointment.status)}" 
                                                 data-id="${appointment.id}">
                                                <div class="weekly-appointment-time">
                                                    <fmt:parseDate value="${appointment.startTime}" pattern="HH:mm" var="parsedStartTime" type="time" />
                                                    <fmt:parseDate value="${appointment.endTime}" pattern="HH:mm" var="parsedEndTime" type="time" />
                                                    <fmt:formatDate value="${parsedStartTime}" pattern="h:mm a" /> - 
                                                    <fmt:formatDate value="${parsedEndTime}" pattern="h:mm a" />
                                                </div>
                                                <div class="weekly-appointment-patient">
                                                    ${appointment.patient.firstName} ${appointment.patient.lastName}
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Appointment Popover for Details -->
    <div class="appointment-popover" id="appointmentPopover">
        <div class="popover-close">&times;</div>
        <div class="popover-time" id="popoverTime"></div>
        <div class="popover-details">
            <h4 id="popoverPatient"></h4>
            <p id="popoverClinic"></p>
            <p id="popoverStatus"></p>
        </div>
        <div class="popover-actions">
            <a href="#" class="popover-action view" id="popoverViewLink">View Details</a>
        </div>
    </div>
    
    <!-- JavaScript Imports -->
    <script src="<c:url value='/js/dentist/weekly-schedule.js'/>"></script>
</body>
</html>