package cmpproject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
/**
 * Servlet implementation class AddToCartServlet
 */
@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddToCartServlet() {
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
		// 1. Security Check
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        
        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Error
            return;
        }

        int productId = Integer.parseInt(request.getParameter("product_id"));
        String size = request.getParameter("size");
        
        // Default size if none selected (e.g. from gallery quick-add)
        if (size == null || size.isEmpty() || size.equals("null")) {
            size = "One Size"; 
        }

        try {
            Connection con = DBConnection.getConnection();
            
            // 2. Check if item (Product + Size) already exists in cart
            String checkSql = "SELECT id, quantity FROM cart_items WHERE user_id = ? AND product_id = ? AND size = ?";
            PreparedStatement checkPst = con.prepareStatement(checkSql);
            checkPst.setInt(1, userId);
            checkPst.setInt(2, productId);
            checkPst.setString(3, size);
            ResultSet rs = checkPst.executeQuery();
            
            if (rs.next()) {
                // EXISTS -> UPDATE QUANTITY
                int newQuantity = rs.getInt("quantity") + 1;
                String updateSql = "UPDATE cart_items SET quantity = ? WHERE id = ?";
                PreparedStatement upPst = con.prepareStatement(updateSql);
                upPst.setInt(1, newQuantity);
                upPst.setInt(2, rs.getInt("id"));
                upPst.executeUpdate();
            } else {
                // DOES NOT EXIST -> INSERT NEW ROW
                String insertSql = "INSERT INTO cart_items (user_id, product_id, size, quantity) VALUES (?, ?, ?, 1)";
                PreparedStatement insPst = con.prepareStatement(insertSql);
                insPst.setInt(1, userId);
                insPst.setInt(2, productId);
                insPst.setString(3, size);
                insPst.executeUpdate();
            }
            
            con.close();
            response.setStatus(HttpServletResponse.SC_OK);

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

}
