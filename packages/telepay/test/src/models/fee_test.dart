import 'package:telepay/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Fee', () {
    final feeJson = <String, dynamic>{
      'blockchain_fee': 0.001784,
      'processing_fee': 0.05,
      'total': 0.051784
    };

    test('fromJson', () {
      expect(Fee.fromJson(feeJson), isA<Fee>());
    });

    test('toJson', () {
      expect(Fee.fromJson(feeJson).toJson(), feeJson);
    });

    test('equeality', () {
      expect(
        Fee.fromJson(feeJson),
        equals(Fee.fromJson(feeJson)),
      );
    });
  });
}
