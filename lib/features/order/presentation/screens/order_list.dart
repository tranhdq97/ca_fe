import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:pisces_ordering/features/order/presentation/controllers/order_controller.dart';
import 'package:provider/provider.dart'; // For accessing Provider
import '../../../../core/models/order_status.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  List<Map<String, dynamic>> _orders = []; // List of orders
  int _currentPage = 1; // Current page for pagination
  bool _isLoading = false; // Loading state
  bool _hasMore = true; // Whether there are more items to load

  @override
  void initState() {
    super.initState();
    _fetchOrders(); // Fetch the first page of orders
  }

  Future<void> _fetchOrders() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    final orderController =
        Provider.of<OrderController>(context, listen: false);
    orderController.fetchAllOrders(
      page: _currentPage,
      limit: 20,
    );
    _orders = orderController.orders;
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    Provider.of<OrderController>(context, listen: false)
        .updateOrderStatus(orderId, newStatus);

    setState(() {
      final order = _orders.firstWhere((order) => order['id'] == orderId);
      order['status'] = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order status updated to $newStatus')),
    );
  }

  String _formatDate(String dateTime) {
    final date = DateTime.parse(dateTime);
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _orders.length + 1, // Add 1 for the loading indicator
              itemBuilder: (context, index) {
                if (index == _orders.length) {
                  // Show loading indicator at the bottom
                  return _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                }

                final order = _orders[index];
                final status = OrderStatusHelper.fromString(order['status']);
                final createdTime = _formatDate(order['created_at']);

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text('Order #${order['id']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Status: ${OrderStatusHelper.getStatusText(status)}'),
                        Text('Created: $createdTime'),
                      ],
                    ),
                    trailing: _buildStatusButton(order),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(Map<String, dynamic> order) {
    final status = OrderStatusHelper.fromString(order['status']);

    if (status == OrderStatus.PROCESSING) {
      return ElevatedButton(
        onPressed: () {
          _updateOrderStatus(order['id'].toString(), OrderStatus.READY.name);
        },
        child: const Text('Ready to Pickup'),
      );
    } else if (status == OrderStatus.READY) {
      return ElevatedButton(
        onPressed: () {
          _updateOrderStatus(
              order['id'].toString(), OrderStatus.DELIVERED.name);
        },
        child: const Text('Delivered'),
      );
    }

    return const SizedBox.shrink(); // No button for other statuses
  }
}
