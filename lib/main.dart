import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/api_client.dart';
import 'core/session.dart';
import 'data/auth/auth_service.dart';
import 'data/profile/profile_service.dart';
import 'views/auth/login_page.dart';
import 'views/home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final session = Session();
  await session.muat();
  runApp(MyApp(session: session));
}

/// Padanan `Program.cs`: mendaftarkan Session, ApiClient dan semua Service.
class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.session, this.apiClient});

  final Session session;

  /// Bisa diganti di test dengan ApiClient ber-`MockClient`.
  final ApiClient? apiClient;

  @override
  Widget build(BuildContext context) {
    final api = apiClient ?? ApiClient(session: session);

    final inputTheme = InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: session),
        Provider.value(value: api),
        Provider(create: (_) => AuthService(api)),
        Provider(create: (_) => ProfileService(api)),
      ],
      child: MaterialApp(
        title: 'My Flutter App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          inputDecorationTheme: inputTheme,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.dark,
          ),
          inputDecorationTheme: inputTheme,
        ),
        home: const AuthGate(),
      ),
    );
  }
}

/// Padanan `BaseController.OnActionExecuting`: belum login -> LoginPage.
/// Saat Session berubah (login, logout, token 401) halaman ikut berganti.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.select<Session, bool>((s) => s.isUserLoggedIn);
    return isLoggedIn ? const HomePage() : const LoginPage();
  }
}
