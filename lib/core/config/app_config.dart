enum Environment { dev, staging, prod }

class AppConfig {
  final String apiBaseUrl;
  final Environment environment;
  final bool enableLogging;
  final String appName;
  final String appVersion;

  // Singleton pattern
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig({
    String? apiBaseUrl,
    Environment? environment,
    bool? enableLogging,
    String? appName,
    String? appVersion,
  }) {
    return AppConfig._internal(
      apiBaseUrl: apiBaseUrl ?? _instance.apiBaseUrl,
      environment: environment ?? _instance.environment,
      enableLogging: enableLogging ?? _instance.enableLogging,
      appName: appName ?? _instance.appName,
      appVersion: appVersion ?? _instance.appVersion,
    );
  }

  // Private constructor
  AppConfig._internal({
    this.apiBaseUrl = 'https://gagaallall.pythonanywhere.com',
    this.environment = Environment.dev,
    this.enableLogging = true,
    this.appName = 'Dual Login App',
    this.appVersion = '1.0.0',
  });

  // Helper method to initialize config based on environment
  static void initConfig(Environment env) {
    switch (env) {
      case Environment.dev:
        AppConfig(
          apiBaseUrl: 'https://gagaallall.pythonanywhere.com',
          environment: Environment.dev,
          enableLogging: true,
        );
        break;
      case Environment.staging:
        AppConfig(
          apiBaseUrl: 'hthttps://gagaallall.pythonanywhere.com',
          environment: Environment.staging,
          enableLogging: true,
        );
        break;
      case Environment.prod:
        AppConfig(
          apiBaseUrl: 'https://gagaallall.pythonanywhere.com',
          environment: Environment.prod,
          enableLogging: false,
        );
        break;
    }
  }
}
