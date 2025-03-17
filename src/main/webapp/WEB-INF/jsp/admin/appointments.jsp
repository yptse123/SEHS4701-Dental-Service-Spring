<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page import="com.example.webapp.util.DateTimeUtils" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>Manage Appointments - HKDC Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
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
                        <h1>Appointments</h1>
                        <p>Manage dental appointments</p>
                    </div>
                    <div class="page-actions">
                        <a href="<c:url value='/admin/appointments/new'/>" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Add Appointment
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
                
                <!-- Filters -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h3>
                            <i class="fas fa-filter"></i> Filters
                            <button type="button" class="toggle-filters btn btn-sm btn-link" title="Toggle filters">
                                <i class="fas fa-chevron-down"></i>
                            </button>
                        </h3>
                    </div>
                    <div class="card-body filter-panel">
                        <form action="<c:url value='/admin/appointments'/>" method="get" id="filterForm">
                            <div class="filter-grid">
                                <!-- First row - Keyword and Participants -->
                                <div class="filter-row">
                                    <div class="filter-col">
                                        <div class="form-group">
                                            <label for="keyword">
                                                <i class="fas fa-search"></i> Keywords
                                            </label>
                                            <input type="text" id="keyword" name="keyword" value="${keyword}" class="form-control" 
                                                placeholder="Search by name, notes...">
                                        </div>
                                    </div>
                                    <div class="filter-col">
                                        <div class="form-group">
                                            <label for="patientId">
                                                <i class="fas fa-user"></i> Patient
                                            </label>
                                            <select id="patientId" name="patientId" class="form-control">
                                                <option value="">All Patients</option>
                                                <c:forEach items="${patients}" var="patient">
                                                    <option value="${patient.id}" ${patient.id eq selectedPatient.id ? 'selected' : ''}>
                                                        ${patient.firstName} ${patient.lastName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="filter-col">
                                        <div class="form-group">
                                            <label for="dentistId">
                                                <i class="fas fa-user-md"></i> Dentist
                                            </label>
                                            <select id="dentistId" name="dentistId" class="form-control">
                                                <option value="">All Dentists</option>
                                                <c:forEach items="${dentists}" var="dentist">
                                                    <option value="${dentist.id}" ${dentist.id eq selectedDentist.id ? 'selected' : ''}>
                                                        Dr. ${dentist.firstName} ${dentist.lastName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Second row - Location, Status, Date Range -->
                                <div class="filter-row">
                                    <div class="filter-col">
                                        <div class="form-group">
                                            <label for="clinicId">
                                                <i class="fas fa-hospital"></i> Clinic
                                            </label>
                                            <select id="clinicId" name="clinicId" class="form-control">
                                                <option value="">All Clinics</option>
                                                <c:forEach items="${clinics}" var="clinic">
                                                    <option value="${clinic.id}" ${clinic.id eq selectedClinic.id ? 'selected' : ''}>
                                                        ${clinic.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="filter-col">
                                        <div class="form-group">
                                            <label for="status">
                                                <i class="fas fa-tag"></i> Status
                                            </label>
                                            <select id="status" name="status" class="form-control">
                                                <option value="">All Statuses</option>
                                                <c:forEach items="${statuses}" var="statusOption">
                                                    <option value="${statusOption}" ${statusOption eq selectedStatus ? 'selected' : ''}>
                                                        ${statusOption}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="filter-col">
                                        <div class="form-group">
                                            <label for="date-range">
                                                <i class="fas fa-calendar"></i> Date Range
                                            </label>
                                            <div class="date-inputs-container">
                                                <div class="date-input-pair">
                                                    <input type="date" id="startDate" name="startDate" value="${startDate}" class="form-control" placeholder="From">
                                                    <span class="date-separator">to</span>
                                                    <input type="date" id="endDate" name="endDate" value="${endDate}" class="form-control" placeholder="To">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Hidden fields for pagination and sorting -->
                                <input type="hidden" name="page" value="0">
                                <input type="hidden" name="size" value="${appointments.size}">
                                <input type="hidden" name="sort" value="${sortField}">
                                <input type="hidden" name="direction" value="${sortDirection}">
                            </div>
                            
                            <div class="filter-actions">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Apply Filters
                                </button>
                                <a href="<c:url value='/admin/appointments'/>" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Clear Filters
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Appointments Table -->
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>
                                    <a href="<c:url value='/admin/appointments?page=${currentPage}&size=${appointments.size}&sort=appointmentDate&direction=${sortField == "appointmentDate" ? reverseSortDirection : "asc"}&patientId=${param.patientId}&dentistId=${param.dentistId}&clinicId=${param.clinicId}&status=${param.status}&startDate=${param.startDate}&endDate=${param.endDate}&keyword=${param.keyword}'/>" 
                                       class="sorted-column ${sortField == 'appointmentDate' ? 'active' : ''}">
                                        Date
                                        <c:if test="${sortField == 'appointmentDate'}">
                                            <i class="fas fa-caret-${sortDirection == 'asc' ? 'up' : 'down'}"></i>
                                        </c:if>
                                    </a>
                                </th>
                                <th>Time</th>
                                <th>Patient</th>
                                <th>Dentist</th>
                                <th>Clinic</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty appointments && appointments.totalElements > 0}">
                                    <c:forEach var="appointment" items="${appointments.content}">
                                        <tr>
                                            <td>
                                                <c:set var="formattedDate" value="${DateTimeUtils.formatDate(appointment.appointmentDate)}" />
                                                ${formattedDate}
                                            </td>
                                            <td>
                                                ${appointment.startTime} - ${appointment.endTime}
                                            </td>
                                            <td>
                                                <a href="<c:url value='/admin/patients/${appointment.patient.id}'/>" class="entity-name">
                                                    ${appointment.patient.firstName} ${appointment.patient.lastName}
                                                </a>
                                                <div class="text-muted small">${appointment.patient.phoneNumber}</div>
                                            </td>
                                            <td>
                                                <a href="<c:url value='/admin/dentists/${appointment.dentist.id}'/>" class="entity-name">
                                                    Dr. ${appointment.dentist.firstName} ${appointment.dentist.lastName}
                                                </a>
                                                <div class="text-muted small">${appointment.dentist.specialization}</div>
                                            </td>
                                            <td>
                                                <a href="<c:url value='/admin/clinics/${appointment.clinic.id}'/>" class="entity-name">
                                                    ${appointment.clinic.name}
                                                </a>
                                            </td>
                                            <td>
                                                <!-- Fix: Don't call toLowerCase() on enum -->
                                                <span class="status-badge status-${fn:toLowerCase(appointment.status)}">
                                                    ${appointment.status}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="actions">
                                                    <a href="<c:url value='/admin/appointments/${appointment.id}'/>" class="action-btn view-btn" title="View details">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    
                                                    <c:if test="${appointment.status == 'SCHEDULED'}">
                                                        <a href="<c:url value='/admin/appointments/${appointment.id}/edit'/>" class="action-btn edit-btn" title="Edit appointment">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        
                                                        <form action="<c:url value='/admin/appointments/${appointment.id}/complete'/>" method="post" class="inline-form">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                            <button type="submit" class="action-btn complete-btn" title="Mark as completed">
                                                                <i class="fas fa-check-circle"></i>
                                                            </button>
                                                        </form>
                                                        
                                                        <form action="<c:url value='/admin/appointments/${appointment.id}/no-show'/>" method="post" class="inline-form">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                            <button type="submit" class="action-btn no-show-btn" title="Mark as no-show">
                                                                <i class="fas fa-user-slash"></i>
                                                            </button>
                                                        </form>
                                                        
                                                        <form action="<c:url value='/admin/appointments/${appointment.id}/cancel'/>" method="post" class="inline-form">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                            <button type="submit" class="action-btn cancel-btn" title="Cancel appointment" 
                                                                onclick="return confirm('Are you sure you want to cancel this appointment?')">
                                                                <i class="fas fa-times-circle"></i>
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="no-results">
                                            <i class="fas fa-calendar-times"></i>
                                            <c:choose>
                                                <c:when test="${not empty keyword or not empty param.patientId or not empty param.dentistId or not empty param.clinicId or not empty param.status or not empty param.startDate or not empty param.endDate}">
                                                    No appointments found matching your search criteria. Try different filters or <a href="<c:url value='/admin/appointments'/>">view all appointments</a>.
                                                </c:when>
                                                <c:otherwise>
                                                    No appointments have been scheduled yet. <a href="<c:url value='/admin/appointments/new'/>">Create a new appointment</a>.
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
                
                <!-- Pagination -->
                <c:if test="${appointments.totalPages > 1}">
                    <div class="pagination">
                        <c:choose>
                            <c:when test="${currentPage > 0}">
                                <a href="<c:url value='/admin/appointments?page=0&size=${appointments.size}&sort=${sortField}&direction=${sortDirection}&patientId=${param.patientId}&dentistId=${param.dentistId}&clinicId=${param.clinicId}&status=${param.status}&startDate=${param.startDate}&endDate=${param.endDate}&keyword=${param.keyword}'/>" class="pagination-btn">
                                    <i class="fas fa-angle-double-left"></i>
                                </a>
                                <a href="<c:url value='/admin/appointments?page=${currentPage - 1}&size=${appointments.size}&sort=${sortField}&direction=${sortDirection}&patientId=${param.patientId}&dentistId=${param.dentistId}&clinicId=${param.clinicId}&status=${param.status}&startDate=${param.startDate}&endDate=${param.endDate}&keyword=${param.keyword}'/>" class="pagination-btn">
                                    <i class="fas fa-angle-left"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="pagination-btn disabled">
                                    <i class="fas fa-angle-double-left"></i>
                                </span>
                                <span class="pagination-btn disabled">
                                    <i class="fas fa-angle-left"></i>
                                </span>
                            </c:otherwise>
                        </c:choose>

                        <c:forEach begin="${Math.max(0, currentPage - 2)}" end="${Math.min(appointments.totalPages - 1, currentPage + 2)}" var="i">
                            <c:choose>
                                <c:when test="${currentPage == i}">
                                    <span class="pagination-btn active">${i + 1}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="<c:url value='/admin/appointments?page=${i}&size=${appointments.size}&sort=${sortField}&direction=${sortDirection}&patientId=${param.patientId}&dentistId=${param.dentistId}&clinicId=${param.clinicId}&status=${param.status}&startDate=${param.startDate}&endDate=${param.endDate}&keyword=${param.keyword}'/>" class="pagination-btn">
                                        ${i + 1}
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <c:choose>
                            <c:when test="${currentPage < appointments.totalPages - 1}">
                                <a href="<c:url value='/admin/appointments?page=${currentPage + 1}&size=${appointments.size}&sort=${sortField}&direction=${sortDirection}&patientId=${param.patientId}&dentistId=${param.dentistId}&clinicId=${param.clinicId}&status=${param.status}&startDate=${param.startDate}&endDate=${param.endDate}&keyword=${param.keyword}'/>" class="pagination-btn">
                                    <i class="fas fa-angle-right"></i>
                                </a>
                                <a href="<c:url value='/admin/appointments?page=${appointments.totalPages - 1}&size=${appointments.size}&sort=${sortField}&direction=${sortDirection}&patientId=${param.patientId}&dentistId=${param.dentistId}&clinicId=${param.clinicId}&status=${param.status}&startDate=${param.startDate}&endDate=${param.endDate}&keyword=${param.keyword}'/>" class="pagination-btn">
                                    <i class="fas fa-angle-double-right"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="pagination-btn disabled">
                                    <i class="fas fa-angle-right"></i>
                                </span>
                                <span class="pagination-btn disabled">
                                    <i class="fas fa-angle-double-right"></i>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
    
    <!-- JavaScript Imports -->
    
    <script>
        // Dynamic filter handling
        document.addEventListener('DOMContentLoaded', function() {
            // Toggle filters panel
            const toggleFilters = document.querySelector('.toggle-filters');
            const filterPanel = document.querySelector('.filter-panel');
            const toggleIcon = toggleFilters.querySelector('i');
            
            toggleFilters.addEventListener('click', function() {
                const isExpanded = filterPanel.style.display !== 'none';
                
                if (isExpanded) {
                    filterPanel.style.display = 'none';
                    toggleIcon.classList.replace('fa-chevron-up', 'fa-chevron-down');
                } else {
                    filterPanel.style.display = 'block';
                    toggleIcon.classList.replace('fa-chevron-down', 'fa-chevron-up');
                }
            });

            // Submit form when select filters change
            document.querySelectorAll('#filterForm select').forEach(select => {
                select.addEventListener('change', function() {
                    document.getElementById('filterForm').submit();
                });
            });
            
            // Auto-submit date filters after selection with small delay
            let dateTimer;
            document.querySelectorAll('#filterForm input[type="date"]').forEach(dateInput => {
                dateInput.addEventListener('change', function() {
                    clearTimeout(dateTimer);
                    dateTimer = setTimeout(function() {
                        document.getElementById('filterForm').submit();
                    }, 500);
                });
            });
        });
    </script>
</body>
</html>