import 'dart:convert';

import 'package:telepay/src/models/wallet.dart';
import 'package:test/test.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  group('Wallet', () {
    final invoicesResponse =
        jsonDecode(fixture('wallets.json')) as Map<String, dynamic>;
    final invoicesJson = (invoicesResponse['wallets'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .first;

    test('fromJson', () {
      expect(Wallet.fromJson(invoicesJson), isA<Wallet>());
    });

    test('toJson', () {
      expect(Wallet.fromJson(invoicesJson).toJson(), invoicesJson);
    });

    test('equeality', () {
      expect(
        Wallet.fromJson(invoicesJson),
        equals(Wallet.fromJson(invoicesJson)),
      );
    });
  });
}
