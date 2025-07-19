
// lib/api_config.dart
class API {
  // Replace with your actual IP address or domain
  static const String _baseUrl = "http://192.168.0.102/api_dukan_store";

  static const String signUp = "$_baseUrl/register.php";
  static const String validateEmail = "$_baseUrl/validate_email.php";
  static const String login = "$_baseUrl/login.php";
  // Add other API endpoints as needed (e.g., for fetching data, updating, deleting)
}