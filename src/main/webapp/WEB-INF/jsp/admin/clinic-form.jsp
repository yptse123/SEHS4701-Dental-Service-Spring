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
    <title>${clinic.id == null ? 'Add New Clinic' : 'Edit Clinic'} - HKDC Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/admin.css'/>">
    <!-- Remove the forms.css reference -->
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
                        <h1>${clinic.id == null ? 'Add New Clinic' : 'Edit Clinic'}</h1>
                        <p>Manage clinic information</p>
                    </div>
                    <div class="page-actions">
                        <a href="<c:url value='/admin/clinics'/>" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Clinics
                        </a>
                    </div>
                </div>

                <div class="form-container">
                    <form:form action="/admin/clinics" method="post" modelAttribute="clinic">
                        <form:hidden path="id" />
                        <form:hidden path="createdAt" />

                        <div class="form-section">
                            <div class="form-section-title">Basic Information</div>
                            
                            <div class="form-group">
                                <form:label path="name">Clinic Name <span class="required">*</span></form:label>
                                <form:input path="name" class="form-control" required="true" />
                                <form:errors path="name" cssClass="invalid-feedback" />
                            </div>

                            <div class="form-group">
                                <form:label path="address">Address <span class="required">*</span></form:label>
                                <form:textarea path="address" class="form-control" rows="3" required="true" />
                                <form:errors path="address" cssClass="invalid-feedback" />
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <form:label path="city">City</form:label>
                                    <form:input path="city" class="form-control" />
                                    <form:errors path="city" cssClass="invalid-feedback" />
                                </div>

                                <div class="form-group">
                                    <form:label path="postalCode">Postal Code</form:label>
                                    <form:input path="postalCode" class="form-control" />
                                    <form:errors path="postalCode" cssClass="invalid-feedback" />
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <div class="form-section-title">Contact Information</div>

                            <div class="form-row">
                                <div class="form-group">
                                    <form:label path="phoneNumber">Phone Number</form:label>
                                    <form:input path="phoneNumber" class="form-control" type="tel" />
                                    <form:errors path="phoneNumber" cssClass="invalid-feedback" />
                                </div>

                                <div class="form-group">
                                    <form:label path="email">Email Address</form:label>
                                    <form:input path="email" class="form-control" type="email" />
                                    <form:errors path="email" cssClass="invalid-feedback" />
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <div class="form-section-title">Operating Hours</div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <form:label path="openingTime">Opening Time</form:label>
                                    <form:input path="openingTime" class="form-control" type="time" />
                                    <form:errors path="openingTime" cssClass="invalid-feedback" />
                                </div>

                                <div class="form-group">
                                    <form:label path="closingTime">Closing Time</form:label>
                                    <form:input path="closingTime" class="form-control" type="time" />
                                    <form:errors path="closingTime" cssClass="invalid-feedback" />
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <div class="form-section-title">Additional Information</div>

                            <div class="form-group">
                                <form:label path="description">Description</form:label>
                                <form:textarea path="description" class="form-control" rows="5" />
                                <form:errors path="description" cssClass="invalid-feedback" />
                                <small class="text-muted">Provide a brief description of the clinic, its specialties, and available services.</small>
                            </div>

                            <div class="form-check">
                                <form:checkbox path="active" id="activeCheck" class="form-check-input" />
                                <form:label path="active" cssClass="form-check-label" for="activeCheck">Active</form:label>
                                <div class="text-muted small">Inactive clinics won't appear in patient-facing pages</div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <a href="<c:url value='/admin/clinics'/>" class="btn btn-secondary">Cancel</a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> ${clinic.id == null ? 'Create Clinic' : 'Update Clinic'}
                            </button>
                        </div>
                    </form:form>
                </div>
            </div>
        </main>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            // Initialize sidebar state
            if (localStorage.getItem('sidebar-collapsed') === 'true') {
                $('.dashboard-container').addClass('sidebar-collapsed');
            }
        });
    </script>
</body>
</html>