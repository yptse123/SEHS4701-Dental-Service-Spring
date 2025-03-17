<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>${dentist.id == null ? 'Add New Dentist' : 'Edit Dentist'} - HKDC Admin</title>
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
                        <h1>${dentist.id == null ? 'Add New Dentist' : 'Edit Dentist'}</h1>
                        <p>Manage dentist information</p>
                    </div>
                    <div class="page-actions">
                        <a href="<c:url value='/admin/dentists'/>" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Dentists
                        </a>
                    </div>
                </div>

                <div class="form-container">
                    <form:form action="/admin/dentists" method="post" modelAttribute="dentist">
                        <form:hidden path="id" />
                        <form:hidden path="createdAt" />

                        <div class="form-section">
                            <div class="form-section-title">Personal Information</div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <form:label path="firstName">First Name <span class="required">*</span></form:label>
                                    <form:input path="firstName" class="form-control" required="true" />
                                    <form:errors path="firstName" cssClass="invalid-feedback" />
                                </div>

                                <div class="form-group">
                                    <form:label path="lastName">Last Name <span class="required">*</span></form:label>
                                    <form:input path="lastName" class="form-control" required="true" />
                                    <form:errors path="lastName" cssClass="invalid-feedback" />
                                </div>
                            </div>

                            <div class="form-group">
                                <form:label path="specialization">Specialization</form:label>
                                <form:input path="specialization" class="form-control" />
                                <form:errors path="specialization" cssClass="invalid-feedback" />
                            </div>

                            <div class="form-group">
                                <form:label path="bio">Bio / Professional Summary</form:label>
                                <form:textarea path="bio" class="form-control" rows="5" />
                                <form:errors path="bio" cssClass="invalid-feedback" />
                                <small class="text-muted">Provide a brief professional summary of the dentist's experience, education, and specialties.</small>
                            </div>
                        </div>

                        <!-- User Account Information (Only shown for new dentists) -->
                        <div class="form-section">
                            <div class="form-section-title">Account Information</div>
                            
                            <!-- For new dentists -->
                            <c:choose>
                                <c:when test="${dentist.id == null}">
                                    <div class="form-group">
                                        <label for="username">Username <span class="required">*</span></label>
                                        <input type="text" id="username" name="username" class="form-control" required>
                                        <small class="text-muted">The username will be used for login.</small>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="email">Email <span class="required">*</span></label>
                                        <input type="email" id="email" name="email" class="form-control" required>
                                        <small class="text-muted">Email address for account recovery and notifications.</small>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- For existing dentists -->
                                    <div class="form-group">
                                        <label>Username</label>
                                        <input type="text" class="form-control" value="${dentistUser.username}" disabled readonly />
                                        <small class="text-muted">Username cannot be changed.</small>
                                    </div>
                        
                                    <div class="form-group">
                                        <label>Email</label>
                                        <input type="text" class="form-control" value="${dentistUser.email}" disabled readonly />
                                        <small class="text-muted">Email cannot be changed.</small>
                                    </div>
                                    
                                    <div class="form-check">
                                        <form:checkbox path="active" id="activeCheck" class="form-check-input" />
                                        <form:label path="active" cssClass="form-check-label" for="activeCheck">Active</form:label>
                                        <div class="text-muted small">Inactive dentists won't appear in patient-facing pages</div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Clinic Assignments -->
                        <div class="form-section">
                            <div class="form-section-title">Clinic Assignments</div>

                            <div class="form-group">
                                <label for="primaryClinicId">Primary Clinic</label>
                                <select name="primaryClinicId" id="primaryClinicId" class="form-control">
                                    <option value="">-- Select Primary Clinic --</option>
                                    <c:forEach var="clinic" items="${clinics}">
                                        <option value="${clinic.id}" ${primaryClinicId == clinic.id ? 'selected' : ''}>${clinic.name}</option>
                                    </c:forEach>
                                </select>
                                <small class="text-muted">The main clinic where this dentist practices.</small>
                            </div>

                            <div class="form-group">
                                <label>Secondary Clinics</label>
                                <div class="clinic-checkboxes">
                                    <c:forEach var="clinic" items="${clinics}">
                                        <div class="form-check">
                                            <input type="checkbox" id="clinic-${clinic.id}" name="secondaryClinicIds" value="${clinic.id}" 
                                                class="form-check-input secondary-clinic-checkbox"
                                                <c:if test="${secondaryClinicIds.contains(clinic.id)}">checked</c:if> />
                                            <label for="clinic-${clinic.id}" class="form-check-label">${clinic.name}</label>
                                        </div>
                                    </c:forEach>
                                </div>
                                <small class="text-muted">Other clinics where this dentist may occasionally work.</small>
                            </div>
                        </div>

                        <div class="form-actions">
                            <a href="<c:url value='/admin/dentists'/>" class="btn btn-secondary">Cancel</a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> ${dentist.id == null ? 'Create Dentist' : 'Update Dentist'}
                            </button>
                        </div>
                    </form:form>
                </div>
            </div>
        </main>
    </div>

    <!-- JavaScript Imports -->
    <script src="<c:url value='/js/admin/dentist-form.js'/>"></script>
</body>
</html>