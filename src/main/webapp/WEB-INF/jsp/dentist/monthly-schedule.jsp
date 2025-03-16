<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page import="java.time.LocalDate" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>Monthly Schedule - HKDC System</title>
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
                        <h1>Monthly Schedule</h1>
                        <p>View and manage your appointments for ${formattedMonth}</p>
                    </div>
                    <div class="schedule-nav">
                        <div class="schedule-views">
                            <a href="<c:url value='/dentist/schedule?view=daily&date=${currentMonth}'/>" class="view-btn">
                                <i class="fas fa-calendar-day"></i> Day
                            </a>
                            <a href="<c:url value='/dentist/schedule?view=weekly&date=${currentMonth}'/>" class="view-btn">
                                <i class="fas fa-calendar-week"></i> Week
                            </a>
                            <a href="<c:url value='/dentist/schedule?view=monthly&date=${currentMonth}'/>" class="view-btn active">
                                <i class="fas fa-calendar-alt"></i> Month
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Date Navigation -->
                <div class="date-navigation">
                    <a href="<c:url value='/dentist/schedule?view=monthly&date=${previousMonth}'/>" class="nav-btn">
                        <i class="fas fa-chevron-left"></i> Previous Month
                    </a>
                    <h2>${formattedMonth}</h2>
                    <a href="<c:url value='/dentist/schedule?view=monthly&date=${nextMonth}'/>" class="nav-btn">
                        Next Month <i class="fas fa-chevron-right"></i>
                    </a>
                </div>

                <!-- Monthly Calendar -->
                <div class="monthly-calendar">
                    <!-- Month header with day names -->
                    <div class="month-header">
                        <div class="month-day-name">Monday</div>
                        <div class="month-day-name">Tuesday</div>
                        <div class="month-day-name">Wednesday</div>
                        <div class="month-day-name">Thursday</div>
                        <div class="month-day-name">Friday</div>
                        <div class="month-day-name">Saturday</div>
                        <div class="month-day-name">Sunday</div>
                    </div>
                    
                    <!-- Month grid -->
                    <div class="month-grid">
                        <%-- Calculate and display days before the first day of month --%>
                        <c:forEach begin="1" end="${firstDayOfWeek - 1}" varStatus="status">
                            <div class="month-day different-month"></div>
                        </c:forEach>
                        
                        <%-- Display all days in the month --%>
                        <c:forEach begin="1" end="${daysInMonth}" varStatus="day">
                            <c:set var="currentDate" value="${currentMonth.withDayOfMonth(day.index)}" />
                            <c:set var="isToday" value="${currentDate.equals(LocalDate.now())}" />
                            <c:set var="dayOfWeek" value="${currentDate.dayOfWeek.value}" />
                            <c:set var="isWeekend" value="${dayOfWeek == 6 || dayOfWeek == 7}" />
                            
                            <div class="month-day ${isToday ? 'today' : ''} ${isWeekend ? 'weekend' : ''}">
                                <div class="month-day-number">${day.index}</div>
                                
                                <div class="month-appointments">
                                    <c:set var="dayAppointments" value="${monthlySchedule[currentDate]}" />
                                    <c:set var="appointmentCount" value="${dayAppointments.size()}" />
                                    <c:set var="displayCount" value="${appointmentCount > 3 ? 3 : appointmentCount}" />
                                    
                                    <c:forEach var="appointment" items="${dayAppointments}" begin="0" end="2">
                                        <div class="month-appointment status-${fn:toLowerCase(appointment.status)}" 
                                             data-id="${appointment.id}">
                                            <fmt:parseDate value="${appointment.startTime}" pattern="HH:mm" var="parsedTime" type="time" />
                                            <fmt:formatDate value="${parsedTime}" pattern="h:mm a" /> - 
                                            ${appointment.patient.lastName}
                                        </div>
                                    </c:forEach>
                                    
                                    <c:if test="${appointmentCount > 3}">
                                        <div class="month-more-indicator" data-date="${currentDate}">
                                            +${appointmentCount - 3} more
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <%-- Calculate and display days after the last day of month to complete grid --%>
                        <c:set var="remainingDays" value="${7 - ((firstDayOfWeek - 1 + daysInMonth) % 7)}" />
                        <c:if test="${remainingDays < 7}">
                            <c:forEach begin="1" end="${remainingDays}" varStatus="status">
                                <div class="month-day different-month"></div>
                            </c:forEach>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- JavaScript Imports -->
    <script src="<c:url value='/js/common/sidebar.js'/>"></script>
    <script src="<c:url value='/js/dentist/monthly-schedule.js'/>"></script>
</body>
</html>