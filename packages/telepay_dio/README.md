# telepay_dio

![TelePay Dart](https://github.com/TelePay-cash/telepay-dart/blob/main/docs/cover.jpg?raw=true)

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]   [![pub package][pub_badge]][pub_link]   [![License: MIT][license_badge]][license_link]

[TelePay][telepay_link] client for Dart language, to easily process cryptocurrency payments using http client [Dio](dio_package_link).

## Getting Started

Check the full example [here](https://github.com/telepay-cash/telepay-dart/blob/main/packages/telepay_dio/example/lib/main.dart).

### Install

Add to dependencies on `pubspec.yaml`:

```yaml
dependencies:
    telepay_dio: <version>
```

### Make Your First Request

The first thing is to create an instance of `TelePayDio` for later use, which receives two parameters, your API private key and an instance of Dio.

```dart
  final telepay = TelePayDio(secretApiKey: 'your_secret_api_key', dio: Dio());
```

🚨  **WARNING** 🚨
Your `secretApiKey` is confidential and meant to be used by you. Anyone who has your project key can access your merchant. Please, do not share it or commit it in your code.

#### Methods

##### getMe

Get the current merchant info.

```dart
final me = await telepay.getMe();
```

##### getAssets

Get all the assets suported by TelePay.

```dart
final assets = await telepay.getAssets();
```

##### getBalance

Get the balance of the all your wallets.

```dart
final balance = await telepay.getBalance();
```

##### getInvoices

Get all the invoices the your merchant.

```dart
final invoices = await telepay.getInvoices();
```

##### createInvoice

Creates an invoice, associated to your merchant.

```dart
final invoiceCreate = await telepay.createInvoice(
    const CreateInvoice(
        asset: 'TON',
        blockchain: 'TON',
        network: 'testnet',
        amount: 3.5,
    ),
);
```

##### getInvoice

Get a specific invoice etails, by invoice number.

```dart
final invoice = await telepay.getInvoice('YYXZT1U7Q2P8');
```

##### cancelInvoice

Cancel invoice, by its number.

```dart
final invoiceCancel = await telepay.cancelInvoice('FNGUA7LR6B');
```

##### deleteInvoice

Delete invoice, by its number.

```dart
final isDelete = await telepay.deleteInvoice('FNGUA7LR6BYYY');
```

##### transfer

Create a tranferent between internal wallets, thsi is a off-chain operation

```dart
final transfer = await telepay.transfer(
    const CreateTransfer(
        asset: 'TON',
        blockchain: 'TON',
        network: 'testnet',
        amount: 3.5,
        username: 'yeikel16',
    ),
);
```

##### getWithdrawMinimum

Get minimum fee for a specific asset for withdraw.

```dart
final withdrawMin =
    await telepay.getWithdrawMinimum('TON', 'TON', 'testnet');
```

##### getWithdrawFee

Get estimated withdraw fee, composed of blockchain fee and processing fee.

```dart
final withdrawFee = await telepay.getWithdrawFee(
    const CreateWithdraw(
        asset: 'TON',
        blockchain: 'TON',
        network: 'testnet',
        amount: 5.2,
        toAddress: 'EQAwEl_ExMqFJIjfitPRPTdV_B9KTgHG-YognX6iKRWHdpX1',
    ),
);
```

## Running Tests 🧪

To run all unit tests use the following command:

```sh
dart test --coverage="/coveraga" --test-randomize-ordering-seed random

```

To view the generated coverage report you can use [coverde](https://pub.dev/packages/coverde).

```sh
# Filter the tested files.
coverde filter -f \.g\.dart

# Generate Coverage Report and open in browser.
coverde report -l
```

---

## Bugs or Requests

If you want to [report a problem][github_issue_link] or would like to add a new feature, feel free to open an [issue on GitHub][github_issue_link]. Pull requests are also welcome.

[github_issue_link]: https://github.com/TelePay-cash/telepay-dart/issues
[codecov_link]: https://codecov.io/gh/telepay/telepay-dart
[coverage_badge]: https://codecov.io/gh/telepay/telepay-dart/branch/main/graph/badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[pub_badge]: https://img.shields.io/pub/v/telepay_dio.svg
[pub_link]: https://pub.dartlang.org/packages/telepay_dio
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[telepay_link]: https://telepay.cash
[dio_package_link]: https://pub.dev/packages/dio
