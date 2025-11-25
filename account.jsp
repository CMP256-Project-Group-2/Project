<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, java.io.*" %>
<%@ page import="cmpproject.DBConnection" %>
<%@ page import="cmpproject.Address" %>
<%@ page import="cmpproject.Order" %>
<% 
    /* 1. Security Check: If no user is logged in, kick them back to home */
    if(session.getAttribute("user_name") == null) { 
        response.sendRedirect("home.jsp"); 
        return; 
    } 

    /* 2. Get the name from the session (saved by LoginServlet) */
    String userName = (String) session.getAttribute("user_name"); 
    String userEmail = (String) session.getAttribute("user_email"); 
    String userPass = (String) session.getAttribute("user_pass"); 

      List<Address> myAddresses = new ArrayList<>();
    
    try {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT * FROM addresses WHERE user_id = ? ORDER BY id DESC";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setInt(1, (Integer)session.getAttribute("user_id")); 
        ResultSet rs = pst.executeQuery();
        
        while(rs.next()){
            myAddresses.add(new Address(
                rs.getInt("id"),
                rs.getString("full_name"),
                rs.getString("phone"),
                rs.getString("address_line"),
                rs.getString("city"),
                rs.getString("state"),
                rs.getString("zip")
            ));
        }
    } catch(Exception e) {
        e.printStackTrace();
    }
    
    /* WISHLIST */
    List<cmpproject.Product> myWishlist = new ArrayList<>();
    try {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT p.id, p.title, p.image, p.price FROM products p " +
                     "JOIN wishlist w ON p.id = w.product_id " +
                     "WHERE w.user_id = ? ORDER BY w.created_at DESC";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setInt(1, (Integer)session.getAttribute("user_id"));
        ResultSet rs = pst.executeQuery();
        
        while(rs.next()){
            myWishlist.add(new cmpproject.Product(
                rs.getInt("id"),
                rs.getString("title"),
                rs.getString("image"),
                rs.getDouble("price")
            ));
        }
    } catch(Exception e) {
        e.printStackTrace();
    }
    /*orders*/
    List<Order> myOrders = new ArrayList<>();
    try {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT id, created_at, status, total_amount FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setInt(1, (Integer)session.getAttribute("user_id"));
        ResultSet rs = pst.executeQuery();
        
        while(rs.next()){
            myOrders.add(new Order(
                rs.getInt("id"),
                rs.getTimestamp("created_at"),
                rs.getString("status"),
                rs.getDouble("total_amount")
            ));
        }
        con.close();
    } catch(Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Account - Noir Loom</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="styles.css">

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400..900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

  <script src="https://www.google.com/recaptcha/api.js" async defer></script>
</head>

<body>

  <div id="splash-screen">
    <h1 id="splash-text">Noir Loom</h1>
  </div>

  <nav class="navbar fixed-top navbar-dark bg-darkblue">
    <div class="container-fluid position-relative">
      <button class="btn btn-link text-light text-decoration-none" id="toggleSidebar" style="font-size: 1.5rem;"><i
          class="fa fa-bars"></i></button>
      <a class="navbar-brand position-absolute top-50 start-50 translate-middle" href="home.jsp">Noir
        Loom</a>

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
        <button class="btn btn-link text-light text-decoration-none" type="button" id="loginDropdownBtn"
          data-bs-toggle="dropdown" aria-expanded="false" data-bs-auto-close="outside" style="font-size: 1.2rem;">
          <i class="fa fa-user-circle-o"></i>
        </button>
        <div class="dropdown-menu dropdown-menu-end login-dropdown-menu" aria-labelledby="loginDropdownBtn">
          <div class="p-3 text-center">
            <p class="mb-2">Logged in as <strong>
                <%= userName %>
              </strong></p>
            <a href="LogoutServlet" class="list-group-item list-group-item-action text-danger">
              <i class="fa fa-sign-out me-2"></i> Logout
            </a>
          </div>
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

  <div class="container dashboard-container mt-5 pt-5">

    <div class="row mb-4 mt-4 align-items-center">
      <div class="col-md-12 d-flex align-items-center gap-3">
        <div class="bg-darkblue text-white rounded-circle d-flex align-items-center justify-content-center"
          style="width: 60px; height: 60px; font-size: 1.5rem;">
          <i class="fa fa-user-circle-o"></i>
        </div>
        <div>
          <h2 class="m-0" style="font-family: 'Cinzel', serif;">Welcome, <%= userName %>
          </h2>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-md-3 mb-4">
        <div class="list-group account-sidebar" id="list-tab" role="tablist">
          <a class="list-group-item list-group-item-action active" id="list-settings-list" data-bs-toggle="list"
            href="#list-settings" role="tab"><i class="fa fa-cog me-2"></i>
            Settings</a>
          <a class="list-group-item list-group-item-action" id="list-wishlist-list" data-bs-toggle="list"
            href="#list-wishlist" role="tab"><i class="fa fa-heart me-2"></i>
            Wishlist</a>
          <a class="list-group-item list-group-item-action" id="list-orders-list" data-bs-toggle="list"
            href="#list-orders" role="tab"><i class="fa fa-shopping-bag me-2"></i> Orders</a>
          <a class="list-group-item list-group-item-action" id="list-address-list" data-bs-toggle="list"
            href="#list-address" role="tab"><i class="fa fa-map-marker me-2"></i> Address</a>
          <a href="home.jsp" class="list-group-item list-group-item-action text-danger"><i
              class="fa fa-sign-out me-2"></i> Logout</a>
        </div>
      </div>

      <div class="col-md-9">
        <div class="dashboard-content tab-content" id="nav-tabContent">

          <div class="tab-pane fade show active" id="list-settings" role="tabpanel">
            <h4 class="section-title">Login Information</h4>

            <div class="mb-3">
              <label class="form-label">Email Address</label>
              <input type="email" class="form-control" value="<%= userEmail %>" readonly>
            </div>
            <hr class="my-4">

            <h5 class="mb-3">Change Password</h5>

            <div class="mb-3">
              <label class="form-label">Current Password (Demo shows password - should not be the case
                otherwise)</label>
              <input type="text" class="form-control" value="<%= userPass %>" readonly>
            </div>

            <form action="UpdatePasswordServlet" method="post">
              <div class="mb-3">
                <label class="form-label">Verify Current Password</label>
                <input type="password" name="current_password" class="form-control" required>
              </div>

              <div class="row">
                <div class="col-md-6 mb-3">
                  <label class="form-label">New Password</label>
                  <input type="password" name="new_password" class="form-control" required>
                </div>
                <div class="col-md-6 mb-3">
                  <label class="form-label">Confirm New Password</label>
                  <input type="password" name="confirm_password" class="form-control" required>
                </div>
              </div>

              <button type="submit" class="btn btn-darkblue mt-2">Update Credentials</button>

              <% if ("password_updated".equals(request.getParameter("status"))) { %>
                <div class="alert alert-success mt-3">Password changed successfully!</div>
                <% } else if ("mismatch".equals(request.getParameter("error"))) { %>
                  <div class="alert alert-danger mt-3">New passwords do not match.</div>
                  <% } else if ("wrong_current".equals(request.getParameter("error"))) { %>
                    <div class="alert alert-danger mt-3">Current password is incorrect.</div>
                    <% } %>
            </form>
          </div>

          <div class="tab-pane fade" id="list-wishlist" role="tabpanel">
    <h4 class="section-title">My Wishlist</h4>
    <div class="row">

        <% if (myWishlist.isEmpty()) { %>
            <div class="col-12 text-center py-5">
                <h5 class="text-muted">Your wishlist is empty.</h5>
                <a href="gallery.jsp" class="btn btn-outline-darkblue mt-3">Browse Collection</a>
            </div>
        <% } else { %>

            <% for (cmpproject.Product p : myWishlist) { %>
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card custom-product-card" style="height: 450px;"> <a href="product.jsp?id=<%= p.getId() %>" style="text-decoration: none; display: block;">
                            <div class="card-image-header" style="height: 250px;"> <img src="<%= p.getImage() %>" alt="<%= p.getTitle() %>" style="max-height: 80%; object-fit: contain;">
                            </div>
                        </a>
                        
                        <div class="card-details-body pt-3" style="height: 200px;"> <a href="product.jsp?id=<%= p.getId() %>" style="text-decoration: none; color: inherit;">
                                <h6 class="product-title text-truncate"><%= p.getTitle() %></h6>
                            </a>
                            
                            <div class="star-rating">
                                <i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i><i class="fa fa-star"></i>
                            </div>
                            
                            <div class="price-tag small mb-2">
                                <img src="img/UAE_Dirham_Symbol.svg" class="dhs_icon_sm"> <%= p.getPrice() %>
                            </div>
                            
                            <button class="btn btn-sm btn-outline-danger w-100 mt-2 active" 
                                    data-id="<%= p.getId() %>" 
                                    onclick="removeFromWishlist(this)">
                                <i class="fa fa-trash"></i> Remove
                            </button>
                        </div>
                    </div>
                </div>
            <% } %>

        <% } %>

    </div>
</div>

          <div class="tab-pane fade" id="list-orders" role="tabpanel">
    <h4 class="section-title">Order History</h4>
    <div class="table-responsive">
      <table class="table table-noir align-middle">
        <thead>
          <tr>
            <th>Order #</th>
            <th>Date</th>
            <th>Status</th>
            <th>Total</th>
          </tr>
        </thead>
        <tbody>
          <% if(myOrders.isEmpty()) { %>
             <tr><td colspan="4" class="text-center py-3">No orders found.</td></tr>
          <% } else { %>
             <% for(Order o : myOrders) { %>
              <tr>
                <td>#NL-<%= o.getId() %></td>
                <td><%= o.getDate().toString().substring(0, 10) %></td>
                <td><span class="badge bg-success"><%= o.getStatus() %></span></td>
                <td><%= String.format("%.2f", o.getTotal()) %> AED</td>
              </tr>
             <% } %>
          <% } %>
        </tbody>
      </table>
    </div>
</div>

          <div class="tab-pane fade" id="list-address" role="tabpanel">
            <h4 class="section-title">Shipping Addresses</h4>

            <% if (myAddresses.isEmpty()) { %>
              <div class="alert alert-light border text-center">No addresses saved yet.</div>
              <% } else { %>
                <% for (Address addr : myAddresses) { %>
                  <div class="card mb-4 border-start border-4 border-primary">

                    <div class="card-body d-flex justify-content-between align-items-center">

                      <div>
                        <h6 class="fw-bold mb-1">
                          <%= addr.getFullName() %>
                        </h6>
                        <p class="text-muted small mb-0">
                          <%= addr.getAddressLine() %><br>
                            <%= addr.getCity() %>, <%= addr.getState() %>
                                <%= addr.getZip() %><br>
                                  Phone: <%= addr.getPhone() %>
                        </p>
                      </div>

                      <form action="DeleteAddressServlet" method="post"
                        onsubmit="return confirm('Are you sure you want to delete this address? This change cannot be undone!');">
                        <input type="hidden" name="id" value="<%= addr.getId() %>">
                        <button type="submit" class="btn btn-sm btn-outline-danger">
                          <i class="fa fa-trash"></i> Delete
                        </button>
                      </form>

                    </div>
                  </div>
                  <% } %>
                    <% } %>

                      <h5 class="mb-3 mt-4">Add New Address</h5>
                      <form action="AddAddressServlet" method="post">
                        <div class="row g-3">
                          <div class="col-md-6">
                            <label class="form-label">Full Name</label>
                            <input type="text" name="full_name" class="form-control" placeholder="First name Last name "
                              required>
                          </div>
                          <div class="col-md-6">
                            <label class="form-label">Phone Number</label>
                            <input type="text" name="phone" class="form-control" placeholder="+971 XX XXX XXXX"
                              required>
                          </div>
                          <div class="col-12">
                            <label class="form-label">Address Line 1</label>
                            <input type="text" name="address_line" class="form-control"
                              placeholder="Street / Area, House or Apartment Number" required>
                          </div>
                          <div class="col-md-6">
                            <label class="form-label">City</label>
                            <input type="text" name="city" class="form-control" placeholder="City name" required>
                          </div>
                          <div class="col-md-4">
                            <label class="form-label">State/Emirate</label>
                            <select name="state" class="form-select">
                              <option Selected>Sharjah</option>
                              <option>Dubai</option>
                              <option>Abu Dhabi</option>
                              <option>Ajman</option>
                              <option>Fujairah</option>
                              <option>Ras Al Khaimah</option>
                              <option>Umm Al Quwain</option>
                            </select>
                          </div>
                          <div class="col-md-2">
                            <label class="form-label">Zip</label>
                            <input type="text" name="zip" class="form-control" placeholder="00000">
                          </div>
                          <div class="col-12 mt-3">
                            <button type="submit" class="btn btn-darkblue">Save Address</button>
                          </div>
                        </div>
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