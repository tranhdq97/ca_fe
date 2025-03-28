import 'dart:async';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../../core/models/order_status.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/order_controller.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _orderIdController =
      TextEditingController(); // Controller for input field
  bool _isNotifying = false; // Track if the notification sound is playing

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _fetchOrdersNeeded = false; // Flag to check if we need to refetch orders
  Timer? _orderFetchTimer; // Timer for periodic API calls

  @override
  void initState() {
    super.initState();

    // Initialize local notifications
    _initializeNotifications();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Repeat the animation (zoom in/out)

    // Define the scale animation
    _scaleAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Fetch orders periodically
    _startOrderFetchTimer();
  }

  void _startOrderFetchTimer() {
    _fetchOrders();

    _orderFetchTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_fetchOrdersNeeded) {
        timer.cancel(); // Stop the timer if fetching orders is no longer needed
      } else {
        _fetchOrders();
      }
    });
  }

  Future<void> _fetchOrders() async {
    final orderController =
        Provider.of<OrderController>(context, listen: false);
    orderController.fetchOrdersByPhone();
    final orders = orderController.orders;
    final hasPendingOrders =
        orders.any((order) => order['status'] != OrderStatus.DELIVERED.name);

    if (hasPendingOrders) {
      _fetchOrdersNeeded = true;
    } else {
      _fetchOrdersNeeded = false;
    }
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Replace with your app icon
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _localNotificationsPlugin.initialize(settings);

    // Request permissions for iOS (if applicable)
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  @override
  void dispose() {
    _stopNotificationSound();
    _animationController.dispose();
    _orderIdController.dispose();
    _orderFetchTimer?.cancel(); // Cancel the timer
    super.dispose();
  }

  void _playNotificationSound() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource(NotificationStrings.audioUrl));
    Future.delayed(Duration(seconds: 30), () {
      _audioPlayer.stop(); // Dừng phát
    });
  }

  void _stopNotificationSound() {
    _audioPlayer.stop(); // Stop the sound
    _isNotifying = false; // Reset the notification flag
  }

  void _checkAndPlayNotificationSound(List<Map<String, dynamic>> orders) {
    final hasReadyForPickup =
        orders.any((order) => order['status'] == OrderStatus.READY.name);

    if (hasReadyForPickup && !_isNotifying) {
      _isNotifying = true;
      _playNotificationSound();

      // Trigger local notification for the first ready order
      final readyOrder = orders
          .firstWhere((order) => order['status'] == OrderStatus.READY.name);
      _showLocalNotification(readyOrder['id'].toString());
    } else {
      _stopNotificationSound();
    }
  }

  void _showLocalNotification(String orderId) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'order_ready_channel', // Channel ID
      'Order Ready Notifications', // Channel name
      channelDescription: 'Notifications for orders ready for pickup',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      0, // Notification ID
      NotificationStrings.readyForPickupTitle,
      '${NotificationStrings.readyForPickupBody} $orderId',
      notificationDetails,
    );
  }

  Future<void> _checkOrder() async {
    final orderId = _orderIdController.text.trim();

    if (orderId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.needValidOrderID)),
      );
      return;
    }

    try {
      // Replace <id> in the endpoint with the actual order ID
      final orderController =
          Provider.of<OrderController>(context, listen: false);
      await orderController.checkOrder(int.parse(orderId));
      await orderController.fetchOrdersByPhone();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.checkOrderSuccessed)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.checkOrderFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderController = Provider.of<OrderController>(context);

    // Check and play notification sound based on fetched orders
    _checkAndPlayNotificationSound(orderController.orders);

    return Scaffold(
      body: Column(
        children: [
          // Input field and add button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _orderIdController,
                    hintText: AppStrings.enterOrderID,
                  ),
                ),
                const SizedBox(width: 8.0),
                AppButton(
                  text: "+", // Use centralized string
                  onPressed: _checkOrder, borderRadius: 4,
                ),
              ],
            ),
          ),

          // Order list
          Expanded(
            child: orderController.isLoading
                ? const Center(child: CircularProgressIndicator())
                : orderController.errorMessage != null
                    ? Center(child: Text(orderController.errorMessage!))
                    : orderController.orders.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.orange,
                                  size: 48.0,
                                ),
                                const SizedBox(height: 16.0),
                                const Text(
                                  AppStrings.noOrder,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: orderController.orders.length,
                            itemBuilder: (context, index) {
                              final order = orderController.orders[index];
                              final status =
                                  OrderStatusHelper.fromString(order['status']);
                              final isAnimating = status == OrderStatus.READY;

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: isAnimating
                                    ? ScaleTransition(
                                        scale:
                                            _scaleAnimation, // Apply zoom in/out animation
                                        child: _buildOrderCard(order, status),
                                      )
                                    : _buildOrderCard(order, status),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, OrderStatus status) {
    return GestureDetector(
      onTap: () {
        if (status == OrderStatus.READY) {
          _stopNotificationSound();
        }
      },
      child: Card(
        color: OrderStatusHelper.getStatusColor(status), // Set card color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Order Number
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.orderNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    order['id'].toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),

              // Order Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.orderStatus,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    OrderStatusHelper.getStatusText(status),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
