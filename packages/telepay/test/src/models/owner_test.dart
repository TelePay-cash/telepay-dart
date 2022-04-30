import 'package:telepay/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Owner', () {
    const ownerJson = {
      'first_name': 'Yeikel',
      'last_name': 'Uriarte',
      'username': 'yeikel'
    };
    test('fromJson', () {
      expect(Owner.fromJson(ownerJson), isA<Owner>());
    });

    test('toJson', () {
      expect(Owner.fromJson(ownerJson).toJson(), ownerJson);
    });

    test('equality', () {
      expect(
        Owner.fromJson(ownerJson),
        equals(Owner.fromJson(ownerJson)),
      );
    });
  });
}
