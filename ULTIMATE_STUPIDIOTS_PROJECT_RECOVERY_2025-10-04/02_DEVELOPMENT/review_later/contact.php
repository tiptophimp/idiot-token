<?php
// IDIOT Token Contact Form Handler
// Simple, clean contact form processing

// Only process POST requests
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    
    // Get and sanitize form data
    $name = strip_tags(trim($_POST["name"] ?? ""));
    $email = filter_var(trim($_POST["email"] ?? ""), FILTER_SANITIZE_EMAIL);
    $message = trim($_POST["message"] ?? "");
    
    // Basic validation
    if (empty($name) || !filter_var($email, FILTER_VALIDATE_EMAIL) || empty($message)) {
        http_response_code(400);
        echo "❌ Please fill in all fields correctly.";
        exit;
    }
    
    // Email configuration
    $to = "contact@stupidiots.com";
    $subject = "New Contact Form Message from $name";
    $body = "Name: $name\n";
    $body .= "Email: $email\n\n";
    $body .= "Message:\n$message\n";
    $headers = "From: $name <$email>\r\n";
    $headers .= "Reply-To: $email\r\n";
    $headers .= "Content-Type: text/plain; charset=UTF-8\r\n";
    
    // Try to send the email
    if (mail($to, $subject, $body, $headers)) {
        http_response_code(200);
        echo "✅ Thank you! Your message has been sent successfully.";
    } else {
        http_response_code(500);
        echo "❌ Sorry, there was an error sending your message. Please try again later.";
    }
    
} else {
    // Not a POST request
    http_response_code(403);
    echo "❌ Invalid request method.";
}
?>