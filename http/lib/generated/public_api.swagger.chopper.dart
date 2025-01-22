// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_api.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$PublicApi extends PublicApi {
  _$PublicApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = PublicApi;

  @override
  Future<Response<V1ActivityResponse>> _publicV1QueryGetActivityPost(
      {required V1GetActivityRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/get_activity');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1GetApiKeyResponse>> _publicV1QueryGetApiKeyPost(
      {required V1GetApiKeyRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/get_api_key');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1GetApiKeyResponse, V1GetApiKeyResponse>($request);
  }

  @override
  Future<Response<V1GetApiKeysResponse>> _publicV1QueryGetApiKeysPost(
      {required V1GetApiKeysRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/get_api_keys');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1GetApiKeysResponse, V1GetApiKeysResponse>($request);
  }

  @override
  Future<Response<V1GetAttestationDocumentResponse>>
      _publicV1QueryGetAttestationPost(
          {required V1GetAttestationDocumentRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/get_attestation');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1GetAttestationDocumentResponse,
        V1GetAttestationDocumentResponse>($request);
  }

  @override
  Future<Response<V1GetAuthenticatorResponse>>
      _publicV1QueryGetAuthenticatorPost(
          {required V1GetAuthenticatorRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/get_authenticator');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<V1GetAuthenticatorResponse, V1GetAuthenticatorResponse>($request);
  }

  @override
  Future<Response<V1GetAuthenticatorsResponse>>
      _publicV1QueryGetAuthenticatorsPost(
          {required V1GetAuthenticatorsRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/get_authenticators');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1GetAuthenticatorsResponse,
        V1GetAuthenticatorsResponse>($request);
  }

  @override
  Future<Response<V1GetOauthProvidersResponse>>
      _publicV1QueryGetOauthProvidersPost(
          {required V1GetOauthProvidersRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/get_oauth_providers');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1GetOauthProvidersResponse,
        V1GetOauthProvidersResponse>($request);
  }

  @override
  Future<Response<V1GetOrganizationResponse>> _publicV1QueryGetOrganizationPost(
      {required V1GetOrganizationRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/get_organization');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<V1GetOrganizationResponse, V1GetOrganizationResponse>($request);
  }

  @override
  Future<Response<V1GetOrganizationConfigsResponse>>
      _publicV1QueryGetOrganizationConfigsPost(
          {required V1GetOrganizationConfigsRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/get_organization_configs');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1GetOrganizationConfigsResponse,
        V1GetOrganizationConfigsResponse>($request);
  }

  @override
  Future<Response<V1GetPolicyResponse>> _publicV1QueryGetPolicyPost(
      {required V1GetPolicyRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/get_policy');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1GetPolicyResponse, V1GetPolicyResponse>($request);
  }

  @override
  Future<Response<V1GetPrivateKeyResponse>> _publicV1QueryGetPrivateKeyPost(
      {required V1GetPrivateKeyRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/get_private_key');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<V1GetPrivateKeyResponse, V1GetPrivateKeyResponse>($request);
  }

  @override
  Future<Response<V1GetUserResponse>> _publicV1QueryGetUserPost(
      {required V1GetUserRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/get_user');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1GetUserResponse, V1GetUserResponse>($request);
  }

  @override
  Future<Response<V1GetWalletResponse>> _publicV1QueryGetWalletPost(
      {required V1GetWalletRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/get_wallet');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1GetWalletResponse, V1GetWalletResponse>($request);
  }

  @override
  Future<Response<V1GetActivitiesResponse>> _publicV1QueryListActivitiesPost(
      {required V1GetActivitiesRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/list_activities');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<V1GetActivitiesResponse, V1GetActivitiesResponse>($request);
  }

  @override
  Future<Response<V1GetPoliciesResponse>> _publicV1QueryListPoliciesPost(
      {required V1GetPoliciesRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/list_policies');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1GetPoliciesResponse, V1GetPoliciesResponse>($request);
  }

  @override
  Future<Response<V1ListPrivateKeyTagsResponse>>
      _publicV1QueryListPrivateKeyTagsPost(
          {required V1ListPrivateKeyTagsRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/list_private_key_tags');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ListPrivateKeyTagsResponse,
        V1ListPrivateKeyTagsResponse>($request);
  }

  @override
  Future<Response<V1GetPrivateKeysResponse>> _publicV1QueryListPrivateKeysPost(
      {required V1GetPrivateKeysRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/list_private_keys');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<V1GetPrivateKeysResponse, V1GetPrivateKeysResponse>($request);
  }

  @override
  Future<Response<V1GetSubOrgIdsResponse>> _publicV1QueryListSuborgsPost(
      {required V1GetSubOrgIdsRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/list_suborgs');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<V1GetSubOrgIdsResponse, V1GetSubOrgIdsResponse>($request);
  }

  @override
  Future<Response<V1ListUserTagsResponse>> _publicV1QueryListUserTagsPost(
      {required V1ListUserTagsRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/list_user_tags');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<V1ListUserTagsResponse, V1ListUserTagsResponse>($request);
  }

  @override
  Future<Response<V1GetUsersResponse>> _publicV1QueryListUsersPost(
      {required V1GetUsersRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/list_users');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1GetUsersResponse, V1GetUsersResponse>($request);
  }

  @override
  Future<Response<V1GetVerifiedSubOrgIdsResponse>>
      _publicV1QueryListVerifiedSuborgsPost(
          {required V1GetVerifiedSubOrgIdsRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/list_verified_suborgs');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1GetVerifiedSubOrgIdsResponse,
        V1GetVerifiedSubOrgIdsResponse>($request);
  }

  @override
  Future<Response<V1GetWalletAccountsResponse>>
      _publicV1QueryListWalletAccountsPost(
          {required V1GetWalletAccountsRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/list_wallet_accounts');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1GetWalletAccountsResponse,
        V1GetWalletAccountsResponse>($request);
  }

  @override
  Future<Response<V1GetWalletsResponse>> _publicV1QueryListWalletsPost(
      {required V1GetWalletsRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/list_wallets');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1GetWalletsResponse, V1GetWalletsResponse>($request);
  }

  @override
  Future<Response<V1GetWhoamiResponse>> _publicV1QueryWhoamiPost(
      {required V1GetWhoamiRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/query/whoami');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1GetWhoamiResponse, V1GetWhoamiResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitApproveActivityPost(
      {required V1ApproveActivityRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/approve_activity');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitCreateApiKeysPost(
      {required V1CreateApiKeysRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/create_api_keys');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitCreateApiOnlyUsersPost(
      {required V1CreateApiOnlyUsersRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/create_api_only_users');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitCreateAuthenticatorsPost(
      {required V1CreateAuthenticatorsRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/create_authenticators');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitCreateInvitationsPost(
      {required V1CreateInvitationsRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/create_invitations');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitCreateOauthProvidersPost(
      {required V1CreateOauthProvidersRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/create_oauth_providers');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitCreatePoliciesPost(
      {required V1CreatePoliciesRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/create_policies');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitCreatePolicyPost(
      {required V1CreatePolicyRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/create_policy');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitCreatePrivateKeyTagPost(
      {required V1CreatePrivateKeyTagRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/create_private_key_tag');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitCreatePrivateKeysPost(
      {required V1CreatePrivateKeysRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/create_private_keys');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitCreateReadOnlySessionPost(
      {required V1CreateReadOnlySessionRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/create_read_only_session');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>>
      _publicV1SubmitCreateReadWriteSessionPost(
          {required V1CreateReadWriteSessionRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/create_read_write_session');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitCreateSubOrganizationPost(
      {required V1CreateSubOrganizationRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/create_sub_organization');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitCreateUserTagPost(
      {required V1CreateUserTagRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/create_user_tag');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitCreateUsersPost(
      {required V1CreateUsersRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/create_users');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitCreateWalletPost(
      {required V1CreateWalletRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/create_wallet');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitCreateWalletAccountsPost(
      {required V1CreateWalletAccountsRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/create_wallet_accounts');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitDeleteApiKeysPost(
      {required V1DeleteApiKeysRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/delete_api_keys');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitDeleteAuthenticatorsPost(
      {required V1DeleteAuthenticatorsRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/delete_authenticators');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitDeleteInvitationPost(
      {required V1DeleteInvitationRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/delete_invitation');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitDeleteOauthProvidersPost(
      {required V1DeleteOauthProvidersRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/delete_oauth_providers');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitDeletePolicyPost(
      {required V1DeletePolicyRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/delete_policy');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitDeletePrivateKeyTagsPost(
      {required V1DeletePrivateKeyTagsRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/delete_private_key_tags');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitDeletePrivateKeysPost(
      {required V1DeletePrivateKeysRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/delete_private_keys');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitDeleteSubOrganizationPost(
      {required V1DeleteSubOrganizationRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/delete_sub_organization');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitDeleteUserTagsPost(
      {required V1DeleteUserTagsRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/delete_user_tags');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitDeleteUsersPost(
      {required V1DeleteUsersRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/delete_users');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitDeleteWalletsPost(
      {required V1DeleteWalletsRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/delete_wallets');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitEmailAuthPost(
      {required V1EmailAuthRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/email_auth');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitExportPrivateKeyPost(
      {required V1ExportPrivateKeyRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/export_private_key');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitExportWalletPost(
      {required V1ExportWalletRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/export_wallet');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitExportWalletAccountPost(
      {required V1ExportWalletAccountRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/export_wallet_account');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitImportPrivateKeyPost(
      {required V1ImportPrivateKeyRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/import_private_key');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitImportWalletPost(
      {required V1ImportWalletRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/import_wallet');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitInitImportPrivateKeyPost(
      {required V1InitImportPrivateKeyRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/init_import_private_key');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitInitImportWalletPost(
      {required V1InitImportWalletRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/init_import_wallet');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitInitOtpAuthPost(
      {required V1InitOtpAuthRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/init_otp_auth');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitInitUserEmailRecoveryPost(
      {required V1InitUserEmailRecoveryRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/init_user_email_recovery');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitOauthPost(
      {required V1OauthRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/oauth');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitOtpAuthPost(
      {required V1OtpAuthRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/otp_auth');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitRecoverUserPost(
      {required V1RecoverUserRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/recover_user');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitRejectActivityPost(
      {required V1RejectActivityRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/reject_activity');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>>
      _publicV1SubmitRemoveOrganizationFeaturePost(
          {required V1RemoveOrganizationFeatureRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/remove_organization_feature');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>>
      _publicV1SubmitSetOrganizationFeaturePost(
          {required V1SetOrganizationFeatureRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/set_organization_feature');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitSignRawPayloadPost(
      {required V1SignRawPayloadRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/sign_raw_payload');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitSignRawPayloadsPost(
      {required V1SignRawPayloadsRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/sign_raw_payloads');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitSignTransactionPost(
      {required V1SignTransactionRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/sign_transaction');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitUpdatePolicyPost(
      {required V1UpdatePolicyRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/update_policy');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitUpdatePrivateKeyTagPost(
      {required V1UpdatePrivateKeyTagRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/update_private_key_tag');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitUpdateRootQuorumPost(
      {required V1UpdateRootQuorumRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/update_root_quorum');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitUpdateUserPost(
      {required V1UpdateUserRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/update_user');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1ActivityResponse>> _publicV1SubmitUpdateUserTagPost(
      {required V1UpdateUserTagRequest? body}) {
    final Uri $url = Uri.parse('/public/v1/submit/update_user_tag');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<V1ActivityResponse, V1ActivityResponse>($request);
  }

  @override
  Future<Response<V1NOOPCodegenAnchorResponse>>
      _tkhqApiV1NoopCodegenAnchorPost() {
    final Uri $url = Uri.parse('/tkhq/api/v1/noop-codegen-anchor');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<V1NOOPCodegenAnchorResponse,
        V1NOOPCodegenAnchorResponse>($request);
  }
}
