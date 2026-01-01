const API_URL = "https://booking-handler.techprokelowna.workers.dev";
document.addEventListener('DOMContentLoaded', () => {
    
    // --- 0. MODAL LOGIC ---
    const modal = document.getElementById('customModal');
    const modalTitle = document.getElementById('modalTitle');
    const modalMessage = document.getElementById('modalMessage');
    const modalCloseBtn = document.getElementById('modalCloseBtn');

    function showModal(title, message, isError = false) {
        if (!modal) return; // Don't run if modal isn't on the page
        modalTitle.textContent = title;
        modalMessage.textContent = message;
        modalTitle.style.color = isError ? '#ff6b6b' : '#28a745'; // Use green for success
        modal.classList.add('active');
    }

    function hideModal() {
        if (!modal) return;
        modal.classList.remove('active');
    }

    if (modalCloseBtn) {
        modalCloseBtn.addEventListener('click', hideModal);
        modal.addEventListener('click', (e) => { if (e.target === modal) hideModal(); });
    }

    // --- REUSABLE FORM SUBMISSION LOGIC ---
    async function handleFormSubmit(apiEndpoint, formData) {
        const response = await fetch(apiEndpoint, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            mode: 'cors',
            body: JSON.stringify(formData),
        });

        const result = await response.json();

        if (!response.ok) {
            // If the server returns an error, create an error object to be caught below
            const error = new Error(result.error || "An unknown server error occurred.");
            error.isServerError = true; // Custom flag to identify server-side errors
            throw error;
        }

        return result;
    }

    // --- 1. BOOKING FORM LOGIC ---
    const bookingForm = document.getElementById('bookingForm');
    if (bookingForm) {
        bookingForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const submitBtn = bookingForm.querySelector('button[type="submit"]');
            submitBtn.disabled = true;
            submitBtn.textContent = 'Sending...';

            const formData = {
                name: document.getElementById('booking-name').value,
                email: document.getElementById('booking-email').value,
                service: document.getElementById('service-type').value,
                date: document.getElementById('booking-date').value,
                message: document.getElementById('booking-problem').value
            };

            try {
                const result = await handleFormSubmit("https://booking-handler.techprokelowna.workers.dev", formData);
                showModal(
                    "Booking Request Sent!", 
                    `Your Ticket ID is: ${result.ticketId}. Please keep this for your records. We will contact you shortly to confirm.`
                );
                bookingForm.reset();
            } catch (error) {
                console.error("Error:", error);
                const title = error.isServerError ? "Booking Error" : "Connection Error";
                const message = error.isServerError ? error.message : "Could not connect to the booking server. Please check your internet connection and try again.";
                showModal(title, message, true);
            } finally {
                submitBtn.disabled = false;
                submitBtn.textContent = 'Request Booking';
            }
        });
    }

    // --- 2. CONTACT FORM LOGIC ---
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const submitBtn = contactForm.querySelector('button[type="submit"]');
            submitBtn.disabled = true;
            submitBtn.textContent = 'Sending...';

            const formData = {
                name: document.getElementById('contact-name').value,
                email: document.getElementById('contact-email').value,
                message: document.getElementById('contact-message').value
            };

            try {
                const result = await handleFormSubmit("https://booking-handler.techprokelowna.workers.dev", formData);
                showModal(
                    "Message Sent!", 
                    `Thank you for reaching out. Your reference Ticket ID is: ${result.ticketId}. We'll get back to you soon.`
                );
                contactForm.reset();
            } catch (error) {
                console.error("Error:", error);
                const title = error.isServerError ? "Send Error" : "Connection Error";
                const message = error.isServerError ? error.message : "Could not connect to the server. Please check your internet connection and try again.";
                showModal(title, message, true);
            } finally {
                submitBtn.disabled = false;
                submitBtn.textContent = 'Send Message';
            }
        });
    }

    // --- 3. HAMBURGER MENU LOGIC ---
    const hamburger = document.querySelector(".hamburger");
    const navMenu = document.querySelector(".nav-menu");

    if (hamburger && navMenu) {
        hamburger.addEventListener("click", () => {
            hamburger.classList.toggle("active");
            navMenu.classList.toggle("active");
        });
    }

    // --- 5. ADMIN LOGIN EASTER EGG ---
    const statusLogo = document.querySelector('.status-logo');
    if (statusLogo) {
        let clickCount = 0;
        let clickTimer = null;

        statusLogo.addEventListener('click', () => {
            clickCount++;

            // If a timer is already running, clear it to reset the 2-second window
            if (clickTimer) {
                clearTimeout(clickTimer);
            }

            if (clickCount === 4) {
                window.location.href = 'admin-kelowna-tp-92x1.html'; // Redirect to the admin page
            }

            // Set a timer to reset the click count after 2 seconds of inactivity
            clickTimer = setTimeout(() => {
                clickCount = 0;
            }, 2000);
        });
    }
});

// --- 4. PUBLIC STATUS CHECK LOGIC ---
// This function needs to be in the global scope to be called by onclick="".
async function checkStatus() {
    const ticketIdInput = document.getElementById('publicTicketId');
    const resultDiv = document.getElementById('pubResult');
    const statusEl = document.getElementById('resStatus');
    const dateEl = document.getElementById('resDate');

    const ticketId = ticketIdInput.value.trim().toUpperCase();
    if (!ticketId) {
        alert("Please enter a Ticket ID.");
        return;
    }

    try {
        const apiEndpoint = `https://booking-handler.techprokelowna.workers.dev?id=${ticketId}`;
        const response = await fetch(apiEndpoint);
        const data = await response.json();

        if (response.ok && data) {
            statusEl.textContent = data.status;
            dateEl.textContent = new Date(data.lastUpdate).toLocaleString();
            resultDiv.style.display = 'block';
        } else {
            alert("Ticket ID not found. Please check the ID and try again.");
        }
    } catch (error) {
        console.error("Status Check Error:", error);
        alert("Could not connect to the status server. Please try again later.");
    }
}