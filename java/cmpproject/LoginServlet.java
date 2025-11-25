package cmpproject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Essential for logging in

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
      /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
    }
    //We don't need the doget function if it's not doing anything.
    //anyways credentials should always be post no point in having doget so we can delete it...
    /**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // Ensure DBConnection class is available in your project
            Connection con = DBConnection.getConnection();
            
            String sql = "SELECT * FROM users WHERE email = ? AND password_hash = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, email);
            pst.setString(2, password);
            
            ResultSet rs = pst.executeQuery();
            
            if (rs.next()) {
                // SUCCESS: Create Session
                HttpSession session = request.getSession();
                session.setAttribute("user_id", rs.getInt("id"));
                
                // We use "username" column or "full_name" depending on what you want to show
                session.setAttribute("user_name", rs.getString("full_name")); 
                session.setAttribute("user_email", rs.getString("email"));
                session.setAttribute("user_pass", rs.getString("password_hash"));
                
                response.sendRedirect("account.jsp"); 
            } else {
                // FAILURE
                response.sendRedirect("home.jsp?login=error");
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}