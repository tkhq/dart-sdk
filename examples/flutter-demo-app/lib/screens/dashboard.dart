import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  String? _signature;
  String? _exportedWallet;
  Wallet? _selectedWallet;
  v1WalletAccount? _selectedAccount;

  late final TurnkeyProvider _turnkeyProvider;
  late final VoidCallback _providerListener;

  @override
  void initState() {
    super.initState();

    // Capture provider once; no context in listener later.
    _turnkeyProvider = Provider.of<TurnkeyProvider>(context, listen: false);

    _providerListener = _handleProviderUpdate;
    _turnkeyProvider.addListener(_providerListener);

    // Initialize local selections from provider.
    _updateSelectedWalletFromProvider(_turnkeyProvider);
  }

  @override
  void dispose() {
    // Always remove listeners to avoid calling setState on a disposed widget.
    _turnkeyProvider.removeListener(_providerListener);
    super.dispose();
  }

  void _handleProviderUpdate() {
    if (!context.mounted) return;
    _updateSelectedWalletFromProvider(_turnkeyProvider);
  }

  void _updateSelectedWalletFromProvider(TurnkeyProvider provider) {
    final wallets = provider.wallets;
    final user = provider.user;

    if (user == null || wallets == null || wallets.isEmpty) return;
    if (wallets.first.accounts.isEmpty) return;

    if (!context.mounted) return;
    setState(() {
      _selectedWallet = wallets.first;
      _selectedAccount = wallets.first.accounts.first;
    });
  }

  Future<void> handleSign(
    BuildContext context,
    String messageToSign,
    v1WalletAccount account,
    void Function(void Function()) onStateUpdated,
  ) async {
    try {
      final response = await _turnkeyProvider.signMessage(
        walletAccount: account,
        message: messageToSign,
      );

      if (!context.mounted) return;

      onStateUpdated(() {
        _signature = 'r: ${response.r}, s: ${response.s}, v: ${response.v}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Success! Message signed.')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing message: $error')),
      );
    }
  }

  Future<void> handleExportWallet(BuildContext context, Wallet wallet) async {
    try {
      final export = await _turnkeyProvider.exportWallet(
        walletId: wallet.id,
      );

      if (!context.mounted) return;

      _exportedWallet = export;

      if (!context.mounted) return;
      Navigator.of(context).pop();

      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Exported Wallet'),
            content: Container(
              constraints: const BoxConstraints(minHeight: 100),
              padding: const EdgeInsets.all(10),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 0.8,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(4),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  _exportedWallet ?? 'Exporting...',
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _exportedWallet ?? ''));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mnemonic copied to clipboard'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.copy, size: 18),
                    SizedBox(width: 4),
                    Text('Copy'),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _exportedWallet = null;
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    const signMessage = 'I love Turnkey';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Fire and forget; provider handles lifecycle.
            _turnkeyProvider.clearAllSessions();
          },
          icon: const Icon(Icons.logout, size: 24.0),
        ),
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Consumer<TurnkeyProvider>(
          builder: (context, turnkeyProvider, child) {
            final walletAccounts = _selectedWallet?.accounts;

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Welcome, ${turnkeyProvider.user?.userName ?? 'User'}!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (walletAccounts != null)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
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
                                    if (!context.mounted) return;
                                    setState(() {
                                      _selectedWallet = wallet;
                                      _selectedAccount = wallet.accounts.first;
                                    });
                                  },
                                  itemBuilder: (BuildContext context) {
                                    final wallets = turnkeyProvider.wallets;
                                    if (wallets == null || wallets.isEmpty) {
                                      return const [
                                        PopupMenuItem<Wallet>(
                                          value: null,
                                          child: Text('No wallets available'),
                                        ),
                                      ];
                                    }
                                    return [
                                      ...wallets.map(
                                        (wallet) => PopupMenuItem<Wallet>(
                                          value: wallet,
                                          child: Text(wallet.name),
                                        ),
                                      ),
                                      const PopupMenuDivider(),
                                      PopupMenuItem<Wallet>(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                const AddWalletDialog(),
                                          );
                                        },
                                        value: null,
                                        child: const Row(
                                          children: [
                                            Icon(Icons.add),
                                            SizedBox(width: 8),
                                            Text('Add Wallet'),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        _selectedWallet?.name ?? 'Wallet',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const Icon(Icons.arrow_drop_down),
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
                                            titleTextStyle: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                            title: Text(
                                              'Export: ${_selectedWallet?.name ?? 'wallet'}?',
                                            ),
                                            content: const Text(
                                              'Your seed phrase will be exposed to the screen.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if (_selectedWallet != null) {
                                                    handleExportWallet(
                                                      context,
                                                      _selectedWallet!,
                                                    );
                                                  }
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => const [
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
                                  ],
                                  icon: const Icon(Icons.more_vert),
                                ),
                              ],
                            ),
                          ),
                          RadioGroup<v1WalletAccount>(
                            groupValue: _selectedAccount,
                            onChanged: (v1WalletAccount? newAccount) {
                              if (!context.mounted) return;
                              setState(() => _selectedAccount = newAccount);
                            },
                            child: Column(
                              children: [
                                for (final account in walletAccounts)
                                  RadioListTile<v1WalletAccount>(
                                    value: account,
                                    title: Text(
                                      '${account.address.substring(0, 6)}...${account.address.substring(account.address.length - 6)}',
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (_selectedAccount != null)
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
                                    title: const Text('Sign message'),
                                    content: Container(
                                      constraints:
                                          const BoxConstraints(minHeight: 100),
                                      padding: const EdgeInsets.all(10),
                                      transformAlignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: const [
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
                                        child: Text(
                                          _signature != null
                                              ? 'Close'
                                              : 'Cancel',
                                        ),
                                      ),
                                      if (_signature == null)
                                        TextButton(
                                          onPressed: () async {
                                            await handleSign(
                                              context,
                                              signMessage,
                                              _selectedAccount!,
                                              setState,
                                            );
                                          },
                                          child: const Text('Sign'),
                                        ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: const Text('Sign a message'),
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
  AddWalletDialogState createState() => AddWalletDialogState();
}

class AddWalletDialogState extends State<AddWalletDialog> {
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
    if (!context.mounted) return;
    Navigator.of(context).pop(_walletNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Wallet'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _walletNameController,
            decoration: const InputDecoration(hintText: 'Wallet Name'),
          ),
          const SizedBox(height: 10),
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
              const Expanded(
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
                const Text(
                  'Enter your 12 or 24 word seed phrase:',
                  style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _seedPhraseController,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: const InputDecoration(
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
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async => await handleAddWallet(context),
          child: Text(_generateSeedPhrase ? 'Create' : 'Import'),
        ),
      ],
    );
  }
}
