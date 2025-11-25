<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Product Details - Noir Loom</title>
  
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="styles.css">
  
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400..900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <script src="https://www.google.com/recaptcha/api.js" async defer></script>
</head>
<body class="product-page-body">

  <!--splash here aswll to make it look like its loading-->
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

  <!-- 4. PRODUCT CONTENT -->
  <div class="container mt-5 pt-5 mb-5" style="min-height: 80vh;">
    
    <!-- cosmetic-->
    <div id="loading-msg" class="text-center py-5 mt-5">
      <div class="spinner-border text-darkblue" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
      <h2 class="mt-3" style="font-family: 'Cinzel', serif;">Loading...</h2>
    </div>

    <div id="product-content" class="d-none">
      
      <div class="row gx-5">
        
        <div class="col-lg-7 mb-4">
          <!-- iamge of product -->
          <div class="product-image-container shadow-lg mb-4">
            <img id="detail-img" src="" alt="Product Image">
          </div>

          <!-- desc -->
          <div class="mt-4 p-3">
             <h5 class="fw-bold" style="font-family: 'Cinzel', serif;">Description</h5>
             <div id="detail-badges" class="mb-3"></div>
             <p class="text-muted" id="detail-desc">Description goes here.</p>
          </div>
        </div>

        <!-- rest here -->
        <div class="col-lg-5">
          <div class="product-info-panel">
            
            <div class="d-flex justify-content-between align-items-start">
              <div>
                <span class="badge bg-darkblue mb-2" id="detail-type">TYPE</span>
                <h1 class="display-5 fw-bold" id="detail-title" style="font-family: 'Cinzel', serif;">Product Name</h1>
                <div class="text-warning mb-2" id="detail-rating"></div>
              </div>
              
              <!-- same effect from product card -->
              <button class="btn btn-wishlist-lg" id="wishlistBtn" onclick="toggleProductPageWishlist(this, event)">
                <i class="fa fa-heart"></i>
              </button>
            </div>

            <div class="my-3">
              <h2 class="price-display" id="detail-price">0.00</h2>
            </div>

            <!-- for sizes -->
            <div class="mb-4">
              <label class="form-label fw-bold text-uppercase small ls-1">Select Size</label>
              <div id="size-container" class="d-flex flex-wrap gap-2">
              </div>
              <small id="size-error" class="text-danger d-none fw-bold mt-2 d-block">
                <i class="fa fa-exclamation-circle"></i> Please select a size.
              </small>
            </div>

            <div class="d-grid mb-4">
              <button class="btn btn-darkblue btn-lg py-3 btn-add-cart" id="addToCartBtn" onclick="addToCartProductPage(this)">
                Add to Cart
              </button>
            </div>

          </div>
        </div>
      </div>
      
      <!-- this needs more foramting-->
      <div class="row mt-5">
        <div class="col-12">
          <div class="blueprint-container">
            <h3 class="blueprint-title">Technical Specifications</h3>
            
            <div class="row align-items-center">
              <div class="col-md-6 text-center position-relative">
                <div class="diagram-box">
                  <div id="schematic-placeholder" class="w-70 h-70 d-flex justify-content-center align-items-center">
                  </div>
                  
                  <!-- Decoration Lines -->
                  <div class="diagram-line line-1"></div>
                  <div class="diagram-line line-2"></div>
                  <div class="diagram-label label-1" id="diag-text">Spec</div> <!-- why-->
                </div>
              </div>
              <div class="col-md-6 text-white p-4">
                <h4 class="mb-4" style="font-family: 'Cinzel', serif;">Measurements</h4>
                <div class="d-flex justify-content-between border-bottom border-light pb-2 mb-3">
                  <span id="meas-label-1">Dimension</span>
                  <span class="fw-bold" id="meas-val-1">--</span>
                </div>
                <div class="d-flex justify-content-between border-bottom border-light pb-2 mb-3">
                  <span id="meas-label-2">Weight</span>
                  <span class="fw-bold" id="meas-val-2">--</span>
                </div>
                <p class="small opacity-75 mt-3">
                  *Measurements are approximate. Variations may occur in natural materials.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- these are hardcoded for now, but let's add them to json later?? to do list-->
      <div class="row mt-5 mb-5">
        <div class="col-lg-8 mx-auto">
          <h3 class="text-center mb-4" style="font-family: 'Cinzel', serif;">Customer Reviews</h3>
          
          <div class="review-card">
            <div class="d-flex justify-content-between">
              <h6 class="fw-bold">Alex M.</h6>
              <span class="text-warning"><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i></span>
            </div>
            <p class="text-muted small mb-0">Absolutely love the texture and fit. Feels premium.</p>
          </div>
          
          <div class="card bg-light border-0 p-4 mt-4" style="background-color: var(--col-bg) !important;">
            <h5 class="mb-3">Write a Review</h5>
            <form id="reviewForm">
              <div class="mb-3">
                <label class="form-label small">Rating</label>
                <select class="form-select form-select-sm" required>
                  <option value="5">5 Stars</option>
                  <option value="4">4 Stars</option>
                  <option value="3">3 Stars</option>
                  <option value="2">2 Stars</option>
                  <option value="1">1 Stars</option>
                  <option value="0">not deserving of any stars</option>
                </select>
              </div>
              <div class="mb-3">
                <textarea class="form-control" rows="3" placeholder="Share your thoughts..." required></textarea>
              </div>
              <button type="submit" class="btn btn-outline-darkblue btn-sm">Submit Review</button>
            </form>
          </div>
        </div>
      </div>

    </div>
  </div>

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
</body>
</html>