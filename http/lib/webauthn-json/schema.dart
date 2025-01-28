import 'schema-format.dart';
import 'convert.dart';

//
// Shared by `create()` and `get()`.
//

final publicKeyCredentialDescriptorSchema = SchemaObject({
  'type': requiredProp(SchemaLeaf.copy),
  'id': requiredProp(SchemaLeaf.convert),
  'transports': optionalProp(SchemaLeaf.copy),
});

final simplifiedExtensionsSchema = SchemaObject({
  'appid': optionalProp(SchemaLeaf.copy),
  'appidExclude': optionalProp(SchemaLeaf.copy),
  'credProps': optionalProp(SchemaLeaf.copy),
});

final simplifiedClientExtensionResultsSchema = SchemaObject({
  'appid': optionalProp(SchemaLeaf.copy),
  'appidExclude': optionalProp(SchemaLeaf.copy),
  'credProps': optionalProp(SchemaLeaf.copy),
});

//
// `navigator.create()` request
//
final credentialCreationOptions = SchemaObject({
  'publicKey': requiredProp(
    SchemaObject({
      'rp': requiredProp(SchemaLeaf.copy),
      'user': requiredProp(
        SchemaObject({
          'id': requiredProp(SchemaLeaf.convert),
          'name': requiredProp(SchemaLeaf.copy),
          'displayName': requiredProp(SchemaLeaf.copy),
        }),
      ),
      'challenge': requiredProp(SchemaLeaf.convert),
      'pubKeyCredParams': requiredProp(SchemaLeaf.copy),
      'timeout': optionalProp(SchemaLeaf.copy),
      'excludeCredentials': optionalProp(
        SchemaArray(publicKeyCredentialDescriptorSchema),
      ),
      'authenticatorSelection': optionalProp(SchemaLeaf.copy),
      'attestation': optionalProp(SchemaLeaf.copy),
      'extensions': optionalProp(simplifiedExtensionsSchema),
    }),
  ),
  'signal': optionalProp(SchemaLeaf.copy),
});

//
// `navigator.create()` response
//
final publicKeyCredentialWithAttestation = SchemaObject({
  'type': requiredProp(SchemaLeaf.copy),
  'id': requiredProp(SchemaLeaf.copy),
  'rawId': requiredProp(SchemaLeaf.convert),
  'authenticatorAttachment': optionalProp(SchemaLeaf.copy),
  'response': requiredProp(
    SchemaObject({
      'clientDataJSON': requiredProp(SchemaLeaf.convert),
      'attestationObject': requiredProp(SchemaLeaf.convert),
      'transports': derived(
        SchemaLeaf.copy,
        (response) {
          // In TypeScript: response.getTransports?.() ?? []
          // In Dart: we'd need your actual object type to replicate the same approach. 
          // For demonstration, we just do a safe lookup:
          final transports = response['getTransports'] ?? [];
          return transports;
        },
      ),
    }),
  ),
  'clientExtensionResults': derived(
    simplifiedClientExtensionResultsSchema,
    (pkc) {
      // In TypeScript: pkc.getClientExtensionResults()
      // In Dart: we'd do something analogous.
      // We'll pretend pkc has a 'getClientExtensionResults' method, or 
      // just store an empty map if not found
      return pkc['getClientExtensionResults'] ?? <String, dynamic>{};
    },
  ),
});

//
// `navigator.get()` request
//
final credentialRequestOptions = SchemaObject({
  'mediation': optionalProp(SchemaLeaf.copy),
  'publicKey': requiredProp(
    SchemaObject({
      'challenge': requiredProp(SchemaLeaf.convert),
      'timeout': optionalProp(SchemaLeaf.copy),
      'rpId': optionalProp(SchemaLeaf.copy),
      'allowCredentials': optionalProp(
        SchemaArray(publicKeyCredentialDescriptorSchema),
      ),
      'userVerification': optionalProp(SchemaLeaf.copy),
      'extensions': optionalProp(simplifiedExtensionsSchema),
    }),
  ),
  'signal': optionalProp(SchemaLeaf.copy),
});

//
// `navigator.get()` response
//
final publicKeyCredentialWithAssertion = SchemaObject({
  'type': requiredProp(SchemaLeaf.copy),
  'id': requiredProp(SchemaLeaf.copy),
  'rawId': requiredProp(SchemaLeaf.convert),
  'authenticatorAttachment': optionalProp(SchemaLeaf.copy),
  'response': requiredProp(
    SchemaObject({
      'clientDataJSON': requiredProp(SchemaLeaf.convert),
      'authenticatorData': requiredProp(SchemaLeaf.convert),
      'signature': requiredProp(SchemaLeaf.convert),
      'userHandle': requiredProp(SchemaLeaf.convert),
    }),
  ),
  'clientExtensionResults': derived(
    simplifiedClientExtensionResultsSchema,
    (pkc) {
      // Same as above.
      return pkc['getClientExtensionResults'] ?? <String, dynamic>{};
    },
  ),
});

/// A simple registry of schema objects, if needed
final Map<String, Schema> schema = {
  'credentialCreationOptions': credentialCreationOptions,
  'publicKeyCredentialWithAttestation': publicKeyCredentialWithAttestation,
  'credentialRequestOptions': credentialRequestOptions,
  'publicKeyCredentialWithAssertion': publicKeyCredentialWithAssertion,
};
