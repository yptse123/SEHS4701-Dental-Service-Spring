<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>${patient.id == null ? 'Add New Patient' : 'Edit Patient'} - HKDC Admin</title>
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
                        <h1>${patient.id == null ? 'Add New Patient' : 'Edit Patient'}</h1>
                        <p>Manage patient information</p>
                    </div>
                    <div class="page-actions">
                        <a href="<c:url value='/admin/patients'/>" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Patients
                        </a>
                    </div>
                </div>

                <div class="form-container">
                    <form:form action="/admin/patients" method="post" modelAttribute="patient">
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

                            <div class="form-row">
                                <div class="form-group">
                                    <form:label path="dateOfBirth">Date of Birth</form:label>
                                    <!-- Change the form:input to regular input with formatted value -->
                                    <c:choose>
                                        <c:when test="${patient.dateOfBirth != null}">
                                            <form:input path="dateOfBirth" type="date" class="form-control" 
                                                value="${patient.dateOfBirth.toString()}" />
                                        </c:when>
                                        <c:otherwise>
                                            <form:input path="dateOfBirth" type="date" class="form-control" />
                                        </c:otherwise>
                                    </c:choose>
                                    <form:errors path="dateOfBirth" cssClass="invalid-feedback" />
                                </div>

                                <div class="form-group">
                                    <form:label path="phoneNumber">Phone Number</form:label>
                                    <form:input path="phoneNumber" class="form-control" />
                                    <form:errors path="phoneNumber" cssClass="invalid-feedback" />
                                </div>
                            </div>

                            <div class="form-group">
                                <form:label path="address">Address</form:label>
                                <form:textarea path="address" class="form-control" rows="3" />
                                <form:errors path="address" cssClass="invalid-feedback" />
                            </div>

                            <c:if test="${patient.id != null}">
                                <div class="form-check">
                                    <form:checkbox path="active" id="active" cssClass="form-check-input" />
                                    <label for="active" class="form-check-label">Active</label>

                                    <input type="hidden" name="_active" value="on" />
                                </div>
                                <div class="form-text text-muted">
                                    Active patients can log in and schedule appointments. Inactive patients cannot access the system.
                                </div>
                            </c:if>
                        </div>

                        <!-- User Account Information (Only shown for new patients) -->
                        <c:if test="${patient.id == null}">
                            <input type="hidden" name="userId" value="${user.id}" />
                            <div class="form-section">
                                <div class="form-section-title">Account Information</div>

                                <div class="form-group">
                                    <label for="username">Username <span class="required">*</span></label>
                                    <input type="text" id="username" name="username" class="form-control" value="${user.username}" required />
                                    <form:errors path="user.username" cssClass="invalid-feedback" />
                                    <small class="text-muted">The username will be used for login.</small>
                                </div>

                                <div class="form-group">
                                    <label for="email">Email <span class="required">*</span></label>
                                    <input type="email" id="email" name="email" class="form-control" value="${user.email}" required />
                                    <form:errors path="user.email" cssClass="invalid-feedback" />
                                </div>
                            </div>
                        </c:if>
                        
                        <!-- For existing patients, just show the email (read-only) -->
                        <c:if test="${patient.id != null}">
                            <div class="form-section">
                                <div class="form-section-title">Account Information</div>

                                <div class="form-group">
                                    <label>Username</label>
                                    <input type="text" class="form-control" value="${user.username}" readonly />
                                    <small class="text-muted">Username cannot be changed.</small>
                                </div>

                                <div class="form-group">
                                    <label>Email</label>
                                    <input type="text" class="form-control" value="${patient.user.email}" readonly />
                                </div>
                            </div>
                        </c:if>

                        <div class="form-actions">
                            <a href="<c:url value='/admin/patients'/>" class="btn btn-secondary">Cancel</a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> ${patient.id == null ? 'Create Patient' : 'Update Patient'}
                            </button>
                        </div>
                    </form:form>
                </div>
            </div>
        </main>
    </div>

    <!-- JavaScript Imports -->
    <script src="<c:url value='/js/common/sidebar.js'/>"></script>
</body>
</html>