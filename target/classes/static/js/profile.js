document.addEventListener('DOMContentLoaded', function () {
    // Profile edit functionality
    initProfileEditing();

    // Image upload functionality
    initImageUpload();
});

function initProfileEditing() {
    // Personal Info section
    const editPersonalInfoBtn = document.getElementById('editPersonalInfoBtn');
    const personalInfoView = document.getElementById('personalInfoView');
    const personalInfoEdit = document.getElementById('personalInfoEdit');
    const cancelPersonalInfoBtn = document.getElementById('cancelPersonalInfoBtn');

    if (editPersonalInfoBtn) {
        editPersonalInfoBtn.addEventListener('click', function () {
            personalInfoView.classList.add('hidden');
            personalInfoEdit.classList.remove('hidden');
        });
    }

    if (cancelPersonalInfoBtn) {
        cancelPersonalInfoBtn.addEventListener('click', function () {
            personalInfoView.classList.remove('hidden');
            personalInfoEdit.classList.add('hidden');
        });
    }

    // Contact Info section
    const editContactInfoBtn = document.getElementById('editContactInfoBtn');
    const contactInfoView = document.getElementById('contactInfoView');
    const contactInfoEdit = document.getElementById('contactInfoEdit');
    const cancelContactInfoBtn = document.getElementById('cancelContactInfoBtn');

    if (editContactInfoBtn) {
        editContactInfoBtn.addEventListener('click', function () {
            contactInfoView.classList.add('hidden');
            contactInfoEdit.classList.remove('hidden');
        });
    }

    if (cancelContactInfoBtn) {
        cancelContactInfoBtn.addEventListener('click', function () {
            contactInfoView.classList.remove('hidden');
            contactInfoEdit.classList.add('hidden');
        });
    }
}

function initImageUpload() {
    const changeImageBtn = document.getElementById('changeImageBtn');
    const profileImage = document.getElementById('profileImage');
    const imageUploadForm = document.getElementById('imageUploadForm');

    if (changeImageBtn && profileImage) {
        changeImageBtn.addEventListener('click', function () {
            profileImage.click();
        });

        profileImage.addEventListener('change', function () {
            if (this.files && this.files[0]) {
                imageUploadForm.submit();
            }
        });
    }
}