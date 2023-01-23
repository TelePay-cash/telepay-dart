# Dart SDK for the TelePay API

![TelePay Dart](https://github.com/TelePay-cash/telepay-dart/blob/main/docs/cover.png?raw=true)

TelePay client library for the Dart language, so you can easely process cryptocurrency payments using the REST API.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Last commit](https://img.shields.io/github/last-commit/telepay-cash/telepay-dart.svg?style=flat-square)](https://github.com/telepay-cash/telepay-dart/commits)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/telepay-cash/telepay-dart?style=flat-square)](https://github.com/telepay-cash/telepay-dart/commits)
[![Github Stars](https://img.shields.io/github/stars/telepay-cash/telepay-dart?style=flat-square&logo=github&)](https://github.com/telepay-cash/telepay-dart/stargazers)
[![Github Forks](https://img.shields.io/github/forks/telepay-cash/telepay-dart?style=flat-square&logo=github)](https://github.com/telepay-cash/telepay-dart/network/members)
[![Github Watchers](https://img.shields.io/github/watchers/telepay-cash/telepay-dart?style=flat-square&logo=github)](https://github.com/telepay-cash/telepay-dart)
[![GitHub contributors](https://img.shields.io/github/contributors/telepay-cash/telepay-dart?label=code%20contributors&style=flat-square)](https://github.com/telepay-cash/telepay-dart/graphs/contributors)
[![Telegram](https://img.shields.io/badge/Telegram-2CA5E0?style=flat-squeare&logo=telegram&logoColor=white)](https://t.me/TelePayCash)
[![Blog](https://img.shields.io/badge/RSS-FFA500?style=flat-square&logo=rss&logoColor=white)](https://blog.telepay.cash)

| Package                                                                                    | Pub                                                                                                                  |
| ------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------- |
|[telepay][telepay_github_link]|[![pub package][pub_badge_telepay]][pub_link_telepay]|
|[telepay_dio][telepay_github_link]|[![pub package][pub_badge_telepay_dio]][pub_link_telepay_dio]|
|[telepay_http][telepay_github_link]|[![pub package][pub_badge_telepay_http]][pub_link_telepay_http]|
|telepay_hooks|(Coming soon)|

## Index

* WebHooks (Coming soon)
* [All Metods](https://github.com/telepay-cash/telepay-dart/#Methods)
  * [getMe](https://github.com/telepay-cash/telepay-dart/#getMe)
  * [getAssets](https://github.com/telepay-cash/telepay-dart/#getAssets)
  * [getBalance](https://github.com/telepay-cash/telepay-dart/#getBalance)
  * [getInvoice](https://github.com/telepay-cash/telepay-dart/#getInvoice)
  * [getInvoices](https://github.com/telepay-cash/telepay-dart/#getInvoices)
  * [createInvoice](https://github.com/telepay-cash/telepay-dart/#createInvoice)
  * [cancelInvoice](https://github.com/telepay-cash/telepay-dart/#cancelInvoice)
  * [deleteInvoice](https://github.com/telepay-cash/telepay-dart/#deleteInvoice)
  * [transfer](https://github.com/telepay-cash/telepay-dart/#transfer)
  * [getWithdrawMinimum](https://github.com/telepay-cash/telepay-dart/#getWithdrawMinimum)
  * [getWithdrawFee](https://github.com/telepay-cash/telepay-dart/#getWithdrawFee)
  * [withdraw](https://github.com/telepay-cash/telepay-dart/#withdraw)

## Installation

Add to dependencies on `pubspec.yaml`:

```yaml
dependencies:
    telepay_dio: <version>
```

### Using the library

The first thing is to create an instance of `TelePayDio` for later use, which receives two parameters, your secret API key and an instance of Dio.

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

##### withdraw

Withdraw funds to a specific address

```dart
    final withdraw = await telepay.withdraw(
      const CreateWithdraw(
        asset: 'TON',
        blockchain: 'TON',
        network: 'testnet',
        amount: 5.2,
        toAddress: 'EQAwEl_ExMqFJIjfitPRPTdV_B9KTgHG-YognX6iKRWHdpX1',
      ),
    );
```

## Tests

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

## Bugs or Requests

If you want to [report a problem][github_issue_link] or would like to add a new feature, feel free to open an [issue on GitHub][github_issue_link]. Pull requests are also welcome.

## Contributors ✨

The library is made by ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/yeikel16"><img src="https://avatars.githubusercontent.com/u/26438532?v=4" width="100px;" alt=""/><br /><sub><b>Yeikel Uriarte Arteaga</b></sub></a><br /><a href="https://github.com/TelePay-cash/telepay-dart/commits?author=yeikel16" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/luiscib3r"><img src="https://avatars.githubusercontent.com/u/32603705?v=4" width="100px;" alt=""/><br /><sub><b>Luis Antonio Correa Leyva </b></sub></a><br /><a href="https://github.com/TelePay-cash/telepay-dart/commits?author=luiscib3r" title="Code">💻</a></td>
    <td align="center"><a href="https://carloslugones.com"><img src="https://avatars.githubusercontent.com/u/18733370?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Carlos Lugones</b></sub></a><br /><a href="https://github.com/telepay-cash/telepay-dart/commits?author=CarlosLugones" title="Mentoring">🧑‍🏫</a></td>
  </tr>
</table>
<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

[github_issue_link]: https://github.com/TelePay-cash/telepay-dart/issues
[pub_badge_telepay]: https://img.shields.io/pub/v/telepay.svg
[pub_link_telepay]: https://pub.dartlang.org/packages/telepay
[pub_badge_telepay_dio]: https://img.shields.io/pub/v/telepay_dio.svg
[pub_link_telepay_dio]: https://pub.dartlang.org/packages/telepay_dio
[pub_badge_telepay_http]: https://img.shields.io/pub/v/telepay_http.svg
[pub_link_telepay_http]: https://pub.dartlang.org/packages/telepay_http
[telepay_dart_github_link]: https://github.com/telepay-cash/telepay-dart/
[telepay_github_link]: https://github.com/telepay-cash/telepay-dart/tree/main/packages/telepay
