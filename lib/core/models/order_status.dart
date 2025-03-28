import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum OrderStatus {
  ESTABLISHED, // "Đang làm"
  PROCESSING, // "Chờ nhận hàng"
  READY, // "Đã giao",
  DELIVERED, // "Đã giao"
}

class OrderStatusHelper {
  static String getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.ESTABLISHED:
        return 'Đang gọi món'; // "In Progress"
      case OrderStatus.PROCESSING:
        return 'Đang làm'; // "In Progress"
      case OrderStatus.READY:
        return 'Chờ nhận hàng'; // "Ready for Pickup"
      case OrderStatus.DELIVERED:
        return 'Đã giao'; // "Picked Up"
    }
  }

  static Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.ESTABLISHED:
        return Colors.green; // Primary color
      case OrderStatus.PROCESSING:
        return AppColors.primaryBlue; // Primary color
      case OrderStatus.READY:
        return Colors.red; // Red for "Ready for Pickup"
      case OrderStatus.DELIVERED:
        return Colors.grey; // Green for "Picked Up"
    }
  }

  static OrderStatus fromString(String status) {
    switch (status) {
      case 'ESTABLISHED':
        return OrderStatus.ESTABLISHED;
      case 'PROCESSING':
        return OrderStatus.PROCESSING;
      case 'READY':
        return OrderStatus.READY;
      case 'DELIVERED':
        return OrderStatus.DELIVERED;
      default:
        throw Exception('Invalid OrderStatus: $status');
    }
  }
}
