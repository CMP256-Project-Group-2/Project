package cmpproject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

// ADD THESE IMPORTS
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public RegisterServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Retrieve data using the 'name' attributes from HTML
        String firstName = request.getParameter("firstname"); 
        String lastName = request.getParameter("lastname");
        String email = request.getParameter("email");
        String username = request.getParameter("username"); // Added this to match your form
        String password = request.getParameter("password");
        
        // Combine First and Last name to match your Database 'full_name' column
        String fullName = firstName + " " + lastName;

        try {
            Connection con = DBConnection.getConnection();
            
            // FIX: Added 'username' to the INSERT statement
            String sql = "INSERT INTO users (full_name, email, password_hash, username) VALUES (?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(sql);
            
            pst.setString(1, fullName);
            pst.setString(2, email);
            pst.setString(3, password); 
            pst.setString(4, username); // FIX: Set the 4th parameter
            
            int rowCount = pst.executeUpdate();
            
            if (rowCount > 0) {
                response.sendRedirect("home.jsp?status=success");
            } else {
                response.sendRedirect("create_account.jsp?status=failed");
            }
            
            // Clean up
            pst.close();
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            // Helpful for debugging: print error to browser if it fails
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}