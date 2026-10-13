import 'package:flutter_test/flutter_test.dart';
import 'package:music4_mobile/features/artist_profile/presentation/utils/count_format.dart';

void main() {
  group('[CE190284] formatCount', () {
    test('small numbers are shown as they are', () {
      expect(formatCount(0), '0');
      expect(formatCount(19), '19');
      expect(formatCount(999), '999');
    });

    test('thousands use K and drop a useless .0', () {
      expect(formatCount(1000), '1K');
      expect(formatCount(1200), '1.2K');
      expect(formatCount(12500), '12.5K');
    });

    test('millions use M', () {
      expect(formatCount(1000000), '1M');
      expect(formatCount(2500000), '2.5M');
    });
  });
}
