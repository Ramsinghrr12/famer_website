<%-- <%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%
    String name = request.getParameter("name");
    String phone = request.getParameter("phone");
    String passbook = request.getParameter("passbook");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");
    String email = request.getParameter("email");

    // Validate the form data
    if (password == null || confirmPassword == null || !password.equals(confirmPassword)) {
        response.sendRedirect("signup.html?error=Passwords do not match");
        return;
    }

    if (name == null || phone == null || passbook == null || email == null) {
        response.sendRedirect("signup.html?error=Missing required fields");
        return;
    }

    try {
        // Database connection details
        String url = "jdbc:mysql://localhost:3306/labor_db"; // Replace with your database name
        String dbUsername = "ramsingh"; // Replace with your MySQL username
        String dbPassword = "Ramsingh12@"; // Replace with your MySQL password

        // Load the MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish the database connection
        Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);

        String sql = "INSERT INTO farmers (username, password, name, phone, passbook_number, email) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, name); // Use the actual name variable
        ps.setString(2, password);
        ps.setString(3, name);
        ps.setString(4, phone);
        ps.setString(5, passbook);
        ps.setString(6, email);
        int rowsInserted = ps.executeUpdate();

        if (rowsInserted > 0) {
            // Registration successful
            response.sendRedirect("project.html?success=Registration successful!");
        } else {
            // Registration failed
            response.sendRedirect("signup.html?error=Registration failed. Please try again.");
        }

        // Close the database resources
        ps.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the exception appropriately
    }
%> --%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%
    String errorMessage = null;
    String successMessage = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String passbook = request.getParameter("passbook");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");

        // Validate the form data on the server side
        if (password == null || confirmPassword == null || !password.equals(confirmPassword)) {
            errorMessage = "Passwords do not match";
        } else if (password.length() < 8) {
            errorMessage = "Password must be at least 8 characters long";
        } else if (phone == null || phone.length() != 10) {
            errorMessage = "Phone number must be 10 digits long";
        } else if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            errorMessage = "Invalid email address";
        } else if (name == null || phone == null || passbook == null || email == null) {
            errorMessage = "Missing required fields";
        } else {
            try {
                // Database connection details
                String url = "jdbc:mysql://localhost:3306/labor_db"; // Replace with your database name
                String dbUsername = "ramsingh"; // Replace with your MySQL username
                String dbPassword = "Ramsingh12@"; // Replace with your MySQL password

                // Load the MySQL JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Establish the database connection
                Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);

                String sql = "INSERT INTO farmers (username, password, name, phone, passbook_number, email) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, password);
                ps.setString(3, name);
                ps.setString(4, phone);
                ps.setString(5, passbook);
                ps.setString(6, email);
                int rowsInserted = ps.executeUpdate();

                if (rowsInserted > 0) {
                    successMessage = "Registration successful!";
                } else {
                    errorMessage = "Registration failed. Please try again.";
                }

                // Close the database resources
                ps.close();
                con.close();
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
                errorMessage = "An error occurred. Please try again later.";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Farmer Registration</title>
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background-color: #1491de;
            text-transform: capitalize;
            font-size: 30px;
            font-weight: 50px;
        }

        h1 {
            text-align: center;
        }

        input[type="text"], input[type="password"], input[type="email"], input[type='number'] {
            width: 40%;
            padding: 10px;
            margin: 8px 0;
            box-sizing: border-box;
            border: 2px solid #ccc;
            border-radius: 10px;
            margin-left: 10px;
            font-size: 50px;
        }

        .main {
            width: 1200px;
            margin: 0 auto;
            padding: 10px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0);
            background: #3c5077;
        }

        input[type='submit']:hover {
            background-color: #45a049;
        }

        .main button {
            height: 40px;
            width: 100px;
            font-size: 25px;
            cursor: pointer;
            font-weight: 500;
            border-radius: 30px;
            background-color: #fff;
        }

        .message {
            margin: 15px 0;
            padding: 10px;
            text-align: center;
            border-radius: 10px;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
        }
    </style>
    <script>
        function validateForm() {
            var name = document.getElementById("name").value;
            var phone = document.getElementById("phone").value;
            var passbook = document.getElementById("passbook").value;
            var password = document.getElementById("password").value;
            var confirmPassword = document.getElementById("confirmPassword").value;
            var email = document.getElementById("email").value;
            var errorMessage = "";

            if (password !== confirmPassword) {
                errorMessage = "Passwords do not match";
            } else if (password.length < 8) {
                errorMessage = "Password must be at least 8 characters long";
            } else if (phone.length !== 10 || isNaN(phone)) {
                errorMessage = "Phone number must be 10 digits long";
            } else if (!email.match(/^[A-Za-z0-9+_.-]+@(.+)$/)) {
                errorMessage = "Invalid email address";
            } else if (name === "" || phone === "" || passbook === "" || email === "") {
                errorMessage = "Missing required fields";
            }

            if (errorMessage !== "") {
                document.getElementById("error-message").innerText = errorMessage;
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <center>
        <form action="register.jsp" method="post" onsubmit="return validateForm()">
            <h1>~Hey Welcome to the Registration~</h1>
            <div class="main" id="main">
                <% if (errorMessage != null) { %>
                    <div class="message error" id="error-message"><%= errorMessage %></div>
                <% } else if (successMessage != null) { %>
                    <div class="message success"><%= successMessage %></div>
                <% } else { %>
                    <div class="message error" id="error-message"></div>
                <% } %>
                <div class="uname">
                    <label for="name">Enter your Name: <input type="text" name="name" id="name"></label>
                </div>
                <div class="phone">
                    <label for="phone">Phone Number: <input type="text" name="phone" id="phone"></label>
                </div>
                <div class="patta">
                    <label for="passbook">Enter Passbook Number: <input type="text" name="passbook" id="passbook"></label>
                </div>
                <div class="r3">
                    <label for="password">Password: <input type="password" name="password" id="password" class="password"></label>
                </div>
                <div class="r4">
                    <label for="confirmPassword">Confirm Password: <input type="password" name="confirmPassword" id="confirmPassword" class="password"></label>
                </div>
                <div class="email">
                    <label for="email">Email: <input type="email" name="email" class="email"></label>
                </div>
                <button type="submit">Sign Up</button>
            </div>
        </form>
    </center>
</body>
</html>
