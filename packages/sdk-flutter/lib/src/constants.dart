import 'package:turnkey_http/__generated__/services/coordinator/v1/public_api.swagger.dart';

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

const OTP_AUTH_DEFAULT_EXPIRATION_SECONDS = 15 * 60;

const MAX_SESSIONS = 15;

const TURNKEY_OAUTH_ORIGIN_URL = "https://oauth-origin.turnkey.com";
const TURNKEY_OAUTH_REDIRECT_URL = "https://oauth-redirect.turnkey.com";

final DEFAULT_ETHEREUM_ACCOUNT = WalletAccountParams(
  curve: Curve.curveSecp256k1,
  pathFormat: PathFormat.pathFormatBip32,
  path: "m/44'/60'/0'/0/0",
  addressFormat: AddressFormat.addressFormatEthereum,
);

final DEFAULT_SOLANA_ACCOUNT = WalletAccountParams(
    curve: Curve.curveEd25519,
    pathFormat: PathFormat.pathFormatBip32,
    path: "m/44'/501'/0'/0'",
    addressFormat: AddressFormat.addressFormatSolana);
