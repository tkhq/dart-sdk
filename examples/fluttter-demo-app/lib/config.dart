import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get turnkeyApiUrl => dotenv.env['TURNKY_API_URL'] ?? 'https://api.turnkey.com';
  static String get backendApiUrl => dotenv.env['BACKEND_API_URL'] ?? 'http://localhost:8081';
  static String get rpId => dotenv.env['RP_ID'] ?? '';
  static String get organizationId => dotenv.env['ORGANIZATION_ID'] ?? '';
}

Future<void> loadEnv() async {
  await dotenv.load(fileName: ".env");
}
