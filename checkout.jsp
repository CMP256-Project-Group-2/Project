<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, cmpproject.*" %>
<%
    // 1. Security Check
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect("home.jsp");
        return;
    }
    int userId = (Integer)session.getAttribute("user_id");

    // 2. Init Lists
    List<CartItem> orderItems = new ArrayList<>();
    List<Address> savedAddresses = new ArrayList<>();
    double subtotal = 0.0;
    
    try {
        Connection con = DBConnection.getConnection();
        
        // A. FETCH CART
        String sqlCart = "SELECT c.id, c.quantity, c.size, p.title, p.price, p.image " +
                     "FROM cart_items c JOIN products p ON c.product_id = p.id " +
                     "WHERE c.user_id = ?";
        PreparedStatement pst = con.prepareStatement(sqlCart);
        pst.setInt(1, userId);
        ResultSet rs = pst.executeQuery();

        while(rs.next()) {
            CartItem item = new CartItem(
                rs.getInt("id"),
                rs.getString("title"),
                rs.getString("image"),
                rs.getDouble("price"),
                rs.getInt("quantity"),
                rs.getString("size")
            );
            orderItems.add(item);
            subtotal += item.getTotal();
        }
        
        // B. FETCH ADDRESSES
        String sqlAddr = "SELECT * FROM addresses WHERE user_id = ? ORDER BY id DESC";
        PreparedStatement pstAddr = con.prepareStatement(sqlAddr);
        pstAddr.setInt(1, userId);
        ResultSet rsAddr = pstAddr.executeQuery();
        while(rsAddr.next()){
            savedAddresses.add(new Address(
                rsAddr.getInt("id"),
                rsAddr.getString("full_name"),
                rsAddr.getString("phone"),
                rsAddr.getString("address_line"),
                rsAddr.getString("city"),
                rsAddr.getString("state"),
                rsAddr.getString("zip")
            ));
        }
        
        con.close();
    } catch(Exception e) {
        e.printStackTrace();
    }
    
    if(orderItems.isEmpty()) {
        response.sendRedirect("cart.jsp");
        return;
    }
    
    double shipping = 0.0; 
    double total = subtotal + shipping;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Checkout - Noir Loom</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="styles.css">
  <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400..900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>

<div class="container-fluid checkout-container">
    <div class="row h-100">
        
        <div class="col-lg-7 form-section">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 style="font-family: 'Cinzel', serif; color: var(--col-primary);">NOIR LOOM</h2>
                <a href="cart.jsp" class="text-decoration-none text-muted"><i class="fa fa-arrow-left"></i> Return to Cart</a>
            </div>

            <div class="breadcrumb-custom mb-5">
                <a href="cart.jsp">Cart</a> <span class="mx-2">></span> 
                <span class="active">Information</span> <span class="mx-2">></span>
                <span>Shipping</span> <span class="mx-2">></span>
                <span>Payment</span>
            </div>

            <form action="PlaceOrderServlet" method="post" id="checkoutForm">
                
                <div class="mb-5">
                    <h5 class="checkout-step-title">Contact Information</h5>
                    <div class="form-floating mb-3">
                        <input type="email" class="form-control" id="email" placeholder="Email" value="<%= session.getAttribute("user_email") %>" readonly>
                        <label for="email">Email Address</label>
                    </div>
                </div>

                <div class="mb-5">
                    <h5 class="checkout-step-title">Shipping Address</h5>
                    
                    <input type="hidden" name="first_name" id="h_fname">
                    <input type="hidden" name="last_name" id="h_lname">
                    <input type="hidden" name="address" id="h_addr">
                    <input type="hidden" name="city" id="h_city">
                    <input type="hidden" name="emirate" id="h_emirate">

                    <% if (!savedAddresses.isEmpty()) { %>
                        <div class="row g-3 mb-3">
                            <% for (Address addr : savedAddresses) { %>
                            <div class="col-12">
                                <div class="card p-3 address-card" 
                                     style="cursor: pointer; border: 1px solid #ddd; transition: all 0.2s;"
                                     onclick="selectAddress(this, '<%= addr.getFullName() %>', '<%= addr.getAddressLine() %>', '<%= addr.getCity() %>', '<%= addr.getState() %>')">
                                    
                                    <div class="form-check pointer-events-none">
                                        <input class="form-check-input" type="radio" name="addr_selection" id="addr_<%= addr.getId() %>">
                                        <label class="form-check-label fw-bold" for="addr_<%= addr.getId() %>">
                                            <%= addr.getAddressLine() %>
                                        </label>
                                    </div>
                                    <div class="ps-4 text-muted small">
                                        <%= addr.getCity() %>, <%= addr.getState() %> <%= addr.getZip() %><br>
                                        <%= addr.getFullName() %> | <%= addr.getPhone() %>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                        </div>
                        
                        <button type="button" class="btn btn-link p-0 text-decoration-none mb-3" onclick="toggleManualAddress()">
                            <i class="fa fa-plus"></i> Use a different address
                        </button>
                    <% } %>

                    <div id="manual-address-form" class="<%= savedAddresses.isEmpty() ? "" : "d-none" %>">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="text" class="form-control manual-input" id="m_fname" placeholder="First Name">
                                    <label>First Name</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="text" class="form-control manual-input" id="m_lname" placeholder="Last Name">
                                    <label>Last Name</label>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-floating">
                                    <input type="text" class="form-control manual-input" id="m_addr" placeholder="Address">
                                    <label>Address</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="text" class="form-control manual-input" id="m_city" placeholder="City">
                                    <label>City</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <select class="form-select manual-input" id="m_emirate">
                                        <option value="Dubai">Dubai</option>
                                        <option value="Abu Dhabi">Abu Dhabi</option>
                                        <option value="Sharjah">Sharjah</option>
                                        <option value="Ajman">Ajman</option>
                                        <option value="Fujairah">Fujairah</option>
                                        <option value="RAK">Ras Al Khaimah</option>
                                        <option value="UAQ">Umm Al Quwain</option>
                                    </select>
                                    <label>Emirate</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mb-5">
                    <h5 class="checkout-step-title">Payment</h5>
                    <div class="card p-3 bg-light border">
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="payment" id="cc" checked>
                            <label class="form-check-label fw-bold" for="cc">
                                Debit / Credit Card <i class="fa fa-lock ms-2 text-muted"></i>
                            </label>
                        </div>
                        <div class="row g-2 mt-2">
                            <div class="col-12">
                                <input type="text" class="form-control" placeholder="Card Number" readonly style="background: #fff;">
                            </div>
                            <div class="col-6">
                                <input type="text" class="form-control" placeholder="MM/YY" readonly style="background: #fff;">
                            </div>
                            <div class="col-6">
                                <input type="text" class="form-control" placeholder="CVC"  readonly style="background: #fff;">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mt-4">
                    <a href="cart.jsp" class="text-decoration-none">Return to cart</a>
                    <button type="submit" class="btn btn-darkblue btn-lg px-5">Pay <%= String.format("%.2f", total) %> AED</button>
                </div>

            </form>
        </div>

        <div class="col-lg-5 summary-section">
            <h4 class="mb-4" style="font-family: 'Cinzel', serif;">Order Summary</h4>
            
            <div class="mb-4">
                <% for(CartItem item : orderItems) { %>
                <div class="d-flex align-items-center mb-3">
                    <div class="position-relative me-3">
                        <img src="<%= item.getImage() %>" class="order-item-img">
                        <div class="qty-badge"><%= item.getQuantity() %></div>
                    </div>
                    <div class="flex-grow-1">
                        <h6 class="mb-0 text-white"><%= item.getTitle() %></h6>
                        <small class="opacity-75"><%= item.getSize() %></small>
                    </div>
                    <div class="text-white">
                        <%= String.format("%.2f", item.getTotal()) %>
                    </div>
                </div>
                <% } %>
            </div>

            <hr style="border-color: rgba(255,255,255,0.2);">

            <div class="summary-row">
                <span>Subtotal</span>
                <span><%= String.format("%.2f", subtotal) %> AED</span>
            </div>
            <div class="summary-row">
                <span>Shipping</span>
                <span>Free</span>
            </div>

            <div class="summary-total">
                <span>Total</span>
                <span><%= String.format("%.2f", total) %> <span style="font-size: 0.8rem">AED</span></span>
            </div>
        </div>

    </div>
</div>
<script src="script.js"></script>
</body>
</html>