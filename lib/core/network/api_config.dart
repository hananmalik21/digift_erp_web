class ApiConfig {
  // Get base URL from environment variable, default to localhost
  static String get baseUrl {
    const String envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) {
      return envUrl;
    }
    // Default to localhost for development
    // return 'http://localhost:3000';
    return 'https://digift-erp-backend-5.onrender.com';
  }

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

