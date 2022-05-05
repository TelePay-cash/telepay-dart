import 'package:dio/dio.dart';
import 'package:telepay/telepay.dart';

/// {@template telepay_dio}
/// Implementation of the telepay package using Dio http client
/// {@endtemplate}
class TelePayDio implements TelePay {
  /// {@macro telepay_dio}
  TelePayDio({
    required String secretApiKey,
    required Dio dio,
  })  : _secretApiKey = secretApiKey,
        _dio = dio {
    _dio.options = BaseOptions(baseUrl: TelePay.baseUrl);
  }

  /// API Key for the TelePay API
  final String _secretApiKey;

  final Dio _dio;

  /// Set headers for the Dio instance
  Map<String, String> get _headers => <String, String>{
        'AUTHORIZATION': _secretApiKey,
        'Accept': 'application/json'
      };

  @override
  Future<Merchant> getMe() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'getMe',
        options: Options(headers: _headers),
      );
      if (response.statusCode == 200 && response.data != null) {
        final merchantJson =
            response.data!['merchant']! as Map<String, dynamic>;
        return Merchant.fromJson(merchantJson);
      }
    } on DioError catch (e) {
      _handlerError(e, 'get Me');
    }
    throw const TelePayException('Failed to get merchant info');
  }

  @override
  Future<List<Wallet>> getBalance() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'getBalance',
        options: Options(headers: _headers),
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!['wallets']! as List<dynamic>;
        final wallets = data.cast<Map<String, dynamic>>();

        return wallets.map(Wallet.fromJson).toList();
      }
    } on DioError catch (e) {
      _handlerError(e, 'get balance');
    }
    throw const TelePayException('Failed to get balance info');
  }

  @override
  Future<List<Invoice>> getInvoices() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'getInvoices',
        options: Options(headers: _headers),
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!['invoices']! as List<dynamic>;
        final invoices = data.cast<Map<String, dynamic>>();

        return invoices.map(Invoice.fromJson).toList();
      }
    } on DioError catch (e) {
      _handlerError(e, 'get invoices');
    }
    throw const TelePayException('Failed to get invoices info');
  }

  @override
  Future<Invoice> getInvoice(String invoiceNumber) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'getInvoice/$invoiceNumber',
        options: Options(headers: _headers),
      );
      if (response.statusCode == 200 && response.data != null) {
        return Invoice.fromJson(response.data!);
      }
    } on DioError catch (e) {
      _handlerError(e, 'get invoice');
    }
    throw const TelePayException('Failed to get invoice info');
  }

  @override
  Future<List<Asset>> getAssets() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'getAssets',
        options: Options(headers: _headers),
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!['assets']! as List<dynamic>;
        final assets = data.cast<Map<String, dynamic>>();

        return assets.map(Asset.fromJson).toList();
      }
    } on DioError catch (e) {
      _handlerError(e, 'get assets');
    }
    throw const TelePayException('Failed to get assets info');
  }

  void _handlerError(DioError e, [String? method]) {
    if (e.response?.statusCode == 403) {
      final data = e.response?.data as Map<String, dynamic>;
      throw UnauthorizedException(
        data['detail'] as String? ?? 'Invalid secret key',
      );
    } else if (e.response?.statusCode == 404 || e.response?.statusCode == 401) {
      final data = e.response?.data as Map<String, dynamic>;
      if (data.containsKey('error')) {
        if (data['error'] as String == 'insufficient-funds') {
          throw InsufficienttFondsException(
            data['message'] as String? ?? data['error'] as String,
          );
        }
        throw NotFoundException(
          data['message'] as String? ?? data['error'] as String,
        );
      }
    }
    throw TelePayException(
      'Failed to $method: \n'
      'STATUS_CODE: ${e.response?.statusCode} \n'
      'RESPONSE: ${e.response?.data}',
    );
  }

  @override
  Future<Invoice> cancelInvoice(String invoiceNumber) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'cancelInvoice/$invoiceNumber',
        options: Options(headers: _headers),
      );
      if (response.statusCode == 200 && response.data != null) {
        return Invoice.fromJson(response.data!);
      }
    } on DioError catch (e) {
      _handlerError(e, 'cancel invoice');
    }
    throw const TelePayException('Failed to cancel invoice.');
  }

  @override
  Future<Invoice> createInvoice(CreateInvoice invoice) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'createInvoice',
        data: invoice.toJson(),
        options: Options(headers: _headers),
      );
      if (response.statusCode == 201 && response.data != null) {
        return Invoice.fromJson(response.data!);
      }
    } on DioError catch (e) {
      _handlerError(e, 'create invoice');
    }
    throw const TelePayException('Failed to create invoice.');
  }

  @override
  Future<bool> deleteInvoice(String invoiceNumber) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'deleteInvoice/$invoiceNumber',
        options: Options(headers: _headers),
      );
      if (response.statusCode == 200 && response.data != null) {
        return response.data!['status'] as String == 'deleted';
      }
    } on DioError catch (e) {
      _handlerError(e, 'delete invoice');
    }
    throw const TelePayException('Failed to delete invoice.');
  }

  @override
  Future<bool> transfer(CreateTransfer transfer) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'transfer',
        data: transfer.toJson(),
        options: Options(
          headers: _headers,
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        return response.data!['success'] as bool == true;
      }
    } on DioError catch (e) {
      _handlerError(e, 'transfer');
    }
    throw const TelePayException('Failed to tranfer.');
  }

  @override
  Future<Fee> getWithdrawFee(CreateWithdraw withdraw) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'getWithdrawFee',
        data: withdraw.toJson(),
        options: Options(headers: _headers),
      );
      if (response.statusCode == 200 && response.data != null) {
        return Fee.fromJson(response.data!);
      }
    } on DioError catch (e) {
      _handlerError(e, 'get withdraw fee');
    }
    throw const TelePayException('Failed to get withdraw fee.');
  }

  @override
  Future<double> getWithdrawMinimum(
    String asset,
    String blockchain, [
    String? network,
  ]) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'getWithdrawMinimum',
        data: <String, dynamic>{
          'asset': asset,
          'blockchain': blockchain,
          'network': network,
        },
        options: Options(headers: _headers),
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data!['withdraw_minimum'] as double;
      }
    } on DioError catch (e) {
      _handlerError(e, 'get withdraw minimum');
    }
    throw const TelePayException('Failed to get withdraw minimum.');
  }

  @override
  Future<bool> withdraw(CreateWithdraw withdraw) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'withdraw',
        data: withdraw.toJson(),
        options: Options(headers: _headers),
      );
      if (response.statusCode == 200 && response.data != null) {
        return response.data!['success'] == true;
      }
    } on DioError catch (e) {
      _handlerError(e, 'withdraw');
    }
    throw const TelePayException('Failed to withdraw.');
  }
}
