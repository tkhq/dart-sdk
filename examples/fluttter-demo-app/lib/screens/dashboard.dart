import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_dart_http_client/__generated__/services/coordinator/v1/public_api.swagger.dart';
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

  Future<void> handleSign(BuildContext context, String messageToSign) async {
    try {
      final turnkeyProvider =
          Provider.of<TurnkeyProvider>(context, listen: false);
      final addressType = _selectedAccount!.startsWith("0x") ? "ETH" : "SOL";
      final hashedMessage = addressType == "ETH"
          ? sha256
              .convert(utf8.encode(messageToSign))
              .toString() //Idk if this works
          : utf8
              .encode(messageToSign)
              .map((b) => b.toRadixString(16).padLeft(2, '0'))
              .join(); //What is this doing?

      final parameters = V1SignRawPayloadIntentV2(
          signWith: _selectedAccount!,
          payload: hashedMessage,
          encoding: V1PayloadEncoding.payloadEncodingHexadecimal,
          hashFunction: addressType == "ETH"
              ? V1HashFunction.hashFunctionNoOp
              : V1HashFunction.hashFunctionNotApplicable);

      final response =
          await turnkeyProvider.signRawPayload(context, parameters);

      setState(() {
        _signature =
            'r: ${response.activity.result.signRawPayloadResult?.r}, s: ${response.activity.result.signRawPayloadResult?.s}, v: ${response.activity.result.signRawPayloadResult?.v}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Success! Message signed.')),
      );
    } catch (error) {
      print("Error signing message: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final signMessage = "I love Turnkey";
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Consumer<TurnkeyProvider>(
          builder: (context, turnkeyProvider, child) {
            final user = turnkeyProvider.user;
            final userName = user?.userName ?? 'User';
            final selectedWallet = user?.wallets[0];
            final walletAccounts = selectedWallet?.accounts;

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
                            title: Text(account),
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
                            return AlertDialog(
                              title: Text('Sign Message'),
                              content: Text(_signature ?? signMessage),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    _signature = null;
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await handleSign(context, signMessage);
                                  },
                                  child: Text('Sign'),
                                ),
                              ],
                            );
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
