// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_api.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiApiKeyParams _$ApiApiKeyParamsFromJson(Map<String, dynamic> json) =>
    ApiApiKeyParams(
      apiKeyName: json['apiKeyName'] as String,
      publicKey: json['publicKey'] as String,
      expirationSeconds: json['expirationSeconds'] as String?,
    );

Map<String, dynamic> _$ApiApiKeyParamsToJson(ApiApiKeyParams instance) =>
    <String, dynamic>{
      'apiKeyName': instance.apiKeyName,
      'publicKey': instance.publicKey,
      'expirationSeconds': instance.expirationSeconds,
    };

BillingActivateBillingTierIntent _$BillingActivateBillingTierIntentFromJson(
        Map<String, dynamic> json) =>
    BillingActivateBillingTierIntent(
      productId: json['productId'] as String,
    );

Map<String, dynamic> _$BillingActivateBillingTierIntentToJson(
        BillingActivateBillingTierIntent instance) =>
    <String, dynamic>{
      'productId': instance.productId,
    };

BillingActivateBillingTierResult _$BillingActivateBillingTierResultFromJson(
        Map<String, dynamic> json) =>
    BillingActivateBillingTierResult(
      productId: json['productId'] as String,
    );

Map<String, dynamic> _$BillingActivateBillingTierResultToJson(
        BillingActivateBillingTierResult instance) =>
    <String, dynamic>{
      'productId': instance.productId,
    };

BillingDeletePaymentMethodIntent _$BillingDeletePaymentMethodIntentFromJson(
        Map<String, dynamic> json) =>
    BillingDeletePaymentMethodIntent(
      paymentMethodId: json['paymentMethodId'] as String,
    );

Map<String, dynamic> _$BillingDeletePaymentMethodIntentToJson(
        BillingDeletePaymentMethodIntent instance) =>
    <String, dynamic>{
      'paymentMethodId': instance.paymentMethodId,
    };

BillingDeletePaymentMethodResult _$BillingDeletePaymentMethodResultFromJson(
        Map<String, dynamic> json) =>
    BillingDeletePaymentMethodResult(
      paymentMethodId: json['paymentMethodId'] as String,
    );

Map<String, dynamic> _$BillingDeletePaymentMethodResultToJson(
        BillingDeletePaymentMethodResult instance) =>
    <String, dynamic>{
      'paymentMethodId': instance.paymentMethodId,
    };

BillingSetPaymentMethodIntent _$BillingSetPaymentMethodIntentFromJson(
        Map<String, dynamic> json) =>
    BillingSetPaymentMethodIntent(
      number: json['number'] as String,
      cvv: json['cvv'] as String,
      expiryMonth: json['expiryMonth'] as String,
      expiryYear: json['expiryYear'] as String,
      cardHolderEmail: json['cardHolderEmail'] as String,
      cardHolderName: json['cardHolderName'] as String,
    );

Map<String, dynamic> _$BillingSetPaymentMethodIntentToJson(
        BillingSetPaymentMethodIntent instance) =>
    <String, dynamic>{
      'number': instance.number,
      'cvv': instance.cvv,
      'expiryMonth': instance.expiryMonth,
      'expiryYear': instance.expiryYear,
      'cardHolderEmail': instance.cardHolderEmail,
      'cardHolderName': instance.cardHolderName,
    };

BillingSetPaymentMethodIntentV2 _$BillingSetPaymentMethodIntentV2FromJson(
        Map<String, dynamic> json) =>
    BillingSetPaymentMethodIntentV2(
      paymentMethodId: json['paymentMethodId'] as String,
      cardHolderEmail: json['cardHolderEmail'] as String,
      cardHolderName: json['cardHolderName'] as String,
    );

Map<String, dynamic> _$BillingSetPaymentMethodIntentV2ToJson(
        BillingSetPaymentMethodIntentV2 instance) =>
    <String, dynamic>{
      'paymentMethodId': instance.paymentMethodId,
      'cardHolderEmail': instance.cardHolderEmail,
      'cardHolderName': instance.cardHolderName,
    };

BillingSetPaymentMethodResult _$BillingSetPaymentMethodResultFromJson(
        Map<String, dynamic> json) =>
    BillingSetPaymentMethodResult(
      lastFour: json['lastFour'] as String,
      cardHolderName: json['cardHolderName'] as String,
      cardHolderEmail: json['cardHolderEmail'] as String,
    );

Map<String, dynamic> _$BillingSetPaymentMethodResultToJson(
        BillingSetPaymentMethodResult instance) =>
    <String, dynamic>{
      'lastFour': instance.lastFour,
      'cardHolderName': instance.cardHolderName,
      'cardHolderEmail': instance.cardHolderEmail,
    };

Datav1Tag _$Datav1TagFromJson(Map<String, dynamic> json) => Datav1Tag(
      tagId: json['tagId'] as String,
      tagName: json['tagName'] as String,
      tagType: v1TagTypeFromJson(json['tagType']),
      createdAt: Externaldatav1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: Externaldatav1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$Datav1TagToJson(Datav1Tag instance) => <String, dynamic>{
      'tagId': instance.tagId,
      'tagName': instance.tagName,
      'tagType': v1TagTypeToJson(instance.tagType),
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
    };

Externaldatav1Address _$Externaldatav1AddressFromJson(
        Map<String, dynamic> json) =>
    Externaldatav1Address(
      format: v1AddressFormatNullableFromJson(json['format']),
      address: json['address'] as String?,
    );

Map<String, dynamic> _$Externaldatav1AddressToJson(
        Externaldatav1Address instance) =>
    <String, dynamic>{
      'format': v1AddressFormatNullableToJson(instance.format),
      'address': instance.address,
    };

Externaldatav1Credential _$Externaldatav1CredentialFromJson(
        Map<String, dynamic> json) =>
    Externaldatav1Credential(
      publicKey: json['publicKey'] as String,
      type: v1CredentialTypeFromJson(json['type']),
    );

Map<String, dynamic> _$Externaldatav1CredentialToJson(
        Externaldatav1Credential instance) =>
    <String, dynamic>{
      'publicKey': instance.publicKey,
      'type': v1CredentialTypeToJson(instance.type),
    };

Externaldatav1Quorum _$Externaldatav1QuorumFromJson(
        Map<String, dynamic> json) =>
    Externaldatav1Quorum(
      threshold: (json['threshold'] as num).toInt(),
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$Externaldatav1QuorumToJson(
        Externaldatav1Quorum instance) =>
    <String, dynamic>{
      'threshold': instance.threshold,
      'userIds': instance.userIds,
    };

Externaldatav1Timestamp _$Externaldatav1TimestampFromJson(
        Map<String, dynamic> json) =>
    Externaldatav1Timestamp(
      seconds: json['seconds'] as String,
      nanos: json['nanos'] as String,
    );

Map<String, dynamic> _$Externaldatav1TimestampToJson(
        Externaldatav1Timestamp instance) =>
    <String, dynamic>{
      'seconds': instance.seconds,
      'nanos': instance.nanos,
    };

Immutableactivityv1Address _$Immutableactivityv1AddressFromJson(
        Map<String, dynamic> json) =>
    Immutableactivityv1Address(
      format: v1AddressFormatNullableFromJson(json['format']),
      address: json['address'] as String?,
    );

Map<String, dynamic> _$Immutableactivityv1AddressToJson(
        Immutableactivityv1Address instance) =>
    <String, dynamic>{
      'format': v1AddressFormatNullableToJson(instance.format),
      'address': instance.address,
    };

ProtobufAny _$ProtobufAnyFromJson(Map<String, dynamic> json) => ProtobufAny(
      type: json['@type'] as String?,
    );

Map<String, dynamic> _$ProtobufAnyToJson(ProtobufAny instance) =>
    <String, dynamic>{
      '@type': instance.type,
    };

RpcStatus _$RpcStatusFromJson(Map<String, dynamic> json) => RpcStatus(
      code: (json['code'] as num?)?.toInt(),
      message: json['message'] as String?,
      details: (json['details'] as List<dynamic>?)
              ?.map((e) => ProtobufAny.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$RpcStatusToJson(RpcStatus instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': instance.details?.map((e) => e.toJson()).toList(),
    };

V1AcceptInvitationIntent _$V1AcceptInvitationIntentFromJson(
        Map<String, dynamic> json) =>
    V1AcceptInvitationIntent(
      invitationId: json['invitationId'] as String,
      userId: json['userId'] as String,
      authenticator: V1AuthenticatorParams.fromJson(
          json['authenticator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AcceptInvitationIntentToJson(
        V1AcceptInvitationIntent instance) =>
    <String, dynamic>{
      'invitationId': instance.invitationId,
      'userId': instance.userId,
      'authenticator': instance.authenticator.toJson(),
    };

V1AcceptInvitationIntentV2 _$V1AcceptInvitationIntentV2FromJson(
        Map<String, dynamic> json) =>
    V1AcceptInvitationIntentV2(
      invitationId: json['invitationId'] as String,
      userId: json['userId'] as String,
      authenticator: V1AuthenticatorParamsV2.fromJson(
          json['authenticator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AcceptInvitationIntentV2ToJson(
        V1AcceptInvitationIntentV2 instance) =>
    <String, dynamic>{
      'invitationId': instance.invitationId,
      'userId': instance.userId,
      'authenticator': instance.authenticator.toJson(),
    };

V1AcceptInvitationResult _$V1AcceptInvitationResultFromJson(
        Map<String, dynamic> json) =>
    V1AcceptInvitationResult(
      invitationId: json['invitationId'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$V1AcceptInvitationResultToJson(
        V1AcceptInvitationResult instance) =>
    <String, dynamic>{
      'invitationId': instance.invitationId,
      'userId': instance.userId,
    };

V1Activity _$V1ActivityFromJson(Map<String, dynamic> json) => V1Activity(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      status: v1ActivityStatusFromJson(json['status']),
      type: v1ActivityTypeFromJson(json['type']),
      intent: V1Intent.fromJson(json['intent'] as Map<String, dynamic>),
      result: V1Result.fromJson(json['result'] as Map<String, dynamic>),
      votes: (json['votes'] as List<dynamic>?)
              ?.map((e) => V1Vote.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      fingerprint: json['fingerprint'] as String,
      canApprove: json['canApprove'] as bool,
      canReject: json['canReject'] as bool,
      createdAt: Externaldatav1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: Externaldatav1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
      failure: json['failure'] == null
          ? null
          : RpcStatus.fromJson(json['failure'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1ActivityToJson(V1Activity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'status': v1ActivityStatusToJson(instance.status),
      'type': v1ActivityTypeToJson(instance.type),
      'intent': instance.intent.toJson(),
      'result': instance.result.toJson(),
      'votes': instance.votes.map((e) => e.toJson()).toList(),
      'fingerprint': instance.fingerprint,
      'canApprove': instance.canApprove,
      'canReject': instance.canReject,
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
      'failure': instance.failure?.toJson(),
    };

V1ActivityResponse _$V1ActivityResponseFromJson(Map<String, dynamic> json) =>
    V1ActivityResponse(
      activity: V1Activity.fromJson(json['activity'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1ActivityResponseToJson(V1ActivityResponse instance) =>
    <String, dynamic>{
      'activity': instance.activity.toJson(),
    };

V1ApiKey _$V1ApiKeyFromJson(Map<String, dynamic> json) => V1ApiKey(
      credential: Externaldatav1Credential.fromJson(
          json['credential'] as Map<String, dynamic>),
      apiKeyId: json['apiKeyId'] as String,
      apiKeyName: json['apiKeyName'] as String,
      createdAt: Externaldatav1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: Externaldatav1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
      expirationSeconds: json['expirationSeconds'] as String?,
    );

Map<String, dynamic> _$V1ApiKeyToJson(V1ApiKey instance) => <String, dynamic>{
      'credential': instance.credential.toJson(),
      'apiKeyId': instance.apiKeyId,
      'apiKeyName': instance.apiKeyName,
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
      'expirationSeconds': instance.expirationSeconds,
    };

V1ApiKeyParamsV2 _$V1ApiKeyParamsV2FromJson(Map<String, dynamic> json) =>
    V1ApiKeyParamsV2(
      apiKeyName: json['apiKeyName'] as String,
      publicKey: json['publicKey'] as String,
      curveType: v1ApiKeyCurveFromJson(json['curveType']),
      expirationSeconds: json['expirationSeconds'] as String?,
    );

Map<String, dynamic> _$V1ApiKeyParamsV2ToJson(V1ApiKeyParamsV2 instance) =>
    <String, dynamic>{
      'apiKeyName': instance.apiKeyName,
      'publicKey': instance.publicKey,
      'curveType': v1ApiKeyCurveToJson(instance.curveType),
      'expirationSeconds': instance.expirationSeconds,
    };

V1ApiOnlyUserParams _$V1ApiOnlyUserParamsFromJson(Map<String, dynamic> json) =>
    V1ApiOnlyUserParams(
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      userTags: (json['userTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiApiKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1ApiOnlyUserParamsToJson(
        V1ApiOnlyUserParams instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'userTags': instance.userTags,
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
    };

V1ApproveActivityIntent _$V1ApproveActivityIntentFromJson(
        Map<String, dynamic> json) =>
    V1ApproveActivityIntent(
      fingerprint: json['fingerprint'] as String,
    );

Map<String, dynamic> _$V1ApproveActivityIntentToJson(
        V1ApproveActivityIntent instance) =>
    <String, dynamic>{
      'fingerprint': instance.fingerprint,
    };

V1ApproveActivityRequest _$V1ApproveActivityRequestFromJson(
        Map<String, dynamic> json) =>
    V1ApproveActivityRequest(
      type: v1ApproveActivityRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1ApproveActivityIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1ApproveActivityRequestToJson(
        V1ApproveActivityRequest instance) =>
    <String, dynamic>{
      'type': v1ApproveActivityRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1Attestation _$V1AttestationFromJson(Map<String, dynamic> json) =>
    V1Attestation(
      credentialId: json['credentialId'] as String,
      clientDataJson: json['clientDataJson'] as String,
      attestationObject: json['attestationObject'] as String,
      transports:
          v1AuthenticatorTransportListFromJson(json['transports'] as List?),
    );

Map<String, dynamic> _$V1AttestationToJson(V1Attestation instance) =>
    <String, dynamic>{
      'credentialId': instance.credentialId,
      'clientDataJson': instance.clientDataJson,
      'attestationObject': instance.attestationObject,
      'transports': v1AuthenticatorTransportListToJson(instance.transports),
    };

V1Authenticator _$V1AuthenticatorFromJson(Map<String, dynamic> json) =>
    V1Authenticator(
      transports:
          v1AuthenticatorTransportListFromJson(json['transports'] as List?),
      attestationType: json['attestationType'] as String,
      aaguid: json['aaguid'] as String,
      credentialId: json['credentialId'] as String,
      model: json['model'] as String,
      credential: Externaldatav1Credential.fromJson(
          json['credential'] as Map<String, dynamic>),
      authenticatorId: json['authenticatorId'] as String,
      authenticatorName: json['authenticatorName'] as String,
      createdAt: Externaldatav1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: Externaldatav1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AuthenticatorToJson(V1Authenticator instance) =>
    <String, dynamic>{
      'transports': v1AuthenticatorTransportListToJson(instance.transports),
      'attestationType': instance.attestationType,
      'aaguid': instance.aaguid,
      'credentialId': instance.credentialId,
      'model': instance.model,
      'credential': instance.credential.toJson(),
      'authenticatorId': instance.authenticatorId,
      'authenticatorName': instance.authenticatorName,
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
    };

V1AuthenticatorAttestationResponse _$V1AuthenticatorAttestationResponseFromJson(
        Map<String, dynamic> json) =>
    V1AuthenticatorAttestationResponse(
      clientDataJson: json['clientDataJson'] as String,
      attestationObject: json['attestationObject'] as String,
      transports:
          v1AuthenticatorTransportListFromJson(json['transports'] as List?),
      authenticatorAttachment:
          v1AuthenticatorAttestationResponseAuthenticatorAttachmentNullableFromJson(
              json['authenticatorAttachment']),
    );

Map<String, dynamic> _$V1AuthenticatorAttestationResponseToJson(
        V1AuthenticatorAttestationResponse instance) =>
    <String, dynamic>{
      'clientDataJson': instance.clientDataJson,
      'attestationObject': instance.attestationObject,
      'transports': v1AuthenticatorTransportListToJson(instance.transports),
      'authenticatorAttachment':
          v1AuthenticatorAttestationResponseAuthenticatorAttachmentNullableToJson(
              instance.authenticatorAttachment),
    };

V1AuthenticatorParams _$V1AuthenticatorParamsFromJson(
        Map<String, dynamic> json) =>
    V1AuthenticatorParams(
      authenticatorName: json['authenticatorName'] as String,
      userId: json['userId'] as String,
      attestation: V1PublicKeyCredentialWithAttestation.fromJson(
          json['attestation'] as Map<String, dynamic>),
      challenge: json['challenge'] as String,
    );

Map<String, dynamic> _$V1AuthenticatorParamsToJson(
        V1AuthenticatorParams instance) =>
    <String, dynamic>{
      'authenticatorName': instance.authenticatorName,
      'userId': instance.userId,
      'attestation': instance.attestation.toJson(),
      'challenge': instance.challenge,
    };

V1AuthenticatorParamsV2 _$V1AuthenticatorParamsV2FromJson(
        Map<String, dynamic> json) =>
    V1AuthenticatorParamsV2(
      authenticatorName: json['authenticatorName'] as String,
      challenge: json['challenge'] as String,
      attestation:
          V1Attestation.fromJson(json['attestation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1AuthenticatorParamsV2ToJson(
        V1AuthenticatorParamsV2 instance) =>
    <String, dynamic>{
      'authenticatorName': instance.authenticatorName,
      'challenge': instance.challenge,
      'attestation': instance.attestation.toJson(),
    };

V1Config _$V1ConfigFromJson(Map<String, dynamic> json) => V1Config(
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => V1Feature.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      quorum: json['quorum'] == null
          ? null
          : Externaldatav1Quorum.fromJson(
              json['quorum'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1ConfigToJson(V1Config instance) => <String, dynamic>{
      'features': instance.features?.map((e) => e.toJson()).toList(),
      'quorum': instance.quorum?.toJson(),
    };

V1CreateApiKeysIntent _$V1CreateApiKeysIntentFromJson(
        Map<String, dynamic> json) =>
    V1CreateApiKeysIntent(
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiApiKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$V1CreateApiKeysIntentToJson(
        V1CreateApiKeysIntent instance) =>
    <String, dynamic>{
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'userId': instance.userId,
    };

V1CreateApiKeysIntentV2 _$V1CreateApiKeysIntentV2FromJson(
        Map<String, dynamic> json) =>
    V1CreateApiKeysIntentV2(
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => V1ApiKeyParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$V1CreateApiKeysIntentV2ToJson(
        V1CreateApiKeysIntentV2 instance) =>
    <String, dynamic>{
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'userId': instance.userId,
    };

V1CreateApiKeysRequest _$V1CreateApiKeysRequestFromJson(
        Map<String, dynamic> json) =>
    V1CreateApiKeysRequest(
      type: v1CreateApiKeysRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1CreateApiKeysIntentV2.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreateApiKeysRequestToJson(
        V1CreateApiKeysRequest instance) =>
    <String, dynamic>{
      'type': v1CreateApiKeysRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1CreateApiKeysResult _$V1CreateApiKeysResultFromJson(
        Map<String, dynamic> json) =>
    V1CreateApiKeysResult(
      apiKeyIds: (json['apiKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateApiKeysResultToJson(
        V1CreateApiKeysResult instance) =>
    <String, dynamic>{
      'apiKeyIds': instance.apiKeyIds,
    };

V1CreateApiOnlyUsersIntent _$V1CreateApiOnlyUsersIntentFromJson(
        Map<String, dynamic> json) =>
    V1CreateApiOnlyUsersIntent(
      apiOnlyUsers: (json['apiOnlyUsers'] as List<dynamic>?)
              ?.map((e) =>
                  V1ApiOnlyUserParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateApiOnlyUsersIntentToJson(
        V1CreateApiOnlyUsersIntent instance) =>
    <String, dynamic>{
      'apiOnlyUsers': instance.apiOnlyUsers.map((e) => e.toJson()).toList(),
    };

V1CreateApiOnlyUsersRequest _$V1CreateApiOnlyUsersRequestFromJson(
        Map<String, dynamic> json) =>
    V1CreateApiOnlyUsersRequest(
      type: v1CreateApiOnlyUsersRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1CreateApiOnlyUsersIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreateApiOnlyUsersRequestToJson(
        V1CreateApiOnlyUsersRequest instance) =>
    <String, dynamic>{
      'type': v1CreateApiOnlyUsersRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1CreateApiOnlyUsersResult _$V1CreateApiOnlyUsersResultFromJson(
        Map<String, dynamic> json) =>
    V1CreateApiOnlyUsersResult(
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateApiOnlyUsersResultToJson(
        V1CreateApiOnlyUsersResult instance) =>
    <String, dynamic>{
      'userIds': instance.userIds,
    };

V1CreateAuthenticatorsIntent _$V1CreateAuthenticatorsIntentFromJson(
        Map<String, dynamic> json) =>
    V1CreateAuthenticatorsIntent(
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) =>
                  V1AuthenticatorParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$V1CreateAuthenticatorsIntentToJson(
        V1CreateAuthenticatorsIntent instance) =>
    <String, dynamic>{
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
      'userId': instance.userId,
    };

V1CreateAuthenticatorsIntentV2 _$V1CreateAuthenticatorsIntentV2FromJson(
        Map<String, dynamic> json) =>
    V1CreateAuthenticatorsIntentV2(
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) =>
                  V1AuthenticatorParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$V1CreateAuthenticatorsIntentV2ToJson(
        V1CreateAuthenticatorsIntentV2 instance) =>
    <String, dynamic>{
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
      'userId': instance.userId,
    };

V1CreateAuthenticatorsRequest _$V1CreateAuthenticatorsRequestFromJson(
        Map<String, dynamic> json) =>
    V1CreateAuthenticatorsRequest(
      type: v1CreateAuthenticatorsRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1CreateAuthenticatorsIntentV2.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreateAuthenticatorsRequestToJson(
        V1CreateAuthenticatorsRequest instance) =>
    <String, dynamic>{
      'type': v1CreateAuthenticatorsRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1CreateAuthenticatorsResult _$V1CreateAuthenticatorsResultFromJson(
        Map<String, dynamic> json) =>
    V1CreateAuthenticatorsResult(
      authenticatorIds: (json['authenticatorIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateAuthenticatorsResultToJson(
        V1CreateAuthenticatorsResult instance) =>
    <String, dynamic>{
      'authenticatorIds': instance.authenticatorIds,
    };

V1CreateInvitationsIntent _$V1CreateInvitationsIntentFromJson(
        Map<String, dynamic> json) =>
    V1CreateInvitationsIntent(
      invitations: (json['invitations'] as List<dynamic>?)
              ?.map(
                  (e) => V1InvitationParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateInvitationsIntentToJson(
        V1CreateInvitationsIntent instance) =>
    <String, dynamic>{
      'invitations': instance.invitations.map((e) => e.toJson()).toList(),
    };

V1CreateInvitationsRequest _$V1CreateInvitationsRequestFromJson(
        Map<String, dynamic> json) =>
    V1CreateInvitationsRequest(
      type: v1CreateInvitationsRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1CreateInvitationsIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreateInvitationsRequestToJson(
        V1CreateInvitationsRequest instance) =>
    <String, dynamic>{
      'type': v1CreateInvitationsRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1CreateInvitationsResult _$V1CreateInvitationsResultFromJson(
        Map<String, dynamic> json) =>
    V1CreateInvitationsResult(
      invitationIds: (json['invitationIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateInvitationsResultToJson(
        V1CreateInvitationsResult instance) =>
    <String, dynamic>{
      'invitationIds': instance.invitationIds,
    };

V1CreateOauthProvidersIntent _$V1CreateOauthProvidersIntentFromJson(
        Map<String, dynamic> json) =>
    V1CreateOauthProvidersIntent(
      userId: json['userId'] as String,
      oauthProviders: (json['oauthProviders'] as List<dynamic>?)
              ?.map((e) =>
                  V1OauthProviderParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateOauthProvidersIntentToJson(
        V1CreateOauthProvidersIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'oauthProviders': instance.oauthProviders.map((e) => e.toJson()).toList(),
    };

V1CreateOauthProvidersRequest _$V1CreateOauthProvidersRequestFromJson(
        Map<String, dynamic> json) =>
    V1CreateOauthProvidersRequest(
      type: v1CreateOauthProvidersRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1CreateOauthProvidersIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreateOauthProvidersRequestToJson(
        V1CreateOauthProvidersRequest instance) =>
    <String, dynamic>{
      'type': v1CreateOauthProvidersRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1CreateOauthProvidersResult _$V1CreateOauthProvidersResultFromJson(
        Map<String, dynamic> json) =>
    V1CreateOauthProvidersResult(
      providerIds: (json['providerIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateOauthProvidersResultToJson(
        V1CreateOauthProvidersResult instance) =>
    <String, dynamic>{
      'providerIds': instance.providerIds,
    };

V1CreateOrganizationIntent _$V1CreateOrganizationIntentFromJson(
        Map<String, dynamic> json) =>
    V1CreateOrganizationIntent(
      organizationName: json['organizationName'] as String,
      rootEmail: json['rootEmail'] as String,
      rootAuthenticator: V1AuthenticatorParams.fromJson(
          json['rootAuthenticator'] as Map<String, dynamic>),
      rootUserId: json['rootUserId'] as String?,
    );

Map<String, dynamic> _$V1CreateOrganizationIntentToJson(
        V1CreateOrganizationIntent instance) =>
    <String, dynamic>{
      'organizationName': instance.organizationName,
      'rootEmail': instance.rootEmail,
      'rootAuthenticator': instance.rootAuthenticator.toJson(),
      'rootUserId': instance.rootUserId,
    };

V1CreateOrganizationIntentV2 _$V1CreateOrganizationIntentV2FromJson(
        Map<String, dynamic> json) =>
    V1CreateOrganizationIntentV2(
      organizationName: json['organizationName'] as String,
      rootEmail: json['rootEmail'] as String,
      rootAuthenticator: V1AuthenticatorParamsV2.fromJson(
          json['rootAuthenticator'] as Map<String, dynamic>),
      rootUserId: json['rootUserId'] as String?,
    );

Map<String, dynamic> _$V1CreateOrganizationIntentV2ToJson(
        V1CreateOrganizationIntentV2 instance) =>
    <String, dynamic>{
      'organizationName': instance.organizationName,
      'rootEmail': instance.rootEmail,
      'rootAuthenticator': instance.rootAuthenticator.toJson(),
      'rootUserId': instance.rootUserId,
    };

V1CreateOrganizationResult _$V1CreateOrganizationResultFromJson(
        Map<String, dynamic> json) =>
    V1CreateOrganizationResult(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$V1CreateOrganizationResultToJson(
        V1CreateOrganizationResult instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

V1CreatePoliciesIntent _$V1CreatePoliciesIntentFromJson(
        Map<String, dynamic> json) =>
    V1CreatePoliciesIntent(
      policies: (json['policies'] as List<dynamic>?)
              ?.map((e) =>
                  V1CreatePolicyIntentV3.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreatePoliciesIntentToJson(
        V1CreatePoliciesIntent instance) =>
    <String, dynamic>{
      'policies': instance.policies.map((e) => e.toJson()).toList(),
    };

V1CreatePoliciesRequest _$V1CreatePoliciesRequestFromJson(
        Map<String, dynamic> json) =>
    V1CreatePoliciesRequest(
      type: v1CreatePoliciesRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1CreatePoliciesIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreatePoliciesRequestToJson(
        V1CreatePoliciesRequest instance) =>
    <String, dynamic>{
      'type': v1CreatePoliciesRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1CreatePoliciesResult _$V1CreatePoliciesResultFromJson(
        Map<String, dynamic> json) =>
    V1CreatePoliciesResult(
      policyIds: (json['policyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreatePoliciesResultToJson(
        V1CreatePoliciesResult instance) =>
    <String, dynamic>{
      'policyIds': instance.policyIds,
    };

V1CreatePolicyIntent _$V1CreatePolicyIntentFromJson(
        Map<String, dynamic> json) =>
    V1CreatePolicyIntent(
      policyName: json['policyName'] as String,
      selectors: (json['selectors'] as List<dynamic>?)
              ?.map((e) => V1Selector.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      effect: v1EffectFromJson(json['effect']),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$V1CreatePolicyIntentToJson(
        V1CreatePolicyIntent instance) =>
    <String, dynamic>{
      'policyName': instance.policyName,
      'selectors': instance.selectors.map((e) => e.toJson()).toList(),
      'effect': v1EffectToJson(instance.effect),
      'notes': instance.notes,
    };

V1CreatePolicyIntentV2 _$V1CreatePolicyIntentV2FromJson(
        Map<String, dynamic> json) =>
    V1CreatePolicyIntentV2(
      policyName: json['policyName'] as String,
      selectors: (json['selectors'] as List<dynamic>?)
              ?.map((e) => V1SelectorV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      effect: v1EffectFromJson(json['effect']),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$V1CreatePolicyIntentV2ToJson(
        V1CreatePolicyIntentV2 instance) =>
    <String, dynamic>{
      'policyName': instance.policyName,
      'selectors': instance.selectors.map((e) => e.toJson()).toList(),
      'effect': v1EffectToJson(instance.effect),
      'notes': instance.notes,
    };

V1CreatePolicyIntentV3 _$V1CreatePolicyIntentV3FromJson(
        Map<String, dynamic> json) =>
    V1CreatePolicyIntentV3(
      policyName: json['policyName'] as String,
      effect: v1EffectFromJson(json['effect']),
      condition: json['condition'] as String?,
      consensus: json['consensus'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$V1CreatePolicyIntentV3ToJson(
        V1CreatePolicyIntentV3 instance) =>
    <String, dynamic>{
      'policyName': instance.policyName,
      'effect': v1EffectToJson(instance.effect),
      'condition': instance.condition,
      'consensus': instance.consensus,
      'notes': instance.notes,
    };

V1CreatePolicyRequest _$V1CreatePolicyRequestFromJson(
        Map<String, dynamic> json) =>
    V1CreatePolicyRequest(
      type: v1CreatePolicyRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1CreatePolicyIntentV3.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreatePolicyRequestToJson(
        V1CreatePolicyRequest instance) =>
    <String, dynamic>{
      'type': v1CreatePolicyRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1CreatePolicyResult _$V1CreatePolicyResultFromJson(
        Map<String, dynamic> json) =>
    V1CreatePolicyResult(
      policyId: json['policyId'] as String,
    );

Map<String, dynamic> _$V1CreatePolicyResultToJson(
        V1CreatePolicyResult instance) =>
    <String, dynamic>{
      'policyId': instance.policyId,
    };

V1CreatePrivateKeyTagIntent _$V1CreatePrivateKeyTagIntentFromJson(
        Map<String, dynamic> json) =>
    V1CreatePrivateKeyTagIntent(
      privateKeyTagName: json['privateKeyTagName'] as String,
      privateKeyIds: (json['privateKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreatePrivateKeyTagIntentToJson(
        V1CreatePrivateKeyTagIntent instance) =>
    <String, dynamic>{
      'privateKeyTagName': instance.privateKeyTagName,
      'privateKeyIds': instance.privateKeyIds,
    };

V1CreatePrivateKeyTagRequest _$V1CreatePrivateKeyTagRequestFromJson(
        Map<String, dynamic> json) =>
    V1CreatePrivateKeyTagRequest(
      type: v1CreatePrivateKeyTagRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1CreatePrivateKeyTagIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreatePrivateKeyTagRequestToJson(
        V1CreatePrivateKeyTagRequest instance) =>
    <String, dynamic>{
      'type': v1CreatePrivateKeyTagRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1CreatePrivateKeyTagResult _$V1CreatePrivateKeyTagResultFromJson(
        Map<String, dynamic> json) =>
    V1CreatePrivateKeyTagResult(
      privateKeyTagId: json['privateKeyTagId'] as String,
      privateKeyIds: (json['privateKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreatePrivateKeyTagResultToJson(
        V1CreatePrivateKeyTagResult instance) =>
    <String, dynamic>{
      'privateKeyTagId': instance.privateKeyTagId,
      'privateKeyIds': instance.privateKeyIds,
    };

V1CreatePrivateKeysIntent _$V1CreatePrivateKeysIntentFromJson(
        Map<String, dynamic> json) =>
    V1CreatePrivateKeysIntent(
      privateKeys: (json['privateKeys'] as List<dynamic>?)
              ?.map(
                  (e) => V1PrivateKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreatePrivateKeysIntentToJson(
        V1CreatePrivateKeysIntent instance) =>
    <String, dynamic>{
      'privateKeys': instance.privateKeys.map((e) => e.toJson()).toList(),
    };

V1CreatePrivateKeysIntentV2 _$V1CreatePrivateKeysIntentV2FromJson(
        Map<String, dynamic> json) =>
    V1CreatePrivateKeysIntentV2(
      privateKeys: (json['privateKeys'] as List<dynamic>?)
              ?.map(
                  (e) => V1PrivateKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreatePrivateKeysIntentV2ToJson(
        V1CreatePrivateKeysIntentV2 instance) =>
    <String, dynamic>{
      'privateKeys': instance.privateKeys.map((e) => e.toJson()).toList(),
    };

V1CreatePrivateKeysRequest _$V1CreatePrivateKeysRequestFromJson(
        Map<String, dynamic> json) =>
    V1CreatePrivateKeysRequest(
      type: v1CreatePrivateKeysRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1CreatePrivateKeysIntentV2.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreatePrivateKeysRequestToJson(
        V1CreatePrivateKeysRequest instance) =>
    <String, dynamic>{
      'type': v1CreatePrivateKeysRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1CreatePrivateKeysResult _$V1CreatePrivateKeysResultFromJson(
        Map<String, dynamic> json) =>
    V1CreatePrivateKeysResult(
      privateKeyIds: (json['privateKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreatePrivateKeysResultToJson(
        V1CreatePrivateKeysResult instance) =>
    <String, dynamic>{
      'privateKeyIds': instance.privateKeyIds,
    };

V1CreatePrivateKeysResultV2 _$V1CreatePrivateKeysResultV2FromJson(
        Map<String, dynamic> json) =>
    V1CreatePrivateKeysResultV2(
      privateKeys: (json['privateKeys'] as List<dynamic>?)
              ?.map(
                  (e) => V1PrivateKeyResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreatePrivateKeysResultV2ToJson(
        V1CreatePrivateKeysResultV2 instance) =>
    <String, dynamic>{
      'privateKeys': instance.privateKeys.map((e) => e.toJson()).toList(),
    };

V1CreateReadOnlySessionIntent _$V1CreateReadOnlySessionIntentFromJson(
        Map<String, dynamic> json) =>
    V1CreateReadOnlySessionIntent();

Map<String, dynamic> _$V1CreateReadOnlySessionIntentToJson(
        V1CreateReadOnlySessionIntent instance) =>
    <String, dynamic>{};

V1CreateReadOnlySessionRequest _$V1CreateReadOnlySessionRequestFromJson(
        Map<String, dynamic> json) =>
    V1CreateReadOnlySessionRequest(
      type: v1CreateReadOnlySessionRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1CreateReadOnlySessionIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreateReadOnlySessionRequestToJson(
        V1CreateReadOnlySessionRequest instance) =>
    <String, dynamic>{
      'type': v1CreateReadOnlySessionRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1CreateReadOnlySessionResult _$V1CreateReadOnlySessionResultFromJson(
        Map<String, dynamic> json) =>
    V1CreateReadOnlySessionResult(
      organizationId: json['organizationId'] as String,
      organizationName: json['organizationName'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      session: json['session'] as String,
      sessionExpiry: json['sessionExpiry'] as String,
    );

Map<String, dynamic> _$V1CreateReadOnlySessionResultToJson(
        V1CreateReadOnlySessionResult instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'organizationName': instance.organizationName,
      'userId': instance.userId,
      'username': instance.username,
      'session': instance.session,
      'sessionExpiry': instance.sessionExpiry,
    };

V1CreateReadWriteSessionIntent _$V1CreateReadWriteSessionIntentFromJson(
        Map<String, dynamic> json) =>
    V1CreateReadWriteSessionIntent(
      targetPublicKey: json['targetPublicKey'] as String,
      email: json['email'] as String,
      apiKeyName: json['apiKeyName'] as String?,
      expirationSeconds: json['expirationSeconds'] as String?,
    );

Map<String, dynamic> _$V1CreateReadWriteSessionIntentToJson(
        V1CreateReadWriteSessionIntent instance) =>
    <String, dynamic>{
      'targetPublicKey': instance.targetPublicKey,
      'email': instance.email,
      'apiKeyName': instance.apiKeyName,
      'expirationSeconds': instance.expirationSeconds,
    };

V1CreateReadWriteSessionIntentV2 _$V1CreateReadWriteSessionIntentV2FromJson(
        Map<String, dynamic> json) =>
    V1CreateReadWriteSessionIntentV2(
      targetPublicKey: json['targetPublicKey'] as String,
      userId: json['userId'] as String?,
      apiKeyName: json['apiKeyName'] as String?,
      expirationSeconds: json['expirationSeconds'] as String?,
    );

Map<String, dynamic> _$V1CreateReadWriteSessionIntentV2ToJson(
        V1CreateReadWriteSessionIntentV2 instance) =>
    <String, dynamic>{
      'targetPublicKey': instance.targetPublicKey,
      'userId': instance.userId,
      'apiKeyName': instance.apiKeyName,
      'expirationSeconds': instance.expirationSeconds,
    };

V1CreateReadWriteSessionRequest _$V1CreateReadWriteSessionRequestFromJson(
        Map<String, dynamic> json) =>
    V1CreateReadWriteSessionRequest(
      type: v1CreateReadWriteSessionRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1CreateReadWriteSessionIntentV2.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreateReadWriteSessionRequestToJson(
        V1CreateReadWriteSessionRequest instance) =>
    <String, dynamic>{
      'type': v1CreateReadWriteSessionRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1CreateReadWriteSessionResult _$V1CreateReadWriteSessionResultFromJson(
        Map<String, dynamic> json) =>
    V1CreateReadWriteSessionResult(
      organizationId: json['organizationId'] as String,
      organizationName: json['organizationName'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      apiKeyId: json['apiKeyId'] as String,
      credentialBundle: json['credentialBundle'] as String,
    );

Map<String, dynamic> _$V1CreateReadWriteSessionResultToJson(
        V1CreateReadWriteSessionResult instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'organizationName': instance.organizationName,
      'userId': instance.userId,
      'username': instance.username,
      'apiKeyId': instance.apiKeyId,
      'credentialBundle': instance.credentialBundle,
    };

V1CreateReadWriteSessionResultV2 _$V1CreateReadWriteSessionResultV2FromJson(
        Map<String, dynamic> json) =>
    V1CreateReadWriteSessionResultV2(
      organizationId: json['organizationId'] as String,
      organizationName: json['organizationName'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      apiKeyId: json['apiKeyId'] as String,
      credentialBundle: json['credentialBundle'] as String,
    );

Map<String, dynamic> _$V1CreateReadWriteSessionResultV2ToJson(
        V1CreateReadWriteSessionResultV2 instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'organizationName': instance.organizationName,
      'userId': instance.userId,
      'username': instance.username,
      'apiKeyId': instance.apiKeyId,
      'credentialBundle': instance.credentialBundle,
    };

V1CreateSubOrganizationIntent _$V1CreateSubOrganizationIntentFromJson(
        Map<String, dynamic> json) =>
    V1CreateSubOrganizationIntent(
      name: json['name'] as String,
      rootAuthenticator: V1AuthenticatorParamsV2.fromJson(
          json['rootAuthenticator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreateSubOrganizationIntentToJson(
        V1CreateSubOrganizationIntent instance) =>
    <String, dynamic>{
      'name': instance.name,
      'rootAuthenticator': instance.rootAuthenticator.toJson(),
    };

V1CreateSubOrganizationIntentV2 _$V1CreateSubOrganizationIntentV2FromJson(
        Map<String, dynamic> json) =>
    V1CreateSubOrganizationIntentV2(
      subOrganizationName: json['subOrganizationName'] as String,
      rootUsers: (json['rootUsers'] as List<dynamic>?)
              ?.map((e) => V1RootUserParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rootQuorumThreshold: (json['rootQuorumThreshold'] as num).toInt(),
    );

Map<String, dynamic> _$V1CreateSubOrganizationIntentV2ToJson(
        V1CreateSubOrganizationIntentV2 instance) =>
    <String, dynamic>{
      'subOrganizationName': instance.subOrganizationName,
      'rootUsers': instance.rootUsers.map((e) => e.toJson()).toList(),
      'rootQuorumThreshold': instance.rootQuorumThreshold,
    };

V1CreateSubOrganizationIntentV3 _$V1CreateSubOrganizationIntentV3FromJson(
        Map<String, dynamic> json) =>
    V1CreateSubOrganizationIntentV3(
      subOrganizationName: json['subOrganizationName'] as String,
      rootUsers: (json['rootUsers'] as List<dynamic>?)
              ?.map((e) => V1RootUserParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rootQuorumThreshold: (json['rootQuorumThreshold'] as num).toInt(),
      privateKeys: (json['privateKeys'] as List<dynamic>?)
              ?.map(
                  (e) => V1PrivateKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateSubOrganizationIntentV3ToJson(
        V1CreateSubOrganizationIntentV3 instance) =>
    <String, dynamic>{
      'subOrganizationName': instance.subOrganizationName,
      'rootUsers': instance.rootUsers.map((e) => e.toJson()).toList(),
      'rootQuorumThreshold': instance.rootQuorumThreshold,
      'privateKeys': instance.privateKeys.map((e) => e.toJson()).toList(),
    };

V1CreateSubOrganizationIntentV4 _$V1CreateSubOrganizationIntentV4FromJson(
        Map<String, dynamic> json) =>
    V1CreateSubOrganizationIntentV4(
      subOrganizationName: json['subOrganizationName'] as String,
      rootUsers: (json['rootUsers'] as List<dynamic>?)
              ?.map((e) => V1RootUserParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rootQuorumThreshold: (json['rootQuorumThreshold'] as num).toInt(),
      wallet: json['wallet'] == null
          ? null
          : V1WalletParams.fromJson(json['wallet'] as Map<String, dynamic>),
      disableEmailRecovery: json['disableEmailRecovery'] as bool?,
      disableEmailAuth: json['disableEmailAuth'] as bool?,
    );

Map<String, dynamic> _$V1CreateSubOrganizationIntentV4ToJson(
        V1CreateSubOrganizationIntentV4 instance) =>
    <String, dynamic>{
      'subOrganizationName': instance.subOrganizationName,
      'rootUsers': instance.rootUsers.map((e) => e.toJson()).toList(),
      'rootQuorumThreshold': instance.rootQuorumThreshold,
      'wallet': instance.wallet?.toJson(),
      'disableEmailRecovery': instance.disableEmailRecovery,
      'disableEmailAuth': instance.disableEmailAuth,
    };

V1CreateSubOrganizationIntentV5 _$V1CreateSubOrganizationIntentV5FromJson(
        Map<String, dynamic> json) =>
    V1CreateSubOrganizationIntentV5(
      subOrganizationName: json['subOrganizationName'] as String,
      rootUsers: (json['rootUsers'] as List<dynamic>?)
              ?.map(
                  (e) => V1RootUserParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rootQuorumThreshold: (json['rootQuorumThreshold'] as num).toInt(),
      wallet: json['wallet'] == null
          ? null
          : V1WalletParams.fromJson(json['wallet'] as Map<String, dynamic>),
      disableEmailRecovery: json['disableEmailRecovery'] as bool?,
      disableEmailAuth: json['disableEmailAuth'] as bool?,
    );

Map<String, dynamic> _$V1CreateSubOrganizationIntentV5ToJson(
        V1CreateSubOrganizationIntentV5 instance) =>
    <String, dynamic>{
      'subOrganizationName': instance.subOrganizationName,
      'rootUsers': instance.rootUsers.map((e) => e.toJson()).toList(),
      'rootQuorumThreshold': instance.rootQuorumThreshold,
      'wallet': instance.wallet?.toJson(),
      'disableEmailRecovery': instance.disableEmailRecovery,
      'disableEmailAuth': instance.disableEmailAuth,
    };

V1CreateSubOrganizationIntentV6 _$V1CreateSubOrganizationIntentV6FromJson(
        Map<String, dynamic> json) =>
    V1CreateSubOrganizationIntentV6(
      subOrganizationName: json['subOrganizationName'] as String,
      rootUsers: (json['rootUsers'] as List<dynamic>?)
              ?.map(
                  (e) => V1RootUserParamsV3.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rootQuorumThreshold: (json['rootQuorumThreshold'] as num).toInt(),
      wallet: json['wallet'] == null
          ? null
          : V1WalletParams.fromJson(json['wallet'] as Map<String, dynamic>),
      disableEmailRecovery: json['disableEmailRecovery'] as bool?,
      disableEmailAuth: json['disableEmailAuth'] as bool?,
    );

Map<String, dynamic> _$V1CreateSubOrganizationIntentV6ToJson(
        V1CreateSubOrganizationIntentV6 instance) =>
    <String, dynamic>{
      'subOrganizationName': instance.subOrganizationName,
      'rootUsers': instance.rootUsers.map((e) => e.toJson()).toList(),
      'rootQuorumThreshold': instance.rootQuorumThreshold,
      'wallet': instance.wallet?.toJson(),
      'disableEmailRecovery': instance.disableEmailRecovery,
      'disableEmailAuth': instance.disableEmailAuth,
    };

V1CreateSubOrganizationIntentV7 _$V1CreateSubOrganizationIntentV7FromJson(
        Map<String, dynamic> json) =>
    V1CreateSubOrganizationIntentV7(
      subOrganizationName: json['subOrganizationName'] as String,
      rootUsers: (json['rootUsers'] as List<dynamic>?)
              ?.map(
                  (e) => V1RootUserParamsV4.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rootQuorumThreshold: (json['rootQuorumThreshold'] as num).toInt(),
      wallet: json['wallet'] == null
          ? null
          : V1WalletParams.fromJson(json['wallet'] as Map<String, dynamic>),
      disableEmailRecovery: json['disableEmailRecovery'] as bool?,
      disableEmailAuth: json['disableEmailAuth'] as bool?,
      disableSmsAuth: json['disableSmsAuth'] as bool?,
      disableOtpEmailAuth: json['disableOtpEmailAuth'] as bool?,
    );

Map<String, dynamic> _$V1CreateSubOrganizationIntentV7ToJson(
        V1CreateSubOrganizationIntentV7 instance) =>
    <String, dynamic>{
      'subOrganizationName': instance.subOrganizationName,
      'rootUsers': instance.rootUsers.map((e) => e.toJson()).toList(),
      'rootQuorumThreshold': instance.rootQuorumThreshold,
      'wallet': instance.wallet?.toJson(),
      'disableEmailRecovery': instance.disableEmailRecovery,
      'disableEmailAuth': instance.disableEmailAuth,
      'disableSmsAuth': instance.disableSmsAuth,
      'disableOtpEmailAuth': instance.disableOtpEmailAuth,
    };

V1CreateSubOrganizationRequest _$V1CreateSubOrganizationRequestFromJson(
        Map<String, dynamic> json) =>
    V1CreateSubOrganizationRequest(
      type: v1CreateSubOrganizationRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1CreateSubOrganizationIntentV7.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreateSubOrganizationRequestToJson(
        V1CreateSubOrganizationRequest instance) =>
    <String, dynamic>{
      'type': v1CreateSubOrganizationRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1CreateSubOrganizationResult _$V1CreateSubOrganizationResultFromJson(
        Map<String, dynamic> json) =>
    V1CreateSubOrganizationResult(
      subOrganizationId: json['subOrganizationId'] as String,
      rootUserIds: (json['rootUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateSubOrganizationResultToJson(
        V1CreateSubOrganizationResult instance) =>
    <String, dynamic>{
      'subOrganizationId': instance.subOrganizationId,
      'rootUserIds': instance.rootUserIds,
    };

V1CreateSubOrganizationResultV3 _$V1CreateSubOrganizationResultV3FromJson(
        Map<String, dynamic> json) =>
    V1CreateSubOrganizationResultV3(
      subOrganizationId: json['subOrganizationId'] as String,
      privateKeys: (json['privateKeys'] as List<dynamic>?)
              ?.map(
                  (e) => V1PrivateKeyResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rootUserIds: (json['rootUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateSubOrganizationResultV3ToJson(
        V1CreateSubOrganizationResultV3 instance) =>
    <String, dynamic>{
      'subOrganizationId': instance.subOrganizationId,
      'privateKeys': instance.privateKeys.map((e) => e.toJson()).toList(),
      'rootUserIds': instance.rootUserIds,
    };

V1CreateSubOrganizationResultV4 _$V1CreateSubOrganizationResultV4FromJson(
        Map<String, dynamic> json) =>
    V1CreateSubOrganizationResultV4(
      subOrganizationId: json['subOrganizationId'] as String,
      wallet: json['wallet'] == null
          ? null
          : V1WalletResult.fromJson(json['wallet'] as Map<String, dynamic>),
      rootUserIds: (json['rootUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateSubOrganizationResultV4ToJson(
        V1CreateSubOrganizationResultV4 instance) =>
    <String, dynamic>{
      'subOrganizationId': instance.subOrganizationId,
      'wallet': instance.wallet?.toJson(),
      'rootUserIds': instance.rootUserIds,
    };

V1CreateSubOrganizationResultV5 _$V1CreateSubOrganizationResultV5FromJson(
        Map<String, dynamic> json) =>
    V1CreateSubOrganizationResultV5(
      subOrganizationId: json['subOrganizationId'] as String,
      wallet: json['wallet'] == null
          ? null
          : V1WalletResult.fromJson(json['wallet'] as Map<String, dynamic>),
      rootUserIds: (json['rootUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateSubOrganizationResultV5ToJson(
        V1CreateSubOrganizationResultV5 instance) =>
    <String, dynamic>{
      'subOrganizationId': instance.subOrganizationId,
      'wallet': instance.wallet?.toJson(),
      'rootUserIds': instance.rootUserIds,
    };

V1CreateSubOrganizationResultV6 _$V1CreateSubOrganizationResultV6FromJson(
        Map<String, dynamic> json) =>
    V1CreateSubOrganizationResultV6(
      subOrganizationId: json['subOrganizationId'] as String,
      wallet: json['wallet'] == null
          ? null
          : V1WalletResult.fromJson(json['wallet'] as Map<String, dynamic>),
      rootUserIds: (json['rootUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateSubOrganizationResultV6ToJson(
        V1CreateSubOrganizationResultV6 instance) =>
    <String, dynamic>{
      'subOrganizationId': instance.subOrganizationId,
      'wallet': instance.wallet?.toJson(),
      'rootUserIds': instance.rootUserIds,
    };

V1CreateSubOrganizationResultV7 _$V1CreateSubOrganizationResultV7FromJson(
        Map<String, dynamic> json) =>
    V1CreateSubOrganizationResultV7(
      subOrganizationId: json['subOrganizationId'] as String,
      wallet: json['wallet'] == null
          ? null
          : V1WalletResult.fromJson(json['wallet'] as Map<String, dynamic>),
      rootUserIds: (json['rootUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateSubOrganizationResultV7ToJson(
        V1CreateSubOrganizationResultV7 instance) =>
    <String, dynamic>{
      'subOrganizationId': instance.subOrganizationId,
      'wallet': instance.wallet?.toJson(),
      'rootUserIds': instance.rootUserIds,
    };

V1CreateUserTagIntent _$V1CreateUserTagIntentFromJson(
        Map<String, dynamic> json) =>
    V1CreateUserTagIntent(
      userTagName: json['userTagName'] as String,
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateUserTagIntentToJson(
        V1CreateUserTagIntent instance) =>
    <String, dynamic>{
      'userTagName': instance.userTagName,
      'userIds': instance.userIds,
    };

V1CreateUserTagRequest _$V1CreateUserTagRequestFromJson(
        Map<String, dynamic> json) =>
    V1CreateUserTagRequest(
      type: v1CreateUserTagRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1CreateUserTagIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreateUserTagRequestToJson(
        V1CreateUserTagRequest instance) =>
    <String, dynamic>{
      'type': v1CreateUserTagRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1CreateUserTagResult _$V1CreateUserTagResultFromJson(
        Map<String, dynamic> json) =>
    V1CreateUserTagResult(
      userTagId: json['userTagId'] as String,
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateUserTagResultToJson(
        V1CreateUserTagResult instance) =>
    <String, dynamic>{
      'userTagId': instance.userTagId,
      'userIds': instance.userIds,
    };

V1CreateUsersIntent _$V1CreateUsersIntentFromJson(Map<String, dynamic> json) =>
    V1CreateUsersIntent(
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => V1UserParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateUsersIntentToJson(
        V1CreateUsersIntent instance) =>
    <String, dynamic>{
      'users': instance.users.map((e) => e.toJson()).toList(),
    };

V1CreateUsersIntentV2 _$V1CreateUsersIntentV2FromJson(
        Map<String, dynamic> json) =>
    V1CreateUsersIntentV2(
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => V1UserParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateUsersIntentV2ToJson(
        V1CreateUsersIntentV2 instance) =>
    <String, dynamic>{
      'users': instance.users.map((e) => e.toJson()).toList(),
    };

V1CreateUsersRequest _$V1CreateUsersRequestFromJson(
        Map<String, dynamic> json) =>
    V1CreateUsersRequest(
      type: v1CreateUsersRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1CreateUsersIntentV2.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreateUsersRequestToJson(
        V1CreateUsersRequest instance) =>
    <String, dynamic>{
      'type': v1CreateUsersRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1CreateUsersResult _$V1CreateUsersResultFromJson(Map<String, dynamic> json) =>
    V1CreateUsersResult(
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateUsersResultToJson(
        V1CreateUsersResult instance) =>
    <String, dynamic>{
      'userIds': instance.userIds,
    };

V1CreateWalletAccountsIntent _$V1CreateWalletAccountsIntentFromJson(
        Map<String, dynamic> json) =>
    V1CreateWalletAccountsIntent(
      walletId: json['walletId'] as String,
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) =>
                  V1WalletAccountParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateWalletAccountsIntentToJson(
        V1CreateWalletAccountsIntent instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'accounts': instance.accounts.map((e) => e.toJson()).toList(),
    };

V1CreateWalletAccountsRequest _$V1CreateWalletAccountsRequestFromJson(
        Map<String, dynamic> json) =>
    V1CreateWalletAccountsRequest(
      type: v1CreateWalletAccountsRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1CreateWalletAccountsIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreateWalletAccountsRequestToJson(
        V1CreateWalletAccountsRequest instance) =>
    <String, dynamic>{
      'type': v1CreateWalletAccountsRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1CreateWalletAccountsResult _$V1CreateWalletAccountsResultFromJson(
        Map<String, dynamic> json) =>
    V1CreateWalletAccountsResult(
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateWalletAccountsResultToJson(
        V1CreateWalletAccountsResult instance) =>
    <String, dynamic>{
      'addresses': instance.addresses,
    };

V1CreateWalletIntent _$V1CreateWalletIntentFromJson(
        Map<String, dynamic> json) =>
    V1CreateWalletIntent(
      walletName: json['walletName'] as String,
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) =>
                  V1WalletAccountParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      mnemonicLength: (json['mnemonicLength'] as num?)?.toInt(),
    );

Map<String, dynamic> _$V1CreateWalletIntentToJson(
        V1CreateWalletIntent instance) =>
    <String, dynamic>{
      'walletName': instance.walletName,
      'accounts': instance.accounts.map((e) => e.toJson()).toList(),
      'mnemonicLength': instance.mnemonicLength,
    };

V1CreateWalletRequest _$V1CreateWalletRequestFromJson(
        Map<String, dynamic> json) =>
    V1CreateWalletRequest(
      type: v1CreateWalletRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1CreateWalletIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1CreateWalletRequestToJson(
        V1CreateWalletRequest instance) =>
    <String, dynamic>{
      'type': v1CreateWalletRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1CreateWalletResult _$V1CreateWalletResultFromJson(
        Map<String, dynamic> json) =>
    V1CreateWalletResult(
      walletId: json['walletId'] as String,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1CreateWalletResultToJson(
        V1CreateWalletResult instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'addresses': instance.addresses,
    };

V1CredPropsAuthenticationExtensionsClientOutputs
    _$V1CredPropsAuthenticationExtensionsClientOutputsFromJson(
            Map<String, dynamic> json) =>
        V1CredPropsAuthenticationExtensionsClientOutputs(
          rk: json['rk'] as bool,
        );

Map<String, dynamic> _$V1CredPropsAuthenticationExtensionsClientOutputsToJson(
        V1CredPropsAuthenticationExtensionsClientOutputs instance) =>
    <String, dynamic>{
      'rk': instance.rk,
    };

V1DeleteApiKeysIntent _$V1DeleteApiKeysIntentFromJson(
        Map<String, dynamic> json) =>
    V1DeleteApiKeysIntent(
      userId: json['userId'] as String,
      apiKeyIds: (json['apiKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1DeleteApiKeysIntentToJson(
        V1DeleteApiKeysIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'apiKeyIds': instance.apiKeyIds,
    };

V1DeleteApiKeysRequest _$V1DeleteApiKeysRequestFromJson(
        Map<String, dynamic> json) =>
    V1DeleteApiKeysRequest(
      type: v1DeleteApiKeysRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1DeleteApiKeysIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1DeleteApiKeysRequestToJson(
        V1DeleteApiKeysRequest instance) =>
    <String, dynamic>{
      'type': v1DeleteApiKeysRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1DeleteApiKeysResult _$V1DeleteApiKeysResultFromJson(
        Map<String, dynamic> json) =>
    V1DeleteApiKeysResult(
      apiKeyIds: (json['apiKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1DeleteApiKeysResultToJson(
        V1DeleteApiKeysResult instance) =>
    <String, dynamic>{
      'apiKeyIds': instance.apiKeyIds,
    };

V1DeleteAuthenticatorsIntent _$V1DeleteAuthenticatorsIntentFromJson(
        Map<String, dynamic> json) =>
    V1DeleteAuthenticatorsIntent(
      userId: json['userId'] as String,
      authenticatorIds: (json['authenticatorIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1DeleteAuthenticatorsIntentToJson(
        V1DeleteAuthenticatorsIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'authenticatorIds': instance.authenticatorIds,
    };

V1DeleteAuthenticatorsRequest _$V1DeleteAuthenticatorsRequestFromJson(
        Map<String, dynamic> json) =>
    V1DeleteAuthenticatorsRequest(
      type: v1DeleteAuthenticatorsRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1DeleteAuthenticatorsIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1DeleteAuthenticatorsRequestToJson(
        V1DeleteAuthenticatorsRequest instance) =>
    <String, dynamic>{
      'type': v1DeleteAuthenticatorsRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1DeleteAuthenticatorsResult _$V1DeleteAuthenticatorsResultFromJson(
        Map<String, dynamic> json) =>
    V1DeleteAuthenticatorsResult(
      authenticatorIds: (json['authenticatorIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1DeleteAuthenticatorsResultToJson(
        V1DeleteAuthenticatorsResult instance) =>
    <String, dynamic>{
      'authenticatorIds': instance.authenticatorIds,
    };

V1DeleteInvitationIntent _$V1DeleteInvitationIntentFromJson(
        Map<String, dynamic> json) =>
    V1DeleteInvitationIntent(
      invitationId: json['invitationId'] as String,
    );

Map<String, dynamic> _$V1DeleteInvitationIntentToJson(
        V1DeleteInvitationIntent instance) =>
    <String, dynamic>{
      'invitationId': instance.invitationId,
    };

V1DeleteInvitationRequest _$V1DeleteInvitationRequestFromJson(
        Map<String, dynamic> json) =>
    V1DeleteInvitationRequest(
      type: v1DeleteInvitationRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1DeleteInvitationIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1DeleteInvitationRequestToJson(
        V1DeleteInvitationRequest instance) =>
    <String, dynamic>{
      'type': v1DeleteInvitationRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1DeleteInvitationResult _$V1DeleteInvitationResultFromJson(
        Map<String, dynamic> json) =>
    V1DeleteInvitationResult(
      invitationId: json['invitationId'] as String,
    );

Map<String, dynamic> _$V1DeleteInvitationResultToJson(
        V1DeleteInvitationResult instance) =>
    <String, dynamic>{
      'invitationId': instance.invitationId,
    };

V1DeleteOauthProvidersIntent _$V1DeleteOauthProvidersIntentFromJson(
        Map<String, dynamic> json) =>
    V1DeleteOauthProvidersIntent(
      userId: json['userId'] as String,
      providerIds: (json['providerIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1DeleteOauthProvidersIntentToJson(
        V1DeleteOauthProvidersIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'providerIds': instance.providerIds,
    };

V1DeleteOauthProvidersRequest _$V1DeleteOauthProvidersRequestFromJson(
        Map<String, dynamic> json) =>
    V1DeleteOauthProvidersRequest(
      type: v1DeleteOauthProvidersRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1DeleteOauthProvidersIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1DeleteOauthProvidersRequestToJson(
        V1DeleteOauthProvidersRequest instance) =>
    <String, dynamic>{
      'type': v1DeleteOauthProvidersRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1DeleteOauthProvidersResult _$V1DeleteOauthProvidersResultFromJson(
        Map<String, dynamic> json) =>
    V1DeleteOauthProvidersResult(
      providerIds: (json['providerIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1DeleteOauthProvidersResultToJson(
        V1DeleteOauthProvidersResult instance) =>
    <String, dynamic>{
      'providerIds': instance.providerIds,
    };

V1DeleteOrganizationIntent _$V1DeleteOrganizationIntentFromJson(
        Map<String, dynamic> json) =>
    V1DeleteOrganizationIntent(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$V1DeleteOrganizationIntentToJson(
        V1DeleteOrganizationIntent instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

V1DeleteOrganizationResult _$V1DeleteOrganizationResultFromJson(
        Map<String, dynamic> json) =>
    V1DeleteOrganizationResult(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$V1DeleteOrganizationResultToJson(
        V1DeleteOrganizationResult instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

V1DeletePolicyIntent _$V1DeletePolicyIntentFromJson(
        Map<String, dynamic> json) =>
    V1DeletePolicyIntent(
      policyId: json['policyId'] as String,
    );

Map<String, dynamic> _$V1DeletePolicyIntentToJson(
        V1DeletePolicyIntent instance) =>
    <String, dynamic>{
      'policyId': instance.policyId,
    };

V1DeletePolicyRequest _$V1DeletePolicyRequestFromJson(
        Map<String, dynamic> json) =>
    V1DeletePolicyRequest(
      type: v1DeletePolicyRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1DeletePolicyIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1DeletePolicyRequestToJson(
        V1DeletePolicyRequest instance) =>
    <String, dynamic>{
      'type': v1DeletePolicyRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1DeletePolicyResult _$V1DeletePolicyResultFromJson(
        Map<String, dynamic> json) =>
    V1DeletePolicyResult(
      policyId: json['policyId'] as String,
    );

Map<String, dynamic> _$V1DeletePolicyResultToJson(
        V1DeletePolicyResult instance) =>
    <String, dynamic>{
      'policyId': instance.policyId,
    };

V1DeletePrivateKeyTagsIntent _$V1DeletePrivateKeyTagsIntentFromJson(
        Map<String, dynamic> json) =>
    V1DeletePrivateKeyTagsIntent(
      privateKeyTagIds: (json['privateKeyTagIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1DeletePrivateKeyTagsIntentToJson(
        V1DeletePrivateKeyTagsIntent instance) =>
    <String, dynamic>{
      'privateKeyTagIds': instance.privateKeyTagIds,
    };

V1DeletePrivateKeyTagsRequest _$V1DeletePrivateKeyTagsRequestFromJson(
        Map<String, dynamic> json) =>
    V1DeletePrivateKeyTagsRequest(
      type: v1DeletePrivateKeyTagsRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1DeletePrivateKeyTagsIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1DeletePrivateKeyTagsRequestToJson(
        V1DeletePrivateKeyTagsRequest instance) =>
    <String, dynamic>{
      'type': v1DeletePrivateKeyTagsRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1DeletePrivateKeyTagsResult _$V1DeletePrivateKeyTagsResultFromJson(
        Map<String, dynamic> json) =>
    V1DeletePrivateKeyTagsResult(
      privateKeyTagIds: (json['privateKeyTagIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      privateKeyIds: (json['privateKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1DeletePrivateKeyTagsResultToJson(
        V1DeletePrivateKeyTagsResult instance) =>
    <String, dynamic>{
      'privateKeyTagIds': instance.privateKeyTagIds,
      'privateKeyIds': instance.privateKeyIds,
    };

V1DeletePrivateKeysIntent _$V1DeletePrivateKeysIntentFromJson(
        Map<String, dynamic> json) =>
    V1DeletePrivateKeysIntent(
      privateKeyIds: (json['privateKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      deleteWithoutExport: json['deleteWithoutExport'] as bool?,
    );

Map<String, dynamic> _$V1DeletePrivateKeysIntentToJson(
        V1DeletePrivateKeysIntent instance) =>
    <String, dynamic>{
      'privateKeyIds': instance.privateKeyIds,
      'deleteWithoutExport': instance.deleteWithoutExport,
    };

V1DeletePrivateKeysRequest _$V1DeletePrivateKeysRequestFromJson(
        Map<String, dynamic> json) =>
    V1DeletePrivateKeysRequest(
      type: v1DeletePrivateKeysRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1DeletePrivateKeysIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1DeletePrivateKeysRequestToJson(
        V1DeletePrivateKeysRequest instance) =>
    <String, dynamic>{
      'type': v1DeletePrivateKeysRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1DeletePrivateKeysResult _$V1DeletePrivateKeysResultFromJson(
        Map<String, dynamic> json) =>
    V1DeletePrivateKeysResult(
      privateKeyIds: (json['privateKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1DeletePrivateKeysResultToJson(
        V1DeletePrivateKeysResult instance) =>
    <String, dynamic>{
      'privateKeyIds': instance.privateKeyIds,
    };

V1DeleteSubOrganizationIntent _$V1DeleteSubOrganizationIntentFromJson(
        Map<String, dynamic> json) =>
    V1DeleteSubOrganizationIntent(
      deleteWithoutExport: json['deleteWithoutExport'] as bool?,
    );

Map<String, dynamic> _$V1DeleteSubOrganizationIntentToJson(
        V1DeleteSubOrganizationIntent instance) =>
    <String, dynamic>{
      'deleteWithoutExport': instance.deleteWithoutExport,
    };

V1DeleteSubOrganizationRequest _$V1DeleteSubOrganizationRequestFromJson(
        Map<String, dynamic> json) =>
    V1DeleteSubOrganizationRequest(
      type: v1DeleteSubOrganizationRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1DeleteSubOrganizationIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1DeleteSubOrganizationRequestToJson(
        V1DeleteSubOrganizationRequest instance) =>
    <String, dynamic>{
      'type': v1DeleteSubOrganizationRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1DeleteSubOrganizationResult _$V1DeleteSubOrganizationResultFromJson(
        Map<String, dynamic> json) =>
    V1DeleteSubOrganizationResult(
      subOrganizationUuid: json['subOrganizationUuid'] as String,
    );

Map<String, dynamic> _$V1DeleteSubOrganizationResultToJson(
        V1DeleteSubOrganizationResult instance) =>
    <String, dynamic>{
      'subOrganizationUuid': instance.subOrganizationUuid,
    };

V1DeleteUserTagsIntent _$V1DeleteUserTagsIntentFromJson(
        Map<String, dynamic> json) =>
    V1DeleteUserTagsIntent(
      userTagIds: (json['userTagIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1DeleteUserTagsIntentToJson(
        V1DeleteUserTagsIntent instance) =>
    <String, dynamic>{
      'userTagIds': instance.userTagIds,
    };

V1DeleteUserTagsRequest _$V1DeleteUserTagsRequestFromJson(
        Map<String, dynamic> json) =>
    V1DeleteUserTagsRequest(
      type: v1DeleteUserTagsRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1DeleteUserTagsIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1DeleteUserTagsRequestToJson(
        V1DeleteUserTagsRequest instance) =>
    <String, dynamic>{
      'type': v1DeleteUserTagsRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1DeleteUserTagsResult _$V1DeleteUserTagsResultFromJson(
        Map<String, dynamic> json) =>
    V1DeleteUserTagsResult(
      userTagIds: (json['userTagIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1DeleteUserTagsResultToJson(
        V1DeleteUserTagsResult instance) =>
    <String, dynamic>{
      'userTagIds': instance.userTagIds,
      'userIds': instance.userIds,
    };

V1DeleteUsersIntent _$V1DeleteUsersIntentFromJson(Map<String, dynamic> json) =>
    V1DeleteUsersIntent(
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1DeleteUsersIntentToJson(
        V1DeleteUsersIntent instance) =>
    <String, dynamic>{
      'userIds': instance.userIds,
    };

V1DeleteUsersRequest _$V1DeleteUsersRequestFromJson(
        Map<String, dynamic> json) =>
    V1DeleteUsersRequest(
      type: v1DeleteUsersRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1DeleteUsersIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1DeleteUsersRequestToJson(
        V1DeleteUsersRequest instance) =>
    <String, dynamic>{
      'type': v1DeleteUsersRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1DeleteUsersResult _$V1DeleteUsersResultFromJson(Map<String, dynamic> json) =>
    V1DeleteUsersResult(
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1DeleteUsersResultToJson(
        V1DeleteUsersResult instance) =>
    <String, dynamic>{
      'userIds': instance.userIds,
    };

V1DeleteWalletsIntent _$V1DeleteWalletsIntentFromJson(
        Map<String, dynamic> json) =>
    V1DeleteWalletsIntent(
      walletIds: (json['walletIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      deleteWithoutExport: json['deleteWithoutExport'] as bool?,
    );

Map<String, dynamic> _$V1DeleteWalletsIntentToJson(
        V1DeleteWalletsIntent instance) =>
    <String, dynamic>{
      'walletIds': instance.walletIds,
      'deleteWithoutExport': instance.deleteWithoutExport,
    };

V1DeleteWalletsRequest _$V1DeleteWalletsRequestFromJson(
        Map<String, dynamic> json) =>
    V1DeleteWalletsRequest(
      type: v1DeleteWalletsRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1DeleteWalletsIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1DeleteWalletsRequestToJson(
        V1DeleteWalletsRequest instance) =>
    <String, dynamic>{
      'type': v1DeleteWalletsRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1DeleteWalletsResult _$V1DeleteWalletsResultFromJson(
        Map<String, dynamic> json) =>
    V1DeleteWalletsResult(
      walletIds: (json['walletIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1DeleteWalletsResultToJson(
        V1DeleteWalletsResult instance) =>
    <String, dynamic>{
      'walletIds': instance.walletIds,
    };

V1DisablePrivateKeyIntent _$V1DisablePrivateKeyIntentFromJson(
        Map<String, dynamic> json) =>
    V1DisablePrivateKeyIntent(
      privateKeyId: json['privateKeyId'] as String,
    );

Map<String, dynamic> _$V1DisablePrivateKeyIntentToJson(
        V1DisablePrivateKeyIntent instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
    };

V1DisablePrivateKeyResult _$V1DisablePrivateKeyResultFromJson(
        Map<String, dynamic> json) =>
    V1DisablePrivateKeyResult(
      privateKeyId: json['privateKeyId'] as String,
    );

Map<String, dynamic> _$V1DisablePrivateKeyResultToJson(
        V1DisablePrivateKeyResult instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
    };

V1EmailAuthIntent _$V1EmailAuthIntentFromJson(Map<String, dynamic> json) =>
    V1EmailAuthIntent(
      email: json['email'] as String,
      targetPublicKey: json['targetPublicKey'] as String,
      apiKeyName: json['apiKeyName'] as String?,
      expirationSeconds: json['expirationSeconds'] as String?,
      emailCustomization: json['emailCustomization'] == null
          ? null
          : V1EmailCustomizationParams.fromJson(
              json['emailCustomization'] as Map<String, dynamic>),
      invalidateExisting: json['invalidateExisting'] as bool?,
    );

Map<String, dynamic> _$V1EmailAuthIntentToJson(V1EmailAuthIntent instance) =>
    <String, dynamic>{
      'email': instance.email,
      'targetPublicKey': instance.targetPublicKey,
      'apiKeyName': instance.apiKeyName,
      'expirationSeconds': instance.expirationSeconds,
      'emailCustomization': instance.emailCustomization?.toJson(),
      'invalidateExisting': instance.invalidateExisting,
    };

V1EmailAuthIntentV2 _$V1EmailAuthIntentV2FromJson(Map<String, dynamic> json) =>
    V1EmailAuthIntentV2(
      email: json['email'] as String,
      targetPublicKey: json['targetPublicKey'] as String,
      apiKeyName: json['apiKeyName'] as String?,
      expirationSeconds: json['expirationSeconds'] as String?,
      emailCustomization: json['emailCustomization'] == null
          ? null
          : V1EmailCustomizationParams.fromJson(
              json['emailCustomization'] as Map<String, dynamic>),
      invalidateExisting: json['invalidateExisting'] as bool?,
    );

Map<String, dynamic> _$V1EmailAuthIntentV2ToJson(
        V1EmailAuthIntentV2 instance) =>
    <String, dynamic>{
      'email': instance.email,
      'targetPublicKey': instance.targetPublicKey,
      'apiKeyName': instance.apiKeyName,
      'expirationSeconds': instance.expirationSeconds,
      'emailCustomization': instance.emailCustomization?.toJson(),
      'invalidateExisting': instance.invalidateExisting,
    };

V1EmailAuthRequest _$V1EmailAuthRequestFromJson(Map<String, dynamic> json) =>
    V1EmailAuthRequest(
      type: v1EmailAuthRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1EmailAuthIntentV2.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1EmailAuthRequestToJson(V1EmailAuthRequest instance) =>
    <String, dynamic>{
      'type': v1EmailAuthRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1EmailAuthResult _$V1EmailAuthResultFromJson(Map<String, dynamic> json) =>
    V1EmailAuthResult(
      userId: json['userId'] as String,
      apiKeyId: json['apiKeyId'] as String,
    );

Map<String, dynamic> _$V1EmailAuthResultToJson(V1EmailAuthResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'apiKeyId': instance.apiKeyId,
    };

V1EmailCustomizationParams _$V1EmailCustomizationParamsFromJson(
        Map<String, dynamic> json) =>
    V1EmailCustomizationParams(
      appName: json['appName'] as String?,
      logoUrl: json['logoUrl'] as String?,
      magicLinkTemplate: json['magicLinkTemplate'] as String?,
      templateVariables: json['templateVariables'] as String?,
      templateId: json['templateId'] as String?,
    );

Map<String, dynamic> _$V1EmailCustomizationParamsToJson(
        V1EmailCustomizationParams instance) =>
    <String, dynamic>{
      'appName': instance.appName,
      'logoUrl': instance.logoUrl,
      'magicLinkTemplate': instance.magicLinkTemplate,
      'templateVariables': instance.templateVariables,
      'templateId': instance.templateId,
    };

V1ExportPrivateKeyIntent _$V1ExportPrivateKeyIntentFromJson(
        Map<String, dynamic> json) =>
    V1ExportPrivateKeyIntent(
      privateKeyId: json['privateKeyId'] as String,
      targetPublicKey: json['targetPublicKey'] as String,
    );

Map<String, dynamic> _$V1ExportPrivateKeyIntentToJson(
        V1ExportPrivateKeyIntent instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
      'targetPublicKey': instance.targetPublicKey,
    };

V1ExportPrivateKeyRequest _$V1ExportPrivateKeyRequestFromJson(
        Map<String, dynamic> json) =>
    V1ExportPrivateKeyRequest(
      type: v1ExportPrivateKeyRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1ExportPrivateKeyIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1ExportPrivateKeyRequestToJson(
        V1ExportPrivateKeyRequest instance) =>
    <String, dynamic>{
      'type': v1ExportPrivateKeyRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1ExportPrivateKeyResult _$V1ExportPrivateKeyResultFromJson(
        Map<String, dynamic> json) =>
    V1ExportPrivateKeyResult(
      privateKeyId: json['privateKeyId'] as String,
      exportBundle: json['exportBundle'] as String,
    );

Map<String, dynamic> _$V1ExportPrivateKeyResultToJson(
        V1ExportPrivateKeyResult instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
      'exportBundle': instance.exportBundle,
    };

V1ExportWalletAccountIntent _$V1ExportWalletAccountIntentFromJson(
        Map<String, dynamic> json) =>
    V1ExportWalletAccountIntent(
      address: json['address'] as String,
      targetPublicKey: json['targetPublicKey'] as String,
    );

Map<String, dynamic> _$V1ExportWalletAccountIntentToJson(
        V1ExportWalletAccountIntent instance) =>
    <String, dynamic>{
      'address': instance.address,
      'targetPublicKey': instance.targetPublicKey,
    };

V1ExportWalletAccountRequest _$V1ExportWalletAccountRequestFromJson(
        Map<String, dynamic> json) =>
    V1ExportWalletAccountRequest(
      type: v1ExportWalletAccountRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1ExportWalletAccountIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1ExportWalletAccountRequestToJson(
        V1ExportWalletAccountRequest instance) =>
    <String, dynamic>{
      'type': v1ExportWalletAccountRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1ExportWalletAccountResult _$V1ExportWalletAccountResultFromJson(
        Map<String, dynamic> json) =>
    V1ExportWalletAccountResult(
      address: json['address'] as String,
      exportBundle: json['exportBundle'] as String,
    );

Map<String, dynamic> _$V1ExportWalletAccountResultToJson(
        V1ExportWalletAccountResult instance) =>
    <String, dynamic>{
      'address': instance.address,
      'exportBundle': instance.exportBundle,
    };

V1ExportWalletIntent _$V1ExportWalletIntentFromJson(
        Map<String, dynamic> json) =>
    V1ExportWalletIntent(
      walletId: json['walletId'] as String,
      targetPublicKey: json['targetPublicKey'] as String,
      language: v1MnemonicLanguageNullableFromJson(json['language']),
    );

Map<String, dynamic> _$V1ExportWalletIntentToJson(
        V1ExportWalletIntent instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'targetPublicKey': instance.targetPublicKey,
      'language': v1MnemonicLanguageNullableToJson(instance.language),
    };

V1ExportWalletRequest _$V1ExportWalletRequestFromJson(
        Map<String, dynamic> json) =>
    V1ExportWalletRequest(
      type: v1ExportWalletRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1ExportWalletIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1ExportWalletRequestToJson(
        V1ExportWalletRequest instance) =>
    <String, dynamic>{
      'type': v1ExportWalletRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1ExportWalletResult _$V1ExportWalletResultFromJson(
        Map<String, dynamic> json) =>
    V1ExportWalletResult(
      walletId: json['walletId'] as String,
      exportBundle: json['exportBundle'] as String,
    );

Map<String, dynamic> _$V1ExportWalletResultToJson(
        V1ExportWalletResult instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'exportBundle': instance.exportBundle,
    };

V1Feature _$V1FeatureFromJson(Map<String, dynamic> json) => V1Feature(
      name: v1FeatureNameNullableFromJson(json['name']),
      $value: json['value'] as String?,
    );

Map<String, dynamic> _$V1FeatureToJson(V1Feature instance) => <String, dynamic>{
      'name': v1FeatureNameNullableToJson(instance.name),
      'value': instance.$value,
    };

V1GetActivitiesRequest _$V1GetActivitiesRequestFromJson(
        Map<String, dynamic> json) =>
    V1GetActivitiesRequest(
      organizationId: json['organizationId'] as String,
      filterByStatus:
          v1ActivityStatusListFromJson(json['filterByStatus'] as List?),
      paginationOptions: json['paginationOptions'] == null
          ? null
          : V1Pagination.fromJson(
              json['paginationOptions'] as Map<String, dynamic>),
      filterByType: v1ActivityTypeListFromJson(json['filterByType'] as List?),
    );

Map<String, dynamic> _$V1GetActivitiesRequestToJson(
        V1GetActivitiesRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'filterByStatus': v1ActivityStatusListToJson(instance.filterByStatus),
      'paginationOptions': instance.paginationOptions?.toJson(),
      'filterByType': v1ActivityTypeListToJson(instance.filterByType),
    };

V1GetActivitiesResponse _$V1GetActivitiesResponseFromJson(
        Map<String, dynamic> json) =>
    V1GetActivitiesResponse(
      activities: (json['activities'] as List<dynamic>?)
              ?.map((e) => V1Activity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1GetActivitiesResponseToJson(
        V1GetActivitiesResponse instance) =>
    <String, dynamic>{
      'activities': instance.activities.map((e) => e.toJson()).toList(),
    };

V1GetActivityRequest _$V1GetActivityRequestFromJson(
        Map<String, dynamic> json) =>
    V1GetActivityRequest(
      organizationId: json['organizationId'] as String,
      activityId: json['activityId'] as String,
    );

Map<String, dynamic> _$V1GetActivityRequestToJson(
        V1GetActivityRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'activityId': instance.activityId,
    };

V1GetApiKeyRequest _$V1GetApiKeyRequestFromJson(Map<String, dynamic> json) =>
    V1GetApiKeyRequest(
      organizationId: json['organizationId'] as String,
      apiKeyId: json['apiKeyId'] as String,
    );

Map<String, dynamic> _$V1GetApiKeyRequestToJson(V1GetApiKeyRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'apiKeyId': instance.apiKeyId,
    };

V1GetApiKeyResponse _$V1GetApiKeyResponseFromJson(Map<String, dynamic> json) =>
    V1GetApiKeyResponse(
      apiKey: V1ApiKey.fromJson(json['apiKey'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1GetApiKeyResponseToJson(
        V1GetApiKeyResponse instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey.toJson(),
    };

V1GetApiKeysRequest _$V1GetApiKeysRequestFromJson(Map<String, dynamic> json) =>
    V1GetApiKeysRequest(
      organizationId: json['organizationId'] as String,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$V1GetApiKeysRequestToJson(
        V1GetApiKeysRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'userId': instance.userId,
    };

V1GetApiKeysResponse _$V1GetApiKeysResponseFromJson(
        Map<String, dynamic> json) =>
    V1GetApiKeysResponse(
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => V1ApiKey.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1GetApiKeysResponseToJson(
        V1GetApiKeysResponse instance) =>
    <String, dynamic>{
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
    };

V1GetAttestationDocumentRequest _$V1GetAttestationDocumentRequestFromJson(
        Map<String, dynamic> json) =>
    V1GetAttestationDocumentRequest(
      organizationId: json['organizationId'] as String,
      enclaveType: json['enclaveType'] as String,
    );

Map<String, dynamic> _$V1GetAttestationDocumentRequestToJson(
        V1GetAttestationDocumentRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'enclaveType': instance.enclaveType,
    };

V1GetAttestationDocumentResponse _$V1GetAttestationDocumentResponseFromJson(
        Map<String, dynamic> json) =>
    V1GetAttestationDocumentResponse(
      attestationDocument: json['attestationDocument'] as String,
    );

Map<String, dynamic> _$V1GetAttestationDocumentResponseToJson(
        V1GetAttestationDocumentResponse instance) =>
    <String, dynamic>{
      'attestationDocument': instance.attestationDocument,
    };

V1GetAuthenticatorRequest _$V1GetAuthenticatorRequestFromJson(
        Map<String, dynamic> json) =>
    V1GetAuthenticatorRequest(
      organizationId: json['organizationId'] as String,
      authenticatorId: json['authenticatorId'] as String,
    );

Map<String, dynamic> _$V1GetAuthenticatorRequestToJson(
        V1GetAuthenticatorRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'authenticatorId': instance.authenticatorId,
    };

V1GetAuthenticatorResponse _$V1GetAuthenticatorResponseFromJson(
        Map<String, dynamic> json) =>
    V1GetAuthenticatorResponse(
      authenticator: V1Authenticator.fromJson(
          json['authenticator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1GetAuthenticatorResponseToJson(
        V1GetAuthenticatorResponse instance) =>
    <String, dynamic>{
      'authenticator': instance.authenticator.toJson(),
    };

V1GetAuthenticatorsRequest _$V1GetAuthenticatorsRequestFromJson(
        Map<String, dynamic> json) =>
    V1GetAuthenticatorsRequest(
      organizationId: json['organizationId'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$V1GetAuthenticatorsRequestToJson(
        V1GetAuthenticatorsRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'userId': instance.userId,
    };

V1GetAuthenticatorsResponse _$V1GetAuthenticatorsResponseFromJson(
        Map<String, dynamic> json) =>
    V1GetAuthenticatorsResponse(
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) => V1Authenticator.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1GetAuthenticatorsResponseToJson(
        V1GetAuthenticatorsResponse instance) =>
    <String, dynamic>{
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
    };

V1GetOauthProvidersRequest _$V1GetOauthProvidersRequestFromJson(
        Map<String, dynamic> json) =>
    V1GetOauthProvidersRequest(
      organizationId: json['organizationId'] as String,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$V1GetOauthProvidersRequestToJson(
        V1GetOauthProvidersRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'userId': instance.userId,
    };

V1GetOauthProvidersResponse _$V1GetOauthProvidersResponseFromJson(
        Map<String, dynamic> json) =>
    V1GetOauthProvidersResponse(
      oauthProviders: (json['oauthProviders'] as List<dynamic>?)
              ?.map((e) => V1OauthProvider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1GetOauthProvidersResponseToJson(
        V1GetOauthProvidersResponse instance) =>
    <String, dynamic>{
      'oauthProviders': instance.oauthProviders.map((e) => e.toJson()).toList(),
    };

V1GetOrganizationConfigsRequest _$V1GetOrganizationConfigsRequestFromJson(
        Map<String, dynamic> json) =>
    V1GetOrganizationConfigsRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$V1GetOrganizationConfigsRequestToJson(
        V1GetOrganizationConfigsRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

V1GetOrganizationConfigsResponse _$V1GetOrganizationConfigsResponseFromJson(
        Map<String, dynamic> json) =>
    V1GetOrganizationConfigsResponse(
      configs: V1Config.fromJson(json['configs'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1GetOrganizationConfigsResponseToJson(
        V1GetOrganizationConfigsResponse instance) =>
    <String, dynamic>{
      'configs': instance.configs.toJson(),
    };

V1GetOrganizationRequest _$V1GetOrganizationRequestFromJson(
        Map<String, dynamic> json) =>
    V1GetOrganizationRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$V1GetOrganizationRequestToJson(
        V1GetOrganizationRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

V1GetOrganizationResponse _$V1GetOrganizationResponseFromJson(
        Map<String, dynamic> json) =>
    V1GetOrganizationResponse(
      organizationData: V1OrganizationData.fromJson(
          json['organizationData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1GetOrganizationResponseToJson(
        V1GetOrganizationResponse instance) =>
    <String, dynamic>{
      'organizationData': instance.organizationData.toJson(),
    };

V1GetPoliciesRequest _$V1GetPoliciesRequestFromJson(
        Map<String, dynamic> json) =>
    V1GetPoliciesRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$V1GetPoliciesRequestToJson(
        V1GetPoliciesRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

V1GetPoliciesResponse _$V1GetPoliciesResponseFromJson(
        Map<String, dynamic> json) =>
    V1GetPoliciesResponse(
      policies: (json['policies'] as List<dynamic>?)
              ?.map((e) => V1Policy.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1GetPoliciesResponseToJson(
        V1GetPoliciesResponse instance) =>
    <String, dynamic>{
      'policies': instance.policies.map((e) => e.toJson()).toList(),
    };

V1GetPolicyRequest _$V1GetPolicyRequestFromJson(Map<String, dynamic> json) =>
    V1GetPolicyRequest(
      organizationId: json['organizationId'] as String,
      policyId: json['policyId'] as String,
    );

Map<String, dynamic> _$V1GetPolicyRequestToJson(V1GetPolicyRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'policyId': instance.policyId,
    };

V1GetPolicyResponse _$V1GetPolicyResponseFromJson(Map<String, dynamic> json) =>
    V1GetPolicyResponse(
      policy: V1Policy.fromJson(json['policy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1GetPolicyResponseToJson(
        V1GetPolicyResponse instance) =>
    <String, dynamic>{
      'policy': instance.policy.toJson(),
    };

V1GetPrivateKeyRequest _$V1GetPrivateKeyRequestFromJson(
        Map<String, dynamic> json) =>
    V1GetPrivateKeyRequest(
      organizationId: json['organizationId'] as String,
      privateKeyId: json['privateKeyId'] as String,
    );

Map<String, dynamic> _$V1GetPrivateKeyRequestToJson(
        V1GetPrivateKeyRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'privateKeyId': instance.privateKeyId,
    };

V1GetPrivateKeyResponse _$V1GetPrivateKeyResponseFromJson(
        Map<String, dynamic> json) =>
    V1GetPrivateKeyResponse(
      privateKey:
          V1PrivateKey.fromJson(json['privateKey'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1GetPrivateKeyResponseToJson(
        V1GetPrivateKeyResponse instance) =>
    <String, dynamic>{
      'privateKey': instance.privateKey.toJson(),
    };

V1GetPrivateKeysRequest _$V1GetPrivateKeysRequestFromJson(
        Map<String, dynamic> json) =>
    V1GetPrivateKeysRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$V1GetPrivateKeysRequestToJson(
        V1GetPrivateKeysRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

V1GetPrivateKeysResponse _$V1GetPrivateKeysResponseFromJson(
        Map<String, dynamic> json) =>
    V1GetPrivateKeysResponse(
      privateKeys: (json['privateKeys'] as List<dynamic>?)
              ?.map((e) => V1PrivateKey.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1GetPrivateKeysResponseToJson(
        V1GetPrivateKeysResponse instance) =>
    <String, dynamic>{
      'privateKeys': instance.privateKeys.map((e) => e.toJson()).toList(),
    };

V1GetSubOrgIdsRequest _$V1GetSubOrgIdsRequestFromJson(
        Map<String, dynamic> json) =>
    V1GetSubOrgIdsRequest(
      organizationId: json['organizationId'] as String,
      filterType: json['filterType'] as String?,
      filterValue: json['filterValue'] as String?,
      paginationOptions: json['paginationOptions'] == null
          ? null
          : V1Pagination.fromJson(
              json['paginationOptions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1GetSubOrgIdsRequestToJson(
        V1GetSubOrgIdsRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'filterType': instance.filterType,
      'filterValue': instance.filterValue,
      'paginationOptions': instance.paginationOptions?.toJson(),
    };

V1GetSubOrgIdsResponse _$V1GetSubOrgIdsResponseFromJson(
        Map<String, dynamic> json) =>
    V1GetSubOrgIdsResponse(
      organizationIds: (json['organizationIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1GetSubOrgIdsResponseToJson(
        V1GetSubOrgIdsResponse instance) =>
    <String, dynamic>{
      'organizationIds': instance.organizationIds,
    };

V1GetUserRequest _$V1GetUserRequestFromJson(Map<String, dynamic> json) =>
    V1GetUserRequest(
      organizationId: json['organizationId'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$V1GetUserRequestToJson(V1GetUserRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'userId': instance.userId,
    };

V1GetUserResponse _$V1GetUserResponseFromJson(Map<String, dynamic> json) =>
    V1GetUserResponse(
      user: V1User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1GetUserResponseToJson(V1GetUserResponse instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
    };

V1GetUsersRequest _$V1GetUsersRequestFromJson(Map<String, dynamic> json) =>
    V1GetUsersRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$V1GetUsersRequestToJson(V1GetUsersRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

V1GetUsersResponse _$V1GetUsersResponseFromJson(Map<String, dynamic> json) =>
    V1GetUsersResponse(
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => V1User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1GetUsersResponseToJson(V1GetUsersResponse instance) =>
    <String, dynamic>{
      'users': instance.users.map((e) => e.toJson()).toList(),
    };

V1GetVerifiedSubOrgIdsRequest _$V1GetVerifiedSubOrgIdsRequestFromJson(
        Map<String, dynamic> json) =>
    V1GetVerifiedSubOrgIdsRequest(
      organizationId: json['organizationId'] as String,
      filterType: json['filterType'] as String?,
      filterValue: json['filterValue'] as String?,
      paginationOptions: json['paginationOptions'] == null
          ? null
          : V1Pagination.fromJson(
              json['paginationOptions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1GetVerifiedSubOrgIdsRequestToJson(
        V1GetVerifiedSubOrgIdsRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'filterType': instance.filterType,
      'filterValue': instance.filterValue,
      'paginationOptions': instance.paginationOptions?.toJson(),
    };

V1GetVerifiedSubOrgIdsResponse _$V1GetVerifiedSubOrgIdsResponseFromJson(
        Map<String, dynamic> json) =>
    V1GetVerifiedSubOrgIdsResponse(
      organizationIds: (json['organizationIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1GetVerifiedSubOrgIdsResponseToJson(
        V1GetVerifiedSubOrgIdsResponse instance) =>
    <String, dynamic>{
      'organizationIds': instance.organizationIds,
    };

V1GetWalletAccountsRequest _$V1GetWalletAccountsRequestFromJson(
        Map<String, dynamic> json) =>
    V1GetWalletAccountsRequest(
      organizationId: json['organizationId'] as String,
      walletId: json['walletId'] as String,
      paginationOptions: json['paginationOptions'] == null
          ? null
          : V1Pagination.fromJson(
              json['paginationOptions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1GetWalletAccountsRequestToJson(
        V1GetWalletAccountsRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'walletId': instance.walletId,
      'paginationOptions': instance.paginationOptions?.toJson(),
    };

V1GetWalletAccountsResponse _$V1GetWalletAccountsResponseFromJson(
        Map<String, dynamic> json) =>
    V1GetWalletAccountsResponse(
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) => V1WalletAccount.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1GetWalletAccountsResponseToJson(
        V1GetWalletAccountsResponse instance) =>
    <String, dynamic>{
      'accounts': instance.accounts.map((e) => e.toJson()).toList(),
    };

V1GetWalletRequest _$V1GetWalletRequestFromJson(Map<String, dynamic> json) =>
    V1GetWalletRequest(
      organizationId: json['organizationId'] as String,
      walletId: json['walletId'] as String,
    );

Map<String, dynamic> _$V1GetWalletRequestToJson(V1GetWalletRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'walletId': instance.walletId,
    };

V1GetWalletResponse _$V1GetWalletResponseFromJson(Map<String, dynamic> json) =>
    V1GetWalletResponse(
      wallet: V1Wallet.fromJson(json['wallet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1GetWalletResponseToJson(
        V1GetWalletResponse instance) =>
    <String, dynamic>{
      'wallet': instance.wallet.toJson(),
    };

V1GetWalletsRequest _$V1GetWalletsRequestFromJson(Map<String, dynamic> json) =>
    V1GetWalletsRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$V1GetWalletsRequestToJson(
        V1GetWalletsRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

V1GetWalletsResponse _$V1GetWalletsResponseFromJson(
        Map<String, dynamic> json) =>
    V1GetWalletsResponse(
      wallets: (json['wallets'] as List<dynamic>?)
              ?.map((e) => V1Wallet.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1GetWalletsResponseToJson(
        V1GetWalletsResponse instance) =>
    <String, dynamic>{
      'wallets': instance.wallets.map((e) => e.toJson()).toList(),
    };

V1GetWhoamiRequest _$V1GetWhoamiRequestFromJson(Map<String, dynamic> json) =>
    V1GetWhoamiRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$V1GetWhoamiRequestToJson(V1GetWhoamiRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

V1GetWhoamiResponse _$V1GetWhoamiResponseFromJson(Map<String, dynamic> json) =>
    V1GetWhoamiResponse(
      organizationId: json['organizationId'] as String,
      organizationName: json['organizationName'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$V1GetWhoamiResponseToJson(
        V1GetWhoamiResponse instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'organizationName': instance.organizationName,
      'userId': instance.userId,
      'username': instance.username,
    };

V1ImportPrivateKeyIntent _$V1ImportPrivateKeyIntentFromJson(
        Map<String, dynamic> json) =>
    V1ImportPrivateKeyIntent(
      userId: json['userId'] as String,
      privateKeyName: json['privateKeyName'] as String,
      encryptedBundle: json['encryptedBundle'] as String,
      curve: v1CurveFromJson(json['curve']),
      addressFormats:
          v1AddressFormatListFromJson(json['addressFormats'] as List?),
    );

Map<String, dynamic> _$V1ImportPrivateKeyIntentToJson(
        V1ImportPrivateKeyIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'privateKeyName': instance.privateKeyName,
      'encryptedBundle': instance.encryptedBundle,
      'curve': v1CurveToJson(instance.curve),
      'addressFormats': v1AddressFormatListToJson(instance.addressFormats),
    };

V1ImportPrivateKeyRequest _$V1ImportPrivateKeyRequestFromJson(
        Map<String, dynamic> json) =>
    V1ImportPrivateKeyRequest(
      type: v1ImportPrivateKeyRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1ImportPrivateKeyIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1ImportPrivateKeyRequestToJson(
        V1ImportPrivateKeyRequest instance) =>
    <String, dynamic>{
      'type': v1ImportPrivateKeyRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1ImportPrivateKeyResult _$V1ImportPrivateKeyResultFromJson(
        Map<String, dynamic> json) =>
    V1ImportPrivateKeyResult(
      privateKeyId: json['privateKeyId'] as String,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => Immutableactivityv1Address.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1ImportPrivateKeyResultToJson(
        V1ImportPrivateKeyResult instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
      'addresses': instance.addresses.map((e) => e.toJson()).toList(),
    };

V1ImportWalletIntent _$V1ImportWalletIntentFromJson(
        Map<String, dynamic> json) =>
    V1ImportWalletIntent(
      userId: json['userId'] as String,
      walletName: json['walletName'] as String,
      encryptedBundle: json['encryptedBundle'] as String,
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) =>
                  V1WalletAccountParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1ImportWalletIntentToJson(
        V1ImportWalletIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'walletName': instance.walletName,
      'encryptedBundle': instance.encryptedBundle,
      'accounts': instance.accounts.map((e) => e.toJson()).toList(),
    };

V1ImportWalletRequest _$V1ImportWalletRequestFromJson(
        Map<String, dynamic> json) =>
    V1ImportWalletRequest(
      type: v1ImportWalletRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1ImportWalletIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1ImportWalletRequestToJson(
        V1ImportWalletRequest instance) =>
    <String, dynamic>{
      'type': v1ImportWalletRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1ImportWalletResult _$V1ImportWalletResultFromJson(
        Map<String, dynamic> json) =>
    V1ImportWalletResult(
      walletId: json['walletId'] as String,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1ImportWalletResultToJson(
        V1ImportWalletResult instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'addresses': instance.addresses,
    };

V1InitImportPrivateKeyIntent _$V1InitImportPrivateKeyIntentFromJson(
        Map<String, dynamic> json) =>
    V1InitImportPrivateKeyIntent(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$V1InitImportPrivateKeyIntentToJson(
        V1InitImportPrivateKeyIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

V1InitImportPrivateKeyRequest _$V1InitImportPrivateKeyRequestFromJson(
        Map<String, dynamic> json) =>
    V1InitImportPrivateKeyRequest(
      type: v1InitImportPrivateKeyRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1InitImportPrivateKeyIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1InitImportPrivateKeyRequestToJson(
        V1InitImportPrivateKeyRequest instance) =>
    <String, dynamic>{
      'type': v1InitImportPrivateKeyRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1InitImportPrivateKeyResult _$V1InitImportPrivateKeyResultFromJson(
        Map<String, dynamic> json) =>
    V1InitImportPrivateKeyResult(
      importBundle: json['importBundle'] as String,
    );

Map<String, dynamic> _$V1InitImportPrivateKeyResultToJson(
        V1InitImportPrivateKeyResult instance) =>
    <String, dynamic>{
      'importBundle': instance.importBundle,
    };

V1InitImportWalletIntent _$V1InitImportWalletIntentFromJson(
        Map<String, dynamic> json) =>
    V1InitImportWalletIntent(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$V1InitImportWalletIntentToJson(
        V1InitImportWalletIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

V1InitImportWalletRequest _$V1InitImportWalletRequestFromJson(
        Map<String, dynamic> json) =>
    V1InitImportWalletRequest(
      type: v1InitImportWalletRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1InitImportWalletIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1InitImportWalletRequestToJson(
        V1InitImportWalletRequest instance) =>
    <String, dynamic>{
      'type': v1InitImportWalletRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1InitImportWalletResult _$V1InitImportWalletResultFromJson(
        Map<String, dynamic> json) =>
    V1InitImportWalletResult(
      importBundle: json['importBundle'] as String,
    );

Map<String, dynamic> _$V1InitImportWalletResultToJson(
        V1InitImportWalletResult instance) =>
    <String, dynamic>{
      'importBundle': instance.importBundle,
    };

V1InitOtpAuthIntent _$V1InitOtpAuthIntentFromJson(Map<String, dynamic> json) =>
    V1InitOtpAuthIntent(
      otpType: json['otpType'] as String,
      contact: json['contact'] as String,
      emailCustomization: json['emailCustomization'] == null
          ? null
          : V1EmailCustomizationParams.fromJson(
              json['emailCustomization'] as Map<String, dynamic>),
      smsCustomization: json['smsCustomization'] == null
          ? null
          : V1SmsCustomizationParams.fromJson(
              json['smsCustomization'] as Map<String, dynamic>),
      userIdentifier: json['userIdentifier'] as String?,
    );

Map<String, dynamic> _$V1InitOtpAuthIntentToJson(
        V1InitOtpAuthIntent instance) =>
    <String, dynamic>{
      'otpType': instance.otpType,
      'contact': instance.contact,
      'emailCustomization': instance.emailCustomization?.toJson(),
      'smsCustomization': instance.smsCustomization?.toJson(),
      'userIdentifier': instance.userIdentifier,
    };

V1InitOtpAuthRequest _$V1InitOtpAuthRequestFromJson(
        Map<String, dynamic> json) =>
    V1InitOtpAuthRequest(
      type: v1InitOtpAuthRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1InitOtpAuthIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1InitOtpAuthRequestToJson(
        V1InitOtpAuthRequest instance) =>
    <String, dynamic>{
      'type': v1InitOtpAuthRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1InitOtpAuthResult _$V1InitOtpAuthResultFromJson(Map<String, dynamic> json) =>
    V1InitOtpAuthResult(
      otpId: json['otpId'] as String,
    );

Map<String, dynamic> _$V1InitOtpAuthResultToJson(
        V1InitOtpAuthResult instance) =>
    <String, dynamic>{
      'otpId': instance.otpId,
    };

V1InitUserEmailRecoveryIntent _$V1InitUserEmailRecoveryIntentFromJson(
        Map<String, dynamic> json) =>
    V1InitUserEmailRecoveryIntent(
      email: json['email'] as String,
      targetPublicKey: json['targetPublicKey'] as String,
      expirationSeconds: json['expirationSeconds'] as String?,
      emailCustomization: json['emailCustomization'] == null
          ? null
          : V1EmailCustomizationParams.fromJson(
              json['emailCustomization'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1InitUserEmailRecoveryIntentToJson(
        V1InitUserEmailRecoveryIntent instance) =>
    <String, dynamic>{
      'email': instance.email,
      'targetPublicKey': instance.targetPublicKey,
      'expirationSeconds': instance.expirationSeconds,
      'emailCustomization': instance.emailCustomization?.toJson(),
    };

V1InitUserEmailRecoveryRequest _$V1InitUserEmailRecoveryRequestFromJson(
        Map<String, dynamic> json) =>
    V1InitUserEmailRecoveryRequest(
      type: v1InitUserEmailRecoveryRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1InitUserEmailRecoveryIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1InitUserEmailRecoveryRequestToJson(
        V1InitUserEmailRecoveryRequest instance) =>
    <String, dynamic>{
      'type': v1InitUserEmailRecoveryRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1InitUserEmailRecoveryResult _$V1InitUserEmailRecoveryResultFromJson(
        Map<String, dynamic> json) =>
    V1InitUserEmailRecoveryResult(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$V1InitUserEmailRecoveryResultToJson(
        V1InitUserEmailRecoveryResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

V1Intent _$V1IntentFromJson(Map<String, dynamic> json) => V1Intent(
      createOrganizationIntent: json['createOrganizationIntent'] == null
          ? null
          : V1CreateOrganizationIntent.fromJson(
              json['createOrganizationIntent'] as Map<String, dynamic>),
      createAuthenticatorsIntent: json['createAuthenticatorsIntent'] == null
          ? null
          : V1CreateAuthenticatorsIntent.fromJson(
              json['createAuthenticatorsIntent'] as Map<String, dynamic>),
      createUsersIntent: json['createUsersIntent'] == null
          ? null
          : V1CreateUsersIntent.fromJson(
              json['createUsersIntent'] as Map<String, dynamic>),
      createPrivateKeysIntent: json['createPrivateKeysIntent'] == null
          ? null
          : V1CreatePrivateKeysIntent.fromJson(
              json['createPrivateKeysIntent'] as Map<String, dynamic>),
      signRawPayloadIntent: json['signRawPayloadIntent'] == null
          ? null
          : V1SignRawPayloadIntent.fromJson(
              json['signRawPayloadIntent'] as Map<String, dynamic>),
      createInvitationsIntent: json['createInvitationsIntent'] == null
          ? null
          : V1CreateInvitationsIntent.fromJson(
              json['createInvitationsIntent'] as Map<String, dynamic>),
      acceptInvitationIntent: json['acceptInvitationIntent'] == null
          ? null
          : V1AcceptInvitationIntent.fromJson(
              json['acceptInvitationIntent'] as Map<String, dynamic>),
      createPolicyIntent: json['createPolicyIntent'] == null
          ? null
          : V1CreatePolicyIntent.fromJson(
              json['createPolicyIntent'] as Map<String, dynamic>),
      disablePrivateKeyIntent: json['disablePrivateKeyIntent'] == null
          ? null
          : V1DisablePrivateKeyIntent.fromJson(
              json['disablePrivateKeyIntent'] as Map<String, dynamic>),
      deleteUsersIntent: json['deleteUsersIntent'] == null
          ? null
          : V1DeleteUsersIntent.fromJson(
              json['deleteUsersIntent'] as Map<String, dynamic>),
      deleteAuthenticatorsIntent: json['deleteAuthenticatorsIntent'] == null
          ? null
          : V1DeleteAuthenticatorsIntent.fromJson(
              json['deleteAuthenticatorsIntent'] as Map<String, dynamic>),
      deleteInvitationIntent: json['deleteInvitationIntent'] == null
          ? null
          : V1DeleteInvitationIntent.fromJson(
              json['deleteInvitationIntent'] as Map<String, dynamic>),
      deleteOrganizationIntent: json['deleteOrganizationIntent'] == null
          ? null
          : V1DeleteOrganizationIntent.fromJson(
              json['deleteOrganizationIntent'] as Map<String, dynamic>),
      deletePolicyIntent: json['deletePolicyIntent'] == null
          ? null
          : V1DeletePolicyIntent.fromJson(
              json['deletePolicyIntent'] as Map<String, dynamic>),
      createUserTagIntent: json['createUserTagIntent'] == null
          ? null
          : V1CreateUserTagIntent.fromJson(
              json['createUserTagIntent'] as Map<String, dynamic>),
      deleteUserTagsIntent: json['deleteUserTagsIntent'] == null
          ? null
          : V1DeleteUserTagsIntent.fromJson(
              json['deleteUserTagsIntent'] as Map<String, dynamic>),
      signTransactionIntent: json['signTransactionIntent'] == null
          ? null
          : V1SignTransactionIntent.fromJson(
              json['signTransactionIntent'] as Map<String, dynamic>),
      createApiKeysIntent: json['createApiKeysIntent'] == null
          ? null
          : V1CreateApiKeysIntent.fromJson(
              json['createApiKeysIntent'] as Map<String, dynamic>),
      deleteApiKeysIntent: json['deleteApiKeysIntent'] == null
          ? null
          : V1DeleteApiKeysIntent.fromJson(
              json['deleteApiKeysIntent'] as Map<String, dynamic>),
      approveActivityIntent: json['approveActivityIntent'] == null
          ? null
          : V1ApproveActivityIntent.fromJson(
              json['approveActivityIntent'] as Map<String, dynamic>),
      rejectActivityIntent: json['rejectActivityIntent'] == null
          ? null
          : V1RejectActivityIntent.fromJson(
              json['rejectActivityIntent'] as Map<String, dynamic>),
      createPrivateKeyTagIntent: json['createPrivateKeyTagIntent'] == null
          ? null
          : V1CreatePrivateKeyTagIntent.fromJson(
              json['createPrivateKeyTagIntent'] as Map<String, dynamic>),
      deletePrivateKeyTagsIntent: json['deletePrivateKeyTagsIntent'] == null
          ? null
          : V1DeletePrivateKeyTagsIntent.fromJson(
              json['deletePrivateKeyTagsIntent'] as Map<String, dynamic>),
      createPolicyIntentV2: json['createPolicyIntentV2'] == null
          ? null
          : V1CreatePolicyIntentV2.fromJson(
              json['createPolicyIntentV2'] as Map<String, dynamic>),
      setPaymentMethodIntent: json['setPaymentMethodIntent'] == null
          ? null
          : BillingSetPaymentMethodIntent.fromJson(
              json['setPaymentMethodIntent'] as Map<String, dynamic>),
      activateBillingTierIntent: json['activateBillingTierIntent'] == null
          ? null
          : BillingActivateBillingTierIntent.fromJson(
              json['activateBillingTierIntent'] as Map<String, dynamic>),
      deletePaymentMethodIntent: json['deletePaymentMethodIntent'] == null
          ? null
          : BillingDeletePaymentMethodIntent.fromJson(
              json['deletePaymentMethodIntent'] as Map<String, dynamic>),
      createPolicyIntentV3: json['createPolicyIntentV3'] == null
          ? null
          : V1CreatePolicyIntentV3.fromJson(
              json['createPolicyIntentV3'] as Map<String, dynamic>),
      createApiOnlyUsersIntent: json['createApiOnlyUsersIntent'] == null
          ? null
          : V1CreateApiOnlyUsersIntent.fromJson(
              json['createApiOnlyUsersIntent'] as Map<String, dynamic>),
      updateRootQuorumIntent: json['updateRootQuorumIntent'] == null
          ? null
          : V1UpdateRootQuorumIntent.fromJson(
              json['updateRootQuorumIntent'] as Map<String, dynamic>),
      updateUserTagIntent: json['updateUserTagIntent'] == null
          ? null
          : V1UpdateUserTagIntent.fromJson(
              json['updateUserTagIntent'] as Map<String, dynamic>),
      updatePrivateKeyTagIntent: json['updatePrivateKeyTagIntent'] == null
          ? null
          : V1UpdatePrivateKeyTagIntent.fromJson(
              json['updatePrivateKeyTagIntent'] as Map<String, dynamic>),
      createAuthenticatorsIntentV2: json['createAuthenticatorsIntentV2'] == null
          ? null
          : V1CreateAuthenticatorsIntentV2.fromJson(
              json['createAuthenticatorsIntentV2'] as Map<String, dynamic>),
      acceptInvitationIntentV2: json['acceptInvitationIntentV2'] == null
          ? null
          : V1AcceptInvitationIntentV2.fromJson(
              json['acceptInvitationIntentV2'] as Map<String, dynamic>),
      createOrganizationIntentV2: json['createOrganizationIntentV2'] == null
          ? null
          : V1CreateOrganizationIntentV2.fromJson(
              json['createOrganizationIntentV2'] as Map<String, dynamic>),
      createUsersIntentV2: json['createUsersIntentV2'] == null
          ? null
          : V1CreateUsersIntentV2.fromJson(
              json['createUsersIntentV2'] as Map<String, dynamic>),
      createSubOrganizationIntent: json['createSubOrganizationIntent'] == null
          ? null
          : V1CreateSubOrganizationIntent.fromJson(
              json['createSubOrganizationIntent'] as Map<String, dynamic>),
      createSubOrganizationIntentV2: json['createSubOrganizationIntentV2'] ==
              null
          ? null
          : V1CreateSubOrganizationIntentV2.fromJson(
              json['createSubOrganizationIntentV2'] as Map<String, dynamic>),
      updateAllowedOriginsIntent: json['updateAllowedOriginsIntent'] == null
          ? null
          : V1UpdateAllowedOriginsIntent.fromJson(
              json['updateAllowedOriginsIntent'] as Map<String, dynamic>),
      createPrivateKeysIntentV2: json['createPrivateKeysIntentV2'] == null
          ? null
          : V1CreatePrivateKeysIntentV2.fromJson(
              json['createPrivateKeysIntentV2'] as Map<String, dynamic>),
      updateUserIntent: json['updateUserIntent'] == null
          ? null
          : V1UpdateUserIntent.fromJson(
              json['updateUserIntent'] as Map<String, dynamic>),
      updatePolicyIntent: json['updatePolicyIntent'] == null
          ? null
          : V1UpdatePolicyIntent.fromJson(
              json['updatePolicyIntent'] as Map<String, dynamic>),
      setPaymentMethodIntentV2: json['setPaymentMethodIntentV2'] == null
          ? null
          : BillingSetPaymentMethodIntentV2.fromJson(
              json['setPaymentMethodIntentV2'] as Map<String, dynamic>),
      createSubOrganizationIntentV3: json['createSubOrganizationIntentV3'] ==
              null
          ? null
          : V1CreateSubOrganizationIntentV3.fromJson(
              json['createSubOrganizationIntentV3'] as Map<String, dynamic>),
      createWalletIntent: json['createWalletIntent'] == null
          ? null
          : V1CreateWalletIntent.fromJson(
              json['createWalletIntent'] as Map<String, dynamic>),
      createWalletAccountsIntent: json['createWalletAccountsIntent'] == null
          ? null
          : V1CreateWalletAccountsIntent.fromJson(
              json['createWalletAccountsIntent'] as Map<String, dynamic>),
      initUserEmailRecoveryIntent: json['initUserEmailRecoveryIntent'] == null
          ? null
          : V1InitUserEmailRecoveryIntent.fromJson(
              json['initUserEmailRecoveryIntent'] as Map<String, dynamic>),
      recoverUserIntent: json['recoverUserIntent'] == null
          ? null
          : V1RecoverUserIntent.fromJson(
              json['recoverUserIntent'] as Map<String, dynamic>),
      setOrganizationFeatureIntent: json['setOrganizationFeatureIntent'] == null
          ? null
          : V1SetOrganizationFeatureIntent.fromJson(
              json['setOrganizationFeatureIntent'] as Map<String, dynamic>),
      removeOrganizationFeatureIntent:
          json['removeOrganizationFeatureIntent'] == null
              ? null
              : V1RemoveOrganizationFeatureIntent.fromJson(
                  json['removeOrganizationFeatureIntent']
                      as Map<String, dynamic>),
      signRawPayloadIntentV2: json['signRawPayloadIntentV2'] == null
          ? null
          : V1SignRawPayloadIntentV2.fromJson(
              json['signRawPayloadIntentV2'] as Map<String, dynamic>),
      signTransactionIntentV2: json['signTransactionIntentV2'] == null
          ? null
          : V1SignTransactionIntentV2.fromJson(
              json['signTransactionIntentV2'] as Map<String, dynamic>),
      exportPrivateKeyIntent: json['exportPrivateKeyIntent'] == null
          ? null
          : V1ExportPrivateKeyIntent.fromJson(
              json['exportPrivateKeyIntent'] as Map<String, dynamic>),
      exportWalletIntent: json['exportWalletIntent'] == null
          ? null
          : V1ExportWalletIntent.fromJson(
              json['exportWalletIntent'] as Map<String, dynamic>),
      createSubOrganizationIntentV4: json['createSubOrganizationIntentV4'] ==
              null
          ? null
          : V1CreateSubOrganizationIntentV4.fromJson(
              json['createSubOrganizationIntentV4'] as Map<String, dynamic>),
      emailAuthIntent: json['emailAuthIntent'] == null
          ? null
          : V1EmailAuthIntent.fromJson(
              json['emailAuthIntent'] as Map<String, dynamic>),
      exportWalletAccountIntent: json['exportWalletAccountIntent'] == null
          ? null
          : V1ExportWalletAccountIntent.fromJson(
              json['exportWalletAccountIntent'] as Map<String, dynamic>),
      initImportWalletIntent: json['initImportWalletIntent'] == null
          ? null
          : V1InitImportWalletIntent.fromJson(
              json['initImportWalletIntent'] as Map<String, dynamic>),
      importWalletIntent: json['importWalletIntent'] == null
          ? null
          : V1ImportWalletIntent.fromJson(
              json['importWalletIntent'] as Map<String, dynamic>),
      initImportPrivateKeyIntent: json['initImportPrivateKeyIntent'] == null
          ? null
          : V1InitImportPrivateKeyIntent.fromJson(
              json['initImportPrivateKeyIntent'] as Map<String, dynamic>),
      importPrivateKeyIntent: json['importPrivateKeyIntent'] == null
          ? null
          : V1ImportPrivateKeyIntent.fromJson(
              json['importPrivateKeyIntent'] as Map<String, dynamic>),
      createPoliciesIntent: json['createPoliciesIntent'] == null
          ? null
          : V1CreatePoliciesIntent.fromJson(
              json['createPoliciesIntent'] as Map<String, dynamic>),
      signRawPayloadsIntent: json['signRawPayloadsIntent'] == null
          ? null
          : V1SignRawPayloadsIntent.fromJson(
              json['signRawPayloadsIntent'] as Map<String, dynamic>),
      createReadOnlySessionIntent: json['createReadOnlySessionIntent'] == null
          ? null
          : V1CreateReadOnlySessionIntent.fromJson(
              json['createReadOnlySessionIntent'] as Map<String, dynamic>),
      createOauthProvidersIntent: json['createOauthProvidersIntent'] == null
          ? null
          : V1CreateOauthProvidersIntent.fromJson(
              json['createOauthProvidersIntent'] as Map<String, dynamic>),
      deleteOauthProvidersIntent: json['deleteOauthProvidersIntent'] == null
          ? null
          : V1DeleteOauthProvidersIntent.fromJson(
              json['deleteOauthProvidersIntent'] as Map<String, dynamic>),
      createSubOrganizationIntentV5: json['createSubOrganizationIntentV5'] ==
              null
          ? null
          : V1CreateSubOrganizationIntentV5.fromJson(
              json['createSubOrganizationIntentV5'] as Map<String, dynamic>),
      oauthIntent: json['oauthIntent'] == null
          ? null
          : V1OauthIntent.fromJson(json['oauthIntent'] as Map<String, dynamic>),
      createApiKeysIntentV2: json['createApiKeysIntentV2'] == null
          ? null
          : V1CreateApiKeysIntentV2.fromJson(
              json['createApiKeysIntentV2'] as Map<String, dynamic>),
      createReadWriteSessionIntent: json['createReadWriteSessionIntent'] == null
          ? null
          : V1CreateReadWriteSessionIntent.fromJson(
              json['createReadWriteSessionIntent'] as Map<String, dynamic>),
      emailAuthIntentV2: json['emailAuthIntentV2'] == null
          ? null
          : V1EmailAuthIntentV2.fromJson(
              json['emailAuthIntentV2'] as Map<String, dynamic>),
      createSubOrganizationIntentV6: json['createSubOrganizationIntentV6'] ==
              null
          ? null
          : V1CreateSubOrganizationIntentV6.fromJson(
              json['createSubOrganizationIntentV6'] as Map<String, dynamic>),
      deletePrivateKeysIntent: json['deletePrivateKeysIntent'] == null
          ? null
          : V1DeletePrivateKeysIntent.fromJson(
              json['deletePrivateKeysIntent'] as Map<String, dynamic>),
      deleteWalletsIntent: json['deleteWalletsIntent'] == null
          ? null
          : V1DeleteWalletsIntent.fromJson(
              json['deleteWalletsIntent'] as Map<String, dynamic>),
      createReadWriteSessionIntentV2: json['createReadWriteSessionIntentV2'] ==
              null
          ? null
          : V1CreateReadWriteSessionIntentV2.fromJson(
              json['createReadWriteSessionIntentV2'] as Map<String, dynamic>),
      deleteSubOrganizationIntent: json['deleteSubOrganizationIntent'] == null
          ? null
          : V1DeleteSubOrganizationIntent.fromJson(
              json['deleteSubOrganizationIntent'] as Map<String, dynamic>),
      initOtpAuthIntent: json['initOtpAuthIntent'] == null
          ? null
          : V1InitOtpAuthIntent.fromJson(
              json['initOtpAuthIntent'] as Map<String, dynamic>),
      otpAuthIntent: json['otpAuthIntent'] == null
          ? null
          : V1OtpAuthIntent.fromJson(
              json['otpAuthIntent'] as Map<String, dynamic>),
      createSubOrganizationIntentV7: json['createSubOrganizationIntentV7'] ==
              null
          ? null
          : V1CreateSubOrganizationIntentV7.fromJson(
              json['createSubOrganizationIntentV7'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1IntentToJson(V1Intent instance) => <String, dynamic>{
      'createOrganizationIntent': instance.createOrganizationIntent?.toJson(),
      'createAuthenticatorsIntent':
          instance.createAuthenticatorsIntent?.toJson(),
      'createUsersIntent': instance.createUsersIntent?.toJson(),
      'createPrivateKeysIntent': instance.createPrivateKeysIntent?.toJson(),
      'signRawPayloadIntent': instance.signRawPayloadIntent?.toJson(),
      'createInvitationsIntent': instance.createInvitationsIntent?.toJson(),
      'acceptInvitationIntent': instance.acceptInvitationIntent?.toJson(),
      'createPolicyIntent': instance.createPolicyIntent?.toJson(),
      'disablePrivateKeyIntent': instance.disablePrivateKeyIntent?.toJson(),
      'deleteUsersIntent': instance.deleteUsersIntent?.toJson(),
      'deleteAuthenticatorsIntent':
          instance.deleteAuthenticatorsIntent?.toJson(),
      'deleteInvitationIntent': instance.deleteInvitationIntent?.toJson(),
      'deleteOrganizationIntent': instance.deleteOrganizationIntent?.toJson(),
      'deletePolicyIntent': instance.deletePolicyIntent?.toJson(),
      'createUserTagIntent': instance.createUserTagIntent?.toJson(),
      'deleteUserTagsIntent': instance.deleteUserTagsIntent?.toJson(),
      'signTransactionIntent': instance.signTransactionIntent?.toJson(),
      'createApiKeysIntent': instance.createApiKeysIntent?.toJson(),
      'deleteApiKeysIntent': instance.deleteApiKeysIntent?.toJson(),
      'approveActivityIntent': instance.approveActivityIntent?.toJson(),
      'rejectActivityIntent': instance.rejectActivityIntent?.toJson(),
      'createPrivateKeyTagIntent': instance.createPrivateKeyTagIntent?.toJson(),
      'deletePrivateKeyTagsIntent':
          instance.deletePrivateKeyTagsIntent?.toJson(),
      'createPolicyIntentV2': instance.createPolicyIntentV2?.toJson(),
      'setPaymentMethodIntent': instance.setPaymentMethodIntent?.toJson(),
      'activateBillingTierIntent': instance.activateBillingTierIntent?.toJson(),
      'deletePaymentMethodIntent': instance.deletePaymentMethodIntent?.toJson(),
      'createPolicyIntentV3': instance.createPolicyIntentV3?.toJson(),
      'createApiOnlyUsersIntent': instance.createApiOnlyUsersIntent?.toJson(),
      'updateRootQuorumIntent': instance.updateRootQuorumIntent?.toJson(),
      'updateUserTagIntent': instance.updateUserTagIntent?.toJson(),
      'updatePrivateKeyTagIntent': instance.updatePrivateKeyTagIntent?.toJson(),
      'createAuthenticatorsIntentV2':
          instance.createAuthenticatorsIntentV2?.toJson(),
      'acceptInvitationIntentV2': instance.acceptInvitationIntentV2?.toJson(),
      'createOrganizationIntentV2':
          instance.createOrganizationIntentV2?.toJson(),
      'createUsersIntentV2': instance.createUsersIntentV2?.toJson(),
      'createSubOrganizationIntent':
          instance.createSubOrganizationIntent?.toJson(),
      'createSubOrganizationIntentV2':
          instance.createSubOrganizationIntentV2?.toJson(),
      'updateAllowedOriginsIntent':
          instance.updateAllowedOriginsIntent?.toJson(),
      'createPrivateKeysIntentV2': instance.createPrivateKeysIntentV2?.toJson(),
      'updateUserIntent': instance.updateUserIntent?.toJson(),
      'updatePolicyIntent': instance.updatePolicyIntent?.toJson(),
      'setPaymentMethodIntentV2': instance.setPaymentMethodIntentV2?.toJson(),
      'createSubOrganizationIntentV3':
          instance.createSubOrganizationIntentV3?.toJson(),
      'createWalletIntent': instance.createWalletIntent?.toJson(),
      'createWalletAccountsIntent':
          instance.createWalletAccountsIntent?.toJson(),
      'initUserEmailRecoveryIntent':
          instance.initUserEmailRecoveryIntent?.toJson(),
      'recoverUserIntent': instance.recoverUserIntent?.toJson(),
      'setOrganizationFeatureIntent':
          instance.setOrganizationFeatureIntent?.toJson(),
      'removeOrganizationFeatureIntent':
          instance.removeOrganizationFeatureIntent?.toJson(),
      'signRawPayloadIntentV2': instance.signRawPayloadIntentV2?.toJson(),
      'signTransactionIntentV2': instance.signTransactionIntentV2?.toJson(),
      'exportPrivateKeyIntent': instance.exportPrivateKeyIntent?.toJson(),
      'exportWalletIntent': instance.exportWalletIntent?.toJson(),
      'createSubOrganizationIntentV4':
          instance.createSubOrganizationIntentV4?.toJson(),
      'emailAuthIntent': instance.emailAuthIntent?.toJson(),
      'exportWalletAccountIntent': instance.exportWalletAccountIntent?.toJson(),
      'initImportWalletIntent': instance.initImportWalletIntent?.toJson(),
      'importWalletIntent': instance.importWalletIntent?.toJson(),
      'initImportPrivateKeyIntent':
          instance.initImportPrivateKeyIntent?.toJson(),
      'importPrivateKeyIntent': instance.importPrivateKeyIntent?.toJson(),
      'createPoliciesIntent': instance.createPoliciesIntent?.toJson(),
      'signRawPayloadsIntent': instance.signRawPayloadsIntent?.toJson(),
      'createReadOnlySessionIntent':
          instance.createReadOnlySessionIntent?.toJson(),
      'createOauthProvidersIntent':
          instance.createOauthProvidersIntent?.toJson(),
      'deleteOauthProvidersIntent':
          instance.deleteOauthProvidersIntent?.toJson(),
      'createSubOrganizationIntentV5':
          instance.createSubOrganizationIntentV5?.toJson(),
      'oauthIntent': instance.oauthIntent?.toJson(),
      'createApiKeysIntentV2': instance.createApiKeysIntentV2?.toJson(),
      'createReadWriteSessionIntent':
          instance.createReadWriteSessionIntent?.toJson(),
      'emailAuthIntentV2': instance.emailAuthIntentV2?.toJson(),
      'createSubOrganizationIntentV6':
          instance.createSubOrganizationIntentV6?.toJson(),
      'deletePrivateKeysIntent': instance.deletePrivateKeysIntent?.toJson(),
      'deleteWalletsIntent': instance.deleteWalletsIntent?.toJson(),
      'createReadWriteSessionIntentV2':
          instance.createReadWriteSessionIntentV2?.toJson(),
      'deleteSubOrganizationIntent':
          instance.deleteSubOrganizationIntent?.toJson(),
      'initOtpAuthIntent': instance.initOtpAuthIntent?.toJson(),
      'otpAuthIntent': instance.otpAuthIntent?.toJson(),
      'createSubOrganizationIntentV7':
          instance.createSubOrganizationIntentV7?.toJson(),
    };

V1Invitation _$V1InvitationFromJson(Map<String, dynamic> json) => V1Invitation(
      invitationId: json['invitationId'] as String,
      receiverUserName: json['receiverUserName'] as String,
      receiverEmail: json['receiverEmail'] as String,
      receiverUserTags: (json['receiverUserTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      accessType: v1AccessTypeFromJson(json['accessType']),
      status: v1InvitationStatusFromJson(json['status']),
      createdAt: Externaldatav1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: Externaldatav1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
      senderUserId: json['senderUserId'] as String,
    );

Map<String, dynamic> _$V1InvitationToJson(V1Invitation instance) =>
    <String, dynamic>{
      'invitationId': instance.invitationId,
      'receiverUserName': instance.receiverUserName,
      'receiverEmail': instance.receiverEmail,
      'receiverUserTags': instance.receiverUserTags,
      'accessType': v1AccessTypeToJson(instance.accessType),
      'status': v1InvitationStatusToJson(instance.status),
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
      'senderUserId': instance.senderUserId,
    };

V1InvitationParams _$V1InvitationParamsFromJson(Map<String, dynamic> json) =>
    V1InvitationParams(
      receiverUserName: json['receiverUserName'] as String,
      receiverUserEmail: json['receiverUserEmail'] as String,
      receiverUserTags: (json['receiverUserTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      accessType: v1AccessTypeFromJson(json['accessType']),
      senderUserId: json['senderUserId'] as String,
    );

Map<String, dynamic> _$V1InvitationParamsToJson(V1InvitationParams instance) =>
    <String, dynamic>{
      'receiverUserName': instance.receiverUserName,
      'receiverUserEmail': instance.receiverUserEmail,
      'receiverUserTags': instance.receiverUserTags,
      'accessType': v1AccessTypeToJson(instance.accessType),
      'senderUserId': instance.senderUserId,
    };

V1ListPrivateKeyTagsRequest _$V1ListPrivateKeyTagsRequestFromJson(
        Map<String, dynamic> json) =>
    V1ListPrivateKeyTagsRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$V1ListPrivateKeyTagsRequestToJson(
        V1ListPrivateKeyTagsRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

V1ListPrivateKeyTagsResponse _$V1ListPrivateKeyTagsResponseFromJson(
        Map<String, dynamic> json) =>
    V1ListPrivateKeyTagsResponse(
      privateKeyTags: (json['privateKeyTags'] as List<dynamic>?)
              ?.map((e) => Datav1Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1ListPrivateKeyTagsResponseToJson(
        V1ListPrivateKeyTagsResponse instance) =>
    <String, dynamic>{
      'privateKeyTags': instance.privateKeyTags.map((e) => e.toJson()).toList(),
    };

V1ListUserTagsRequest _$V1ListUserTagsRequestFromJson(
        Map<String, dynamic> json) =>
    V1ListUserTagsRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$V1ListUserTagsRequestToJson(
        V1ListUserTagsRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

V1ListUserTagsResponse _$V1ListUserTagsResponseFromJson(
        Map<String, dynamic> json) =>
    V1ListUserTagsResponse(
      userTags: (json['userTags'] as List<dynamic>?)
              ?.map((e) => Datav1Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1ListUserTagsResponseToJson(
        V1ListUserTagsResponse instance) =>
    <String, dynamic>{
      'userTags': instance.userTags.map((e) => e.toJson()).toList(),
    };

V1NOOPCodegenAnchorResponse _$V1NOOPCodegenAnchorResponseFromJson(
        Map<String, dynamic> json) =>
    V1NOOPCodegenAnchorResponse(
      stamp: V1WebAuthnStamp.fromJson(json['stamp'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1NOOPCodegenAnchorResponseToJson(
        V1NOOPCodegenAnchorResponse instance) =>
    <String, dynamic>{
      'stamp': instance.stamp.toJson(),
    };

V1OauthIntent _$V1OauthIntentFromJson(Map<String, dynamic> json) =>
    V1OauthIntent(
      oidcToken: json['oidcToken'] as String,
      targetPublicKey: json['targetPublicKey'] as String,
      apiKeyName: json['apiKeyName'] as String?,
      expirationSeconds: json['expirationSeconds'] as String?,
    );

Map<String, dynamic> _$V1OauthIntentToJson(V1OauthIntent instance) =>
    <String, dynamic>{
      'oidcToken': instance.oidcToken,
      'targetPublicKey': instance.targetPublicKey,
      'apiKeyName': instance.apiKeyName,
      'expirationSeconds': instance.expirationSeconds,
    };

V1OauthProvider _$V1OauthProviderFromJson(Map<String, dynamic> json) =>
    V1OauthProvider(
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      issuer: json['issuer'] as String,
      audience: json['audience'] as String,
      subject: json['subject'] as String,
      createdAt: Externaldatav1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: Externaldatav1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1OauthProviderToJson(V1OauthProvider instance) =>
    <String, dynamic>{
      'providerId': instance.providerId,
      'providerName': instance.providerName,
      'issuer': instance.issuer,
      'audience': instance.audience,
      'subject': instance.subject,
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
    };

V1OauthProviderParams _$V1OauthProviderParamsFromJson(
        Map<String, dynamic> json) =>
    V1OauthProviderParams(
      providerName: json['providerName'] as String,
      oidcToken: json['oidcToken'] as String,
    );

Map<String, dynamic> _$V1OauthProviderParamsToJson(
        V1OauthProviderParams instance) =>
    <String, dynamic>{
      'providerName': instance.providerName,
      'oidcToken': instance.oidcToken,
    };

V1OauthRequest _$V1OauthRequestFromJson(Map<String, dynamic> json) =>
    V1OauthRequest(
      type: v1OauthRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters:
          V1OauthIntent.fromJson(json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1OauthRequestToJson(V1OauthRequest instance) =>
    <String, dynamic>{
      'type': v1OauthRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1OauthResult _$V1OauthResultFromJson(Map<String, dynamic> json) =>
    V1OauthResult(
      userId: json['userId'] as String,
      apiKeyId: json['apiKeyId'] as String,
      credentialBundle: json['credentialBundle'] as String,
    );

Map<String, dynamic> _$V1OauthResultToJson(V1OauthResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'apiKeyId': instance.apiKeyId,
      'credentialBundle': instance.credentialBundle,
    };

V1OrganizationData _$V1OrganizationDataFromJson(Map<String, dynamic> json) =>
    V1OrganizationData(
      organizationId: json['organizationId'] as String?,
      name: json['name'] as String?,
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => V1User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      policies: (json['policies'] as List<dynamic>?)
              ?.map((e) => V1Policy.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      privateKeys: (json['privateKeys'] as List<dynamic>?)
              ?.map((e) => V1PrivateKey.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      invitations: (json['invitations'] as List<dynamic>?)
              ?.map((e) => V1Invitation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => Datav1Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rootQuorum: json['rootQuorum'] == null
          ? null
          : Externaldatav1Quorum.fromJson(
              json['rootQuorum'] as Map<String, dynamic>),
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => V1Feature.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      wallets: (json['wallets'] as List<dynamic>?)
              ?.map((e) => V1Wallet.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1OrganizationDataToJson(V1OrganizationData instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'name': instance.name,
      'users': instance.users?.map((e) => e.toJson()).toList(),
      'policies': instance.policies?.map((e) => e.toJson()).toList(),
      'privateKeys': instance.privateKeys?.map((e) => e.toJson()).toList(),
      'invitations': instance.invitations?.map((e) => e.toJson()).toList(),
      'tags': instance.tags?.map((e) => e.toJson()).toList(),
      'rootQuorum': instance.rootQuorum?.toJson(),
      'features': instance.features?.map((e) => e.toJson()).toList(),
      'wallets': instance.wallets?.map((e) => e.toJson()).toList(),
    };

V1OtpAuthIntent _$V1OtpAuthIntentFromJson(Map<String, dynamic> json) =>
    V1OtpAuthIntent(
      otpId: json['otpId'] as String,
      otpCode: json['otpCode'] as String,
      targetPublicKey: json['targetPublicKey'] as String?,
      apiKeyName: json['apiKeyName'] as String?,
      expirationSeconds: json['expirationSeconds'] as String?,
      invalidateExisting: json['invalidateExisting'] as bool?,
    );

Map<String, dynamic> _$V1OtpAuthIntentToJson(V1OtpAuthIntent instance) =>
    <String, dynamic>{
      'otpId': instance.otpId,
      'otpCode': instance.otpCode,
      'targetPublicKey': instance.targetPublicKey,
      'apiKeyName': instance.apiKeyName,
      'expirationSeconds': instance.expirationSeconds,
      'invalidateExisting': instance.invalidateExisting,
    };

V1OtpAuthRequest _$V1OtpAuthRequestFromJson(Map<String, dynamic> json) =>
    V1OtpAuthRequest(
      type: v1OtpAuthRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters:
          V1OtpAuthIntent.fromJson(json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1OtpAuthRequestToJson(V1OtpAuthRequest instance) =>
    <String, dynamic>{
      'type': v1OtpAuthRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1OtpAuthResult _$V1OtpAuthResultFromJson(Map<String, dynamic> json) =>
    V1OtpAuthResult(
      userId: json['userId'] as String,
      apiKeyId: json['apiKeyId'] as String?,
      credentialBundle: json['credentialBundle'] as String?,
    );

Map<String, dynamic> _$V1OtpAuthResultToJson(V1OtpAuthResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'apiKeyId': instance.apiKeyId,
      'credentialBundle': instance.credentialBundle,
    };

V1Pagination _$V1PaginationFromJson(Map<String, dynamic> json) => V1Pagination(
      limit: json['limit'] as String?,
      before: json['before'] as String?,
      after: json['after'] as String?,
    );

Map<String, dynamic> _$V1PaginationToJson(V1Pagination instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'before': instance.before,
      'after': instance.after,
    };

V1Policy _$V1PolicyFromJson(Map<String, dynamic> json) => V1Policy(
      policyId: json['policyId'] as String,
      policyName: json['policyName'] as String,
      effect: v1EffectFromJson(json['effect']),
      createdAt: Externaldatav1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: Externaldatav1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
      notes: json['notes'] as String,
      consensus: json['consensus'] as String,
      condition: json['condition'] as String,
    );

Map<String, dynamic> _$V1PolicyToJson(V1Policy instance) => <String, dynamic>{
      'policyId': instance.policyId,
      'policyName': instance.policyName,
      'effect': v1EffectToJson(instance.effect),
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
      'notes': instance.notes,
      'consensus': instance.consensus,
      'condition': instance.condition,
    };

V1PrivateKey _$V1PrivateKeyFromJson(Map<String, dynamic> json) => V1PrivateKey(
      privateKeyId: json['privateKeyId'] as String,
      publicKey: json['publicKey'] as String,
      privateKeyName: json['privateKeyName'] as String,
      curve: v1CurveFromJson(json['curve']),
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) =>
                  Externaldatav1Address.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      privateKeyTags: (json['privateKeyTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: Externaldatav1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: Externaldatav1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
      exported: json['exported'] as bool,
      imported: json['imported'] as bool,
    );

Map<String, dynamic> _$V1PrivateKeyToJson(V1PrivateKey instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
      'publicKey': instance.publicKey,
      'privateKeyName': instance.privateKeyName,
      'curve': v1CurveToJson(instance.curve),
      'addresses': instance.addresses.map((e) => e.toJson()).toList(),
      'privateKeyTags': instance.privateKeyTags,
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
      'exported': instance.exported,
      'imported': instance.imported,
    };

V1PrivateKeyParams _$V1PrivateKeyParamsFromJson(Map<String, dynamic> json) =>
    V1PrivateKeyParams(
      privateKeyName: json['privateKeyName'] as String,
      curve: v1CurveFromJson(json['curve']),
      privateKeyTags: (json['privateKeyTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      addressFormats:
          v1AddressFormatListFromJson(json['addressFormats'] as List?),
    );

Map<String, dynamic> _$V1PrivateKeyParamsToJson(V1PrivateKeyParams instance) =>
    <String, dynamic>{
      'privateKeyName': instance.privateKeyName,
      'curve': v1CurveToJson(instance.curve),
      'privateKeyTags': instance.privateKeyTags,
      'addressFormats': v1AddressFormatListToJson(instance.addressFormats),
    };

V1PrivateKeyResult _$V1PrivateKeyResultFromJson(Map<String, dynamic> json) =>
    V1PrivateKeyResult(
      privateKeyId: json['privateKeyId'] as String?,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => Immutableactivityv1Address.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1PrivateKeyResultToJson(V1PrivateKeyResult instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
      'addresses': instance.addresses?.map((e) => e.toJson()).toList(),
    };

V1PublicKeyCredentialWithAttestation
    _$V1PublicKeyCredentialWithAttestationFromJson(Map<String, dynamic> json) =>
        V1PublicKeyCredentialWithAttestation(
          id: json['id'] as String,
          type: v1PublicKeyCredentialWithAttestationTypeFromJson(json['type']),
          rawId: json['rawId'] as String,
          authenticatorAttachment:
              v1PublicKeyCredentialWithAttestationAuthenticatorAttachmentNullableFromJson(
                  json['authenticatorAttachment']),
          response: V1AuthenticatorAttestationResponse.fromJson(
              json['response'] as Map<String, dynamic>),
          clientExtensionResults: V1SimpleClientExtensionResults.fromJson(
              json['clientExtensionResults'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$V1PublicKeyCredentialWithAttestationToJson(
        V1PublicKeyCredentialWithAttestation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': v1PublicKeyCredentialWithAttestationTypeToJson(instance.type),
      'rawId': instance.rawId,
      'authenticatorAttachment':
          v1PublicKeyCredentialWithAttestationAuthenticatorAttachmentNullableToJson(
              instance.authenticatorAttachment),
      'response': instance.response.toJson(),
      'clientExtensionResults': instance.clientExtensionResults.toJson(),
    };

V1RecoverUserIntent _$V1RecoverUserIntentFromJson(Map<String, dynamic> json) =>
    V1RecoverUserIntent(
      authenticator: V1AuthenticatorParamsV2.fromJson(
          json['authenticator'] as Map<String, dynamic>),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$V1RecoverUserIntentToJson(
        V1RecoverUserIntent instance) =>
    <String, dynamic>{
      'authenticator': instance.authenticator.toJson(),
      'userId': instance.userId,
    };

V1RecoverUserRequest _$V1RecoverUserRequestFromJson(
        Map<String, dynamic> json) =>
    V1RecoverUserRequest(
      type: v1RecoverUserRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1RecoverUserIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1RecoverUserRequestToJson(
        V1RecoverUserRequest instance) =>
    <String, dynamic>{
      'type': v1RecoverUserRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1RecoverUserResult _$V1RecoverUserResultFromJson(Map<String, dynamic> json) =>
    V1RecoverUserResult(
      authenticatorId: (json['authenticatorId'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1RecoverUserResultToJson(
        V1RecoverUserResult instance) =>
    <String, dynamic>{
      'authenticatorId': instance.authenticatorId,
    };

V1RejectActivityIntent _$V1RejectActivityIntentFromJson(
        Map<String, dynamic> json) =>
    V1RejectActivityIntent(
      fingerprint: json['fingerprint'] as String,
    );

Map<String, dynamic> _$V1RejectActivityIntentToJson(
        V1RejectActivityIntent instance) =>
    <String, dynamic>{
      'fingerprint': instance.fingerprint,
    };

V1RejectActivityRequest _$V1RejectActivityRequestFromJson(
        Map<String, dynamic> json) =>
    V1RejectActivityRequest(
      type: v1RejectActivityRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1RejectActivityIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1RejectActivityRequestToJson(
        V1RejectActivityRequest instance) =>
    <String, dynamic>{
      'type': v1RejectActivityRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1RemoveOrganizationFeatureIntent _$V1RemoveOrganizationFeatureIntentFromJson(
        Map<String, dynamic> json) =>
    V1RemoveOrganizationFeatureIntent(
      name: v1FeatureNameFromJson(json['name']),
    );

Map<String, dynamic> _$V1RemoveOrganizationFeatureIntentToJson(
        V1RemoveOrganizationFeatureIntent instance) =>
    <String, dynamic>{
      'name': v1FeatureNameToJson(instance.name),
    };

V1RemoveOrganizationFeatureRequest _$V1RemoveOrganizationFeatureRequestFromJson(
        Map<String, dynamic> json) =>
    V1RemoveOrganizationFeatureRequest(
      type: v1RemoveOrganizationFeatureRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1RemoveOrganizationFeatureIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1RemoveOrganizationFeatureRequestToJson(
        V1RemoveOrganizationFeatureRequest instance) =>
    <String, dynamic>{
      'type': v1RemoveOrganizationFeatureRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1RemoveOrganizationFeatureResult _$V1RemoveOrganizationFeatureResultFromJson(
        Map<String, dynamic> json) =>
    V1RemoveOrganizationFeatureResult(
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => V1Feature.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1RemoveOrganizationFeatureResultToJson(
        V1RemoveOrganizationFeatureResult instance) =>
    <String, dynamic>{
      'features': instance.features.map((e) => e.toJson()).toList(),
    };

V1Result _$V1ResultFromJson(Map<String, dynamic> json) => V1Result(
      createOrganizationResult: json['createOrganizationResult'] == null
          ? null
          : V1CreateOrganizationResult.fromJson(
              json['createOrganizationResult'] as Map<String, dynamic>),
      createAuthenticatorsResult: json['createAuthenticatorsResult'] == null
          ? null
          : V1CreateAuthenticatorsResult.fromJson(
              json['createAuthenticatorsResult'] as Map<String, dynamic>),
      createUsersResult: json['createUsersResult'] == null
          ? null
          : V1CreateUsersResult.fromJson(
              json['createUsersResult'] as Map<String, dynamic>),
      createPrivateKeysResult: json['createPrivateKeysResult'] == null
          ? null
          : V1CreatePrivateKeysResult.fromJson(
              json['createPrivateKeysResult'] as Map<String, dynamic>),
      createInvitationsResult: json['createInvitationsResult'] == null
          ? null
          : V1CreateInvitationsResult.fromJson(
              json['createInvitationsResult'] as Map<String, dynamic>),
      acceptInvitationResult: json['acceptInvitationResult'] == null
          ? null
          : V1AcceptInvitationResult.fromJson(
              json['acceptInvitationResult'] as Map<String, dynamic>),
      signRawPayloadResult: json['signRawPayloadResult'] == null
          ? null
          : V1SignRawPayloadResult.fromJson(
              json['signRawPayloadResult'] as Map<String, dynamic>),
      createPolicyResult: json['createPolicyResult'] == null
          ? null
          : V1CreatePolicyResult.fromJson(
              json['createPolicyResult'] as Map<String, dynamic>),
      disablePrivateKeyResult: json['disablePrivateKeyResult'] == null
          ? null
          : V1DisablePrivateKeyResult.fromJson(
              json['disablePrivateKeyResult'] as Map<String, dynamic>),
      deleteUsersResult: json['deleteUsersResult'] == null
          ? null
          : V1DeleteUsersResult.fromJson(
              json['deleteUsersResult'] as Map<String, dynamic>),
      deleteAuthenticatorsResult: json['deleteAuthenticatorsResult'] == null
          ? null
          : V1DeleteAuthenticatorsResult.fromJson(
              json['deleteAuthenticatorsResult'] as Map<String, dynamic>),
      deleteInvitationResult: json['deleteInvitationResult'] == null
          ? null
          : V1DeleteInvitationResult.fromJson(
              json['deleteInvitationResult'] as Map<String, dynamic>),
      deleteOrganizationResult: json['deleteOrganizationResult'] == null
          ? null
          : V1DeleteOrganizationResult.fromJson(
              json['deleteOrganizationResult'] as Map<String, dynamic>),
      deletePolicyResult: json['deletePolicyResult'] == null
          ? null
          : V1DeletePolicyResult.fromJson(
              json['deletePolicyResult'] as Map<String, dynamic>),
      createUserTagResult: json['createUserTagResult'] == null
          ? null
          : V1CreateUserTagResult.fromJson(
              json['createUserTagResult'] as Map<String, dynamic>),
      deleteUserTagsResult: json['deleteUserTagsResult'] == null
          ? null
          : V1DeleteUserTagsResult.fromJson(
              json['deleteUserTagsResult'] as Map<String, dynamic>),
      signTransactionResult: json['signTransactionResult'] == null
          ? null
          : V1SignTransactionResult.fromJson(
              json['signTransactionResult'] as Map<String, dynamic>),
      deleteApiKeysResult: json['deleteApiKeysResult'] == null
          ? null
          : V1DeleteApiKeysResult.fromJson(
              json['deleteApiKeysResult'] as Map<String, dynamic>),
      createApiKeysResult: json['createApiKeysResult'] == null
          ? null
          : V1CreateApiKeysResult.fromJson(
              json['createApiKeysResult'] as Map<String, dynamic>),
      createPrivateKeyTagResult: json['createPrivateKeyTagResult'] == null
          ? null
          : V1CreatePrivateKeyTagResult.fromJson(
              json['createPrivateKeyTagResult'] as Map<String, dynamic>),
      deletePrivateKeyTagsResult: json['deletePrivateKeyTagsResult'] == null
          ? null
          : V1DeletePrivateKeyTagsResult.fromJson(
              json['deletePrivateKeyTagsResult'] as Map<String, dynamic>),
      setPaymentMethodResult: json['setPaymentMethodResult'] == null
          ? null
          : BillingSetPaymentMethodResult.fromJson(
              json['setPaymentMethodResult'] as Map<String, dynamic>),
      activateBillingTierResult: json['activateBillingTierResult'] == null
          ? null
          : BillingActivateBillingTierResult.fromJson(
              json['activateBillingTierResult'] as Map<String, dynamic>),
      deletePaymentMethodResult: json['deletePaymentMethodResult'] == null
          ? null
          : BillingDeletePaymentMethodResult.fromJson(
              json['deletePaymentMethodResult'] as Map<String, dynamic>),
      createApiOnlyUsersResult: json['createApiOnlyUsersResult'] == null
          ? null
          : V1CreateApiOnlyUsersResult.fromJson(
              json['createApiOnlyUsersResult'] as Map<String, dynamic>),
      updateRootQuorumResult: json['updateRootQuorumResult'] == null
          ? null
          : V1UpdateRootQuorumResult.fromJson(
              json['updateRootQuorumResult'] as Map<String, dynamic>),
      updateUserTagResult: json['updateUserTagResult'] == null
          ? null
          : V1UpdateUserTagResult.fromJson(
              json['updateUserTagResult'] as Map<String, dynamic>),
      updatePrivateKeyTagResult: json['updatePrivateKeyTagResult'] == null
          ? null
          : V1UpdatePrivateKeyTagResult.fromJson(
              json['updatePrivateKeyTagResult'] as Map<String, dynamic>),
      createSubOrganizationResult: json['createSubOrganizationResult'] == null
          ? null
          : V1CreateSubOrganizationResult.fromJson(
              json['createSubOrganizationResult'] as Map<String, dynamic>),
      updateAllowedOriginsResult: json['updateAllowedOriginsResult'] == null
          ? null
          : V1UpdateAllowedOriginsResult.fromJson(
              json['updateAllowedOriginsResult'] as Map<String, dynamic>),
      createPrivateKeysResultV2: json['createPrivateKeysResultV2'] == null
          ? null
          : V1CreatePrivateKeysResultV2.fromJson(
              json['createPrivateKeysResultV2'] as Map<String, dynamic>),
      updateUserResult: json['updateUserResult'] == null
          ? null
          : V1UpdateUserResult.fromJson(
              json['updateUserResult'] as Map<String, dynamic>),
      updatePolicyResult: json['updatePolicyResult'] == null
          ? null
          : V1UpdatePolicyResult.fromJson(
              json['updatePolicyResult'] as Map<String, dynamic>),
      createSubOrganizationResultV3: json['createSubOrganizationResultV3'] ==
              null
          ? null
          : V1CreateSubOrganizationResultV3.fromJson(
              json['createSubOrganizationResultV3'] as Map<String, dynamic>),
      createWalletResult: json['createWalletResult'] == null
          ? null
          : V1CreateWalletResult.fromJson(
              json['createWalletResult'] as Map<String, dynamic>),
      createWalletAccountsResult: json['createWalletAccountsResult'] == null
          ? null
          : V1CreateWalletAccountsResult.fromJson(
              json['createWalletAccountsResult'] as Map<String, dynamic>),
      initUserEmailRecoveryResult: json['initUserEmailRecoveryResult'] == null
          ? null
          : V1InitUserEmailRecoveryResult.fromJson(
              json['initUserEmailRecoveryResult'] as Map<String, dynamic>),
      recoverUserResult: json['recoverUserResult'] == null
          ? null
          : V1RecoverUserResult.fromJson(
              json['recoverUserResult'] as Map<String, dynamic>),
      setOrganizationFeatureResult: json['setOrganizationFeatureResult'] == null
          ? null
          : V1SetOrganizationFeatureResult.fromJson(
              json['setOrganizationFeatureResult'] as Map<String, dynamic>),
      removeOrganizationFeatureResult:
          json['removeOrganizationFeatureResult'] == null
              ? null
              : V1RemoveOrganizationFeatureResult.fromJson(
                  json['removeOrganizationFeatureResult']
                      as Map<String, dynamic>),
      exportPrivateKeyResult: json['exportPrivateKeyResult'] == null
          ? null
          : V1ExportPrivateKeyResult.fromJson(
              json['exportPrivateKeyResult'] as Map<String, dynamic>),
      exportWalletResult: json['exportWalletResult'] == null
          ? null
          : V1ExportWalletResult.fromJson(
              json['exportWalletResult'] as Map<String, dynamic>),
      createSubOrganizationResultV4: json['createSubOrganizationResultV4'] ==
              null
          ? null
          : V1CreateSubOrganizationResultV4.fromJson(
              json['createSubOrganizationResultV4'] as Map<String, dynamic>),
      emailAuthResult: json['emailAuthResult'] == null
          ? null
          : V1EmailAuthResult.fromJson(
              json['emailAuthResult'] as Map<String, dynamic>),
      exportWalletAccountResult: json['exportWalletAccountResult'] == null
          ? null
          : V1ExportWalletAccountResult.fromJson(
              json['exportWalletAccountResult'] as Map<String, dynamic>),
      initImportWalletResult: json['initImportWalletResult'] == null
          ? null
          : V1InitImportWalletResult.fromJson(
              json['initImportWalletResult'] as Map<String, dynamic>),
      importWalletResult: json['importWalletResult'] == null
          ? null
          : V1ImportWalletResult.fromJson(
              json['importWalletResult'] as Map<String, dynamic>),
      initImportPrivateKeyResult: json['initImportPrivateKeyResult'] == null
          ? null
          : V1InitImportPrivateKeyResult.fromJson(
              json['initImportPrivateKeyResult'] as Map<String, dynamic>),
      importPrivateKeyResult: json['importPrivateKeyResult'] == null
          ? null
          : V1ImportPrivateKeyResult.fromJson(
              json['importPrivateKeyResult'] as Map<String, dynamic>),
      createPoliciesResult: json['createPoliciesResult'] == null
          ? null
          : V1CreatePoliciesResult.fromJson(
              json['createPoliciesResult'] as Map<String, dynamic>),
      signRawPayloadsResult: json['signRawPayloadsResult'] == null
          ? null
          : V1SignRawPayloadsResult.fromJson(
              json['signRawPayloadsResult'] as Map<String, dynamic>),
      createReadOnlySessionResult: json['createReadOnlySessionResult'] == null
          ? null
          : V1CreateReadOnlySessionResult.fromJson(
              json['createReadOnlySessionResult'] as Map<String, dynamic>),
      createOauthProvidersResult: json['createOauthProvidersResult'] == null
          ? null
          : V1CreateOauthProvidersResult.fromJson(
              json['createOauthProvidersResult'] as Map<String, dynamic>),
      deleteOauthProvidersResult: json['deleteOauthProvidersResult'] == null
          ? null
          : V1DeleteOauthProvidersResult.fromJson(
              json['deleteOauthProvidersResult'] as Map<String, dynamic>),
      createSubOrganizationResultV5: json['createSubOrganizationResultV5'] ==
              null
          ? null
          : V1CreateSubOrganizationResultV5.fromJson(
              json['createSubOrganizationResultV5'] as Map<String, dynamic>),
      oauthResult: json['oauthResult'] == null
          ? null
          : V1OauthResult.fromJson(json['oauthResult'] as Map<String, dynamic>),
      createReadWriteSessionResult: json['createReadWriteSessionResult'] == null
          ? null
          : V1CreateReadWriteSessionResult.fromJson(
              json['createReadWriteSessionResult'] as Map<String, dynamic>),
      createSubOrganizationResultV6: json['createSubOrganizationResultV6'] ==
              null
          ? null
          : V1CreateSubOrganizationResultV6.fromJson(
              json['createSubOrganizationResultV6'] as Map<String, dynamic>),
      deletePrivateKeysResult: json['deletePrivateKeysResult'] == null
          ? null
          : V1DeletePrivateKeysResult.fromJson(
              json['deletePrivateKeysResult'] as Map<String, dynamic>),
      deleteWalletsResult: json['deleteWalletsResult'] == null
          ? null
          : V1DeleteWalletsResult.fromJson(
              json['deleteWalletsResult'] as Map<String, dynamic>),
      createReadWriteSessionResultV2: json['createReadWriteSessionResultV2'] ==
              null
          ? null
          : V1CreateReadWriteSessionResultV2.fromJson(
              json['createReadWriteSessionResultV2'] as Map<String, dynamic>),
      deleteSubOrganizationResult: json['deleteSubOrganizationResult'] == null
          ? null
          : V1DeleteSubOrganizationResult.fromJson(
              json['deleteSubOrganizationResult'] as Map<String, dynamic>),
      initOtpAuthResult: json['initOtpAuthResult'] == null
          ? null
          : V1InitOtpAuthResult.fromJson(
              json['initOtpAuthResult'] as Map<String, dynamic>),
      otpAuthResult: json['otpAuthResult'] == null
          ? null
          : V1OtpAuthResult.fromJson(
              json['otpAuthResult'] as Map<String, dynamic>),
      createSubOrganizationResultV7: json['createSubOrganizationResultV7'] ==
              null
          ? null
          : V1CreateSubOrganizationResultV7.fromJson(
              json['createSubOrganizationResultV7'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1ResultToJson(V1Result instance) => <String, dynamic>{
      'createOrganizationResult': instance.createOrganizationResult?.toJson(),
      'createAuthenticatorsResult':
          instance.createAuthenticatorsResult?.toJson(),
      'createUsersResult': instance.createUsersResult?.toJson(),
      'createPrivateKeysResult': instance.createPrivateKeysResult?.toJson(),
      'createInvitationsResult': instance.createInvitationsResult?.toJson(),
      'acceptInvitationResult': instance.acceptInvitationResult?.toJson(),
      'signRawPayloadResult': instance.signRawPayloadResult?.toJson(),
      'createPolicyResult': instance.createPolicyResult?.toJson(),
      'disablePrivateKeyResult': instance.disablePrivateKeyResult?.toJson(),
      'deleteUsersResult': instance.deleteUsersResult?.toJson(),
      'deleteAuthenticatorsResult':
          instance.deleteAuthenticatorsResult?.toJson(),
      'deleteInvitationResult': instance.deleteInvitationResult?.toJson(),
      'deleteOrganizationResult': instance.deleteOrganizationResult?.toJson(),
      'deletePolicyResult': instance.deletePolicyResult?.toJson(),
      'createUserTagResult': instance.createUserTagResult?.toJson(),
      'deleteUserTagsResult': instance.deleteUserTagsResult?.toJson(),
      'signTransactionResult': instance.signTransactionResult?.toJson(),
      'deleteApiKeysResult': instance.deleteApiKeysResult?.toJson(),
      'createApiKeysResult': instance.createApiKeysResult?.toJson(),
      'createPrivateKeyTagResult': instance.createPrivateKeyTagResult?.toJson(),
      'deletePrivateKeyTagsResult':
          instance.deletePrivateKeyTagsResult?.toJson(),
      'setPaymentMethodResult': instance.setPaymentMethodResult?.toJson(),
      'activateBillingTierResult': instance.activateBillingTierResult?.toJson(),
      'deletePaymentMethodResult': instance.deletePaymentMethodResult?.toJson(),
      'createApiOnlyUsersResult': instance.createApiOnlyUsersResult?.toJson(),
      'updateRootQuorumResult': instance.updateRootQuorumResult?.toJson(),
      'updateUserTagResult': instance.updateUserTagResult?.toJson(),
      'updatePrivateKeyTagResult': instance.updatePrivateKeyTagResult?.toJson(),
      'createSubOrganizationResult':
          instance.createSubOrganizationResult?.toJson(),
      'updateAllowedOriginsResult':
          instance.updateAllowedOriginsResult?.toJson(),
      'createPrivateKeysResultV2': instance.createPrivateKeysResultV2?.toJson(),
      'updateUserResult': instance.updateUserResult?.toJson(),
      'updatePolicyResult': instance.updatePolicyResult?.toJson(),
      'createSubOrganizationResultV3':
          instance.createSubOrganizationResultV3?.toJson(),
      'createWalletResult': instance.createWalletResult?.toJson(),
      'createWalletAccountsResult':
          instance.createWalletAccountsResult?.toJson(),
      'initUserEmailRecoveryResult':
          instance.initUserEmailRecoveryResult?.toJson(),
      'recoverUserResult': instance.recoverUserResult?.toJson(),
      'setOrganizationFeatureResult':
          instance.setOrganizationFeatureResult?.toJson(),
      'removeOrganizationFeatureResult':
          instance.removeOrganizationFeatureResult?.toJson(),
      'exportPrivateKeyResult': instance.exportPrivateKeyResult?.toJson(),
      'exportWalletResult': instance.exportWalletResult?.toJson(),
      'createSubOrganizationResultV4':
          instance.createSubOrganizationResultV4?.toJson(),
      'emailAuthResult': instance.emailAuthResult?.toJson(),
      'exportWalletAccountResult': instance.exportWalletAccountResult?.toJson(),
      'initImportWalletResult': instance.initImportWalletResult?.toJson(),
      'importWalletResult': instance.importWalletResult?.toJson(),
      'initImportPrivateKeyResult':
          instance.initImportPrivateKeyResult?.toJson(),
      'importPrivateKeyResult': instance.importPrivateKeyResult?.toJson(),
      'createPoliciesResult': instance.createPoliciesResult?.toJson(),
      'signRawPayloadsResult': instance.signRawPayloadsResult?.toJson(),
      'createReadOnlySessionResult':
          instance.createReadOnlySessionResult?.toJson(),
      'createOauthProvidersResult':
          instance.createOauthProvidersResult?.toJson(),
      'deleteOauthProvidersResult':
          instance.deleteOauthProvidersResult?.toJson(),
      'createSubOrganizationResultV5':
          instance.createSubOrganizationResultV5?.toJson(),
      'oauthResult': instance.oauthResult?.toJson(),
      'createReadWriteSessionResult':
          instance.createReadWriteSessionResult?.toJson(),
      'createSubOrganizationResultV6':
          instance.createSubOrganizationResultV6?.toJson(),
      'deletePrivateKeysResult': instance.deletePrivateKeysResult?.toJson(),
      'deleteWalletsResult': instance.deleteWalletsResult?.toJson(),
      'createReadWriteSessionResultV2':
          instance.createReadWriteSessionResultV2?.toJson(),
      'deleteSubOrganizationResult':
          instance.deleteSubOrganizationResult?.toJson(),
      'initOtpAuthResult': instance.initOtpAuthResult?.toJson(),
      'otpAuthResult': instance.otpAuthResult?.toJson(),
      'createSubOrganizationResultV7':
          instance.createSubOrganizationResultV7?.toJson(),
    };

V1RootUserParams _$V1RootUserParamsFromJson(Map<String, dynamic> json) =>
    V1RootUserParams(
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiApiKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) =>
                  V1AuthenticatorParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1RootUserParamsToJson(V1RootUserParams instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
    };

V1RootUserParamsV2 _$V1RootUserParamsV2FromJson(Map<String, dynamic> json) =>
    V1RootUserParamsV2(
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiApiKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) =>
                  V1AuthenticatorParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      oauthProviders: (json['oauthProviders'] as List<dynamic>?)
              ?.map((e) =>
                  V1OauthProviderParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1RootUserParamsV2ToJson(V1RootUserParamsV2 instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
      'oauthProviders': instance.oauthProviders.map((e) => e.toJson()).toList(),
    };

V1RootUserParamsV3 _$V1RootUserParamsV3FromJson(Map<String, dynamic> json) =>
    V1RootUserParamsV3(
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => V1ApiKeyParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) =>
                  V1AuthenticatorParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      oauthProviders: (json['oauthProviders'] as List<dynamic>?)
              ?.map((e) =>
                  V1OauthProviderParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1RootUserParamsV3ToJson(V1RootUserParamsV3 instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
      'oauthProviders': instance.oauthProviders.map((e) => e.toJson()).toList(),
    };

V1RootUserParamsV4 _$V1RootUserParamsV4FromJson(Map<String, dynamic> json) =>
    V1RootUserParamsV4(
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      userPhoneNumber: json['userPhoneNumber'] as String?,
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => V1ApiKeyParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) =>
                  V1AuthenticatorParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      oauthProviders: (json['oauthProviders'] as List<dynamic>?)
              ?.map((e) =>
                  V1OauthProviderParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1RootUserParamsV4ToJson(V1RootUserParamsV4 instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'userPhoneNumber': instance.userPhoneNumber,
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
      'oauthProviders': instance.oauthProviders.map((e) => e.toJson()).toList(),
    };

V1Selector _$V1SelectorFromJson(Map<String, dynamic> json) => V1Selector(
      subject: json['subject'] as String?,
      $operator: v1OperatorNullableFromJson(json['operator']),
      target: json['target'] as String?,
    );

Map<String, dynamic> _$V1SelectorToJson(V1Selector instance) =>
    <String, dynamic>{
      'subject': instance.subject,
      'operator': v1OperatorNullableToJson(instance.$operator),
      'target': instance.target,
    };

V1SelectorV2 _$V1SelectorV2FromJson(Map<String, dynamic> json) => V1SelectorV2(
      subject: json['subject'] as String?,
      $operator: v1OperatorNullableFromJson(json['operator']),
      targets: (json['targets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1SelectorV2ToJson(V1SelectorV2 instance) =>
    <String, dynamic>{
      'subject': instance.subject,
      'operator': v1OperatorNullableToJson(instance.$operator),
      'targets': instance.targets,
    };

V1SetOrganizationFeatureIntent _$V1SetOrganizationFeatureIntentFromJson(
        Map<String, dynamic> json) =>
    V1SetOrganizationFeatureIntent(
      name: v1FeatureNameFromJson(json['name']),
      $value: json['value'] as String,
    );

Map<String, dynamic> _$V1SetOrganizationFeatureIntentToJson(
        V1SetOrganizationFeatureIntent instance) =>
    <String, dynamic>{
      'name': v1FeatureNameToJson(instance.name),
      'value': instance.$value,
    };

V1SetOrganizationFeatureRequest _$V1SetOrganizationFeatureRequestFromJson(
        Map<String, dynamic> json) =>
    V1SetOrganizationFeatureRequest(
      type: v1SetOrganizationFeatureRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1SetOrganizationFeatureIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1SetOrganizationFeatureRequestToJson(
        V1SetOrganizationFeatureRequest instance) =>
    <String, dynamic>{
      'type': v1SetOrganizationFeatureRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1SetOrganizationFeatureResult _$V1SetOrganizationFeatureResultFromJson(
        Map<String, dynamic> json) =>
    V1SetOrganizationFeatureResult(
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => V1Feature.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1SetOrganizationFeatureResultToJson(
        V1SetOrganizationFeatureResult instance) =>
    <String, dynamic>{
      'features': instance.features.map((e) => e.toJson()).toList(),
    };

V1SignRawPayloadIntent _$V1SignRawPayloadIntentFromJson(
        Map<String, dynamic> json) =>
    V1SignRawPayloadIntent(
      privateKeyId: json['privateKeyId'] as String,
      payload: json['payload'] as String,
      encoding: v1PayloadEncodingFromJson(json['encoding']),
      hashFunction: v1HashFunctionFromJson(json['hashFunction']),
    );

Map<String, dynamic> _$V1SignRawPayloadIntentToJson(
        V1SignRawPayloadIntent instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
      'payload': instance.payload,
      'encoding': v1PayloadEncodingToJson(instance.encoding),
      'hashFunction': v1HashFunctionToJson(instance.hashFunction),
    };

V1SignRawPayloadIntentV2 _$V1SignRawPayloadIntentV2FromJson(
        Map<String, dynamic> json) =>
    V1SignRawPayloadIntentV2(
      signWith: json['signWith'] as String,
      payload: json['payload'] as String,
      encoding: v1PayloadEncodingFromJson(json['encoding']),
      hashFunction: v1HashFunctionFromJson(json['hashFunction']),
    );

Map<String, dynamic> _$V1SignRawPayloadIntentV2ToJson(
        V1SignRawPayloadIntentV2 instance) =>
    <String, dynamic>{
      'signWith': instance.signWith,
      'payload': instance.payload,
      'encoding': v1PayloadEncodingToJson(instance.encoding),
      'hashFunction': v1HashFunctionToJson(instance.hashFunction),
    };

V1SignRawPayloadRequest _$V1SignRawPayloadRequestFromJson(
        Map<String, dynamic> json) =>
    V1SignRawPayloadRequest(
      type: v1SignRawPayloadRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1SignRawPayloadIntentV2.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1SignRawPayloadRequestToJson(
        V1SignRawPayloadRequest instance) =>
    <String, dynamic>{
      'type': v1SignRawPayloadRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1SignRawPayloadResult _$V1SignRawPayloadResultFromJson(
        Map<String, dynamic> json) =>
    V1SignRawPayloadResult(
      r: json['r'] as String,
      s: json['s'] as String,
      v: json['v'] as String,
    );

Map<String, dynamic> _$V1SignRawPayloadResultToJson(
        V1SignRawPayloadResult instance) =>
    <String, dynamic>{
      'r': instance.r,
      's': instance.s,
      'v': instance.v,
    };

V1SignRawPayloadsIntent _$V1SignRawPayloadsIntentFromJson(
        Map<String, dynamic> json) =>
    V1SignRawPayloadsIntent(
      signWith: json['signWith'] as String,
      payloads: (json['payloads'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      encoding: v1PayloadEncodingFromJson(json['encoding']),
      hashFunction: v1HashFunctionFromJson(json['hashFunction']),
    );

Map<String, dynamic> _$V1SignRawPayloadsIntentToJson(
        V1SignRawPayloadsIntent instance) =>
    <String, dynamic>{
      'signWith': instance.signWith,
      'payloads': instance.payloads,
      'encoding': v1PayloadEncodingToJson(instance.encoding),
      'hashFunction': v1HashFunctionToJson(instance.hashFunction),
    };

V1SignRawPayloadsRequest _$V1SignRawPayloadsRequestFromJson(
        Map<String, dynamic> json) =>
    V1SignRawPayloadsRequest(
      type: v1SignRawPayloadsRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1SignRawPayloadsIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1SignRawPayloadsRequestToJson(
        V1SignRawPayloadsRequest instance) =>
    <String, dynamic>{
      'type': v1SignRawPayloadsRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1SignRawPayloadsResult _$V1SignRawPayloadsResultFromJson(
        Map<String, dynamic> json) =>
    V1SignRawPayloadsResult(
      signatures: (json['signatures'] as List<dynamic>?)
              ?.map((e) =>
                  V1SignRawPayloadResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1SignRawPayloadsResultToJson(
        V1SignRawPayloadsResult instance) =>
    <String, dynamic>{
      'signatures': instance.signatures?.map((e) => e.toJson()).toList(),
    };

V1SignTransactionIntent _$V1SignTransactionIntentFromJson(
        Map<String, dynamic> json) =>
    V1SignTransactionIntent(
      privateKeyId: json['privateKeyId'] as String,
      unsignedTransaction: json['unsignedTransaction'] as String,
      type: v1TransactionTypeFromJson(json['type']),
    );

Map<String, dynamic> _$V1SignTransactionIntentToJson(
        V1SignTransactionIntent instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
      'unsignedTransaction': instance.unsignedTransaction,
      'type': v1TransactionTypeToJson(instance.type),
    };

V1SignTransactionIntentV2 _$V1SignTransactionIntentV2FromJson(
        Map<String, dynamic> json) =>
    V1SignTransactionIntentV2(
      signWith: json['signWith'] as String,
      unsignedTransaction: json['unsignedTransaction'] as String,
      type: v1TransactionTypeFromJson(json['type']),
    );

Map<String, dynamic> _$V1SignTransactionIntentV2ToJson(
        V1SignTransactionIntentV2 instance) =>
    <String, dynamic>{
      'signWith': instance.signWith,
      'unsignedTransaction': instance.unsignedTransaction,
      'type': v1TransactionTypeToJson(instance.type),
    };

V1SignTransactionRequest _$V1SignTransactionRequestFromJson(
        Map<String, dynamic> json) =>
    V1SignTransactionRequest(
      type: v1SignTransactionRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1SignTransactionIntentV2.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1SignTransactionRequestToJson(
        V1SignTransactionRequest instance) =>
    <String, dynamic>{
      'type': v1SignTransactionRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1SignTransactionResult _$V1SignTransactionResultFromJson(
        Map<String, dynamic> json) =>
    V1SignTransactionResult(
      signedTransaction: json['signedTransaction'] as String,
    );

Map<String, dynamic> _$V1SignTransactionResultToJson(
        V1SignTransactionResult instance) =>
    <String, dynamic>{
      'signedTransaction': instance.signedTransaction,
    };

V1SimpleClientExtensionResults _$V1SimpleClientExtensionResultsFromJson(
        Map<String, dynamic> json) =>
    V1SimpleClientExtensionResults(
      appid: json['appid'] as bool?,
      appidExclude: json['appidExclude'] as bool?,
      credProps: json['credProps'] == null
          ? null
          : V1CredPropsAuthenticationExtensionsClientOutputs.fromJson(
              json['credProps'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1SimpleClientExtensionResultsToJson(
        V1SimpleClientExtensionResults instance) =>
    <String, dynamic>{
      'appid': instance.appid,
      'appidExclude': instance.appidExclude,
      'credProps': instance.credProps?.toJson(),
    };

V1SmsCustomizationParams _$V1SmsCustomizationParamsFromJson(
        Map<String, dynamic> json) =>
    V1SmsCustomizationParams(
      template: json['template'] as String?,
    );

Map<String, dynamic> _$V1SmsCustomizationParamsToJson(
        V1SmsCustomizationParams instance) =>
    <String, dynamic>{
      'template': instance.template,
    };

V1UpdateAllowedOriginsIntent _$V1UpdateAllowedOriginsIntentFromJson(
        Map<String, dynamic> json) =>
    V1UpdateAllowedOriginsIntent(
      allowedOrigins: (json['allowedOrigins'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1UpdateAllowedOriginsIntentToJson(
        V1UpdateAllowedOriginsIntent instance) =>
    <String, dynamic>{
      'allowedOrigins': instance.allowedOrigins,
    };

V1UpdateAllowedOriginsResult _$V1UpdateAllowedOriginsResultFromJson(
        Map<String, dynamic> json) =>
    V1UpdateAllowedOriginsResult();

Map<String, dynamic> _$V1UpdateAllowedOriginsResultToJson(
        V1UpdateAllowedOriginsResult instance) =>
    <String, dynamic>{};

V1UpdatePolicyIntent _$V1UpdatePolicyIntentFromJson(
        Map<String, dynamic> json) =>
    V1UpdatePolicyIntent(
      policyId: json['policyId'] as String,
      policyName: json['policyName'] as String?,
      policyEffect: v1EffectNullableFromJson(json['policyEffect']),
      policyCondition: json['policyCondition'] as String?,
      policyConsensus: json['policyConsensus'] as String?,
      policyNotes: json['policyNotes'] as String?,
    );

Map<String, dynamic> _$V1UpdatePolicyIntentToJson(
        V1UpdatePolicyIntent instance) =>
    <String, dynamic>{
      'policyId': instance.policyId,
      'policyName': instance.policyName,
      'policyEffect': v1EffectNullableToJson(instance.policyEffect),
      'policyCondition': instance.policyCondition,
      'policyConsensus': instance.policyConsensus,
      'policyNotes': instance.policyNotes,
    };

V1UpdatePolicyRequest _$V1UpdatePolicyRequestFromJson(
        Map<String, dynamic> json) =>
    V1UpdatePolicyRequest(
      type: v1UpdatePolicyRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1UpdatePolicyIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1UpdatePolicyRequestToJson(
        V1UpdatePolicyRequest instance) =>
    <String, dynamic>{
      'type': v1UpdatePolicyRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1UpdatePolicyResult _$V1UpdatePolicyResultFromJson(
        Map<String, dynamic> json) =>
    V1UpdatePolicyResult(
      policyId: json['policyId'] as String,
    );

Map<String, dynamic> _$V1UpdatePolicyResultToJson(
        V1UpdatePolicyResult instance) =>
    <String, dynamic>{
      'policyId': instance.policyId,
    };

V1UpdatePrivateKeyTagIntent _$V1UpdatePrivateKeyTagIntentFromJson(
        Map<String, dynamic> json) =>
    V1UpdatePrivateKeyTagIntent(
      privateKeyTagId: json['privateKeyTagId'] as String,
      newPrivateKeyTagName: json['newPrivateKeyTagName'] as String?,
      addPrivateKeyIds: (json['addPrivateKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      removePrivateKeyIds: (json['removePrivateKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1UpdatePrivateKeyTagIntentToJson(
        V1UpdatePrivateKeyTagIntent instance) =>
    <String, dynamic>{
      'privateKeyTagId': instance.privateKeyTagId,
      'newPrivateKeyTagName': instance.newPrivateKeyTagName,
      'addPrivateKeyIds': instance.addPrivateKeyIds,
      'removePrivateKeyIds': instance.removePrivateKeyIds,
    };

V1UpdatePrivateKeyTagRequest _$V1UpdatePrivateKeyTagRequestFromJson(
        Map<String, dynamic> json) =>
    V1UpdatePrivateKeyTagRequest(
      type: v1UpdatePrivateKeyTagRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1UpdatePrivateKeyTagIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1UpdatePrivateKeyTagRequestToJson(
        V1UpdatePrivateKeyTagRequest instance) =>
    <String, dynamic>{
      'type': v1UpdatePrivateKeyTagRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1UpdatePrivateKeyTagResult _$V1UpdatePrivateKeyTagResultFromJson(
        Map<String, dynamic> json) =>
    V1UpdatePrivateKeyTagResult(
      privateKeyTagId: json['privateKeyTagId'] as String,
    );

Map<String, dynamic> _$V1UpdatePrivateKeyTagResultToJson(
        V1UpdatePrivateKeyTagResult instance) =>
    <String, dynamic>{
      'privateKeyTagId': instance.privateKeyTagId,
    };

V1UpdateRootQuorumIntent _$V1UpdateRootQuorumIntentFromJson(
        Map<String, dynamic> json) =>
    V1UpdateRootQuorumIntent(
      threshold: (json['threshold'] as num).toInt(),
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1UpdateRootQuorumIntentToJson(
        V1UpdateRootQuorumIntent instance) =>
    <String, dynamic>{
      'threshold': instance.threshold,
      'userIds': instance.userIds,
    };

V1UpdateRootQuorumRequest _$V1UpdateRootQuorumRequestFromJson(
        Map<String, dynamic> json) =>
    V1UpdateRootQuorumRequest(
      type: v1UpdateRootQuorumRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1UpdateRootQuorumIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1UpdateRootQuorumRequestToJson(
        V1UpdateRootQuorumRequest instance) =>
    <String, dynamic>{
      'type': v1UpdateRootQuorumRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1UpdateRootQuorumResult _$V1UpdateRootQuorumResultFromJson(
        Map<String, dynamic> json) =>
    V1UpdateRootQuorumResult();

Map<String, dynamic> _$V1UpdateRootQuorumResultToJson(
        V1UpdateRootQuorumResult instance) =>
    <String, dynamic>{};

V1UpdateUserIntent _$V1UpdateUserIntentFromJson(Map<String, dynamic> json) =>
    V1UpdateUserIntent(
      userId: json['userId'] as String,
      userName: json['userName'] as String?,
      userEmail: json['userEmail'] as String?,
      userTagIds: (json['userTagIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      userPhoneNumber: json['userPhoneNumber'] as String?,
    );

Map<String, dynamic> _$V1UpdateUserIntentToJson(V1UpdateUserIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'userTagIds': instance.userTagIds,
      'userPhoneNumber': instance.userPhoneNumber,
    };

V1UpdateUserRequest _$V1UpdateUserRequestFromJson(Map<String, dynamic> json) =>
    V1UpdateUserRequest(
      type: v1UpdateUserRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1UpdateUserIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1UpdateUserRequestToJson(
        V1UpdateUserRequest instance) =>
    <String, dynamic>{
      'type': v1UpdateUserRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1UpdateUserResult _$V1UpdateUserResultFromJson(Map<String, dynamic> json) =>
    V1UpdateUserResult(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$V1UpdateUserResultToJson(V1UpdateUserResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

V1UpdateUserTagIntent _$V1UpdateUserTagIntentFromJson(
        Map<String, dynamic> json) =>
    V1UpdateUserTagIntent(
      userTagId: json['userTagId'] as String,
      newUserTagName: json['newUserTagName'] as String?,
      addUserIds: (json['addUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      removeUserIds: (json['removeUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1UpdateUserTagIntentToJson(
        V1UpdateUserTagIntent instance) =>
    <String, dynamic>{
      'userTagId': instance.userTagId,
      'newUserTagName': instance.newUserTagName,
      'addUserIds': instance.addUserIds,
      'removeUserIds': instance.removeUserIds,
    };

V1UpdateUserTagRequest _$V1UpdateUserTagRequestFromJson(
        Map<String, dynamic> json) =>
    V1UpdateUserTagRequest(
      type: v1UpdateUserTagRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: V1UpdateUserTagIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1UpdateUserTagRequestToJson(
        V1UpdateUserTagRequest instance) =>
    <String, dynamic>{
      'type': v1UpdateUserTagRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

V1UpdateUserTagResult _$V1UpdateUserTagResultFromJson(
        Map<String, dynamic> json) =>
    V1UpdateUserTagResult(
      userTagId: json['userTagId'] as String,
    );

Map<String, dynamic> _$V1UpdateUserTagResultToJson(
        V1UpdateUserTagResult instance) =>
    <String, dynamic>{
      'userTagId': instance.userTagId,
    };

V1User _$V1UserFromJson(Map<String, dynamic> json) => V1User(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      userPhoneNumber: json['userPhoneNumber'] as String?,
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) => V1Authenticator.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => V1ApiKey.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userTags: (json['userTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      oauthProviders: (json['oauthProviders'] as List<dynamic>?)
              ?.map((e) => V1OauthProvider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: Externaldatav1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: Externaldatav1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1UserToJson(V1User instance) => <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'userPhoneNumber': instance.userPhoneNumber,
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'userTags': instance.userTags,
      'oauthProviders': instance.oauthProviders.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
    };

V1UserParams _$V1UserParamsFromJson(Map<String, dynamic> json) => V1UserParams(
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      accessType: v1AccessTypeFromJson(json['accessType']),
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiApiKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) =>
                  V1AuthenticatorParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userTags: (json['userTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1UserParamsToJson(V1UserParams instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'accessType': v1AccessTypeToJson(instance.accessType),
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
      'userTags': instance.userTags,
    };

V1UserParamsV2 _$V1UserParamsV2FromJson(Map<String, dynamic> json) =>
    V1UserParamsV2(
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiApiKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) =>
                  V1AuthenticatorParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userTags: (json['userTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1UserParamsV2ToJson(V1UserParamsV2 instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
      'userTags': instance.userTags,
    };

V1Vote _$V1VoteFromJson(Map<String, dynamic> json) => V1Vote(
      id: json['id'] as String,
      userId: json['userId'] as String,
      user: V1User.fromJson(json['user'] as Map<String, dynamic>),
      activityId: json['activityId'] as String,
      selection: v1VoteSelectionFromJson(json['selection']),
      message: json['message'] as String,
      publicKey: json['publicKey'] as String,
      signature: json['signature'] as String,
      scheme: json['scheme'] as String,
      // We manually add a check until the API is fixed (See https://github.com/tkhq/mono/pull/3693 for details)
      createdAt: json['createdAt'] == null ? Externaldatav1Timestamp(seconds: '0', nanos: '0') : Externaldatav1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1VoteToJson(V1Vote instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'user': instance.user.toJson(),
      'activityId': instance.activityId,
      'selection': v1VoteSelectionToJson(instance.selection),
      'message': instance.message,
      'publicKey': instance.publicKey,
      'signature': instance.signature,
      'scheme': instance.scheme,
      'createdAt': instance.createdAt.toJson(),
    };

V1Wallet _$V1WalletFromJson(Map<String, dynamic> json) => V1Wallet(
      walletId: json['walletId'] as String,
      walletName: json['walletName'] as String,
      createdAt: Externaldatav1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: Externaldatav1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
      exported: json['exported'] as bool,
      imported: json['imported'] as bool,
    );

Map<String, dynamic> _$V1WalletToJson(V1Wallet instance) => <String, dynamic>{
      'walletId': instance.walletId,
      'walletName': instance.walletName,
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
      'exported': instance.exported,
      'imported': instance.imported,
    };

V1WalletAccount _$V1WalletAccountFromJson(Map<String, dynamic> json) =>
    V1WalletAccount(
      walletAccountId: json['walletAccountId'] as String,
      organizationId: json['organizationId'] as String,
      walletId: json['walletId'] as String,
      curve: v1CurveFromJson(json['curve']),
      pathFormat: v1PathFormatFromJson(json['pathFormat']),
      path: json['path'] as String,
      addressFormat: v1AddressFormatFromJson(json['addressFormat']),
      address: json['address'] as String,
      createdAt: Externaldatav1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: Externaldatav1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1WalletAccountToJson(V1WalletAccount instance) =>
    <String, dynamic>{
      'walletAccountId': instance.walletAccountId,
      'organizationId': instance.organizationId,
      'walletId': instance.walletId,
      'curve': v1CurveToJson(instance.curve),
      'pathFormat': v1PathFormatToJson(instance.pathFormat),
      'path': instance.path,
      'addressFormat': v1AddressFormatToJson(instance.addressFormat),
      'address': instance.address,
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
    };

V1WalletAccountParams _$V1WalletAccountParamsFromJson(
        Map<String, dynamic> json) =>
    V1WalletAccountParams(
      curve: v1CurveFromJson(json['curve']),
      pathFormat: v1PathFormatFromJson(json['pathFormat']),
      path: json['path'] as String,
      addressFormat: v1AddressFormatFromJson(json['addressFormat']),
    );

Map<String, dynamic> _$V1WalletAccountParamsToJson(
        V1WalletAccountParams instance) =>
    <String, dynamic>{
      'curve': v1CurveToJson(instance.curve),
      'pathFormat': v1PathFormatToJson(instance.pathFormat),
      'path': instance.path,
      'addressFormat': v1AddressFormatToJson(instance.addressFormat),
    };

V1WalletParams _$V1WalletParamsFromJson(Map<String, dynamic> json) =>
    V1WalletParams(
      walletName: json['walletName'] as String,
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) =>
                  V1WalletAccountParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      mnemonicLength: (json['mnemonicLength'] as num?)?.toInt(),
    );

Map<String, dynamic> _$V1WalletParamsToJson(V1WalletParams instance) =>
    <String, dynamic>{
      'walletName': instance.walletName,
      'accounts': instance.accounts.map((e) => e.toJson()).toList(),
      'mnemonicLength': instance.mnemonicLength,
    };

V1WalletResult _$V1WalletResultFromJson(Map<String, dynamic> json) =>
    V1WalletResult(
      walletId: json['walletId'] as String,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$V1WalletResultToJson(V1WalletResult instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'addresses': instance.addresses,
    };

V1WebAuthnStamp _$V1WebAuthnStampFromJson(Map<String, dynamic> json) =>
    V1WebAuthnStamp(
      credentialId: json['credentialId'] as String,
      clientDataJson: json['clientDataJson'] as String,
      authenticatorData: json['authenticatorData'] as String,
      signature: json['signature'] as String,
    );

Map<String, dynamic> _$V1WebAuthnStampToJson(V1WebAuthnStamp instance) =>
    <String, dynamic>{
      'credentialId': instance.credentialId,
      'clientDataJson': instance.clientDataJson,
      'authenticatorData': instance.authenticatorData,
      'signature': instance.signature,
    };
