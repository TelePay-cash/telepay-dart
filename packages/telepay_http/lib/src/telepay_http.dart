import 'dart:developer';

import 'package:http/http.dart';
import 'package:telepay/telepay.dart';

import 'package:telepay_http/src/http_extensions.dart';

/// {@template telepay_http}
/// Implementation of the telepay package using classic http client
/// {@endtemplate}
class TelePayHttp implements TelePay {
  /// {@macro telepay_http}
  const TelePayHttp({
    required String secretApiKey,
    required Client httpClient,
  })  : _secretApiKey = secretApiKey,
        _http = httpClient;

  /// API Key for the TelePay API
  final String _secretApiKey;

  final Client _http;

  /// Set headers for the Dio instance
  Map<String, String> get _headers => <String, String>{
        'AUTHORIZATION': _secretApiKey,
        'Accept': 'application/json'
      };

  // Telepay methods

  @override
  Future<Invoice> cancelInvoice(String invoiceNumber) async {
    final response = await _http.telepayPost(
      'cancelInvoice/$invoiceNumber',
      headers: _headers,
    );

    if (response.statusCode == 200 && response.data != null) {
      return Invoice.fromJson(response.data!);
    }

    throw const TelePayException('Failed to cancel invoice.');
  }

  @override
  Future<Invoice> createInvoice(CreateInvoice invoice) async {
    final response = await _http.telepayPost(
      'createInvoice',
      headers: _headers,
      body: invoice.toJson(),
    );

    if (response.statusCode == 201 && response.data != null) {
      return Invoice.fromJson(response.data!);
    }

    throw const TelePayException('Failed to create invoice.');
  }

  @override
  Future<bool> deleteInvoice(String invoiceNumber) async {
    final response = await _http.telepayPost(
      'deleteInvoice/$invoiceNumber',
      headers: _headers,
    );

    if (response.statusCode == 200 && response.data != null) {
      return response.data!['status'] as String == 'deleted';
    }

    throw const TelePayException('Failed to delete invoice.');
  }

  @override
  Future<List<Asset>> getAssets() async {
    final response = await _http.telepayGet('getAssets', headers: _headers);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data!['assets']! as List<dynamic>;
      final assets = data.cast<Map<String, dynamic>>();

      return assets.map(Asset.fromJson).toList();
    }

    throw const TelePayException('Failed to get invoices info');
  }

  @override
  Future<List<Wallet>> getBalance() async {
    final response = await _http.telepayGet('getBalance', headers: _headers);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data!['wallets']! as List<dynamic>;
      final wallets = data.cast<Map<String, dynamic>>();

      return wallets.map(Wallet.fromJson).toList();
    }

    throw const TelePayException('Failed to get balance info');
  }

  @override
  Future<Invoice> getInvoice(String invoiceNumber) async {
    final response = await _http.telepayGet(
      'getInvoice/$invoiceNumber',
      headers: _headers,
    );

    if (response.statusCode == 200 && response.data != null) {
      return Invoice.fromJson(response.data!);
    }

    throw const TelePayException('Failed to get invoices info');
  }

  @override
  Future<List<Invoice>> getInvoices() async {
    final response = await _http.telepayGet('getInvoices', headers: _headers);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data!['invoices']! as List<dynamic>;
      final invoices = data.cast<Map<String, dynamic>>();

      return invoices.map(Invoice.fromJson).toList();
    }

    throw const TelePayException('Failed to get invoices info');
  }

  @override
  Future<Merchant> getMe() async {
    final response = await _http.telepayGet('getMe', headers: _headers);

    if (response.statusCode == 200 && response.data != null) {
      final merchantJson = response.data!['merchant']! as Map<String, dynamic>;

      return Merchant.fromJson(merchantJson);
    }

    throw const TelePayException('Failed to get merchant info');
  }

  @override
  Future<Fee> getWithdrawFee(CreateWithdraw withdraw) async {
    final response = await _http.telepayPost(
      'getWithdrawFee',
      headers: _headers,
      body: withdraw.toJson(),
    );

    if (response.statusCode == 200 && response.data != null) {
      return Fee.fromJson(response.data!);
    }

    throw const TelePayException('Failed to get withdraw fee.');
  }

  @override
  Future<double> getWithdrawMinimum(
    String asset,
    String blockchain, [
    String? network,
  ]) async {
    final response = await _http.telepayPost(
      'getWithdrawMinimum',
      headers: _headers,
      body: <String, dynamic>{
        'asset': asset,
        'blockchain': blockchain,
        'network': network,
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      return response.data!['withdraw_minimum'] as double;
    }

    throw const TelePayException('Failed to get withdraw minimum.');
  }

  @override
  Future<bool> transfer(CreateTransfer transfer) async {
    final response = await _http.telepayPost(
      'transfer',
      headers: _headers,
      body: transfer.toJson(),
    );

    if (response.statusCode == 200 && response.data != null) {
      return response.data!['success'] as bool == true;
    }

    throw const TelePayException('Failed to tranfer.');
  }

  @override
  Future<bool> withdraw(CreateWithdraw withdraw) async {
    final response = await _http.telepayPost(
      'withdraw',
      headers: _headers,
      body: withdraw.toJson(),
    );

    if (response.statusCode == 200 && response.data != null) {
      return response.data!['success'] == true;
    }

    throw const TelePayException('Failed to withdraw.');
  }
}
