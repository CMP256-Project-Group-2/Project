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