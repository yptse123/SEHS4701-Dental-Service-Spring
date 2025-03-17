document.addEventListener('DOMContentLoaded', function() {
    // Show/hide "Other" reason field based on dropdown selection
    const reasonSelect = document.getElementById('cancellationReason');
    const otherField = document.getElementById('otherReasonField');
    const otherInput = document.getElementById('otherReason');
    
    reasonSelect.addEventListener('change', function() {
        if (this.value === 'Other') {
            otherField.style.display = 'block';
            otherInput.setAttribute('required', 'required');
        } else {
            otherField.style.display = 'none';
            otherInput.removeAttribute('required');
        }
    });
});