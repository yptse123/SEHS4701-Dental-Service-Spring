<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>Patient Details - HKDC Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
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
                        <h1>${patient.firstName} ${patient.lastName}</h1>
                        <p>Patient ID: #${patient.id}</p>
                    </div>
                    <div class="page-actions">
                        <form action="<c:url value='/admin/patients/${patient.id}/toggle-status'/>" method="post" class="d-inline">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button type="submit" class="btn ${patient.active ? 'btn-warning' : 'btn-success'}">
                                <i class="fas ${patient.active ? 'fa-ban' : 'fa-check-circle'}"></i>
                                ${patient.active ? 'Deactivate' : 'Activate'} Patient
                            </button>
                        </form>
                        <a href="<c:url value='/admin/patients/${patient.id}/edit'/>" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit Patient
                        </a>
                        <a href="<c:url value='/admin/patients'/>" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Patients
                        </a>
                    </div>
                </div>
                
                <!-- Success/Error Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        ${successMessage}
                    </div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        ${errorMessage}
                    </div>
                </c:if>
                
                <div class="detail-container">
                    <!-- Personal Information Card -->
                    <div class="detail-card">
                        <div class="card-header">
                            <h3>Personal Information</h3>
                        </div>
                        <div class="info-group">
                            <div class="info-label">Full Name</div>
                            <div class="info-value">${patient.firstName} ${patient.lastName}</div>
                        </div>
                        <div class="info-group">
                            <div class="info-label">Date of Birth</div>
                            <div class="info-value">
                                <c:if test="${not empty patient.dateOfBirth}">
                                    ${patient.formattedDateOfBirth}
                                    <span class="text-muted ml-2">(${patient.age} years)</span>
                                </c:if>
                                <c:if test="${empty patient.dateOfBirth}">
                                    <span class="text-muted">Not provided</span>
                                </c:if>
                            </div>
                        </div>
                        <div class="info-group">
                            <div class="info-label">Phone Number</div>
                            <div class="info-value">
                                <c:if test="${not empty patient.phoneNumber}">
                                    ${patient.phoneNumber}
                                </c:if>
                                <c:if test="${empty patient.phoneNumber}">
                                    <span class="text-muted">Not provided</span>
                                </c:if>
                            </div>
                        </div>
                        <div class="info-group">
                            <div class="info-label">Address</div>
                            <div class="info-value">
                                <c:if test="${not empty patient.address}">
                                    ${patient.address}
                                </c:if>
                                <c:if test="${empty patient.address}">
                                    <span class="text-muted">Not provided</span>
                                </c:if>
                            </div>
                        </div>
                        <div class="form-section">
                            <div class="form-section-title">Status</div>
                            
                            <div class="form-group">
                                <div class="form-check">
                                    <!-- Fix: Proper checkbox binding with Spring form tags -->
                                    <form:checkbox path="active" id="active" cssClass="form-check-input" />
                                    <form:label path="active" cssClass="form-check-label">Active</form:label>
                                    
                                    <!-- This hidden field ensures false value is submitted when checkbox is unchecked -->
                                    <input type="hidden" name="_active" value="on" />
                                </div>
                                <small class="text-muted">Active patients can book appointments and access the system.</small>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Account Information Card -->
                    <div class="detail-card">
                        <div class="card-header">
                            <h3>Account Information</h3>
                        </div>
                        <div class="info-group">
                            <div class="info-label">Username</div>
                            <div class="info-value">${patient.user.username}</div>
                        </div>
                        <div class="info-group">
                            <div class="info-label">Email</div>
                            <div class="info-value">${patient.user.email}</div>
                        </div>
                        <div class="info-group">
                            <div class="info-label">Created On</div>
                            <div class="info-value">
                                ${patient.formattedCreatedAt}
                            </div>
                        </div>
                        <div class="info-group">
                            <div class="info-label">Last Updated</div>
                            <div class="info-value">
                                ${patient.formattedUpdatedAt}
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Appointments Card -->
                <div class="detail-card mt-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h3>Appointment History</h3>
                        <a href="<c:url value='/admin/appointments/new?patientId=${patient.id}'/>" class="btn btn-sm btn-primary">
                            <i class="fas fa-plus"></i> New Appointment
                        </a>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Date & Time</th>
                                    <th>Dentist</th>
                                    <th>Clinic</th>
                                    <th>Service</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty appointments}">
                                        <c:forEach var="appointment" items="${appointments}">
                                            <tr>
                                                <td>
                                                    <fmt:formatDate value="${appointment.appointmentDate}" pattern="MMM d, yyyy" /><br>
                                                    <span class="text-muted small">
                                                        <fmt:formatDate value="${appointment.startTime}" pattern="h:mm a" /> - 
                                                        <fmt:formatDate value="${appointment.endTime}" pattern="h:mm a" />
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="<c:url value='/admin/dentists/${appointment.dentist.id}'/>" class="entity-link">
                                                        Dr. ${appointment.dentist.firstName} ${appointment.dentist.lastName}
                                                    </a>
                                                </td>
                                                <td>
                                                    <a href="<c:url value='/admin/clinics/${appointment.clinic.id}'/>" class="entity-link">
                                                        ${appointment.clinic.name}
                                                    </a>
                                                </td>
                                                <td>${appointment.service.name}</td>
                                                <td>
                                                    <span class="status-badge status-${appointment.status.toLowerCase()}">
                                                        ${appointment.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="actions">
                                                        <a href="<c:url value='/admin/appointments/${appointment.id}'/>" class="action-btn view-btn" title="View details">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="<c:url value='/admin/appointments/${appointment.id}/edit'/>" class="action-btn edit-btn" title="Edit appointment">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="no-results">
                                                <i class="fas fa-calendar"></i>
                                                No appointments found for this patient
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Medical Records Card -->
                <div class="detail-card mt-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h3>Medical Records</h3>
                        <a href="<c:url value='/admin/medical-records/new?patientId=${patient.id}'/>" class="btn btn-sm btn-primary">
                            <i class="fas fa-plus"></i> Add Medical Record
                        </a>
                    </div>
                    
                    <div class="medical-records-placeholder">
                        <p class="text-muted text-center p-4">
                            <i class="fas fa-notes-medical fa-2x mb-3"></i><br>
                            Medical records management will be available soon
                        </p>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- JavaScript Imports -->
    <script src="<c:url value='/js/common/sidebar.js'/>"></script>
</body>
</html>