import 'dart:convert';

import 'package:telepay/src/models/invoice.dart';
import 'package:test/test.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  group('Invoice', () {
    final invoicesResponse =
        jsonDecode(fixture('invoices.json')) as Map<String, dynamic>;
    final invoicesJson = (invoicesResponse['invoices'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .first;

    test('fromJson', () {
      expect(Invoice.fromJson(invoicesJson), isA<Invoice>());
    });

    test('toJson', () {
      expect(Invoice.fromJson(invoicesJson).toJson(), invoicesJson);
    });

    test('equeality', () {
      expect(
        Invoice.fromJson(invoicesJson),
        equals(Invoice.fromJson(invoicesJson)),
      );
    });
  });
}
