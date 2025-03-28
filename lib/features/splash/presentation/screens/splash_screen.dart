import 'package:flutter/material.dart';
import '../../../../core/models/user_type.dart';
import '../../../../services/auth_service.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../home/presentation/screens/staff_home_screen.dart';
import '../../../home/presentation/screens/client_home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  Future<void> _checkLoginStatus(BuildContext context) async {
    final isLoggedIn = await AuthService.getLoggedInStatus();
    final userType = await AuthService.getUserType(); // Get user type as enum

    if (isLoggedIn) {
      if (userType == UserType.staff) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StaffHomeScreen()),
        );
      } else if (userType == UserType.client) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClientHomeScreen()),
        );
      } else {
        // If userType is null or invalid, fallback to login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Perform the login status check after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus(context);
    });

    return Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), // Show a loading indicator while checking
      ),
    );
  }
}
