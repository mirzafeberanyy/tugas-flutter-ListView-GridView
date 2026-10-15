import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ui_tugas/main.dart';
import 'package:ui_tugas/providers/theme_provider.dart';
import 'package:ui_tugas/providers/user_provider.dart';
import 'package:ui_tugas/providers/language_provider.dart';

void main() {
  testWidgets('Test 3 State Global dan Navigasi Login ke Home', (WidgetTester tester) async {
    // Build app dengan MultiProvider (3 State Global)
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Verifikasi bahwa halaman login berhasil dirender
    expect(find.text('Halaman Login'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    // Masukkan username
    await tester.enterText(find.byType(TextField).first, 'Budi');
    await tester.pump();

    // Pastikan tombol login terlihat lalu klik
    final loginButton = find.text('Login');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Verifikasi sudah pindah ke Home Page dan menampilkan nama dari UserProvider
    expect(find.text('Halo, Budi!'), findsOneWidget);
    expect(find.text('State 1: UserProvider'), findsOneWidget);
    expect(find.text('State 2: ThemeProvider'), findsOneWidget);
    expect(find.text('State 3: LanguageProvider'), findsOneWidget);
  });
}
