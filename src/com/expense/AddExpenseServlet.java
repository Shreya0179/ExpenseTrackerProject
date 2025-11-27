package com.expense;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/addExpense") // <-- this is the URL your form submits to
public class AddExpenseServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        String amountStr = request.getParameter("amount");
        String category = request.getParameter("category");
        String date = request.getParameter("date");

        String url = "jdbc:mysql://localhost:3306/expense_tracker";
        String user = "root";
        String password = "root";

        String message = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                String sql = "INSERT INTO expenses(title, amount, category, date) VALUES (?, ?, ?, ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, title);
                    pstmt.setDouble(2, Double.parseDouble(amountStr));
                    pstmt.setString(3, category);
                    pstmt.setDate(4, java.sql.Date.valueOf(date));
                    pstmt.executeUpdate();
                }
            }

            message = "✅ Expense added successfully!";
        } catch (Exception e) {
            e.printStackTrace();
            message = "❌ Error: " + e.getMessage();
        }

        // Store message in session so dashboard.jsp can show it
        HttpSession session = request.getSession();
        session.setAttribute("message", message);

        // Redirect to dashboard.jsp
        response.sendRedirect("dashboard.jsp");
    }
}
