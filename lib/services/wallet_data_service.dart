import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:toml/toml.dart';

class WalletData {
  final String transparentAddress;
  final String publicKey;
  final String paymentAddress;
  final String spendKeys;

  WalletData({
    required this.transparentAddress,
    required this.publicKey,
    required this.paymentAddress,
    required this.spendKeys,
  });
}

class WalletDataService {
  Future<bool> walletExists() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/sdk-wallet/wallet.toml');
    return file.exists();
  }

  Future<WalletData> loadFromToml({String? alias}) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/sdk-wallet/wallet.toml');
    final raw = await file.readAsString();
    final doc = TomlDocument.parse(raw).toMap();

    final addr = doc['addresses']?[alias] as String? ?? '';
    final paymentAddr =
        doc['payment_addrs']?['${alias}_shielded_payment'] as String? ?? '';
    var pub = doc['public_keys']?[alias] as String? ?? '';
    var spend = doc['spend_keys']?['${alias}_shielded'] as String? ?? '';
    pub = pub.replaceFirst('ED25519_PK_PREFIX', '');
    spend = spend.replaceFirst('unencrypted:', '');

    return WalletData(
      transparentAddress: addr,
      publicKey: pub,
      paymentAddress: paymentAddr,
      spendKeys: spend,
    );
  }
}
