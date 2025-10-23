document.addEventListener('DOMContentLoaded', () => {
  const loginBtn = document.getElementById('loginPopoverBtn');

  new coreui.Popover(loginBtn, {
    container: 'body',
    placement: 'bottom',
    html: true,
    sanitize: false, // <--- This is crucial!
    title: 'Login',
    content: document.getElementById('loginFormContent').innerHTML
  });
});

// Mariam's Addition
const form = document.getElementById("signupForm");
form.addEventListener("submit", function(event) {
  event.preventDefault();

  let password = document.getElementById("password").value;
  let confirmPassword = document.getElementById("confirmPassword").value;

  if (password !== confirmPassword) {
    alert("Passwords do not match!");
    return;
  }

  // Just a fake success message for now
  alert("Account created successfully!");
  form.reset();
});


