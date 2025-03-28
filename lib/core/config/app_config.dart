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
    _instance._apiBaseUrl = apiBaseUrl ?? _instance._apiBaseUrl;
    _instance._environment = environment ?? _instance._environment;
    _instance._enableLogging = enableLogging ?? _instance._enableLogging;
    _instance._appName = appName ?? _instance._appName;
    _instance._appVersion = appVersion ?? _instance._appVersion;

    return _instance;
  }

  // Private constructor
  AppConfig._internal()
    : _apiBaseUrl = 'http://gagaallall.pythonanywhere.com',
      _environment = Environment.dev,
      _enableLogging = true,
      _appName = 'Dual Login App',
      _appVersion = '1.0.0';

  // Private fields with getters
  String _apiBaseUrl;
  Environment _environment;
  bool _enableLogging;
  String _appName;
  String _appVersion;

  // Getters
  String get apiBaseUrl => _apiBaseUrl;
  Environment get environment => _environment;
  bool get enableLogging => _enableLogging;
  String get appName => _appName;
  String get appVersion => _appVersion;
  bool get isProduction => _environment == Environment.prod;
  bool get isDevelopment => _environment == Environment.dev;

  // Helper method to initialize config based on environment
  static void initConfig(Environment env) {
    switch (env) {
      case Environment.dev:
        AppConfig(
          apiBaseUrl: 'http://gagaallall.pythonanywhere.com',
          environment: Environment.dev,
          enableLogging: true,
        );
        break;
      case Environment.staging:
        AppConfig(
          apiBaseUrl: 'http://staging.gagaallall.pythonanywhere.com',
          environment: Environment.staging,
          enableLogging: true,
        );
        break;
      case Environment.prod:
        AppConfig(
          apiBaseUrl: 'http://gagaallall.pythonanywhere.com',
          environment: Environment.prod,
          enableLogging: false,
        );
        break;
    }
  }
}
