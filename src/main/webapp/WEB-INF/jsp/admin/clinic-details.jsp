<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>${clinic.name} - Clinic Details | HKDC Admin</title>
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
                        <h1>${clinic.name}</h1>
                        <p>Clinic Details</p>
                    </div>
                    <div class="page-actions">
                        <a href="<c:url value='/admin/clinics/${clinic.id}/edit'/>" class="btn btn-primary">
                            <i class="fas fa-edit"></i> Edit Clinic
                        </a>
                        <form action="<c:url value='/admin/clinics/${clinic.id}/toggle-status'/>" method="post" class="d-inline">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button type="submit" class="btn ${clinic.active ? 'btn-warning' : 'btn-success'}">
                                <i class="fas ${clinic.active ? 'fa-ban' : 'fa-check-circle'}"></i>
                                ${clinic.active ? 'Deactivate' : 'Activate'} Clinic
                            </button>
                        </form>
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
                    <!-- Clinic Info Section -->
                    <div class="detail-card">
                        <div class="card-header">
                            <h3>Clinic Information</h3>
                            <span class="badge ${clinic.active ? 'badge-success' : 'badge-inactive'}">
                                ${clinic.active ? 'Active' : 'Inactive'}
                            </span>
                        </div>
                        
                        <div class="info-group">
                            <div class="info-label">Name</div>
                            <div class="info-value">${clinic.name}</div>
                        </div>
                        
                        <div class="info-group">
                            <div class="info-label">Address</div>
                            <div class="info-value">${clinic.address}</div>
                        </div>
                        
                        <div class="info-group">
                            <div class="info-label">City</div>
                            <div class="info-value">${clinic.city}</div>
                        </div>
                        
                        <div class="info-group">
                            <div class="info-label">Postal Code</div>
                            <div class="info-value">${clinic.postalCode}</div>
                        </div>
                        
                        <div class="info-group">
                            <div class="info-label">Phone</div>
                            <div class="info-value">${clinic.phoneNumber}</div>
                        </div>
                        
                        <div class="info-group">
                            <div class="info-label">Email</div>
                            <div class="info-value">${clinic.email}</div>
                        </div>
                        
                        <div class="info-group">
                            <div class="info-label">Business Hours</div>
                            <div class="info-value">${clinic.openingTime} - ${clinic.closingTime}</div>
                        </div>
                        
                        <div class="info-group">
                            <div class="info-label">Description</div>
                            <div class="info-value description">${clinic.description}</div>
                        </div>
                    </div>
                    
                    <!-- Assigned Dentists Section -->
                    <div class="detail-card">
                        <div class="card-header">
                            <h3>Assigned Dentists</h3>
                            <button class="btn btn-sm btn-primary" data-toggle="modal" data-target="#assignDentistModal">
                                <i class="fas fa-user-plus"></i> Assign Dentist
                            </button>
                        </div>
                        
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Specialization</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty dentists}">
                                            <c:forEach var="dentist" items="${dentists}">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="avatar-small">
                                                                <i class="fas fa-user-md"></i>
                                                            </div>
                                                            <div class="ml-2">
                                                                <div class="strong">${dentist.firstName} ${dentist.lastName}</div>
                                                                <div class="small text-muted">${dentist.user.email}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>${dentist.specialization}</td>
                                                    <td>
                                                        <c:forEach var="assignment" items="${dentist.clinicAssignments}">
                                                            <c:if test="${assignment.clinic.id == clinic.id}">
                                                                <span class="badge ${assignment.primary ? 'badge-primary' : 'badge-secondary'}">
                                                                    ${assignment.primary ? 'Primary' : 'Secondary'}
                                                                </span>
                                                            </c:if>
                                                        </c:forEach>
                                                    </td>
                                                    <td>
                                                        <div class="dentist-actions">
                                                            <form action="<c:url value='/admin/clinics/${clinic.id}/remove-dentist'/>" method="post" onsubmit="return confirm('Are you sure you want to remove this dentist from the clinic?');">
                                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                                <input type="hidden" name="dentistId" value="${dentist.id}" />
                                                                <button type="submit" class="btn btn-sm btn-danger dentist-action-btn">
                                                                    <i class="fas fa-trash"></i> Remove
                                                                </button>
                                                            </form>
                                                            
                                                            <c:forEach var="assignment" items="${dentist.clinicAssignments}">
                                                                <c:if test="${assignment.clinic.id == clinic.id && !assignment.primary}">
                                                                    <form action="<c:url value='/admin/clinics/${clinic.id}/assign-dentist'/>" method="post">
                                                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                                        <input type="hidden" name="dentistId" value="${dentist.id}" />
                                                                        <input type="hidden" name="isPrimary" value="true" />
                                                                        <button type="submit" class="btn btn-sm btn-outline-primary dentist-action-btn">
                                                                            <i class="fas fa-star"></i> Set as Primary
                                                                        </button>
                                                                    </form>
                                                                </c:if>
                                                            </c:forEach>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="4" class="text-center">No dentists assigned to this clinic yet.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Assign Dentist Modal -->
    <div class="modal" id="assignDentistModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Assign Dentist to ${clinic.name}</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form action="<c:url value='/admin/clinics/${clinic.id}/assign-dentist'/>" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="dentistId">Select Dentist</label>
                            <select class="form-control" id="dentistId" name="dentistId" required>
                                <option value="">-- Select a dentist --</option>
                                <c:forEach var="dentist" items="${allDentists}">
                                    <c:set var="isAssigned" value="false" />
                                    <c:forEach var="assignedDentist" items="${dentists}">
                                        <c:if test="${assignedDentist.id == dentist.id}">
                                            <c:set var="isAssigned" value="true" />
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${!isAssigned}">
                                        <option value="${dentist.id}">${dentist.firstName} ${dentist.lastName} - ${dentist.specialization}</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="isPrimary" name="isPrimary">
                                <label class="form-check-label" for="isPrimary">
                                    Set as primary clinic for this dentist
                                </label>
                            </div>
                        </div>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Assign Dentist</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>