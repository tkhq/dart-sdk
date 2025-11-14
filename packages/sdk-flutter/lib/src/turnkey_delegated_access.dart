part of 'turnkey.dart';

extension DelegatedAccessExtension on TurnkeyProvider {
    /// Fetches an existing user by P-256 API key public key, or creates a new one if none exists.
  ///
  /// This function is idempotent: multiple calls with the same `publicKey` will always return the same user.
  /// Attempts to find a user whose API keys include the given P-256 public key.
  /// If a matching user is found, it is returned as-is.
  /// If no matching user is found, a new user is created with the given public key as a P-256 API key.
  ///
  /// Throws an [Exception] if there is no active session, if input is invalid, or if
  /// retrieval/creation fails.
  ///
  /// [publicKey] The P-256 public key to use for lookup and (if needed) creation.
  /// [organizationId] Optional organization ID. Defaults to the current session’s organization ID.
  /// [createParams] Optional parameters used only when creating a new user.
  Future<v1User> fetchOrCreateP256ApiKeyUser({
    required String publicKey,
    String? organizationId,
    CreateP256UserParams? createParams,
  }) async {
    if (session == null) {
      throw Exception("No active session found. Please log in first.");
    }

    final String? orgId = organizationId ?? session?.organizationId;
    if (orgId == null || orgId.trim().isEmpty) {
      throw Exception(
        "Organization ID is required to fetch or create P-256 API key user.",
      );
    }

    if (publicKey.trim().isEmpty) {
      throw Exception("'publicKey' is required and cannot be empty.");
    }

    // Fetch existing users
    final usersResp = await requireClient.getUsers(
      input: TGetUsersBody(organizationId: orgId),
    );
    final List<v1User> users = usersResp.users;
    if (users.isEmpty) {
      throw Exception("No users found in the organization.");
    }

    // Try to find a user with the matching P-256 API key
    v1User? userWithPublicKey;
    for (final u in users) {
      final apiKeys = u.apiKeys;
      final match = apiKeys.any((k) {
        final cred = k.credential;
        return cred.publicKey == publicKey &&
            cred.type == v1CredentialType.credential_type_api_key_p256;
      });
      if (match) {
        userWithPublicKey = u;
        break;
      }
    }

    // The user already exists, so we return it
    if (userWithPublicKey != null) {
      return userWithPublicKey;
    }

    // At this point we know the user doesn't exist, so we create it
    final String newUserName =
        (createParams?.userName?.trim().isNotEmpty ?? false)
            ? createParams!.userName!.trim()
            : "Public Key User";

    final String newApiKeyName =
        (createParams?.apiKeyName?.trim().isNotEmpty ?? false)
            ? createParams!.apiKeyName!.trim()
            : "public-key-user-$publicKey";

    final createUsersResp = await requireClient.createUsers(
      input: TCreateUsersBody(
        organizationId: orgId,
        users: [
          v1UserParamsV3(
            userName: newUserName,
            userTags: const [],
            apiKeys: [
              v1ApiKeyParamsV2(
                apiKeyName: newApiKeyName,
                curveType: v1ApiKeyCurve.api_key_curve_p256,
                publicKey: publicKey,
              ),
            ],
            authenticators: const [],
            oauthProviders: const [],
          ),
        ],
      ),
    );

    final List<String> createdIds = createUsersResp.result?.userIds ?? const [];
    if (createdIds.isEmpty || createdIds.first.isEmpty) {
      throw Exception("Failed to create P-256 API key user.");
    }

    final String newUserId = createdIds.first;

    // Fetch and return the newly created user
    final created = await fetchUser(requireClient, orgId, newUserId);

    if (created == null) {
      throw Exception("The newly created user could not be fetched.");
    }

    return created;
  }

  /// Fetches each requested policy if it exists, or creates it if it does not.
  ///
  /// This function is idempotent: multiple calls with the same policies will not create duplicates.
  /// For every policy in the request:
  ///   If it already exists, it is returned with its `policyId`.
  ///   If it does not exist, it is created and returned with its new `policyId`.
  /// Throws an [Exception] if there is no active session, if input is invalid,
  /// or if fetching/creation fails.
  ///
  /// [policies] The list of policies to fetch or create.
  /// [organizationId] Optional organization ID. Defaults to the current session’s organization ID.
  ///
  /// Returns a list of [Policy] containing `policyId`, `policyName`,
  /// `effect`, and optional `condition`, `consensus`, `notes`.
  Future<List<Policy>> fetchOrCreatePolicies({
    required List<v1CreatePolicyIntentV3> policies,
    String? organizationId,
  }) async {
    if (session == null) {
      throw Exception("No active session found. Please log in first.");
    }
    if (policies.isEmpty) {
      throw Exception(
          "'policies' must be a non-empty list of policy definitions.");
    }

    final String? orgId = organizationId ?? session?.organizationId;
    if (orgId == null || orgId.trim().isEmpty) {
      throw Exception(
          "Organization ID is required to fetch or create policies.");
    }

    // We first fetch existing policies
    final existingResp = await requireClient.getPolicies(
      input: TGetPoliciesBody(organizationId: orgId),
    );
    final List<v1Policy> existingPolicies = existingResp.policies;

    // We create a map of existing policies by their signature
    // where the policySignature maps to its policyId
    final Map<String, String> existingSignatureToId = {};
    for (final ep in existingPolicies) {
      final sig = getPolicySignatureFromExisting(ep);
      if (ep.policyId.isNotEmpty) {
        existingSignatureToId[sig] = ep.policyId;
      }
    }

    // We go through each requested policy and check if it already exists
    // if it exists, we add it to the alreadyExistingPolicies list
    // if it doesn't exist, we add it to the missingPolicies list
    final List<Policy> alreadyExisting = [];
    final List<v1CreatePolicyIntentV3> missing = [];

    for (final p in policies) {
      final sig = getPolicySignature(p);
      final existingId = existingSignatureToId[sig];
      if (existingId != null) {
        alreadyExisting
            .add(Policy.fromCreateIntent(p, policyId: existingId));
      } else {
        missing.add(p);
      }
    }

    // If there are no missing policies, that means we're done
    // so we return them with their respective IDs
    if (missing.isEmpty) {
      return alreadyExisting;
    }

    // At this point we know there is at least one missing policy.
    // so we create the missing policies and then return the full list
    final createResp = await requireClient.createPolicies(
      input: TCreatePoliciesBody(
        organizationId: orgId,
        policies: missing,
      ),
    );

    // Assign returned IDs back to the missing ones in order
    final List<String> newIds = createResp.result?.policyIds ?? const [];
    if (newIds.length != missing.length) {
      throw Exception("Failed to create missing policies.");
    }

    final List<Policy> newlyCreated = [];
    for (var i = 0; i < missing.length; i++) {
      newlyCreated.add(
        Policy.fromCreateIntent(missing[i], policyId: newIds[i]),
      );
    }

    // We return the full list of policies, both existing and the newly created
    // which includes each of their respective IDs
    return [...alreadyExisting, ...newlyCreated];
  }
}