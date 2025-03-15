document.addEventListener('DOMContentLoaded', function () {
    // Initialize sidebar state
    const container = document.querySelector('.dashboard-container');
    if (localStorage.getItem('sidebar-collapsed') === 'true') {
        container.classList.add('sidebar-collapsed');
    }

    // Set active menu item based on current URL
    setActiveMenuItem();
});

document.getElementById('sidebar-toggle').addEventListener('click', function () {
    const container = document.querySelector('.dashboard-container');
    const isCollapsed = container.classList.toggle('sidebar-collapsed');

    // Save state to localStorage
    localStorage.setItem('sidebar-collapsed', isCollapsed);
});

function logout() {
    document.getElementById('logoutForm').submit();
}

// Function to set the active menu item
function setActiveMenuItem() {
    const currentPath = window.location.pathname;

    // Get all navigation links
    const sidebarLinks = document.querySelectorAll('.sidebar-nav a');

    // Find the matching link and add the active class
    sidebarLinks.forEach(link => {
        // Remove active class from parent li
        link.parentElement.classList.remove('active');

        // Get the href attribute
        const href = link.getAttribute('href');

        // Extract the path from the full URL
        let linkPath = href;
        if (href.includes('://')) {
            const url = new URL(href);
            linkPath = url.pathname;
        }

        // Special case for root path
        if (linkPath === '/' && currentPath === '/dashboard') {
            link.parentElement.classList.add('active');
            return;
        }

        // Check if the current path starts with the link path
        // This handles both exact matches and child routes
        if (currentPath === linkPath ||
            (linkPath !== '/' && currentPath.startsWith(linkPath))) {
            link.parentElement.classList.add('active');
        }
    });
}