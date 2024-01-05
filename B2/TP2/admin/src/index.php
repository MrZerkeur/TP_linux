<?php
    // Create a connection to the MySQL database
    $mysqli = new mysqli('mysql', 'root', 'oui', 'mysqldb');

    // Check the mysqliection
    if ($mysqli->connect_error) {
        die("Connection failed: " . $mysqli->connect_error);
    }
    // Perform query
    $result = $mysqli -> query("SELECT * FROM random");
    while ($row = $result->fetch_row()) {
        echo "Table: " . $row[0] . "<br>";
    }
        // Free result set
        //$result -> free_result();
    
    // Retrieve the data from the MySQL database
    // $sql = "SELECT * FROM productlines";
    // $result = $conn->query($sql);

    // // Check if any rows were returned
    // echo "<p>$result</p>"
    // if ($result->num_rows > 0) {
    //     // Display the data in a table
    //     echo "<table><tr><th>Column 1</th><th>Column 2</th></tr>";
    //     while($row = $result->fetch_assoc()) {
    //         echo "<tr><td>" . $row["column1_name"] . "</td><td>" . $row["column2_name"] . "</td></tr>";
    //     }
    //     echo "</table>";
    // } else {
    //     echo "0 results";
    // }

    // Close the connection
    //$conn->close();
?>
