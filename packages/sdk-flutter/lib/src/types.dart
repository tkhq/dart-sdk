import 'package:turnkey_http/__generated__/services/coordinator/v1/public_api.swagger.dart';

enum StorageKey {
  embeddedKey,
  session,
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
  final List<String> accounts;

  Wallet({
    required this.name,
    required this.id,
    required this.accounts,
  });

  /// Converts the wallet to a JSON map.
  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'accounts': accounts,
      };

  /// Creates a wallet from a JSON map.
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      name: json['name'],
      id: json['id'],
      accounts: List<String>.from(json['accounts']),
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

  TurnkeyConfig({
    required this.apiBaseUrl,
    required this.organizationId,
  });
}
