package cmpproject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
/**
 * Servlet implementation class GetProductsServlet
 */
@WebServlet("/GetProductsServlet")
public class GetProductsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetProductsServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. Set response type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            Connection con = DBConnection.getConnection();
            Statement stmt = con.createStatement();
            String sql = "SELECT * FROM products";
            ResultSet rs = stmt.executeQuery(sql);

            // 2. Manually construct the JSON array string
            StringBuilder json = new StringBuilder("[");
            boolean first = true;

            while (rs.next()) {
                if (!first) {
                    json.append(",");
                }
                first = false;

                json.append("{");
                json.append("\"id\":").append(rs.getInt("id")).append(",");
                json.append("\"title\":\"").append(rs.getString("title")).append("\",");
                json.append("\"image\":\"").append(rs.getString("image")).append("\",");
                json.append("\"type\":\"").append(rs.getString("type")).append("\",");
                json.append("\"price\":").append(rs.getDouble("price")).append(",");
                // Escape quotes in description just in case
                json.append("\"description\":\"").append(rs.getString("description").replace("\"", "\\\"")).append("\",");
                json.append("\"rating\":").append(rs.getInt("rating")).append(",");
                
                // These columns are ALREADY JSON strings in the DB, so we append them directly
                json.append("\"categories\":").append(rs.getString("categories")).append(",");
                json.append("\"colors\":").append(rs.getString("colors")).append(",");
                json.append("\"sizes\":").append(rs.getString("sizes")).append(",");
                json.append("\"badges\":").append(rs.getString("badges"));
                
                // Optional: Measurements (handle nulls)
                String meas = rs.getString("measurements");
                if(meas != null) {
                    json.append(",\"measurements\":").append(meas);
                }

                json.append("}");
            }
            json.append("]");

            // 3. Send JSON to frontend
            out.print(json.toString());
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            out.print("[]"); // Return empty array on error
        }
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
