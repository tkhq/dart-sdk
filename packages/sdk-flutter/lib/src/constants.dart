import 'package:turnkey_http/__generated__/services/coordinator/v1/public_api.swagger.dart';

final OTP_AUTH_DEFAULT_EXPIRATION_SECONDS = 15 * 60;

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
