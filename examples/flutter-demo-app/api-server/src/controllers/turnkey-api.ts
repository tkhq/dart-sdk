import { Email, JSONRPCRequest, MethodName, ParamsType } from "../types";
import { DEFAULT_ETHEREUM_ACCOUNTS, Turnkey } from "@turnkey/sdk-server";
import { Request, Response } from "express";
import dotenv from "dotenv";
import path from "path";
import { decodeJwt } from "../utils";

dotenv.config({ path: path.resolve(__dirname, "../../../.env") });

export const turnkeyConfig = {
  apiBaseUrl: process.env.TURNKEY_API_URL ?? "",
  defaultOrganizationId: process.env.ORGANIZATION_ID ?? "",
  apiPublicKey: process.env.TURNKEY_API_PUBLIC_KEY ?? "",
  apiPrivateKey: process.env.TURNKEY_API_PRIVATE_KEY ?? "",
};

const turnkey = new Turnkey(turnkeyConfig).apiClient();

export async function POST(req: Request, res: Response) {
  const body: JSONRPCRequest<MethodName> = req.body;
  const { method, params } = body;

  try {
    switch (method) {
      case "getSubOrgId":
        return handleGetSubOrgId(params as ParamsType<"getSubOrgId">, res);
      case "initOTPAuth":
        return handleInitOtpAuth(params as ParamsType<"initOTPAuth">, res);
      case "createSubOrg":
        const subOrgResult = await handleCreateSubOrg(
          params as ParamsType<"createSubOrg">
        );
        return res.json(subOrgResult);

      case "otpAuth":
        return handleOtpAuth(params as ParamsType<"otpAuth">, res);
      case "oAuthLogin":
        return handleOAuthLogin(params as ParamsType<"oAuthLogin">, res);
      default:
        return res.json({ error: "Method not found", status: 404 });
    }
  } catch (error: any) {
    console.log("error", error);
    console.error("server error", { ...error }, JSON.stringify(error));
    return res.json({
      error: error.message || "An unknown error occurred",
      code: error.code || 0,
      status: 500,
    });
  }
}

async function handleGetSubOrgId(
  params: ParamsType<"getSubOrgId">,
  res: Response
) {
  const { filterType, filterValue } = params;

  let organizationId: string = turnkeyConfig.defaultOrganizationId;
  const { organizationIds } = await turnkey.getSubOrgIds({
    filterType,
    filterValue,
  });
  if (organizationIds.length > 0) {
    organizationId = organizationIds[0];
  }
  return res.json({ organizationId });
}

async function handleOAuthLogin(
  params: ParamsType<"oAuthLogin">,
  res: Response
) {
  const { email, oidcToken, providerName, targetPublicKey, expirationSeconds } =
    params;
  let organizationId: string = turnkeyConfig.defaultOrganizationId;

  const { organizationIds } = await turnkey.getSubOrgIds({
    filterType: "OIDC_TOKEN",
    filterValue: oidcToken,
  });

  if (organizationIds.length > 0) {
    organizationId = organizationIds[0];
  } else {
    const createSubOrgParams = { email, oauth: { oidcToken, providerName } };
    const result = await handleCreateSubOrg(createSubOrgParams);
    organizationId = result.subOrganizationId;
  }

  const oauthResponse = await turnkey.oauth({
    organizationId,
    oidcToken,
    targetPublicKey,
    expirationSeconds,
  });

  return res.json(oauthResponse);
}

async function handleInitOtpAuth(
  params: ParamsType<"initOTPAuth">,
  res: Response
) {
  const { otpType, contact } = params;
  let organizationId: string = turnkeyConfig.defaultOrganizationId;

  const { organizationIds } = await turnkey.getSubOrgIds({
    filterType: otpType === "OTP_TYPE_EMAIL" ? "EMAIL" : "PHONE_NUMBER",
    filterValue: contact,
  });

  if (organizationIds.length > 0) {
    organizationId = organizationIds[0];
  } else {
    const createSubOrgParams =
      otpType === "OTP_TYPE_EMAIL"
        ? { email: contact as Email }
        : { phone: contact };
    const result = await handleCreateSubOrg(createSubOrgParams);
    organizationId = result.subOrganizationId;
  }

  const result = await turnkey.initOtpAuth({
    organizationId,
    otpType,
    contact,
  });
  return res.json({ ...result, organizationId });
}

async function handleOtpAuth(params: ParamsType<"otpAuth">, res: Response) {
  try {
    const result = await turnkey.otpAuth(params);
    return res.json(result);
  } catch (error: any) {
    return res.json({ error: error.message, status: 500 });
  }
}

async function handleCreateSubOrg(params: ParamsType<"createSubOrg">) {
  const { email, phone, passkey, oauth, apiKeys } = params;

  const subOrganizationName = `Sub Org - ${email || phone}`;
  const userName = email ? email.split("@")[0] || email : "";
  let userEmail = email;
  const userPhoneNumber = phone;
  const oauthProviders = oauth ? [oauth] : []; // You can attach multiple oauth providers when creating a suborganization
  const authenticators = passkey
    ? [
        {
          authenticatorName: "Passkey",
          challenge: passkey.challenge,
          attestation: passkey.attestation,
        },
      ]
    : [];

  // If the user is authenticated with OAuth, you can extract the email from the token in most cases.
  if (oauth) {
    const decoded = decodeJwt(oauth.oidcToken);
    if (decoded?.email) {
      userEmail = decoded.email;
    }
  }

  const result = await turnkey.createSubOrganization({
    organizationId: turnkeyConfig.defaultOrganizationId,
    subOrganizationName,
    rootUsers: [
      {
        userName,
        userEmail,
        userPhoneNumber,
        oauthProviders,
        authenticators,
        apiKeys: apiKeys ?? [],
      },
    ],
    rootQuorumThreshold: 1,
    wallet: {
      walletName: "Default Wallet",
      accounts: DEFAULT_ETHEREUM_ACCOUNTS,
    },
  });

  return result;
}
