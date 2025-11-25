<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Order Confirmed - Noir Loom</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="styles.css">
  <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400..900&display=swap" rel="stylesheet">
</head>
<body class="d-flex align-items-center justify-content-center" style="min-height: 100vh; background-color: var(--col-primary); color: white;">

  <div class="text-center p-5" style="max-width: 600px;">
    <div class="mb-4" style="font-size: 5rem; color: var(--col-accent);">
      <i class="fa fa-check-circle"></i> &#10003; </div>
    
    <h1 style="font-family: 'Cinzel', serif; margin-bottom: 20px;">Order Confirmed</h1>
    <p class="lead mb-4">Thank you for your purchase. Your order <strong>#NL-<%= request.getParameter("order_id") %></strong> has been placed successfully.</p>
    
    <div class="d-flex gap-3 justify-content-center">
      <a href="account.jsp" class="btn btn-outline-light px-4">View Order</a>
      <a href="gallery.jsp" class="btn btn-light text-dark px-4 fw-bold">Continue Shopping</a>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
  <script>
    confetti({ particleCount: 150, spread: 100, origin: { y: 0.6 }, colors: ['#C9AEA7', '#ffffff'] });
  </script>

</body>
</html>