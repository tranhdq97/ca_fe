import 'package:flutter/material.dart';
import 'package:pisces_ordering/core/constants/app_strings.dart';
import '../../../../core/models/app_route.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../order/presentation/screens/staff_order.dart';
import '../../../order/presentation/screens/order_list.dart';

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({Key? key}) : super(key: key);

  @override
  _StaffHomeScreenState createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  int _currentIndex = 0; // Default mode is Staff Order (index 0)

  final List<Widget> _screens = [
    StaffOrderScreen(), // Staff Order Mode
    OrderListScreen(), // Order List Mode
  ];

  void _signOut(BuildContext context) {
    // Clear user data or tokens (if applicable)
    // Navigate to the login screen
    Navigator.of(context)
        .pushReplacementNamed(AppRoutes.getRoute(AppRoute.login));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? AppStrings.orders // Title for Staff Order mode
              : AppStrings.menuLabel, // Title for Order List mode
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _signOut(context); // Sign out action
            },
          ),
        ],
      ),
      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.orange, // Highlight active mode
        unselectedItemColor: Colors.grey, // Color for inactive items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: AppStrings.orders,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: AppStrings.menuLabel,
          ),
        ],
      ),
    );
  }
}
