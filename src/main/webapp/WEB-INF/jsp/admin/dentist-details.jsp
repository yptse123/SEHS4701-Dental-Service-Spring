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
    <title>Dentist Details - HKDC Admin</title>
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
                        <h1>Dr. ${dentist.firstName} ${dentist.lastName}</h1>
                        <p>${dentist.specialization}</p>
                    </div>
                    <div class="page-actions">
                        <form action="<c:url value='/admin/dentists/${dentist.id}/toggle-status'/>" method="post" class="d-inline">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button type="submit" class="btn ${dentist.active ? 'btn-warning' : 'btn-success'}">
                                <i class="fas ${dentist.active ? 'fa-ban' : 'fa-check-circle'}"></i>
                                ${dentist.active ? 'Deactivate' : 'Activate'} Dentist
                            </button>
                        </form>
                        <a href="<c:url value='/admin/dentists/${dentist.id}/edit'/>" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit Dentist
                        </a>
                        <a href="<c:url value='/admin/dentists'/>" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Dentists
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
                            <div class="info-value">Dr. ${dentist.firstName} ${dentist.lastName}</div>
                        </div>
                        <div class="info-group">
                            <div class="info-label">Specialization</div>
                            <div class="info-value">${dentist.specialization}</div>
                        </div>
                        <div class="info-group">
                            <div class="info-label">Status</div>
                            <div class="info-value">
                                <span class="status-badge ${dentist.active ? 'status-active' : 'status-inactive'}">
                                    ${dentist.active ? 'Active' : 'Inactive'}
                                </span>
                            </div>
                        </div>
                        <div class="info-group">
                            <div class="info-label">Bio</div>
                            <div class="info-value description">${dentist.bio}</div>
                        </div>
                    </div>
                    
                    <!-- Account Information Card -->
                    <div class="detail-card">
                        <div class="card-header">
                            <h3>Account Information</h3>
                        </div>
                        <div class="info-group">
                            <div class="info-label">Username</div>
                            <div class="info-value">${dentist.user.username}</div>
                        </div>
                        <div class="info-group">
                            <div class="info-label">Email</div>
                            <div class="info-value">${dentist.user.email}</div>
                        </div>
                        <div class="info-group">
                            <div class="info-label">Created On</div>
                            <div class="info-value">
                                <fmt:formatDate value="${dentist.createdAt}" pattern="MMM d, yyyy" />
                            </div>
                        </div>
                        <div class="info-group">
                            <div class="info-label">Last Updated</div>
                            <div class="info-value">
                                <fmt:formatDate value="${dentist.updatedAt}" pattern="MMM d, yyyy" />
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Clinic Assignments -->
                <div class="detail-card mt-4">
                    <div class="card-header">
                        <h3>Clinic Assignments</h3>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Clinic Name</th>
                                    <th>Address</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty dentist.clinicAssignments}">
                                        <c:forEach var="assignment" items="${dentist.clinicAssignments}">
                                            <tr>
                                                <td>
                                                    <a href="<c:url value='/admin/clinics/${assignment.clinic.id}'/>" class="entity-name">
                                                        ${assignment.clinic.name}
                                                    </a>
                                                    <c:if test="${assignment.primary}">
                                                        <span class="badge badge-primary ml-2">Primary</span>
                                                    </c:if>
                                                </td>
                                                <td>${assignment.clinic.address}</td>
                                                <td>
                                                    <span class="status-badge ${assignment.clinic.active ? 'status-active' : 'status-inactive'}">
                                                        ${assignment.clinic.active ? 'Active' : 'Inactive'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="actions">
                                                        <c:if test="${!assignment.primary}">
                                                            <form action="<c:url value='/admin/dentists/${dentist.id}/assign-clinic'/>" method="post">
                                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                                <input type="hidden" name="clinicId" value="${assignment.clinic.id}" />
                                                                <input type="hidden" name="isPrimary" value="true" />
                                                                <button type="submit" class="btn btn-sm btn-outline-primary">
                                                                    <i class="fas fa-star"></i> Set as Primary
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        <form action="<c:url value='/admin/dentists/${dentist.id}/remove-clinic'/>" 
                                                            method="post" 
                                                            onsubmit="return confirm('Are you sure you want to remove this clinic assignment?');">
                                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                            <input type="hidden" name="clinicId" value="${assignment.clinic.id}" />
                                                            <button type="submit" class="btn btn-sm btn-danger">
                                                                <i class="fas fa-trash"></i> Remove
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="no-results">
                                                <i class="fas fa-hospital"></i>
                                                No clinic assignments found
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- Add Clinic Assignment -->
                    <div class="card-actions mt-3">
                        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="addClinicModal">
                            <i class="fas fa-plus"></i> Add Clinic Assignment
                        </button>
                    </div>
                </div>
                
                <!-- Schedule section - could be expanded in future -->
                <div class="detail-card mt-4">
                    <div class="card-header">
                        <h3>Schedule</h3>
                    </div>
                    <div class="schedule-placeholder">
                        <p class="text-muted text-center p-4">
                            <i class="fas fa-calendar-alt fa-2x mb-3"></i><br>
                            Schedule management will be available soon
                        </p>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Add Clinic Modal -->
    <div class="modal" id="addClinicModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5>Add Clinic Assignment</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form action="<c:url value='/admin/dentists/${dentist.id}/assign-clinic'/>" method="post" id="addClinicForm">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        
                        <div class="form-group">
                            <label for="clinicId">Clinic</label>
                            <select name="clinicId" id="clinicId" class="form-control" required>
                                <option value="">-- Select Clinic --</option>
                                <c:forEach var="clinic" items="${availableClinics}">
                                    <c:set var="alreadyAssigned" value="false" />
                                    <c:forEach var="assignment" items="${dentist.clinicAssignments}">
                                        <c:if test="${assignment.clinic.id == clinic.id}">
                                            <c:set var="alreadyAssigned" value="true" />
                                        </c:if>
                                    </c:forEach>
                                    
                                    <c:if test="${!alreadyAssigned}">
                                        <option value="${clinic.id}">${clinic.name}</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="form-check mb-3">
                            <input type="checkbox" name="isPrimary" id="isPrimary" class="form-check-input" value="true" />
                            <label for="isPrimary" class="form-check-label">Set as primary clinic</label>
                            <div class="text-muted small">This will change the current primary clinic assignment</div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="submit" form="addClinicForm" class="btn btn-primary">Add Assignment</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- JavaScript Imports -->
    <script src="<c:url value='/js/common/sidebar.js'/>"></script>
    <script src="<c:url value='/js/admin/dentist-details.js'/>"></script>
</body>
</html>