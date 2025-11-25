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
 * Servlet implementation class UpdatePasswordServlet
 */
@WebServlet("/UpdatePasswordServlet")
public class UpdatePasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdatePasswordServlet() {
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
		// 1. Get the current user from the Session (Security Check)
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");
        
        // If not logged in, kick them out
        if (userId == null) {
            response.sendRedirect("home.jsp");
            return;
        }

        // 2. Get form data
        String currentPass = request.getParameter("current_password");
        String newPass = request.getParameter("new_password");
        String confirmPass = request.getParameter("confirm_password");

        // 3. Simple Validation
        if (!newPass.equals(confirmPass)) {
            response.sendRedirect("account.jsp?error=mismatch"); // Passwords don't match
            return;
        }

        try {
            Connection con = DBConnection.getConnection();
            
            // 4. Verify the OLD password first
            String checkSql = "SELECT password_hash FROM users WHERE id = ?";
            PreparedStatement checkStmt = con.prepareStatement(checkSql);
            checkStmt.setInt(1, userId);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                String dbPass = rs.getString("password_hash");
                
                // If the user typed the wrong current password
                if (!dbPass.equals(currentPass)) {
                    response.sendRedirect("account.jsp?error=wrong_current");
                    return;
                }
            }

            // 5. Update to the NEW password
            String updateSql = "UPDATE users SET password_hash = ? WHERE id = ?";
            PreparedStatement updateStmt = con.prepareStatement(updateSql);
            updateStmt.setString(1, newPass);
            updateStmt.setInt(2, userId);
            
            int rowCount = updateStmt.executeUpdate();
            
            // 6. Update the session so the "Current Password" field in JSP updates instantly
            session.setAttribute("user_pass", newPass);

            con.close();
            
            if (rowCount > 0) {
                response.sendRedirect("account.jsp?status=password_updated");
            } else {
                response.sendRedirect("account.jsp?error=db_error");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
