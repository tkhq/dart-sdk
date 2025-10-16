import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

// TODO (Amir): This file needs to be reworked to match the new SDK structure and features.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _signature;
  String? _exportedWallet;
  Wallet? _selectedWallet;
  WalletAccount? _selectedAccount;

  @override
  void initState() {
    super.initState();
    final turnkeyProvider =
        Provider.of<TurnkeyProvider>(context, listen: false);
    turnkeyProvider.addListener(_updateSelectedWallet);
    _updateSelectedWallet();
  }

  void _updateSelectedWallet() {
    final turnkeyProvider =
        Provider.of<TurnkeyProvider>(context, listen: false);

    final user = turnkeyProvider.user;
    if (user == null || user.wallets.isEmpty) {
      return;
    }

    final firstWallet = user.wallets.first;
    if (firstWallet.accounts.isEmpty) {
      return;
    }

    setState(() {
      _selectedWallet = firstWallet;
      _selectedAccount = firstWallet.accounts.first;
    });
  }

  Future<void> handleSign(BuildContext context, String messageToSign,
      String account, Function onStateUpdated) async {
    try {
      final turnkeyProvider =
          Provider.of<TurnkeyProvider>(context, listen: false);
      final addressType = account.startsWith('0x') ? 'ETH' : 'SOL';
      final hashedMessage = addressType == 'ETH'
          ? sha256.convert(utf8.encode(messageToSign)).toString()
          : utf8
              .encode(messageToSign)
              .map((b) => b.toRadixString(16).padLeft(2, '0'))
              .join();

      final response = await turnkeyProvider.signRawPayload(
          signWith: account,
          payload: hashedMessage,
          encoding: v1PayloadEncoding.payload_encoding_hexadecimal,
          hashFunction: addressType == 'ETH'
              ? v1HashFunction.hash_function_no_op
              : v1HashFunction.hash_function_not_applicable);
      onStateUpdated(() {
        _signature = 'r: ${response.r}, s: ${response.s}, v: ${response.v}';
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

  Future<void> handleExportWallet(BuildContext context, Wallet wallet) async {
    final turnkeyProvider =
        Provider.of<TurnkeyProvider>(context, listen: false);

    final export = await turnkeyProvider.exportWallet(
      walletId: wallet.id,
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
    final signMessage = 'I love Turnkey';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Provider.of<TurnkeyProvider>(context, listen: false)
                .clearAllSessions();
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
            // return (Text('Dashboard content goes here'));
            final user = turnkeyProvider.user;
            final userName =
                (user?.userName != null && user!.userName!.isNotEmpty)
                    ? user.userName
                    : 'User';

            final walletAccounts = _selectedWallet?.accounts;

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
                                PopupMenuButton<Wallet>(
                                  onSelected: (wallet) {
                                    setState(() {
                                      _selectedWallet = wallet;
                                      _selectedAccount = wallet.accounts[0];
                                    });
                                  },
                                  itemBuilder: (BuildContext context) {
                                    List<PopupMenuEntry<Wallet>> items = [];
                                    if (turnkeyProvider.user?.wallets != null) {
                                      items.addAll(turnkeyProvider.user!.wallets.map((wallet) {
                                        return PopupMenuItem<Wallet>(
                                          value: wallet,
                                          child: Text(wallet.name),
                                        );
                                      }).toList());
                                    }
                                    items.add(PopupMenuDivider());
                                    items.add(
                                      PopupMenuItem<Wallet>(
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
                                        _selectedWallet?.name ?? 'Wallet',
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
                                                'Export: ${_selectedWallet?.name ?? 'wallet'}?'),
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
                                                  handleExportWallet(context,
                                                      _selectedWallet!);
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
                                  '${account.address.substring(0, 6)}...${account.address.substring(account.address.length - 6)}'),
                              onChanged: (Object? value) {
                                setState(() {
                                  _selectedAccount = (value as WalletAccount?);
                                });
                              },
                              value: account,
                              groupValue: _selectedAccount,
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
                                title: Text('Sign message'),
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
                                    child: Text(_signature != null
                                        ? 'Close'
                                        : 'Cancel'),
                                  ),
                                  if (_signature == null)
                                    TextButton(
                                      onPressed: () async {
                                        await handleSign(
                                            context,
                                            signMessage,
                                            _selectedAccount!.address,
                                            setState);
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
        walletName: _walletNameController.text,
        accounts: [
          DEFAULT_ETHEREUM_ACCOUNT,
          DEFAULT_SOLANA_ACCOUNT,
        ],
      );
    } else {
      await turnkeyProvider.importWallet(
        mnemonic: _seedPhraseController.text,
        walletName: _walletNameController.text,
        accounts: [
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
              Expanded(
                child: Text(
                  'Automatically generate seed phrase',
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
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
