import 'dart:convert';

import 'package:telepay/src/models/merchant.dart';
import 'package:test/test.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  group('Merchant', () {
    final merchantString =
        jsonDecode(fixture('merchant.json')) as Map<String, dynamic>;
    final merchantJson = merchantString['merchant'] as Map<String, dynamic>;

    test('fromJson', () {
      expect(Merchant.fromJson(merchantJson), isA<Merchant>());
    });

    test('toJson', () {
      expect(Merchant.fromJson(merchantJson).toJson(), merchantJson);
    });

    test('equeality', () {
      expect(
        Merchant.fromJson(merchantJson),
        equals(Merchant.fromJson(merchantJson)),
      );
    });
  });
}
