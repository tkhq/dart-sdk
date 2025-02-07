import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_flutter_demo_app/utils/constants.dart';
import 'package:turnkey_http/__generated__/services/coordinator/v1/public_api.swagger.dart';
import 'package:turnkey_flutter_demo_app/providers/turnkey.dart';
import 'package:turnkey_flutter_demo_app/providers/turnkey.dart' as tk;
import 'package:crypto/crypto.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _signature;
  String? _exportedWallet;

  Future<void> handleSign(BuildContext context, String messageToSign,
      String account, Function onStateUpdated) async {
    try {
      final turnkeyProvider =
          Provider.of<TurnkeyProvider>(context, listen: false);
      final addressType = account.startsWith("0x") ? "ETH" : "SOL";
      final hashedMessage = addressType == "ETH"
          ? sha256.convert(utf8.encode(messageToSign)).toString()
          : utf8
              .encode(messageToSign)
              .map((b) => b.toRadixString(16).padLeft(2, '0'))
              .join();

      final parameters = SignRawPayloadIntentV2(
          signWith: account,
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

  Future<void> handleExportWallet(
      BuildContext context, tk.Wallet wallet) async {
    final turnkeyProvider =
        Provider.of<TurnkeyProvider>(context, listen: false);

    final export = await turnkeyProvider.exportWallet(
      context,
      wallet.id,
    );

    _exportedWallet = export;

    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exported Wallet'),
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
            child: Text(_exportedWallet ?? 'Exporting...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _exportedWallet = null;
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
          ),
        ),
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Consumer<TurnkeyProvider>(
          builder: (context, turnkeyProvider, child) {
            void showTurnkeyProviderErrors() {
              if (turnkeyProvider.errorMessage != null) {
                debugPrint(turnkeyProvider.errorMessage.toString());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'An error has occurred: \n${turnkeyProvider.errorMessage.toString()}'),
                  ),
                );

                turnkeyProvider.setError(null);
              }
            }

            turnkeyProvider.addListener(showTurnkeyProviderErrors);

            final user = turnkeyProvider.user;
            final userName =
                (user?.userName != null && user!.userName!.isNotEmpty)
                    ? user.userName
                    : 'User';
            final selectedWallet =
                turnkeyProvider.selectedWallet ?? user?.wallets[0];
            final walletAccounts = selectedWallet?.accounts;
            final selectedAccount =
                turnkeyProvider.selectedAccount ?? walletAccounts?.first;

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
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 0.05,
                                  blurRadius: 1,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PopupMenuButton<tk.Wallet>(
                                  onSelected: (wallet) {
                                    turnkeyProvider.setSelectedWallet(wallet);
                                    ;
                                  },
                                  itemBuilder: (BuildContext context) {
                                    List<PopupMenuEntry<tk.Wallet>> items = [];
                                    if (user?.wallets != null) {
                                      items.addAll(user!.wallets.map((wallet) {
                                        return PopupMenuItem<tk.Wallet>(
                                          value: wallet,
                                          child: Text(wallet.name),
                                        );
                                      }).toList());
                                    }
                                    items.add(PopupMenuDivider());
                                    items.add(
                                      PopupMenuItem<tk.Wallet>(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AddWalletDialog();
                                              });
                                        },
                                        value: null,
                                        child: Row(
                                          children: [
                                            Icon(Icons.add),
                                            SizedBox(width: 8),
                                            Text('Add Wallet'),
                                          ],
                                        ),
                                      ),
                                    );
                                    return items;
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        selectedWallet?.name ?? 'Wallet',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'export') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            titleTextStyle: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black),
                                            title: Text(
                                                'Export: ${selectedWallet?.name ?? 'wallet'}?'),
                                            content: Text(
                                              'Your seed phrase will be exposed to the screen.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  handleExportWallet(
                                                      context, selectedWallet!);
                                                },
                                                child: Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: 'export',
                                        child: Row(
                                          children: [
                                            Icon(Icons.upload_file),
                                            SizedBox(width: 8),
                                            Text('Export Wallet'),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                  icon: Icon(Icons.more_vert),
                                ),
                              ],
                            ),
                          ),
                          ...walletAccounts.map((account) {
                            return RadioListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                  '${account.substring(0, 6)}...${account.substring(account.length - 6)}'),
                              onChanged: (String? value) {
                                turnkeyProvider.setSelectedAccount(value);
                              },
                              value: account,
                              groupValue: selectedAccount,
                            );
                          }),
                        ],
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
                                      await handleSign(context, signMessage,
                                          selectedAccount!, setState);
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

class AddWalletDialog extends StatefulWidget {
  const AddWalletDialog({super.key});

  @override
  _AddWalletDialogState createState() => _AddWalletDialogState();
}

class _AddWalletDialogState extends State<AddWalletDialog> {
  final TextEditingController _walletNameController = TextEditingController();
  final TextEditingController _seedPhraseController = TextEditingController();
  bool _generateSeedPhrase = true;

  Future<void> handleAddWallet(BuildContext context) async {
    final turnkeyProvider =
        Provider.of<TurnkeyProvider>(context, listen: false);
    if (_generateSeedPhrase) {
      await turnkeyProvider.createWallet(
        context,
        CreateWalletIntent(
          walletName: _walletNameController.text,
          accounts: [
            DEFAULT_ETHEREUM_ACCOUNT,
            DEFAULT_SOLANA_ACCOUNT,
          ],
        ),
      );
    } else {
      await turnkeyProvider.importWallet(
        context,
        _seedPhraseController.text,
        _walletNameController.text,
        [
          DEFAULT_ETHEREUM_ACCOUNT,
          DEFAULT_SOLANA_ACCOUNT,
        ],
      );
    }
    Navigator.of(context).pop(_walletNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Wallet'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _walletNameController,
            decoration: InputDecoration(hintText: 'Wallet Name'),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: _generateSeedPhrase,
                onChanged: (bool? value) {
                  setState(() {
                    _generateSeedPhrase = value ?? true;
                  });
                },
              ),
              Text('Automatically generate seed phrase'),
            ],
          ),
          if (!_generateSeedPhrase)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter your 12 or 24 word seed phrase:',
                    style:
                        TextStyle(fontSize: 10, fontStyle: FontStyle.italic)),
                SizedBox(height: 5),
                TextField(
                  controller: _seedPhraseController,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await handleAddWallet(context);
          },
          child: Text(_generateSeedPhrase ? 'Create' : 'Import'),
        ),
      ],
    );
  }
}
