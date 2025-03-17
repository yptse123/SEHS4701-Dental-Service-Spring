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
                <div class="page-header">
                    <div>
                        <h1>My Appointments</h1>
                        <p>View and manage your appointments</p>
                    </div>
                    <div class="view-actions">
                        <a href="<c:url value='/dentist/schedule'/>" class="btn-primary">
                            <i class="fas fa-calendar-week"></i> Schedule View
                        </a>
                    </div>
                </div>

                <!-- Filter Section -->
                <div class="filter-section">
                    <form action="<c:url value='/dentist/appointments'/>" method="get" class="filter-form">
                        <div class="filter-row">
                            <div class="filter-group">
                                <label for="status">Status:</label>
                                <select name="status" id="status">
                                    <option value="">All Statuses</option>
                                    <c:forEach var="option" items="${statusOptions}">
                                        <option value="${option}" ${status == option ? 'selected' : ''}>
                                            ${fn:replace(fn:toLowerCase(option), '_', ' ')}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <div class="filter-group">
                                <label for="patientName">Patient:</label>
                                <input type="text" name="patientName" id="patientName" value="${patientName}"
                                       placeholder="Patient name...">
                            </div>
                            
                            <div class="filter-group">
                                <label for="startDate">From:</label>
                                <input type="date" name="startDate" id="startDate" 
                                       value="${startDate}" class="date-input">
                            </div>
                            
                            <div class="filter-group">
                                <label for="endDate">To:</label>
                                <input type="date" name="endDate" id="endDate" 
                                       value="${endDate}" class="date-input">
                            </div>
                            
                            <div class="filter-actions">
                                <button type="submit" class="btn-primary">Apply</button>
                                <a href="<c:url value='/dentist/appointments'/>" class="btn-outline">Reset</a>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Appointments List -->
                <div class="table-responsive">
                    <table class="data-table appointments-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Patient</th>
                                <th>Clinic</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty appointments}">
                                    <tr>
                                        <td colspan="6" class="no-data">No appointments found.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="appointment" items="${appointments}">
                                        <tr class="status-${fn:toLowerCase(appointment.status)}">
                                            <td class="date-cell">
                                                <div class="date-badge">
                                                    <fmt:parseDate value="${appointment.appointmentDate}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="MMM d, yyyy" />
                                                </div>
                                            </td>
                                            <td>
                                                <c:if test="${appointment.startTime != null && appointment.endTime != null}">
                                                    <fmt:parseDate value="${appointment.startTime}" pattern="HH:mm" var="parsedStartTime" type="time" />
                                                    <fmt:parseDate value="${appointment.endTime}" pattern="HH:mm" var="parsedEndTime" type="time" />
                                                    <fmt:formatDate value="${parsedStartTime}" pattern="h:mm a" /> - 
                                                    <fmt:formatDate value="${parsedEndTime}" pattern="h:mm a" />
                                                </c:if>
                                            </td>
                                            <td>
                                                <a href="<c:url value='/dentist/patients/${appointment.patient.id}'/>" class="entity-link">
                                                    ${appointment.patient.firstName} ${appointment.patient.lastName}
                                                </a>
                                            </td>
                                            <td>${appointment.clinic.name}</td>
                                            <td>
                                                <span class="status-badge status-${fn:toLowerCase(appointment.status)}">
                                                    ${fn:replace(fn:toLowerCase(appointment.status), '_', ' ')}
                                                </span>
                                            </td>
                                            <td class="actions-cell">
                                                <div class="table-actions">
                                                    <a href="<c:url value='/dentist/appointments/${appointment.id}'/>" 
                                                       class="action-btn" title="View Details">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <c:if test="${appointment.status == 'SCHEDULED'}">
                                                        <button type="button" class="action-btn status-update-btn" 
                                                                data-id="${appointment.id}" 
                                                                data-status="COMPLETED" 
                                                                title="Mark as Completed">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                        <button type="button" class="action-btn status-update-btn" 
                                                                data-id="${appointment.id}" 
                                                                data-status="NO_SHOW" 
                                                                title="Mark as No-Show">
                                                            <i class="fas fa-user-slash"></i>
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 0}">
                    <div class="pagination">
                        <c:set var="prevDisabled" value="${currentPage == 0 ? 'disabled' : ''}" />
                        <c:set var="nextDisabled" value="${currentPage + 1 >= totalPages ? 'disabled' : ''}" />
                        
                        <a href="<c:url value='/dentist/appointments?page=0&size=${pageSize}&status=${status}&startDate=${startDate}&endDate=${endDate}&patientName=${patientName}'/>" 
                           class="page-link ${prevDisabled}" ${prevDisabled}>
                            <i class="fas fa-angle-double-left"></i>
                        </a>
                        <a href="<c:url value='/dentist/appointments?page=${currentPage - 1}&size=${pageSize}&status=${status}&startDate=${startDate}&endDate=${endDate}&patientName=${patientName}'/>" 
                           class="page-link ${prevDisabled}" ${prevDisabled}>
                            <i class="fas fa-angle-left"></i>
                        </a>
                        
                        <c:forEach begin="${Math.max(0, currentPage - 2)}" 
                                   end="${Math.min(totalPages - 1, currentPage + 2)}" var="i">
                            <a href="<c:url value='/dentist/appointments?page=${i}&size=${pageSize}&status=${status}&startDate=${startDate}&endDate=${endDate}&patientName=${patientName}'/>" 
                               class="page-link ${i == currentPage ? 'active' : ''}">
                                ${i + 1}
                            </a>
                        </c:forEach>
                        
                        <a href="<c:url value='/dentist/appointments?page=${currentPage + 1}&size=${pageSize}&status=${status}&startDate=${startDate}&endDate=${endDate}&patientName=${patientName}'/>" 
                           class="page-link ${nextDisabled}" ${nextDisabled}>
                            <i class="fas fa-angle-right"></i>
                        </a>
                        <a href="<c:url value='/dentist/appointments?page=${totalPages - 1}&size=${pageSize}&status=${status}&startDate=${startDate}&endDate=${endDate}&patientName=${patientName}'/>" 
                           class="page-link ${nextDisabled}" ${nextDisabled}>
                            <i class="fas fa-angle-double-right"></i>
                        </a>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
    
    <!-- Status Update Modal -->
    <div class="modal" id="statusUpdateModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">Update Appointment Status</h3>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <form id="statusUpdateForm" action="" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type="hidden" name="status" id="statusInput" />
                    
                    <div class="form-group">
                        <label for="notesInput">Additional Notes:</label>
                        <textarea name="notes" id="notesInput" rows="4" placeholder="Enter any additional notes about this appointment..."></textarea>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn-outline" id="modalCancelBtn">Cancel</button>
                        <button type="submit" class="btn-primary" id="modalConfirmBtn">Update Status</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- JavaScript Imports -->
    <script src="<c:url value='/js/dentist/appointments.js'/>"></script>
</body>
</html>