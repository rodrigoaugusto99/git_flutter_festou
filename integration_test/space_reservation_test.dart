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
        settleTimeout: Duration(seconds: 30),
      ),
      'should reserve space', ($) async {
    await setupMain();
    final locadorId = await createUserAuth();
    await createUserOnFirestore(locadorId!);
    final locatarioId = await createUserAuth();
    await createUserOnFirestore(
      locatarioId!,
      isLocatario: true,
      email: 'rodrigoaugusto51@outlook.com',
    );
    await createSpaceOnFirestore(locadorId);

    await $.pumpWidgetAndSettle(const ProviderScope(child: MyApp()));

    // Login com usuário locatário
    // await $(Keys.kLoginViewEmail).waitUntilExists();
    // await $(Keys.kLoginViewEmail).enterText('rodrigoaugusto51@outlook.com');
    // await $(Keys.kLoginViewPassword).enterText('22222');
    // await $(Keys.kLoginViewButton).tap();

    // Aguarda o scaffold da home ficar visível
    await $(Keys.kHomeScaffold).waitUntilVisible();

    // Clica no tipo de espaço "Casamento"
    await $(Keys.kSpaceTypeCasamento).tap();

    // Aguarda e clica no espaço criado
    await $(Keys.kSpaceCard).at(0).waitUntilVisible();
    await Future.delayed(const Duration(seconds: 2));
    await $(Keys.kSpaceCard).at(0).tap();

    // Clica no botão "Alugar"
    await $(Keys.kAlugarButton).waitUntilVisible();
    await $(Keys.kAlugarButton).tap();

    // Aguarda a animação do calendário
    await Future.delayed(const Duration(seconds: 3));

    // Clica no dia 20 do calendário (precisa encontrar o dia através do texto)
    await $('20').tap();

    // Clica no horário de início (7:00)
    await $(Keys.kCheckInTime(7)).scrollTo().tap();

    // Clica no horário de fim (12:59)
    await $(Keys.kCheckOutTime(12)).scrollTo().tap();

    // Clica no botão Continuar
    await $(Keys.kContinuarButton).scrollTo().tap();

    // Aguarda carregar a página de resumo
    await Future.delayed(const Duration(seconds: 2));

    // Clica em "Trocar" para selecionar método de pagamento (scrollTo já faz o scroll)
    await $(Keys.kTrocarMetodoPagamento).scrollTo().tap();

    // Clica no botão "Pix"
    await $(Keys.kPixButton).waitUntilVisible();
    await $(Keys.kPixButton).tap();

    // Volta para a tela de resumo
    await Future.delayed(const Duration(seconds: 1));

    // Clica em "Ler e assinar contrato"
    await $(Keys.kLerAssinarContrato).scrollTo().tap();

    // Aguarda carregar a página do contrato
    await Future.delayed(const Duration(seconds: 2));

    // Clica em "Assinar contrato"
    await $(Keys.kAssinarContratoButton).scrollTo().tap();

    // Faz a assinatura (usando a lógica do teste de criar espaço)
    await Future.delayed(const Duration(seconds: 1));
    final drawArea = find.byKey(Keys.kSignaturePaper);
    final rect = $.tester.getRect(drawArea);
    final center = rect.center;
    const offset = 10.0;
    final start = Offset(center.dx - offset, center.dy - offset);
    final middle = Offset(center.dx + offset, center.dy);
    final end = Offset(center.dx - offset, center.dy + rect.height / 4);

    final gesture = await $.tester.startGesture(start);
    await gesture.moveTo(middle);
    await gesture.moveTo(end);
    await gesture.up();
    await Future.delayed(const Duration(seconds: 1));
    await $.pump();

    // Clica em "Confirmar" assinatura
    await $(Keys.kSignatureConfirmButton).tap();

    // Aguarda redirecionar para página de contrato assinado
    await Future.delayed(const Duration(seconds: 2));

    // Clica em "Continuar reserva"
    await $(Keys.kContinuarReservaButton).scrollTo().tap();

    // Aguarda voltar para resumo
    await Future.delayed(const Duration(seconds: 1));

    // Clica em "Reservar"
    await $(Keys.kReservarButton).scrollTo().tap();

    // Aguarda a reserva ser processada
    await Future.delayed(const Duration(seconds: 5));
  });
}
