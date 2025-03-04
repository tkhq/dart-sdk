import 'package:turnkey_http/__generated__/services/coordinator/v1/public_api.swagger.dart';

// default storage key
const TURNKEY_DEFAULT_SESSION_STORAGE = "turnkey_session";

// fixed storage keys (used internally by the SDK)
const TURNKEY_EMBEDDED_KEY_STORAGE = "turnkey_embedded_key";
const TURNKEY_SESSION_KEYS_INDEX = "turnkey_session_keys_index";
const TURNKEY_SELECTED_SESSION = "turnkey_selected_session";

const OTP_AUTH_DEFAULT_EXPIRATION_SECONDS = 15 * 60;

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
