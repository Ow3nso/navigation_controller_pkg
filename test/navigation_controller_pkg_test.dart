import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () {
    int one = 1;
    int two = one + one;
    expect(one + two, 3);
  });
}
