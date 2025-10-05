// IDIOT Token Website JavaScript

document.addEventListener('DOMContentLoaded', function() {
    const contactForm = document.getElementById('contactForm');
    const formResponse = document.getElementById('formResponse');
    
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
    e.preventDefault();
    
            // Show loading state
            const submitBtn = contactForm.querySelector('button[type="submit"]');
            const originalText = submitBtn.textContent;
            submitBtn.textContent = 'Sending...';
            submitBtn.disabled = true;
            
            // Hide previous response
            formResponse.style.display = 'none';
            
            // Get form data
            const formData = new FormData(contactForm);
            
            // Send form data
            fetch('contact.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                // Show response
                formResponse.textContent = data;
                formResponse.className = data.includes('✅') ? 'success' : 'error';
                formResponse.style.display = 'block';
                
                // Reset form if successful
                if (data.includes('✅')) {
                    contactForm.reset();
                }
            })
            .catch(error => {
                formResponse.textContent = '❌ Network error. Please try again.';
                formResponse.className = 'error';
                formResponse.style.display = 'block';
            })
            .finally(() => {
                // Reset button
                submitBtn.textContent = originalText;
                submitBtn.disabled = false;
    });
  });
}
});