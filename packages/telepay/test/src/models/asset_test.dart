import 'dart:convert';

import 'package:telepay/src/models/asset.dart';
import 'package:test/test.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  group('Assets', () {
    final assetsResponse =
        jsonDecode(fixture('assets.json')) as Map<String, dynamic>;
    final assetsJson = (assetsResponse['assets'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .first;

    test('fromJson', () {
      expect(Asset.fromJson(assetsJson), isA<Asset>());
    });

    test('toJson', () {
      expect(Asset.fromJson(assetsJson).toJson(), assetsJson);
    });

    test('equeality', () {
      expect(
        Asset.fromJson(assetsJson),
        equals(Asset.fromJson(assetsJson)),
      );
    });
  });
}
