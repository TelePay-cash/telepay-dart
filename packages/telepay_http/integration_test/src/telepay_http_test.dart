// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:telepay_http/telepay_http.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements Client {}

extension StringX on String {
  Uri get uri => Uri.parse('${TelePay.baseUrl}$this');
}

extension MapX on Map<String, dynamic> {
  List<int> get encode => utf8.encode(json.encode(this));
}

void main() {
  late final MockClient client;
  late final TelePayHttp telepay;

  setUp(() {
    final credentials =
        File('integration_test/credentials.txt').readAsStringSync();

    client = MockClient();
    telepay = TelePayHttp(
      secretApiKey: credentials,
      httpClient: client,
    );
  });

  group('TelePayHttp', () {
    test('getMe', () async {
      final response = await telepay.getMe();

      log(response.toString());
    });

    test('getBalance', () async {
      final response = await telepay.getBalance();

      log(response.toString());
    });

    test(
      'getInvoices',
      () async {
        final response = await telepay.getInvoices();

        log(response.toString());
      },
    );

    test(
      'getAssets',
      () async {
        final response = await telepay.getAssets();

        for (final asset in response) {
          log(asset.toString());
        }
      },
    );

    test(
      'createInvoice',
      () async {
        final response = await telepay.createInvoice(
          CreateInvoice(
            asset: 'HIVE',
            blockchain: 'HIVE',
            network: null,
            amount: 5,
          ),
        );

        log(response.toString());
      },
    );

    test(
      'cancelInvoice',
      () async {
        final response = await telepay.cancelInvoice('CAKGXSA4X4');

        log(response.toString());
      },
    );

    test(
      'deleteInvoice',
      () async {
        final response = await telepay.deleteInvoice('CAKGXSA4X4');

        log(response.toString());
      },
    );

    test(
      'withdraw',
      () async {
        final response = await telepay.withdraw(
          CreateWithdraw(
            asset: 'HIVE',
            blockchain: 'HIVE',
            network: null,
            amount: 5,
            toAddress: 'luisciber',
          ),
        );

        log(response.toString());
      },
    );

    test(
      'getWithdrawMinimum HIVE',
      () async {
        final response = await telepay.getWithdrawMinimum('HIVE', 'HIVE');

        log(response.toString());
      },
    );

    test(
      'getWithdrawMinimum TON Mainnet',
      () async {
        final response = await telepay.getWithdrawMinimum(
          'TON',
          'TON',
          'mainnet',
        );

        log(response.toString());
      },
    );

    test(
      'getWithdrawMinimum TON Testnet',
      () async {
        final response = await telepay.getWithdrawMinimum(
          'TON',
          'TON',
          'testnet',
        );

        log(response.toString());
      },
    );

    test(
      'getWithdrawFee HIVE',
      () async {
        final response = await telepay.getWithdrawFee(
          CreateWithdraw(
            asset: 'HIVE',
            blockchain: 'HIVE',
            network: null,
            amount: 5,
            toAddress: 'luisciber',
          ),
        );

        log(response.toString());
      },
    );
  });
}
