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
 * Servlet implementation class ToggleWishlistServlet
 */
@WebServlet("/ToggleWishlistServlet")
public class ToggleWishlistServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ToggleWishlistServlet() {
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

        try {
            Connection con = DBConnection.getConnection();
            
            // 2. Check if item exists
            String checkSql = "SELECT id FROM wishlist WHERE user_id = ? AND product_id = ?";
            PreparedStatement checkPst = con.prepareStatement(checkSql);
            checkPst.setInt(1, userId);
            checkPst.setInt(2, productId);
            ResultSet rs = checkPst.executeQuery();
            
            if (rs.next()) {
                // EXISTS -> REMOVE IT
                String deleteSql = "DELETE FROM wishlist WHERE id = ?";
                PreparedStatement delPst = con.prepareStatement(deleteSql);
                delPst.setInt(1, rs.getInt("id"));
                delPst.executeUpdate();
                response.getWriter().write("removed");
            } else {
                // DOES NOT EXIST -> ADD IT
                String insertSql = "INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)";
                PreparedStatement insPst = con.prepareStatement(insertSql);
                insPst.setInt(1, userId);
                insPst.setInt(2, productId);
                insPst.executeUpdate();
                response.getWriter().write("added");
            }
            
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
