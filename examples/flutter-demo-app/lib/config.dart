import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get turnkeyApiUrl =>
      dotenv.env['TURNKEY_API_URL'] ?? 'https://api.turnkey.com';
  static String get backendApiUrl =>
      dotenv.env['BACKEND_API_URL'] ?? 'http://localhost:8081';
  static String get rpId => dotenv.env['RP_ID'] ?? '';
  static String get organizationId => dotenv.env['ORGANIZATION_ID'] ?? '';
  static String get googleClientId => dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
  static String get googleRedirectScheme =>
      dotenv.env['GOOGLE_REDIRECT_SCHEME'] ?? '';
}

Future<void> loadEnv() async {
  await dotenv.load(fileName: ".env");
}
