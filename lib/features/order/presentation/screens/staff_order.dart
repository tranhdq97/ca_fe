import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../features/menu/presentation/controllers/menu_controller.dart';
import '../../../../features/menu/helpers/category_helper.dart';

class StaffOrderScreen extends StatefulWidget {
  const StaffOrderScreen({Key? key}) : super(key: key);

  @override
  _StaffOrderScreenState createState() => _StaffOrderScreenState();
}

class _StaffOrderScreenState extends State<StaffOrderScreen> {
  List<Map<String, dynamic>> _currentOrder = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  // Get sorted order items
  List<Map<String, dynamic>> get _sortedOrderItems {
    // Create a copy of the list to avoid modifying the original
    final sortedList = List<Map<String, dynamic>>.from(_currentOrder);
    // Sort by name alphabetically
    sortedList
        .sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
    return sortedList;
  }

  void _addItemToOrder(Map<String, dynamic> menuItem) {
    setState(() {
      final existingItem = _currentOrder.firstWhere(
        (item) => item['id'] == menuItem['id'],
        orElse: () => {},
      );

      if (existingItem.isNotEmpty) {
        existingItem['quantity'] += 1;
      } else {
        _currentOrder.add({
          'id': menuItem['id'],
          'name': menuItem['name'],
          'price': menuItem['price'],
          'quantity': 1,
        });
      }
    });
  }

  void _removeItemFromOrder(int itemId) {
    setState(() {
      _currentOrder.removeWhere((item) => item['id'] == itemId);
    });
  }

  void _incrementQuantity(int itemId) {
    setState(() {
      final item = _currentOrder.firstWhere((item) => item['id'] == itemId);
      item['quantity'] += 1;
    });
  }

  void _decrementQuantity(int itemId) {
    setState(() {
      final item = _currentOrder.firstWhere((item) => item['id'] == itemId);
      if (item['quantity'] > 1) {
        item['quantity'] -= 1;
      } else {
        _removeItemFromOrder(itemId);
      }
    });
  }

  // Calculate total price of the order
  int _calculateTotal() {
    return _currentOrder.fold(0, (total, item) {
      return total + (item['price'] as int) * (item['quantity'] as int);
    });
  }

  void _printOrder() async {
    if (_currentOrder.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.noItems)),
      );
      return;
    }

    // Show dialog with order details
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Chi tiết đơn hàng'),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Order items
              Container(
                height: 300, // Fixed height for the list
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _sortedOrderItems.length,
                  itemBuilder: (context, index) {
                    final item = _sortedOrderItems[index];
                    final itemTotal =
                        (item['price'] as int) * (item['quantity'] as int);
                    final formattedPrice =
                        NumberFormat('#,###').format(item['price']);
                    final formattedTotal =
                        NumberFormat('#,###').format(itemTotal);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(item['name']),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('${item['quantity']} x'),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('$formattedPrice đ'),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '$formattedTotal đ',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Divider
              Divider(thickness: 1.0),

              // Total
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng cộng:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${NumberFormat('#,###').format(_calculateTotal())} đ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            onPressed: () {
              // Perform print functionality here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppStrings.printOrder)),
              );
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.print),
            label: Text('In đơn hàng'),
          ),
        ],
      ),
    );
  }

  Future<void> _chargeOrder() async {
    try {
      final apiClient = ApiClient();
      final response = await apiClient.post(
        ApiEndpoints.allOrders,
      );

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.charged)),
        );
        setState(() {
          _currentOrder.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.chargeFailed)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.chargeFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuItemController>(
      builder: (context, menuController, _) {
        // Ensure menu items are loaded
        if (menuController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Map<String, dynamic>> categories = menuController.categories;

        // Set default category if needed
        if (categories.isNotEmpty && _selectedCategory == 'All') {
          // Initialize with first category
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _selectedCategory = categories.first['name'];
              menuController.setActiveCategory(categories.first['id']);
            });
          });
        }

        return Column(
          children: [
            // Current Order Section
            Expanded(
              flex: _currentOrder.isEmpty ? 1 : 5,
              child: Container(
                color: Colors.grey[200],
                child: Column(
                  children: [
                    // Buttons at the top
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            onPressed: _printOrder,
                            icon: const Icon(Icons.print),
                            label: Text(AppStrings.printOrder),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            onPressed: _chargeOrder,
                            child: Text(AppStrings.charged),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: _currentOrder.isEmpty
                          ? Center(
                              child: Text(
                                AppStrings.noItems,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount:
                                  _sortedOrderItems.length, // Use sorted list
                              itemBuilder: (context, index) {
                                final item =
                                    _sortedOrderItems[index]; // Use sorted list
                                final formattedPrice =
                                    NumberFormat('#,###').format(item['price']);
                                return ListTile(
                                  dense: true, // Reduce vertical padding
                                  visualDensity:
                                      VisualDensity.compact, // More compact
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        8.0, // Reduced horizontal padding
                                    vertical: 0.0, // No vertical padding
                                  ),
                                  title: Text('${item['name']}'),
                                  subtitle: Text('$formattedPrice VND'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero, // No padding
                                        constraints:
                                            BoxConstraints(), // No constraints
                                        icon: const Icon(Icons.remove,
                                            size: 20), // Smaller icon
                                        onPressed: () {
                                          _decrementQuantity(item['id']);
                                        },
                                      ),
                                      SizedBox(width: 8), // Small spacing
                                      Text(
                                        '${item['quantity']}',
                                        style: const TextStyle(
                                          fontSize: 16.0, // Smaller font
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8), // Small spacing
                                      IconButton(
                                        padding: EdgeInsets.zero, // No padding
                                        constraints:
                                            BoxConstraints(), // No constraints
                                        icon: const Icon(Icons.add,
                                            size: 20), // Smaller icon
                                        onPressed: () {
                                          _incrementQuantity(item['id']);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // Menu Section (keep the rest of your existing code)
            Expanded(
              flex: 10,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // Search bar at the top
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppTextField(
                        controller: _searchController,
                        hintText: AppStrings.search,
                        prefixIcon: Icons.search,
                        onChanged: (value) {
                          menuController.filterItemsBySearch(value);
                        },
                      ),
                    ),

                    // Categories and menu items in a Row
                    Expanded(
                      child: Row(
                        children: [
                          // Categories list (vertical with icons)
                          Container(
                            width: 60, // Width for icons only
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: ListView.builder(
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                final categoryName = category['name'] as String;
                                final isSelected =
                                    _selectedCategory == categoryName;

                                // Get appropriate icon
                                IconData icon = Icons.category; // Default icon

                                // Get category icon from helper
                                final categoryIcon =
                                    CategoryHelper.getIconByName(categoryName);
                                if (categoryIcon != null) {
                                  icon = categoryIcon;
                                }

                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory = categoryName;
                                      // Set active category ID
                                      menuController
                                          .setActiveCategory(category['id']);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.grey[200]
                                          : Colors.transparent,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[300]!,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    child: Icon(
                                      icon,
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.grey[600],
                                      size: 28.0,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Menu items list
                          Expanded(
                            child: ListView.builder(
                              itemCount: menuController.filteredItems.length,
                              itemBuilder: (context, index) {
                                final menuItem =
                                    menuController.filteredItems[index];
                                final formattedPrice = NumberFormat('#,###')
                                    .format(menuItem['price']);
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      menuItem['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text('$formattedPrice VND'),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.add_circle,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        _addItemToOrder(menuItem);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
