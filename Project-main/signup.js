const form = document.getElementById("signupForm");
form.addEventListener("submit", function(event) {
  event.preventDefault();

  let password = document.getElementById("password").value;
  let confirmPassword = document.getElementById("confirmPassword").value;

  if (password !== confirmPassword) {
    alert("Passwords do not match!");
    return;
  }

  alert("Account created successfully!");
  form.reset();
});