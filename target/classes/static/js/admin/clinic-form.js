$(document).ready(function() {
    // Initialize sidebar state
    if (localStorage.getItem('sidebar-collapsed') === 'true') {
        $('.dashboard-container').addClass('sidebar-collapsed');
    }
});