class ApiServices {
  static Map<String, String> getHeadersWithToken(String token) {
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }
  static Map<String, String> getHeaders() {
    return {
      "Content-Type": "application/json",
    };
  }
  static Map<String, String> getHeadersWithOnlyToken(String token) {
    return {
    'Authorization': 'Bearer $token'
    };
  }
}
