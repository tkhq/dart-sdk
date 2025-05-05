import { type TurnkeyApiTypes } from "@turnkey/sdk-server";

export type Attestation = TurnkeyApiTypes["v1Attestation"];

export type CurveType = TurnkeyApiTypes["v1ApiKeyCurve"];

export type Email = `${string}@${string}.${string}`;

export type GetSubOrgIdParams = {
  filterType:
    | "NAME"
    | "USERNAME"
    | "EMAIL"
    | "PHONE_NUMBER"
    | "CREDENTIAL_ID"
    | "PUBLIC_KEY"
    | "OIDC_TOKEN";
  filterValue: string;
};

export type InitOtpAuthParams = {
  otpType: "OTP_TYPE_EMAIL" | "OTP_TYPE_SMS";
  contact: string;
};

export type CreateSubOrgParams = {
  email?: Email;
  phone?: string;
  passkey?: {
    name?: string;
    challenge: string;
    attestation: Attestation;
  };
  oauth?: {
    oidcToken: string;
    providerName: string;
  };
  apiKeys?: {
    apiKeyName: string;
    publicKey: string;
    curveType: CurveType;
    expirationSeconds?: string;
  }[];
};

export type GetWhoamiParams = {
  organizationId: string;
};

export type OtpAuthParams = {
  otpId: string;
  otpCode: string;
  organizationId: string;
  targetPublicKey: string;
  apiKeyName?: string;
  expirationSeconds?: string;
  invalidateExisting?: boolean;
};

export type OAuthLoginParams = {
  email?: Email;
  oidcToken: string;
  providerName: string;
  targetPublicKey: string;
  expirationSeconds?: string;
};

export type MethodParamsMap = {
  getSubOrgId: GetSubOrgIdParams;
  initOTPAuth: InitOtpAuthParams;
  createSubOrg: CreateSubOrgParams;
  getWhoami: GetWhoamiParams;
  otpAuth: OtpAuthParams;
  oAuthLogin: OAuthLoginParams;
};

export type MethodName = keyof MethodParamsMap;

export type ParamsType<M extends MethodName> = MethodParamsMap[M];

export type JSONRPCRequest<M extends MethodName> = {
  method: M;
  params: ParamsType<M>;
};

export type User = {
  id: string;
  userName?: string;
  email?: string;
  phoneNumber?: string;
  organizationId: string;
  wallets: {
    name: string;
    id: string;
    accounts: `0x${string}`[];
  }[];
};
