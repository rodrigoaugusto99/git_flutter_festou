import 'package:flutter_test/flutter_test.dart';
import 'package:git_flutter_festou/main.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register.dart';
import 'package:git_flutter_festou/src/helpers/keys.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'test_utils.dart';

void main() {
  tearDown(() async {});
  patrolWidgetTest('should edit task correctly', ($) async {
    await setupMain();
    final userId = await createUserAuth();

    await $.pumpWidgetAndSettle(const NewSpaceRegister());
    await $(Keys.kHomeViewProfile).tap();
    await $(Keys.kProfileViewLocador).tap();
    await $(Keys.kDialogConfirm).tap();

    await $(Keys.kTextFormField).at(1).enterText('143.655.037-82');
    await $(Keys.kTextFormField).at(1).enterText('96.134.301/0001-87');
    await $(Keys.kTextFormField).at(1).enterText('nome da empresa');
    // await $(Keys.kSignaturePaint).at(1).enterText('nome da empresa');
    // Simula um desenho na tela
    const Offset start = Offset(50, 50);
    const Offset end = Offset(200, 200);

    await Future.delayed(const Duration(seconds: 1));
    await $.tester.dragFrom(start, end);
    await $.pump();
  });
}
