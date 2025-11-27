<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Expense</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f3f4f6;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background: white;
            padding: 30px 40px;
            border-radius: 12px;
            width: 380px;
            box-shadow: 0px 4px 15px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
        }

        label {
            font-weight: bold;
            color: #444;
        }

        input[type="text"],
        input[type="number"],
        input[type="date"] {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            margin-bottom: 18px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 14px;
        }

        input:focus {
            border-color: #007BFF;
            outline: none;
            box-shadow: 0 0 5px rgba(0,123,255,0.4);
        }

        button {
            width: 100%;
            padding: 12px;
            background: #007BFF;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.3s;
        }

        button:hover {
            background: #0056b3;
        }

        .message {
            text-align: center;
            margin-top: 15px;
            font-weight: bold;
        }

        .success { color: green; }
        .error { color: red; }
    </style>
</head>
<body>
<div class="container">
    <h2>Add Expense</h2>

<%
    String message = "";
    String messageClass = "";
    if(request.getMethod().equalsIgnoreCase("POST")) {
        String title = request.getParameter("title");
        String amountStr = request.getParameter("amount");
        String category = request.getParameter("category");
        String date = request.getParameter("date");

        String url = "jdbc:mysql://localhost:3306/expense_tracker";
        String user = "root";
        String password = "Urvi@8124";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            double amount = Double.parseDouble(amountStr);

            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, password);

            String sql = "INSERT INTO expenses(title, amount, category, date) VALUES(?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setDouble(2, amount);
            pstmt.setString(3, category);
            pstmt.setDate(4, java.sql.Date.valueOf(date));

            int rows = pstmt.executeUpdate();
            if(rows > 0) {
                message = "Expense added successfully!";
                messageClass = "success";
            } else {
                message = "Failed to add expense.";
                messageClass = "error";
            }
        } catch(Exception e) {
            message = "Error: " + e.getMessage();
            messageClass = "error";
        } finally {
            try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
    }
%>

<form action="addExpense.jsp" method="post">
    Title: <input type="text" name="title" required><br>
    Amount: <input type="number" name="amount" step="0.01" required><br>
    Category: <input type="text" name="category" required><br>
    Date: <input type="date" name="date" required><br>
    <button type="submit">Add Expense</button>
</form>

<% if(!message.isEmpty()) { %>
    <p class="message <%= messageClass %>"><%= message %></p>
<% } %>

</div>
</body>
</html>









