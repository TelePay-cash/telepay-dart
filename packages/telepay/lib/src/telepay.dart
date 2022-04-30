import 'package:dio/dio.dart';
import 'package:telepay/src/exceptions/exceptions.dart';
import 'package:telepay/src/models/models.dart';

/// {@template telepay}
/// Dart API Client wich wraps the TelePay API
/// {@endtemplate}
class TelePay {
  /// {@macro telepay}
  TelePay({
    required String secretApiKey,
    required Dio dio,
  })  : _secretApiKey = secretApiKey,
        _dio = dio {
    _dio.options = BaseOptions(baseUrl: baseUrl);
  }

  /// Base URL for the TelePay API
  static const String baseUrl = 'https://api.telepay.cash/rest/';

  /// API Key for the TelePay API
  final String _secretApiKey;

  final Dio _dio;

  /// Set headers for the Dio instance
  Map<String, String> _headers() => <String, String>{
        'AUTHORIZATION': _secretApiKey,
        'Accept': 'application/json'
      };

  /// Info about the current [Merchant].
  ///
  /// This method throw [UnauthorizedException] when the `statusCode` is 403,
  /// other wasie throw [TelePayException].
  ///
  /// https://api.telepay.cash/rest/getMe
  Future<Merchant> getMe() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'getMe',
        options: Options(headers: _headers()),
      );
      if (response.statusCode == 200 && response.data != null) {
        final merchantJson =
            response.data!['merchant']! as Map<String, dynamic>;
        return Merchant.fromJson(merchantJson);
      }
    } on DioError catch (e) {
      _handlerError(e);
    }
    throw const TelePayException('Failed to get merchant info');
  }

  /// Get your merchant [Wallet] assets with corresponding balance.
  ///
  /// https://api.telepay.cash/rest/getBalance
  Future<List<Wallet>> getBalance() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'getBalance',
        options: Options(headers: _headers()),
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!['wallets']! as List<dynamic>;
        final wallets = data.cast<Map<String, dynamic>>();

        return wallets.map(Wallet.fromJson).toList();
      }
    } on DioError catch (e) {
      _handlerError(e);
    }
    throw const TelePayException('Failed to get merchant info');
  }


  void _handlerError(DioError e) {
    if (e.response?.statusCode == 403) {
      final data = e.response?.data as Map<String, dynamic>;
      throw UnauthorizedException(
        data['detail'] as String? ?? 'Invalid secret key',
      );
    }
    throw TelePayException(
      'Failed to get balance: \n'
      'STATUS_CODE: ${e.response?.statusCode} \n'
      'RESPONSE: ${e.response?.data}',
    );
  }
}
