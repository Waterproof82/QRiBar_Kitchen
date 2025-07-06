import 'package:flutter_test/flutter_test.dart';
import 'package:qribar_cocina/app/const/app_sizes.dart';

void main() {
  group('AppSizes', () {
    test('should have correct padding sizes', () {
      expect(AppSizes.p4, 4.0);
      expect(AppSizes.p8, 8.0);
    });
  });

  group('Gap', () {
    testWidgets('should create SizedBox with correct heights', (
      WidgetTester tester,
    ) async {
      expect(Gap.h4.height, AppSizes.p4);
      expect(Gap.h8.height, AppSizes.p8);
    });

    testWidgets('should create SizedBox with correct widths', (
      WidgetTester tester,
    ) async {
      expect(Gap.w4.width, AppSizes.p4);
      expect(Gap.w8.width, AppSizes.p8);
    });
  });
}
