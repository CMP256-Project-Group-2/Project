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
/**
 * Servlet implementation class RemoveFromCartServlet
 */
@WebServlet("/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RemoveFromCartServlet() {
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
            response.sendRedirect("home.jsp");
            return;
        }

        // 2. Get Cart ID to remove
        String cartId = request.getParameter("cart_id");

        try {
            Connection con = DBConnection.getConnection();
            
            // 3. Delete Query (Ensure user owns this cart item for security)
            String sql = "DELETE FROM cart_items WHERE id = ? AND user_id = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            
            pst.setInt(1, Integer.parseInt(cartId));
            pst.setInt(2, userId);
            
            pst.executeUpdate();
            con.close();
            
            // 4. Redirect back to cart
            response.sendRedirect("cart.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
