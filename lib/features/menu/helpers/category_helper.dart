import 'package:flutter/material.dart';

class CategoryHelper {
  static const List<Map<String, dynamic>> categories = [
    {
      'name': 'Nước', // "Drinks"
      'icon': Icons.local_drink,
    },
    {
      'name': 'Ăn vặt', // "Food"
      'icon': Icons.lunch_dining,
    },
    {
      "name": 'Tượng',
      'icon': Icons.emoji_objects,
    }
  ];

  static IconData? getIconByName(String name) {
    for (var category in categories) {
      if (category['name'] == name) {
        return category['icon'] as IconData?;
      }
    }
    return null;
  }
}
