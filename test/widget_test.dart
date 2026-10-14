import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_app/main.dart';

void main() {
  testWidgets('Login menampilkan error saat form kosong', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pump();

    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Password wajib diisi'), findsOneWidget);
  });

  testWidgets('Login valid membuka halaman beranda', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextFormField).at(0), 'user@email.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'rahasia123');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Halo, user@email.com'), findsOneWidget);
  });
}
