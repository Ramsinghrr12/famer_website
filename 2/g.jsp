<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
    // Database connection details
    String url = "jdbc:mysql://localhost:3306/market_prices";
    String username = "ramsingh";
    String password = "Ramsingh12@";

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    // Get the current date
    Date today = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String currentDate = sdf.format(today);

    // Debug: Print the current date to verify the format
    System.out.println("Current Date: " + currentDate);

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");  // Ensure correct driver is used
        conn = DriverManager.getConnection(url, username, password);
        stmt = conn.createStatement();
        
        // SQL query to get records for today's date
        String query = "SELECT c.name AS crop, p.price, p.cost, p.region, p.date " +
                       "FROM prices p JOIN crops c ON p.crop_id = c.id " +
                       "WHERE p.date = '" + currentDate + "' " +
                       "ORDER BY c.name";
        
        rs = stmt.executeQuery(query);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Farmer's Market Prices</title>
    <link rel="stylesheet" href="styles.css">
    <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places"></script>
    <script>
        function initMap() {
            var map = new google.maps.Map(document.getElementById('map'), {
                center: { lat: -34.397, lng: 150.644 },
                zoom: 8
            });

            var input = document.getElementById('search-box');
            var searchBox = new google.maps.places.SearchBox(input);
            
            map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

            // Bias the SearchBox results towards current map's viewport.
            map.addListener('bounds_changed', function() {
                searchBox.setBounds(map.getBounds());
            });

            searchBox.addListener('places_changed', function() {
                var places = searchBox.getPlaces();

                if (places.length == 0) {
                    return;
                }

                // Clear out the old markers.
                var markers = [];
                markers.forEach(function(marker) {
                    marker.setMap(null);
                });

                // For each place, get the icon, name and location.
                var bounds = new google.maps.LatLngBounds();
                places.forEach(function(place) {
                    if (!place.geometry) {
                        console.log("Returned place contains no geometry");
                        return;
                    }

                    // Create a marker for each place.
                    var marker = new google.maps.Marker({
                        map: map,
                        title: place.name,
                        position: place.geometry.location
                    });

                    markers.push(marker);

                    if (place.geometry.viewport) {
                        // Only geocodes have viewport.
                        bounds.union(place.geometry.viewport);
                    } else {
                        bounds.extend(place.geometry.location);
                    }
                });
                map.fitBounds(bounds);
            });
        }
    </script>
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

        /* Map Styles */
        #map {
            height: 400px;
            width: 100%;
        }

        #search-box {
            margin-top: 10px;
            width: 300px;
        }
    </style>
</head>
<body onload="initMap()">
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
        boolean hasResults = false;
        while (rs.next()) {
            hasResults = true;
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
        if (!hasResults) {
%>
                <tr>
                    <td colspan="5">No data available for today's date.</td>
                </tr>
<%
        }
%>
            </tbody>
        </table>
        <h2>Google Map Search</h2>
        <input id="search-box" class="controls" type="text" placeholder="Search Box">
        <div id="map"></div>
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
        // Close the database resources
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
