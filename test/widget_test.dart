import 'package:flutter_test/flutter_test.dart';
import 'package:testing_app_brief/theme/app_theme.dart';

void main() {
  test('App theme is configured for Material 3', () {
    final theme = AppTheme.light();

    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.primary, AppColors.brand);
  });
}
