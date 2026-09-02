import 'package:flutter_test/flutter_test.dart';

import 'package:dondelodeje/data/user_session.dart';

void main() {
  setUp(UserSession.instance.reset);

  test('initialFor devuelve la primera letra en mayúscula', () {
    expect(UserSession.initialFor('ismael'), 'I');
    expect(UserSession.initialFor('Ángel'), 'Á');
    expect(UserSession.initialFor(''), '?');
    expect(UserSession.initialFor(null), '?');
  });

  test('completeOnboarding guarda el nombre y marca el onboarding como hecho', () {
    expect(UserSession.instance.hasCompletedOnboarding, isFalse);

    UserSession.instance.completeOnboarding('  Laura  ');

    expect(UserSession.instance.hasCompletedOnboarding, isTrue);
    expect(UserSession.instance.displayName, 'Laura');
    expect(UserSession.instance.initial, 'L');
  });
}
