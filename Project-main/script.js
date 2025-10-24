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


var toggleBtn = document.getElementById('toggleSidebar');
var sidebar = document.getElementById('sidebar');

toggleBtn.onclick = function() {
  if (sidebar.classList.contains('open')) {
    sidebar.classList.remove('open');
  } else {
    sidebar.classList.add('open');
  }
  
}

window.addEventListener('scroll', () => {
  const navbar = document.querySelector('.navbar');
  if (window.scrollY > 50) {
    navbar.classList.add('transparent');
  } else {
    navbar.classList.remove('transparent');
  }
});