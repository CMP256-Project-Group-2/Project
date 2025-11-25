<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, cmpproject.*" %>
<%
    // 1. Security Check
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect("home.jsp");
        return;
    }

    List<CartItem> myCart = new ArrayList<>();
    double grandTotal = 0.0;

    // 2. Fetch Data (JOIN cart_items + products)
    try {
        Connection con = DBConnection.getConnection();
        String sql = "SELECT c.id, c.quantity, c.size, p.title, p.price, p.image " +
                     "FROM cart_items c " +
                     "JOIN products p ON c.product_id = p.id " +
                     "WHERE c.user_id = ?";
                     
        PreparedStatement pst = con.prepareStatement(sql);
        pst.setInt(1, (Integer)session.getAttribute("user_id"));
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
            myCart.add(item);
            grandTotal += item.getTotal();
        }
        con.close();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Your Bag - Noir Loom</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="styles.css">
  <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400..900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  
  <script src="https://www.google.com/recaptcha/api.js" async defer></script>
</head>
<body>

  <jsp:include page="navbar_partial.jsp" /> 
  <div class="container mt-5 pt-5 mb-5">
    <h1 class="text-center mb-5 body_text_lg" style="font-size: 4vh;">My Cart</h1>

    <div class="row">
        <div class="col-lg-8">
            <% if(myCart.isEmpty()) { %>
                <div class="text-center py-5 border rounded bg-white">
                    <h4>Your Cart is empty!!!</h4>
                    <a href="gallery.jsp" class="btn btn-darkblue mt-3">Continue Shopping</a>
                </div>
            <% } else { %>
                <% for(CartItem item : myCart) { %>
                    <div class="card mb-3 border-0 shadow-sm">
                        <div class="row g-0 align-items-center">
                            <div class="col-3 col-md-2">
                                <img src="<%= item.getImage() %>" class="img-fluid rounded-start" style="max-height: 100px; object-fit: contain;">
                            </div>
                            <div class="col-9 col-md-10">
                                <div class="card-body d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title fw-bold mb-1"><%= item.getTitle() %></h6>
                                        <p class="text-muted small mb-0">
                                            Size: <strong><%= item.getSize() %></strong> <br>
                                            Qty: <%= item.getQuantity() %>
                                        </p>
                                    </div>
                                    <div class="text-end">
                                        <p class="fw-bold mb-1"><%= String.format("%.2f", item.getTotal()) %> AED</p>
                                        
                                        <form action="RemoveFromCartServlet" method="post">
                                            <input type="hidden" name="cart_id" value="<%= item.getId() %>">
                                            <button type="submit" class="btn btn-sm text-danger border-0 p-0 text-decoration-underline">Remove</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>

        <div class="col-lg-4">
            <div class="card border-0 shadow-sm bg-light">
                <div class="card-body p-4">
                    <h5 class="fw-bold mb-4" style="font-family: 'Cinzel', serif;">Order Summary</h5>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Subtotal</span>
                        <span><%= String.format("%.2f", grandTotal) %> AED</span>
                    </div>
                    <div class="d-flex justify-content-between mb-3 border-bottom pb-3">
                        <span>Shipping</span>
                        <span>Free</span>
                    </div>
                    <div class="d-flex justify-content-between mb-4">
                        <strong class="fs-5">Total</strong>
                        <strong class="fs-5"><%= String.format("%.2f", grandTotal) %> AED</strong>
                    </div>
                    <a href="checkout.jsp" class="btn btn-darkblue w-100 py-2 fw-bold">Checkout</a>
                    <div class="text-center mt-3">
                         <img src="img/paymentmethods.png" alt="Accepted Payment MEthods" style="height: 20px;">
                    </div>
                </div>
            </div>
        </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>