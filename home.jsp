<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Noir Loom</title>
  
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" xintegrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  <link rel="stylesheet" href="styles.css">
  
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400..900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <script src="https://www.google.com/recaptcha/api.js" async defer></script>
</head>
<!-- make sure to buetify the code to make it organized, shift-alt-b on vscode (-hasan)-->
<body>

<!-- for future ref and pages, where we want loading the splash screen goes on top.-->
  <div id="splash-screen">
    <h1 id="splash-text">Noir Loom</h1>
  </div>

  

  

  <nav class="navbar fixed-top navbar-dark bg-darkblue">
    <div class="container-fluid position-relative">
      
      <button class="btn btn-link text-light text-decoration-none" id="toggleSidebar" style="font-size: 1.5rem;">
        <i class="fa fa-bars"></i>
      </button>
      
      <a class="navbar-brand position-absolute top-50 start-50 translate-middle" href="home.jsp">Noir Loom</a>
      
      <div class="dropdown">
        <a href="cart.jsp" class="btn btn-link text-light text-decoration-none position-relative me-2" style="font-size: 1.2rem;">
  <i class="fa fa-shopping-bag"></i>
  
  <%-- Optional: Logic to show red dot if items exist --%>
  <% if(session.getAttribute("user_id") != null) { %>
      <span class="position-absolute top-25 start-75 translate-middle p-1 bg-accent border border-light rounded-circle" style="background-color: var(--col-accent);">
        <span class="visually-hidden">New alerts</span>
      </span>
  <% } %>
</a>
  <button class="btn btn-link text-light text-decoration-none" type="button" id="loginDropdownBtn" data-bs-toggle="dropdown" aria-expanded="false" data-bs-auto-close="outside" style="font-size: 1.2rem;">
    <i class="fa fa-user-circle-o"></i>
  </button>

  <div class="dropdown-menu dropdown-menu-end login-dropdown-menu" aria-labelledby="loginDropdownBtn">
    
    <% 
      // JAVA CODE: Check if user is logged in
      String navUser = (String) session.getAttribute("user_name");
      if (navUser != null) { 
    %>
        <div class="p-3 text-center">
          <p class="mb-2">Logged in as <br><strong><%= navUser %></strong></p>
          
          <a href="account.jsp" class="btn btn-sm btn-outline-light w-100 mb-2">
            <i class="fa fa-user me-2"></i> My Dashboard
          </a>
          
          <a href="LogoutServlet" class="btn btn-sm btn-danger w-100">
            <i class="fa fa-sign-out me-2"></i> Logout
          </a>
        </div>

    <% } else { %>
    
        <div class="text-center mb-3">
          <h5 style="font-family: 'Cinzel', serif; color: var(--col-accent);">MEMBER LOGIN</h5>
        </div>

        <form id="navbarLoginForm" action="LoginServlet" method="post">
          <div class="mb-3">
            <input type="email" name="email" class="form-control login-input" placeholder="Email Address" required>
          </div>
          
          <div class="mb-3">
            <input type="password" name="password" class="form-control login-input" placeholder="Password" required>
          </div>

          <div class="d-flex justify-content-center mb-3">
             <div class="g-recaptcha" data-sitekey="6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI"></div>
          </div>

          <button type="submit" class="btn btn-light w-100 mb-3 fw-bold" style="color: var(--col-primary);">LOG IN</button>
          
          <div class="text-center small border-top border-secondary pt-2">
            <span class="text-muted text-light opacity-50" style="color: #ffffff !important;">New here?</span><br>
            <a href="create_account.jsp" class="fw-bold text-decoration-none" style="color: var(--col-accent);">Create Account</a>
          </div>
        </form>
        
    <% } %>

  </div>
</div>
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


  <!-- this broke needs fixing, restrict the hieght. -->
  <div id="carouselExampleIndicators" class="carousel slide" data-bs-ride="carousel">
    <div class="carousel-indicators">
      <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
      <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="1" aria-label="Slide 2"></button>
      <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="2" aria-label="Slide 3"></button>
    </div>
    <div class="carousel-inner">
      <div class="carousel-item active">
        <img src="img/placeholder.png" class="d-block w-100" alt="First slide" style="min-height: 500px; background-color: #ddd;">
      </div>
      <div class="carousel-item">
        <img src="img/placeholder.png" class="d-block w-100" alt="Second slide" style="min-height: 500px; background-color: #ddd;">
      </div>
      <div class="carousel-item">
        <img src="img/placeholder.png" class="d-block w-100" alt="Third slide" style="min-height: 500px; background-color: #ddd;">
      </div>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
      <span class="visually-hidden">Previous</span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
      <span class="carousel-control-next-icon" aria-hidden="true"></span>
      <span class="visually-hidden">Next</span>
    </button>
  </div>

  <div class="container-fluid mt-5" style="min-height: 120px; display: flex; align-items: center; justify-content: center;">
    <h1 id="rotating-text" class="body_text_lg">FALL COLLECTION</h1>
  </div>

  <!-- issue here aswell, check notes about cards (CSS)-->
  <div class="container-fluid my-4 overflow-hidden"> <div id="product-container-dynamic" class="d-flex align-items-center">
     </div>
  </div>

  <div class="container-fluid mt-5 mb-5">
  <h1 class="body_text_lg" style="font-size: 4vh; margin-bottom: 40px;">Take a Look</h1>
  

  <!-- we will populate this later --added to github tasks.-->
  <div class="row three-col-gallery">
 
     <div class="col-lg-4 col-md-6 mb-4">
       <div class="gallery-feature-item">
             <img src="img/summer.jpg" alt="Summer Vibes Group" class="img-fluid gallery-img">
        <div class="image-caption"><h5>Summer Vibes</h5></div>
      </div>
    </div>

     <div class="col-lg-4 col-md-6 mb-4">
       <div class="gallery-feature-item">
              <img src="img/urban.jpg" alt="Urban Streetwear Style" class="img-fluid gallery-img">
         <div class="image-caption"><h5>Urban Style</h5></div>
      </div>
     </div>

    <div class="col-lg-4 col-md-6 mb-4">
       <div class="gallery-feature-item">
              <img src="img/modern.jpg" alt="Trendy Co-ord Outfits" class="img-fluid gallery-img">
         <div class="image-caption"><h5>Trendy Picks</h5></div>
      </div>
    </div>

        <div class="col-lg-4 col-md-6 mb-4">
      <div class="gallery-feature-item">
             <img src="img/winter.jpg" alt="Cozy Winter Wear" class="img-fluid gallery-img">
        <div class="image-caption"><h5>Cozy Winter</h5></div>
       </div>
    </div>

     <div class="col-lg-4 col-md-6 mb-4">
       <div class="gallery-feature-item">
               <img src="img/allseason.jpg" alt="All-Season Couple Wear" class="img-fluid gallery-img">
           <div class="image-caption"><h5>All-Season Wear</h5></div>
       </div>
     </div>

     <div class="col-lg-4 col-md-6 mb-4">
       <div class="gallery-feature-item">
              <img src="img/soft.jpg" alt="Holiday Family Pajamas" class="img-fluid gallery-img">
        <div class="image-caption"><h5>Holiday Pajamas</h5></div>
       </div>
     </div>

   </div>
</div>

  <!-- this is hidden for the login popover -->

<footer id="main-footer">
  
  <div class="footer-branding-zone">
    <h1 class="footer-huge-title">NOIR LOOM</h1>
  </div>

  <div class="footer-content-zone">
    <div class="container">
      <div class="row">
        
        <div class="col-lg-4 col-md-6 mb-4">
          <h5 class="footer-heading">About Us</h5>
          <p class="text-muted-footer small">
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam suscipit odio purus, id molestie ex rutrum nec.
          </p>
          <div class="social-icons mt-3">
            <a href="#"><i class="fa fa-instagram"></i></a>
            <a href="#"><i class="fa fa-twitter"></i></a>
            <a href="#"><i class="fa fa-facebook"></i></a>
            <a href="#"><i class="fa fa-pinterest"></i></a>
          </div>
        </div>

        <div class="col-lg-2 col-md-3 col-6 mb-4">
          <h5 class="footer-heading">Shop</h5>
          <ul class="list-unstyled footer-links">
            <li><a href="gallery.jsp">New Arrivals</a></li>
            <li><a href="gallery.jsp?category=men">Men</a></li>
            <li><a href="gallery.jsp?category=women">Women</a></li>
            <li><a href="gallery.jsp?category=accessories">Accessories</a></li>
          </ul>
        </div>

        <div class="col-lg-2 col-md-3 col-6 mb-4">
          <h5 class="footer-heading">Support</h5>
          <ul class="list-unstyled footer-links">
            <li><a href="account.jsp">Track Order</a></li>
            <li><a href="account.jsp">Returns</a></li>
            <li><a href="account.jsp">Shipping</a></li>
            <li><a href="account.jsp">Account</a></li>
          </ul>
        </div>

        <div class="col-lg-4 col-md-12 mb-4">
          <h5 class="footer-heading">Stay in the Loop</h5>
          <p class="text-muted-footer small">Subscribe for exclusive drops and offers.</p>
          <form class="footer-newsletter">
            <div class="input-group">
              <input type="email" class="form-control form-control-sm" placeholder="Your Email">
              <button class="btn btn-light btn-sm" type="button">Subscribe</button>
            </div>
          </form>
        </div>

      </div>

      <div class="footer-bottom-bar text-center pt-4 mt-4 border-top border-secondary">
        <p class="small text-muted-footer mb-0">© 2025 Noir Loom. All rights reserved.</p>
      </div>
    </div>
  </div>
</footer>
  <!-- SCRIPTS ---COPY to each page. -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" xintegrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
  <script src="script.js"></script>

</body>
</html>