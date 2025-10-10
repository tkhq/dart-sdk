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

const Map<OtpType, FilterType> otpTypeToFilterTypeMap = {
  OtpType.Email: FilterType.Email,
  OtpType.SMS: FilterType.SMS,
};

const OTP_AUTH_DEFAULT_EXPIRATION_SECONDS = 15 * 60;

const MAX_SESSIONS = 15;

const TURNKEY_OAUTH_ORIGIN_URL = "https://oauth-origin.turnkey.com";
const TURNKEY_OAUTH_REDIRECT_URL = "https://oauth-redirect.turnkey.com";

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
