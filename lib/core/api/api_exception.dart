class ApiException implements Exception {
  final String message;
  final int? statusCode; // Add statusCode field

  ApiException(this.message,
      {this.statusCode}); // Update constructor to accept statusCode

  @override
  String toString() {
    return 'ApiException: $message (Status code: $statusCode)';
  }
}
