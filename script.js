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
