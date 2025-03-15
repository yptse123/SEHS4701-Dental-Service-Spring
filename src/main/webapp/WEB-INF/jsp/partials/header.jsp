<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <header class="main-header">
        <div class="header-search">
            <i class="fas fa-search"></i>
            <input type="text" placeholder="Search...">
        </div>

        <div class="header-actions">
            <div class="notifications">
                <button class="icon-button">
                    <i class="fas fa-bell"></i>
                    <span class="badge">3</span>
                </button>
            </div>

            <div class="user-dropdown">
                <button class="user-dropdown-toggle" id="userDropdownToggle">
                    <c:choose>
                        <c:when test="${not empty user.profile.profileImagePath}">
                            <img src="<c:url value='/profile/image/${user.id}'/>" alt="Profile"
                                class="user-avatar-small">
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-user-circle"></i>
                        </c:otherwise>
                    </c:choose>
                    <span>${user.username}</span>
                    <i class="fas fa-chevron-down"></i>
                </button>

                <div class="dropdown-menu" id="userDropdownMenu">
                    <div class="dropdown-header">
                        <div class="user-info-large">
                            <div class="avatar-large">
                                <c:choose>
                                    <c:when test="${not empty user.profile.profileImagePath}">
                                        <img src="<c:url value='/profile/image/${user.id}'/>" alt="Profile"
                                            class="avatar-image">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-user-circle"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <p class="name-large">${user.username}</p>
                                <p class="email">${user.email}</p>
                                <p class="role-badge">
                                    <sec:authorize access="hasRole('ADMIN')">Administrator
                                    </sec:authorize>
                                    <sec:authorize access="hasRole('DENTIST')">Dentist
                                    </sec:authorize>
                                    <sec:authorize access="hasRole('PATIENT')">Patient
                                    </sec:authorize>
                                </p>
                            </div>
                        </div>
                    </div>

                    <ul class="dropdown-list">
                        <li>
                            <a href="<c:url value='/profile'/>">
                                <i class="fas fa-user"></i> My Profile
                            </a>
                        </li>
                        <li>
                            <a href="<c:url value='/profile/settings'/>">
                                <i class="fas fa-cog"></i> Account Settings
                            </a>
                        </li>
                        <li class="dropdown-divider"></li>
                        <li>
                            <a href="javascript:void(0)" onclick="document.getElementById('logoutForm').submit();">
                                <i class="fas fa-sign-out-alt"></i> Logout
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </header>

    <script>
        // Initialize sidebar state from localStorage if available
        document.addEventListener('DOMContentLoaded', function () {
            const userDropdownToggle = document.getElementById('userDropdownToggle');
            const userDropdownMenu = document.getElementById('userDropdownMenu');

            if (userDropdownToggle && userDropdownMenu) {
                // Toggle dropdown when clicking the button
                userDropdownToggle.addEventListener('click', function (e) {
                    e.preventDefault();
                    e.stopPropagation();
                    userDropdownMenu.classList.toggle('active');

                    // Rotate the chevron icon
                    const chevronIcon = this.querySelector('.fa-chevron-down');
                    if (userDropdownMenu.classList.contains('active')) {
                        chevronIcon.style.transform = 'rotate(180deg)';
                    } else {
                        chevronIcon.style.transform = 'rotate(0deg)';
                    }
                });

                // Close dropdown when clicking outside
                document.addEventListener('click', function (e) {
                    if (!userDropdownToggle.contains(e.target) && !userDropdownMenu.contains(e.target)) {
                        userDropdownMenu.classList.remove('active');
                        userDropdownToggle.querySelector('.fa-chevron-down').style.transform = 'rotate(0deg)';
                    }
                });

                // Close dropdown when pressing Escape key
                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape' && userDropdownMenu.classList.contains('active')) {
                        userDropdownMenu.classList.remove('active');
                        userDropdownToggle.querySelector('.fa-chevron-down').style.transform = 'rotate(0deg)';
                    }
                });
            }
        });
    </script>