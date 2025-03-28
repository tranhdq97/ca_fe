import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/config/app_config.dart';
import 'core/models/app_route.dart';
import 'core/services/local_notifications.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/client_home_screen.dart';
import 'features/home/presentation/screens/staff_home_screen.dart';
import 'core/routes/app_routes.dart';
import 'app_themes.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/order/presentation/controllers/order_controller.dart';
import 'features/menu/presentation/controllers/menu_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.initialize();
  AppConfig.initConfig(Environment.dev);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => OrderController()),
        ChangeNotifierProvider(create: (_) => MenuItemController())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: AppThemes.lightTheme,
      initialRoute: AppRoutes.getRoute(AppRoute.splash),
      routes: {
        AppRoutes.getRoute(AppRoute.login): (context) => LoginScreen(),
        AppRoutes.getRoute(AppRoute.clientHome): (context) =>
            ClientHomeScreen(),
        AppRoutes.getRoute(AppRoute.staffHome): (context) => StaffHomeScreen(),
        AppRoutes.getRoute(AppRoute.splash): (context) => SplashScreen(),
      },
    );
  }
}
