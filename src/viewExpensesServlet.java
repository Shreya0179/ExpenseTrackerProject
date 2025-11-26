import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;

public class ViewExpensesServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String[]> expenses = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM expenses ORDER BY date DESC");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                expenses.add(new String[]{
                    rs.getInt("id") + "",
                    rs.getString("title"),
                    rs.getString("amount"),
                    rs.getString("category"),
                    rs.getString("date")
                });
            }

            con.close();

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        request.setAttribute("expensesList", expenses);
        RequestDispatcher rd = request.getRequestDispatcher("viewExpenses.jsp");
        rd.forward(request, response);
    }
}