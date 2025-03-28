import '../models/app_route.dart';

class AppRoutes {
  static String getRoute(AppRoute route) {
    switch (route) {
      case AppRoute.clientHome:
        return '/client_home';
      case AppRoute.staffHome:
        return '/staff_home';
      case AppRoute.login:
        return '/login';
      case AppRoute.splash:
        return '/splash';
      default:
        throw Exception('Route not defined');
    }
  }
}
