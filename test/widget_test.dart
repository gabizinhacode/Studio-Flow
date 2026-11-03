
import 'package:flutter_test/flutter_test.dart';
import 'package:studio_flow/main.dart';

void main() {
  testWidgets('O StudioFlow inicia e mostra a tela inicial',
      (WidgetTester tester) async {
    await tester.pumpWidget(const StudioFlowApp());

    expect(find.text('StudioFlow'), findsOneWidget);
    expect(find.text('Explore o StudioFlow'), findsOneWidget);
    expect(find.text('Agendar horário'), findsOneWidget);
  });
}
