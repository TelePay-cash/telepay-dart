import 'package:telepay/src/exceptions/exceptions.dart';
import 'package:telepay/src/models/models.dart';

/// {@template telepay}
/// Dart API Client wich wraps the TelePay API
/// {@endtemplate}
abstract class TelePay {
  /// {@macro telepay}
  const TelePay();

  /// Base URL for the [TelePay API](https://telepay.readme.io)
  static const String baseUrl = 'https://api.telepay.cash/rest/';

  /// Info about the current [Merchant].
  ///
  /// Throw [UnauthorizedException] when the `statusCode` is 403,
  /// other wasie throw [TelePayException].
  Future<Merchant> getMe();

  /// Get your merchant [Wallet] assets with corresponding balance.
  Future<List<Wallet>> getBalance();

  /// Get assets suported by TelePay.
  Future<List<Asset>> getAssets();

  /// Get your merchant invoices.
  Future<List<Invoice>> getInvoices();

  /// Get invoice details, by ID.
  Future<Invoice> getInvoice(String invoiceNumber);

  /// Creates an invoice, associated to your merchant.
  Future<Invoice> createInvoice(CreateInvoice invoice);

  /// Cancel invoice, by its number
  Future<Invoice> cancelInvoice(String invoiceNumber);

  /// Delete invoice, by its number.
  Future<bool> deleteInvoice(String invoiceNumber);

  /// Transfer funds between internal wallets. Off-chain operation.
  Future<bool> transfer({required CreateTransfer transfer});

  /// Obtains minimum amount required to withdraw funds on a given asset
  Future<double> getWithdrawMinimum(
    String asset,
    String blockchain, [
    String? network,
  ]);

  /// Get estimated withdraw fee, composed of blockchain fee and processing fee.
  Future<Fee> getWithdrawFee({
    required String asset,
    required String blockchain,
    required String network,
  });

  /// Withdraw funds from merchant wallet to external wallet.
  Future<bool> withdraw({required CreateWithdraw withdraw});
}
