import 'package:turnkey_http/__generated__/models.dart';

enum StorageKeys {
  AllSessionKeys("@turnkey/all-session-keys"),
  ActiveSessionKey("@turnkey/active-session-key"),
  DefaultSession("@turnkey/session"),
  EmbeddedKey("@turnkey/embedded-key");

  final String value;
  const StorageKeys(this.value);
}

enum OtpType {
  Email("OTP_TYPE_EMAIL"),
  SMS("OTP_TYPE_SMS");

  final String value;
  const OtpType(this.value);
}

enum FilterType {
  Email("EMAIL"),
  SMS("PHONE_NUMBER");

  final String value;
  const FilterType(this.value);
}

enum AuthAction {
  login("LOGIN"),
  signup("SIGNUP");

  final String value;
  const AuthAction(this.value);

  bool get isLogin => this == AuthAction.login;
  bool get isSignup => this == AuthAction.signup;
}

const Map<OtpType, FilterType> otpTypeToFilterTypeMap = {
  OtpType.Email: FilterType.Email,
  OtpType.SMS: FilterType.SMS,
};

const OTP_AUTH_DEFAULT_EXPIRATION_SECONDS = "900";

const MAX_SESSIONS = 15;

const X_AUTH_URL = "https://x.com/i/oauth2/authorize";
const DISCORD_AUTH_URL = "https://discord.com/oauth2/authorize";
const TURNKEY_OAUTH_ORIGIN_URL = "https://oauth-origin.turnkey.com";
const TURNKEY_OAUTH_REDIRECT_URL = "https://oauth-redirect.turnkey.com";
const APPLE_AUTH_URL = "https://account.apple.com/auth/authorize";
const APPLE_AUTH_SCRIPT_URL = "https://appleid.cdn-apple.com/appleauth/static/jsapi/appleid/1/en_US/appleid.auth.js";

final DEFAULT_ETHEREUM_ACCOUNT = v1WalletAccountParams(
  curve: v1Curve.curve_secp256k1,
  pathFormat: v1PathFormat.path_format_bip32,
  path: "m/44'/60'/0'/0/0",
  addressFormat: v1AddressFormat.address_format_ethereum,
);

final DEFAULT_SOLANA_ACCOUNT = v1WalletAccountParams(
    curve: v1Curve.curve_ed25519,
    pathFormat: v1PathFormat.path_format_bip32,
    path: "m/44'/501'/0'/0'",
    addressFormat: v1AddressFormat.address_format_solana);
