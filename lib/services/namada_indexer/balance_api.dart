import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:namadawallet/config/namada_mainnet/api_constants.dart';
import 'package:namadawallet/models/balance.dart';

class BalanceApi {
  final String baseUrl;
  final http.Client _httpClient;
  static const String _accountEndpoint = 'api/v1/account';

  BalanceApi({
    this.baseUrl = ApiConstants.indexerMainnetBaseUrl,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  /// Fetches all balances for [address] via indexer.
  Future<List<Balance>> fetchAccountBalances(String address) async {
    final url = Uri.parse('$baseUrl/$_accountEndpoint/$address');
    final response = await _httpClient.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch balances: HTTP ${response.statusCode} - ${response.body}',
      );
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw Exception('Unexpected response format: expected a List');
      }
      return decoded
          .map((e) => Balance.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to parse response: $e');
    }
  }

  void dispose() => _httpClient.close();
}
