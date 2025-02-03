// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_api.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceptInvitationIntent _$AcceptInvitationIntentFromJson(
        Map<String, dynamic> json) =>
    AcceptInvitationIntent(
      invitationId: json['invitationId'] as String,
      userId: json['userId'] as String,
      authenticator: AuthenticatorParams.fromJson(
          json['authenticator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AcceptInvitationIntentToJson(
        AcceptInvitationIntent instance) =>
    <String, dynamic>{
      'invitationId': instance.invitationId,
      'userId': instance.userId,
      'authenticator': instance.authenticator.toJson(),
    };

AcceptInvitationIntentV2 _$AcceptInvitationIntentV2FromJson(
        Map<String, dynamic> json) =>
    AcceptInvitationIntentV2(
      invitationId: json['invitationId'] as String,
      userId: json['userId'] as String,
      authenticator: AuthenticatorParamsV2.fromJson(
          json['authenticator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AcceptInvitationIntentV2ToJson(
        AcceptInvitationIntentV2 instance) =>
    <String, dynamic>{
      'invitationId': instance.invitationId,
      'userId': instance.userId,
      'authenticator': instance.authenticator.toJson(),
    };

AcceptInvitationResult _$AcceptInvitationResultFromJson(
        Map<String, dynamic> json) =>
    AcceptInvitationResult(
      invitationId: json['invitationId'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$AcceptInvitationResultToJson(
        AcceptInvitationResult instance) =>
    <String, dynamic>{
      'invitationId': instance.invitationId,
      'userId': instance.userId,
    };

ActivateBillingTierIntent _$ActivateBillingTierIntentFromJson(
        Map<String, dynamic> json) =>
    ActivateBillingTierIntent(
      productId: json['productId'] as String,
    );

Map<String, dynamic> _$ActivateBillingTierIntentToJson(
        ActivateBillingTierIntent instance) =>
    <String, dynamic>{
      'productId': instance.productId,
    };

ActivateBillingTierResult _$ActivateBillingTierResultFromJson(
        Map<String, dynamic> json) =>
    ActivateBillingTierResult(
      productId: json['productId'] as String,
    );

Map<String, dynamic> _$ActivateBillingTierResultToJson(
        ActivateBillingTierResult instance) =>
    <String, dynamic>{
      'productId': instance.productId,
    };

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      status: activityStatusFromJson(json['status']),
      type: activityTypeFromJson(json['type']),
      intent: Intent.fromJson(json['intent'] as Map<String, dynamic>),
      result: Result.fromJson(json['result'] as Map<String, dynamic>),
      votes: (json['votes'] as List<dynamic>?)
              ?.map((e) => Vote.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      fingerprint: json['fingerprint'] as String,
      canApprove: json['canApprove'] as bool,
      canReject: json['canReject'] as bool,
      createdAt: ExternalDataV1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: ExternalDataV1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
      failure: json['failure'] == null
          ? null
          : Status.fromJson(json['failure'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'status': activityStatusToJson(instance.status),
      'type': activityTypeToJson(instance.type),
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

ActivityResponse _$ActivityResponseFromJson(Map<String, dynamic> json) =>
    ActivityResponse(
      activity: Activity.fromJson(json['activity'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActivityResponseToJson(ActivityResponse instance) =>
    <String, dynamic>{
      'activity': instance.activity.toJson(),
    };

Any _$AnyFromJson(Map<String, dynamic> json) => Any(
      type: json['@type'] as String?,
    );

Map<String, dynamic> _$AnyToJson(Any instance) => <String, dynamic>{
      '@type': instance.type,
    };

ApiKey _$ApiKeyFromJson(Map<String, dynamic> json) => ApiKey(
      credential: ExternalDataV1Credential.fromJson(
          json['credential'] as Map<String, dynamic>),
      apiKeyId: json['apiKeyId'] as String,
      apiKeyName: json['apiKeyName'] as String,
      createdAt: ExternalDataV1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: ExternalDataV1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
      expirationSeconds: json['expirationSeconds'] as String?,
    );

Map<String, dynamic> _$ApiKeyToJson(ApiKey instance) => <String, dynamic>{
      'credential': instance.credential.toJson(),
      'apiKeyId': instance.apiKeyId,
      'apiKeyName': instance.apiKeyName,
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
      'expirationSeconds': instance.expirationSeconds,
    };

ApiKeyParams _$ApiKeyParamsFromJson(Map<String, dynamic> json) => ApiKeyParams(
      apiKeyName: json['apiKeyName'] as String,
      publicKey: json['publicKey'] as String,
      expirationSeconds: json['expirationSeconds'] as String?,
    );

Map<String, dynamic> _$ApiKeyParamsToJson(ApiKeyParams instance) =>
    <String, dynamic>{
      'apiKeyName': instance.apiKeyName,
      'publicKey': instance.publicKey,
      'expirationSeconds': instance.expirationSeconds,
    };

ApiKeyParamsV2 _$ApiKeyParamsV2FromJson(Map<String, dynamic> json) =>
    ApiKeyParamsV2(
      apiKeyName: json['apiKeyName'] as String,
      publicKey: json['publicKey'] as String,
      curveType: apiKeyCurveFromJson(json['curveType']),
      expirationSeconds: json['expirationSeconds'] as String?,
    );

Map<String, dynamic> _$ApiKeyParamsV2ToJson(ApiKeyParamsV2 instance) =>
    <String, dynamic>{
      'apiKeyName': instance.apiKeyName,
      'publicKey': instance.publicKey,
      'curveType': apiKeyCurveToJson(instance.curveType),
      'expirationSeconds': instance.expirationSeconds,
    };

ApiOnlyUserParams _$ApiOnlyUserParamsFromJson(Map<String, dynamic> json) =>
    ApiOnlyUserParams(
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      userTags: (json['userTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ApiOnlyUserParamsToJson(ApiOnlyUserParams instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'userTags': instance.userTags,
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
    };

ApproveActivityIntent _$ApproveActivityIntentFromJson(
        Map<String, dynamic> json) =>
    ApproveActivityIntent(
      fingerprint: json['fingerprint'] as String,
    );

Map<String, dynamic> _$ApproveActivityIntentToJson(
        ApproveActivityIntent instance) =>
    <String, dynamic>{
      'fingerprint': instance.fingerprint,
    };

ApproveActivityRequest _$ApproveActivityRequestFromJson(
        Map<String, dynamic> json) =>
    ApproveActivityRequest(
      type: approveActivityRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: ApproveActivityIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApproveActivityRequestToJson(
        ApproveActivityRequest instance) =>
    <String, dynamic>{
      'type': approveActivityRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

Attestation _$AttestationFromJson(Map<String, dynamic> json) => Attestation(
      credentialId: json['credentialId'] as String,
      clientDataJson: json['clientDataJson'] as String,
      attestationObject: json['attestationObject'] as String,
      transports:
          authenticatorTransportListFromJson(json['transports'] as List?),
    );

Map<String, dynamic> _$AttestationToJson(Attestation instance) =>
    <String, dynamic>{
      'credentialId': instance.credentialId,
      'clientDataJson': instance.clientDataJson,
      'attestationObject': instance.attestationObject,
      'transports': authenticatorTransportListToJson(instance.transports),
    };

Authenticator _$AuthenticatorFromJson(Map<String, dynamic> json) =>
    Authenticator(
      transports:
          authenticatorTransportListFromJson(json['transports'] as List?),
      attestationType: json['attestationType'] as String,
      aaguid: json['aaguid'] as String,
      credentialId: json['credentialId'] as String,
      model: json['model'] as String,
      credential: ExternalDataV1Credential.fromJson(
          json['credential'] as Map<String, dynamic>),
      authenticatorId: json['authenticatorId'] as String,
      authenticatorName: json['authenticatorName'] as String,
      createdAt: ExternalDataV1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: ExternalDataV1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthenticatorToJson(Authenticator instance) =>
    <String, dynamic>{
      'transports': authenticatorTransportListToJson(instance.transports),
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

AuthenticatorAttestationResponse _$AuthenticatorAttestationResponseFromJson(
        Map<String, dynamic> json) =>
    AuthenticatorAttestationResponse(
      clientDataJson: json['clientDataJson'] as String,
      attestationObject: json['attestationObject'] as String,
      transports:
          authenticatorTransportListFromJson(json['transports'] as List?),
      authenticatorAttachment:
          authenticatorAttestationResponseAuthenticatorAttachmentNullableFromJson(
              json['authenticatorAttachment']),
    );

Map<String, dynamic> _$AuthenticatorAttestationResponseToJson(
        AuthenticatorAttestationResponse instance) =>
    <String, dynamic>{
      'clientDataJson': instance.clientDataJson,
      'attestationObject': instance.attestationObject,
      'transports': authenticatorTransportListToJson(instance.transports),
      'authenticatorAttachment':
          authenticatorAttestationResponseAuthenticatorAttachmentNullableToJson(
              instance.authenticatorAttachment),
    };

AuthenticatorParams _$AuthenticatorParamsFromJson(Map<String, dynamic> json) =>
    AuthenticatorParams(
      authenticatorName: json['authenticatorName'] as String,
      userId: json['userId'] as String,
      attestation: PublicKeyCredentialWithAttestation.fromJson(
          json['attestation'] as Map<String, dynamic>),
      challenge: json['challenge'] as String,
    );

Map<String, dynamic> _$AuthenticatorParamsToJson(
        AuthenticatorParams instance) =>
    <String, dynamic>{
      'authenticatorName': instance.authenticatorName,
      'userId': instance.userId,
      'attestation': instance.attestation.toJson(),
      'challenge': instance.challenge,
    };

AuthenticatorParamsV2 _$AuthenticatorParamsV2FromJson(
        Map<String, dynamic> json) =>
    AuthenticatorParamsV2(
      authenticatorName: json['authenticatorName'] as String,
      challenge: json['challenge'] as String,
      attestation:
          Attestation.fromJson(json['attestation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthenticatorParamsV2ToJson(
        AuthenticatorParamsV2 instance) =>
    <String, dynamic>{
      'authenticatorName': instance.authenticatorName,
      'challenge': instance.challenge,
      'attestation': instance.attestation.toJson(),
    };

Config _$ConfigFromJson(Map<String, dynamic> json) => Config(
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => Feature.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      quorum: json['quorum'] == null
          ? null
          : ExternalDataV1Quorum.fromJson(
              json['quorum'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'features': instance.features?.map((e) => e.toJson()).toList(),
      'quorum': instance.quorum?.toJson(),
    };

CreateApiKeysIntent _$CreateApiKeysIntentFromJson(Map<String, dynamic> json) =>
    CreateApiKeysIntent(
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$CreateApiKeysIntentToJson(
        CreateApiKeysIntent instance) =>
    <String, dynamic>{
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'userId': instance.userId,
    };

CreateApiKeysIntentV2 _$CreateApiKeysIntentV2FromJson(
        Map<String, dynamic> json) =>
    CreateApiKeysIntentV2(
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiKeyParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$CreateApiKeysIntentV2ToJson(
        CreateApiKeysIntentV2 instance) =>
    <String, dynamic>{
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'userId': instance.userId,
    };

CreateApiKeysRequest _$CreateApiKeysRequestFromJson(
        Map<String, dynamic> json) =>
    CreateApiKeysRequest(
      type: createApiKeysRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: CreateApiKeysIntentV2.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateApiKeysRequestToJson(
        CreateApiKeysRequest instance) =>
    <String, dynamic>{
      'type': createApiKeysRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

CreateApiKeysResult _$CreateApiKeysResultFromJson(Map<String, dynamic> json) =>
    CreateApiKeysResult(
      apiKeyIds: (json['apiKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateApiKeysResultToJson(
        CreateApiKeysResult instance) =>
    <String, dynamic>{
      'apiKeyIds': instance.apiKeyIds,
    };

CreateApiOnlyUsersIntent _$CreateApiOnlyUsersIntentFromJson(
        Map<String, dynamic> json) =>
    CreateApiOnlyUsersIntent(
      apiOnlyUsers: (json['apiOnlyUsers'] as List<dynamic>?)
              ?.map(
                  (e) => ApiOnlyUserParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateApiOnlyUsersIntentToJson(
        CreateApiOnlyUsersIntent instance) =>
    <String, dynamic>{
      'apiOnlyUsers': instance.apiOnlyUsers.map((e) => e.toJson()).toList(),
    };

CreateApiOnlyUsersResult _$CreateApiOnlyUsersResultFromJson(
        Map<String, dynamic> json) =>
    CreateApiOnlyUsersResult(
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateApiOnlyUsersResultToJson(
        CreateApiOnlyUsersResult instance) =>
    <String, dynamic>{
      'userIds': instance.userIds,
    };

CreateAuthenticatorsIntent _$CreateAuthenticatorsIntentFromJson(
        Map<String, dynamic> json) =>
    CreateAuthenticatorsIntent(
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) =>
                  AuthenticatorParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$CreateAuthenticatorsIntentToJson(
        CreateAuthenticatorsIntent instance) =>
    <String, dynamic>{
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
      'userId': instance.userId,
    };

CreateAuthenticatorsIntentV2 _$CreateAuthenticatorsIntentV2FromJson(
        Map<String, dynamic> json) =>
    CreateAuthenticatorsIntentV2(
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) =>
                  AuthenticatorParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$CreateAuthenticatorsIntentV2ToJson(
        CreateAuthenticatorsIntentV2 instance) =>
    <String, dynamic>{
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
      'userId': instance.userId,
    };

CreateAuthenticatorsRequest _$CreateAuthenticatorsRequestFromJson(
        Map<String, dynamic> json) =>
    CreateAuthenticatorsRequest(
      type: createAuthenticatorsRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: CreateAuthenticatorsIntentV2.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateAuthenticatorsRequestToJson(
        CreateAuthenticatorsRequest instance) =>
    <String, dynamic>{
      'type': createAuthenticatorsRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

CreateAuthenticatorsResult _$CreateAuthenticatorsResultFromJson(
        Map<String, dynamic> json) =>
    CreateAuthenticatorsResult(
      authenticatorIds: (json['authenticatorIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateAuthenticatorsResultToJson(
        CreateAuthenticatorsResult instance) =>
    <String, dynamic>{
      'authenticatorIds': instance.authenticatorIds,
    };

CreateInvitationsIntent _$CreateInvitationsIntentFromJson(
        Map<String, dynamic> json) =>
    CreateInvitationsIntent(
      invitations: (json['invitations'] as List<dynamic>?)
              ?.map((e) => InvitationParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateInvitationsIntentToJson(
        CreateInvitationsIntent instance) =>
    <String, dynamic>{
      'invitations': instance.invitations.map((e) => e.toJson()).toList(),
    };

CreateInvitationsRequest _$CreateInvitationsRequestFromJson(
        Map<String, dynamic> json) =>
    CreateInvitationsRequest(
      type: createInvitationsRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: CreateInvitationsIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateInvitationsRequestToJson(
        CreateInvitationsRequest instance) =>
    <String, dynamic>{
      'type': createInvitationsRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

CreateInvitationsResult _$CreateInvitationsResultFromJson(
        Map<String, dynamic> json) =>
    CreateInvitationsResult(
      invitationIds: (json['invitationIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateInvitationsResultToJson(
        CreateInvitationsResult instance) =>
    <String, dynamic>{
      'invitationIds': instance.invitationIds,
    };

CreateOauthProvidersIntent _$CreateOauthProvidersIntentFromJson(
        Map<String, dynamic> json) =>
    CreateOauthProvidersIntent(
      userId: json['userId'] as String,
      oauthProviders: (json['oauthProviders'] as List<dynamic>?)
              ?.map((e) =>
                  OauthProviderParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateOauthProvidersIntentToJson(
        CreateOauthProvidersIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'oauthProviders': instance.oauthProviders.map((e) => e.toJson()).toList(),
    };

CreateOauthProvidersRequest _$CreateOauthProvidersRequestFromJson(
        Map<String, dynamic> json) =>
    CreateOauthProvidersRequest(
      type: createOauthProvidersRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: CreateOauthProvidersIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateOauthProvidersRequestToJson(
        CreateOauthProvidersRequest instance) =>
    <String, dynamic>{
      'type': createOauthProvidersRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

CreateOauthProvidersResult _$CreateOauthProvidersResultFromJson(
        Map<String, dynamic> json) =>
    CreateOauthProvidersResult(
      providerIds: (json['providerIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateOauthProvidersResultToJson(
        CreateOauthProvidersResult instance) =>
    <String, dynamic>{
      'providerIds': instance.providerIds,
    };

CreateOrganizationIntent _$CreateOrganizationIntentFromJson(
        Map<String, dynamic> json) =>
    CreateOrganizationIntent(
      organizationName: json['organizationName'] as String,
      rootEmail: json['rootEmail'] as String,
      rootAuthenticator: AuthenticatorParams.fromJson(
          json['rootAuthenticator'] as Map<String, dynamic>),
      rootUserId: json['rootUserId'] as String?,
    );

Map<String, dynamic> _$CreateOrganizationIntentToJson(
        CreateOrganizationIntent instance) =>
    <String, dynamic>{
      'organizationName': instance.organizationName,
      'rootEmail': instance.rootEmail,
      'rootAuthenticator': instance.rootAuthenticator.toJson(),
      'rootUserId': instance.rootUserId,
    };

CreateOrganizationIntentV2 _$CreateOrganizationIntentV2FromJson(
        Map<String, dynamic> json) =>
    CreateOrganizationIntentV2(
      organizationName: json['organizationName'] as String,
      rootEmail: json['rootEmail'] as String,
      rootAuthenticator: AuthenticatorParamsV2.fromJson(
          json['rootAuthenticator'] as Map<String, dynamic>),
      rootUserId: json['rootUserId'] as String?,
    );

Map<String, dynamic> _$CreateOrganizationIntentV2ToJson(
        CreateOrganizationIntentV2 instance) =>
    <String, dynamic>{
      'organizationName': instance.organizationName,
      'rootEmail': instance.rootEmail,
      'rootAuthenticator': instance.rootAuthenticator.toJson(),
      'rootUserId': instance.rootUserId,
    };

CreateOrganizationResult _$CreateOrganizationResultFromJson(
        Map<String, dynamic> json) =>
    CreateOrganizationResult(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$CreateOrganizationResultToJson(
        CreateOrganizationResult instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

CreatePoliciesIntent _$CreatePoliciesIntentFromJson(
        Map<String, dynamic> json) =>
    CreatePoliciesIntent(
      policies: (json['policies'] as List<dynamic>?)
              ?.map((e) =>
                  CreatePolicyIntentV3.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreatePoliciesIntentToJson(
        CreatePoliciesIntent instance) =>
    <String, dynamic>{
      'policies': instance.policies.map((e) => e.toJson()).toList(),
    };

CreatePoliciesRequest _$CreatePoliciesRequestFromJson(
        Map<String, dynamic> json) =>
    CreatePoliciesRequest(
      type: createPoliciesRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: CreatePoliciesIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreatePoliciesRequestToJson(
        CreatePoliciesRequest instance) =>
    <String, dynamic>{
      'type': createPoliciesRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

CreatePoliciesResult _$CreatePoliciesResultFromJson(
        Map<String, dynamic> json) =>
    CreatePoliciesResult(
      policyIds: (json['policyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreatePoliciesResultToJson(
        CreatePoliciesResult instance) =>
    <String, dynamic>{
      'policyIds': instance.policyIds,
    };

CreatePolicyIntent _$CreatePolicyIntentFromJson(Map<String, dynamic> json) =>
    CreatePolicyIntent(
      policyName: json['policyName'] as String,
      selectors: (json['selectors'] as List<dynamic>?)
              ?.map((e) => Selector.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      effect: effectFromJson(json['effect']),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$CreatePolicyIntentToJson(CreatePolicyIntent instance) =>
    <String, dynamic>{
      'policyName': instance.policyName,
      'selectors': instance.selectors.map((e) => e.toJson()).toList(),
      'effect': effectToJson(instance.effect),
      'notes': instance.notes,
    };

CreatePolicyIntentV2 _$CreatePolicyIntentV2FromJson(
        Map<String, dynamic> json) =>
    CreatePolicyIntentV2(
      policyName: json['policyName'] as String,
      selectors: (json['selectors'] as List<dynamic>?)
              ?.map((e) => SelectorV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      effect: effectFromJson(json['effect']),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$CreatePolicyIntentV2ToJson(
        CreatePolicyIntentV2 instance) =>
    <String, dynamic>{
      'policyName': instance.policyName,
      'selectors': instance.selectors.map((e) => e.toJson()).toList(),
      'effect': effectToJson(instance.effect),
      'notes': instance.notes,
    };

CreatePolicyIntentV3 _$CreatePolicyIntentV3FromJson(
        Map<String, dynamic> json) =>
    CreatePolicyIntentV3(
      policyName: json['policyName'] as String,
      effect: effectFromJson(json['effect']),
      condition: json['condition'] as String?,
      consensus: json['consensus'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$CreatePolicyIntentV3ToJson(
        CreatePolicyIntentV3 instance) =>
    <String, dynamic>{
      'policyName': instance.policyName,
      'effect': effectToJson(instance.effect),
      'condition': instance.condition,
      'consensus': instance.consensus,
      'notes': instance.notes,
    };

CreatePolicyRequest _$CreatePolicyRequestFromJson(Map<String, dynamic> json) =>
    CreatePolicyRequest(
      type: createPolicyRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: CreatePolicyIntentV3.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreatePolicyRequestToJson(
        CreatePolicyRequest instance) =>
    <String, dynamic>{
      'type': createPolicyRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

CreatePolicyResult _$CreatePolicyResultFromJson(Map<String, dynamic> json) =>
    CreatePolicyResult(
      policyId: json['policyId'] as String,
    );

Map<String, dynamic> _$CreatePolicyResultToJson(CreatePolicyResult instance) =>
    <String, dynamic>{
      'policyId': instance.policyId,
    };

CreatePrivateKeyTagIntent _$CreatePrivateKeyTagIntentFromJson(
        Map<String, dynamic> json) =>
    CreatePrivateKeyTagIntent(
      privateKeyTagName: json['privateKeyTagName'] as String,
      privateKeyIds: (json['privateKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreatePrivateKeyTagIntentToJson(
        CreatePrivateKeyTagIntent instance) =>
    <String, dynamic>{
      'privateKeyTagName': instance.privateKeyTagName,
      'privateKeyIds': instance.privateKeyIds,
    };

CreatePrivateKeyTagRequest _$CreatePrivateKeyTagRequestFromJson(
        Map<String, dynamic> json) =>
    CreatePrivateKeyTagRequest(
      type: createPrivateKeyTagRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: CreatePrivateKeyTagIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreatePrivateKeyTagRequestToJson(
        CreatePrivateKeyTagRequest instance) =>
    <String, dynamic>{
      'type': createPrivateKeyTagRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

CreatePrivateKeyTagResult _$CreatePrivateKeyTagResultFromJson(
        Map<String, dynamic> json) =>
    CreatePrivateKeyTagResult(
      privateKeyTagId: json['privateKeyTagId'] as String,
      privateKeyIds: (json['privateKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreatePrivateKeyTagResultToJson(
        CreatePrivateKeyTagResult instance) =>
    <String, dynamic>{
      'privateKeyTagId': instance.privateKeyTagId,
      'privateKeyIds': instance.privateKeyIds,
    };

CreatePrivateKeysIntent _$CreatePrivateKeysIntentFromJson(
        Map<String, dynamic> json) =>
    CreatePrivateKeysIntent(
      privateKeys: (json['privateKeys'] as List<dynamic>?)
              ?.map((e) => PrivateKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreatePrivateKeysIntentToJson(
        CreatePrivateKeysIntent instance) =>
    <String, dynamic>{
      'privateKeys': instance.privateKeys.map((e) => e.toJson()).toList(),
    };

CreatePrivateKeysIntentV2 _$CreatePrivateKeysIntentV2FromJson(
        Map<String, dynamic> json) =>
    CreatePrivateKeysIntentV2(
      privateKeys: (json['privateKeys'] as List<dynamic>?)
              ?.map((e) => PrivateKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreatePrivateKeysIntentV2ToJson(
        CreatePrivateKeysIntentV2 instance) =>
    <String, dynamic>{
      'privateKeys': instance.privateKeys.map((e) => e.toJson()).toList(),
    };

CreatePrivateKeysRequest _$CreatePrivateKeysRequestFromJson(
        Map<String, dynamic> json) =>
    CreatePrivateKeysRequest(
      type: createPrivateKeysRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: CreatePrivateKeysIntentV2.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreatePrivateKeysRequestToJson(
        CreatePrivateKeysRequest instance) =>
    <String, dynamic>{
      'type': createPrivateKeysRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

CreatePrivateKeysResult _$CreatePrivateKeysResultFromJson(
        Map<String, dynamic> json) =>
    CreatePrivateKeysResult(
      privateKeyIds: (json['privateKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreatePrivateKeysResultToJson(
        CreatePrivateKeysResult instance) =>
    <String, dynamic>{
      'privateKeyIds': instance.privateKeyIds,
    };

CreatePrivateKeysResultV2 _$CreatePrivateKeysResultV2FromJson(
        Map<String, dynamic> json) =>
    CreatePrivateKeysResultV2(
      privateKeys: (json['privateKeys'] as List<dynamic>?)
              ?.map((e) => PrivateKeyResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreatePrivateKeysResultV2ToJson(
        CreatePrivateKeysResultV2 instance) =>
    <String, dynamic>{
      'privateKeys': instance.privateKeys.map((e) => e.toJson()).toList(),
    };

CreateReadOnlySessionIntent _$CreateReadOnlySessionIntentFromJson(
        Map<String, dynamic> json) =>
    CreateReadOnlySessionIntent();

Map<String, dynamic> _$CreateReadOnlySessionIntentToJson(
        CreateReadOnlySessionIntent instance) =>
    <String, dynamic>{};

CreateReadOnlySessionRequest _$CreateReadOnlySessionRequestFromJson(
        Map<String, dynamic> json) =>
    CreateReadOnlySessionRequest(
      type: createReadOnlySessionRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: CreateReadOnlySessionIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateReadOnlySessionRequestToJson(
        CreateReadOnlySessionRequest instance) =>
    <String, dynamic>{
      'type': createReadOnlySessionRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

CreateReadOnlySessionResult _$CreateReadOnlySessionResultFromJson(
        Map<String, dynamic> json) =>
    CreateReadOnlySessionResult(
      organizationId: json['organizationId'] as String,
      organizationName: json['organizationName'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      session: json['session'] as String,
      sessionExpiry: json['sessionExpiry'] as String,
    );

Map<String, dynamic> _$CreateReadOnlySessionResultToJson(
        CreateReadOnlySessionResult instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'organizationName': instance.organizationName,
      'userId': instance.userId,
      'username': instance.username,
      'session': instance.session,
      'sessionExpiry': instance.sessionExpiry,
    };

CreateReadWriteSessionIntent _$CreateReadWriteSessionIntentFromJson(
        Map<String, dynamic> json) =>
    CreateReadWriteSessionIntent(
      targetPublicKey: json['targetPublicKey'] as String,
      email: json['email'] as String,
      apiKeyName: json['apiKeyName'] as String?,
      expirationSeconds: json['expirationSeconds'] as String?,
    );

Map<String, dynamic> _$CreateReadWriteSessionIntentToJson(
        CreateReadWriteSessionIntent instance) =>
    <String, dynamic>{
      'targetPublicKey': instance.targetPublicKey,
      'email': instance.email,
      'apiKeyName': instance.apiKeyName,
      'expirationSeconds': instance.expirationSeconds,
    };

CreateReadWriteSessionIntentV2 _$CreateReadWriteSessionIntentV2FromJson(
        Map<String, dynamic> json) =>
    CreateReadWriteSessionIntentV2(
      targetPublicKey: json['targetPublicKey'] as String,
      userId: json['userId'] as String?,
      apiKeyName: json['apiKeyName'] as String?,
      expirationSeconds: json['expirationSeconds'] as String?,
    );

Map<String, dynamic> _$CreateReadWriteSessionIntentV2ToJson(
        CreateReadWriteSessionIntentV2 instance) =>
    <String, dynamic>{
      'targetPublicKey': instance.targetPublicKey,
      'userId': instance.userId,
      'apiKeyName': instance.apiKeyName,
      'expirationSeconds': instance.expirationSeconds,
    };

CreateReadWriteSessionRequest _$CreateReadWriteSessionRequestFromJson(
        Map<String, dynamic> json) =>
    CreateReadWriteSessionRequest(
      type: createReadWriteSessionRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: CreateReadWriteSessionIntentV2.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateReadWriteSessionRequestToJson(
        CreateReadWriteSessionRequest instance) =>
    <String, dynamic>{
      'type': createReadWriteSessionRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

CreateReadWriteSessionResult _$CreateReadWriteSessionResultFromJson(
        Map<String, dynamic> json) =>
    CreateReadWriteSessionResult(
      organizationId: json['organizationId'] as String,
      organizationName: json['organizationName'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      apiKeyId: json['apiKeyId'] as String,
      credentialBundle: json['credentialBundle'] as String,
    );

Map<String, dynamic> _$CreateReadWriteSessionResultToJson(
        CreateReadWriteSessionResult instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'organizationName': instance.organizationName,
      'userId': instance.userId,
      'username': instance.username,
      'apiKeyId': instance.apiKeyId,
      'credentialBundle': instance.credentialBundle,
    };

CreateReadWriteSessionResultV2 _$CreateReadWriteSessionResultV2FromJson(
        Map<String, dynamic> json) =>
    CreateReadWriteSessionResultV2(
      organizationId: json['organizationId'] as String,
      organizationName: json['organizationName'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      apiKeyId: json['apiKeyId'] as String,
      credentialBundle: json['credentialBundle'] as String,
    );

Map<String, dynamic> _$CreateReadWriteSessionResultV2ToJson(
        CreateReadWriteSessionResultV2 instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'organizationName': instance.organizationName,
      'userId': instance.userId,
      'username': instance.username,
      'apiKeyId': instance.apiKeyId,
      'credentialBundle': instance.credentialBundle,
    };

CreateSubOrganizationIntent _$CreateSubOrganizationIntentFromJson(
        Map<String, dynamic> json) =>
    CreateSubOrganizationIntent(
      name: json['name'] as String,
      rootAuthenticator: AuthenticatorParamsV2.fromJson(
          json['rootAuthenticator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateSubOrganizationIntentToJson(
        CreateSubOrganizationIntent instance) =>
    <String, dynamic>{
      'name': instance.name,
      'rootAuthenticator': instance.rootAuthenticator.toJson(),
    };

CreateSubOrganizationIntentV2 _$CreateSubOrganizationIntentV2FromJson(
        Map<String, dynamic> json) =>
    CreateSubOrganizationIntentV2(
      subOrganizationName: json['subOrganizationName'] as String,
      rootUsers: (json['rootUsers'] as List<dynamic>?)
              ?.map((e) => RootUserParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rootQuorumThreshold: (json['rootQuorumThreshold'] as num).toInt(),
    );

Map<String, dynamic> _$CreateSubOrganizationIntentV2ToJson(
        CreateSubOrganizationIntentV2 instance) =>
    <String, dynamic>{
      'subOrganizationName': instance.subOrganizationName,
      'rootUsers': instance.rootUsers.map((e) => e.toJson()).toList(),
      'rootQuorumThreshold': instance.rootQuorumThreshold,
    };

CreateSubOrganizationIntentV3 _$CreateSubOrganizationIntentV3FromJson(
        Map<String, dynamic> json) =>
    CreateSubOrganizationIntentV3(
      subOrganizationName: json['subOrganizationName'] as String,
      rootUsers: (json['rootUsers'] as List<dynamic>?)
              ?.map((e) => RootUserParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rootQuorumThreshold: (json['rootQuorumThreshold'] as num).toInt(),
      privateKeys: (json['privateKeys'] as List<dynamic>?)
              ?.map((e) => PrivateKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateSubOrganizationIntentV3ToJson(
        CreateSubOrganizationIntentV3 instance) =>
    <String, dynamic>{
      'subOrganizationName': instance.subOrganizationName,
      'rootUsers': instance.rootUsers.map((e) => e.toJson()).toList(),
      'rootQuorumThreshold': instance.rootQuorumThreshold,
      'privateKeys': instance.privateKeys.map((e) => e.toJson()).toList(),
    };

CreateSubOrganizationIntentV4 _$CreateSubOrganizationIntentV4FromJson(
        Map<String, dynamic> json) =>
    CreateSubOrganizationIntentV4(
      subOrganizationName: json['subOrganizationName'] as String,
      rootUsers: (json['rootUsers'] as List<dynamic>?)
              ?.map((e) => RootUserParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rootQuorumThreshold: (json['rootQuorumThreshold'] as num).toInt(),
      wallet: json['wallet'] == null
          ? null
          : WalletParams.fromJson(json['wallet'] as Map<String, dynamic>),
      disableEmailRecovery: json['disableEmailRecovery'] as bool?,
      disableEmailAuth: json['disableEmailAuth'] as bool?,
    );

Map<String, dynamic> _$CreateSubOrganizationIntentV4ToJson(
        CreateSubOrganizationIntentV4 instance) =>
    <String, dynamic>{
      'subOrganizationName': instance.subOrganizationName,
      'rootUsers': instance.rootUsers.map((e) => e.toJson()).toList(),
      'rootQuorumThreshold': instance.rootQuorumThreshold,
      'wallet': instance.wallet?.toJson(),
      'disableEmailRecovery': instance.disableEmailRecovery,
      'disableEmailAuth': instance.disableEmailAuth,
    };

CreateSubOrganizationIntentV5 _$CreateSubOrganizationIntentV5FromJson(
        Map<String, dynamic> json) =>
    CreateSubOrganizationIntentV5(
      subOrganizationName: json['subOrganizationName'] as String,
      rootUsers: (json['rootUsers'] as List<dynamic>?)
              ?.map((e) => RootUserParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rootQuorumThreshold: (json['rootQuorumThreshold'] as num).toInt(),
      wallet: json['wallet'] == null
          ? null
          : WalletParams.fromJson(json['wallet'] as Map<String, dynamic>),
      disableEmailRecovery: json['disableEmailRecovery'] as bool?,
      disableEmailAuth: json['disableEmailAuth'] as bool?,
    );

Map<String, dynamic> _$CreateSubOrganizationIntentV5ToJson(
        CreateSubOrganizationIntentV5 instance) =>
    <String, dynamic>{
      'subOrganizationName': instance.subOrganizationName,
      'rootUsers': instance.rootUsers.map((e) => e.toJson()).toList(),
      'rootQuorumThreshold': instance.rootQuorumThreshold,
      'wallet': instance.wallet?.toJson(),
      'disableEmailRecovery': instance.disableEmailRecovery,
      'disableEmailAuth': instance.disableEmailAuth,
    };

CreateSubOrganizationIntentV6 _$CreateSubOrganizationIntentV6FromJson(
        Map<String, dynamic> json) =>
    CreateSubOrganizationIntentV6(
      subOrganizationName: json['subOrganizationName'] as String,
      rootUsers: (json['rootUsers'] as List<dynamic>?)
              ?.map((e) => RootUserParamsV3.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rootQuorumThreshold: (json['rootQuorumThreshold'] as num).toInt(),
      wallet: json['wallet'] == null
          ? null
          : WalletParams.fromJson(json['wallet'] as Map<String, dynamic>),
      disableEmailRecovery: json['disableEmailRecovery'] as bool?,
      disableEmailAuth: json['disableEmailAuth'] as bool?,
    );

Map<String, dynamic> _$CreateSubOrganizationIntentV6ToJson(
        CreateSubOrganizationIntentV6 instance) =>
    <String, dynamic>{
      'subOrganizationName': instance.subOrganizationName,
      'rootUsers': instance.rootUsers.map((e) => e.toJson()).toList(),
      'rootQuorumThreshold': instance.rootQuorumThreshold,
      'wallet': instance.wallet?.toJson(),
      'disableEmailRecovery': instance.disableEmailRecovery,
      'disableEmailAuth': instance.disableEmailAuth,
    };

CreateSubOrganizationIntentV7 _$CreateSubOrganizationIntentV7FromJson(
        Map<String, dynamic> json) =>
    CreateSubOrganizationIntentV7(
      subOrganizationName: json['subOrganizationName'] as String,
      rootUsers: (json['rootUsers'] as List<dynamic>?)
              ?.map((e) => RootUserParamsV4.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rootQuorumThreshold: (json['rootQuorumThreshold'] as num).toInt(),
      wallet: json['wallet'] == null
          ? null
          : WalletParams.fromJson(json['wallet'] as Map<String, dynamic>),
      disableEmailRecovery: json['disableEmailRecovery'] as bool?,
      disableEmailAuth: json['disableEmailAuth'] as bool?,
      disableSmsAuth: json['disableSmsAuth'] as bool?,
      disableOtpEmailAuth: json['disableOtpEmailAuth'] as bool?,
    );

Map<String, dynamic> _$CreateSubOrganizationIntentV7ToJson(
        CreateSubOrganizationIntentV7 instance) =>
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

CreateSubOrganizationRequest _$CreateSubOrganizationRequestFromJson(
        Map<String, dynamic> json) =>
    CreateSubOrganizationRequest(
      type: createSubOrganizationRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: CreateSubOrganizationIntentV7.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateSubOrganizationRequestToJson(
        CreateSubOrganizationRequest instance) =>
    <String, dynamic>{
      'type': createSubOrganizationRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

CreateSubOrganizationResult _$CreateSubOrganizationResultFromJson(
        Map<String, dynamic> json) =>
    CreateSubOrganizationResult(
      subOrganizationId: json['subOrganizationId'] as String,
      rootUserIds: (json['rootUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateSubOrganizationResultToJson(
        CreateSubOrganizationResult instance) =>
    <String, dynamic>{
      'subOrganizationId': instance.subOrganizationId,
      'rootUserIds': instance.rootUserIds,
    };

CreateSubOrganizationResultV3 _$CreateSubOrganizationResultV3FromJson(
        Map<String, dynamic> json) =>
    CreateSubOrganizationResultV3(
      subOrganizationId: json['subOrganizationId'] as String,
      privateKeys: (json['privateKeys'] as List<dynamic>?)
              ?.map((e) => PrivateKeyResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rootUserIds: (json['rootUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateSubOrganizationResultV3ToJson(
        CreateSubOrganizationResultV3 instance) =>
    <String, dynamic>{
      'subOrganizationId': instance.subOrganizationId,
      'privateKeys': instance.privateKeys.map((e) => e.toJson()).toList(),
      'rootUserIds': instance.rootUserIds,
    };

CreateSubOrganizationResultV4 _$CreateSubOrganizationResultV4FromJson(
        Map<String, dynamic> json) =>
    CreateSubOrganizationResultV4(
      subOrganizationId: json['subOrganizationId'] as String,
      wallet: json['wallet'] == null
          ? null
          : WalletResult.fromJson(json['wallet'] as Map<String, dynamic>),
      rootUserIds: (json['rootUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateSubOrganizationResultV4ToJson(
        CreateSubOrganizationResultV4 instance) =>
    <String, dynamic>{
      'subOrganizationId': instance.subOrganizationId,
      'wallet': instance.wallet?.toJson(),
      'rootUserIds': instance.rootUserIds,
    };

CreateSubOrganizationResultV5 _$CreateSubOrganizationResultV5FromJson(
        Map<String, dynamic> json) =>
    CreateSubOrganizationResultV5(
      subOrganizationId: json['subOrganizationId'] as String,
      wallet: json['wallet'] == null
          ? null
          : WalletResult.fromJson(json['wallet'] as Map<String, dynamic>),
      rootUserIds: (json['rootUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateSubOrganizationResultV5ToJson(
        CreateSubOrganizationResultV5 instance) =>
    <String, dynamic>{
      'subOrganizationId': instance.subOrganizationId,
      'wallet': instance.wallet?.toJson(),
      'rootUserIds': instance.rootUserIds,
    };

CreateSubOrganizationResultV6 _$CreateSubOrganizationResultV6FromJson(
        Map<String, dynamic> json) =>
    CreateSubOrganizationResultV6(
      subOrganizationId: json['subOrganizationId'] as String,
      wallet: json['wallet'] == null
          ? null
          : WalletResult.fromJson(json['wallet'] as Map<String, dynamic>),
      rootUserIds: (json['rootUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateSubOrganizationResultV6ToJson(
        CreateSubOrganizationResultV6 instance) =>
    <String, dynamic>{
      'subOrganizationId': instance.subOrganizationId,
      'wallet': instance.wallet?.toJson(),
      'rootUserIds': instance.rootUserIds,
    };

CreateSubOrganizationResultV7 _$CreateSubOrganizationResultV7FromJson(
        Map<String, dynamic> json) =>
    CreateSubOrganizationResultV7(
      subOrganizationId: json['subOrganizationId'] as String,
      wallet: json['wallet'] == null
          ? null
          : WalletResult.fromJson(json['wallet'] as Map<String, dynamic>),
      rootUserIds: (json['rootUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateSubOrganizationResultV7ToJson(
        CreateSubOrganizationResultV7 instance) =>
    <String, dynamic>{
      'subOrganizationId': instance.subOrganizationId,
      'wallet': instance.wallet?.toJson(),
      'rootUserIds': instance.rootUserIds,
    };

CreateUserTagIntent _$CreateUserTagIntentFromJson(Map<String, dynamic> json) =>
    CreateUserTagIntent(
      userTagName: json['userTagName'] as String,
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateUserTagIntentToJson(
        CreateUserTagIntent instance) =>
    <String, dynamic>{
      'userTagName': instance.userTagName,
      'userIds': instance.userIds,
    };

CreateUserTagRequest _$CreateUserTagRequestFromJson(
        Map<String, dynamic> json) =>
    CreateUserTagRequest(
      type: createUserTagRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: CreateUserTagIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateUserTagRequestToJson(
        CreateUserTagRequest instance) =>
    <String, dynamic>{
      'type': createUserTagRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

CreateUserTagResult _$CreateUserTagResultFromJson(Map<String, dynamic> json) =>
    CreateUserTagResult(
      userTagId: json['userTagId'] as String,
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateUserTagResultToJson(
        CreateUserTagResult instance) =>
    <String, dynamic>{
      'userTagId': instance.userTagId,
      'userIds': instance.userIds,
    };

CreateUsersIntent _$CreateUsersIntentFromJson(Map<String, dynamic> json) =>
    CreateUsersIntent(
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => UserParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateUsersIntentToJson(CreateUsersIntent instance) =>
    <String, dynamic>{
      'users': instance.users.map((e) => e.toJson()).toList(),
    };

CreateUsersIntentV2 _$CreateUsersIntentV2FromJson(Map<String, dynamic> json) =>
    CreateUsersIntentV2(
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => UserParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateUsersIntentV2ToJson(
        CreateUsersIntentV2 instance) =>
    <String, dynamic>{
      'users': instance.users.map((e) => e.toJson()).toList(),
    };

CreateUsersRequest _$CreateUsersRequestFromJson(Map<String, dynamic> json) =>
    CreateUsersRequest(
      type: createUsersRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: CreateUsersIntentV2.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateUsersRequestToJson(CreateUsersRequest instance) =>
    <String, dynamic>{
      'type': createUsersRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

CreateUsersResult _$CreateUsersResultFromJson(Map<String, dynamic> json) =>
    CreateUsersResult(
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateUsersResultToJson(CreateUsersResult instance) =>
    <String, dynamic>{
      'userIds': instance.userIds,
    };

CreateWalletAccountsIntent _$CreateWalletAccountsIntentFromJson(
        Map<String, dynamic> json) =>
    CreateWalletAccountsIntent(
      walletId: json['walletId'] as String,
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) =>
                  WalletAccountParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateWalletAccountsIntentToJson(
        CreateWalletAccountsIntent instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'accounts': instance.accounts.map((e) => e.toJson()).toList(),
    };

CreateWalletAccountsRequest _$CreateWalletAccountsRequestFromJson(
        Map<String, dynamic> json) =>
    CreateWalletAccountsRequest(
      type: createWalletAccountsRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: CreateWalletAccountsIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateWalletAccountsRequestToJson(
        CreateWalletAccountsRequest instance) =>
    <String, dynamic>{
      'type': createWalletAccountsRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

CreateWalletAccountsResult _$CreateWalletAccountsResultFromJson(
        Map<String, dynamic> json) =>
    CreateWalletAccountsResult(
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateWalletAccountsResultToJson(
        CreateWalletAccountsResult instance) =>
    <String, dynamic>{
      'addresses': instance.addresses,
    };

CreateWalletIntent _$CreateWalletIntentFromJson(Map<String, dynamic> json) =>
    CreateWalletIntent(
      walletName: json['walletName'] as String,
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) =>
                  WalletAccountParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      mnemonicLength: (json['mnemonicLength'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CreateWalletIntentToJson(CreateWalletIntent instance) =>
    <String, dynamic>{
      'walletName': instance.walletName,
      'accounts': instance.accounts.map((e) => e.toJson()).toList(),
      'mnemonicLength': instance.mnemonicLength,
    };

CreateWalletRequest _$CreateWalletRequestFromJson(Map<String, dynamic> json) =>
    CreateWalletRequest(
      type: createWalletRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: CreateWalletIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateWalletRequestToJson(
        CreateWalletRequest instance) =>
    <String, dynamic>{
      'type': createWalletRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

CreateWalletResult _$CreateWalletResultFromJson(Map<String, dynamic> json) =>
    CreateWalletResult(
      walletId: json['walletId'] as String,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateWalletResultToJson(CreateWalletResult instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'addresses': instance.addresses,
    };

CredPropsAuthenticationExtensionsClientOutputs
    _$CredPropsAuthenticationExtensionsClientOutputsFromJson(
            Map<String, dynamic> json) =>
        CredPropsAuthenticationExtensionsClientOutputs(
          rk: json['rk'] as bool,
        );

Map<String, dynamic> _$CredPropsAuthenticationExtensionsClientOutputsToJson(
        CredPropsAuthenticationExtensionsClientOutputs instance) =>
    <String, dynamic>{
      'rk': instance.rk,
    };

DeleteApiKeysIntent _$DeleteApiKeysIntentFromJson(Map<String, dynamic> json) =>
    DeleteApiKeysIntent(
      userId: json['userId'] as String,
      apiKeyIds: (json['apiKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$DeleteApiKeysIntentToJson(
        DeleteApiKeysIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'apiKeyIds': instance.apiKeyIds,
    };

DeleteApiKeysRequest _$DeleteApiKeysRequestFromJson(
        Map<String, dynamic> json) =>
    DeleteApiKeysRequest(
      type: deleteApiKeysRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: DeleteApiKeysIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeleteApiKeysRequestToJson(
        DeleteApiKeysRequest instance) =>
    <String, dynamic>{
      'type': deleteApiKeysRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

DeleteApiKeysResult _$DeleteApiKeysResultFromJson(Map<String, dynamic> json) =>
    DeleteApiKeysResult(
      apiKeyIds: (json['apiKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$DeleteApiKeysResultToJson(
        DeleteApiKeysResult instance) =>
    <String, dynamic>{
      'apiKeyIds': instance.apiKeyIds,
    };

DeleteAuthenticatorsIntent _$DeleteAuthenticatorsIntentFromJson(
        Map<String, dynamic> json) =>
    DeleteAuthenticatorsIntent(
      userId: json['userId'] as String,
      authenticatorIds: (json['authenticatorIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$DeleteAuthenticatorsIntentToJson(
        DeleteAuthenticatorsIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'authenticatorIds': instance.authenticatorIds,
    };

DeleteAuthenticatorsRequest _$DeleteAuthenticatorsRequestFromJson(
        Map<String, dynamic> json) =>
    DeleteAuthenticatorsRequest(
      type: deleteAuthenticatorsRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: DeleteAuthenticatorsIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeleteAuthenticatorsRequestToJson(
        DeleteAuthenticatorsRequest instance) =>
    <String, dynamic>{
      'type': deleteAuthenticatorsRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

DeleteAuthenticatorsResult _$DeleteAuthenticatorsResultFromJson(
        Map<String, dynamic> json) =>
    DeleteAuthenticatorsResult(
      authenticatorIds: (json['authenticatorIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$DeleteAuthenticatorsResultToJson(
        DeleteAuthenticatorsResult instance) =>
    <String, dynamic>{
      'authenticatorIds': instance.authenticatorIds,
    };

DeleteInvitationIntent _$DeleteInvitationIntentFromJson(
        Map<String, dynamic> json) =>
    DeleteInvitationIntent(
      invitationId: json['invitationId'] as String,
    );

Map<String, dynamic> _$DeleteInvitationIntentToJson(
        DeleteInvitationIntent instance) =>
    <String, dynamic>{
      'invitationId': instance.invitationId,
    };

DeleteInvitationRequest _$DeleteInvitationRequestFromJson(
        Map<String, dynamic> json) =>
    DeleteInvitationRequest(
      type: deleteInvitationRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: DeleteInvitationIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeleteInvitationRequestToJson(
        DeleteInvitationRequest instance) =>
    <String, dynamic>{
      'type': deleteInvitationRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

DeleteInvitationResult _$DeleteInvitationResultFromJson(
        Map<String, dynamic> json) =>
    DeleteInvitationResult(
      invitationId: json['invitationId'] as String,
    );

Map<String, dynamic> _$DeleteInvitationResultToJson(
        DeleteInvitationResult instance) =>
    <String, dynamic>{
      'invitationId': instance.invitationId,
    };

DeleteOauthProvidersIntent _$DeleteOauthProvidersIntentFromJson(
        Map<String, dynamic> json) =>
    DeleteOauthProvidersIntent(
      userId: json['userId'] as String,
      providerIds: (json['providerIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$DeleteOauthProvidersIntentToJson(
        DeleteOauthProvidersIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'providerIds': instance.providerIds,
    };

DeleteOauthProvidersRequest _$DeleteOauthProvidersRequestFromJson(
        Map<String, dynamic> json) =>
    DeleteOauthProvidersRequest(
      type: deleteOauthProvidersRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: DeleteOauthProvidersIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeleteOauthProvidersRequestToJson(
        DeleteOauthProvidersRequest instance) =>
    <String, dynamic>{
      'type': deleteOauthProvidersRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

DeleteOauthProvidersResult _$DeleteOauthProvidersResultFromJson(
        Map<String, dynamic> json) =>
    DeleteOauthProvidersResult(
      providerIds: (json['providerIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$DeleteOauthProvidersResultToJson(
        DeleteOauthProvidersResult instance) =>
    <String, dynamic>{
      'providerIds': instance.providerIds,
    };

DeleteOrganizationIntent _$DeleteOrganizationIntentFromJson(
        Map<String, dynamic> json) =>
    DeleteOrganizationIntent(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$DeleteOrganizationIntentToJson(
        DeleteOrganizationIntent instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

DeleteOrganizationResult _$DeleteOrganizationResultFromJson(
        Map<String, dynamic> json) =>
    DeleteOrganizationResult(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$DeleteOrganizationResultToJson(
        DeleteOrganizationResult instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

DeletePaymentMethodIntent _$DeletePaymentMethodIntentFromJson(
        Map<String, dynamic> json) =>
    DeletePaymentMethodIntent(
      paymentMethodId: json['paymentMethodId'] as String,
    );

Map<String, dynamic> _$DeletePaymentMethodIntentToJson(
        DeletePaymentMethodIntent instance) =>
    <String, dynamic>{
      'paymentMethodId': instance.paymentMethodId,
    };

DeletePaymentMethodResult _$DeletePaymentMethodResultFromJson(
        Map<String, dynamic> json) =>
    DeletePaymentMethodResult(
      paymentMethodId: json['paymentMethodId'] as String,
    );

Map<String, dynamic> _$DeletePaymentMethodResultToJson(
        DeletePaymentMethodResult instance) =>
    <String, dynamic>{
      'paymentMethodId': instance.paymentMethodId,
    };

DeletePolicyIntent _$DeletePolicyIntentFromJson(Map<String, dynamic> json) =>
    DeletePolicyIntent(
      policyId: json['policyId'] as String,
    );

Map<String, dynamic> _$DeletePolicyIntentToJson(DeletePolicyIntent instance) =>
    <String, dynamic>{
      'policyId': instance.policyId,
    };

DeletePolicyRequest _$DeletePolicyRequestFromJson(Map<String, dynamic> json) =>
    DeletePolicyRequest(
      type: deletePolicyRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: DeletePolicyIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeletePolicyRequestToJson(
        DeletePolicyRequest instance) =>
    <String, dynamic>{
      'type': deletePolicyRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

DeletePolicyResult _$DeletePolicyResultFromJson(Map<String, dynamic> json) =>
    DeletePolicyResult(
      policyId: json['policyId'] as String,
    );

Map<String, dynamic> _$DeletePolicyResultToJson(DeletePolicyResult instance) =>
    <String, dynamic>{
      'policyId': instance.policyId,
    };

DeletePrivateKeyTagsIntent _$DeletePrivateKeyTagsIntentFromJson(
        Map<String, dynamic> json) =>
    DeletePrivateKeyTagsIntent(
      privateKeyTagIds: (json['privateKeyTagIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$DeletePrivateKeyTagsIntentToJson(
        DeletePrivateKeyTagsIntent instance) =>
    <String, dynamic>{
      'privateKeyTagIds': instance.privateKeyTagIds,
    };

DeletePrivateKeyTagsRequest _$DeletePrivateKeyTagsRequestFromJson(
        Map<String, dynamic> json) =>
    DeletePrivateKeyTagsRequest(
      type: deletePrivateKeyTagsRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: DeletePrivateKeyTagsIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeletePrivateKeyTagsRequestToJson(
        DeletePrivateKeyTagsRequest instance) =>
    <String, dynamic>{
      'type': deletePrivateKeyTagsRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

DeletePrivateKeyTagsResult _$DeletePrivateKeyTagsResultFromJson(
        Map<String, dynamic> json) =>
    DeletePrivateKeyTagsResult(
      privateKeyTagIds: (json['privateKeyTagIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      privateKeyIds: (json['privateKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$DeletePrivateKeyTagsResultToJson(
        DeletePrivateKeyTagsResult instance) =>
    <String, dynamic>{
      'privateKeyTagIds': instance.privateKeyTagIds,
      'privateKeyIds': instance.privateKeyIds,
    };

DeletePrivateKeysIntent _$DeletePrivateKeysIntentFromJson(
        Map<String, dynamic> json) =>
    DeletePrivateKeysIntent(
      privateKeyIds: (json['privateKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      deleteWithoutExport: json['deleteWithoutExport'] as bool?,
    );

Map<String, dynamic> _$DeletePrivateKeysIntentToJson(
        DeletePrivateKeysIntent instance) =>
    <String, dynamic>{
      'privateKeyIds': instance.privateKeyIds,
      'deleteWithoutExport': instance.deleteWithoutExport,
    };

DeletePrivateKeysRequest _$DeletePrivateKeysRequestFromJson(
        Map<String, dynamic> json) =>
    DeletePrivateKeysRequest(
      type: deletePrivateKeysRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: DeletePrivateKeysIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeletePrivateKeysRequestToJson(
        DeletePrivateKeysRequest instance) =>
    <String, dynamic>{
      'type': deletePrivateKeysRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

DeletePrivateKeysResult _$DeletePrivateKeysResultFromJson(
        Map<String, dynamic> json) =>
    DeletePrivateKeysResult(
      privateKeyIds: (json['privateKeyIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$DeletePrivateKeysResultToJson(
        DeletePrivateKeysResult instance) =>
    <String, dynamic>{
      'privateKeyIds': instance.privateKeyIds,
    };

DeleteSubOrganizationIntent _$DeleteSubOrganizationIntentFromJson(
        Map<String, dynamic> json) =>
    DeleteSubOrganizationIntent(
      deleteWithoutExport: json['deleteWithoutExport'] as bool?,
    );

Map<String, dynamic> _$DeleteSubOrganizationIntentToJson(
        DeleteSubOrganizationIntent instance) =>
    <String, dynamic>{
      'deleteWithoutExport': instance.deleteWithoutExport,
    };

DeleteSubOrganizationRequest _$DeleteSubOrganizationRequestFromJson(
        Map<String, dynamic> json) =>
    DeleteSubOrganizationRequest(
      type: deleteSubOrganizationRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: DeleteSubOrganizationIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeleteSubOrganizationRequestToJson(
        DeleteSubOrganizationRequest instance) =>
    <String, dynamic>{
      'type': deleteSubOrganizationRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

DeleteSubOrganizationResult _$DeleteSubOrganizationResultFromJson(
        Map<String, dynamic> json) =>
    DeleteSubOrganizationResult(
      subOrganizationUuid: json['subOrganizationUuid'] as String,
    );

Map<String, dynamic> _$DeleteSubOrganizationResultToJson(
        DeleteSubOrganizationResult instance) =>
    <String, dynamic>{
      'subOrganizationUuid': instance.subOrganizationUuid,
    };

DeleteUserTagsIntent _$DeleteUserTagsIntentFromJson(
        Map<String, dynamic> json) =>
    DeleteUserTagsIntent(
      userTagIds: (json['userTagIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$DeleteUserTagsIntentToJson(
        DeleteUserTagsIntent instance) =>
    <String, dynamic>{
      'userTagIds': instance.userTagIds,
    };

DeleteUserTagsRequest _$DeleteUserTagsRequestFromJson(
        Map<String, dynamic> json) =>
    DeleteUserTagsRequest(
      type: deleteUserTagsRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: DeleteUserTagsIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeleteUserTagsRequestToJson(
        DeleteUserTagsRequest instance) =>
    <String, dynamic>{
      'type': deleteUserTagsRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

DeleteUserTagsResult _$DeleteUserTagsResultFromJson(
        Map<String, dynamic> json) =>
    DeleteUserTagsResult(
      userTagIds: (json['userTagIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$DeleteUserTagsResultToJson(
        DeleteUserTagsResult instance) =>
    <String, dynamic>{
      'userTagIds': instance.userTagIds,
      'userIds': instance.userIds,
    };

DeleteUsersIntent _$DeleteUsersIntentFromJson(Map<String, dynamic> json) =>
    DeleteUsersIntent(
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$DeleteUsersIntentToJson(DeleteUsersIntent instance) =>
    <String, dynamic>{
      'userIds': instance.userIds,
    };

DeleteUsersRequest _$DeleteUsersRequestFromJson(Map<String, dynamic> json) =>
    DeleteUsersRequest(
      type: deleteUsersRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: DeleteUsersIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeleteUsersRequestToJson(DeleteUsersRequest instance) =>
    <String, dynamic>{
      'type': deleteUsersRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

DeleteUsersResult _$DeleteUsersResultFromJson(Map<String, dynamic> json) =>
    DeleteUsersResult(
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$DeleteUsersResultToJson(DeleteUsersResult instance) =>
    <String, dynamic>{
      'userIds': instance.userIds,
    };

DeleteWalletsIntent _$DeleteWalletsIntentFromJson(Map<String, dynamic> json) =>
    DeleteWalletsIntent(
      walletIds: (json['walletIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      deleteWithoutExport: json['deleteWithoutExport'] as bool?,
    );

Map<String, dynamic> _$DeleteWalletsIntentToJson(
        DeleteWalletsIntent instance) =>
    <String, dynamic>{
      'walletIds': instance.walletIds,
      'deleteWithoutExport': instance.deleteWithoutExport,
    };

DeleteWalletsRequest _$DeleteWalletsRequestFromJson(
        Map<String, dynamic> json) =>
    DeleteWalletsRequest(
      type: deleteWalletsRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: DeleteWalletsIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeleteWalletsRequestToJson(
        DeleteWalletsRequest instance) =>
    <String, dynamic>{
      'type': deleteWalletsRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

DeleteWalletsResult _$DeleteWalletsResultFromJson(Map<String, dynamic> json) =>
    DeleteWalletsResult(
      walletIds: (json['walletIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$DeleteWalletsResultToJson(
        DeleteWalletsResult instance) =>
    <String, dynamic>{
      'walletIds': instance.walletIds,
    };

DisablePrivateKeyIntent _$DisablePrivateKeyIntentFromJson(
        Map<String, dynamic> json) =>
    DisablePrivateKeyIntent(
      privateKeyId: json['privateKeyId'] as String,
    );

Map<String, dynamic> _$DisablePrivateKeyIntentToJson(
        DisablePrivateKeyIntent instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
    };

DisablePrivateKeyResult _$DisablePrivateKeyResultFromJson(
        Map<String, dynamic> json) =>
    DisablePrivateKeyResult(
      privateKeyId: json['privateKeyId'] as String,
    );

Map<String, dynamic> _$DisablePrivateKeyResultToJson(
        DisablePrivateKeyResult instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
    };

EmailAuthIntent _$EmailAuthIntentFromJson(Map<String, dynamic> json) =>
    EmailAuthIntent(
      email: json['email'] as String,
      targetPublicKey: json['targetPublicKey'] as String,
      apiKeyName: json['apiKeyName'] as String?,
      expirationSeconds: json['expirationSeconds'] as String?,
      emailCustomization: json['emailCustomization'] == null
          ? null
          : EmailCustomizationParams.fromJson(
              json['emailCustomization'] as Map<String, dynamic>),
      invalidateExisting: json['invalidateExisting'] as bool?,
      sendFromEmailAddress: json['sendFromEmailAddress'] as String?,
    );

Map<String, dynamic> _$EmailAuthIntentToJson(EmailAuthIntent instance) =>
    <String, dynamic>{
      'email': instance.email,
      'targetPublicKey': instance.targetPublicKey,
      'apiKeyName': instance.apiKeyName,
      'expirationSeconds': instance.expirationSeconds,
      'emailCustomization': instance.emailCustomization?.toJson(),
      'invalidateExisting': instance.invalidateExisting,
      'sendFromEmailAddress': instance.sendFromEmailAddress,
    };

EmailAuthIntentV2 _$EmailAuthIntentV2FromJson(Map<String, dynamic> json) =>
    EmailAuthIntentV2(
      email: json['email'] as String,
      targetPublicKey: json['targetPublicKey'] as String,
      apiKeyName: json['apiKeyName'] as String?,
      expirationSeconds: json['expirationSeconds'] as String?,
      emailCustomization: json['emailCustomization'] == null
          ? null
          : EmailCustomizationParams.fromJson(
              json['emailCustomization'] as Map<String, dynamic>),
      invalidateExisting: json['invalidateExisting'] as bool?,
      sendFromEmailAddress: json['sendFromEmailAddress'] as String?,
    );

Map<String, dynamic> _$EmailAuthIntentV2ToJson(EmailAuthIntentV2 instance) =>
    <String, dynamic>{
      'email': instance.email,
      'targetPublicKey': instance.targetPublicKey,
      'apiKeyName': instance.apiKeyName,
      'expirationSeconds': instance.expirationSeconds,
      'emailCustomization': instance.emailCustomization?.toJson(),
      'invalidateExisting': instance.invalidateExisting,
      'sendFromEmailAddress': instance.sendFromEmailAddress,
    };

EmailAuthRequest _$EmailAuthRequestFromJson(Map<String, dynamic> json) =>
    EmailAuthRequest(
      type: emailAuthRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: EmailAuthIntentV2.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EmailAuthRequestToJson(EmailAuthRequest instance) =>
    <String, dynamic>{
      'type': emailAuthRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

EmailAuthResult _$EmailAuthResultFromJson(Map<String, dynamic> json) =>
    EmailAuthResult(
      userId: json['userId'] as String,
      apiKeyId: json['apiKeyId'] as String,
    );

Map<String, dynamic> _$EmailAuthResultToJson(EmailAuthResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'apiKeyId': instance.apiKeyId,
    };

EmailCustomizationParams _$EmailCustomizationParamsFromJson(
        Map<String, dynamic> json) =>
    EmailCustomizationParams(
      appName: json['appName'] as String?,
      logoUrl: json['logoUrl'] as String?,
      magicLinkTemplate: json['magicLinkTemplate'] as String?,
      templateVariables: json['templateVariables'] as String?,
      templateId: json['templateId'] as String?,
    );

Map<String, dynamic> _$EmailCustomizationParamsToJson(
        EmailCustomizationParams instance) =>
    <String, dynamic>{
      'appName': instance.appName,
      'logoUrl': instance.logoUrl,
      'magicLinkTemplate': instance.magicLinkTemplate,
      'templateVariables': instance.templateVariables,
      'templateId': instance.templateId,
    };

ExportPrivateKeyIntent _$ExportPrivateKeyIntentFromJson(
        Map<String, dynamic> json) =>
    ExportPrivateKeyIntent(
      privateKeyId: json['privateKeyId'] as String,
      targetPublicKey: json['targetPublicKey'] as String,
    );

Map<String, dynamic> _$ExportPrivateKeyIntentToJson(
        ExportPrivateKeyIntent instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
      'targetPublicKey': instance.targetPublicKey,
    };

ExportPrivateKeyRequest _$ExportPrivateKeyRequestFromJson(
        Map<String, dynamic> json) =>
    ExportPrivateKeyRequest(
      type: exportPrivateKeyRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: ExportPrivateKeyIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExportPrivateKeyRequestToJson(
        ExportPrivateKeyRequest instance) =>
    <String, dynamic>{
      'type': exportPrivateKeyRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

ExportPrivateKeyResult _$ExportPrivateKeyResultFromJson(
        Map<String, dynamic> json) =>
    ExportPrivateKeyResult(
      privateKeyId: json['privateKeyId'] as String,
      exportBundle: json['exportBundle'] as String,
    );

Map<String, dynamic> _$ExportPrivateKeyResultToJson(
        ExportPrivateKeyResult instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
      'exportBundle': instance.exportBundle,
    };

ExportWalletAccountIntent _$ExportWalletAccountIntentFromJson(
        Map<String, dynamic> json) =>
    ExportWalletAccountIntent(
      address: json['address'] as String,
      targetPublicKey: json['targetPublicKey'] as String,
    );

Map<String, dynamic> _$ExportWalletAccountIntentToJson(
        ExportWalletAccountIntent instance) =>
    <String, dynamic>{
      'address': instance.address,
      'targetPublicKey': instance.targetPublicKey,
    };

ExportWalletAccountRequest _$ExportWalletAccountRequestFromJson(
        Map<String, dynamic> json) =>
    ExportWalletAccountRequest(
      type: exportWalletAccountRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: ExportWalletAccountIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExportWalletAccountRequestToJson(
        ExportWalletAccountRequest instance) =>
    <String, dynamic>{
      'type': exportWalletAccountRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

ExportWalletAccountResult _$ExportWalletAccountResultFromJson(
        Map<String, dynamic> json) =>
    ExportWalletAccountResult(
      address: json['address'] as String,
      exportBundle: json['exportBundle'] as String,
    );

Map<String, dynamic> _$ExportWalletAccountResultToJson(
        ExportWalletAccountResult instance) =>
    <String, dynamic>{
      'address': instance.address,
      'exportBundle': instance.exportBundle,
    };

ExportWalletIntent _$ExportWalletIntentFromJson(Map<String, dynamic> json) =>
    ExportWalletIntent(
      walletId: json['walletId'] as String,
      targetPublicKey: json['targetPublicKey'] as String,
      language: mnemonicLanguageNullableFromJson(json['language']),
    );

Map<String, dynamic> _$ExportWalletIntentToJson(ExportWalletIntent instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'targetPublicKey': instance.targetPublicKey,
      'language': mnemonicLanguageNullableToJson(instance.language),
    };

ExportWalletRequest _$ExportWalletRequestFromJson(Map<String, dynamic> json) =>
    ExportWalletRequest(
      type: exportWalletRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: ExportWalletIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ExportWalletRequestToJson(
        ExportWalletRequest instance) =>
    <String, dynamic>{
      'type': exportWalletRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

ExportWalletResult _$ExportWalletResultFromJson(Map<String, dynamic> json) =>
    ExportWalletResult(
      walletId: json['walletId'] as String,
      exportBundle: json['exportBundle'] as String,
    );

Map<String, dynamic> _$ExportWalletResultToJson(ExportWalletResult instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'exportBundle': instance.exportBundle,
    };

Feature _$FeatureFromJson(Map<String, dynamic> json) => Feature(
      name: featureNameNullableFromJson(json['name']),
      $value: json['value'] as String?,
    );

Map<String, dynamic> _$FeatureToJson(Feature instance) => <String, dynamic>{
      'name': featureNameNullableToJson(instance.name),
      'value': instance.$value,
    };

GetActivitiesRequest _$GetActivitiesRequestFromJson(
        Map<String, dynamic> json) =>
    GetActivitiesRequest(
      organizationId: json['organizationId'] as String,
      filterByStatus:
          activityStatusListFromJson(json['filterByStatus'] as List?),
      paginationOptions: json['paginationOptions'] == null
          ? null
          : Pagination.fromJson(
              json['paginationOptions'] as Map<String, dynamic>),
      filterByType: activityTypeListFromJson(json['filterByType'] as List?),
    );

Map<String, dynamic> _$GetActivitiesRequestToJson(
        GetActivitiesRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'filterByStatus': activityStatusListToJson(instance.filterByStatus),
      'paginationOptions': instance.paginationOptions?.toJson(),
      'filterByType': activityTypeListToJson(instance.filterByType),
    };

GetActivitiesResponse _$GetActivitiesResponseFromJson(
        Map<String, dynamic> json) =>
    GetActivitiesResponse(
      activities: (json['activities'] as List<dynamic>?)
              ?.map((e) => Activity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$GetActivitiesResponseToJson(
        GetActivitiesResponse instance) =>
    <String, dynamic>{
      'activities': instance.activities.map((e) => e.toJson()).toList(),
    };

GetActivityRequest _$GetActivityRequestFromJson(Map<String, dynamic> json) =>
    GetActivityRequest(
      organizationId: json['organizationId'] as String,
      activityId: json['activityId'] as String,
    );

Map<String, dynamic> _$GetActivityRequestToJson(GetActivityRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'activityId': instance.activityId,
    };

GetApiKeyRequest _$GetApiKeyRequestFromJson(Map<String, dynamic> json) =>
    GetApiKeyRequest(
      organizationId: json['organizationId'] as String,
      apiKeyId: json['apiKeyId'] as String,
    );

Map<String, dynamic> _$GetApiKeyRequestToJson(GetApiKeyRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'apiKeyId': instance.apiKeyId,
    };

GetApiKeyResponse _$GetApiKeyResponseFromJson(Map<String, dynamic> json) =>
    GetApiKeyResponse(
      apiKey: ApiKey.fromJson(json['apiKey'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetApiKeyResponseToJson(GetApiKeyResponse instance) =>
    <String, dynamic>{
      'apiKey': instance.apiKey.toJson(),
    };

GetApiKeysRequest _$GetApiKeysRequestFromJson(Map<String, dynamic> json) =>
    GetApiKeysRequest(
      organizationId: json['organizationId'] as String,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$GetApiKeysRequestToJson(GetApiKeysRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'userId': instance.userId,
    };

GetApiKeysResponse _$GetApiKeysResponseFromJson(Map<String, dynamic> json) =>
    GetApiKeysResponse(
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiKey.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$GetApiKeysResponseToJson(GetApiKeysResponse instance) =>
    <String, dynamic>{
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
    };

GetAuthenticatorRequest _$GetAuthenticatorRequestFromJson(
        Map<String, dynamic> json) =>
    GetAuthenticatorRequest(
      organizationId: json['organizationId'] as String,
      authenticatorId: json['authenticatorId'] as String,
    );

Map<String, dynamic> _$GetAuthenticatorRequestToJson(
        GetAuthenticatorRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'authenticatorId': instance.authenticatorId,
    };

GetAuthenticatorResponse _$GetAuthenticatorResponseFromJson(
        Map<String, dynamic> json) =>
    GetAuthenticatorResponse(
      authenticator:
          Authenticator.fromJson(json['authenticator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetAuthenticatorResponseToJson(
        GetAuthenticatorResponse instance) =>
    <String, dynamic>{
      'authenticator': instance.authenticator.toJson(),
    };

GetAuthenticatorsRequest _$GetAuthenticatorsRequestFromJson(
        Map<String, dynamic> json) =>
    GetAuthenticatorsRequest(
      organizationId: json['organizationId'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$GetAuthenticatorsRequestToJson(
        GetAuthenticatorsRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'userId': instance.userId,
    };

GetAuthenticatorsResponse _$GetAuthenticatorsResponseFromJson(
        Map<String, dynamic> json) =>
    GetAuthenticatorsResponse(
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) => Authenticator.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$GetAuthenticatorsResponseToJson(
        GetAuthenticatorsResponse instance) =>
    <String, dynamic>{
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
    };

GetOauthProvidersRequest _$GetOauthProvidersRequestFromJson(
        Map<String, dynamic> json) =>
    GetOauthProvidersRequest(
      organizationId: json['organizationId'] as String,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$GetOauthProvidersRequestToJson(
        GetOauthProvidersRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'userId': instance.userId,
    };

GetOauthProvidersResponse _$GetOauthProvidersResponseFromJson(
        Map<String, dynamic> json) =>
    GetOauthProvidersResponse(
      oauthProviders: (json['oauthProviders'] as List<dynamic>?)
              ?.map((e) => OauthProvider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$GetOauthProvidersResponseToJson(
        GetOauthProvidersResponse instance) =>
    <String, dynamic>{
      'oauthProviders': instance.oauthProviders.map((e) => e.toJson()).toList(),
    };

GetOrganizationConfigsRequest _$GetOrganizationConfigsRequestFromJson(
        Map<String, dynamic> json) =>
    GetOrganizationConfigsRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$GetOrganizationConfigsRequestToJson(
        GetOrganizationConfigsRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

GetOrganizationConfigsResponse _$GetOrganizationConfigsResponseFromJson(
        Map<String, dynamic> json) =>
    GetOrganizationConfigsResponse(
      configs: Config.fromJson(json['configs'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetOrganizationConfigsResponseToJson(
        GetOrganizationConfigsResponse instance) =>
    <String, dynamic>{
      'configs': instance.configs.toJson(),
    };

GetPoliciesRequest _$GetPoliciesRequestFromJson(Map<String, dynamic> json) =>
    GetPoliciesRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$GetPoliciesRequestToJson(GetPoliciesRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

GetPoliciesResponse _$GetPoliciesResponseFromJson(Map<String, dynamic> json) =>
    GetPoliciesResponse(
      policies: (json['policies'] as List<dynamic>?)
              ?.map((e) => Policy.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$GetPoliciesResponseToJson(
        GetPoliciesResponse instance) =>
    <String, dynamic>{
      'policies': instance.policies.map((e) => e.toJson()).toList(),
    };

GetPolicyRequest _$GetPolicyRequestFromJson(Map<String, dynamic> json) =>
    GetPolicyRequest(
      organizationId: json['organizationId'] as String,
      policyId: json['policyId'] as String,
    );

Map<String, dynamic> _$GetPolicyRequestToJson(GetPolicyRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'policyId': instance.policyId,
    };

GetPolicyResponse _$GetPolicyResponseFromJson(Map<String, dynamic> json) =>
    GetPolicyResponse(
      policy: Policy.fromJson(json['policy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetPolicyResponseToJson(GetPolicyResponse instance) =>
    <String, dynamic>{
      'policy': instance.policy.toJson(),
    };

GetPrivateKeyRequest _$GetPrivateKeyRequestFromJson(
        Map<String, dynamic> json) =>
    GetPrivateKeyRequest(
      organizationId: json['organizationId'] as String,
      privateKeyId: json['privateKeyId'] as String,
    );

Map<String, dynamic> _$GetPrivateKeyRequestToJson(
        GetPrivateKeyRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'privateKeyId': instance.privateKeyId,
    };

GetPrivateKeyResponse _$GetPrivateKeyResponseFromJson(
        Map<String, dynamic> json) =>
    GetPrivateKeyResponse(
      privateKey:
          PrivateKey.fromJson(json['privateKey'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetPrivateKeyResponseToJson(
        GetPrivateKeyResponse instance) =>
    <String, dynamic>{
      'privateKey': instance.privateKey.toJson(),
    };

GetPrivateKeysRequest _$GetPrivateKeysRequestFromJson(
        Map<String, dynamic> json) =>
    GetPrivateKeysRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$GetPrivateKeysRequestToJson(
        GetPrivateKeysRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

GetPrivateKeysResponse _$GetPrivateKeysResponseFromJson(
        Map<String, dynamic> json) =>
    GetPrivateKeysResponse(
      privateKeys: (json['privateKeys'] as List<dynamic>?)
              ?.map((e) => PrivateKey.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$GetPrivateKeysResponseToJson(
        GetPrivateKeysResponse instance) =>
    <String, dynamic>{
      'privateKeys': instance.privateKeys.map((e) => e.toJson()).toList(),
    };

GetSubOrgIdsRequest _$GetSubOrgIdsRequestFromJson(Map<String, dynamic> json) =>
    GetSubOrgIdsRequest(
      organizationId: json['organizationId'] as String,
      filterType: json['filterType'] as String?,
      filterValue: json['filterValue'] as String?,
      paginationOptions: json['paginationOptions'] == null
          ? null
          : Pagination.fromJson(
              json['paginationOptions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetSubOrgIdsRequestToJson(
        GetSubOrgIdsRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'filterType': instance.filterType,
      'filterValue': instance.filterValue,
      'paginationOptions': instance.paginationOptions?.toJson(),
    };

GetSubOrgIdsResponse _$GetSubOrgIdsResponseFromJson(
        Map<String, dynamic> json) =>
    GetSubOrgIdsResponse(
      organizationIds: (json['organizationIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$GetSubOrgIdsResponseToJson(
        GetSubOrgIdsResponse instance) =>
    <String, dynamic>{
      'organizationIds': instance.organizationIds,
    };

GetUserRequest _$GetUserRequestFromJson(Map<String, dynamic> json) =>
    GetUserRequest(
      organizationId: json['organizationId'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$GetUserRequestToJson(GetUserRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'userId': instance.userId,
    };

GetUserResponse _$GetUserResponseFromJson(Map<String, dynamic> json) =>
    GetUserResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetUserResponseToJson(GetUserResponse instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
    };

GetUsersRequest _$GetUsersRequestFromJson(Map<String, dynamic> json) =>
    GetUsersRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$GetUsersRequestToJson(GetUsersRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

GetUsersResponse _$GetUsersResponseFromJson(Map<String, dynamic> json) =>
    GetUsersResponse(
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$GetUsersResponseToJson(GetUsersResponse instance) =>
    <String, dynamic>{
      'users': instance.users.map((e) => e.toJson()).toList(),
    };

GetVerifiedSubOrgIdsRequest _$GetVerifiedSubOrgIdsRequestFromJson(
        Map<String, dynamic> json) =>
    GetVerifiedSubOrgIdsRequest(
      organizationId: json['organizationId'] as String,
      filterType: json['filterType'] as String?,
      filterValue: json['filterValue'] as String?,
      paginationOptions: json['paginationOptions'] == null
          ? null
          : Pagination.fromJson(
              json['paginationOptions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetVerifiedSubOrgIdsRequestToJson(
        GetVerifiedSubOrgIdsRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'filterType': instance.filterType,
      'filterValue': instance.filterValue,
      'paginationOptions': instance.paginationOptions?.toJson(),
    };

GetVerifiedSubOrgIdsResponse _$GetVerifiedSubOrgIdsResponseFromJson(
        Map<String, dynamic> json) =>
    GetVerifiedSubOrgIdsResponse(
      organizationIds: (json['organizationIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$GetVerifiedSubOrgIdsResponseToJson(
        GetVerifiedSubOrgIdsResponse instance) =>
    <String, dynamic>{
      'organizationIds': instance.organizationIds,
    };

GetWalletAccountRequest _$GetWalletAccountRequestFromJson(
        Map<String, dynamic> json) =>
    GetWalletAccountRequest(
      organizationId: json['organizationId'] as String,
      walletId: json['walletId'] as String,
      address: json['address'] as String?,
      path: json['path'] as String?,
    );

Map<String, dynamic> _$GetWalletAccountRequestToJson(
        GetWalletAccountRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'walletId': instance.walletId,
      'address': instance.address,
      'path': instance.path,
    };

GetWalletAccountResponse _$GetWalletAccountResponseFromJson(
        Map<String, dynamic> json) =>
    GetWalletAccountResponse(
      account: WalletAccount.fromJson(json['account'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetWalletAccountResponseToJson(
        GetWalletAccountResponse instance) =>
    <String, dynamic>{
      'account': instance.account.toJson(),
    };

GetWalletAccountsRequest _$GetWalletAccountsRequestFromJson(
        Map<String, dynamic> json) =>
    GetWalletAccountsRequest(
      organizationId: json['organizationId'] as String,
      walletId: json['walletId'] as String,
      paginationOptions: json['paginationOptions'] == null
          ? null
          : Pagination.fromJson(
              json['paginationOptions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetWalletAccountsRequestToJson(
        GetWalletAccountsRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'walletId': instance.walletId,
      'paginationOptions': instance.paginationOptions?.toJson(),
    };

GetWalletAccountsResponse _$GetWalletAccountsResponseFromJson(
        Map<String, dynamic> json) =>
    GetWalletAccountsResponse(
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) => WalletAccount.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$GetWalletAccountsResponseToJson(
        GetWalletAccountsResponse instance) =>
    <String, dynamic>{
      'accounts': instance.accounts.map((e) => e.toJson()).toList(),
    };

GetWalletRequest _$GetWalletRequestFromJson(Map<String, dynamic> json) =>
    GetWalletRequest(
      organizationId: json['organizationId'] as String,
      walletId: json['walletId'] as String,
    );

Map<String, dynamic> _$GetWalletRequestToJson(GetWalletRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'walletId': instance.walletId,
    };

GetWalletResponse _$GetWalletResponseFromJson(Map<String, dynamic> json) =>
    GetWalletResponse(
      wallet: Wallet.fromJson(json['wallet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetWalletResponseToJson(GetWalletResponse instance) =>
    <String, dynamic>{
      'wallet': instance.wallet.toJson(),
    };

GetWalletsRequest _$GetWalletsRequestFromJson(Map<String, dynamic> json) =>
    GetWalletsRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$GetWalletsRequestToJson(GetWalletsRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

GetWalletsResponse _$GetWalletsResponseFromJson(Map<String, dynamic> json) =>
    GetWalletsResponse(
      wallets: (json['wallets'] as List<dynamic>?)
              ?.map((e) => Wallet.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$GetWalletsResponseToJson(GetWalletsResponse instance) =>
    <String, dynamic>{
      'wallets': instance.wallets.map((e) => e.toJson()).toList(),
    };

GetWhoamiRequest _$GetWhoamiRequestFromJson(Map<String, dynamic> json) =>
    GetWhoamiRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$GetWhoamiRequestToJson(GetWhoamiRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

GetWhoamiResponse _$GetWhoamiResponseFromJson(Map<String, dynamic> json) =>
    GetWhoamiResponse(
      organizationId: json['organizationId'] as String,
      organizationName: json['organizationName'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$GetWhoamiResponseToJson(GetWhoamiResponse instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'organizationName': instance.organizationName,
      'userId': instance.userId,
      'username': instance.username,
    };

ImportPrivateKeyIntent _$ImportPrivateKeyIntentFromJson(
        Map<String, dynamic> json) =>
    ImportPrivateKeyIntent(
      userId: json['userId'] as String,
      privateKeyName: json['privateKeyName'] as String,
      encryptedBundle: json['encryptedBundle'] as String,
      curve: curveFromJson(json['curve']),
      addressFormats:
          addressFormatListFromJson(json['addressFormats'] as List?),
    );

Map<String, dynamic> _$ImportPrivateKeyIntentToJson(
        ImportPrivateKeyIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'privateKeyName': instance.privateKeyName,
      'encryptedBundle': instance.encryptedBundle,
      'curve': curveToJson(instance.curve),
      'addressFormats': addressFormatListToJson(instance.addressFormats),
    };

ImportPrivateKeyRequest _$ImportPrivateKeyRequestFromJson(
        Map<String, dynamic> json) =>
    ImportPrivateKeyRequest(
      type: importPrivateKeyRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: ImportPrivateKeyIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ImportPrivateKeyRequestToJson(
        ImportPrivateKeyRequest instance) =>
    <String, dynamic>{
      'type': importPrivateKeyRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

ImportPrivateKeyResult _$ImportPrivateKeyResultFromJson(
        Map<String, dynamic> json) =>
    ImportPrivateKeyResult(
      privateKeyId: json['privateKeyId'] as String,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map(
                  (e) => ActivityV1Address.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ImportPrivateKeyResultToJson(
        ImportPrivateKeyResult instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
      'addresses': instance.addresses.map((e) => e.toJson()).toList(),
    };

ImportWalletIntent _$ImportWalletIntentFromJson(Map<String, dynamic> json) =>
    ImportWalletIntent(
      userId: json['userId'] as String,
      walletName: json['walletName'] as String,
      encryptedBundle: json['encryptedBundle'] as String,
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) =>
                  WalletAccountParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ImportWalletIntentToJson(ImportWalletIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'walletName': instance.walletName,
      'encryptedBundle': instance.encryptedBundle,
      'accounts': instance.accounts.map((e) => e.toJson()).toList(),
    };

ImportWalletRequest _$ImportWalletRequestFromJson(Map<String, dynamic> json) =>
    ImportWalletRequest(
      type: importWalletRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: ImportWalletIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ImportWalletRequestToJson(
        ImportWalletRequest instance) =>
    <String, dynamic>{
      'type': importWalletRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

ImportWalletResult _$ImportWalletResultFromJson(Map<String, dynamic> json) =>
    ImportWalletResult(
      walletId: json['walletId'] as String,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$ImportWalletResultToJson(ImportWalletResult instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'addresses': instance.addresses,
    };

InitImportPrivateKeyIntent _$InitImportPrivateKeyIntentFromJson(
        Map<String, dynamic> json) =>
    InitImportPrivateKeyIntent(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$InitImportPrivateKeyIntentToJson(
        InitImportPrivateKeyIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

InitImportPrivateKeyRequest _$InitImportPrivateKeyRequestFromJson(
        Map<String, dynamic> json) =>
    InitImportPrivateKeyRequest(
      type: initImportPrivateKeyRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: InitImportPrivateKeyIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InitImportPrivateKeyRequestToJson(
        InitImportPrivateKeyRequest instance) =>
    <String, dynamic>{
      'type': initImportPrivateKeyRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

InitImportPrivateKeyResult _$InitImportPrivateKeyResultFromJson(
        Map<String, dynamic> json) =>
    InitImportPrivateKeyResult(
      importBundle: json['importBundle'] as String,
    );

Map<String, dynamic> _$InitImportPrivateKeyResultToJson(
        InitImportPrivateKeyResult instance) =>
    <String, dynamic>{
      'importBundle': instance.importBundle,
    };

InitImportWalletIntent _$InitImportWalletIntentFromJson(
        Map<String, dynamic> json) =>
    InitImportWalletIntent(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$InitImportWalletIntentToJson(
        InitImportWalletIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

InitImportWalletRequest _$InitImportWalletRequestFromJson(
        Map<String, dynamic> json) =>
    InitImportWalletRequest(
      type: initImportWalletRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: InitImportWalletIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InitImportWalletRequestToJson(
        InitImportWalletRequest instance) =>
    <String, dynamic>{
      'type': initImportWalletRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

InitImportWalletResult _$InitImportWalletResultFromJson(
        Map<String, dynamic> json) =>
    InitImportWalletResult(
      importBundle: json['importBundle'] as String,
    );

Map<String, dynamic> _$InitImportWalletResultToJson(
        InitImportWalletResult instance) =>
    <String, dynamic>{
      'importBundle': instance.importBundle,
    };

InitOtpAuthIntent _$InitOtpAuthIntentFromJson(Map<String, dynamic> json) =>
    InitOtpAuthIntent(
      otpType: json['otpType'] as String,
      contact: json['contact'] as String,
      emailCustomization: json['emailCustomization'] == null
          ? null
          : EmailCustomizationParams.fromJson(
              json['emailCustomization'] as Map<String, dynamic>),
      smsCustomization: json['smsCustomization'] == null
          ? null
          : SmsCustomizationParams.fromJson(
              json['smsCustomization'] as Map<String, dynamic>),
      userIdentifier: json['userIdentifier'] as String?,
      sendFromEmailAddress: json['sendFromEmailAddress'] as String?,
    );

Map<String, dynamic> _$InitOtpAuthIntentToJson(InitOtpAuthIntent instance) =>
    <String, dynamic>{
      'otpType': instance.otpType,
      'contact': instance.contact,
      'emailCustomization': instance.emailCustomization?.toJson(),
      'smsCustomization': instance.smsCustomization?.toJson(),
      'userIdentifier': instance.userIdentifier,
      'sendFromEmailAddress': instance.sendFromEmailAddress,
    };

InitOtpAuthRequest _$InitOtpAuthRequestFromJson(Map<String, dynamic> json) =>
    InitOtpAuthRequest(
      type: initOtpAuthRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: InitOtpAuthIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InitOtpAuthRequestToJson(InitOtpAuthRequest instance) =>
    <String, dynamic>{
      'type': initOtpAuthRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

InitOtpAuthResult _$InitOtpAuthResultFromJson(Map<String, dynamic> json) =>
    InitOtpAuthResult(
      otpId: json['otpId'] as String,
    );

Map<String, dynamic> _$InitOtpAuthResultToJson(InitOtpAuthResult instance) =>
    <String, dynamic>{
      'otpId': instance.otpId,
    };

InitUserEmailRecoveryIntent _$InitUserEmailRecoveryIntentFromJson(
        Map<String, dynamic> json) =>
    InitUserEmailRecoveryIntent(
      email: json['email'] as String,
      targetPublicKey: json['targetPublicKey'] as String,
      expirationSeconds: json['expirationSeconds'] as String?,
      emailCustomization: json['emailCustomization'] == null
          ? null
          : EmailCustomizationParams.fromJson(
              json['emailCustomization'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InitUserEmailRecoveryIntentToJson(
        InitUserEmailRecoveryIntent instance) =>
    <String, dynamic>{
      'email': instance.email,
      'targetPublicKey': instance.targetPublicKey,
      'expirationSeconds': instance.expirationSeconds,
      'emailCustomization': instance.emailCustomization?.toJson(),
    };

InitUserEmailRecoveryRequest _$InitUserEmailRecoveryRequestFromJson(
        Map<String, dynamic> json) =>
    InitUserEmailRecoveryRequest(
      type: initUserEmailRecoveryRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: InitUserEmailRecoveryIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InitUserEmailRecoveryRequestToJson(
        InitUserEmailRecoveryRequest instance) =>
    <String, dynamic>{
      'type': initUserEmailRecoveryRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

InitUserEmailRecoveryResult _$InitUserEmailRecoveryResultFromJson(
        Map<String, dynamic> json) =>
    InitUserEmailRecoveryResult(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$InitUserEmailRecoveryResultToJson(
        InitUserEmailRecoveryResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

Intent _$IntentFromJson(Map<String, dynamic> json) => Intent(
      createOrganizationIntent: json['createOrganizationIntent'] == null
          ? null
          : CreateOrganizationIntent.fromJson(
              json['createOrganizationIntent'] as Map<String, dynamic>),
      createAuthenticatorsIntent: json['createAuthenticatorsIntent'] == null
          ? null
          : CreateAuthenticatorsIntent.fromJson(
              json['createAuthenticatorsIntent'] as Map<String, dynamic>),
      createUsersIntent: json['createUsersIntent'] == null
          ? null
          : CreateUsersIntent.fromJson(
              json['createUsersIntent'] as Map<String, dynamic>),
      createPrivateKeysIntent: json['createPrivateKeysIntent'] == null
          ? null
          : CreatePrivateKeysIntent.fromJson(
              json['createPrivateKeysIntent'] as Map<String, dynamic>),
      signRawPayloadIntent: json['signRawPayloadIntent'] == null
          ? null
          : SignRawPayloadIntent.fromJson(
              json['signRawPayloadIntent'] as Map<String, dynamic>),
      createInvitationsIntent: json['createInvitationsIntent'] == null
          ? null
          : CreateInvitationsIntent.fromJson(
              json['createInvitationsIntent'] as Map<String, dynamic>),
      acceptInvitationIntent: json['acceptInvitationIntent'] == null
          ? null
          : AcceptInvitationIntent.fromJson(
              json['acceptInvitationIntent'] as Map<String, dynamic>),
      createPolicyIntent: json['createPolicyIntent'] == null
          ? null
          : CreatePolicyIntent.fromJson(
              json['createPolicyIntent'] as Map<String, dynamic>),
      disablePrivateKeyIntent: json['disablePrivateKeyIntent'] == null
          ? null
          : DisablePrivateKeyIntent.fromJson(
              json['disablePrivateKeyIntent'] as Map<String, dynamic>),
      deleteUsersIntent: json['deleteUsersIntent'] == null
          ? null
          : DeleteUsersIntent.fromJson(
              json['deleteUsersIntent'] as Map<String, dynamic>),
      deleteAuthenticatorsIntent: json['deleteAuthenticatorsIntent'] == null
          ? null
          : DeleteAuthenticatorsIntent.fromJson(
              json['deleteAuthenticatorsIntent'] as Map<String, dynamic>),
      deleteInvitationIntent: json['deleteInvitationIntent'] == null
          ? null
          : DeleteInvitationIntent.fromJson(
              json['deleteInvitationIntent'] as Map<String, dynamic>),
      deleteOrganizationIntent: json['deleteOrganizationIntent'] == null
          ? null
          : DeleteOrganizationIntent.fromJson(
              json['deleteOrganizationIntent'] as Map<String, dynamic>),
      deletePolicyIntent: json['deletePolicyIntent'] == null
          ? null
          : DeletePolicyIntent.fromJson(
              json['deletePolicyIntent'] as Map<String, dynamic>),
      createUserTagIntent: json['createUserTagIntent'] == null
          ? null
          : CreateUserTagIntent.fromJson(
              json['createUserTagIntent'] as Map<String, dynamic>),
      deleteUserTagsIntent: json['deleteUserTagsIntent'] == null
          ? null
          : DeleteUserTagsIntent.fromJson(
              json['deleteUserTagsIntent'] as Map<String, dynamic>),
      signTransactionIntent: json['signTransactionIntent'] == null
          ? null
          : SignTransactionIntent.fromJson(
              json['signTransactionIntent'] as Map<String, dynamic>),
      createApiKeysIntent: json['createApiKeysIntent'] == null
          ? null
          : CreateApiKeysIntent.fromJson(
              json['createApiKeysIntent'] as Map<String, dynamic>),
      deleteApiKeysIntent: json['deleteApiKeysIntent'] == null
          ? null
          : DeleteApiKeysIntent.fromJson(
              json['deleteApiKeysIntent'] as Map<String, dynamic>),
      approveActivityIntent: json['approveActivityIntent'] == null
          ? null
          : ApproveActivityIntent.fromJson(
              json['approveActivityIntent'] as Map<String, dynamic>),
      rejectActivityIntent: json['rejectActivityIntent'] == null
          ? null
          : RejectActivityIntent.fromJson(
              json['rejectActivityIntent'] as Map<String, dynamic>),
      createPrivateKeyTagIntent: json['createPrivateKeyTagIntent'] == null
          ? null
          : CreatePrivateKeyTagIntent.fromJson(
              json['createPrivateKeyTagIntent'] as Map<String, dynamic>),
      deletePrivateKeyTagsIntent: json['deletePrivateKeyTagsIntent'] == null
          ? null
          : DeletePrivateKeyTagsIntent.fromJson(
              json['deletePrivateKeyTagsIntent'] as Map<String, dynamic>),
      createPolicyIntentV2: json['createPolicyIntentV2'] == null
          ? null
          : CreatePolicyIntentV2.fromJson(
              json['createPolicyIntentV2'] as Map<String, dynamic>),
      setPaymentMethodIntent: json['setPaymentMethodIntent'] == null
          ? null
          : SetPaymentMethodIntent.fromJson(
              json['setPaymentMethodIntent'] as Map<String, dynamic>),
      activateBillingTierIntent: json['activateBillingTierIntent'] == null
          ? null
          : ActivateBillingTierIntent.fromJson(
              json['activateBillingTierIntent'] as Map<String, dynamic>),
      deletePaymentMethodIntent: json['deletePaymentMethodIntent'] == null
          ? null
          : DeletePaymentMethodIntent.fromJson(
              json['deletePaymentMethodIntent'] as Map<String, dynamic>),
      createPolicyIntentV3: json['createPolicyIntentV3'] == null
          ? null
          : CreatePolicyIntentV3.fromJson(
              json['createPolicyIntentV3'] as Map<String, dynamic>),
      createApiOnlyUsersIntent: json['createApiOnlyUsersIntent'] == null
          ? null
          : CreateApiOnlyUsersIntent.fromJson(
              json['createApiOnlyUsersIntent'] as Map<String, dynamic>),
      updateRootQuorumIntent: json['updateRootQuorumIntent'] == null
          ? null
          : UpdateRootQuorumIntent.fromJson(
              json['updateRootQuorumIntent'] as Map<String, dynamic>),
      updateUserTagIntent: json['updateUserTagIntent'] == null
          ? null
          : UpdateUserTagIntent.fromJson(
              json['updateUserTagIntent'] as Map<String, dynamic>),
      updatePrivateKeyTagIntent: json['updatePrivateKeyTagIntent'] == null
          ? null
          : UpdatePrivateKeyTagIntent.fromJson(
              json['updatePrivateKeyTagIntent'] as Map<String, dynamic>),
      createAuthenticatorsIntentV2: json['createAuthenticatorsIntentV2'] == null
          ? null
          : CreateAuthenticatorsIntentV2.fromJson(
              json['createAuthenticatorsIntentV2'] as Map<String, dynamic>),
      acceptInvitationIntentV2: json['acceptInvitationIntentV2'] == null
          ? null
          : AcceptInvitationIntentV2.fromJson(
              json['acceptInvitationIntentV2'] as Map<String, dynamic>),
      createOrganizationIntentV2: json['createOrganizationIntentV2'] == null
          ? null
          : CreateOrganizationIntentV2.fromJson(
              json['createOrganizationIntentV2'] as Map<String, dynamic>),
      createUsersIntentV2: json['createUsersIntentV2'] == null
          ? null
          : CreateUsersIntentV2.fromJson(
              json['createUsersIntentV2'] as Map<String, dynamic>),
      createSubOrganizationIntent: json['createSubOrganizationIntent'] == null
          ? null
          : CreateSubOrganizationIntent.fromJson(
              json['createSubOrganizationIntent'] as Map<String, dynamic>),
      createSubOrganizationIntentV2: json['createSubOrganizationIntentV2'] ==
              null
          ? null
          : CreateSubOrganizationIntentV2.fromJson(
              json['createSubOrganizationIntentV2'] as Map<String, dynamic>),
      updateAllowedOriginsIntent: json['updateAllowedOriginsIntent'] == null
          ? null
          : UpdateAllowedOriginsIntent.fromJson(
              json['updateAllowedOriginsIntent'] as Map<String, dynamic>),
      createPrivateKeysIntentV2: json['createPrivateKeysIntentV2'] == null
          ? null
          : CreatePrivateKeysIntentV2.fromJson(
              json['createPrivateKeysIntentV2'] as Map<String, dynamic>),
      updateUserIntent: json['updateUserIntent'] == null
          ? null
          : UpdateUserIntent.fromJson(
              json['updateUserIntent'] as Map<String, dynamic>),
      updatePolicyIntent: json['updatePolicyIntent'] == null
          ? null
          : UpdatePolicyIntent.fromJson(
              json['updatePolicyIntent'] as Map<String, dynamic>),
      setPaymentMethodIntentV2: json['setPaymentMethodIntentV2'] == null
          ? null
          : SetPaymentMethodIntentV2.fromJson(
              json['setPaymentMethodIntentV2'] as Map<String, dynamic>),
      createSubOrganizationIntentV3: json['createSubOrganizationIntentV3'] ==
              null
          ? null
          : CreateSubOrganizationIntentV3.fromJson(
              json['createSubOrganizationIntentV3'] as Map<String, dynamic>),
      createWalletIntent: json['createWalletIntent'] == null
          ? null
          : CreateWalletIntent.fromJson(
              json['createWalletIntent'] as Map<String, dynamic>),
      createWalletAccountsIntent: json['createWalletAccountsIntent'] == null
          ? null
          : CreateWalletAccountsIntent.fromJson(
              json['createWalletAccountsIntent'] as Map<String, dynamic>),
      initUserEmailRecoveryIntent: json['initUserEmailRecoveryIntent'] == null
          ? null
          : InitUserEmailRecoveryIntent.fromJson(
              json['initUserEmailRecoveryIntent'] as Map<String, dynamic>),
      recoverUserIntent: json['recoverUserIntent'] == null
          ? null
          : RecoverUserIntent.fromJson(
              json['recoverUserIntent'] as Map<String, dynamic>),
      setOrganizationFeatureIntent: json['setOrganizationFeatureIntent'] == null
          ? null
          : SetOrganizationFeatureIntent.fromJson(
              json['setOrganizationFeatureIntent'] as Map<String, dynamic>),
      removeOrganizationFeatureIntent:
          json['removeOrganizationFeatureIntent'] == null
              ? null
              : RemoveOrganizationFeatureIntent.fromJson(
                  json['removeOrganizationFeatureIntent']
                      as Map<String, dynamic>),
      signRawPayloadIntentV2: json['signRawPayloadIntentV2'] == null
          ? null
          : SignRawPayloadIntentV2.fromJson(
              json['signRawPayloadIntentV2'] as Map<String, dynamic>),
      signTransactionIntentV2: json['signTransactionIntentV2'] == null
          ? null
          : SignTransactionIntentV2.fromJson(
              json['signTransactionIntentV2'] as Map<String, dynamic>),
      exportPrivateKeyIntent: json['exportPrivateKeyIntent'] == null
          ? null
          : ExportPrivateKeyIntent.fromJson(
              json['exportPrivateKeyIntent'] as Map<String, dynamic>),
      exportWalletIntent: json['exportWalletIntent'] == null
          ? null
          : ExportWalletIntent.fromJson(
              json['exportWalletIntent'] as Map<String, dynamic>),
      createSubOrganizationIntentV4: json['createSubOrganizationIntentV4'] ==
              null
          ? null
          : CreateSubOrganizationIntentV4.fromJson(
              json['createSubOrganizationIntentV4'] as Map<String, dynamic>),
      emailAuthIntent: json['emailAuthIntent'] == null
          ? null
          : EmailAuthIntent.fromJson(
              json['emailAuthIntent'] as Map<String, dynamic>),
      exportWalletAccountIntent: json['exportWalletAccountIntent'] == null
          ? null
          : ExportWalletAccountIntent.fromJson(
              json['exportWalletAccountIntent'] as Map<String, dynamic>),
      initImportWalletIntent: json['initImportWalletIntent'] == null
          ? null
          : InitImportWalletIntent.fromJson(
              json['initImportWalletIntent'] as Map<String, dynamic>),
      importWalletIntent: json['importWalletIntent'] == null
          ? null
          : ImportWalletIntent.fromJson(
              json['importWalletIntent'] as Map<String, dynamic>),
      initImportPrivateKeyIntent: json['initImportPrivateKeyIntent'] == null
          ? null
          : InitImportPrivateKeyIntent.fromJson(
              json['initImportPrivateKeyIntent'] as Map<String, dynamic>),
      importPrivateKeyIntent: json['importPrivateKeyIntent'] == null
          ? null
          : ImportPrivateKeyIntent.fromJson(
              json['importPrivateKeyIntent'] as Map<String, dynamic>),
      createPoliciesIntent: json['createPoliciesIntent'] == null
          ? null
          : CreatePoliciesIntent.fromJson(
              json['createPoliciesIntent'] as Map<String, dynamic>),
      signRawPayloadsIntent: json['signRawPayloadsIntent'] == null
          ? null
          : SignRawPayloadsIntent.fromJson(
              json['signRawPayloadsIntent'] as Map<String, dynamic>),
      createReadOnlySessionIntent: json['createReadOnlySessionIntent'] == null
          ? null
          : CreateReadOnlySessionIntent.fromJson(
              json['createReadOnlySessionIntent'] as Map<String, dynamic>),
      createOauthProvidersIntent: json['createOauthProvidersIntent'] == null
          ? null
          : CreateOauthProvidersIntent.fromJson(
              json['createOauthProvidersIntent'] as Map<String, dynamic>),
      deleteOauthProvidersIntent: json['deleteOauthProvidersIntent'] == null
          ? null
          : DeleteOauthProvidersIntent.fromJson(
              json['deleteOauthProvidersIntent'] as Map<String, dynamic>),
      createSubOrganizationIntentV5: json['createSubOrganizationIntentV5'] ==
              null
          ? null
          : CreateSubOrganizationIntentV5.fromJson(
              json['createSubOrganizationIntentV5'] as Map<String, dynamic>),
      oauthIntent: json['oauthIntent'] == null
          ? null
          : OauthIntent.fromJson(json['oauthIntent'] as Map<String, dynamic>),
      createApiKeysIntentV2: json['createApiKeysIntentV2'] == null
          ? null
          : CreateApiKeysIntentV2.fromJson(
              json['createApiKeysIntentV2'] as Map<String, dynamic>),
      createReadWriteSessionIntent: json['createReadWriteSessionIntent'] == null
          ? null
          : CreateReadWriteSessionIntent.fromJson(
              json['createReadWriteSessionIntent'] as Map<String, dynamic>),
      emailAuthIntentV2: json['emailAuthIntentV2'] == null
          ? null
          : EmailAuthIntentV2.fromJson(
              json['emailAuthIntentV2'] as Map<String, dynamic>),
      createSubOrganizationIntentV6: json['createSubOrganizationIntentV6'] ==
              null
          ? null
          : CreateSubOrganizationIntentV6.fromJson(
              json['createSubOrganizationIntentV6'] as Map<String, dynamic>),
      deletePrivateKeysIntent: json['deletePrivateKeysIntent'] == null
          ? null
          : DeletePrivateKeysIntent.fromJson(
              json['deletePrivateKeysIntent'] as Map<String, dynamic>),
      deleteWalletsIntent: json['deleteWalletsIntent'] == null
          ? null
          : DeleteWalletsIntent.fromJson(
              json['deleteWalletsIntent'] as Map<String, dynamic>),
      createReadWriteSessionIntentV2: json['createReadWriteSessionIntentV2'] ==
              null
          ? null
          : CreateReadWriteSessionIntentV2.fromJson(
              json['createReadWriteSessionIntentV2'] as Map<String, dynamic>),
      deleteSubOrganizationIntent: json['deleteSubOrganizationIntent'] == null
          ? null
          : DeleteSubOrganizationIntent.fromJson(
              json['deleteSubOrganizationIntent'] as Map<String, dynamic>),
      initOtpAuthIntent: json['initOtpAuthIntent'] == null
          ? null
          : InitOtpAuthIntent.fromJson(
              json['initOtpAuthIntent'] as Map<String, dynamic>),
      otpAuthIntent: json['otpAuthIntent'] == null
          ? null
          : OtpAuthIntent.fromJson(
              json['otpAuthIntent'] as Map<String, dynamic>),
      createSubOrganizationIntentV7: json['createSubOrganizationIntentV7'] ==
              null
          ? null
          : CreateSubOrganizationIntentV7.fromJson(
              json['createSubOrganizationIntentV7'] as Map<String, dynamic>),
      updateWalletIntent: json['updateWalletIntent'] == null
          ? null
          : UpdateWalletIntent.fromJson(
              json['updateWalletIntent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IntentToJson(Intent instance) => <String, dynamic>{
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
      'updateWalletIntent': instance.updateWalletIntent?.toJson(),
    };

InvitationParams _$InvitationParamsFromJson(Map<String, dynamic> json) =>
    InvitationParams(
      receiverUserName: json['receiverUserName'] as String,
      receiverUserEmail: json['receiverUserEmail'] as String,
      receiverUserTags: (json['receiverUserTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      accessType: accessTypeFromJson(json['accessType']),
      senderUserId: json['senderUserId'] as String,
    );

Map<String, dynamic> _$InvitationParamsToJson(InvitationParams instance) =>
    <String, dynamic>{
      'receiverUserName': instance.receiverUserName,
      'receiverUserEmail': instance.receiverUserEmail,
      'receiverUserTags': instance.receiverUserTags,
      'accessType': accessTypeToJson(instance.accessType),
      'senderUserId': instance.senderUserId,
    };

ListPrivateKeyTagsRequest _$ListPrivateKeyTagsRequestFromJson(
        Map<String, dynamic> json) =>
    ListPrivateKeyTagsRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$ListPrivateKeyTagsRequestToJson(
        ListPrivateKeyTagsRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

ListPrivateKeyTagsResponse _$ListPrivateKeyTagsResponseFromJson(
        Map<String, dynamic> json) =>
    ListPrivateKeyTagsResponse(
      privateKeyTags: (json['privateKeyTags'] as List<dynamic>?)
              ?.map((e) => V1Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ListPrivateKeyTagsResponseToJson(
        ListPrivateKeyTagsResponse instance) =>
    <String, dynamic>{
      'privateKeyTags': instance.privateKeyTags.map((e) => e.toJson()).toList(),
    };

ListUserTagsRequest _$ListUserTagsRequestFromJson(Map<String, dynamic> json) =>
    ListUserTagsRequest(
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$ListUserTagsRequestToJson(
        ListUserTagsRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
    };

ListUserTagsResponse _$ListUserTagsResponseFromJson(
        Map<String, dynamic> json) =>
    ListUserTagsResponse(
      userTags: (json['userTags'] as List<dynamic>?)
              ?.map((e) => V1Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ListUserTagsResponseToJson(
        ListUserTagsResponse instance) =>
    <String, dynamic>{
      'userTags': instance.userTags.map((e) => e.toJson()).toList(),
    };

OauthIntent _$OauthIntentFromJson(Map<String, dynamic> json) => OauthIntent(
      oidcToken: json['oidcToken'] as String,
      targetPublicKey: json['targetPublicKey'] as String,
      apiKeyName: json['apiKeyName'] as String?,
      expirationSeconds: json['expirationSeconds'] as String?,
    );

Map<String, dynamic> _$OauthIntentToJson(OauthIntent instance) =>
    <String, dynamic>{
      'oidcToken': instance.oidcToken,
      'targetPublicKey': instance.targetPublicKey,
      'apiKeyName': instance.apiKeyName,
      'expirationSeconds': instance.expirationSeconds,
    };

OauthProvider _$OauthProviderFromJson(Map<String, dynamic> json) =>
    OauthProvider(
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      issuer: json['issuer'] as String,
      audience: json['audience'] as String,
      subject: json['subject'] as String,
      createdAt: ExternalDataV1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: ExternalDataV1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OauthProviderToJson(OauthProvider instance) =>
    <String, dynamic>{
      'providerId': instance.providerId,
      'providerName': instance.providerName,
      'issuer': instance.issuer,
      'audience': instance.audience,
      'subject': instance.subject,
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
    };

OauthProviderParams _$OauthProviderParamsFromJson(Map<String, dynamic> json) =>
    OauthProviderParams(
      providerName: json['providerName'] as String,
      oidcToken: json['oidcToken'] as String,
    );

Map<String, dynamic> _$OauthProviderParamsToJson(
        OauthProviderParams instance) =>
    <String, dynamic>{
      'providerName': instance.providerName,
      'oidcToken': instance.oidcToken,
    };

OauthRequest _$OauthRequestFromJson(Map<String, dynamic> json) => OauthRequest(
      type: oauthRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters:
          OauthIntent.fromJson(json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OauthRequestToJson(OauthRequest instance) =>
    <String, dynamic>{
      'type': oauthRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

OauthResult _$OauthResultFromJson(Map<String, dynamic> json) => OauthResult(
      userId: json['userId'] as String,
      apiKeyId: json['apiKeyId'] as String,
      credentialBundle: json['credentialBundle'] as String,
    );

Map<String, dynamic> _$OauthResultToJson(OauthResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'apiKeyId': instance.apiKeyId,
      'credentialBundle': instance.credentialBundle,
    };

OtpAuthIntent _$OtpAuthIntentFromJson(Map<String, dynamic> json) =>
    OtpAuthIntent(
      otpId: json['otpId'] as String,
      otpCode: json['otpCode'] as String,
      targetPublicKey: json['targetPublicKey'] as String?,
      apiKeyName: json['apiKeyName'] as String?,
      expirationSeconds: json['expirationSeconds'] as String?,
      invalidateExisting: json['invalidateExisting'] as bool?,
    );

Map<String, dynamic> _$OtpAuthIntentToJson(OtpAuthIntent instance) =>
    <String, dynamic>{
      'otpId': instance.otpId,
      'otpCode': instance.otpCode,
      'targetPublicKey': instance.targetPublicKey,
      'apiKeyName': instance.apiKeyName,
      'expirationSeconds': instance.expirationSeconds,
      'invalidateExisting': instance.invalidateExisting,
    };

OtpAuthRequest _$OtpAuthRequestFromJson(Map<String, dynamic> json) =>
    OtpAuthRequest(
      type: otpAuthRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters:
          OtpAuthIntent.fromJson(json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OtpAuthRequestToJson(OtpAuthRequest instance) =>
    <String, dynamic>{
      'type': otpAuthRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

OtpAuthResult _$OtpAuthResultFromJson(Map<String, dynamic> json) =>
    OtpAuthResult(
      userId: json['userId'] as String,
      apiKeyId: json['apiKeyId'] as String?,
      credentialBundle: json['credentialBundle'] as String?,
    );

Map<String, dynamic> _$OtpAuthResultToJson(OtpAuthResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'apiKeyId': instance.apiKeyId,
      'credentialBundle': instance.credentialBundle,
    };

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
      limit: json['limit'] as String?,
      before: json['before'] as String?,
      after: json['after'] as String?,
    );

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'before': instance.before,
      'after': instance.after,
    };

Policy _$PolicyFromJson(Map<String, dynamic> json) => Policy(
      policyId: json['policyId'] as String,
      policyName: json['policyName'] as String,
      effect: effectFromJson(json['effect']),
      createdAt: ExternalDataV1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: ExternalDataV1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
      notes: json['notes'] as String,
      consensus: json['consensus'] as String,
      condition: json['condition'] as String,
    );

Map<String, dynamic> _$PolicyToJson(Policy instance) => <String, dynamic>{
      'policyId': instance.policyId,
      'policyName': instance.policyName,
      'effect': effectToJson(instance.effect),
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
      'notes': instance.notes,
      'consensus': instance.consensus,
      'condition': instance.condition,
    };

PrivateKey _$PrivateKeyFromJson(Map<String, dynamic> json) => PrivateKey(
      privateKeyId: json['privateKeyId'] as String,
      publicKey: json['publicKey'] as String,
      privateKeyName: json['privateKeyName'] as String,
      curve: curveFromJson(json['curve']),
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => DataV1Address.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      privateKeyTags: (json['privateKeyTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: ExternalDataV1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: ExternalDataV1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
      exported: json['exported'] as bool,
      imported: json['imported'] as bool,
    );

Map<String, dynamic> _$PrivateKeyToJson(PrivateKey instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
      'publicKey': instance.publicKey,
      'privateKeyName': instance.privateKeyName,
      'curve': curveToJson(instance.curve),
      'addresses': instance.addresses.map((e) => e.toJson()).toList(),
      'privateKeyTags': instance.privateKeyTags,
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
      'exported': instance.exported,
      'imported': instance.imported,
    };

PrivateKeyParams _$PrivateKeyParamsFromJson(Map<String, dynamic> json) =>
    PrivateKeyParams(
      privateKeyName: json['privateKeyName'] as String,
      curve: curveFromJson(json['curve']),
      privateKeyTags: (json['privateKeyTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      addressFormats:
          addressFormatListFromJson(json['addressFormats'] as List?),
    );

Map<String, dynamic> _$PrivateKeyParamsToJson(PrivateKeyParams instance) =>
    <String, dynamic>{
      'privateKeyName': instance.privateKeyName,
      'curve': curveToJson(instance.curve),
      'privateKeyTags': instance.privateKeyTags,
      'addressFormats': addressFormatListToJson(instance.addressFormats),
    };

PrivateKeyResult _$PrivateKeyResultFromJson(Map<String, dynamic> json) =>
    PrivateKeyResult(
      privateKeyId: json['privateKeyId'] as String?,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map(
                  (e) => ActivityV1Address.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$PrivateKeyResultToJson(PrivateKeyResult instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
      'addresses': instance.addresses?.map((e) => e.toJson()).toList(),
    };

PublicKeyCredentialWithAttestation _$PublicKeyCredentialWithAttestationFromJson(
        Map<String, dynamic> json) =>
    PublicKeyCredentialWithAttestation(
      id: json['id'] as String,
      type: publicKeyCredentialWithAttestationTypeFromJson(json['type']),
      rawId: json['rawId'] as String,
      authenticatorAttachment:
          publicKeyCredentialWithAttestationAuthenticatorAttachmentNullableFromJson(
              json['authenticatorAttachment']),
      response: AuthenticatorAttestationResponse.fromJson(
          json['response'] as Map<String, dynamic>),
      clientExtensionResults: SimpleClientExtensionResults.fromJson(
          json['clientExtensionResults'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PublicKeyCredentialWithAttestationToJson(
        PublicKeyCredentialWithAttestation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': publicKeyCredentialWithAttestationTypeToJson(instance.type),
      'rawId': instance.rawId,
      'authenticatorAttachment':
          publicKeyCredentialWithAttestationAuthenticatorAttachmentNullableToJson(
              instance.authenticatorAttachment),
      'response': instance.response.toJson(),
      'clientExtensionResults': instance.clientExtensionResults.toJson(),
    };

RecoverUserIntent _$RecoverUserIntentFromJson(Map<String, dynamic> json) =>
    RecoverUserIntent(
      authenticator: AuthenticatorParamsV2.fromJson(
          json['authenticator'] as Map<String, dynamic>),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$RecoverUserIntentToJson(RecoverUserIntent instance) =>
    <String, dynamic>{
      'authenticator': instance.authenticator.toJson(),
      'userId': instance.userId,
    };

RecoverUserRequest _$RecoverUserRequestFromJson(Map<String, dynamic> json) =>
    RecoverUserRequest(
      type: recoverUserRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: RecoverUserIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecoverUserRequestToJson(RecoverUserRequest instance) =>
    <String, dynamic>{
      'type': recoverUserRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

RecoverUserResult _$RecoverUserResultFromJson(Map<String, dynamic> json) =>
    RecoverUserResult(
      authenticatorId: (json['authenticatorId'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$RecoverUserResultToJson(RecoverUserResult instance) =>
    <String, dynamic>{
      'authenticatorId': instance.authenticatorId,
    };

RejectActivityIntent _$RejectActivityIntentFromJson(
        Map<String, dynamic> json) =>
    RejectActivityIntent(
      fingerprint: json['fingerprint'] as String,
    );

Map<String, dynamic> _$RejectActivityIntentToJson(
        RejectActivityIntent instance) =>
    <String, dynamic>{
      'fingerprint': instance.fingerprint,
    };

RejectActivityRequest _$RejectActivityRequestFromJson(
        Map<String, dynamic> json) =>
    RejectActivityRequest(
      type: rejectActivityRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: RejectActivityIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RejectActivityRequestToJson(
        RejectActivityRequest instance) =>
    <String, dynamic>{
      'type': rejectActivityRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

RemoveOrganizationFeatureIntent _$RemoveOrganizationFeatureIntentFromJson(
        Map<String, dynamic> json) =>
    RemoveOrganizationFeatureIntent(
      name: featureNameFromJson(json['name']),
    );

Map<String, dynamic> _$RemoveOrganizationFeatureIntentToJson(
        RemoveOrganizationFeatureIntent instance) =>
    <String, dynamic>{
      'name': featureNameToJson(instance.name),
    };

RemoveOrganizationFeatureRequest _$RemoveOrganizationFeatureRequestFromJson(
        Map<String, dynamic> json) =>
    RemoveOrganizationFeatureRequest(
      type: removeOrganizationFeatureRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: RemoveOrganizationFeatureIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RemoveOrganizationFeatureRequestToJson(
        RemoveOrganizationFeatureRequest instance) =>
    <String, dynamic>{
      'type': removeOrganizationFeatureRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

RemoveOrganizationFeatureResult _$RemoveOrganizationFeatureResultFromJson(
        Map<String, dynamic> json) =>
    RemoveOrganizationFeatureResult(
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => Feature.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$RemoveOrganizationFeatureResultToJson(
        RemoveOrganizationFeatureResult instance) =>
    <String, dynamic>{
      'features': instance.features.map((e) => e.toJson()).toList(),
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      createOrganizationResult: json['createOrganizationResult'] == null
          ? null
          : CreateOrganizationResult.fromJson(
              json['createOrganizationResult'] as Map<String, dynamic>),
      createAuthenticatorsResult: json['createAuthenticatorsResult'] == null
          ? null
          : CreateAuthenticatorsResult.fromJson(
              json['createAuthenticatorsResult'] as Map<String, dynamic>),
      createUsersResult: json['createUsersResult'] == null
          ? null
          : CreateUsersResult.fromJson(
              json['createUsersResult'] as Map<String, dynamic>),
      createPrivateKeysResult: json['createPrivateKeysResult'] == null
          ? null
          : CreatePrivateKeysResult.fromJson(
              json['createPrivateKeysResult'] as Map<String, dynamic>),
      createInvitationsResult: json['createInvitationsResult'] == null
          ? null
          : CreateInvitationsResult.fromJson(
              json['createInvitationsResult'] as Map<String, dynamic>),
      acceptInvitationResult: json['acceptInvitationResult'] == null
          ? null
          : AcceptInvitationResult.fromJson(
              json['acceptInvitationResult'] as Map<String, dynamic>),
      signRawPayloadResult: json['signRawPayloadResult'] == null
          ? null
          : SignRawPayloadResult.fromJson(
              json['signRawPayloadResult'] as Map<String, dynamic>),
      createPolicyResult: json['createPolicyResult'] == null
          ? null
          : CreatePolicyResult.fromJson(
              json['createPolicyResult'] as Map<String, dynamic>),
      disablePrivateKeyResult: json['disablePrivateKeyResult'] == null
          ? null
          : DisablePrivateKeyResult.fromJson(
              json['disablePrivateKeyResult'] as Map<String, dynamic>),
      deleteUsersResult: json['deleteUsersResult'] == null
          ? null
          : DeleteUsersResult.fromJson(
              json['deleteUsersResult'] as Map<String, dynamic>),
      deleteAuthenticatorsResult: json['deleteAuthenticatorsResult'] == null
          ? null
          : DeleteAuthenticatorsResult.fromJson(
              json['deleteAuthenticatorsResult'] as Map<String, dynamic>),
      deleteInvitationResult: json['deleteInvitationResult'] == null
          ? null
          : DeleteInvitationResult.fromJson(
              json['deleteInvitationResult'] as Map<String, dynamic>),
      deleteOrganizationResult: json['deleteOrganizationResult'] == null
          ? null
          : DeleteOrganizationResult.fromJson(
              json['deleteOrganizationResult'] as Map<String, dynamic>),
      deletePolicyResult: json['deletePolicyResult'] == null
          ? null
          : DeletePolicyResult.fromJson(
              json['deletePolicyResult'] as Map<String, dynamic>),
      createUserTagResult: json['createUserTagResult'] == null
          ? null
          : CreateUserTagResult.fromJson(
              json['createUserTagResult'] as Map<String, dynamic>),
      deleteUserTagsResult: json['deleteUserTagsResult'] == null
          ? null
          : DeleteUserTagsResult.fromJson(
              json['deleteUserTagsResult'] as Map<String, dynamic>),
      signTransactionResult: json['signTransactionResult'] == null
          ? null
          : SignTransactionResult.fromJson(
              json['signTransactionResult'] as Map<String, dynamic>),
      deleteApiKeysResult: json['deleteApiKeysResult'] == null
          ? null
          : DeleteApiKeysResult.fromJson(
              json['deleteApiKeysResult'] as Map<String, dynamic>),
      createApiKeysResult: json['createApiKeysResult'] == null
          ? null
          : CreateApiKeysResult.fromJson(
              json['createApiKeysResult'] as Map<String, dynamic>),
      createPrivateKeyTagResult: json['createPrivateKeyTagResult'] == null
          ? null
          : CreatePrivateKeyTagResult.fromJson(
              json['createPrivateKeyTagResult'] as Map<String, dynamic>),
      deletePrivateKeyTagsResult: json['deletePrivateKeyTagsResult'] == null
          ? null
          : DeletePrivateKeyTagsResult.fromJson(
              json['deletePrivateKeyTagsResult'] as Map<String, dynamic>),
      setPaymentMethodResult: json['setPaymentMethodResult'] == null
          ? null
          : SetPaymentMethodResult.fromJson(
              json['setPaymentMethodResult'] as Map<String, dynamic>),
      activateBillingTierResult: json['activateBillingTierResult'] == null
          ? null
          : ActivateBillingTierResult.fromJson(
              json['activateBillingTierResult'] as Map<String, dynamic>),
      deletePaymentMethodResult: json['deletePaymentMethodResult'] == null
          ? null
          : DeletePaymentMethodResult.fromJson(
              json['deletePaymentMethodResult'] as Map<String, dynamic>),
      createApiOnlyUsersResult: json['createApiOnlyUsersResult'] == null
          ? null
          : CreateApiOnlyUsersResult.fromJson(
              json['createApiOnlyUsersResult'] as Map<String, dynamic>),
      updateRootQuorumResult: json['updateRootQuorumResult'] == null
          ? null
          : UpdateRootQuorumResult.fromJson(
              json['updateRootQuorumResult'] as Map<String, dynamic>),
      updateUserTagResult: json['updateUserTagResult'] == null
          ? null
          : UpdateUserTagResult.fromJson(
              json['updateUserTagResult'] as Map<String, dynamic>),
      updatePrivateKeyTagResult: json['updatePrivateKeyTagResult'] == null
          ? null
          : UpdatePrivateKeyTagResult.fromJson(
              json['updatePrivateKeyTagResult'] as Map<String, dynamic>),
      createSubOrganizationResult: json['createSubOrganizationResult'] == null
          ? null
          : CreateSubOrganizationResult.fromJson(
              json['createSubOrganizationResult'] as Map<String, dynamic>),
      updateAllowedOriginsResult: json['updateAllowedOriginsResult'] == null
          ? null
          : UpdateAllowedOriginsResult.fromJson(
              json['updateAllowedOriginsResult'] as Map<String, dynamic>),
      createPrivateKeysResultV2: json['createPrivateKeysResultV2'] == null
          ? null
          : CreatePrivateKeysResultV2.fromJson(
              json['createPrivateKeysResultV2'] as Map<String, dynamic>),
      updateUserResult: json['updateUserResult'] == null
          ? null
          : UpdateUserResult.fromJson(
              json['updateUserResult'] as Map<String, dynamic>),
      updatePolicyResult: json['updatePolicyResult'] == null
          ? null
          : UpdatePolicyResult.fromJson(
              json['updatePolicyResult'] as Map<String, dynamic>),
      createSubOrganizationResultV3: json['createSubOrganizationResultV3'] ==
              null
          ? null
          : CreateSubOrganizationResultV3.fromJson(
              json['createSubOrganizationResultV3'] as Map<String, dynamic>),
      createWalletResult: json['createWalletResult'] == null
          ? null
          : CreateWalletResult.fromJson(
              json['createWalletResult'] as Map<String, dynamic>),
      createWalletAccountsResult: json['createWalletAccountsResult'] == null
          ? null
          : CreateWalletAccountsResult.fromJson(
              json['createWalletAccountsResult'] as Map<String, dynamic>),
      initUserEmailRecoveryResult: json['initUserEmailRecoveryResult'] == null
          ? null
          : InitUserEmailRecoveryResult.fromJson(
              json['initUserEmailRecoveryResult'] as Map<String, dynamic>),
      recoverUserResult: json['recoverUserResult'] == null
          ? null
          : RecoverUserResult.fromJson(
              json['recoverUserResult'] as Map<String, dynamic>),
      setOrganizationFeatureResult: json['setOrganizationFeatureResult'] == null
          ? null
          : SetOrganizationFeatureResult.fromJson(
              json['setOrganizationFeatureResult'] as Map<String, dynamic>),
      removeOrganizationFeatureResult:
          json['removeOrganizationFeatureResult'] == null
              ? null
              : RemoveOrganizationFeatureResult.fromJson(
                  json['removeOrganizationFeatureResult']
                      as Map<String, dynamic>),
      exportPrivateKeyResult: json['exportPrivateKeyResult'] == null
          ? null
          : ExportPrivateKeyResult.fromJson(
              json['exportPrivateKeyResult'] as Map<String, dynamic>),
      exportWalletResult: json['exportWalletResult'] == null
          ? null
          : ExportWalletResult.fromJson(
              json['exportWalletResult'] as Map<String, dynamic>),
      createSubOrganizationResultV4: json['createSubOrganizationResultV4'] ==
              null
          ? null
          : CreateSubOrganizationResultV4.fromJson(
              json['createSubOrganizationResultV4'] as Map<String, dynamic>),
      emailAuthResult: json['emailAuthResult'] == null
          ? null
          : EmailAuthResult.fromJson(
              json['emailAuthResult'] as Map<String, dynamic>),
      exportWalletAccountResult: json['exportWalletAccountResult'] == null
          ? null
          : ExportWalletAccountResult.fromJson(
              json['exportWalletAccountResult'] as Map<String, dynamic>),
      initImportWalletResult: json['initImportWalletResult'] == null
          ? null
          : InitImportWalletResult.fromJson(
              json['initImportWalletResult'] as Map<String, dynamic>),
      importWalletResult: json['importWalletResult'] == null
          ? null
          : ImportWalletResult.fromJson(
              json['importWalletResult'] as Map<String, dynamic>),
      initImportPrivateKeyResult: json['initImportPrivateKeyResult'] == null
          ? null
          : InitImportPrivateKeyResult.fromJson(
              json['initImportPrivateKeyResult'] as Map<String, dynamic>),
      importPrivateKeyResult: json['importPrivateKeyResult'] == null
          ? null
          : ImportPrivateKeyResult.fromJson(
              json['importPrivateKeyResult'] as Map<String, dynamic>),
      createPoliciesResult: json['createPoliciesResult'] == null
          ? null
          : CreatePoliciesResult.fromJson(
              json['createPoliciesResult'] as Map<String, dynamic>),
      signRawPayloadsResult: json['signRawPayloadsResult'] == null
          ? null
          : SignRawPayloadsResult.fromJson(
              json['signRawPayloadsResult'] as Map<String, dynamic>),
      createReadOnlySessionResult: json['createReadOnlySessionResult'] == null
          ? null
          : CreateReadOnlySessionResult.fromJson(
              json['createReadOnlySessionResult'] as Map<String, dynamic>),
      createOauthProvidersResult: json['createOauthProvidersResult'] == null
          ? null
          : CreateOauthProvidersResult.fromJson(
              json['createOauthProvidersResult'] as Map<String, dynamic>),
      deleteOauthProvidersResult: json['deleteOauthProvidersResult'] == null
          ? null
          : DeleteOauthProvidersResult.fromJson(
              json['deleteOauthProvidersResult'] as Map<String, dynamic>),
      createSubOrganizationResultV5: json['createSubOrganizationResultV5'] ==
              null
          ? null
          : CreateSubOrganizationResultV5.fromJson(
              json['createSubOrganizationResultV5'] as Map<String, dynamic>),
      oauthResult: json['oauthResult'] == null
          ? null
          : OauthResult.fromJson(json['oauthResult'] as Map<String, dynamic>),
      createReadWriteSessionResult: json['createReadWriteSessionResult'] == null
          ? null
          : CreateReadWriteSessionResult.fromJson(
              json['createReadWriteSessionResult'] as Map<String, dynamic>),
      createSubOrganizationResultV6: json['createSubOrganizationResultV6'] ==
              null
          ? null
          : CreateSubOrganizationResultV6.fromJson(
              json['createSubOrganizationResultV6'] as Map<String, dynamic>),
      deletePrivateKeysResult: json['deletePrivateKeysResult'] == null
          ? null
          : DeletePrivateKeysResult.fromJson(
              json['deletePrivateKeysResult'] as Map<String, dynamic>),
      deleteWalletsResult: json['deleteWalletsResult'] == null
          ? null
          : DeleteWalletsResult.fromJson(
              json['deleteWalletsResult'] as Map<String, dynamic>),
      createReadWriteSessionResultV2: json['createReadWriteSessionResultV2'] ==
              null
          ? null
          : CreateReadWriteSessionResultV2.fromJson(
              json['createReadWriteSessionResultV2'] as Map<String, dynamic>),
      deleteSubOrganizationResult: json['deleteSubOrganizationResult'] == null
          ? null
          : DeleteSubOrganizationResult.fromJson(
              json['deleteSubOrganizationResult'] as Map<String, dynamic>),
      initOtpAuthResult: json['initOtpAuthResult'] == null
          ? null
          : InitOtpAuthResult.fromJson(
              json['initOtpAuthResult'] as Map<String, dynamic>),
      otpAuthResult: json['otpAuthResult'] == null
          ? null
          : OtpAuthResult.fromJson(
              json['otpAuthResult'] as Map<String, dynamic>),
      createSubOrganizationResultV7: json['createSubOrganizationResultV7'] ==
              null
          ? null
          : CreateSubOrganizationResultV7.fromJson(
              json['createSubOrganizationResultV7'] as Map<String, dynamic>),
      updateWalletResult: json['updateWalletResult'] == null
          ? null
          : UpdateWalletResult.fromJson(
              json['updateWalletResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
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
      'updateWalletResult': instance.updateWalletResult?.toJson(),
    };

RootUserParams _$RootUserParamsFromJson(Map<String, dynamic> json) =>
    RootUserParams(
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) =>
                  AuthenticatorParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$RootUserParamsToJson(RootUserParams instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
    };

RootUserParamsV2 _$RootUserParamsV2FromJson(Map<String, dynamic> json) =>
    RootUserParamsV2(
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) =>
                  AuthenticatorParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      oauthProviders: (json['oauthProviders'] as List<dynamic>?)
              ?.map((e) =>
                  OauthProviderParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$RootUserParamsV2ToJson(RootUserParamsV2 instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
      'oauthProviders': instance.oauthProviders.map((e) => e.toJson()).toList(),
    };

RootUserParamsV3 _$RootUserParamsV3FromJson(Map<String, dynamic> json) =>
    RootUserParamsV3(
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiKeyParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) =>
                  AuthenticatorParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      oauthProviders: (json['oauthProviders'] as List<dynamic>?)
              ?.map((e) =>
                  OauthProviderParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$RootUserParamsV3ToJson(RootUserParamsV3 instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
      'oauthProviders': instance.oauthProviders.map((e) => e.toJson()).toList(),
    };

RootUserParamsV4 _$RootUserParamsV4FromJson(Map<String, dynamic> json) =>
    RootUserParamsV4(
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      userPhoneNumber: json['userPhoneNumber'] as String?,
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiKeyParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) =>
                  AuthenticatorParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      oauthProviders: (json['oauthProviders'] as List<dynamic>?)
              ?.map((e) =>
                  OauthProviderParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$RootUserParamsV4ToJson(RootUserParamsV4 instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'userPhoneNumber': instance.userPhoneNumber,
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
      'oauthProviders': instance.oauthProviders.map((e) => e.toJson()).toList(),
    };

Selector _$SelectorFromJson(Map<String, dynamic> json) => Selector(
      subject: json['subject'] as String?,
      $operator: operatorNullableFromJson(json['operator']),
      target: json['target'] as String?,
    );

Map<String, dynamic> _$SelectorToJson(Selector instance) => <String, dynamic>{
      'subject': instance.subject,
      'operator': operatorNullableToJson(instance.$operator),
      'target': instance.target,
    };

SelectorV2 _$SelectorV2FromJson(Map<String, dynamic> json) => SelectorV2(
      subject: json['subject'] as String?,
      $operator: operatorNullableFromJson(json['operator']),
      targets: (json['targets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$SelectorV2ToJson(SelectorV2 instance) =>
    <String, dynamic>{
      'subject': instance.subject,
      'operator': operatorNullableToJson(instance.$operator),
      'targets': instance.targets,
    };

SetOrganizationFeatureIntent _$SetOrganizationFeatureIntentFromJson(
        Map<String, dynamic> json) =>
    SetOrganizationFeatureIntent(
      name: featureNameFromJson(json['name']),
      $value: json['value'] as String,
    );

Map<String, dynamic> _$SetOrganizationFeatureIntentToJson(
        SetOrganizationFeatureIntent instance) =>
    <String, dynamic>{
      'name': featureNameToJson(instance.name),
      'value': instance.$value,
    };

SetOrganizationFeatureRequest _$SetOrganizationFeatureRequestFromJson(
        Map<String, dynamic> json) =>
    SetOrganizationFeatureRequest(
      type: setOrganizationFeatureRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: SetOrganizationFeatureIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SetOrganizationFeatureRequestToJson(
        SetOrganizationFeatureRequest instance) =>
    <String, dynamic>{
      'type': setOrganizationFeatureRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

SetOrganizationFeatureResult _$SetOrganizationFeatureResultFromJson(
        Map<String, dynamic> json) =>
    SetOrganizationFeatureResult(
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => Feature.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$SetOrganizationFeatureResultToJson(
        SetOrganizationFeatureResult instance) =>
    <String, dynamic>{
      'features': instance.features.map((e) => e.toJson()).toList(),
    };

SetPaymentMethodIntent _$SetPaymentMethodIntentFromJson(
        Map<String, dynamic> json) =>
    SetPaymentMethodIntent(
      number: json['number'] as String,
      cvv: json['cvv'] as String,
      expiryMonth: json['expiryMonth'] as String,
      expiryYear: json['expiryYear'] as String,
      cardHolderEmail: json['cardHolderEmail'] as String,
      cardHolderName: json['cardHolderName'] as String,
    );

Map<String, dynamic> _$SetPaymentMethodIntentToJson(
        SetPaymentMethodIntent instance) =>
    <String, dynamic>{
      'number': instance.number,
      'cvv': instance.cvv,
      'expiryMonth': instance.expiryMonth,
      'expiryYear': instance.expiryYear,
      'cardHolderEmail': instance.cardHolderEmail,
      'cardHolderName': instance.cardHolderName,
    };

SetPaymentMethodIntentV2 _$SetPaymentMethodIntentV2FromJson(
        Map<String, dynamic> json) =>
    SetPaymentMethodIntentV2(
      paymentMethodId: json['paymentMethodId'] as String,
      cardHolderEmail: json['cardHolderEmail'] as String,
      cardHolderName: json['cardHolderName'] as String,
    );

Map<String, dynamic> _$SetPaymentMethodIntentV2ToJson(
        SetPaymentMethodIntentV2 instance) =>
    <String, dynamic>{
      'paymentMethodId': instance.paymentMethodId,
      'cardHolderEmail': instance.cardHolderEmail,
      'cardHolderName': instance.cardHolderName,
    };

SetPaymentMethodResult _$SetPaymentMethodResultFromJson(
        Map<String, dynamic> json) =>
    SetPaymentMethodResult(
      lastFour: json['lastFour'] as String,
      cardHolderName: json['cardHolderName'] as String,
      cardHolderEmail: json['cardHolderEmail'] as String,
    );

Map<String, dynamic> _$SetPaymentMethodResultToJson(
        SetPaymentMethodResult instance) =>
    <String, dynamic>{
      'lastFour': instance.lastFour,
      'cardHolderName': instance.cardHolderName,
      'cardHolderEmail': instance.cardHolderEmail,
    };

SignRawPayloadIntent _$SignRawPayloadIntentFromJson(
        Map<String, dynamic> json) =>
    SignRawPayloadIntent(
      privateKeyId: json['privateKeyId'] as String,
      payload: json['payload'] as String,
      encoding: payloadEncodingFromJson(json['encoding']),
      hashFunction: hashFunctionFromJson(json['hashFunction']),
    );

Map<String, dynamic> _$SignRawPayloadIntentToJson(
        SignRawPayloadIntent instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
      'payload': instance.payload,
      'encoding': payloadEncodingToJson(instance.encoding),
      'hashFunction': hashFunctionToJson(instance.hashFunction),
    };

SignRawPayloadIntentV2 _$SignRawPayloadIntentV2FromJson(
        Map<String, dynamic> json) =>
    SignRawPayloadIntentV2(
      signWith: json['signWith'] as String,
      payload: json['payload'] as String,
      encoding: payloadEncodingFromJson(json['encoding']),
      hashFunction: hashFunctionFromJson(json['hashFunction']),
    );

Map<String, dynamic> _$SignRawPayloadIntentV2ToJson(
        SignRawPayloadIntentV2 instance) =>
    <String, dynamic>{
      'signWith': instance.signWith,
      'payload': instance.payload,
      'encoding': payloadEncodingToJson(instance.encoding),
      'hashFunction': hashFunctionToJson(instance.hashFunction),
    };

SignRawPayloadRequest _$SignRawPayloadRequestFromJson(
        Map<String, dynamic> json) =>
    SignRawPayloadRequest(
      type: signRawPayloadRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: SignRawPayloadIntentV2.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignRawPayloadRequestToJson(
        SignRawPayloadRequest instance) =>
    <String, dynamic>{
      'type': signRawPayloadRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

SignRawPayloadResult _$SignRawPayloadResultFromJson(
        Map<String, dynamic> json) =>
    SignRawPayloadResult(
      r: json['r'] as String,
      s: json['s'] as String,
      v: json['v'] as String,
    );

Map<String, dynamic> _$SignRawPayloadResultToJson(
        SignRawPayloadResult instance) =>
    <String, dynamic>{
      'r': instance.r,
      's': instance.s,
      'v': instance.v,
    };

SignRawPayloadsIntent _$SignRawPayloadsIntentFromJson(
        Map<String, dynamic> json) =>
    SignRawPayloadsIntent(
      signWith: json['signWith'] as String,
      payloads: (json['payloads'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      encoding: payloadEncodingFromJson(json['encoding']),
      hashFunction: hashFunctionFromJson(json['hashFunction']),
    );

Map<String, dynamic> _$SignRawPayloadsIntentToJson(
        SignRawPayloadsIntent instance) =>
    <String, dynamic>{
      'signWith': instance.signWith,
      'payloads': instance.payloads,
      'encoding': payloadEncodingToJson(instance.encoding),
      'hashFunction': hashFunctionToJson(instance.hashFunction),
    };

SignRawPayloadsRequest _$SignRawPayloadsRequestFromJson(
        Map<String, dynamic> json) =>
    SignRawPayloadsRequest(
      type: signRawPayloadsRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: SignRawPayloadsIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignRawPayloadsRequestToJson(
        SignRawPayloadsRequest instance) =>
    <String, dynamic>{
      'type': signRawPayloadsRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

SignRawPayloadsResult _$SignRawPayloadsResultFromJson(
        Map<String, dynamic> json) =>
    SignRawPayloadsResult(
      signatures: (json['signatures'] as List<dynamic>?)
              ?.map((e) =>
                  SignRawPayloadResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$SignRawPayloadsResultToJson(
        SignRawPayloadsResult instance) =>
    <String, dynamic>{
      'signatures': instance.signatures?.map((e) => e.toJson()).toList(),
    };

SignTransactionIntent _$SignTransactionIntentFromJson(
        Map<String, dynamic> json) =>
    SignTransactionIntent(
      privateKeyId: json['privateKeyId'] as String,
      unsignedTransaction: json['unsignedTransaction'] as String,
      type: transactionTypeFromJson(json['type']),
    );

Map<String, dynamic> _$SignTransactionIntentToJson(
        SignTransactionIntent instance) =>
    <String, dynamic>{
      'privateKeyId': instance.privateKeyId,
      'unsignedTransaction': instance.unsignedTransaction,
      'type': transactionTypeToJson(instance.type),
    };

SignTransactionIntentV2 _$SignTransactionIntentV2FromJson(
        Map<String, dynamic> json) =>
    SignTransactionIntentV2(
      signWith: json['signWith'] as String,
      unsignedTransaction: json['unsignedTransaction'] as String,
      type: transactionTypeFromJson(json['type']),
    );

Map<String, dynamic> _$SignTransactionIntentV2ToJson(
        SignTransactionIntentV2 instance) =>
    <String, dynamic>{
      'signWith': instance.signWith,
      'unsignedTransaction': instance.unsignedTransaction,
      'type': transactionTypeToJson(instance.type),
    };

SignTransactionRequest _$SignTransactionRequestFromJson(
        Map<String, dynamic> json) =>
    SignTransactionRequest(
      type: signTransactionRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: SignTransactionIntentV2.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignTransactionRequestToJson(
        SignTransactionRequest instance) =>
    <String, dynamic>{
      'type': signTransactionRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

SignTransactionResult _$SignTransactionResultFromJson(
        Map<String, dynamic> json) =>
    SignTransactionResult(
      signedTransaction: json['signedTransaction'] as String,
    );

Map<String, dynamic> _$SignTransactionResultToJson(
        SignTransactionResult instance) =>
    <String, dynamic>{
      'signedTransaction': instance.signedTransaction,
    };

SimpleClientExtensionResults _$SimpleClientExtensionResultsFromJson(
        Map<String, dynamic> json) =>
    SimpleClientExtensionResults(
      appid: json['appid'] as bool?,
      appidExclude: json['appidExclude'] as bool?,
      credProps: json['credProps'] == null
          ? null
          : CredPropsAuthenticationExtensionsClientOutputs.fromJson(
              json['credProps'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SimpleClientExtensionResultsToJson(
        SimpleClientExtensionResults instance) =>
    <String, dynamic>{
      'appid': instance.appid,
      'appidExclude': instance.appidExclude,
      'credProps': instance.credProps?.toJson(),
    };

SmsCustomizationParams _$SmsCustomizationParamsFromJson(
        Map<String, dynamic> json) =>
    SmsCustomizationParams(
      template: json['template'] as String?,
    );

Map<String, dynamic> _$SmsCustomizationParamsToJson(
        SmsCustomizationParams instance) =>
    <String, dynamic>{
      'template': instance.template,
    };

Status _$StatusFromJson(Map<String, dynamic> json) => Status(
      code: (json['code'] as num?)?.toInt(),
      message: json['message'] as String?,
      details: (json['details'] as List<dynamic>?)
              ?.map((e) => Any.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'details': instance.details?.map((e) => e.toJson()).toList(),
    };

UpdateAllowedOriginsIntent _$UpdateAllowedOriginsIntentFromJson(
        Map<String, dynamic> json) =>
    UpdateAllowedOriginsIntent(
      allowedOrigins: (json['allowedOrigins'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$UpdateAllowedOriginsIntentToJson(
        UpdateAllowedOriginsIntent instance) =>
    <String, dynamic>{
      'allowedOrigins': instance.allowedOrigins,
    };

UpdateAllowedOriginsResult _$UpdateAllowedOriginsResultFromJson(
        Map<String, dynamic> json) =>
    UpdateAllowedOriginsResult();

Map<String, dynamic> _$UpdateAllowedOriginsResultToJson(
        UpdateAllowedOriginsResult instance) =>
    <String, dynamic>{};

UpdatePolicyIntent _$UpdatePolicyIntentFromJson(Map<String, dynamic> json) =>
    UpdatePolicyIntent(
      policyId: json['policyId'] as String,
      policyName: json['policyName'] as String?,
      policyEffect: effectNullableFromJson(json['policyEffect']),
      policyCondition: json['policyCondition'] as String?,
      policyConsensus: json['policyConsensus'] as String?,
      policyNotes: json['policyNotes'] as String?,
    );

Map<String, dynamic> _$UpdatePolicyIntentToJson(UpdatePolicyIntent instance) =>
    <String, dynamic>{
      'policyId': instance.policyId,
      'policyName': instance.policyName,
      'policyEffect': effectNullableToJson(instance.policyEffect),
      'policyCondition': instance.policyCondition,
      'policyConsensus': instance.policyConsensus,
      'policyNotes': instance.policyNotes,
    };

UpdatePolicyRequest _$UpdatePolicyRequestFromJson(Map<String, dynamic> json) =>
    UpdatePolicyRequest(
      type: updatePolicyRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: UpdatePolicyIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdatePolicyRequestToJson(
        UpdatePolicyRequest instance) =>
    <String, dynamic>{
      'type': updatePolicyRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

UpdatePolicyResult _$UpdatePolicyResultFromJson(Map<String, dynamic> json) =>
    UpdatePolicyResult(
      policyId: json['policyId'] as String,
    );

Map<String, dynamic> _$UpdatePolicyResultToJson(UpdatePolicyResult instance) =>
    <String, dynamic>{
      'policyId': instance.policyId,
    };

UpdatePrivateKeyTagIntent _$UpdatePrivateKeyTagIntentFromJson(
        Map<String, dynamic> json) =>
    UpdatePrivateKeyTagIntent(
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

Map<String, dynamic> _$UpdatePrivateKeyTagIntentToJson(
        UpdatePrivateKeyTagIntent instance) =>
    <String, dynamic>{
      'privateKeyTagId': instance.privateKeyTagId,
      'newPrivateKeyTagName': instance.newPrivateKeyTagName,
      'addPrivateKeyIds': instance.addPrivateKeyIds,
      'removePrivateKeyIds': instance.removePrivateKeyIds,
    };

UpdatePrivateKeyTagRequest _$UpdatePrivateKeyTagRequestFromJson(
        Map<String, dynamic> json) =>
    UpdatePrivateKeyTagRequest(
      type: updatePrivateKeyTagRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: UpdatePrivateKeyTagIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdatePrivateKeyTagRequestToJson(
        UpdatePrivateKeyTagRequest instance) =>
    <String, dynamic>{
      'type': updatePrivateKeyTagRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

UpdatePrivateKeyTagResult _$UpdatePrivateKeyTagResultFromJson(
        Map<String, dynamic> json) =>
    UpdatePrivateKeyTagResult(
      privateKeyTagId: json['privateKeyTagId'] as String,
    );

Map<String, dynamic> _$UpdatePrivateKeyTagResultToJson(
        UpdatePrivateKeyTagResult instance) =>
    <String, dynamic>{
      'privateKeyTagId': instance.privateKeyTagId,
    };

UpdateRootQuorumIntent _$UpdateRootQuorumIntentFromJson(
        Map<String, dynamic> json) =>
    UpdateRootQuorumIntent(
      threshold: (json['threshold'] as num).toInt(),
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$UpdateRootQuorumIntentToJson(
        UpdateRootQuorumIntent instance) =>
    <String, dynamic>{
      'threshold': instance.threshold,
      'userIds': instance.userIds,
    };

UpdateRootQuorumRequest _$UpdateRootQuorumRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateRootQuorumRequest(
      type: updateRootQuorumRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: UpdateRootQuorumIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateRootQuorumRequestToJson(
        UpdateRootQuorumRequest instance) =>
    <String, dynamic>{
      'type': updateRootQuorumRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

UpdateRootQuorumResult _$UpdateRootQuorumResultFromJson(
        Map<String, dynamic> json) =>
    UpdateRootQuorumResult();

Map<String, dynamic> _$UpdateRootQuorumResultToJson(
        UpdateRootQuorumResult instance) =>
    <String, dynamic>{};

UpdateUserIntent _$UpdateUserIntentFromJson(Map<String, dynamic> json) =>
    UpdateUserIntent(
      userId: json['userId'] as String,
      userName: json['userName'] as String?,
      userEmail: json['userEmail'] as String?,
      userTagIds: (json['userTagIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      userPhoneNumber: json['userPhoneNumber'] as String?,
    );

Map<String, dynamic> _$UpdateUserIntentToJson(UpdateUserIntent instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'userTagIds': instance.userTagIds,
      'userPhoneNumber': instance.userPhoneNumber,
    };

UpdateUserRequest _$UpdateUserRequestFromJson(Map<String, dynamic> json) =>
    UpdateUserRequest(
      type: updateUserRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters:
          UpdateUserIntent.fromJson(json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateUserRequestToJson(UpdateUserRequest instance) =>
    <String, dynamic>{
      'type': updateUserRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

UpdateUserResult _$UpdateUserResultFromJson(Map<String, dynamic> json) =>
    UpdateUserResult(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$UpdateUserResultToJson(UpdateUserResult instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

UpdateUserTagIntent _$UpdateUserTagIntentFromJson(Map<String, dynamic> json) =>
    UpdateUserTagIntent(
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

Map<String, dynamic> _$UpdateUserTagIntentToJson(
        UpdateUserTagIntent instance) =>
    <String, dynamic>{
      'userTagId': instance.userTagId,
      'newUserTagName': instance.newUserTagName,
      'addUserIds': instance.addUserIds,
      'removeUserIds': instance.removeUserIds,
    };

UpdateUserTagRequest _$UpdateUserTagRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateUserTagRequest(
      type: updateUserTagRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: UpdateUserTagIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateUserTagRequestToJson(
        UpdateUserTagRequest instance) =>
    <String, dynamic>{
      'type': updateUserTagRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

UpdateUserTagResult _$UpdateUserTagResultFromJson(Map<String, dynamic> json) =>
    UpdateUserTagResult(
      userTagId: json['userTagId'] as String,
    );

Map<String, dynamic> _$UpdateUserTagResultToJson(
        UpdateUserTagResult instance) =>
    <String, dynamic>{
      'userTagId': instance.userTagId,
    };

UpdateWalletIntent _$UpdateWalletIntentFromJson(Map<String, dynamic> json) =>
    UpdateWalletIntent(
      walletId: json['walletId'] as String,
      walletName: json['walletName'] as String?,
    );

Map<String, dynamic> _$UpdateWalletIntentToJson(UpdateWalletIntent instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'walletName': instance.walletName,
    };

UpdateWalletRequest _$UpdateWalletRequestFromJson(Map<String, dynamic> json) =>
    UpdateWalletRequest(
      type: updateWalletRequestTypeFromJson(json['type']),
      timestampMs: json['timestampMs'] as String,
      organizationId: json['organizationId'] as String,
      parameters: UpdateWalletIntent.fromJson(
          json['parameters'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateWalletRequestToJson(
        UpdateWalletRequest instance) =>
    <String, dynamic>{
      'type': updateWalletRequestTypeToJson(instance.type),
      'timestampMs': instance.timestampMs,
      'organizationId': instance.organizationId,
      'parameters': instance.parameters.toJson(),
    };

UpdateWalletResult _$UpdateWalletResultFromJson(Map<String, dynamic> json) =>
    UpdateWalletResult(
      walletId: json['walletId'] as String,
    );

Map<String, dynamic> _$UpdateWalletResultToJson(UpdateWalletResult instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      userPhoneNumber: json['userPhoneNumber'] as String?,
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) => Authenticator.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiKey.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userTags: (json['userTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      oauthProviders: (json['oauthProviders'] as List<dynamic>?)
              ?.map((e) => OauthProvider.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: ExternalDataV1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: ExternalDataV1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
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

UserParams _$UserParamsFromJson(Map<String, dynamic> json) => UserParams(
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      accessType: accessTypeFromJson(json['accessType']),
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) =>
                  AuthenticatorParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userTags: (json['userTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$UserParamsToJson(UserParams instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'accessType': accessTypeToJson(instance.accessType),
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
      'userTags': instance.userTags,
    };

UserParamsV2 _$UserParamsV2FromJson(Map<String, dynamic> json) => UserParamsV2(
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String?,
      apiKeys: (json['apiKeys'] as List<dynamic>?)
              ?.map((e) => ApiKeyParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      authenticators: (json['authenticators'] as List<dynamic>?)
              ?.map((e) =>
                  AuthenticatorParamsV2.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userTags: (json['userTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$UserParamsV2ToJson(UserParamsV2 instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'apiKeys': instance.apiKeys.map((e) => e.toJson()).toList(),
      'authenticators': instance.authenticators.map((e) => e.toJson()).toList(),
      'userTags': instance.userTags,
    };

Vote _$VoteFromJson(Map<String, dynamic> json) => Vote(
      id: json['id'] as String,
      userId: json['userId'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      activityId: json['activityId'] as String,
      selection: voteSelectionFromJson(json['selection']),
      message: json['message'] as String,
      publicKey: json['publicKey'] as String,
      signature: json['signature'] as String,
      scheme: json['scheme'] as String,
      createdAt: ExternalDataV1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VoteToJson(Vote instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'user': instance.user.toJson(),
      'activityId': instance.activityId,
      'selection': voteSelectionToJson(instance.selection),
      'message': instance.message,
      'publicKey': instance.publicKey,
      'signature': instance.signature,
      'scheme': instance.scheme,
      'createdAt': instance.createdAt.toJson(),
    };

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      walletId: json['walletId'] as String,
      walletName: json['walletName'] as String,
      createdAt: ExternalDataV1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: ExternalDataV1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
      exported: json['exported'] as bool,
      imported: json['imported'] as bool,
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      'walletId': instance.walletId,
      'walletName': instance.walletName,
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
      'exported': instance.exported,
      'imported': instance.imported,
    };

WalletAccount _$WalletAccountFromJson(Map<String, dynamic> json) =>
    WalletAccount(
      walletAccountId: json['walletAccountId'] as String,
      organizationId: json['organizationId'] as String,
      walletId: json['walletId'] as String,
      curve: curveFromJson(json['curve']),
      pathFormat: pathFormatFromJson(json['pathFormat']),
      path: json['path'] as String,
      addressFormat: addressFormatFromJson(json['addressFormat']),
      address: json['address'] as String,
      createdAt: ExternalDataV1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: ExternalDataV1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WalletAccountToJson(WalletAccount instance) =>
    <String, dynamic>{
      'walletAccountId': instance.walletAccountId,
      'organizationId': instance.organizationId,
      'walletId': instance.walletId,
      'curve': curveToJson(instance.curve),
      'pathFormat': pathFormatToJson(instance.pathFormat),
      'path': instance.path,
      'addressFormat': addressFormatToJson(instance.addressFormat),
      'address': instance.address,
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
    };

WalletAccountParams _$WalletAccountParamsFromJson(Map<String, dynamic> json) =>
    WalletAccountParams(
      curve: curveFromJson(json['curve']),
      pathFormat: pathFormatFromJson(json['pathFormat']),
      path: json['path'] as String,
      addressFormat: addressFormatFromJson(json['addressFormat']),
    );

Map<String, dynamic> _$WalletAccountParamsToJson(
        WalletAccountParams instance) =>
    <String, dynamic>{
      'curve': curveToJson(instance.curve),
      'pathFormat': pathFormatToJson(instance.pathFormat),
      'path': instance.path,
      'addressFormat': addressFormatToJson(instance.addressFormat),
    };

WalletParams _$WalletParamsFromJson(Map<String, dynamic> json) => WalletParams(
      walletName: json['walletName'] as String,
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) =>
                  WalletAccountParams.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      mnemonicLength: (json['mnemonicLength'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WalletParamsToJson(WalletParams instance) =>
    <String, dynamic>{
      'walletName': instance.walletName,
      'accounts': instance.accounts.map((e) => e.toJson()).toList(),
      'mnemonicLength': instance.mnemonicLength,
    };

WalletResult _$WalletResultFromJson(Map<String, dynamic> json) => WalletResult(
      walletId: json['walletId'] as String,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$WalletResultToJson(WalletResult instance) =>
    <String, dynamic>{
      'walletId': instance.walletId,
      'addresses': instance.addresses,
    };

ActivityV1Address _$ActivityV1AddressFromJson(Map<String, dynamic> json) =>
    ActivityV1Address(
      format: addressFormatNullableFromJson(json['format']),
      address: json['address'] as String?,
    );

Map<String, dynamic> _$ActivityV1AddressToJson(ActivityV1Address instance) =>
    <String, dynamic>{
      'format': addressFormatNullableToJson(instance.format),
      'address': instance.address,
    };

DataV1Address _$DataV1AddressFromJson(Map<String, dynamic> json) =>
    DataV1Address(
      format: addressFormatNullableFromJson(json['format']),
      address: json['address'] as String?,
    );

Map<String, dynamic> _$DataV1AddressToJson(DataV1Address instance) =>
    <String, dynamic>{
      'format': addressFormatNullableToJson(instance.format),
      'address': instance.address,
    };

ExternalDataV1Credential _$ExternalDataV1CredentialFromJson(
        Map<String, dynamic> json) =>
    ExternalDataV1Credential(
      publicKey: json['publicKey'] as String,
      type: credentialTypeFromJson(json['type']),
    );

Map<String, dynamic> _$ExternalDataV1CredentialToJson(
        ExternalDataV1Credential instance) =>
    <String, dynamic>{
      'publicKey': instance.publicKey,
      'type': credentialTypeToJson(instance.type),
    };

ExternalDataV1Quorum _$ExternalDataV1QuorumFromJson(
        Map<String, dynamic> json) =>
    ExternalDataV1Quorum(
      threshold: (json['threshold'] as num).toInt(),
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$ExternalDataV1QuorumToJson(
        ExternalDataV1Quorum instance) =>
    <String, dynamic>{
      'threshold': instance.threshold,
      'userIds': instance.userIds,
    };

ExternalDataV1Timestamp _$ExternalDataV1TimestampFromJson(
        Map<String, dynamic> json) =>
    ExternalDataV1Timestamp(
      seconds: json['seconds'] as String,
      nanos: json['nanos'] as String,
    );

Map<String, dynamic> _$ExternalDataV1TimestampToJson(
        ExternalDataV1Timestamp instance) =>
    <String, dynamic>{
      'seconds': instance.seconds,
      'nanos': instance.nanos,
    };

V1Tag _$V1TagFromJson(Map<String, dynamic> json) => V1Tag(
      tagId: json['tagId'] as String,
      tagName: json['tagName'] as String,
      tagType: tagTypeFromJson(json['tagType']),
      createdAt: ExternalDataV1Timestamp.fromJson(
          json['createdAt'] as Map<String, dynamic>),
      updatedAt: ExternalDataV1Timestamp.fromJson(
          json['updatedAt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V1TagToJson(V1Tag instance) => <String, dynamic>{
      'tagId': instance.tagId,
      'tagName': instance.tagName,
      'tagType': tagTypeToJson(instance.tagType),
      'createdAt': instance.createdAt.toJson(),
      'updatedAt': instance.updatedAt.toJson(),
    };
