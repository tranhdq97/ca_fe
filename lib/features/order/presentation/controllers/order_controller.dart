import 'package:flutter/material.dart';
import '../../data/repositories/order_repository.dart';

class OrderController with ChangeNotifier {
  final OrderRepository _orderRepository;

  OrderController({OrderRepository? orderRepository})
      : _orderRepository = orderRepository ?? OrderRepository();

  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1; // Current page for pagination
  bool _hasMore = true; // Whether there are more items to load

  List<Map<String, dynamic>> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;

  Future<void> fetchOrdersByPhone() async {
    _setLoading(true);
    try {
      _orders = await _orderRepository.fetchOrdersByPhone();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void updateOrderStatus(String orderId, String status) {
    final index =
        _orders.indexWhere((order) => order['id'] == int.parse(orderId));
    if (index != -1) {
      _orders[index]['status'] = status;
      notifyListeners(); // Notify the UI to refresh
    }
  }

  Future<void> checkOrder(int orderId) async {
    await _orderRepository.checkOrder(orderId);
  }

  Future<void> fetchAllOrders({int page = 1, int limit = 20}) async {
    if (_isLoading || !_hasMore) return;

    _setLoading(true);
    try {
      final fetchedOrders = await _orderRepository.fetchAllOrders(
          page: _currentPage, limit: limit);

      if (fetchedOrders.isNotEmpty) {
        _orders.addAll(fetchedOrders);
        _currentPage++;
        _hasMore = fetchedOrders.length == limit; // Check if more pages exist
      } else {
        _hasMore = false; // No more items to load
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void resetPagination() {
    _orders.clear();
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners(); // Notify listeners to rebuild the UI
    });
  }
}
