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
  /// Throw [UnauthorizedException] when the secret key is invalid,
  /// otherwise it throws exception [TelePayException] with any other error.
  Future<Merchant> getMe();

  /// Get your merchant [Wallet] assets with corresponding balance.
  ///
  /// Throw [UnauthorizedException] when the secret key is invalid,
  /// otherwise it throws exception [TelePayException] with any other error.
  Future<List<Wallet>> getBalance();

  /// Get assets suported by TelePay.
  ///
  /// Throw [UnauthorizedException] when the secret key is invalid,
  /// otherwise it throws exception [TelePayException] with any other error.
  Future<List<Asset>> getAssets();

  /// Get your merchant invoices.
  ///
  /// Throw [UnauthorizedException] when the secret key is invalid,
  /// otherwise it throws exception [TelePayException] with any other error.
  Future<List<Invoice>> getInvoices();

  /// Get invoice details, by ID.
  ///
  /// Throw [UnauthorizedException] when the secret key is invalid.
  /// Throw [NotFoundException] when no match was found
  /// with the `invoiceNumber`.
  /// It throws exception [TelePayException] with any other error.
  Future<Invoice> getInvoice(String invoiceNumber);

  /// Creates an invoice, associated to your merchant.
  ///
  /// Throw [UnauthorizedException] when the secret key is invalid,
  /// otherwise it throws exception [TelePayException] with any other error.
  Future<Invoice> createInvoice(CreateInvoice invoice);

  /// Cancel invoice, by its number.
  ///
  /// Throw [UnauthorizedException] when the secret key is invalid.
  /// Throw [NotFoundException] when no match was found
  /// with the `invoiceNumber`.
  /// It throws exception [TelePayException] with any other error.
  Future<Invoice> cancelInvoice(String invoiceNumber);

  /// Delete invoice, by its number.
  ///
  /// Throw [UnauthorizedException] when the secret key is invalid.
  /// Throw [NotFoundException] when no match was found
  /// with the `invoiceNumber`.
  /// It throws exception [TelePayException] with any other error.
  Future<bool> deleteInvoice(String invoiceNumber);

  /// Transfer funds between internal wallets. Off-chain operation.
  ///
  /// Throw [UnauthorizedException] when the secret key is invalid.
  /// Throw [NotFoundException] when merchant or user does not exist.
  /// It throws exception [TelePayException] with any other error.
  Future<bool> transfer(CreateTransfer transfer);

  /// Obtains minimum amount required to withdraw funds on a given asset.
  ///
  /// Throw [UnauthorizedException] when the secret key is invalid.
  /// Throw [NotFoundException] when the asset was not found.
  /// It throws exception [TelePayException] with any other error.
  Future<double> getWithdrawMinimum(
    String asset,
    String blockchain, [
    String? network,
  ]);

  /// Get estimated withdraw fee, composed of blockchain fee and processing fee.
  ///
  /// Throw [UnauthorizedException] when the secret key is invalid.
  /// Throw [NotFoundException] when the asset was not found.
  /// It throws exception [TelePayException] with any other error.
  Future<Fee> getWithdrawFee(CreateWithdraw withdraw);

  /// Withdraw funds from merchant wallet to external wallet.
  ///
  /// Throw [UnauthorizedException] when the secret key is invalid.
  /// Throw [NotFoundException] when the asset was not found.
  /// Throw [InsufficienttFondsException] when not have suficient founds.
  /// It throws exception [TelePayException] with any other error.
  Future<bool> withdraw(CreateWithdraw withdraw);
}
