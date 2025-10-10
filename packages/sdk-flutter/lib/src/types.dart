import 'dart:convert';

import 'package:turnkey_http/__generated__/services/coordinator/v1/public_api.swagger.dart';

/// A class representing a session with public and private keys and an expiry time.
class Session {
  final String sessionType;
  final String userId;
  final String organizationId;
  final int expiry;
  final String expirationSeconds;
  final String publicKey;
  final String token;

  const Session({
    required this.sessionType,
    required this.userId,
    required this.organizationId,
    required this.expiry,
    required this.expirationSeconds,
    required this.publicKey,
    required this.token,
  });

  /// Construct from JSON (used when retrieving from storage)
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionType: json['sessionType'] as String,
      userId: json['userId'] as String,
      organizationId: json['organizationId'] as String,
      expiry: json['expiry'] as int,
      expirationSeconds: json['expirationSeconds'] as String,
      publicKey: json['publicKey'] as String,
      token: json['token'] as String,
    );
  }

  /// Convert back to JSON (used for storage)
  Map<String, dynamic> toJson() {
    return {
      'sessionType': sessionType,
      'userId': userId,
      'organizationId': organizationId,
      'expiry': expiry,
      'expirationSeconds': expirationSeconds,
      'publicKey': publicKey,
      'token': token,
    };
  }

  /// Helper: create Session from a JWT string
  static Session fromJwt(String token) {
    final parts = token.split(".");
    if (parts.length < 2) {
      throw Exception("Invalid JWT: Missing payload");
    }

    final payload = parts[1];
    final normalized =
        base64.normalize(payload.replaceAll('-', '+').replaceAll('_', '/'));
    final decodedBytes = base64.decode(normalized);
    final decoded =
        jsonDecode(utf8.decode(decodedBytes)) as Map<String, dynamic>;

    final exp = decoded["exp"];
    final publicKey = decoded["public_key"];
    final sessionType = decoded["session_type"];
    final userId = decoded["user_id"];
    final organizationId = decoded["organization_id"];

    if (exp == null ||
        publicKey == null ||
        sessionType == null ||
        userId == null ||
        organizationId == null) {
      throw Exception("JWT payload missing required fields");
    }

    final expirySeconds =
        ((exp * 1000 - DateTime.now().millisecondsSinceEpoch) / 1000).ceil();

    return Session(
      sessionType: sessionType,
      userId: userId,
      organizationId: organizationId,
      expiry: exp,
      expirationSeconds: expirySeconds.toString(),
      publicKey: publicKey,
      token: token,
    );
  }
}

/// A class representing a user with various attributes.
class User {
  final String id;
  final String? userName;
  final String? email;
  final String? phoneNumber;
  final String organizationId;
  final List<Wallet> wallets;

  User({
    required this.id,
    this.userName,
    this.email,
    this.phoneNumber,
    required this.organizationId,
    required this.wallets,
  });

  /// Converts the user to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'email': email,
        'phoneNumber': phoneNumber,
        'organizationId': organizationId,
        'wallets': wallets.map((wallet) => wallet.toJson()).toList(),
      };

  /// Creates a user from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      organizationId: json['organizationId'],
      wallets: (json['wallets'] as List<dynamic>)
          .map((walletJson) => Wallet.fromJson(walletJson))
          .toList(),
    );
  }
}

/// A class representing a wallet with a name, id, and a list of accounts.
class Wallet {
  final String name;
  final String id;
  final List<WalletAccount> accounts;

  Wallet({
    required this.name,
    required this.id,
    required this.accounts,
  });

  /// Converts the wallet to a JSON map.
  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'accounts': accounts.map((account) => account.toJson()).toList(),
      };

  /// Creates a wallet from a JSON map.
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      name: json['name'],
      id: json['id'],
      accounts: (json['accounts'] as List<dynamic>)
          .map((accountJson) => WalletAccount.fromJson(accountJson))
          .toList(),
    );
  }
}

/// A class representing a wallet account with various attributes.
class WalletAccount {
  final String id;
  final Curve curve;
  final PathFormat pathFormat;
  final String path;
  final AddressFormat addressFormat;
  final String address;
  final ExternalDataV1Timestamp createdAt;
  final ExternalDataV1Timestamp updatedAt;

  WalletAccount({
    required this.id,
    required this.curve,
    required this.pathFormat,
    required this.path,
    required this.addressFormat,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Converts the wallet account to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'curve': curve.toString(),
        'pathFormat': pathFormat.toString(),
        'path': path,
        'addressFormat': addressFormat.toString(),
        'address': address,
        'createdAt': createdAt.toJson(),
        'updatedAt': updatedAt.toJson(),
      };

  /// Creates a wallet account from a JSON map.
  factory WalletAccount.fromJson(Map<String, dynamic> json) {
    return WalletAccount(
      id: json['id'],
      curve: Curve.values.firstWhere((e) => e.toString() == json['curve']),
      pathFormat: PathFormat.values
          .firstWhere((e) => e.toString() == json['pathFormat']),
      path: json['path'],
      addressFormat: AddressFormat.values
          .firstWhere((e) => e.toString() == json['addressFormat']),
      address: json['address'],
      createdAt: ExternalDataV1Timestamp.fromJson(json['createdAt']),
      updatedAt: ExternalDataV1Timestamp.fromJson(json['updatedAt']),
    );
  }
}

class TurnkeyConfig {
  final String apiBaseUrl;
  final String organizationId;

  final void Function(Session session)? onSessionCreated;
  final void Function(Session session)? onSessionSelected;
  final void Function(Session session)? onSessionExpired;
  final void Function(Session session)? onSessionCleared;
  final void Function(Session session)? onSessionRefreshed;
  final void Function()? onSessionEmpty;
  final void Function(Object? error)? onInitialized;

  TurnkeyConfig({
    required this.apiBaseUrl,
    required this.organizationId,
    this.onSessionCreated,
    this.onSessionSelected,
    this.onSessionExpired,
    this.onSessionCleared,
    this.onSessionRefreshed,
    this.onSessionEmpty,
    this.onInitialized,
  });
}
