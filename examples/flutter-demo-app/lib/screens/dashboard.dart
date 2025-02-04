import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_http/__generated__/services/coordinator/v1/public_api.swagger.dart';
import 'package:turnkey_flutter_demo_app/providers/turnkey.dart';
import 'package:crypto/crypto.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _selectedAccount;
  String? _signature;

  Future<void> handleSign(BuildContext context, String messageToSign,
      Function onStateUpdated) async {
    try {
      final turnkeyProvider =
          Provider.of<TurnkeyProvider>(context, listen: false);
      final addressType = _selectedAccount!.startsWith("0x") ? "ETH" : "SOL";
      final hashedMessage = addressType == "ETH"
          ? sha256.convert(utf8.encode(messageToSign)).toString()
          : utf8
              .encode(messageToSign)
              .map((b) => b.toRadixString(16).padLeft(2, '0'))
              .join();

      final parameters = SignRawPayloadIntentV2(
          signWith: _selectedAccount!,
          payload: hashedMessage,
          encoding: PayloadEncoding.payloadEncodingHexadecimal,
          hashFunction: addressType == "ETH"
              ? HashFunction.hashFunctionNoOp
              : HashFunction.hashFunctionNotApplicable);

      final response =
          await turnkeyProvider.signRawPayload(context, parameters);

      onStateUpdated(() {
        _signature =
            'r: ${response.activity.result.signRawPayloadResult?.r}, s: ${response.activity.result.signRawPayloadResult?.s}, v: ${response.activity.result.signRawPayloadResult?.v}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Success! Message signed.')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing message: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final signMessage = "I love Turnkey";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Provider.of<TurnkeyProvider>(context, listen: false)
                .logout(context);
          },
          icon: Icon(
            Icons.logout,
            size: 24.0,
            semanticLabel: 'Logout of your Turnkey session',
          ),
        ),
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Consumer<TurnkeyProvider>(
          builder: (context, turnkeyProvider, child) {
            final user = turnkeyProvider.user;
            final userName =
                (user?.userName != null && user!.userName!.isNotEmpty)
                    ? user.userName
                    : 'User';
            final selectedWallet = user?.wallets[0];
            final walletAccounts = selectedWallet?.accounts;
            _selectedAccount = walletAccounts?.first;

            return Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome, $userName!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (walletAccounts != null)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.8,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: walletAccounts.map((account) {
                          return RadioListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                                '${account.substring(0, 6)}...${account.substring(account.length - 6)}'),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedAccount = value;
                              });
                            },
                            value: account,
                            groupValue: _selectedAccount,
                          );
                        }).toList(),
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return AlertDialog(
                                title: Text('Sign Message'),
                                content: Container(
                                  constraints: BoxConstraints(
                                    minHeight: 100,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  transformAlignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 0.8,
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(_signature ?? signMessage),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _signature = null;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await handleSign(
                                          context, signMessage, setState);
                                    },
                                    child: Text('Sign'),
                                  ),
                                ],
                              );
                            });
                          },
                        );
                      },
                      child: Text('Sign a message'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
