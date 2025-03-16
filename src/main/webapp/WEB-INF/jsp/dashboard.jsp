<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>Dashboard - HKDC</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/static/css/dashboard.css'/>">
</head>

<body>
    <div class="dashboard-container">
        <!-- Include sidebar partial -->
        <jsp:include page="partials/sidebar.jsp" />

        <!-- Main Content -->
        <main class="main-content">
            <!-- Include header partial -->
            <jsp:include page="partials/header.jsp" />

            <div class="content-wrapper">
                <div class="page-header">
                    <h1>Dashboard</h1>
                    <p>Welcome back, ${user.username}!</p>
                </div>

                <!-- Patient Dashboard Content -->
                <sec:authorize access="hasRole('PATIENT')">
                    <div class="dashboard-cards">
                        <div class="card">
                            <div class="card-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="card-info">
                                <h3>Upcoming Appointments</h3>
                                <p class="card-value">${upcomingAppointmentsCount}</p>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-icon">
                                <i class="fas fa-history"></i>
                            </div>
                            <div class="card-info">
                                <h3>Past Appointments</h3>
                                <p class="card-value">${pastAppointmentsCount}</p>
                            </div>
                        </div>

                        <div class="card card-action">
                            <a href="<c:url value='/patient/book'/>">
                                <div class="card-icon">
                                    <i class="fas fa-plus-circle"></i>
                                </div>
                                <div class="card-info">
                                    <h3>Book New Appointment</h3>
                                    <p>Schedule your next dental visit</p>
                                </div>
                            </a>
                        </div>
                    </div>

                    <div class="dashboard-sections">
                        <section class="dashboard-section">
                            <div class="section-header">
                                <h2>Upcoming Appointments</h2>
                                <a href="<c:url value='/patient/appointments'/>" class="view-all">View
                                    All</a>
                            </div>

                            <div class="section-content">
                                <c:choose>
                                    <c:when test="${not empty upcomingAppointments}">
                                        <table class="appointments-table">
                                            <thead>
                                                <tr>
                                                    <th>Date</th>
                                                    <th>Time</th>
                                                    <th>Dentist</th>
                                                    <th>Clinic</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${upcomingAppointments}" var="appointment">
                                                    <tr>
                                                        <td>${appointment.appointmentDate}</td>
                                                        <td>${appointment.startTime} -
                                                            ${appointment.endTime}</td>
                                                        <td>Dr. ${appointment.dentist.firstName}
                                                            ${appointment.dentist.lastName}</td>
                                                        <td>${appointment.clinic.name}</td>
                                                        <td>
                                                            <a href="<c:url value='/patient/appointments/${appointment.id}'/>"
                                                                class="btn-view">
                                                                <i class="fas fa-eye"></i> View
                                                            </a>
                                                            <a href="<c:url value='/patient/appointments/${appointment.id}/cancel'/>"
                                                                class="btn-cancel">
                                                                <i class="fas fa-times"></i> Cancel
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <i class="fas fa-calendar-xmark"></i>
                                            <p>You don't have any upcoming appointments</p>
                                            <a href="<c:url value='/patient/book'/>" class="btn-primary">Book
                                                Now</a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </section>

                        <section class="dashboard-section">
                            <div class="section-header">
                                <h2>Clinics</h2>
                            </div>

                            <div class="section-content clinics-grid">
                                <c:forEach items="${clinics}" var="clinic">
                                    <div class="clinic-card">
                                        <h3>${clinic.name}</h3>
                                        <p><i class="fas fa-map-marker-alt"></i> ${clinic.address}</p>
                                        <p><i class="fas fa-phone"></i> ${clinic.phone}</p>
                                        <p><i class="fas fa-clock"></i> ${clinic.openTime} -
                                            ${clinic.closeTime}</p>
                                    </div>
                                </c:forEach>
                            </div>
                        </section>
                    </div>
                </sec:authorize>

                <!-- Dentist Dashboard Content -->
                <sec:authorize access="hasRole('DENTIST')">
                    <div class="dashboard-cards">
                        <div class="card">
                            <div class="card-icon">
                                <i class="fas fa-calendar-day"></i>
                            </div>
                            <div class="card-info">
                                <h3>Today's Appointments</h3>
                                <p class="card-value">${todayAppointmentsCount}</p>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-icon">
                                <i class="fas fa-calendar-week"></i>
                            </div>
                            <div class="card-info">
                                <h3>This Week</h3>
                                <p class="card-value">${weeklyAppointmentsCount}</p>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-icon">
                                <i class="fas fa-user-injured"></i>
                            </div>
                            <div class="card-info">
                                <h3>Total Patients</h3>
                                <p class="card-value">${patientsCount}</p>
                            </div>
                        </div>
                    </div>

                    <div class="dashboard-sections">
                        <section class="dashboard-section">
                            <div class="section-header">
                                <h2>Today's Schedule</h2>
                                <a href="<c:url value='/dentist/schedule'/>" class="view-all">View Full
                                    Schedule</a>
                            </div>

                            <div class="section-content">
                                <c:choose>
                                    <c:when test="${not empty todayAppointments}">
                                        <table class="appointments-table">
                                            <thead>
                                                <tr>
                                                    <th>Time</th>
                                                    <th>Patient</th>
                                                    <th>Clinic</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${todayAppointments}" var="appointment">
                                                    <tr>
                                                        <td>${appointment.startTime} -
                                                            ${appointment.endTime}</td>
                                                        <td>${appointment.patient.firstName}
                                                            ${appointment.patient.lastName}</td>
                                                        <td>${appointment.clinic.name}</td>
                                                        <td>
                                                            <a href="<c:url value='/dentist/appointments/${appointment.id}'/>"
                                                                class="btn-view">
                                                                <i class="fas fa-eye"></i> View
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <i class="fas fa-calendar-day"></i>
                                            <p>You have no appointments scheduled for today</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </section>

                        <section class="dashboard-section">
                            <div class="section-header">
                                <h2>My Weekly Schedule</h2>
                                <a href="<c:url value='/dentist/schedule'/>" class="view-all">Full Calendar</a>
                            </div>

                            <div class="section-content">
                                <div class="weekly-schedule">
                                    <c:forEach items="${weeklySchedule}" var="day">
                                        <div class="schedule-day ${day.isToday ? 'today' : ''}">
                                            <div class="day-header">
                                                <h3>${day.dayOfWeek}</h3>
                                                <span class="day-date">${day.formattedDate}</span>
                                            </div>

                                            <div class="day-content">
                                                <c:choose>
                                                    <c:when test="${not empty day.schedules}">
                                                        <c:forEach items="${day.schedules}" var="schedule">
                                                            <a href="<c:url value='/dentist/appointments/${schedule.appointmentId}'/>"
                                                                class="schedule-slot">
                                                                <div class="time">
                                                                    <i class="fas fa-clock"></i>
                                                                    ${schedule.startTime} - ${schedule.endTime}
                                                                </div>
                                                                <div class="patient">
                                                                    <i class="fas fa-user"></i>
                                                                    ${schedule.patient.firstName}
                                                                    ${schedule.patient.lastName}
                                                                </div>
                                                                <div class="clinic">
                                                                    <i class="fas fa-hospital"></i>
                                                                    ${schedule.clinic.name}
                                                                </div>
                                                                <div
                                                                    class="status status-${fn:toLowerCase(schedule.status)}">
                                                                    ${fn:replace(fn:toLowerCase(schedule.status),
                                                                    '_', ' ')}
                                                                </div>
                                                            </a>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="no-schedule">
                                                            <i class="fas fa-calendar-xmark"></i>
                                                            <p>No appointments</p>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </section>
                    </div>
                </sec:authorize>

                <!-- Admin Dashboard Content -->
                <sec:authorize access="hasRole('ADMIN')">
                    <div class="dashboard-cards">
                        <div class="card">
                            <div class="card-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="card-info">
                                <h3>Total Patients</h3>
                                <p class="card-value">${patientsCount}</p>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-icon">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <div class="card-info">
                                <h3>Dentists</h3>
                                <p class="card-value">${dentistsCount}</p>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-icon">
                                <i class="fas fa-clinic-medical"></i>
                            </div>
                            <div class="card-info">
                                <h3>Clinics</h3>
                                <p class="card-value">${clinicsCount}</p>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <div class="card-info">
                                <h3>Appointments Today</h3>
                                <p class="card-value">${todayAppointmentsCount}</p>
                            </div>
                        </div>
                    </div>

                    <div class="dashboard-sections">
                        <section class="dashboard-section">
                            <div class="section-header">
                                <h2>Recent Appointments</h2>
                                <a href="<c:url value='/admin/appointments'/>" class="view-all">View All</a>
                            </div>

                            <div class="section-content">
                                <table class="appointments-table">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Time</th>
                                            <th>Patient</th>
                                            <th>Dentist</th>
                                            <th>Clinic</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${recentAppointments}" var="appointment">
                                            <tr>
                                                <td>${appointment.appointmentDate}</td>
                                                <td>${appointment.startTime} - ${appointment.endTime}</td>
                                                <td>${appointment.patient.firstName}
                                                    ${appointment.patient.lastName}</td>
                                                <td>Dr. ${appointment.dentist.firstName}
                                                    ${appointment.dentist.lastName}</td>
                                                <td>${appointment.clinic.name}</td>
                                                <td><span
                                                        class="status-badge status-${appointment.status.toLowerCase()}">${appointment.status}</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </section>

                        <div class="admin-quick-actions">
                            <div class="action-card">
                                <i class="fas fa-user-plus"></i>
                                <h3>Add Dentist</h3>
                                <a href="<c:url value='/admin/dentists/new'/>" class="btn-primary">Add
                                    New</a>
                            </div>

                            <div class="action-card">
                                <i class="fas fa-clinic-medical"></i>
                                <h3>Add Clinic</h3>
                                <a href="<c:url value='/admin/clinics/new'/>" class="btn-primary">Add
                                    New</a>
                            </div>

                            <div class="action-card">
                                <i class="fas fa-calendar-alt"></i>
                                <h3>Manage Appointments</h3>
                                <a href="<c:url value='/admin/appointments'/>" class="btn-primary">View</a>
                            </div>

                            <!-- <div class="action-card">
                                        <i class="fas fa-chart-bar"></i>
                                        <h3>Reports</h3>
                                        <a href="<c:url value='/admin/reports'/>" class="btn-primary">View</a>
                                    </div> -->
                        </div>
                    </div>
                </sec:authorize>
            </div>
        </main>
    </div>
</body>

</html>