<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

        <aside class="sidebar">
            <div class="sidebar-header">
           
                <h2><i class="fas fa-tooth"></i>  
                    
                    <!-- <img src="<c:url value='/static/image/smile dental logo.png'/>" alt="HK Dental Care Logo" height="40"> -->
                    <span>  Dental</span> <span class="main-color" style="color: #8fd7f8;">Care</span>  
                
                </h2>
            </div>

            <div class="sidebar-user">
                <div class="avatar">
                    <i class="fas fa-user-circle"></i>
                </div>
                <div class="user-info">
                    <p class="name">${user.username}</p>
                    <p class="role">
                        <sec:authorize access="hasRole('ADMIN')">Administrator</sec:authorize>
                        <sec:authorize access="hasRole('DENTIST')">Dentist</sec:authorize>
                        <sec:authorize access="hasRole('PATIENT')">Patient</sec:authorize>
                    </p>
                </div>
            </div>

            <nav class="sidebar-nav">
                <ul>
                    <li>
                        <a href="<c:url value='/dashboard'/>" data-title="Dashboard">
                            <i class="fas fa-tachometer-alt"></i> <span>Dashboard</span>
                        </a>
                    </li>

                    <!-- Common links for all users -->
                    <li>
                        <a href="<c:url value='/profile'/>" data-title="Profile">
                            <i class="fas fa-user"></i> <span>Profile</span>
                        </a>
                    </li>

                    <!-- Patient-specific links -->
                    <sec:authorize access="hasRole('PATIENT')">
                        <li><a href="<c:url value='/patient/appointments'/>" data-title="My Appointments"><i
                                    class="fas fa-calendar-check"></i> <span>My Appointments</span></a></li>
                        <li><a href="<c:url value='/patient/book'/>" data-title="Book Appointment"><i
                                    class="fas fa-calendar-plus"></i>
                                <span>Book Appointment</span></a></li>
                    </sec:authorize>

                    <!-- Dentist-specific links -->
                    <sec:authorize access="hasRole('DENTIST')">
                        <li><a href="<c:url value='/dentist/schedule'/>" data-title="My Schedule"><i
                                    class="fas fa-calendar-alt"></i>
                                <span>My Schedule</span></a></li>
                        <li><a href="<c:url value='/dentist/appointments'/>" data-title="Appointments"><i
                                    class="fas fa-calendar-check"></i> <span>Appointments</span></a></li>
                    </sec:authorize>

                    <!-- Admin-specific links -->
                    <sec:authorize access="hasRole('ADMIN')">
                        <li><a href="<c:url value='/admin/clinics'/>" data-title="Manage Clinics"><i
                                    class="fas fa-clinic-medical"></i>
                                <span>Manage Clinics</span></a></li>
                        <li><a href="<c:url value='/admin/dentists'/>" data-title="Manage Dentists"><i
                                    class="fas fa-user-md"></i>
                                <span>Manage Dentists</span></a></li>
                        <li><a href="<c:url value='/admin/patients'/>" data-title="Manage Patients"><i
                                    class="fas fa-users"></i>
                                <span>Manage Patients</span></a></li>
                        <li><a href="<c:url value='/admin/appointments'/>" data-title="All Appointments"><i
                                    class="fas fa-calendar-alt"></i> <span>All Appointments</span></a></li>
                    </sec:authorize>

                    <li>
                        <form id="logoutForm" action="<c:url value='/logout'/>" method="post" data-title="Logout">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        </form>
                        <a href="javascript:void(0)" onclick="document.getElementById('logoutForm').submit();">
                            <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>

        <script src="<c:url value='/js/common/sidebar.js'/>"></script>