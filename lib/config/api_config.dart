class ApiConfig {
  static const String baseUrl = 'https://dev.osp.id/ptap-kpi-dev';
  static const bool isDevelopment = true; // Set to false for production
  
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
}