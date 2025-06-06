<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
        <title>Manage Dentists - HKDC Admin</title>
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
                            <h1>Dentists</h1>
                            <p>Manage dentists and their clinic assignments</p>
                        </div>
                        <div class="page-actions">
                            <a href="<c:url value='/admin/dentists/new'/>" class="btn btn-primary">
                                <i class="fas fa-user-plus"></i> Add Dentist
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

                    <!-- Search Form -->
                    <div class="filters-container">
                        <form action="<c:url value='/admin/dentists'/>" method="get" class="search-form">
                            <div class="search-input-wrapper">
                                <input type="text" name="keyword" placeholder="Search by name or specialization..."
                                    value="${keyword}" />
                                <button type="submit" class="search-btn">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                            <c:if test="${not empty keyword}">
                                <a href="<c:url value='/admin/dentists'/>" class="clear-search">Clear</a>
                            </c:if>
                        </form>
                    </div>

                    <!-- Dentists Table -->
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>
                                        <a href="<c:url value='/admin/dentists?sort=lastName&direction=${sortField == "
                                            lastName" ? reverseSortDirection : "asc" }&keyword=${keyword}' />"
                                        class="sorted-column ${sortField ==
                                        'lastName' ? 'active' : ''}">
                                        Name
                                        <c:if test="${sortField == 'lastName'}">
                                            <i class="fas fa-caret-${sortDirection == 'asc' ? 'up' : 'down'}"></i>
                                        </c:if>
                                        </a>
                                    </th>
                                    <th>Specialization</th>
                                    <th>Primary Clinic</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty dentists && dentists.totalElements > 0}">
                                        <c:forEach var="dentist" items="${dentists.content}">
                                            <tr>
                                                <td>
                                                    <a href="<c:url value='/admin/dentists/${dentist.id}'/>"
                                                        class="entity-name">
                                                        ${dentist.firstName} ${dentist.lastName}
                                                    </a>
                                                    <div class="text-muted small">${dentist.user.email}
                                                    </div>
                                                </td>
                                                <td>${dentist.specialization}</td>
                                                <td>
                                                    <c:set var="foundPrimary" value="false" />
                                                    <c:forEach var="assignment" items="${dentist.clinicAssignments}">
                                                        <c:if test="${assignment.primary}">
                                                            <c:set var="foundPrimary" value="true" />
                                                            <a href="<c:url value='/admin/clinics/${assignment.clinic.id}'/>"
                                                                class="clinic-link">
                                                                ${assignment.clinic.name}
                                                            </a>
                                                        </c:if>
                                                    </c:forEach>
                                                    <c:if test="${!foundPrimary}">
                                                        <span class="text-muted">Not assigned</span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <span
                                                        class="status-badge ${dentist.active ? 'status-active' : 'status-inactive'}">
                                                        ${dentist.active ? 'Active' : 'Inactive'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div class="actions">
                                                        <a href="<c:url value='/admin/dentists/${dentist.id}'/>"
                                                            class="action-btn view-btn" title="View details">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="<c:url value='/admin/dentists/${dentist.id}/edit'/>"
                                                            class="action-btn edit-btn" title="Edit dentist">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <form
                                                            action="<c:url value='/admin/dentists/${dentist.id}/toggle-status'/>"
                                                            method="post" class="inline-form">
                                                            <input type="hidden" name="${_csrf.parameterName}"
                                                                value="${_csrf.token}" />
                                                            <button type="submit"
                                                                class="action-btn ${dentist.active ? 'deactivate-btn' : 'activate-btn'}"
                                                                title="${dentist.active ? 'Deactivate' : 'Activate'} dentist">
                                                                <i
                                                                    class="fas ${dentist.active ? 'fa-ban' : 'fa-check-circle'}"></i>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="no-results">
                                                <i class="fas fa-search"></i>
                                                <c:choose>
                                                    <c:when test="${not empty keyword}">
                                                        No dentists found matching '${keyword}'
                                                    </c:when>
                                                    <c:otherwise>
                                                        No dentists found
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${dentists.totalPages > 1}">
                        <div class="pagination">
                            <c:choose>
                                <c:when test="${currentPage > 0}">
                                    <a href="<c:url value='/admin/dentists?page=0&sort=${sortField}&direction=${sortDirection}&keyword=${keyword}'/>"
                                        class="pagination-btn">
                                        <i class="fas fa-angle-double-left"></i>
                                    </a>
                                    <a href="<c:url value='/admin/dentists?page=${currentPage - 1}&sort=${sortField}&direction=${sortDirection}&keyword=${keyword}'/>"
                                        class="pagination-btn">
                                        <i class="fas fa-angle-left"></i>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="pagination-btn disabled">
                                        <i class="fas fa-angle-double-left"></i>
                                    </span>
                                    <span class="pagination-btn disabled">
                                        <i class="fas fa-angle-left"></i>
                                    </span>
                                </c:otherwise>
                            </c:choose>

                            <c:forEach begin="0" end="${dentists.totalPages - 1}" var="i">
                                <c:choose>
                                    <c:when test="${currentPage == i}">
                                        <span class="pagination-btn active">${i + 1}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="<c:url value='/admin/dentists?page=${i}&sort=${sortField}&direction=${sortDirection}&keyword=${keyword}'/>"
                                            class="pagination-btn">${i + 1}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${currentPage < dentists.totalPages - 1}">
                                    <a href="<c:url value='/admin/dentists?page=${currentPage + 1}&sort=${sortField}&direction=${sortDirection}&keyword=${keyword}'/>"
                                        class="pagination-btn">
                                        <i class="fas fa-angle-right"></i>
                                    </a>
                                    <a href="<c:url value='/admin/dentists?page=${dentists.totalPages - 1}&sort=${sortField}&direction=${sortDirection}&keyword=${keyword}'/>"
                                        class="pagination-btn">
                                        <i class="fas fa-angle-double-right"></i>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="pagination-btn disabled">
                                        <i class="fas fa-angle-right"></i>
                                    </span>
                                    <span class="pagination-btn disabled">
                                        <i class="fas fa-angle-double-right"></i>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </div>
            </main>
        </div>
    </body>

    </html>