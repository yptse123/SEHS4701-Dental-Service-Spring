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
                <title>Account Settings - HKDC</title>
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
                <link rel="stylesheet" href="<c:url value='/css/profile-settings.css'/>">
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
                                <h1>Account Settings</h1>
                                <p>Manage your account information and security settings</p>
                            </div>

                            <div class="settings-container">
                                <!-- Success/Error Messages -->
                                <c:if test="${not empty successMessage}">
                                    <div class="alert alert-success">
                                        ${successMessage}
                                    </div>
                                </c:if>

                                <!-- Account Preferences Card -->
                                <div class="settings-card">
                                    <h2>Notification Preferences</h2>

                                    <form action="<c:url value='/profile/update-preferences'/>" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                        <div class="form-group">
                                            <label class="checkbox-label">
                                                <input type="checkbox" name="emailNotifications" ${(user.preferences
                                                    !=null && user.preferences.emailNotifications) ? 'checked' : '' }>
                                                Email notifications for upcoming appointments
                                            </label>
                                        </div>

                                        <div class="form-group">
                                            <label class="checkbox-label">
                                                <input type="checkbox" name="smsNotifications" ${(user.preferences
                                                    !=null && user.preferences.smsNotifications) ? 'checked' : '' }>
                                                SMS notifications for appointment reminders
                                            </label>
                                        </div>

                                        <div class="form-actions">
                                            <button type="submit" class="btn-save">Save Preferences</button>
                                        </div>
                                    </form>
                                </div>

                                <!-- Update Email Card -->
                                <div class="settings-card">
                                    <h2>Update Email</h2>
                                    <c:if test="${not empty emailError}">
                                        <div class="alert alert-danger">
                                            ${emailError}
                                        </div>
                                    </c:if>

                                    <form action="<c:url value='/profile/update-email'/>" method="post">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                        <div class="form-group">
                                            <label for="email">Email Address</label>
                                            <input type="email" id="email" name="email" value="${user.email}" required>
                                        </div>

                                        <div class="form-actions">
                                            <button type="submit" class="btn-save">Update Email</button>
                                        </div>
                                    </form>
                                </div>

                                <!-- Update Password Card -->
                                <div class="settings-card">
                                    <h2>Change Password</h2>
                                    <c:if test="${not empty passwordError}">
                                        <div class="alert alert-danger">
                                            ${passwordError}
                                        </div>
                                    </c:if>

                                    <form:form action="${pageContext.request.contextPath}/profile/update-password"
                                        method="post" modelAttribute="passwordUpdateDto">

                                        <div class="form-group">
                                            <label for="currentPassword">Current Password</label>
                                            <form:password path="currentPassword" class="form-control"
                                                required="true" />
                                            <form:errors path="currentPassword" cssClass="field-error" />
                                        </div>

                                        <div class="form-group">
                                            <label for="newPassword">New Password</label>
                                            <form:password path="newPassword" class="form-control" required="true" />
                                            <form:errors path="newPassword" cssClass="field-error" />
                                        </div>

                                        <div class="form-group">
                                            <label for="confirmPassword">Confirm New Password</label>
                                            <form:password path="confirmPassword" class="form-control"
                                                required="true" />
                                            <form:errors path="confirmPassword" cssClass="field-error" />
                                        </div>

                                        <div class="form-actions">
                                            <button type="submit" class="btn-save">Update Password</button>
                                        </div>
                                    </form:form>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        // Add password form validation
                        const passwordForm = document.querySelector('form[action*="update-password"]');
                        if (passwordForm) {
                            passwordForm.addEventListener('submit', function (e) {
                                const newPassword = document.getElementById('newPassword').value;
                                const confirmPassword = document.getElementById('confirmPassword').value;

                                if (newPassword !== confirmPassword) {
                                    e.preventDefault();

                                    // Show error message
                                    const errorDiv = document.createElement('div');
                                    errorDiv.className = 'alert alert-danger';
                                    errorDiv.textContent = 'Passwords do not match';

                                    // Remove any existing error messages
                                    const existingErrors = document.querySelectorAll('.alert-danger');
                                    existingErrors.forEach(el => el.remove());

                                    // Insert error before the form
                                    passwordForm.parentNode.insertBefore(errorDiv, passwordForm);

                                    // Scroll to error
                                    errorDiv.scrollIntoView({ behavior: 'smooth' });
                                }
                            });
                        }
                    });
                </script>
            </body>

            </html>