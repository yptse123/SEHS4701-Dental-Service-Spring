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
    <title>Book Appointment - HKDC System</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/appointments.css'/>">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
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
                <!-- Page Header with Steps -->
                <div class="page-header">
                    <div>
                        <h1>Book an Appointment</h1>
                        <p>Step 1: Choose a clinic and date</p>
                    </div>
                    <div class="view-actions">
                        <a href="<c:url value='/patient/appointments'/>" class="btn-outline">
                            <i class="fas fa-arrow-left"></i> Back to Appointments
                        </a>
                    </div>
                </div>

                <!-- Error Message -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                        <button type="button" class="close-alert">&times;</button>
                    </div>
                </c:if>

                <!-- Booking Steps Indicator -->
                <div class="booking-steps">
                    <div class="step active">
                        <div class="step-number">1</div>
                        <div class="step-label">Choose Clinic & Date</div>
                    </div>
                    <div class="step-connector"></div>
                    <div class="step">
                        <div class="step-number">2</div>
                        <div class="step-label">Select Time & Dentist</div>
                    </div>
                    <div class="step-connector"></div>
                    <div class="step">
                        <div class="step-number">3</div>
                        <div class="step-label">Confirm Booking</div>
                    </div>
                </div>

                <!-- Booking Form Card -->
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-hospital"></i> Select Clinic & Date</h3>
                    </div>
                    <div class="card-body">
                        <form action="<c:url value='/patient/book/select-date'/>" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                            <div class="form-group">
                                <label for="clinicId">Select a Clinic</label>
                                <select name="clinicId" id="clinicId" class="form-control" required>
                                    <option value="" disabled selected>-- Choose a clinic --</option>
                                    <c:forEach items="${clinics}" var="clinic">
                                        <option value="${clinic.id}">${clinic.name} - ${clinic.address}, ${clinic.city}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="appointmentDate">Select Date</label>
                                <div class="date-input-container">
                                    <input type="text" name="appointmentDate" id="appointmentDate" class="form-control" placeholder="Click to select a date" required readonly>
                                    <i class="fas fa-calendar-alt date-icon"></i>
                                </div>
                                <small class="form-text text-muted">Select a date for your appointment. You can only book appointments up to 30 days in advance.</small>
                            </div>

                            <div class="form-actions">
                                <a href="<c:url value='/patient/appointments'/>" class="btn-outline">Cancel</a>
                                <button type="submit" class="btn-primary">
                                    Continue <i class="fas fa-arrow-right"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Clinics Information Card -->
                <div class="card">
                    <div class="card-header">
                        <h3><i class="fas fa-info-circle"></i> Available Clinics</h3>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="clinics-table">
                                <thead>
                                    <tr>
                                        <th>Clinic Name</th>
                                        <th>Address</th>
                                        <th>Phone</th>
                                        <th>Working Hours</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${clinics}" var="clinic">
                                        <tr>
                                            <td class="clinic-name">${clinic.name}</td>
                                            <td>${clinic.address}, ${clinic.city}, ${clinic.postalCode}</td>
                                            <td>${clinic.phoneNumber}</td>
                                            <td>Mon-Fri: 9:00 AM - 5:00 PM<br>Sat: 9:00 AM - 1:00 PM</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="<c:url value='/js/common/sidebar.js'/>"></script>
    <script src="<c:url value='/js/patient/book-appointment.js'/>"></script>
</body>
</html>