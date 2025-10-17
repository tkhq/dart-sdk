import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get turnkeyApiUrl =>
      dotenv.env['TURNKEY_API_URL'] ?? 'https://api.turnkey.com';
  static String get backendApiUrl =>
      dotenv.env['BACKEND_API_URL'] ?? 'http://localhost:8081';
  static String get rpId => dotenv.env['RP_ID'] ?? '';
  static String get organizationId => dotenv.env['ORGANIZATION_ID'] ?? '';
  static String get googleClientId => dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
  static String get appleClientId => dotenv.env['APPLE_CLIENT_ID'] ?? '';
  static String get xClientId => dotenv.env['X_CLIENT_ID'] ?? '';
  static String get discordClientId => dotenv.env['DISCORD_CLIENT_ID'] ?? '';
  static String get appScheme => dotenv.env['APP_SCHEME'] ?? '';
  static String? get authProxyUrl => dotenv.env['AUTH_PROXY_URL'];
  static String? get authProxyConfigId => dotenv.env['AUTH_PROXY_CONFIG_ID'];
}

Future<void> loadEnv() async {
  await dotenv.load(fileName: '.env');
}
