import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namadawallet/helpers/wallet_data_copy_utils.dart';
import 'package:namadawallet/models/balance.dart';
import 'package:namadawallet/services/namada_indexer/balance_api.dart';
import 'package:namadawallet/services/wallet_data_service.dart';
import 'package:namadawallet/ui/screens/wallet/widgets/card_slider.dart';
import 'package:namadawallet/ui/screens/wallet/widgets/shielded_dummy_panel.dart';
import 'package:namadawallet/ui/screens/wallet/widgets/token_list_header.dart';
import 'package:namadawallet/ui/screens/wallet/widgets/token_list_view.dart';
import 'package:namadawallet/ui/screens/wallet/widgets/wallet_appbar.dart';
import 'package:namadawallet/ui/screens/wallet/widgets/wallet_selector.dart';
import 'package:namadawallet/widgets/loader/namada_loader_primary.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with AutomaticKeepAliveClientMixin, WalletDataCopyUtils {
  String _transparentBalance = 'Loading..';
  String _shieldedBalance = 'Press to start sync';
  String _tokenBalance = 'Loading..';
  String _tokenName = '';
  bool _loading = false;
  String _transparentAddress = '';
  String _shieldedAddress = '';
  String _publicKey = '';
  late List<Wallet> wallets;
  late Wallet selected;
  final _walletDataService = WalletDataService();
  List<Balance> _allBalances = [];
  final _accountApi = BalanceApi();
  String alias = '';
  bool _initialized = false;

  final _nativeTokenAddress = "tnam1q9gr66cvu4hrzm0sd5kmlnjje82gs3xlfg3v6nu7";

  String _spendKeys = '';
  String _status = '';
  bool _isSyncing = false;

  bool _shieldedReady = false;
  final List<Balance> _shieldedBalances = [];
  final PageController _cardController = PageController(
    viewportFraction: 0.75,
    keepPage: true,
  );
  final ValueNotifier<int> _cardIndex = ValueNotifier<int>(0);

  final List<CardModel> _cards = const [
    CardModel(
      label: 'Transparent',
      colorA: Color(0xFF2B2B30),
      colorB: Color(0xFF3A3A42),
      icon: Icons.visibility_rounded,
    ),
    CardModel(
      label: 'Shielded',
      colorA: Color(0xFFFFF176),
      colorB: Color(0xFFFFC107),
      icon: Icons.security,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _cardController.addListener(() {
      final idx = _cardController.page?.round() ?? 0;
      if (_cardIndex.value != idx) _cardIndex.value = idx;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // we need this check because the very first app versions had hardcoded wallet alias
      alias = (await getWalletAlias()) ?? 'my_wallet';
      await _initWalletData(alias);

      wallets = [
        Wallet(
          id: '1',
          name: alias,
          icon: Image.asset(
            'assets/images/nam_token_yellow_black.png',
            width: 24,
          ),
        ),
      ];
      _loadAvailableBalance();

      setState(() {
        selected = wallets.first;
        _initialized = true;
      });
    });
  }

  @override
  void dispose() {
    _accountApi.dispose();
    _cardController.dispose();
    _cardIndex.dispose();
    super.dispose();
  }

  Future<String?> getWalletAlias() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('wallet_alias');
  }

  Future<void> _initWalletData(String? alias) async {
    final data = await _walletDataService.loadFromToml(alias: alias);
    setState(() {
      _transparentAddress = data.transparentAddress;
      _shieldedAddress = data.paymentAddress;
      _publicKey = data.publicKey;
      _spendKeys = data.spendKeys;
    });
    await _loadAvailableBalance();
  }

  Future<void> _loadAvailableBalance() async {
    setState(() {
      _transparentBalance = 'Loading...';
      _tokenBalance = 'Loading...';
      _loading = true;
      _allBalances = [];
    });

    try {
      final balances = await _accountApi.fetchAccountBalances(
        _transparentAddress,
      );

      const namTokenAddress = 'tnam1q9gr66cvu4hrzm0sd5kmlnjje82gs3xlfg3v6nu7';
      final transparentEntry = balances.firstWhere(
        (b) => b.tokenAddress == namTokenAddress,
        orElse: () => Balance(tokenAddress: '', minDenomAmount: '0'),
      );

      final transparentAmount =
          BigInt.tryParse(transparentEntry.minDenomAmount) ?? BigInt.zero;
      final transparentFormatted = (transparentAmount.toDouble() / 1e6)
          .toStringAsFixed(4);

      // sort NAM first
      int _cmp(Balance a, Balance b) {
        final isNamA = a.tokenAddress == namTokenAddress;
        final isNamB = b.tokenAddress == namTokenAddress;
        if (isNamA && !isNamB) return -1;
        if (isNamB && !isNamA) return 1;

        final aAmt = BigInt.tryParse(a.minDenomAmount) ?? BigInt.zero;
        final bAmt = BigInt.tryParse(b.minDenomAmount) ?? BigInt.zero;
        final aNonZero = aAmt > BigInt.zero;
        final bNonZero = bAmt > BigInt.zero;

        // non-zero balances come before zero balances
        if (aNonZero && !bNonZero) return -1;
        if (bNonZero && !aNonZero) return 1;

        final byAmountDesc = bAmt.compareTo(aAmt);
        if (byAmountDesc != 0) return byAmountDesc;

        return a.tokenAddress.compareTo(b.tokenAddress);
      }

      final sortedBalances = [...balances]..sort(_cmp);

      setState(() {
        _allBalances = sortedBalances;
        _transparentBalance = transparentFormatted;
        _tokenBalance = '';
        _loading = false;
      });
    } catch (e) {
      debugPrint('Balance fetch error: $e');
      setState(() {
        _transparentBalance = 'Error';
        _tokenBalance = 'Error';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!_initialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF1D1B20),
        body: Center(child: NamadaLoaderPrimary()),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFF1D1B20),
      appBar: WalletAppBar(
        selected: selected,
        wallets: wallets,
        transparentAddress: _transparentAddress,
        shieldedAddress: _shieldedAddress,
        publicKey: _publicKey,
        onCopyTransparent: () =>
            copyToClipboard(_transparentAddress, 'Transparent address'),
        onCopyPublic: () => copyToClipboard(_publicKey, 'Public key'),
        onCopyShielded: () =>
            copyToClipboard(_shieldedAddress, 'Shielded address'),
        onWalletChanged: (w) => setState(() => selected = w),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAvailableBalance,
        color: Colors.yellow,
        backgroundColor: const Color(0xFF1D1B20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // === Card slider (Transparent | Shielded) ====================
              SizedBox(
                height: 146,
                child: ValueListenableBuilder<int>(
                  valueListenable: _cardIndex,
                  builder: (_, activeIdx, __) {
                    return PageView.builder(
                      controller: _cardController,
                      itemCount: _cards.length,
                      padEnds: false,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _cardController,
                          builder: (_, __) {
                            final page = _cardController.page ?? 0.0;
                            final delta = (index - page).abs().clamp(0.0, 1.0);
                            final scale = 1 - (0.02 * (1 - (1 - delta)));
                            return Transform.scale(
                              scale: scale,
                              child: NamadaCard(
                                model: _cards[index],
                                active: index == activeIdx,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              ValueListenableBuilder<int>(
                valueListenable: _cardIndex,
                builder: (_, idx, __) =>
                    Dots(count: _cards.length, active: idx),
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<int>(
                valueListenable: _cardIndex,
                builder: (_, idx, __) {
                  final isShielded = _cards[idx].label == 'Shielded';
                  if (isShielded) {
                    // when shielded not ready, show dummy panel with sync button
                    if (!_shieldedReady) {
                      return ShieldedDummyContainer(
                        onSyncPressed: () => {},
                        // shows "Is syncing…" and flips to list on success
                        shieldedBalance: _shieldedBalance,
                        status: _status,
                        isSyncing: _isSyncing,
                      );
                    }
                    // shielded card view
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 4),
                        const TokenListHeader(title: "Shielded Tokens"),
                        TokenListView(
                          balances: _shieldedBalances,
                          namTokenAddress: _nativeTokenAddress,
                        ),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 4),
                      const TokenListHeader(title: "Transparent Tokens"),
                      TokenListView(
                        balances: _allBalances,
                        namTokenAddress: _nativeTokenAddress,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
