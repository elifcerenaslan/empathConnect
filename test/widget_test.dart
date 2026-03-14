import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:empath_connect/main.dart';

void main() {
testWidgets('Uygulama basariyla aciliyor mu testi', (WidgetTester tester) async {
// Uygulamamızı çalıştırıyoruz
await tester.pumpWidget(const EmpathConnectApp());

// Artık tarafsız olan Ana Sayfa yazısını arıyoruz
expect(find.text('Ana Sayfa (Yapım Aşamasında)'), findsOneWidget);
});
}