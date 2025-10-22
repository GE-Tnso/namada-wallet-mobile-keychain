import 'package:flutter/material.dart';
import 'package:namadawallet/services/wallet_data_service.dart';
import 'package:namadawallet/ui/screens/wallet/widgets/wallet_action_buttons.dart';
import 'package:namadawallet/ui/screens/wallet/widgets/wallet_header.dart';
import 'package:namadawallet/widgets/appbar/primary_appbar.dart';
import 'package:flutter/services.dart';

class WalletSetupScreen extends StatefulWidget {
  @override
  State<WalletSetupScreen> createState() => _WalletSetupScreenState();
}

class _WalletSetupScreenState extends State<WalletSetupScreen> {
  bool _hasWallet = false;
  static const String screenTitle = "Wallet Setup";

  @override
  void initState() {
    super.initState();
    _checkIfWalletExists();
  }

  void _checkIfWalletExists() {
    WalletDataService().walletExists().then((exists) {
      setState(() => _hasWallet = exists);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _hasWallet,
      child: Scaffold(
        backgroundColor: const Color(0xFF1D1B20),
        appBar: buildWalletAppBar(context, screenTitle, _hasWallet),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            WalletHeaderSection(),
            WalletActionButtons(),
          ],
        ),
      ),
    );
  }
}
