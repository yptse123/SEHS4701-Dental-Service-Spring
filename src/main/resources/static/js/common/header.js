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