import 'package:flutter_test/flutter_test.dart';
import 'package:cuatro_retos_pantallas/main.dart';

void main() {
  testWidgets('La pantalla principal muestra los cuatro retos', (tester) async {
    await tester.pumpWidget(const CuatroRetosApp());
    expect(find.text('1. Películas'), findsOneWidget);
    expect(find.text('2. Memes de gatos'), findsOneWidget);
    expect(find.text('3. Clima'), findsOneWidget);
    expect(find.text('4. Criptomonedas'), findsOneWidget);
  });
}
