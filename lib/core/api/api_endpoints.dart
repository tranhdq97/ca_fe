class ApiEndpoints {
  static const String baseUrl = 'https://gagaallall.pythonanywhere.com';
  // static const String baseUrl = 'http://192.168.1.11:5000';
  // Auth
  static const String login = '/auth/login';
  // Client Order
  static const String orders = '/order/byphone';
  static const String checkOrder = '/order/<id>/check';
  static const String streamOrder = '/order/status-stream';
  // Menu
  static const String menu = '/menu';
  // Staff Order
  static const String allOrders = '/order/';
}
