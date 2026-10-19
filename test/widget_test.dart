import 'package:flutter_test/flutter_test.dart';
import 'package:insta_tela/main.dart';

void main() {
  testWidgets('O aplicativo Conecta abre corretamente',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MeuAplicativo());

    expect(find.text('Conecta'), findsOneWidget);
  });
}