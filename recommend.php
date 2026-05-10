<?php

header('Content-Type: application/json');

$servername = "localhost";
$username = "root";
$password = "123456";
$dbname = "recommendation_db";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    echo json_encode(["error" => "Database connection failed"]);
    exit();
}

$response = ["results" => []];


if (isset($_GET['all']) && $_GET['all'] === 'true') {
    
    $sql = "SELECT user_input, recommended_item FROM recommendations";
    $result = $conn->query($sql);

    
    if ($result && $result->num_rows > 0) {
        
        while ($row = $result->fetch_assoc()) {
        
            $response["results"][] = [
                "recommendation" => $row['recommended_item'],
                "keyword" => $row['user_input'],
                "category" => "Catalog" 
            ];
        }
    } else {
        
        $response["error"] = "No items found in catalog.";
    }
}

if (isset($_GET['q'])) {
    $input = trim($_GET['q']);
    
    $stmt = $conn->prepare("SELECT user_input, recommended_item FROM recommendations WHERE user_input = ?");
    $stmt->bind_param("s", $input);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        $response["results"][] = [
            "recommendation" => $row['recommended_item'],
            "keyword" => $row['user_input'],
            "category" => "General"
        ];
    }
    $stmt->close();
}

echo json_encode($response);
$conn->close();
?>