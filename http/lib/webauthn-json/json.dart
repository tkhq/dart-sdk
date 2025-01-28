typedef Base64urlString = String;

/// Intermediate type for attaching client outputs to WebAuthn API call results
/// before converting to JSON.
class CredPropsAuthenticationExtensionsClientOutputsJSON {
  final bool rk;

  CredPropsAuthenticationExtensionsClientOutputsJSON({required this.rk});
}

/// Authentication Extensions Client Outputs JSON
class AuthenticationExtensionsClientOutputsJSON {
  final bool? appidExclude;
  final CredPropsAuthenticationExtensionsClientOutputsJSON? credProps;

  AuthenticationExtensionsClientOutputsJSON({
    this.appidExclude,
    this.credProps,
  });
}

/// Public Key Credential with Optional Authenticator Attachment
class PublicKeyCredentialWithOptionalAuthenticatorAttachment {
  final String? authenticatorAttachment;

  PublicKeyCredentialWithOptionalAuthenticatorAttachment({
    this.authenticatorAttachment,
  });
}

/// Public Key Credential with Client Extension Results
class PublicKeyCredentialWithClientExtensionResults
    extends PublicKeyCredentialWithOptionalAuthenticatorAttachment {
  final AuthenticationExtensionsClientOutputsJSON? clientExtensionResults;

  PublicKeyCredentialWithClientExtensionResults({
    String? authenticatorAttachment,
    this.clientExtensionResults,
  }) : super(authenticatorAttachment: authenticatorAttachment);
}

/// Authenticator Transport JSON
enum AuthenticatorTransportJSON { usb, nfc, ble, internal, hybrid }

/// Public Key Credential Descriptor JSON
class PublicKeyCredentialDescriptorJSON {
  final String type;
  final Base64urlString id;
  final List<AuthenticatorTransportJSON>? transports;

  PublicKeyCredentialDescriptorJSON({
    required this.type,
    required this.id,
    this.transports,
  });
}

/// Simple WebAuthn Extensions JSON
class SimpleWebAuthnExtensionsJSON {
  final String? appid;
  final String? appidExclude;
  final bool? credProps;

  SimpleWebAuthnExtensionsJSON({
    this.appid,
    this.appidExclude,
    this.credProps,
  });
}

/// Simple Client Extension Results JSON
class SimpleClientExtensionResultsJSON {
  final bool? appid;
  final bool? appidExclude;
  final CredPropsAuthenticationExtensionsClientOutputsJSON? credProps;

  SimpleClientExtensionResultsJSON({
    this.appid,
    this.appidExclude,
    this.credProps,
  });
}

/// Public Key Credential JSON
class PublicKeyCredentialJSON {
  final String id;
  final String type;
  final Base64urlString rawId;
  final String? authenticatorAttachment;

  PublicKeyCredentialJSON({
    required this.id,
    required this.type,
    required this.rawId,
    this.authenticatorAttachment,
  });
}

/// Public Key Credential User Entity JSON
class PublicKeyCredentialUserEntityJSON {
  final String displayName;
  final Base64urlString id;

  PublicKeyCredentialUserEntityJSON({
    required this.displayName,
    required this.id,
  });
}

/// Resident Key Requirement
enum ResidentKeyRequirement { discouraged, preferred, required }

/// Authenticator Selection Criteria JSON
class AuthenticatorSelectionCriteriaJSON {
  final ResidentKeyRequirement? residentKey;

  AuthenticatorSelectionCriteriaJSON({this.residentKey});
}

/// Public Key Credential Creation Options JSON
class PublicKeyCredentialCreationOptionsJSON {
  final String rp;
  final PublicKeyCredentialUserEntityJSON user;
  final Base64urlString challenge;
  final List<String> pubKeyCredParams;
  final int? timeout;
  final List<PublicKeyCredentialDescriptorJSON>? excludeCredentials;
  final AuthenticatorSelectionCriteriaJSON? authenticatorSelection;
  final String? attestation;
  final SimpleWebAuthnExtensionsJSON? extensions;

  PublicKeyCredentialCreationOptionsJSON({
    required this.rp,
    required this.user,
    required this.challenge,
    required this.pubKeyCredParams,
    this.timeout,
    this.excludeCredentials,
    this.authenticatorSelection,
    this.attestation,
    this.extensions,
  });
}

/// Credential Creation Options JSON
class CredentialCreationOptionsJSON {
  final PublicKeyCredentialCreationOptionsJSON publicKey;

  CredentialCreationOptionsJSON({
    required this.publicKey,
  });
}

/// Authenticator Attestation Response JSON
class AuthenticatorAttestationResponseJSON {
  final Base64urlString clientDataJSON;
  final Base64urlString attestationObject;
  final List<AuthenticatorTransportJSON> transports;

  AuthenticatorAttestationResponseJSON({
    required this.clientDataJSON,
    required this.attestationObject,
    required this.transports,
  });
}

/// Public Key Credential with Attestation JSON
class PublicKeyCredentialWithAttestationJSON extends PublicKeyCredentialJSON {
  final AuthenticatorAttestationResponseJSON response;
  final SimpleClientExtensionResultsJSON clientExtensionResults;

  PublicKeyCredentialWithAttestationJSON({
    required String id,
    required String type,
    required Base64urlString rawId,
    required this.response,
    required this.clientExtensionResults,
    String? authenticatorAttachment,
  }) : super(
          id: id,
          type: type,
          rawId: rawId,
          authenticatorAttachment: authenticatorAttachment,
        );
}

/// Public Key Credential Request Options JSON
class PublicKeyCredentialRequestOptionsJSON {
  final Base64urlString challenge;
  final int? timeout;
  final String? rpId;
  final List<PublicKeyCredentialDescriptorJSON>? allowCredentials;
  final String? userVerification;
  final SimpleWebAuthnExtensionsJSON? extensions;

  PublicKeyCredentialRequestOptionsJSON({
    required this.challenge,
    this.timeout,
    this.rpId,
    this.allowCredentials,
    this.userVerification,
    this.extensions,
  });
}

/// Credential Request Options JSON
class CredentialRequestOptionsJSON {
  final String? mediation;
  final PublicKeyCredentialRequestOptionsJSON? publicKey;

  CredentialRequestOptionsJSON({
    this.mediation,
    this.publicKey,
  });
}

/// Authenticator Assertion Response JSON
class AuthenticatorAssertionResponseJSON {
  final Base64urlString clientDataJSON;
  final Base64urlString authenticatorData;
  final Base64urlString signature;
  final Base64urlString? userHandle;

  AuthenticatorAssertionResponseJSON({
    required this.clientDataJSON,
    required this.authenticatorData,
    required this.signature,
    this.userHandle,
  });
}

/// Public Key Credential with Assertion JSON
class PublicKeyCredentialWithAssertionJSON extends PublicKeyCredentialJSON {
  final AuthenticatorAssertionResponseJSON response;
  final SimpleClientExtensionResultsJSON clientExtensionResults;

  PublicKeyCredentialWithAssertionJSON({
    required String id,
    required String type,
    required Base64urlString rawId,
    required this.response,
    required this.clientExtensionResults,
    String? authenticatorAttachment,
  }) : super(
          id: id,
          type: type,
          rawId: rawId,
          authenticatorAttachment: authenticatorAttachment,
        );
}
