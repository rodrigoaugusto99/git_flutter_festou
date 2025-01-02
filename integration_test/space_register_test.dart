import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_flutter_festou/main.dart';
import 'package:git_flutter_festou/src/features/register/space/space%20temporary/pages/new_space_register.dart';
import 'package:git_flutter_festou/src/helpers/keys.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'test_utils.dart';

void main() {
  tearDown(() async {});
  patrolWidgetTest(
      config: const PatrolTesterConfig(
          visibleTimeout: Duration(seconds: 30),
          settleTimeout: Duration(seconds: 30)),
      // timeout: const Timeout(Duration(seconds: 100)),
      'should edit task correctly', ($) async {
    await setupMain();
    final userId = await createUserAuth();
    await createUserOnFirestore(userId!);

    await $.pumpWidgetAndSettle(const ProviderScope(child: MyApp()));
    // await $(Keys.kHomeViewProfile).tap();
    await $(Keys.kProfileViewLocador).tap();
    await $(Keys.kDialogConfirm).tap();

    await $(Keys.kTextFormField).waitUntilExists();
    await $(Keys.kTextFormField).at(0).enterText('143.655.037-82');
    await $(Keys.kTextFormField).at(1).enterText('nome da empresa');
    await $(Keys.kTextFormField).at(2).enterText('96.134.301/0001-87');

    await $(Keys.kSignaturePaint).tap();
    await Future.delayed(const Duration(seconds: 1));
    final drawArea =
        find.byKey(Keys.kSignaturePaper); // Substitua pelo tipo correto
    final rect = $.tester.getRect(drawArea);

    // final center = rect.center;
    // const offset = 50.0;
    // final start = Offset(center.dx - offset, center.dy - offset);
    // final middle = Offset(center.dx, center.dy);
    // final end = Offset(center.dx + offset, center.dy + offset);
    final center = rect.center;
    const offset = 10.0;
    final start = Offset(center.dx - offset, center.dy - offset);
    // final start = Offset(center.dx,
    //     center.dy - rect.height / 4); // Ajusta para o centro superior
    final middle = Offset(center.dx + offset, center.dy);
    final end = Offset(center.dx - offset, center.dy + rect.height / 4);

    final gesture = await $.tester.startGesture(start);
    await gesture.moveTo(middle);
    await gesture.moveTo(end);
    await gesture.up();
    await Future.delayed(const Duration(seconds: 1));
    await $.pump();
    await Future.delayed(const Duration(seconds: 1));
    // await $.tester.dragFrom(start, middle);
    // await $.tester.dragFrom(middle, end);
    await $.pump();

    await Future.delayed(const Duration(seconds: 2));
  });
}
