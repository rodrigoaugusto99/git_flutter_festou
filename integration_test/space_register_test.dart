import 'package:flutter_test/flutter_test.dart';
import 'package:git_flutter_festou/main.dart';
import 'package:git_flutter_festou/src/helpers/keys.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'test_utils.dart';

void main() {
  tearDown(() async {});
  patrolWidgetTest('should edit task correctly', ($) async {
    await setupMain();
    final userId = await createUserAuth();

    await $.pumpWidgetAndSettle(const MyApp());
  });
}
