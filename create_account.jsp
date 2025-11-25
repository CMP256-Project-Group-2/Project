<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Join the Loom - Create Account</title>
  
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="styles.css">
  
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400..900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  
  <script src="https://www.google.com/recaptcha/api.js" async defer></script>
</head>

<body>

  <nav class="navbar fixed-top navbar-dark bg-darkblue">
    <div class="container-fluid position-relative">
      
      <button class="btn btn-link text-light text-decoration-none" id="toggleSidebar" style="font-size: 1.5rem;">
        <i class="fa fa-bars"></i>
      </button>
      
      <a class="navbar-brand position-absolute top-50 start-50 translate-middle" href="home.jsp">Noir Loom</a>
      
      
      </div>
  </nav>

  <div id="sidebar" class="sidebar">
    <button id="closeSidebar" class="btn-close-custom">&times;</button>
    <h4 class="text-center py-3 flow-item">Menu</h4>
    <a href="home.jsp" class="flow-item">Home</a>
    <a href="gallery.jsp?category=women" class="flow-item">Women</a>
    <a href="gallery.jsp?category=men" class="flow-item">Men</a>
    <a href="gallery.jsp?category=kids" class="flow-item">Kids</a>
    <a href="gallery.jsp?category=accessories" class="flow-item">Accessories</a>
    <a href="create_account.jsp" class="flow-item">Create Account</a>
  </div>

  <section class="account-hero-section">
    <div class="account-overlay"></div>
    
    <div class="glass-card fade-in-up">
      <div class="text-center mb-4">
        <h2 style="font-family: 'Cinzel', serif;">Join us!</h2>

      </div>

      <form id="signupForm" action="./RegisterServlet" method="post">
        
        <div class="row">
          <div class="col-md-6 mb-3">
            <label class="form-label small text-uppercase fw-bold opacity-75">First Name</label>
            <input type="text" name="firstname" class="form-control glass-form-control" required>
          </div>
          <div class="col-md-6 mb-3">
            <label class="form-label small text-uppercase fw-bold opacity-75">Last Name</label>
            <input type="text" name="lastname" class="form-control glass-form-control" required>
          </div>
        </div>

        <div class="mb-3">
          <label class="form-label small text-uppercase fw-bold opacity-75">Username</label>
          <div class="input-group">
            <input type="text" name="username" class="form-control glass-form-control" required>
          </div>
        </div>

        <div class="mb-3">
          <label class="form-label small text-uppercase fw-bold opacity-75">Email Address</label>
          <input type="email" name="email" class="form-control glass-form-control" required>
        </div>

        <div class="mb-3">
          <label class="form-label small text-uppercase fw-bold opacity-75">Password</label>
          <input type="password" name="password" class="form-control glass-form-control" required>
        </div>
        
        <div class="mb-4">
          <label class="form-label small text-uppercase fw-bold opacity-75">Confirm Password</label>
          <input type="password" class="form-control glass-form-control" placeholder="re-type your password" required>
        </div>

        <div class="form-check mb-4">
          <input class="form-check-input bg-transparent border-secondary" type="checkbox" value="" id="flexCheckDefault" required>
          <label class="form-check-label small opacity-75" for="flexCheckDefault">
            I agree to the <a href="#" class="text-light text-decoration-underline">Terms of Service</a> and Privacy Policy.
          </label>
        </div>

        <button type="submit" class="btn btn-light w-100 py-2 fw-bold" style="color: var(--col-primary);">CREATE ACCOUNT</button>
        
        <div class="text-center mt-3">
          <p class="small opacity-75">Already a member? <a href="#" onclick="document.getElementById('loginDropdownBtn').click(); return false;" class="text-warning text-decoration-none fw-bold">Login Here</a></p>
        </div>
      </form>
    </div>
  </section>

  <footer id="main-footer">
    <div class="footer-branding-zone">
      <h1 class="footer-huge-title">NOIR LOOM</h1>
    </div>
    <div class="footer-content-zone">
      <div class="container">
        <div class="footer-bottom-bar text-center pt-4 mt-4 border-top border-secondary">
          <p class="small text-muted-footer mb-0">© 2025 Noir Loom. All rights reserved.</p>
        </div>
      </div>
    </div>
  </footer>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
  <script src="script.js"></script>

  <script>
    document.addEventListener("DOMContentLoaded", () => {
       gsap.from(".glass-card", {
         duration: 1,
         y: 50,
         opacity: 0,
         ease: "power3.out",
         delay: 0.5
       });
    });
  </script>
</body>
</html>