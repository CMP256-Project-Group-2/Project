<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Collection - Noir Loom</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="styles.css">

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400..900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <script src="https://www.google.com/recaptcha/api.js" async defer></script>
</head>

<body>
  <!-- add loading here?maybe-->
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

  <div class="container mt-5 pt-5">
    <h1 id="gallery-title" class="text-center mt-4 mb-2 body_text_lg" style="font-size: 4vh;">COLLECTION</h1>
  </div>

  <div class="container sticky-top bg-light py-3 border-bottom" style="top: 70px; z-index: 900;">
    <div class="d-flex justify-content-between align-items-center">

      <button class="btn btn-outline-darkblue d-flex align-items-center gap-2" type="button" data-bs-toggle="collapse"
        data-bs-target="#filterPanel" aria-expanded="false" aria-controls="filterPanel">
        <i class="fa fa-sliders"></i> FILTER
      </button>

      <!-- sort menu here slider is nice but needs implemenation. -->
      <div class="dropdown">
        <button class="btn btn-outline-darkblue dropdown-toggle" type="button" id="sortDropdown"
          data-bs-toggle="dropdown" aria-expanded="false">
          Sort By: Featured
        </button>
        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="sortDropdown">
          <li><a class="dropdown-item" href="javascript:void(0)" onclick="sortProducts('newest')">Newest</a></li>
          <li><a class="dropdown-item" href="javascript:void(0)" onclick="sortProducts('low-high')">Price: Low to
              High</a></li>
          <li><a class="dropdown-item" href="javascript:void(0)" onclick="sortProducts('high-low')">Price: High to
              Low</a></li>
        </ul>
      </div>

    </div>

    <div class="collapse mt-3" id="filterPanel">
      <div class="card card-body bg-light border-0">
        <div class="row">

          <div class="col-md-3 mb-3">
            <h6 class="fw-bold">Max Price: <span id="priceValue">500</span> AED</h6>
            <input type="range" class="form-range" id="priceRange" min="0" max="500" step="10" value="500"
              oninput="document.getElementById('priceValue').innerText = this.value">
          </div>

          <div class="col-md-3 mb-3">
            <h6 class="fw-bold">Product Type</h6>
            <div class="d-flex flex-column gap-1">
              <div class="form-check">
                <input class="form-check-input filter-type" type="checkbox" value="shoe" id="typeShoe">
                <label class="form-check-label small" for="typeShoe">Shoes</label>
              </div>
              <div class="form-check">
                <input class="form-check-input filter-type" type="checkbox" value="shirt" id="typeShirt">
                <label class="form-check-label small" for="typeShirt">Shirts</label>
              </div>
              <div class="form-check">
                <input class="form-check-input filter-type" type="checkbox" value="hoodie" id="typeHoodie">
                <label class="form-check-label small" for="typeHoodie">Hoodies</label>
              </div>
              <div class="form-check">
                <input class="form-check-input filter-type" type="checkbox" value="dress" id="typeDress">
                <label class="form-check-label small" for="typeDress">Dresses</label>
              </div>
              <div class="form-check">
                <input class="form-check-input filter-type" type="checkbox" value="accessory" id="typeAcc">
                <label class="form-check-label small" for="typeAcc">Accessories</label>
              </div>
            </div>
          </div>

          <div class="col-md-2 mb-3">
            <h6 class="fw-bold">Size</h6>
            <div class="d-flex gap-2 flex-wrap">
              <button class="btn btn-sm btn-outline-secondary filter-size" data-size="S"
                onclick="toggleFilterBtn(this)">S</button>
              <button class="btn btn-sm btn-outline-secondary filter-size" data-size="M"
                onclick="toggleFilterBtn(this)">M</button>
              <button class="btn btn-sm btn-outline-secondary filter-size" data-size="L"
                onclick="toggleFilterBtn(this)">L</button>
              <button class="btn btn-sm btn-outline-secondary filter-size" data-size="EU 40"
                onclick="toggleFilterBtn(this)">40</button>
              <button class="btn btn-sm btn-outline-secondary filter-size" data-size="EU 42"
                onclick="toggleFilterBtn(this)">42</button>
            </div>
          </div>

          <div class="col-md-2 mb-3">
            <h6 class="fw-bold">Color</h6>
            <div class="d-flex gap-2">
              <button class="rounded-circle border filter-color" data-color="black" onclick="toggleFilterBtn(this)"
                style="width:25px;height:25px; background-color: black;"></button>
              <button class="rounded-circle border filter-color" data-color="white" onclick="toggleFilterBtn(this)"
                style="width:25px;height:25px; background-color: white;"></button>
              <button class="rounded-circle border filter-color" data-color="blue" onclick="toggleFilterBtn(this)"
                style="width:25px;height:25px; background-color: blue;"></button>
              <button class="rounded-circle border filter-color" data-color="red" onclick="toggleFilterBtn(this)"
                style="width:25px;height:25px; background-color: red;"></button>
            </div>
          </div>

          <div class="col-md-2 d-flex align-items-end">
            <button class="btn btn-darkblue w-100" onclick="applyFilters()">Apply</button>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- grid for products -->
  <div class="container my-5">
    <div id="gallery-grid" class="row">
    </div>


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
                Weaving darkness with elegance. Noir Loom brings you the finest selection of urban aesthetics and luxury
                comfort.
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
                <li><a href="#">New Arrivals</a></li>
                <li><a href="#">Men</a></li>
                <li><a href="#">Women</a></li>
                <li><a href="#">Accessories</a></li>
              </ul>
            </div>

            <div class="col-lg-2 col-md-3 col-6 mb-4">
              <h5 class="footer-heading">Support</h5>
              <ul class="list-unstyled footer-links">
                <li><a href="#">Track Order</a></li>
                <li><a href="#">Returns</a></li>
                <li><a href="#">Shipping</a></li>
                <li><a href="#">FAQ</a></li>
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

    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
    <script src="script.js"></script>
</body>

</html>