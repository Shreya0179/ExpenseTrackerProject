



<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Expense Tracker Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f3f4f6; margin:0; padding:0;}
        .container { width: 90%; margin: 20px auto; }
        h2 { text-align: center; margin-top: 20px; color: #333; }
        table {
            width: 100%;
            margin: 20px 0;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        th, td {
            border: 1px solid #333;
            padding: 8px 12px;
            text-align: center;
        }
        th {
            background-color: #007BFF;
            color: white;
        }
        .summary { text-align: center; margin-top: 20px; font-size: 16px; }
        .form-container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .form-container input, .form-container select {
            width: calc(100% - 22px);
            padding: 10px;
            margin: 5px 0 15px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        .form-container button {
            padding: 12px 20px;
            background: #007BFF;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        .form-container button:hover { background: #0056b3; }
    </style>
</head>
<body>

<div class="container">
<h2>💰 Expense Tracker Dashboard 💰</h2>

<div class="form-container">
    <form action="addExpense.jsp" method="post">
        <input type="text" name="title" placeholder="Title" required>
        <input type="number" step="0.01" name="amount" placeholder="Amount" required>
        <input type="text" name="category" placeholder="Category" required>
        <input type="date" name="date" required>
        <button type="submit">Add Expense</button>
    </form>
</div>

<%
    // Declare variables only once
    String url = "jdbc:mysql://localhost:3306/expense_tracker";
    String user = "root";          
    String password = "Urvi@8124"; 

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    int totalExpenses = 0;
    double totalAmount = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM expenses ORDER BY date DESC");
%>

<table>
    <tr>
        <th>ID</th>
        <th>Title</th>
        <th>Amount</th>
        <th>Category</th>
        <th>Date</th>
    </tr>
<%
        while(rs.next()) {
            double amount = rs.getDouble("amount");
            totalAmount += amount;
            totalExpenses++;
%>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("title") %></td>
        <td>$<%= String.format("%.2f", amount) %></td>
        <td><%= rs.getString("category") %></td>
        <td><%= rs.getDate("date") %></td>
    </tr>
<%
        }
    } catch(Exception e) {
        out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if(rs != null) rs.close(); } catch(Exception e) {}
        try { if(stmt != null) stmt.close(); } catch(Exception e) {}
        try { if(conn != null) conn.close(); } catch(Exception e) {}
    }
%>
</table>

<div class="summary">
<%
    if(totalExpenses > 0) {
%>
    <p>Total Expenses: <b><%= totalExpenses %></b></p>
    <p>Total Amount Spent: <b>$<%= String.format("%.2f", totalAmount) %></b></p>
<%
    } else {
%>
    <p>No expense records found.</p>
<%
    }
%>
</div>
</div>

</body>
</html>
