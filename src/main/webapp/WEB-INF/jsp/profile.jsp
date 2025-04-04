<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
                <%@ taglib prefix="df" uri="http://localhost:8080/dateformat" %>

                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <meta name="_csrf" content="${_csrf.token}" />
                        <meta name="_csrf_header" content="${_csrf.headerName}" />
                        <title>My Profile - HKDC</title>
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                        <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
                        <link rel="stylesheet" href="<c:url value='/css/profile.css'/>">
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
                                        <h1>My Profile</h1>
                                        <p>View and manage your personal information</p>
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

                                    <div class="profile-container">
                                        <!-- Profile Overview Section -->
                                        <div class="profile-card profile-overview">
                                            <div class="profile-header">
                                                <div class="profile-image-container">
                                                    <c:choose>
                                                        <c:when test="${not empty user.profile.profileImagePath}">
                                                            <img src="<c:url value='/profile/image/${user.id}'/>"
                                                                alt="Profile Picture" class="profile-image">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="profile-image-placeholder">
                                                                <i class="fas fa-user"></i>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <button class="change-image-btn" id="changeImageBtn">
                                                        <i class="fas fa-camera"></i>
                                                    </button>
                                                </div>
                                                <div class="profile-title">
                                                    <sec:authorize access="hasRole('PATIENT')">
                                                        <!-- Add debugging output -->
                                                        <div style="display:none">
                                                            Debug - Patient object exists: ${patient != null}
                                                            Patient name: ${patient.firstName} ${patient.lastName}
                                                            Patient phone: ${patient.phoneNumber}
                                                        </div>
                                                        
                                                        <h2>${patient.firstName} ${patient.lastName}</h2>
                                                    </sec:authorize>
                                                    <sec:authorize access="!hasRole('PATIENT')">
                                                        <h2>${not empty user.profile.firstName ? user.profile.fullName : user.username}</h2>
                                                    </sec:authorize>
                                                    <p class="profile-subtitle">${user.email}</p>
                                                    
                                                    <div class="profile-role-badge">
                                                        <sec:authorize access="hasRole('ADMIN')">Administrator</sec:authorize>
                                                        <sec:authorize access="hasRole('DENTIST')">Dentist</sec:authorize>
                                                        <sec:authorize access="hasRole('PATIENT')">Patient</sec:authorize>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="profile-stats">
                                                <div class="stat-item">
                                                    <div class="stat-value">
                                                        <i class="fas fa-calendar-check"></i>
                                                        <span>${appointmentCount}</span>
                                                    </div>
                                                    <div class="stat-label">Appointments</div>
                                                </div>
                                                <sec:authorize access="hasRole('PATIENT')">
                                                    <div class="stat-item">
                                                        <div class="stat-value">
                                                            <i class="fas fa-tooth"></i>
                                                            <span>${treatmentCount}</span>
                                                        </div>
                                                        <div class="stat-label">Treatments</div>
                                                    </div>
                                                </sec:authorize>
                                                <div class="stat-item">
                                                    <div class="stat-value">
                                                        <i class="fas fa-clock"></i>
                                                        <span>${df:formatDateTime(user.createdAt, 'MMM yyyy')}</span>
                                                    </div>
                                                    <div class="stat-label">Member Since</div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Personal Information Section -->
                                        <div class="profile-card">
                                            <div class="card-header">
                                                <h3>Personal Information</h3>
                                                <button class="edit-btn" id="editPersonalInfoBtn">
                                                    <i class="fas fa-pencil-alt"></i> Edit
                                                </button>
                                            </div>

                                            <!-- View Mode -->
                                            <div class="info-section" id="personalInfoView">
                                                <div class="info-group">
                                                    <div class="info-label">First Name</div>
                                                    <div class="info-value">
                                                        <sec:authorize access="hasRole('PATIENT')">
                                                            ${not empty patient.firstName ? patient.firstName : 'Not provided'}
                                                        </sec:authorize>
                                                        <sec:authorize access="!hasRole('PATIENT')">
                                                            ${not empty user.profile.firstName ? user.profile.firstName : 'Not provided'}
                                                        </sec:authorize>
                                                    </div>
                                                </div>
                                                <div class="info-group">
                                                    <div class="info-label">Last Name</div>
                                                    <div class="info-value">
                                                        <sec:authorize access="hasRole('PATIENT')">
                                                            ${not empty patient.lastName ? patient.lastName : 'Not provided'}
                                                        </sec:authorize>
                                                        <sec:authorize access="!hasRole('PATIENT')">
                                                            ${not empty user.profile.lastName ? user.profile.lastName : 'Not provided'}
                                                        </sec:authorize>
                                                    </div>
                                                </div>
                                                <div class="info-group">
                                                    <div class="info-label">Phone Number</div>
                                                    <div class="info-value">
                                                        <sec:authorize access="hasRole('PATIENT')">
                                                            ${not empty patient.phoneNumber ? patient.phoneNumber : 'Not provided'}
                                                        </sec:authorize>
                                                        <sec:authorize access="!hasRole('PATIENT')">
                                                            ${not empty user.profile.phoneNumber ? user.profile.phoneNumber : 'Not provided'}
                                                        </sec:authorize>
                                                    </div>
                                                </div>
                                                <div class="info-group">
                                                    <div class="info-label">Date of Birth</div>
                                                    <div class="info-value">
                                                        <sec:authorize access="hasRole('PATIENT')">
                                                            <c:choose>
                                                                <c:when test="${not empty patient.dateOfBirth}">
                                                                    ${df:formatDate(patient.dateOfBirth, 'dd/MM/yyyy')}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Not provided
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </sec:authorize>
                                                        <sec:authorize access="!hasRole('PATIENT')">
                                                            <c:choose>
                                                                <c:when test="${not empty user.profile.dateOfBirth}">
                                                                    ${df:formatDate(user.profile.dateOfBirth, 'dd/MM/yyyy')}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Not provided
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </sec:authorize>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Edit Mode -->
                                            <div class="info-section hidden" id="personalInfoEdit">
                                                <form action="<c:url value='/profile/update-info'/>" method="post">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                                    <div class="form-group">
                                                        <label for="firstName">First Name</label>
                                                        <sec:authorize access="hasRole('PATIENT')">
                                                            <input type="text" id="firstName" name="firstName" value="${patient.firstName}">
                                                        </sec:authorize>
                                                        <sec:authorize access="!hasRole('PATIENT')">
                                                            <input type="text" id="firstName" name="firstName" value="${user.profile.firstName}">
                                                        </sec:authorize>
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="lastName">Last Name</label>
                                                        <sec:authorize access="hasRole('PATIENT')">
                                                            <input type="text" id="lastName" name="lastName" value="${patient.lastName}">
                                                        </sec:authorize>
                                                        <sec:authorize access="!hasRole('PATIENT')">
                                                            <input type="text" id="lastName" name="lastName" value="${user.profile.lastName}">
                                                        </sec:authorize>
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="phoneNumber">Phone Number</label>
                                                        <sec:authorize access="hasRole('PATIENT')">
                                                            <input type="tel" id="phoneNumber" name="phoneNumber" value="${patient.phoneNumber}">
                                                        </sec:authorize>
                                                        <sec:authorize access="!hasRole('PATIENT')">
                                                            <input type="tel" id="phoneNumber" name="phoneNumber" value="${user.profile.phoneNumber}">
                                                        </sec:authorize>
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="dateOfBirth">Date of Birth</label>
                                                        <sec:authorize access="hasRole('PATIENT')">
                                                            <input type="date" id="dateOfBirth" name="dateOfBirth" value="${df:formatDate(patient.dateOfBirth, 'yyyy-MM-dd')}">
                                                        </sec:authorize>
                                                        <sec:authorize access="!hasRole('PATIENT')">
                                                            <input type="date" id="dateOfBirth" name="dateOfBirth" value="${df:formatDate(user.profile.dateOfBirth, 'yyyy-MM-dd')}">
                                                        </sec:authorize>
                                                    </div>

                                                    <div class="form-actions">
                                                        <button type="button" class="btn-cancel" id="cancelPersonalInfoBtn">Cancel</button>
                                                        <button type="submit" class="btn-save">Save Changes</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                        <!-- Contact Information Section -->
                                        <div class="profile-card">
                                            <div class="card-header">
                                                <h3>Contact Information</h3>
                                                <button class="edit-btn" id="editContactInfoBtn">
                                                    <i class="fas fa-pencil-alt"></i> Edit
                                                </button>
                                            </div>

                                            <!-- View Mode -->
                                            <div class="info-section" id="contactInfoView">
                                                <div class="info-group">
                                                    <div class="info-label">Email</div>
                                                    <div class="info-value">${user.email}</div>
                                                </div>
                                                <div class="info-group">
                                                    <div class="info-label">Address</div>
                                                    <div class="info-value">${not empty user.profile.address ?
                                                        user.profile.address : 'Not provided'}</div>
                                                </div>
                                                <div class="info-group">
                                                    <div class="info-label">City</div>
                                                    <div class="info-value">${not empty user.profile.city ?
                                                        user.profile.city : 'Not provided'}</div>
                                                </div>
                                                <div class="info-group">
                                                    <div class="info-label">Postal Code</div>
                                                    <div class="info-value">${not empty user.profile.postalCode ?
                                                        user.profile.postalCode : 'Not provided'}</div>
                                                </div>
                                            </div>

                                            <!-- Edit Mode -->
                                            <div class="info-section hidden" id="contactInfoEdit">
                                                <form action="<c:url value='/profile/update-address'/>" method="post">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                        value="${_csrf.token}" />

                                                    <div class="form-group">
                                                        <label for="address">Address</label>
                                                        <textarea id="address" name="address"
                                                            rows="3">${user.profile.address}</textarea>
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="city">City</label>
                                                        <input type="text" id="city" name="city"
                                                            value="${user.profile.city}">
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="postalCode">Postal Code</label>
                                                        <input type="text" id="postalCode" name="postalCode"
                                                            value="${user.profile.postalCode}">
                                                    </div>

                                                    <div class="form-actions">
                                                        <button type="button" class="btn-cancel"
                                                            id="cancelContactInfoBtn">Cancel</button>
                                                        <button type="submit" class="btn-save">Save Changes</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Hidden image upload form -->
                                    <form id="imageUploadForm" action="<c:url value='/profile/upload-image'/>"
                                        method="post" enctype="multipart/form-data" style="display: none;">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <input type="file" id="profileImage" name="profileImage" accept="image/*">
                                        <input type="submit" value="Upload">
                                    </form>
                                </div>
                            </main>
                        </div>

                        <script src="<c:url value='/js/profile.js'/>"></script>
                    </body>

                    </html>