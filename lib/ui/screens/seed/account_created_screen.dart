import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namadawallet/main.dart';
import 'package:namadawallet/services/wallet_data_service.dart';
import 'package:namadawallet/widgets/appbar/primary_appbar.dart';
import 'package:namadawallet/widgets/buttons/confimation_button_v2.dart';

class AccountCreatedScreen extends StatefulWidget {
  final String alias;

  const AccountCreatedScreen({Key? key, required this.alias}) : super(key: key);

  @override
  _AccountCreatedScreenState createState() => _AccountCreatedScreenState();
}

class _AccountCreatedScreenState extends State<AccountCreatedScreen> {
  String _transparentAddress = '';
  String _publicKey = '';
  String _paymentAddress = '';

  bool _hasWallet = false;
  WalletData? _walletData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadWalletData();
    });
  }

  Future<void> _loadWalletData() async {
    try {
      final service = WalletDataService();
      final data = await service.loadFromToml(alias: widget.alias);

      setState(() {
        _walletData = data;
        _hasWallet = data.transparentAddress.isNotEmpty;
      });
    } catch (e) {
      debugPrint('Failed to load wallet data: $e');
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, VoidCallback onCopy) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2B2930),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label + value
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFFFFFF00),
                      fontSize: 16,
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, color: Color(0xFFFFFF00)),
              onPressed: onCopy,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transparent = _walletData?.transparentAddress ?? 'Loading...';
    final publicKey = _walletData?.publicKey ?? 'Loading...';
    final shielded = _walletData?.paymentAddress ?? 'Loading...';

    return Scaffold(
      backgroundColor: const Color(0xFF1D1B20),
      appBar: const PrimaryAppBar(title: 'Namada Keys Created'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Center(
                child: Text(
                  "Here is the account generated from your keys",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            _buildInfoTile(
              'Your Transparent Address',
              transparent,
              () => _copyToClipboard(transparent, 'Transparent address'),
            ),
            _buildInfoTile(
              'Public Key',
              publicKey,
              () => _copyToClipboard(publicKey, 'Public key'),
            ),
            _buildInfoTile(
              'Your Shielded Address',
              shielded,
              () => _copyToClipboard(shielded, 'Shielded address'),
            ),
            ConfirmationButtonV2(
              isEnabled: _hasWallet,
              label: "Finish Setup",
              onPressed: _hasWallet
                  ? () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyApp(hasWallet: true),
                        ),
                        (route) => false,
                      );
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
