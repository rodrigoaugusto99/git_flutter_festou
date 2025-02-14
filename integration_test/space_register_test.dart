import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:festou/main.dart';
import 'package:festou/src/helpers/keys.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'test_utils.dart';

void main() {
  tearDown(() async {});
  patrolWidgetTest(
      config: const PatrolTesterConfig(
          visibleTimeout: Duration(seconds: 30),
          settleTimeout: Duration(seconds: 30)),
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

    await $(Keys.kSignatureConfirmButton).tap();
    await $(Keys.kLocadorFormEnviarButton).tap();
    await $(Keys.kLocadorViewRegisterSpace).tap();
    await $(Keys.kFirstScreenButton).tap();
    await $(Keys.kChipWidget).tap();
    await $(Keys.kSecondScreenButton).tap();

    await $(Keys.kTextFormField).waitUntilExists();
    await $(Keys.kTextFormField).at(0).enterText('22221000');
    await Future.delayed(const Duration(seconds: 1));
    await $(Keys.kTextFormField).at(2).enterText('123');
    await $(Keys.k3creenButton).tap();
    await $(Keys.kChipWidget).tap();
    await $(Keys.k4ScreenButton).tap();
    await $(Keys.k5creenButton).tap();
    await $(Keys.kTextFormField).waitUntilExists();
    final name = DateTime.now().millisecondsSinceEpoch.toString();
    final descricao = DateTime.now().millisecondsSinceEpoch.toString();

    await $(Keys.kTextFormField).enterText(name);
    await $(Keys.k6ScreenButton).tap();
    await $(Keys.kTextFormField).waitUntilExists();
    await $(Keys.kTextFormField).enterText(descricao);
    await $(Keys.k7ScreenButton).tap();
    await $(Keys.kTextFormField).waitUntilExists();
    await $(Keys.kTextFormField).enterText('123123');
    await $(Keys.k8creenButton).tap();

    await $(Keys.kSelectDayIndex(0)).tap();
    await $(Keys.kSelectDayIndex(1)).tap();
    await $(Keys.k9ScreenButton).tap();
    await $(Keys.k10ScreenButton).scrollTo().tap();
    await Future.delayed(const Duration(seconds: 10));

    //verificando se o espaco foi criado
    final spaces = await getSpaceOnFirestore(userId);
    expect(spaces.length, 1);
    final space = spaces.first;
    expect(space.titulo, name);
    expect(space.descricao, descricao);
    expect(space.selectedServices.length, 1);
    expect(space.selectedServices.contains('Cozinha'), true);
    expect(space.selectedTypes.length, 1);
    expect(space.selectedTypes.contains('Kids'), true);
    expect(space.days.friday, null);
    expect(space.days.saturday, null);
    expect(space.days.sunday, null);
    expect(space.days.thursday, null);
    expect(space.days.wednesday, null);
    expect(space.days.monday, isNotNull);
    expect(space.days.tuesday, isNotNull);
  });
}
