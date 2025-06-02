import 'package:json_annotation/json_annotation.dart';

enum AccessType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACCESS_TYPE_WEB')
  accessTypeWeb('ACCESS_TYPE_WEB'),
  @JsonValue('ACCESS_TYPE_API')
  accessTypeApi('ACCESS_TYPE_API'),
  @JsonValue('ACCESS_TYPE_ALL')
  accessTypeAll('ACCESS_TYPE_ALL');

  final String? value;

  const AccessType(this.value);
}

enum ActivityStatus {
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

  const ActivityStatus(this.value);
}

enum ActivityType {
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
      'ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V7'),
  @JsonValue('ACTIVITY_TYPE_UPDATE_WALLET')
  activityTypeUpdateWallet('ACTIVITY_TYPE_UPDATE_WALLET'),
  @JsonValue('ACTIVITY_TYPE_UPDATE_POLICY_V2')
  activityTypeUpdatePolicyV2('ACTIVITY_TYPE_UPDATE_POLICY_V2'),
  @JsonValue('ACTIVITY_TYPE_CREATE_USERS_V3')
  activityTypeCreateUsersV3('ACTIVITY_TYPE_CREATE_USERS_V3'),
  @JsonValue('ACTIVITY_TYPE_INIT_OTP_AUTH_V2')
  activityTypeInitOtpAuthV2('ACTIVITY_TYPE_INIT_OTP_AUTH_V2'),
  @JsonValue('ACTIVITY_TYPE_INIT_OTP')
  activityTypeInitOtp('ACTIVITY_TYPE_INIT_OTP'),
  @JsonValue('ACTIVITY_TYPE_VERIFY_OTP')
  activityTypeVerifyOtp('ACTIVITY_TYPE_VERIFY_OTP'),
  @JsonValue('ACTIVITY_TYPE_OTP_LOGIN')
  activityTypeOtpLogin('ACTIVITY_TYPE_OTP_LOGIN'),
  @JsonValue('ACTIVITY_TYPE_STAMP_LOGIN')
  activityTypeStampLogin('ACTIVITY_TYPE_STAMP_LOGIN'),
  @JsonValue('ACTIVITY_TYPE_OAUTH_LOGIN')
  activityTypeOauthLogin('ACTIVITY_TYPE_OAUTH_LOGIN');

  final String? value;

  const ActivityType(this.value);
}

enum AddressFormat {
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
  @JsonValue('ADDRESS_FORMAT_TON_V5R1')
  addressFormatTonV5r1('ADDRESS_FORMAT_TON_V5R1'),
  @JsonValue('ADDRESS_FORMAT_XRP')
  addressFormatXrp('ADDRESS_FORMAT_XRP');

  final String? value;

  const AddressFormat(this.value);
}

enum ApiKeyCurve {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('API_KEY_CURVE_P256')
  apiKeyCurveP256('API_KEY_CURVE_P256'),
  @JsonValue('API_KEY_CURVE_SECP256K1')
  apiKeyCurveSecp256k1('API_KEY_CURVE_SECP256K1'),
  @JsonValue('API_KEY_CURVE_ED25519')
  apiKeyCurveEd25519('API_KEY_CURVE_ED25519');

  final String? value;

  const ApiKeyCurve(this.value);
}

enum ApproveActivityRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_APPROVE_ACTIVITY')
  activityTypeApproveActivity('ACTIVITY_TYPE_APPROVE_ACTIVITY');

  final String? value;

  const ApproveActivityRequestType(this.value);
}

enum AuthenticatorAttestationResponseAuthenticatorAttachment {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('cross-platform')
  crossPlatform('cross-platform'),
  @JsonValue('platform')
  platform('platform');

  final String? value;

  const AuthenticatorAttestationResponseAuthenticatorAttachment(this.value);
}

enum AuthenticatorTransport {
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

  const AuthenticatorTransport(this.value);
}

enum CreateApiKeysRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_API_KEYS_V2')
  activityTypeCreateApiKeysV2('ACTIVITY_TYPE_CREATE_API_KEYS_V2');

  final String? value;

  const CreateApiKeysRequestType(this.value);
}

enum CreateAuthenticatorsRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_AUTHENTICATORS_V2')
  activityTypeCreateAuthenticatorsV2('ACTIVITY_TYPE_CREATE_AUTHENTICATORS_V2');

  final String? value;

  const CreateAuthenticatorsRequestType(this.value);
}

enum CreateInvitationsRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_INVITATIONS')
  activityTypeCreateInvitations('ACTIVITY_TYPE_CREATE_INVITATIONS');

  final String? value;

  const CreateInvitationsRequestType(this.value);
}

enum CreateOauthProvidersRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_OAUTH_PROVIDERS')
  activityTypeCreateOauthProviders('ACTIVITY_TYPE_CREATE_OAUTH_PROVIDERS');

  final String? value;

  const CreateOauthProvidersRequestType(this.value);
}

enum CreatePoliciesRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_POLICIES')
  activityTypeCreatePolicies('ACTIVITY_TYPE_CREATE_POLICIES');

  final String? value;

  const CreatePoliciesRequestType(this.value);
}

enum CreatePolicyRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_POLICY_V3')
  activityTypeCreatePolicyV3('ACTIVITY_TYPE_CREATE_POLICY_V3');

  final String? value;

  const CreatePolicyRequestType(this.value);
}

enum CreatePrivateKeyTagRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_PRIVATE_KEY_TAG')
  activityTypeCreatePrivateKeyTag('ACTIVITY_TYPE_CREATE_PRIVATE_KEY_TAG');

  final String? value;

  const CreatePrivateKeyTagRequestType(this.value);
}

enum CreatePrivateKeysRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_PRIVATE_KEYS_V2')
  activityTypeCreatePrivateKeysV2('ACTIVITY_TYPE_CREATE_PRIVATE_KEYS_V2');

  final String? value;

  const CreatePrivateKeysRequestType(this.value);
}

enum CreateReadOnlySessionRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_READ_ONLY_SESSION')
  activityTypeCreateReadOnlySession('ACTIVITY_TYPE_CREATE_READ_ONLY_SESSION');

  final String? value;

  const CreateReadOnlySessionRequestType(this.value);
}

enum CreateReadWriteSessionRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_READ_WRITE_SESSION_V2')
  activityTypeCreateReadWriteSessionV2(
      'ACTIVITY_TYPE_CREATE_READ_WRITE_SESSION_V2');

  final String? value;

  const CreateReadWriteSessionRequestType(this.value);
}

enum CreateSubOrganizationRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V7')
  activityTypeCreateSubOrganizationV7(
      'ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V7');

  final String? value;

  const CreateSubOrganizationRequestType(this.value);
}

enum CreateUserTagRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_USER_TAG')
  activityTypeCreateUserTag('ACTIVITY_TYPE_CREATE_USER_TAG');

  final String? value;

  const CreateUserTagRequestType(this.value);
}

enum CreateUsersRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_USERS_V3')
  activityTypeCreateUsersV3('ACTIVITY_TYPE_CREATE_USERS_V3');

  final String? value;

  const CreateUsersRequestType(this.value);
}

enum CreateWalletAccountsRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_WALLET_ACCOUNTS')
  activityTypeCreateWalletAccounts('ACTIVITY_TYPE_CREATE_WALLET_ACCOUNTS');

  final String? value;

  const CreateWalletAccountsRequestType(this.value);
}

enum CreateWalletRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_CREATE_WALLET')
  activityTypeCreateWallet('ACTIVITY_TYPE_CREATE_WALLET');

  final String? value;

  const CreateWalletRequestType(this.value);
}

enum CredentialType {
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
  credentialTypeOtpAuthKeyP256('CREDENTIAL_TYPE_OTP_AUTH_KEY_P256'),
  @JsonValue('CREDENTIAL_TYPE_READ_WRITE_SESSION_KEY_P256')
  credentialTypeReadWriteSessionKeyP256(
      'CREDENTIAL_TYPE_READ_WRITE_SESSION_KEY_P256'),
  @JsonValue('CREDENTIAL_TYPE_OAUTH_KEY_P256')
  credentialTypeOauthKeyP256('CREDENTIAL_TYPE_OAUTH_KEY_P256'),
  @JsonValue('CREDENTIAL_TYPE_LOGIN')
  credentialTypeLogin('CREDENTIAL_TYPE_LOGIN');

  final String? value;

  const CredentialType(this.value);
}

enum Curve {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('CURVE_SECP256K1')
  curveSecp256k1('CURVE_SECP256K1'),
  @JsonValue('CURVE_ED25519')
  curveEd25519('CURVE_ED25519');

  final String? value;

  const Curve(this.value);
}

enum DeleteApiKeysRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_API_KEYS')
  activityTypeDeleteApiKeys('ACTIVITY_TYPE_DELETE_API_KEYS');

  final String? value;

  const DeleteApiKeysRequestType(this.value);
}

enum DeleteAuthenticatorsRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_AUTHENTICATORS')
  activityTypeDeleteAuthenticators('ACTIVITY_TYPE_DELETE_AUTHENTICATORS');

  final String? value;

  const DeleteAuthenticatorsRequestType(this.value);
}

enum DeleteInvitationRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_INVITATION')
  activityTypeDeleteInvitation('ACTIVITY_TYPE_DELETE_INVITATION');

  final String? value;

  const DeleteInvitationRequestType(this.value);
}

enum DeleteOauthProvidersRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_OAUTH_PROVIDERS')
  activityTypeDeleteOauthProviders('ACTIVITY_TYPE_DELETE_OAUTH_PROVIDERS');

  final String? value;

  const DeleteOauthProvidersRequestType(this.value);
}

enum DeletePolicyRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_POLICY')
  activityTypeDeletePolicy('ACTIVITY_TYPE_DELETE_POLICY');

  final String? value;

  const DeletePolicyRequestType(this.value);
}

enum DeletePrivateKeyTagsRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_PRIVATE_KEY_TAGS')
  activityTypeDeletePrivateKeyTags('ACTIVITY_TYPE_DELETE_PRIVATE_KEY_TAGS');

  final String? value;

  const DeletePrivateKeyTagsRequestType(this.value);
}

enum DeletePrivateKeysRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_PRIVATE_KEYS')
  activityTypeDeletePrivateKeys('ACTIVITY_TYPE_DELETE_PRIVATE_KEYS');

  final String? value;

  const DeletePrivateKeysRequestType(this.value);
}

enum DeleteSubOrganizationRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_SUB_ORGANIZATION')
  activityTypeDeleteSubOrganization('ACTIVITY_TYPE_DELETE_SUB_ORGANIZATION');

  final String? value;

  const DeleteSubOrganizationRequestType(this.value);
}

enum DeleteUserTagsRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_USER_TAGS')
  activityTypeDeleteUserTags('ACTIVITY_TYPE_DELETE_USER_TAGS');

  final String? value;

  const DeleteUserTagsRequestType(this.value);
}

enum DeleteUsersRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_USERS')
  activityTypeDeleteUsers('ACTIVITY_TYPE_DELETE_USERS');

  final String? value;

  const DeleteUsersRequestType(this.value);
}

enum DeleteWalletsRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_DELETE_WALLETS')
  activityTypeDeleteWallets('ACTIVITY_TYPE_DELETE_WALLETS');

  final String? value;

  const DeleteWalletsRequestType(this.value);
}

enum Effect {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('EFFECT_ALLOW')
  effectAllow('EFFECT_ALLOW'),
  @JsonValue('EFFECT_DENY')
  effectDeny('EFFECT_DENY');

  final String? value;

  const Effect(this.value);
}

enum EmailAuthRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_EMAIL_AUTH_V2')
  activityTypeEmailAuthV2('ACTIVITY_TYPE_EMAIL_AUTH_V2');

  final String? value;

  const EmailAuthRequestType(this.value);
}

enum ExportPrivateKeyRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_EXPORT_PRIVATE_KEY')
  activityTypeExportPrivateKey('ACTIVITY_TYPE_EXPORT_PRIVATE_KEY');

  final String? value;

  const ExportPrivateKeyRequestType(this.value);
}

enum ExportWalletAccountRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_EXPORT_WALLET_ACCOUNT')
  activityTypeExportWalletAccount('ACTIVITY_TYPE_EXPORT_WALLET_ACCOUNT');

  final String? value;

  const ExportWalletAccountRequestType(this.value);
}

enum ExportWalletRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_EXPORT_WALLET')
  activityTypeExportWallet('ACTIVITY_TYPE_EXPORT_WALLET');

  final String? value;

  const ExportWalletRequestType(this.value);
}

enum FeatureName {
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

  const FeatureName(this.value);
}

enum HashFunction {
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

  const HashFunction(this.value);
}

enum ImportPrivateKeyRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_IMPORT_PRIVATE_KEY')
  activityTypeImportPrivateKey('ACTIVITY_TYPE_IMPORT_PRIVATE_KEY');

  final String? value;

  const ImportPrivateKeyRequestType(this.value);
}

enum ImportWalletRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_IMPORT_WALLET')
  activityTypeImportWallet('ACTIVITY_TYPE_IMPORT_WALLET');

  final String? value;

  const ImportWalletRequestType(this.value);
}

enum InitImportPrivateKeyRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_INIT_IMPORT_PRIVATE_KEY')
  activityTypeInitImportPrivateKey('ACTIVITY_TYPE_INIT_IMPORT_PRIVATE_KEY');

  final String? value;

  const InitImportPrivateKeyRequestType(this.value);
}

enum InitImportWalletRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_INIT_IMPORT_WALLET')
  activityTypeInitImportWallet('ACTIVITY_TYPE_INIT_IMPORT_WALLET');

  final String? value;

  const InitImportWalletRequestType(this.value);
}

enum InitOtpAuthRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_INIT_OTP_AUTH_V2')
  activityTypeInitOtpAuthV2('ACTIVITY_TYPE_INIT_OTP_AUTH_V2');

  final String? value;

  const InitOtpAuthRequestType(this.value);
}

enum InitOtpRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_INIT_OTP')
  activityTypeInitOtp('ACTIVITY_TYPE_INIT_OTP');

  final String? value;

  const InitOtpRequestType(this.value);
}

enum InitUserEmailRecoveryRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_INIT_USER_EMAIL_RECOVERY')
  activityTypeInitUserEmailRecovery('ACTIVITY_TYPE_INIT_USER_EMAIL_RECOVERY');

  final String? value;

  const InitUserEmailRecoveryRequestType(this.value);
}

enum MnemonicLanguage {
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

  const MnemonicLanguage(this.value);
}

enum OauthLoginRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_OAUTH_LOGIN')
  activityTypeOauthLogin('ACTIVITY_TYPE_OAUTH_LOGIN');

  final String? value;

  const OauthLoginRequestType(this.value);
}

enum OauthRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_OAUTH')
  activityTypeOauth('ACTIVITY_TYPE_OAUTH');

  final String? value;

  const OauthRequestType(this.value);
}

enum Operator {
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

  const Operator(this.value);
}

enum OtpAuthRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_OTP_AUTH')
  activityTypeOtpAuth('ACTIVITY_TYPE_OTP_AUTH');

  final String? value;

  const OtpAuthRequestType(this.value);
}

enum OtpLoginRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_OTP_LOGIN')
  activityTypeOtpLogin('ACTIVITY_TYPE_OTP_LOGIN');

  final String? value;

  const OtpLoginRequestType(this.value);
}

enum PathFormat {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('PATH_FORMAT_BIP32')
  pathFormatBip32('PATH_FORMAT_BIP32');

  final String? value;

  const PathFormat(this.value);
}

enum PayloadEncoding {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('PAYLOAD_ENCODING_HEXADECIMAL')
  payloadEncodingHexadecimal('PAYLOAD_ENCODING_HEXADECIMAL'),
  @JsonValue('PAYLOAD_ENCODING_TEXT_UTF8')
  payloadEncodingTextUtf8('PAYLOAD_ENCODING_TEXT_UTF8');

  final String? value;

  const PayloadEncoding(this.value);
}

enum PublicKeyCredentialWithAttestationType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('public-key')
  publicKey('public-key');

  final String? value;

  const PublicKeyCredentialWithAttestationType(this.value);
}

enum PublicKeyCredentialWithAttestationAuthenticatorAttachment {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('cross-platform')
  crossPlatform('cross-platform'),
  @JsonValue('platform')
  platform('platform');

  final String? value;

  const PublicKeyCredentialWithAttestationAuthenticatorAttachment(this.value);
}

enum RecoverUserRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_RECOVER_USER')
  activityTypeRecoverUser('ACTIVITY_TYPE_RECOVER_USER');

  final String? value;

  const RecoverUserRequestType(this.value);
}

enum RejectActivityRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_REJECT_ACTIVITY')
  activityTypeRejectActivity('ACTIVITY_TYPE_REJECT_ACTIVITY');

  final String? value;

  const RejectActivityRequestType(this.value);
}

enum RemoveOrganizationFeatureRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_REMOVE_ORGANIZATION_FEATURE')
  activityTypeRemoveOrganizationFeature(
      'ACTIVITY_TYPE_REMOVE_ORGANIZATION_FEATURE');

  final String? value;

  const RemoveOrganizationFeatureRequestType(this.value);
}

enum SetOrganizationFeatureRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_SET_ORGANIZATION_FEATURE')
  activityTypeSetOrganizationFeature('ACTIVITY_TYPE_SET_ORGANIZATION_FEATURE');

  final String? value;

  const SetOrganizationFeatureRequestType(this.value);
}

enum SignRawPayloadRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_SIGN_RAW_PAYLOAD_V2')
  activityTypeSignRawPayloadV2('ACTIVITY_TYPE_SIGN_RAW_PAYLOAD_V2');

  final String? value;

  const SignRawPayloadRequestType(this.value);
}

enum SignRawPayloadsRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_SIGN_RAW_PAYLOADS')
  activityTypeSignRawPayloads('ACTIVITY_TYPE_SIGN_RAW_PAYLOADS');

  final String? value;

  const SignRawPayloadsRequestType(this.value);
}

enum SignTransactionRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_SIGN_TRANSACTION_V2')
  activityTypeSignTransactionV2('ACTIVITY_TYPE_SIGN_TRANSACTION_V2');

  final String? value;

  const SignTransactionRequestType(this.value);
}

enum StampLoginRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_STAMP_LOGIN')
  activityTypeStampLogin('ACTIVITY_TYPE_STAMP_LOGIN');

  final String? value;

  const StampLoginRequestType(this.value);
}

enum TagType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('TAG_TYPE_USER')
  tagTypeUser('TAG_TYPE_USER'),
  @JsonValue('TAG_TYPE_PRIVATE_KEY')
  tagTypePrivateKey('TAG_TYPE_PRIVATE_KEY');

  final String? value;

  const TagType(this.value);
}

enum TransactionType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('TRANSACTION_TYPE_ETHEREUM')
  transactionTypeEthereum('TRANSACTION_TYPE_ETHEREUM'),
  @JsonValue('TRANSACTION_TYPE_SOLANA')
  transactionTypeSolana('TRANSACTION_TYPE_SOLANA'),
  @JsonValue('TRANSACTION_TYPE_TRON')
  transactionTypeTron('TRANSACTION_TYPE_TRON');

  final String? value;

  const TransactionType(this.value);
}

enum UpdatePolicyRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_UPDATE_POLICY_V2')
  activityTypeUpdatePolicyV2('ACTIVITY_TYPE_UPDATE_POLICY_V2');

  final String? value;

  const UpdatePolicyRequestType(this.value);
}

enum UpdatePrivateKeyTagRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_UPDATE_PRIVATE_KEY_TAG')
  activityTypeUpdatePrivateKeyTag('ACTIVITY_TYPE_UPDATE_PRIVATE_KEY_TAG');

  final String? value;

  const UpdatePrivateKeyTagRequestType(this.value);
}

enum UpdateRootQuorumRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_UPDATE_ROOT_QUORUM')
  activityTypeUpdateRootQuorum('ACTIVITY_TYPE_UPDATE_ROOT_QUORUM');

  final String? value;

  const UpdateRootQuorumRequestType(this.value);
}

enum UpdateUserRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_UPDATE_USER')
  activityTypeUpdateUser('ACTIVITY_TYPE_UPDATE_USER');

  final String? value;

  const UpdateUserRequestType(this.value);
}

enum UpdateUserTagRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_UPDATE_USER_TAG')
  activityTypeUpdateUserTag('ACTIVITY_TYPE_UPDATE_USER_TAG');

  final String? value;

  const UpdateUserTagRequestType(this.value);
}

enum UpdateWalletRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_UPDATE_WALLET')
  activityTypeUpdateWallet('ACTIVITY_TYPE_UPDATE_WALLET');

  final String? value;

  const UpdateWalletRequestType(this.value);
}

enum VerifyOtpRequestType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ACTIVITY_TYPE_VERIFY_OTP')
  activityTypeVerifyOtp('ACTIVITY_TYPE_VERIFY_OTP');

  final String? value;

  const VerifyOtpRequestType(this.value);
}

enum VoteSelection {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('VOTE_SELECTION_APPROVED')
  voteSelectionApproved('VOTE_SELECTION_APPROVED'),
  @JsonValue('VOTE_SELECTION_REJECTED')
  voteSelectionRejected('VOTE_SELECTION_REJECTED');

  final String? value;

  const VoteSelection(this.value);
}
