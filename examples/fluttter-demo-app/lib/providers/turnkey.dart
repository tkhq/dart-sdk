import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_flutter_demo_app/utils/turnkey_rpc.dart';
import 'package:turnkey_flutter_demo_app/screens/otp.dart';
import 'package:turnkey_flutter_demo_app/screens/dashboard.dart';
import '../utils/constants.dart';
import 'session.dart';

class TurnkeyProvider with ChangeNotifier {
  final Map<String, bool> _loading = {};
  String? _errorMessage;

  bool isLoading(String key) => _loading[key] ?? false;
  String? get errorMessage => _errorMessage;

  void setLoading(String key, bool loading) {
    _loading[key] = loading;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> initEmailLogin(BuildContext context, String email) async {
    setLoading('initEmailLogin', true);
    setError(null);

    final otpType = 'OTP_TYPE_EMAIL';

    try {
      final response = await initOTPAuth({
        'otpType': otpType,
        'contact': email,
      });

      if (response != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              otpType: otpType,
              otpId: response['otpId'],
              organizationId: response['organizationId'],
            ),
          ),
        );
      }
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading('initEmailLogin', false);
    }
  }

  Future<void> completeEmailAuth({
    required BuildContext context,
    required String otpId,
    required String otpCode,
    required String organizationId,
  }) async {
    if (otpCode.isNotEmpty) {
      setLoading('completeEmailAuth', true);
      setError(null);

      try {
        final sessionProvider =
            Provider.of<SessionProvider>(context, listen: false);
        final targetPublicKey = await sessionProvider.createEmbeddedKey();

        final response = await otpAuth({
          'otpId': otpId,
          'otpCode': otpCode,
          'organizationId': organizationId,
          'targetPublicKey': targetPublicKey,
          'expirationSeconds': OTP_AUTH_DEFAULT_EXPIRATION_SECONDS.toString(),
          'invalidateExisting': false,
        });

        if (response['credentialBundle'] != null) {
          await sessionProvider.createSession(response['credentialBundle']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        }
      } catch (error) {
        setError(error.toString());
      } finally {
        setLoading('completeEmailAuth', false);
      }
    }
  }

  Future<void> initPhoneLogin(BuildContext context, String phone) async {
    final otpType = 'OTP_TYPE_SMS';
    setLoading('initPhoneLogin', true);
    setError(null);

    try {
      final response = await initOTPAuth({
        'otpType': otpType,
        'contact': phone,
      });

      if (response != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              otpType: otpType,
              otpId: response['otpId'],
              organizationId: response['organizationId'],
            ),
          ),
        );
      }
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading('initPhoneLogin', false);
    }
  }

  Future<void> completePhoneAuth({
    required BuildContext context,
    required String otpId,
    required String otpCode,
    required String organizationId,
  }) async {
    if (otpCode.isNotEmpty) {
      setLoading('completePhoneAuth', true);
      setError(null);

      try {
        final sessionProvider =
            Provider.of<SessionProvider>(context, listen: false);
        final targetPublicKey = await sessionProvider.createEmbeddedKey();

        final response = await otpAuth({
          'otpId': otpId,
          'otpCode': otpCode,
          'organizationId': organizationId,
          'targetPublicKey': targetPublicKey,
          'expirationSeconds': OTP_AUTH_DEFAULT_EXPIRATION_SECONDS.toString(),
          'invalidateExisting': false,
        });

        if (response['credentialBundle'] != null) {
          await sessionProvider.createSession(response['credentialBundle']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        }
      } catch (error) {
        setError(error.toString());
      } finally {
        setLoading('completePhoneAuth', false);
      }
    }
  }
}
