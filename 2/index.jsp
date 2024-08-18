<!-- <!DOCTYPE html>
<html>
<head>
	<title>Farmer's Market Prices</title>
    <style>
/* General Styles */
body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 0;
}

/* Header Styles */
header {
	background-color: #333;
	color: #fff;
	padding: 20px;
}

nav ul {
	list-style-type: none;
	margin: 0;
	padding: 0;
}

nav li {
	display: inline-block;
	margin-right: 20px;
}

nav a {
	color: #fff;
	text-decoration: none;
}

/* Main Content Styles */
main {
	padding: 20px;
}

section {
	margin-bottom: 40px;
}

/* Footer Styles */
footer {
	background-color: #333;
	color: #fff;
	padding: 10px;
	text-align: center;
}

    </style>
</head>
<body>
        <header>
            <h1>Farmer's Market Prices</h1>
        </header>
        <main>
            <h2>Crop Prices</h2>
            <table id="crop-prices">
                <thead>
                    <tr>
                        <th>Crop</th>
                        <th>Price</th>
                        <th>Cost</th>
                        <th>Region</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </main>
        <footer>
            <p>&copy; 2024 Farmer's Market Prices</p>
        </footer>
    
	<script>

        window.onload = function() {
            fetch('/prices')
                .then(response => response.json())
                .then(data => {
                    const tableBody = document.querySelector('#crop-prices tbody');
                    data.forEach(item => {
                        const row = document.createElement('tr');
                        const cropCell = document.createElement('td');
                        const priceCell = document.createElement('td');
                        const costCell = document.createElement('td');
                        const regionCell = document.createElement('td');
                        const dateCell = document.createElement('td');
        
                        cropCell.textContent = item.crop;
                        priceCell.textContent = item.price;
                        costCell.textContent = item.cost;
                        regionCell.textContent = item.region;
                        dateCell.textContent = item.date;
        
                        row.appendChild(cropCell);
                        row.appendChild(priceCell);
                        row.appendChild(costCell);
                        row.appendChild(regionCell);
                        row.appendChild(dateCell);
        
                        tableBody.appendChild(row);
                    });
                })
                .catch(error => console.error(error));
        };
    </script>
</body>
</html> -->



<%-- <%@ page import="java.sql.*" %>
<%
    // Database connection details
    String url = "jdbc:mysql://localhost:3306/market_prices";
    String username = "your_username";
    String password = "your_password";

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);
        stmt = conn.createStatement();
        String query = "SELECT c.name AS crop, p.price, p.cost, p.region, p.date FROM prices p JOIN crops c ON p.crop_id = c.id ORDER BY c.name";
        rs = stmt.executeQuery(query);
    
%>
<!DOCTYPE html>
<html>
<head>
    <title>Farmer's Market Prices</title>
    <link rel="stylesheet" href="styles.css">
</head>

<style>
/* General Styles */
body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 0;
}

/* Header Styles */
header {
	background-color: #333;
	color: #fff;
	padding: 20px;
}

nav ul {
	list-style-type: none;
	margin: 0;
	padding: 0;
}

nav li {
	display: inline-block;
	margin-right: 20px;
}

nav a {
	color: #fff;
	text-decoration: none;
}

/* Main Content Styles */
main {
	padding: 20px;
}

section {
	margin-bottom: 40px;
}

/* Footer Styles */
footer {
	background-color: #333;
	color: #fff;
	padding: 10px;
	text-align: center;
}

    </style>
<body>
    <header>
        <h1>Farmer's Market Prices</h1>
    </header>
    <main>
        <h2>Crop Prices</h2>
        <table id="crop-prices">
            <thead>
                <tr>
                    <th>Crop</th>
                    <th>Price</th>
                    <th>Cost</th>
                    <th>Region</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
<%
        while (rs.next()) {
%>
                <tr>
                    <td><%= rs.getString("crop") %></td>
                    <td><%= rs.getDouble("price") %></td>
                    <td><%= rs.getDouble("cost") %></td>
                    <td><%= rs.getString("region") %></td>
                    <td><%= rs.getString("date") %></td>
                </tr>
<%
        }
%>
            </tbody>
        </table>
    </main>
    <footer>
        <p>&copy; 2024 Farmer's Market Prices</p>
    </footer>
</body>
</html>
<%
    }
} catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred");
    } finally {
        // Close the database resources
        if (rs != null) {
            try { rs.close(); } catch (SQLException e) { /* ignored */ }
        }
        if (stmt != null) {
            try { stmt.close(); } catch (SQLException e) { /* ignored */ }
        }
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { /* ignored */ }
        }
    }
%> --%>


<%@ page import="java.sql.*" %>
<%
    // Database connection details
    String url = "jdbc:mysql://localhost:3306/market_prices";
    String username = "ramsingh";
    String password = "Ramsingh12@";

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);
        stmt = conn.createStatement();
        String query = "SELECT c.name AS crop, p.price, p.cost, p.region, p.date FROM prices p JOIN crops c ON p.crop_id = c.id ORDER BY c.name";
        rs = stmt.executeQuery(query);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Farmer's Market Prices</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        /* General Styles */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        /* Header Styles */
        header {
            background-color: #333;
            color: #fff;
            padding: 20px;
        }

        nav ul {
            list-style-type: none;
            margin: 0;
            padding: 0;
        }

        nav li {
            display: inline-block;
            margin-right: 20px;
        }

        nav a {
            color: #fff;
            text-decoration: none;
        }

        /* Main Content Styles */
        main {
            padding: 20px;
        }

        section {
            margin-bottom: 40px;
        }

        /* Footer Styles */
        footer {
            background-color: #333;
            color: #fff;
            padding: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
    <header>
        <h1>Farmer's Market Prices</h1>
    </header>
    <main>
        <h2>Crop Prices</h2>
        <table id="crop-prices">
            <thead>
                <tr>
                    <th>Crop</th>
                    <th>Price</th>
                    <th>Cost</th>
                    <th>Region</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
<%
        while (rs.next()) {
%>
                <tr>
                    <td><%= rs.getString("crop") %></td>
                    <td><%= rs.getDouble("price") %></td>
                    <td><%= rs.getDouble("cost") %></td>
                    <td><%= rs.getString("region") %></td>
                    <td><%= rs.getString("date") %></td>
                </tr>
<%
        }
%>
            </tbody>
        </table>
    </main>
    <footer>
        <p>&copy; 2024 Farmer's Market Prices</p>
    </footer>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred");
    } finally {
        if (rs != null) {
            try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        if (stmt != null) {
            try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>
