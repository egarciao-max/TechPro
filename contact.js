document.addEventListener('DOMContentLoaded', () => {
    const contactForm = document.getElementById('contact-form');
    
    // Make sure the form exists on the page before adding an event listener
    if (contactForm) {
        const formStatus = document.getElementById('form-status');
        const submitButton = contactForm.querySelector('button[type="submit"]');

        // --- ⬇️ IMPORTANT ⬇️ ---
        // Replace this placeholder with the actual URL of your deployed Cloudflare Worker.
        const WORKER_URL = 'https://your-worker-name.your-username.workers.dev';

        contactForm.addEventListener('submit', async (event) => {
            event.preventDefault();

            const formData = new FormData(contactForm);
            const data = Object.fromEntries(formData.entries());

            formStatus.textContent = 'Sending...';
            formStatus.style.color = 'gray';
            submitButton.disabled = true;

            try {
                const response = await fetch(WORKER_URL, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data),
                });

                if (!response.ok) {
                    throw new Error(`Server error: ${response.status} ${response.statusText}`);
                }

                const result = await response.json();

                if (result.success) {
                    formStatus.textContent = 'Message sent successfully!';
                    formStatus.style.color = 'green';
                    contactForm.reset();
                } else {
                    throw new Error(result.message || 'An unknown error occurred.');
                }
            } catch (error) {
                console.error('Fetch Error:', error);
                formStatus.textContent = 'Failed to send message. Please try again.';
                formStatus.style.color = 'red';
            } finally {
                submitButton.disabled = false;
            }
        });
    }
});