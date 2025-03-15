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
    <title>Manage Clinics - HKDC Admin</title>
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
                    <h1>Manage Clinics</h1>
                    <a href="<c:url value='/admin/clinics/new'/>" class="btn-primary">
                        <i class="fas fa-plus"></i> Add New Clinic
                    </a>
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

                <!-- Search and Filters -->
                <div class="filters-container">
                    <form action="<c:url value='/admin/clinics'/>" method="get" class="search-form">
                        <div class="search-input-wrapper">
                            <input type="text" name="keyword" placeholder="Search clinics..." value="${keyword}">
                            <button type="submit" class="search-btn">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                        <c:if test="${not empty keyword}">
                            <a href="<c:url value='/admin/clinics'/>" class="clear-search">Clear</a>
                        </c:if>
                    </form>
                </div>

                <!-- Clinics Table -->
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Clinic Name</th>
                                <th>Address</th>
                                <th>Phone</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${clinics.content}" var="clinic">
                                <tr>
                                    <td>
                                        <a href="<c:url value='/admin/clinics/${clinic.id}'/>" class="entity-name">
                                            ${clinic.name}
                                        </a>
                                    </td>
                                    <td>${clinic.address}, ${clinic.city} ${clinic.postalCode}</td>
                                    <td>${empty clinic.phoneNumber ? 'N/A' : clinic.phoneNumber}</td>
                                    <td>
                                        <span class="status-badge ${clinic.active ? 'status-active' : 'status-inactive'}">
                                            ${clinic.active ? 'Active' : 'Inactive'}
                                        </span>
                                    </td>
                                    <td class="actions">
                                        <a href="<c:url value='/admin/clinics/${clinic.id}'/>" class="action-btn view-btn" title="View Details">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="<c:url value='/admin/clinics/${clinic.id}/edit'/>" class="action-btn edit-btn" title="Edit">
                                            <i class="fas fa-pencil-alt"></i>
                                        </a>
                                        <form action="<c:url value='/admin/clinics/${clinic.id}/toggle-status'/>" method="post" class="inline-form">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button type="submit" class="action-btn ${clinic.active ? 'deactivate-btn' : 'activate-btn'}" 
                                                    title="${clinic.active ? 'Deactivate' : 'Activate'}">
                                                <i class="fas ${clinic.active ? 'fa-ban' : 'fa-check'}"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${clinics.totalElements == 0}">
                                <tr>
                                    <td colspan="5" class="no-results">
                                        <i class="fas fa-info-circle"></i>
                                        <c:choose>
                                            <c:when test="${not empty keyword}">
                                                No clinics found matching your search criteria. Try a different search term or <a href="<c:url value='/admin/clinics'/>">view all clinics</a>.
                                            </c:when>
                                            <c:otherwise>
                                                No clinics have been added yet. <a href="<c:url value='/admin/clinics/new'/>">Add your first clinic</a>.
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:if test="${clinics.totalPages > 1}">
                    <div class="pagination">
                        <c:choose>
                            <c:when test="${currentPage > 0}">
                                <a href="<c:url value='/admin/clinics?page=0&size=${clinics.size}&sort=${sortField}&direction=${sortDirection}&keyword=${keyword}'/>" class="pagination-btn">
                                    <i class="fas fa-angle-double-left"></i>
                                </a>
                                <a href="<c:url value='/admin/clinics?page=${currentPage - 1}&size=${clinics.size}&sort=${sortField}&direction=${sortDirection}&keyword=${keyword}'/>" class="pagination-btn">
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

                        <c:forEach begin="${Math.max(0, currentPage - 2)}" end="${Math.min(clinics.totalPages - 1, currentPage + 2)}" var="i">
                            <c:choose>
                                <c:when test="${currentPage == i}">
                                    <span class="pagination-btn active">${i + 1}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="<c:url value='/admin/clinics?page=${i}&size=${clinics.size}&sort=${sortField}&direction=${sortDirection}&keyword=${keyword}'/>" class="pagination-btn">
                                        ${i + 1}
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <c:choose>
                            <c:when test="${currentPage < clinics.totalPages - 1}">
                                <a href="<c:url value='/admin/clinics?page=${currentPage + 1}&size=${clinics.size}&sort=${sortField}&direction=${sortDirection}&keyword=${keyword}'/>" class="pagination-btn">
                                    <i class="fas fa-angle-right"></i>
                                </a>
                                <a href="<c:url value='/admin/clinics?page=${clinics.totalPages - 1}&size=${clinics.size}&sort=${sortField}&direction=${sortDirection}&keyword=${keyword}'/>" class="pagination-btn">
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