import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe/main.dart';

void main() {
  testWidgets('TicTacToeApp root widget builds', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());
    expect(find.byType(TicTacToeMainContainer), findsOneWidget);
    expect(find.text('TicTacToe Interactive'), findsOneWidget);
  });
}
