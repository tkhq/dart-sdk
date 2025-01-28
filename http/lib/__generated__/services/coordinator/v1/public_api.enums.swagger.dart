import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum V1AccessType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACCESS_TYPE_WEB')
  accessTypeWeb('ACCESS_TYPE_WEB'),
  @JsonValue('ACCESS_TYPE_API')
  accessTypeApi('ACCESS_TYPE_API'),
  @JsonValue('ACCESS_TYPE_ALL')
  accessTypeAll('ACCESS_TYPE_ALL');

  final String? value;

  const V1AccessType(this.value);
}

enum V1ActivityStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_STATUS_CREATED')
  activityStatusCreated('ACTIVITY_STATUS_CREATED'),
  @JsonValue('ACTIVITY_STATUS_PENDING')
  activityStatusPending('ACTIVITY_STATUS_PENDING'),
  @JsonValue('ACTIVITY_STATUS_COMPLETED')
  activityStatusCompleted('ACTIVITY_STATUS_COMPLETED'),
  @JsonValue('ACTIVITY_STATUS_FAILED')
  activityStatusFailed('ACTIVITY_STATUS_FAILED'),
  @JsonValue('ACTIVITY_STATUS_CONSENSUS_NEEDED')
  activityStatusConsensusNeeded('ACTIVITY_STATUS_CONSENSUS_NEEDED'),
  @JsonValue('ACTIVITY_STATUS_REJECTED')
  activityStatusRejected('ACTIVITY_STATUS_REJECTED');

  final String? value;

  const V1ActivityStatus(this.value);
}

enum V1ActivityType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_API_KEYS')
  activityTypeCreateApiKeys('ACTIVITY_TYPE_CREATE_API_KEYS'),
  @JsonValue('ACTIVITY_TYPE_CREATE_USERS')
  activityTypeCreateUsers('ACTIVITY_TYPE_CREATE_USERS'),
  @JsonValue('ACTIVITY_TYPE_CREATE_PRIVATE_KEYS')
  activityTypeCreatePrivateKeys('ACTIVITY_TYPE_CREATE_PRIVATE_KEYS'),
  @JsonValue('ACTIVITY_TYPE_SIGN_RAW_PAYLOAD')
  activityTypeSignRawPayload('ACTIVITY_TYPE_SIGN_RAW_PAYLOAD'),
  @JsonValue('ACTIVITY_TYPE_CREATE_INVITATIONS')
  activityTypeCreateInvitations('ACTIVITY_TYPE_CREATE_INVITATIONS'),
  @JsonValue('ACTIVITY_TYPE_ACCEPT_INVITATION')
  activityTypeAcceptInvitation('ACTIVITY_TYPE_ACCEPT_INVITATION'),
  @JsonValue('ACTIVITY_TYPE_CREATE_POLICY')
  activityTypeCreatePolicy('ACTIVITY_TYPE_CREATE_POLICY'),
  @JsonValue('ACTIVITY_TYPE_DISABLE_PRIVATE_KEY')
  activityTypeDisablePrivateKey('ACTIVITY_TYPE_DISABLE_PRIVATE_KEY'),
  @JsonValue('ACTIVITY_TYPE_DELETE_USERS')
  activityTypeDeleteUsers('ACTIVITY_TYPE_DELETE_USERS'),
  @JsonValue('ACTIVITY_TYPE_DELETE_API_KEYS')
  activityTypeDeleteApiKeys('ACTIVITY_TYPE_DELETE_API_KEYS'),
  @JsonValue('ACTIVITY_TYPE_DELETE_INVITATION')
  activityTypeDeleteInvitation('ACTIVITY_TYPE_DELETE_INVITATION'),
  @JsonValue('ACTIVITY_TYPE_DELETE_ORGANIZATION')
  activityTypeDeleteOrganization('ACTIVITY_TYPE_DELETE_ORGANIZATION'),
  @JsonValue('ACTIVITY_TYPE_DELETE_POLICY')
  activityTypeDeletePolicy('ACTIVITY_TYPE_DELETE_POLICY'),
  @JsonValue('ACTIVITY_TYPE_CREATE_USER_TAG')
  activityTypeCreateUserTag('ACTIVITY_TYPE_CREATE_USER_TAG'),
  @JsonValue('ACTIVITY_TYPE_DELETE_USER_TAGS')
  activityTypeDeleteUserTags('ACTIVITY_TYPE_DELETE_USER_TAGS'),
  @JsonValue('ACTIVITY_TYPE_CREATE_ORGANIZATION')
  activityTypeCreateOrganization('ACTIVITY_TYPE_CREATE_ORGANIZATION'),
  @JsonValue('ACTIVITY_TYPE_SIGN_TRANSACTION')
  activityTypeSignTransaction('ACTIVITY_TYPE_SIGN_TRANSACTION'),
  @JsonValue('ACTIVITY_TYPE_APPROVE_ACTIVITY')
  activityTypeApproveActivity('ACTIVITY_TYPE_APPROVE_ACTIVITY'),
  @JsonValue('ACTIVITY_TYPE_REJECT_ACTIVITY')
  activityTypeRejectActivity('ACTIVITY_TYPE_REJECT_ACTIVITY'),
  @JsonValue('ACTIVITY_TYPE_DELETE_AUTHENTICATORS')
  activityTypeDeleteAuthenticators('ACTIVITY_TYPE_DELETE_AUTHENTICATORS'),
  @JsonValue('ACTIVITY_TYPE_CREATE_AUTHENTICATORS')
  activityTypeCreateAuthenticators('ACTIVITY_TYPE_CREATE_AUTHENTICATORS'),
  @JsonValue('ACTIVITY_TYPE_CREATE_PRIVATE_KEY_TAG')
  activityTypeCreatePrivateKeyTag('ACTIVITY_TYPE_CREATE_PRIVATE_KEY_TAG'),
  @JsonValue('ACTIVITY_TYPE_DELETE_PRIVATE_KEY_TAGS')
  activityTypeDeletePrivateKeyTags('ACTIVITY_TYPE_DELETE_PRIVATE_KEY_TAGS'),
  @JsonValue('ACTIVITY_TYPE_SET_PAYMENT_METHOD')
  activityTypeSetPaymentMethod('ACTIVITY_TYPE_SET_PAYMENT_METHOD'),
  @JsonValue('ACTIVITY_TYPE_ACTIVATE_BILLING_TIER')
  activityTypeActivateBillingTier('ACTIVITY_TYPE_ACTIVATE_BILLING_TIER'),
  @JsonValue('ACTIVITY_TYPE_DELETE_PAYMENT_METHOD')
  activityTypeDeletePaymentMethod('ACTIVITY_TYPE_DELETE_PAYMENT_METHOD'),
  @JsonValue('ACTIVITY_TYPE_CREATE_POLICY_V2')
  activityTypeCreatePolicyV2('ACTIVITY_TYPE_CREATE_POLICY_V2'),
  @JsonValue('ACTIVITY_TYPE_CREATE_POLICY_V3')
  activityTypeCreatePolicyV3('ACTIVITY_TYPE_CREATE_POLICY_V3'),
  @JsonValue('ACTIVITY_TYPE_CREATE_API_ONLY_USERS')
  activityTypeCreateApiOnlyUsers('ACTIVITY_TYPE_CREATE_API_ONLY_USERS'),
  @JsonValue('ACTIVITY_TYPE_UPDATE_ROOT_QUORUM')
  activityTypeUpdateRootQuorum('ACTIVITY_TYPE_UPDATE_ROOT_QUORUM'),
  @JsonValue('ACTIVITY_TYPE_UPDATE_USER_TAG')
  activityTypeUpdateUserTag('ACTIVITY_TYPE_UPDATE_USER_TAG'),
  @JsonValue('ACTIVITY_TYPE_UPDATE_PRIVATE_KEY_TAG')
  activityTypeUpdatePrivateKeyTag('ACTIVITY_TYPE_UPDATE_PRIVATE_KEY_TAG'),
  @JsonValue('ACTIVITY_TYPE_CREATE_AUTHENTICATORS_V2')
  activityTypeCreateAuthenticatorsV2('ACTIVITY_TYPE_CREATE_AUTHENTICATORS_V2'),
  @JsonValue('ACTIVITY_TYPE_CREATE_ORGANIZATION_V2')
  activityTypeCreateOrganizationV2('ACTIVITY_TYPE_CREATE_ORGANIZATION_V2'),
  @JsonValue('ACTIVITY_TYPE_CREATE_USERS_V2')
  activityTypeCreateUsersV2('ACTIVITY_TYPE_CREATE_USERS_V2'),
  @JsonValue('ACTIVITY_TYPE_ACCEPT_INVITATION_V2')
  activityTypeAcceptInvitationV2('ACTIVITY_TYPE_ACCEPT_INVITATION_V2'),
  @JsonValue('ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION')
  activityTypeCreateSubOrganization('ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION'),
  @JsonValue('ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V2')
  activityTypeCreateSubOrganizationV2(
      'ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V2'),
  @JsonValue('ACTIVITY_TYPE_UPDATE_ALLOWED_ORIGINS')
  activityTypeUpdateAllowedOrigins('ACTIVITY_TYPE_UPDATE_ALLOWED_ORIGINS'),
  @JsonValue('ACTIVITY_TYPE_CREATE_PRIVATE_KEYS_V2')
  activityTypeCreatePrivateKeysV2('ACTIVITY_TYPE_CREATE_PRIVATE_KEYS_V2'),
  @JsonValue('ACTIVITY_TYPE_UPDATE_USER')
  activityTypeUpdateUser('ACTIVITY_TYPE_UPDATE_USER'),
  @JsonValue('ACTIVITY_TYPE_UPDATE_POLICY')
  activityTypeUpdatePolicy('ACTIVITY_TYPE_UPDATE_POLICY'),
  @JsonValue('ACTIVITY_TYPE_SET_PAYMENT_METHOD_V2')
  activityTypeSetPaymentMethodV2('ACTIVITY_TYPE_SET_PAYMENT_METHOD_V2'),
  @JsonValue('ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V3')
  activityTypeCreateSubOrganizationV3(
      'ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V3'),
  @JsonValue('ACTIVITY_TYPE_CREATE_WALLET')
  activityTypeCreateWallet('ACTIVITY_TYPE_CREATE_WALLET'),
  @JsonValue('ACTIVITY_TYPE_CREATE_WALLET_ACCOUNTS')
  activityTypeCreateWalletAccounts('ACTIVITY_TYPE_CREATE_WALLET_ACCOUNTS'),
  @JsonValue('ACTIVITY_TYPE_INIT_USER_EMAIL_RECOVERY')
  activityTypeInitUserEmailRecovery('ACTIVITY_TYPE_INIT_USER_EMAIL_RECOVERY'),
  @JsonValue('ACTIVITY_TYPE_RECOVER_USER')
  activityTypeRecoverUser('ACTIVITY_TYPE_RECOVER_USER'),
  @JsonValue('ACTIVITY_TYPE_SET_ORGANIZATION_FEATURE')
  activityTypeSetOrganizationFeature('ACTIVITY_TYPE_SET_ORGANIZATION_FEATURE'),
  @JsonValue('ACTIVITY_TYPE_REMOVE_ORGANIZATION_FEATURE')
  activityTypeRemoveOrganizationFeature(
      'ACTIVITY_TYPE_REMOVE_ORGANIZATION_FEATURE'),
  @JsonValue('ACTIVITY_TYPE_SIGN_RAW_PAYLOAD_V2')
  activityTypeSignRawPayloadV2('ACTIVITY_TYPE_SIGN_RAW_PAYLOAD_V2'),
  @JsonValue('ACTIVITY_TYPE_SIGN_TRANSACTION_V2')
  activityTypeSignTransactionV2('ACTIVITY_TYPE_SIGN_TRANSACTION_V2'),
  @JsonValue('ACTIVITY_TYPE_EXPORT_PRIVATE_KEY')
  activityTypeExportPrivateKey('ACTIVITY_TYPE_EXPORT_PRIVATE_KEY'),
  @JsonValue('ACTIVITY_TYPE_EXPORT_WALLET')
  activityTypeExportWallet('ACTIVITY_TYPE_EXPORT_WALLET'),
  @JsonValue('ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V4')
  activityTypeCreateSubOrganizationV4(
      'ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V4'),
  @JsonValue('ACTIVITY_TYPE_EMAIL_AUTH')
  activityTypeEmailAuth('ACTIVITY_TYPE_EMAIL_AUTH'),
  @JsonValue('ACTIVITY_TYPE_EXPORT_WALLET_ACCOUNT')
  activityTypeExportWalletAccount('ACTIVITY_TYPE_EXPORT_WALLET_ACCOUNT'),
  @JsonValue('ACTIVITY_TYPE_INIT_IMPORT_WALLET')
  activityTypeInitImportWallet('ACTIVITY_TYPE_INIT_IMPORT_WALLET'),
  @JsonValue('ACTIVITY_TYPE_IMPORT_WALLET')
  activityTypeImportWallet('ACTIVITY_TYPE_IMPORT_WALLET'),
  @JsonValue('ACTIVITY_TYPE_INIT_IMPORT_PRIVATE_KEY')
  activityTypeInitImportPrivateKey('ACTIVITY_TYPE_INIT_IMPORT_PRIVATE_KEY'),
  @JsonValue('ACTIVITY_TYPE_IMPORT_PRIVATE_KEY')
  activityTypeImportPrivateKey('ACTIVITY_TYPE_IMPORT_PRIVATE_KEY'),
  @JsonValue('ACTIVITY_TYPE_CREATE_POLICIES')
  activityTypeCreatePolicies('ACTIVITY_TYPE_CREATE_POLICIES'),
  @JsonValue('ACTIVITY_TYPE_SIGN_RAW_PAYLOADS')
  activityTypeSignRawPayloads('ACTIVITY_TYPE_SIGN_RAW_PAYLOADS'),
  @JsonValue('ACTIVITY_TYPE_CREATE_READ_ONLY_SESSION')
  activityTypeCreateReadOnlySession('ACTIVITY_TYPE_CREATE_READ_ONLY_SESSION'),
  @JsonValue('ACTIVITY_TYPE_CREATE_OAUTH_PROVIDERS')
  activityTypeCreateOauthProviders('ACTIVITY_TYPE_CREATE_OAUTH_PROVIDERS'),
  @JsonValue('ACTIVITY_TYPE_DELETE_OAUTH_PROVIDERS')
  activityTypeDeleteOauthProviders('ACTIVITY_TYPE_DELETE_OAUTH_PROVIDERS'),
  @JsonValue('ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V5')
  activityTypeCreateSubOrganizationV5(
      'ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V5'),
  @JsonValue('ACTIVITY_TYPE_OAUTH')
  activityTypeOauth('ACTIVITY_TYPE_OAUTH'),
  @JsonValue('ACTIVITY_TYPE_CREATE_API_KEYS_V2')
  activityTypeCreateApiKeysV2('ACTIVITY_TYPE_CREATE_API_KEYS_V2'),
  @JsonValue('ACTIVITY_TYPE_CREATE_READ_WRITE_SESSION')
  activityTypeCreateReadWriteSession('ACTIVITY_TYPE_CREATE_READ_WRITE_SESSION'),
  @JsonValue('ACTIVITY_TYPE_EMAIL_AUTH_V2')
  activityTypeEmailAuthV2('ACTIVITY_TYPE_EMAIL_AUTH_V2'),
  @JsonValue('ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V6')
  activityTypeCreateSubOrganizationV6(
      'ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V6'),
  @JsonValue('ACTIVITY_TYPE_DELETE_PRIVATE_KEYS')
  activityTypeDeletePrivateKeys('ACTIVITY_TYPE_DELETE_PRIVATE_KEYS'),
  @JsonValue('ACTIVITY_TYPE_DELETE_WALLETS')
  activityTypeDeleteWallets('ACTIVITY_TYPE_DELETE_WALLETS'),
  @JsonValue('ACTIVITY_TYPE_CREATE_READ_WRITE_SESSION_V2')
  activityTypeCreateReadWriteSessionV2(
      'ACTIVITY_TYPE_CREATE_READ_WRITE_SESSION_V2'),
  @JsonValue('ACTIVITY_TYPE_DELETE_SUB_ORGANIZATION')
  activityTypeDeleteSubOrganization('ACTIVITY_TYPE_DELETE_SUB_ORGANIZATION'),
  @JsonValue('ACTIVITY_TYPE_INIT_OTP_AUTH')
  activityTypeInitOtpAuth('ACTIVITY_TYPE_INIT_OTP_AUTH'),
  @JsonValue('ACTIVITY_TYPE_OTP_AUTH')
  activityTypeOtpAuth('ACTIVITY_TYPE_OTP_AUTH'),
  @JsonValue('ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V7')
  activityTypeCreateSubOrganizationV7(
      'ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V7');

  final String? value;

  const V1ActivityType(this.value);
}

enum V1AddressFormat {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ADDRESS_FORMAT_UNCOMPRESSED')
  addressFormatUncompressed('ADDRESS_FORMAT_UNCOMPRESSED'),
  @JsonValue('ADDRESS_FORMAT_COMPRESSED')
  addressFormatCompressed('ADDRESS_FORMAT_COMPRESSED'),
  @JsonValue('ADDRESS_FORMAT_ETHEREUM')
  addressFormatEthereum('ADDRESS_FORMAT_ETHEREUM'),
  @JsonValue('ADDRESS_FORMAT_SOLANA')
  addressFormatSolana('ADDRESS_FORMAT_SOLANA'),
  @JsonValue('ADDRESS_FORMAT_COSMOS')
  addressFormatCosmos('ADDRESS_FORMAT_COSMOS'),
  @JsonValue('ADDRESS_FORMAT_TRON')
  addressFormatTron('ADDRESS_FORMAT_TRON'),
  @JsonValue('ADDRESS_FORMAT_SUI')
  addressFormatSui('ADDRESS_FORMAT_SUI'),
  @JsonValue('ADDRESS_FORMAT_APTOS')
  addressFormatAptos('ADDRESS_FORMAT_APTOS'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_MAINNET_P2PKH')
  addressFormatBitcoinMainnetP2pkh('ADDRESS_FORMAT_BITCOIN_MAINNET_P2PKH'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_MAINNET_P2SH')
  addressFormatBitcoinMainnetP2sh('ADDRESS_FORMAT_BITCOIN_MAINNET_P2SH'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_MAINNET_P2WPKH')
  addressFormatBitcoinMainnetP2wpkh('ADDRESS_FORMAT_BITCOIN_MAINNET_P2WPKH'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_MAINNET_P2WSH')
  addressFormatBitcoinMainnetP2wsh('ADDRESS_FORMAT_BITCOIN_MAINNET_P2WSH'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_MAINNET_P2TR')
  addressFormatBitcoinMainnetP2tr('ADDRESS_FORMAT_BITCOIN_MAINNET_P2TR'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_TESTNET_P2PKH')
  addressFormatBitcoinTestnetP2pkh('ADDRESS_FORMAT_BITCOIN_TESTNET_P2PKH'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_TESTNET_P2SH')
  addressFormatBitcoinTestnetP2sh('ADDRESS_FORMAT_BITCOIN_TESTNET_P2SH'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_TESTNET_P2WPKH')
  addressFormatBitcoinTestnetP2wpkh('ADDRESS_FORMAT_BITCOIN_TESTNET_P2WPKH'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_TESTNET_P2WSH')
  addressFormatBitcoinTestnetP2wsh('ADDRESS_FORMAT_BITCOIN_TESTNET_P2WSH'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_TESTNET_P2TR')
  addressFormatBitcoinTestnetP2tr('ADDRESS_FORMAT_BITCOIN_TESTNET_P2TR'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_SIGNET_P2PKH')
  addressFormatBitcoinSignetP2pkh('ADDRESS_FORMAT_BITCOIN_SIGNET_P2PKH'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_SIGNET_P2SH')
  addressFormatBitcoinSignetP2sh('ADDRESS_FORMAT_BITCOIN_SIGNET_P2SH'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_SIGNET_P2WPKH')
  addressFormatBitcoinSignetP2wpkh('ADDRESS_FORMAT_BITCOIN_SIGNET_P2WPKH'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_SIGNET_P2WSH')
  addressFormatBitcoinSignetP2wsh('ADDRESS_FORMAT_BITCOIN_SIGNET_P2WSH'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_SIGNET_P2TR')
  addressFormatBitcoinSignetP2tr('ADDRESS_FORMAT_BITCOIN_SIGNET_P2TR'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_REGTEST_P2PKH')
  addressFormatBitcoinRegtestP2pkh('ADDRESS_FORMAT_BITCOIN_REGTEST_P2PKH'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_REGTEST_P2SH')
  addressFormatBitcoinRegtestP2sh('ADDRESS_FORMAT_BITCOIN_REGTEST_P2SH'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_REGTEST_P2WPKH')
  addressFormatBitcoinRegtestP2wpkh('ADDRESS_FORMAT_BITCOIN_REGTEST_P2WPKH'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_REGTEST_P2WSH')
  addressFormatBitcoinRegtestP2wsh('ADDRESS_FORMAT_BITCOIN_REGTEST_P2WSH'),
  @JsonValue('ADDRESS_FORMAT_BITCOIN_REGTEST_P2TR')
  addressFormatBitcoinRegtestP2tr('ADDRESS_FORMAT_BITCOIN_REGTEST_P2TR'),
  @JsonValue('ADDRESS_FORMAT_SEI')
  addressFormatSei('ADDRESS_FORMAT_SEI'),
  @JsonValue('ADDRESS_FORMAT_XLM')
  addressFormatXlm('ADDRESS_FORMAT_XLM'),
  @JsonValue('ADDRESS_FORMAT_DOGE_MAINNET')
  addressFormatDogeMainnet('ADDRESS_FORMAT_DOGE_MAINNET'),
  @JsonValue('ADDRESS_FORMAT_DOGE_TESTNET')
  addressFormatDogeTestnet('ADDRESS_FORMAT_DOGE_TESTNET'),
  @JsonValue('ADDRESS_FORMAT_TON_V3R2')
  addressFormatTonV3r2('ADDRESS_FORMAT_TON_V3R2'),
  @JsonValue('ADDRESS_FORMAT_TON_V4R2')
  addressFormatTonV4r2('ADDRESS_FORMAT_TON_V4R2'),
  @JsonValue('ADDRESS_FORMAT_XRP')
  addressFormatXrp('ADDRESS_FORMAT_XRP');

  final String? value;

  const V1AddressFormat(this.value);
}

enum V1ApiKeyCurve {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('API_KEY_CURVE_P256')
  apiKeyCurveP256('API_KEY_CURVE_P256'),
  @JsonValue('API_KEY_CURVE_SECP256K1')
  apiKeyCurveSecp256k1('API_KEY_CURVE_SECP256K1'),
  @JsonValue('API_KEY_CURVE_ED25519')
  apiKeyCurveEd25519('API_KEY_CURVE_ED25519');

  final String? value;

  const V1ApiKeyCurve(this.value);
}

enum V1ApproveActivityRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_APPROVE_ACTIVITY')
  activityTypeApproveActivity('ACTIVITY_TYPE_APPROVE_ACTIVITY');

  final String? value;

  const V1ApproveActivityRequestType(this.value);
}

enum V1AuthenticatorAttestationResponseAuthenticatorAttachment {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('cross-platform')
  crossPlatform('cross-platform'),
  @JsonValue('platform')
  platform('platform');

  final String? value;

  const V1AuthenticatorAttestationResponseAuthenticatorAttachment(this.value);
}

enum V1AuthenticatorTransport {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('AUTHENTICATOR_TRANSPORT_BLE')
  authenticatorTransportBle('AUTHENTICATOR_TRANSPORT_BLE'),
  @JsonValue('AUTHENTICATOR_TRANSPORT_INTERNAL')
  authenticatorTransportInternal('AUTHENTICATOR_TRANSPORT_INTERNAL'),
  @JsonValue('AUTHENTICATOR_TRANSPORT_NFC')
  authenticatorTransportNfc('AUTHENTICATOR_TRANSPORT_NFC'),
  @JsonValue('AUTHENTICATOR_TRANSPORT_USB')
  authenticatorTransportUsb('AUTHENTICATOR_TRANSPORT_USB'),
  @JsonValue('AUTHENTICATOR_TRANSPORT_HYBRID')
  authenticatorTransportHybrid('AUTHENTICATOR_TRANSPORT_HYBRID');

  final String? value;

  const V1AuthenticatorTransport(this.value);
}

enum V1CreateApiKeysRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_API_KEYS_V2')
  activityTypeCreateApiKeysV2('ACTIVITY_TYPE_CREATE_API_KEYS_V2');

  final String? value;

  const V1CreateApiKeysRequestType(this.value);
}

enum V1CreateApiOnlyUsersRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_API_ONLY_USERS')
  activityTypeCreateApiOnlyUsers('ACTIVITY_TYPE_CREATE_API_ONLY_USERS');

  final String? value;

  const V1CreateApiOnlyUsersRequestType(this.value);
}

enum V1CreateAuthenticatorsRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_AUTHENTICATORS_V2')
  activityTypeCreateAuthenticatorsV2('ACTIVITY_TYPE_CREATE_AUTHENTICATORS_V2');

  final String? value;

  const V1CreateAuthenticatorsRequestType(this.value);
}

enum V1CreateInvitationsRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_INVITATIONS')
  activityTypeCreateInvitations('ACTIVITY_TYPE_CREATE_INVITATIONS');

  final String? value;

  const V1CreateInvitationsRequestType(this.value);
}

enum V1CreateOauthProvidersRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_OAUTH_PROVIDERS')
  activityTypeCreateOauthProviders('ACTIVITY_TYPE_CREATE_OAUTH_PROVIDERS');

  final String? value;

  const V1CreateOauthProvidersRequestType(this.value);
}

enum V1CreatePoliciesRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_POLICIES')
  activityTypeCreatePolicies('ACTIVITY_TYPE_CREATE_POLICIES');

  final String? value;

  const V1CreatePoliciesRequestType(this.value);
}

enum V1CreatePolicyRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_POLICY_V3')
  activityTypeCreatePolicyV3('ACTIVITY_TYPE_CREATE_POLICY_V3');

  final String? value;

  const V1CreatePolicyRequestType(this.value);
}

enum V1CreatePrivateKeyTagRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_PRIVATE_KEY_TAG')
  activityTypeCreatePrivateKeyTag('ACTIVITY_TYPE_CREATE_PRIVATE_KEY_TAG');

  final String? value;

  const V1CreatePrivateKeyTagRequestType(this.value);
}

enum V1CreatePrivateKeysRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_PRIVATE_KEYS_V2')
  activityTypeCreatePrivateKeysV2('ACTIVITY_TYPE_CREATE_PRIVATE_KEYS_V2');

  final String? value;

  const V1CreatePrivateKeysRequestType(this.value);
}

enum V1CreateReadOnlySessionRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_READ_ONLY_SESSION')
  activityTypeCreateReadOnlySession('ACTIVITY_TYPE_CREATE_READ_ONLY_SESSION');

  final String? value;

  const V1CreateReadOnlySessionRequestType(this.value);
}

enum V1CreateReadWriteSessionRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_READ_WRITE_SESSION_V2')
  activityTypeCreateReadWriteSessionV2(
      'ACTIVITY_TYPE_CREATE_READ_WRITE_SESSION_V2');

  final String? value;

  const V1CreateReadWriteSessionRequestType(this.value);
}

enum V1CreateSubOrganizationRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V7')
  activityTypeCreateSubOrganizationV7(
      'ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V7');

  final String? value;

  const V1CreateSubOrganizationRequestType(this.value);
}

enum V1CreateUserTagRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_USER_TAG')
  activityTypeCreateUserTag('ACTIVITY_TYPE_CREATE_USER_TAG');

  final String? value;

  const V1CreateUserTagRequestType(this.value);
}

enum V1CreateUsersRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_USERS_V2')
  activityTypeCreateUsersV2('ACTIVITY_TYPE_CREATE_USERS_V2');

  final String? value;

  const V1CreateUsersRequestType(this.value);
}

enum V1CreateWalletAccountsRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_WALLET_ACCOUNTS')
  activityTypeCreateWalletAccounts('ACTIVITY_TYPE_CREATE_WALLET_ACCOUNTS');

  final String? value;

  const V1CreateWalletAccountsRequestType(this.value);
}

enum V1CreateWalletRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_WALLET')
  activityTypeCreateWallet('ACTIVITY_TYPE_CREATE_WALLET');

  final String? value;

  const V1CreateWalletRequestType(this.value);
}

enum V1CredentialType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('CREDENTIAL_TYPE_WEBAUTHN_AUTHENTICATOR')
  credentialTypeWebauthnAuthenticator('CREDENTIAL_TYPE_WEBAUTHN_AUTHENTICATOR'),
  @JsonValue('CREDENTIAL_TYPE_API_KEY_P256')
  credentialTypeApiKeyP256('CREDENTIAL_TYPE_API_KEY_P256'),
  @JsonValue('CREDENTIAL_TYPE_RECOVER_USER_KEY_P256')
  credentialTypeRecoverUserKeyP256('CREDENTIAL_TYPE_RECOVER_USER_KEY_P256'),
  @JsonValue('CREDENTIAL_TYPE_API_KEY_SECP256K1')
  credentialTypeApiKeySecp256k1('CREDENTIAL_TYPE_API_KEY_SECP256K1'),
  @JsonValue('CREDENTIAL_TYPE_EMAIL_AUTH_KEY_P256')
  credentialTypeEmailAuthKeyP256('CREDENTIAL_TYPE_EMAIL_AUTH_KEY_P256'),
  @JsonValue('CREDENTIAL_TYPE_API_KEY_ED25519')
  credentialTypeApiKeyEd25519('CREDENTIAL_TYPE_API_KEY_ED25519'),
  @JsonValue('CREDENTIAL_TYPE_OTP_AUTH_KEY_P256')
  credentialTypeOtpAuthKeyP256('CREDENTIAL_TYPE_OTP_AUTH_KEY_P256');

  final String? value;

  const V1CredentialType(this.value);
}

enum V1Curve {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('CURVE_SECP256K1')
  curveSecp256k1('CURVE_SECP256K1'),
  @JsonValue('CURVE_ED25519')
  curveEd25519('CURVE_ED25519');

  final String? value;

  const V1Curve(this.value);
}

enum V1DeleteApiKeysRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_API_KEYS')
  activityTypeDeleteApiKeys('ACTIVITY_TYPE_DELETE_API_KEYS');

  final String? value;

  const V1DeleteApiKeysRequestType(this.value);
}

enum V1DeleteAuthenticatorsRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_AUTHENTICATORS')
  activityTypeDeleteAuthenticators('ACTIVITY_TYPE_DELETE_AUTHENTICATORS');

  final String? value;

  const V1DeleteAuthenticatorsRequestType(this.value);
}

enum V1DeleteInvitationRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_INVITATION')
  activityTypeDeleteInvitation('ACTIVITY_TYPE_DELETE_INVITATION');

  final String? value;

  const V1DeleteInvitationRequestType(this.value);
}

enum V1DeleteOauthProvidersRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_OAUTH_PROVIDERS')
  activityTypeDeleteOauthProviders('ACTIVITY_TYPE_DELETE_OAUTH_PROVIDERS');

  final String? value;

  const V1DeleteOauthProvidersRequestType(this.value);
}

enum V1DeletePolicyRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_POLICY')
  activityTypeDeletePolicy('ACTIVITY_TYPE_DELETE_POLICY');

  final String? value;

  const V1DeletePolicyRequestType(this.value);
}

enum V1DeletePrivateKeyTagsRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_PRIVATE_KEY_TAGS')
  activityTypeDeletePrivateKeyTags('ACTIVITY_TYPE_DELETE_PRIVATE_KEY_TAGS');

  final String? value;

  const V1DeletePrivateKeyTagsRequestType(this.value);
}

enum V1DeletePrivateKeysRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_PRIVATE_KEYS')
  activityTypeDeletePrivateKeys('ACTIVITY_TYPE_DELETE_PRIVATE_KEYS');

  final String? value;

  const V1DeletePrivateKeysRequestType(this.value);
}

enum V1DeleteSubOrganizationRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_SUB_ORGANIZATION')
  activityTypeDeleteSubOrganization('ACTIVITY_TYPE_DELETE_SUB_ORGANIZATION');

  final String? value;

  const V1DeleteSubOrganizationRequestType(this.value);
}

enum V1DeleteUserTagsRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_USER_TAGS')
  activityTypeDeleteUserTags('ACTIVITY_TYPE_DELETE_USER_TAGS');

  final String? value;

  const V1DeleteUserTagsRequestType(this.value);
}

enum V1DeleteUsersRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_USERS')
  activityTypeDeleteUsers('ACTIVITY_TYPE_DELETE_USERS');

  final String? value;

  const V1DeleteUsersRequestType(this.value);
}

enum V1DeleteWalletsRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_WALLETS')
  activityTypeDeleteWallets('ACTIVITY_TYPE_DELETE_WALLETS');

  final String? value;

  const V1DeleteWalletsRequestType(this.value);
}

enum V1Effect {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('EFFECT_ALLOW')
  effectAllow('EFFECT_ALLOW'),
  @JsonValue('EFFECT_DENY')
  effectDeny('EFFECT_DENY');

  final String? value;

  const V1Effect(this.value);
}

enum V1EmailAuthRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_EMAIL_AUTH_V2')
  activityTypeEmailAuthV2('ACTIVITY_TYPE_EMAIL_AUTH_V2');

  final String? value;

  const V1EmailAuthRequestType(this.value);
}

enum V1ExportPrivateKeyRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_EXPORT_PRIVATE_KEY')
  activityTypeExportPrivateKey('ACTIVITY_TYPE_EXPORT_PRIVATE_KEY');

  final String? value;

  const V1ExportPrivateKeyRequestType(this.value);
}

enum V1ExportWalletAccountRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_EXPORT_WALLET_ACCOUNT')
  activityTypeExportWalletAccount('ACTIVITY_TYPE_EXPORT_WALLET_ACCOUNT');

  final String? value;

  const V1ExportWalletAccountRequestType(this.value);
}

enum V1ExportWalletRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_EXPORT_WALLET')
  activityTypeExportWallet('ACTIVITY_TYPE_EXPORT_WALLET');

  final String? value;

  const V1ExportWalletRequestType(this.value);
}

enum V1FeatureName {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('FEATURE_NAME_ROOT_USER_EMAIL_RECOVERY')
  featureNameRootUserEmailRecovery('FEATURE_NAME_ROOT_USER_EMAIL_RECOVERY'),
  @JsonValue('FEATURE_NAME_WEBAUTHN_ORIGINS')
  featureNameWebauthnOrigins('FEATURE_NAME_WEBAUTHN_ORIGINS'),
  @JsonValue('FEATURE_NAME_EMAIL_AUTH')
  featureNameEmailAuth('FEATURE_NAME_EMAIL_AUTH'),
  @JsonValue('FEATURE_NAME_EMAIL_RECOVERY')
  featureNameEmailRecovery('FEATURE_NAME_EMAIL_RECOVERY'),
  @JsonValue('FEATURE_NAME_WEBHOOK')
  featureNameWebhook('FEATURE_NAME_WEBHOOK'),
  @JsonValue('FEATURE_NAME_SMS_AUTH')
  featureNameSmsAuth('FEATURE_NAME_SMS_AUTH'),
  @JsonValue('FEATURE_NAME_OTP_EMAIL_AUTH')
  featureNameOtpEmailAuth('FEATURE_NAME_OTP_EMAIL_AUTH');

  final String? value;

  const V1FeatureName(this.value);
}

enum V1HashFunction {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('HASH_FUNCTION_NO_OP')
  hashFunctionNoOp('HASH_FUNCTION_NO_OP'),
  @JsonValue('HASH_FUNCTION_SHA256')
  hashFunctionSha256('HASH_FUNCTION_SHA256'),
  @JsonValue('HASH_FUNCTION_KECCAK256')
  hashFunctionKeccak256('HASH_FUNCTION_KECCAK256'),
  @JsonValue('HASH_FUNCTION_NOT_APPLICABLE')
  hashFunctionNotApplicable('HASH_FUNCTION_NOT_APPLICABLE');

  final String? value;

  const V1HashFunction(this.value);
}

enum V1ImportPrivateKeyRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_IMPORT_PRIVATE_KEY')
  activityTypeImportPrivateKey('ACTIVITY_TYPE_IMPORT_PRIVATE_KEY');

  final String? value;

  const V1ImportPrivateKeyRequestType(this.value);
}

enum V1ImportWalletRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_IMPORT_WALLET')
  activityTypeImportWallet('ACTIVITY_TYPE_IMPORT_WALLET');

  final String? value;

  const V1ImportWalletRequestType(this.value);
}

enum V1InitImportPrivateKeyRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_INIT_IMPORT_PRIVATE_KEY')
  activityTypeInitImportPrivateKey('ACTIVITY_TYPE_INIT_IMPORT_PRIVATE_KEY');

  final String? value;

  const V1InitImportPrivateKeyRequestType(this.value);
}

enum V1InitImportWalletRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_INIT_IMPORT_WALLET')
  activityTypeInitImportWallet('ACTIVITY_TYPE_INIT_IMPORT_WALLET');

  final String? value;

  const V1InitImportWalletRequestType(this.value);
}

enum V1InitOtpAuthRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_INIT_OTP_AUTH')
  activityTypeInitOtpAuth('ACTIVITY_TYPE_INIT_OTP_AUTH');

  final String? value;

  const V1InitOtpAuthRequestType(this.value);
}

enum V1InitUserEmailRecoveryRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_INIT_USER_EMAIL_RECOVERY')
  activityTypeInitUserEmailRecovery('ACTIVITY_TYPE_INIT_USER_EMAIL_RECOVERY');

  final String? value;

  const V1InitUserEmailRecoveryRequestType(this.value);
}

enum V1InvitationStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('INVITATION_STATUS_CREATED')
  invitationStatusCreated('INVITATION_STATUS_CREATED'),
  @JsonValue('INVITATION_STATUS_ACCEPTED')
  invitationStatusAccepted('INVITATION_STATUS_ACCEPTED'),
  @JsonValue('INVITATION_STATUS_REVOKED')
  invitationStatusRevoked('INVITATION_STATUS_REVOKED');

  final String? value;

  const V1InvitationStatus(this.value);
}

enum V1MnemonicLanguage {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('MNEMONIC_LANGUAGE_ENGLISH')
  mnemonicLanguageEnglish('MNEMONIC_LANGUAGE_ENGLISH'),
  @JsonValue('MNEMONIC_LANGUAGE_SIMPLIFIED_CHINESE')
  mnemonicLanguageSimplifiedChinese('MNEMONIC_LANGUAGE_SIMPLIFIED_CHINESE'),
  @JsonValue('MNEMONIC_LANGUAGE_TRADITIONAL_CHINESE')
  mnemonicLanguageTraditionalChinese('MNEMONIC_LANGUAGE_TRADITIONAL_CHINESE'),
  @JsonValue('MNEMONIC_LANGUAGE_CZECH')
  mnemonicLanguageCzech('MNEMONIC_LANGUAGE_CZECH'),
  @JsonValue('MNEMONIC_LANGUAGE_FRENCH')
  mnemonicLanguageFrench('MNEMONIC_LANGUAGE_FRENCH'),
  @JsonValue('MNEMONIC_LANGUAGE_ITALIAN')
  mnemonicLanguageItalian('MNEMONIC_LANGUAGE_ITALIAN'),
  @JsonValue('MNEMONIC_LANGUAGE_JAPANESE')
  mnemonicLanguageJapanese('MNEMONIC_LANGUAGE_JAPANESE'),
  @JsonValue('MNEMONIC_LANGUAGE_KOREAN')
  mnemonicLanguageKorean('MNEMONIC_LANGUAGE_KOREAN'),
  @JsonValue('MNEMONIC_LANGUAGE_SPANISH')
  mnemonicLanguageSpanish('MNEMONIC_LANGUAGE_SPANISH');

  final String? value;

  const V1MnemonicLanguage(this.value);
}

enum V1OauthRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_OAUTH')
  activityTypeOauth('ACTIVITY_TYPE_OAUTH');

  final String? value;

  const V1OauthRequestType(this.value);
}

enum V1Operator {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('OPERATOR_EQUAL')
  operatorEqual('OPERATOR_EQUAL'),
  @JsonValue('OPERATOR_MORE_THAN')
  operatorMoreThan('OPERATOR_MORE_THAN'),
  @JsonValue('OPERATOR_MORE_THAN_OR_EQUAL')
  operatorMoreThanOrEqual('OPERATOR_MORE_THAN_OR_EQUAL'),
  @JsonValue('OPERATOR_LESS_THAN')
  operatorLessThan('OPERATOR_LESS_THAN'),
  @JsonValue('OPERATOR_LESS_THAN_OR_EQUAL')
  operatorLessThanOrEqual('OPERATOR_LESS_THAN_OR_EQUAL'),
  @JsonValue('OPERATOR_CONTAINS')
  operatorContains('OPERATOR_CONTAINS'),
  @JsonValue('OPERATOR_NOT_EQUAL')
  operatorNotEqual('OPERATOR_NOT_EQUAL'),
  @JsonValue('OPERATOR_IN')
  operatorIn('OPERATOR_IN'),
  @JsonValue('OPERATOR_NOT_IN')
  operatorNotIn('OPERATOR_NOT_IN'),
  @JsonValue('OPERATOR_CONTAINS_ONE')
  operatorContainsOne('OPERATOR_CONTAINS_ONE'),
  @JsonValue('OPERATOR_CONTAINS_ALL')
  operatorContainsAll('OPERATOR_CONTAINS_ALL');

  final String? value;

  const V1Operator(this.value);
}

enum V1OtpAuthRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_OTP_AUTH')
  activityTypeOtpAuth('ACTIVITY_TYPE_OTP_AUTH');

  final String? value;

  const V1OtpAuthRequestType(this.value);
}

enum V1PathFormat {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('PATH_FORMAT_BIP32')
  pathFormatBip32('PATH_FORMAT_BIP32');

  final String? value;

  const V1PathFormat(this.value);
}

enum V1PayloadEncoding {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('PAYLOAD_ENCODING_HEXADECIMAL')
  payloadEncodingHexadecimal('PAYLOAD_ENCODING_HEXADECIMAL'),
  @JsonValue('PAYLOAD_ENCODING_TEXT_UTF8')
  payloadEncodingTextUtf8('PAYLOAD_ENCODING_TEXT_UTF8');

  final String? value;

  const V1PayloadEncoding(this.value);
}

enum V1PublicKeyCredentialWithAttestationType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('public-key')
  publicKey('public-key');

  final String? value;

  const V1PublicKeyCredentialWithAttestationType(this.value);
}

enum V1PublicKeyCredentialWithAttestationAuthenticatorAttachment {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('cross-platform')
  crossPlatform('cross-platform'),
  @JsonValue('platform')
  platform('platform');

  final String? value;

  const V1PublicKeyCredentialWithAttestationAuthenticatorAttachment(this.value);
}

enum V1RecoverUserRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_RECOVER_USER')
  activityTypeRecoverUser('ACTIVITY_TYPE_RECOVER_USER');

  final String? value;

  const V1RecoverUserRequestType(this.value);
}

enum V1RejectActivityRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_REJECT_ACTIVITY')
  activityTypeRejectActivity('ACTIVITY_TYPE_REJECT_ACTIVITY');

  final String? value;

  const V1RejectActivityRequestType(this.value);
}

enum V1RemoveOrganizationFeatureRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_REMOVE_ORGANIZATION_FEATURE')
  activityTypeRemoveOrganizationFeature(
      'ACTIVITY_TYPE_REMOVE_ORGANIZATION_FEATURE');

  final String? value;

  const V1RemoveOrganizationFeatureRequestType(this.value);
}

enum V1SetOrganizationFeatureRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_SET_ORGANIZATION_FEATURE')
  activityTypeSetOrganizationFeature('ACTIVITY_TYPE_SET_ORGANIZATION_FEATURE');

  final String? value;

  const V1SetOrganizationFeatureRequestType(this.value);
}

enum V1SignRawPayloadRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_SIGN_RAW_PAYLOAD_V2')
  activityTypeSignRawPayloadV2('ACTIVITY_TYPE_SIGN_RAW_PAYLOAD_V2');

  final String? value;

  const V1SignRawPayloadRequestType(this.value);
}

enum V1SignRawPayloadsRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_SIGN_RAW_PAYLOADS')
  activityTypeSignRawPayloads('ACTIVITY_TYPE_SIGN_RAW_PAYLOADS');

  final String? value;

  const V1SignRawPayloadsRequestType(this.value);
}

enum V1SignTransactionRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_SIGN_TRANSACTION_V2')
  activityTypeSignTransactionV2('ACTIVITY_TYPE_SIGN_TRANSACTION_V2');

  final String? value;

  const V1SignTransactionRequestType(this.value);
}

enum V1TagType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('TAG_TYPE_USER')
  tagTypeUser('TAG_TYPE_USER'),
  @JsonValue('TAG_TYPE_PRIVATE_KEY')
  tagTypePrivateKey('TAG_TYPE_PRIVATE_KEY');

  final String? value;

  const V1TagType(this.value);
}

enum V1TransactionType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('TRANSACTION_TYPE_ETHEREUM')
  transactionTypeEthereum('TRANSACTION_TYPE_ETHEREUM'),
  @JsonValue('TRANSACTION_TYPE_SOLANA')
  transactionTypeSolana('TRANSACTION_TYPE_SOLANA');

  final String? value;

  const V1TransactionType(this.value);
}

enum V1UpdatePolicyRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_UPDATE_POLICY')
  activityTypeUpdatePolicy('ACTIVITY_TYPE_UPDATE_POLICY');

  final String? value;

  const V1UpdatePolicyRequestType(this.value);
}

enum V1UpdatePrivateKeyTagRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_UPDATE_PRIVATE_KEY_TAG')
  activityTypeUpdatePrivateKeyTag('ACTIVITY_TYPE_UPDATE_PRIVATE_KEY_TAG');

  final String? value;

  const V1UpdatePrivateKeyTagRequestType(this.value);
}

enum V1UpdateRootQuorumRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_UPDATE_ROOT_QUORUM')
  activityTypeUpdateRootQuorum('ACTIVITY_TYPE_UPDATE_ROOT_QUORUM');

  final String? value;

  const V1UpdateRootQuorumRequestType(this.value);
}

enum V1UpdateUserRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_UPDATE_USER')
  activityTypeUpdateUser('ACTIVITY_TYPE_UPDATE_USER');

  final String? value;

  const V1UpdateUserRequestType(this.value);
}

enum V1UpdateUserTagRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_UPDATE_USER_TAG')
  activityTypeUpdateUserTag('ACTIVITY_TYPE_UPDATE_USER_TAG');

  final String? value;

  const V1UpdateUserTagRequestType(this.value);
}

enum V1VoteSelection {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('VOTE_SELECTION_APPROVED')
  voteSelectionApproved('VOTE_SELECTION_APPROVED'),
  @JsonValue('VOTE_SELECTION_REJECTED')
  voteSelectionRejected('VOTE_SELECTION_REJECTED');

  final String? value;

  const V1VoteSelection(this.value);
}
