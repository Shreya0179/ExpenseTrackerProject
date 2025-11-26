import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AddExpenseServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        String amount = request.getParameter("amount");
        String category = request.getParameter("category");
        String date = request.getParameter("date");

        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO expenses (title, amount, category, date) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = con.prepareStatement(sql);

            stmt.setString(1, title);
            stmt.setDouble(2, Double.parseDouble(amount));
            stmt.setString(3, category);
            stmt.setString(4, date);

            stmt.executeUpdate();
            con.close();

            response.getWriter().println("Expense Added Successfully!");

        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}

