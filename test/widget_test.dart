import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_compras/main.dart';

void main() {
  testWidgets('Adiciona e marca um produto', (WidgetTester tester) async {
    await tester.pumpWidget(const ListaComprasApp());

    await tester.enterText(find.byType(TextField).first, 'Arroz');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('Arroz'), findsOneWidget);
    expect(find.text('0 de 1 itens comprados'), findsOneWidget);
  });
}
