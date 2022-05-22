// ignore_for_file: avoid_print

import 'package:http/http.dart';
import 'package:telepay_http/telepay_http.dart';

const secretApiKey = 'you_secret_api_key';

Future<void> main(List<String> args) async {
  final telepay = TelePayHttp(
    secretApiKey: secretApiKey,
    httpClient: Client(),
  );

  try {
    // Get the current merchant info.
    final me = await telepay.getMe();
    print(me);

    // Get all the assets suported by TelePay.
    final asset = await telepay.getAssets();
    print(asset);

    // Get the balance of the all your wallets.
    final balance = await telepay.getBalance();
    print(balance);

    // Get all the invoices the your merchant.
    final invoices = await telepay.getInvoices();
    print(invoices);

    // Creates an invoice, associated to your merchant.
    final invoiceCreate = await telepay.createInvoice(
      const CreateInvoice(
        asset: 'TON',
        blockchain: 'TON',
        network: 'testnet',
        amount: 3.5,
      ),
    );
    print(invoiceCreate.number);

    // Get a specific invoice etails, by invoice number.
    final invoice = await telepay.getInvoice(invoiceCreate.number);
    print(invoice);

    // Cancel invoice, by its number.
    final invoiceCancel = await telepay.cancelInvoice(invoice.number);
    print(invoiceCancel);

    // Delete invoice, by its number.
    final isDelete = await telepay.deleteInvoice(invoiceCancel.number);
    print(isDelete);

    // Create a tranferent between internal wallets,
    // thsi is a off-chain operation
    final transfer = await telepay.transfer(
      const CreateTransfer(
        asset: 'TON',
        blockchain: 'TON',
        network: 'testnet',
        amount: 3.5,
        username: 'yeikel16',
      ),
    );
    print(transfer);

    // Get minimum fee for a specific asset for withdraw.
    final withdrawMin =
        await telepay.getWithdrawMinimum('TON', 'TON', 'testnet');
    print(withdrawMin);

    // Get estimated withdraw fee, composed of blockchain fee
    // and processing fee.
    final withdrawFee = await telepay.getWithdrawFee(
      const CreateWithdraw(
        asset: 'TON',
        blockchain: 'TON',
        network: 'testnet',
        amount: 5.2,
        toAddress: 'EQAwEl_ExMqFJIjfitPRPTdV_B9KTgHG-YognX6iKRWHdpX1',
      ),
    );
    print(withdrawFee);

    // Withdraw funds to a specific address.
    final withdraw = await telepay.withdraw(
      const CreateWithdraw(
        asset: 'TON',
        blockchain: 'TON',
        network: 'testnet',
        amount: 5.2,
        toAddress: 'EQAwEl_ExMqFJIjfitPRPTdV_B9KTgHG-YognX6iKRWHdpX1',
      ),
    );
    print(withdraw);
  } on TelePayException catch (e) {
    print(e.toString());
  }
}
