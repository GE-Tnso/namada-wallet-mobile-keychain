import 'package:flutter/material.dart';
import 'package:namadawallet/services/wallet_data_service.dart';
import 'package:namadawallet/ui/screens/stake/stake_feature_unavailable_screen.dart';
import 'package:namadawallet/ui/screens/wallet/wallet_setup_screen.dart';

import 'package:namadawallet/ui/screens/wallet/wallet_screen.dart';
import 'package:namadawallet/widgets/bottom_navbar/primary_bottom_navigation_bar.dart';

import 'ui/screens/account/account_feature_unavailable_screen.dart';
import 'ui/screens/deposit/deposit_feature_unavailable_screen.dart';
import 'ui/screens/transaction/transfer_feature_unavailable_screen.dart';

void main() async {
  _checkIfWalletExists();
}

void _checkIfWalletExists() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hasWallet = await WalletDataService().walletExists();
  runApp(MyApp(hasWallet: hasWallet));
}

class MyApp extends StatelessWidget {
  final bool hasWallet;

  const MyApp({Key? key, required this.hasWallet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'SpaceGrotesk'),
      home: hasWallet ? const MainWithNavbar() : WalletSetupScreen(),
    );
  }
}

class MainWithNavbar extends StatefulWidget {
  const MainWithNavbar({Key? key}) : super(key: key);

  @override
  _MainWithNavbarState createState() => _MainWithNavbarState();
}

class _MainWithNavbarState extends State<MainWithNavbar> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    WalletScreen(),
    StakeFeatureUnavailableScreen(),
    TransferFeatureUnavailableScreen(),
    DepositFeatureUnavailableScreen(),
    AccountFeatureUnavailableScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: PrimaryBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
