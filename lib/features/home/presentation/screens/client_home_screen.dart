import '../../../../core/models/app_route.dart';
import '../../../../core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart'; // Import your theme colors
import '../../../order/presentation/screens/client_order.dart';
import '../../../menu/presentation/screens/client_menu.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({Key? key}) : super(key: key);

  @override
  _ClientHomeScreenState createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int _currentIndex = 0; // Track the selected mode (0 = Order, 1 = Menu)

  final List<Widget> _screens = [
    OrderScreen(), // Order Mode
    MenuScreen(), // Menu Mode
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
              ? AppStrings.yourOrders // Use centralized string
              : AppStrings.menu, // Use centralized string
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
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
        selectedItemColor: AppColors.secondaryOrange, // Highlight active mode
        unselectedItemColor: Colors.grey, // Color for inactive items
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: AppStrings.orders, // Use centralized string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: AppStrings.menuLabel, // Use centralized string
          ),
        ],
      ),
    );
  }
}
