import 'dart:convert';

import 'package:telepay/src/models/models.dart';
import 'package:test/test.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  group('CreateInvoice', () {
    final invoicesJson =
        jsonDecode(fixture('create_invoice.json')) as Map<String, dynamic>;

    test('fromJson', () {
      expect(CreateInvoice.fromJson(invoicesJson), isA<CreateInvoice>());
    });

    test('toJson', () {
      expect(CreateInvoice.fromJson(invoicesJson).toJson(), invoicesJson);
    });

    test('equeality', () {
      expect(
        CreateInvoice.fromJson(invoicesJson),
        equals(CreateInvoice.fromJson(invoicesJson)),
      );
    });
  });
}
