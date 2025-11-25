package cmpproject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet implementation class PlaceOrderServlet
 */
@WebServlet("/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PlaceOrderServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userId == null) {
            response.sendRedirect("home.jsp");
            return;
        }

        // 1. construct address string from form
        String address = request.getParameter("first_name") + " " + request.getParameter("last_name") + "\n" +
                request.getParameter("address") + ", " + 
                request.getParameter("city") + ", " + 
                request.getParameter("emirate");

        Connection con = null;
     // Inside PlaceOrderServlet.java doPost

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 1. Fetch Cart Data (Single Query)
            String fetchCart = "SELECT c.product_id, c.quantity, c.size, p.price " +
                               "FROM cart_items c JOIN products p ON c.product_id = p.id " +
                               "WHERE c.user_id = ?";
            PreparedStatement pstCart = con.prepareStatement(fetchCart);
            pstCart.setInt(1, userId);
            ResultSet rs = pstCart.executeQuery();

            double total = 0.0;
            List<String[]> orderItems = new ArrayList<>();

            while(rs.next()) {
                int pid = rs.getInt("product_id"); // This works because it's in the SELECT
                int qty = rs.getInt("quantity");
                String size = rs.getString("size");
                double price = rs.getDouble("price");
                
                total += (price * qty);
                
                // Store for later insertion
                orderItems.add(new String[]{
                    String.valueOf(pid), 
                    String.valueOf(qty), 
                    size, 
                    String.valueOf(price)
                });
            }
            rs.close(); // Close RS before next query

            if (orderItems.isEmpty()) {
                response.sendRedirect("cart.jsp");
                return;
            }

            // 2. Insert Order
            String insertOrder = "INSERT INTO orders (user_id, total_amount, shipping_address) VALUES (?, ?, ?)";
            PreparedStatement pstOrder = con.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS);
            pstOrder.setInt(1, userId);
            pstOrder.setDouble(2, total);
            pstOrder.setString(3, address);
            pstOrder.executeUpdate();

            ResultSet keys = pstOrder.getGeneratedKeys();
            int newOrderId = 0;
            if (keys.next()) newOrderId = keys.getInt(1);

            // 3. Insert Order Items
            String insertItem = "INSERT INTO order_items (order_id, product_id, quantity, size, price_at_purchase) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstItem = con.prepareStatement(insertItem);

            for(String[] item : orderItems) {
                pstItem.setInt(1, newOrderId);
                pstItem.setInt(2, Integer.parseInt(item[0]));
                pstItem.setInt(3, Integer.parseInt(item[1]));
                pstItem.setString(4, item[2]);
                pstItem.setDouble(5, Double.parseDouble(item[3]));
                pstItem.addBatch();
            }
            pstItem.executeBatch();

            // 4. Clear Cart
            String deleteCart = "DELETE FROM cart_items WHERE user_id = ?";
            PreparedStatement pstDel = con.prepareStatement(deleteCart);
            pstDel.setInt(1, userId);
            pstDel.executeUpdate();

            con.commit();
            response.sendRedirect("thank_you.jsp?order_id=" + newOrderId);

        } catch (Exception e) {
            if(con != null) try { con.rollback(); } catch(SQLException ex) {}
            e.printStackTrace();
            // This helps debug: prints error to console
        }
        finally {
            try {
            	if(con != null) con.close();
            }
            catch(SQLException e) {
            	e.printStackTrace();
            }
        }
    }

}
