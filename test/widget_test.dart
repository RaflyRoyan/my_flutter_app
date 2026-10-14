import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:my_flutter_app/core/api_client.dart';
import 'package:my_flutter_app/core/session.dart';
import 'package:my_flutter_app/main.dart';
import 'package:my_flutter_app/views/profile/profile_page.dart';

const _profileJson = {
  'nip': '198001012005011001',
  'nama': 'Budi Santoso',
  'alamat': 'Jl. Pahlawan 1',
  'hp': '08123456789',
  'email': 'budi@contoh.go.id',
  'jenisPegawai': 'PNS',
  'aktif': 'Aktif',
  'tglLahir': '1980-01-01 00:00:00',
  'bidang': 'Pengawasan',
  'jabatan': 'Staf Pengawasan',
  'golongan': 'III/a',
};

Map<String, dynamic> _ok(Object data) => {
  'isSuccess': true,
  'title': 'Berhasil',
  'status': 200,
  'data': data,
};

Map<String, dynamic> _fail(String error, {int status = 400}) => {
  'isSuccess': false,
  'title': 'Gagal',
  'status': status,
  'errors': [error],
};

/// Membuat aplikasi dengan API tiruan. [handler] menerima request dan
/// mengembalikan (statusCode, body).
Future<Session> _pumpApp(
  WidgetTester tester,
  (int, Map<String, dynamic>) Function(http.Request) handler,
) async {
  FlutterSecureStorage.setMockInitialValues({});
  final session = Session();
  await session.muat();
  final api = ApiClient(
    session: session,
    baseUrl: 'http://api.test',
    client: MockClient((req) async {
      final (status, body) = handler(req);
      return http.Response(jsonEncode(body), status);
    }),
  );
  await tester.pumpWidget(MyApp(session: session, apiClient: api));
  return session;
}

Future<void> _login(WidgetTester tester) async {
  await tester.enterText(
    find.byType(TextFormField).at(0),
    '198001012005011001',
  );
  await tester.enterText(find.byType(TextFormField).at(1), 'rahasia');
  await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Form kosong menampilkan pesan validasi', (tester) async {
    await _pumpApp(tester, (_) => (200, _ok({})));

    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pump();

    expect(find.text('NIP wajib diisi.'), findsOneWidget);
    expect(find.text('Password wajib diisi.'), findsOneWidget);
  });

  testWidgets('Gagal login (HTTP 200, isSuccess false) menampilkan pesan API', (
    tester,
  ) async {
    await _pumpApp(tester, (_) => (200, _fail('Password salah.')));

    await _login(tester);

    expect(find.text('Password salah.'), findsOneWidget);
    expect(find.text('Selamat Datang'), findsOneWidget);
  });

  testWidgets('Login berhasil memuat profil, lalu bisa keluar', (tester) async {
    late http.Request profileRequest;
    final session = await _pumpApp(tester, (req) {
      if (req.url.path == '/api/auth/login') {
        expect(jsonDecode(req.body), {
          'nip': '198001012005011001',
          'password': 'rahasia',
        });
        return (200, _ok({'isResetPassword': false, 'token': 'jwt-123'}));
      }
      profileRequest = req;
      return (200, _ok(_profileJson));
    });

    await _login(tester);

    expect(session.token, 'jwt-123');
    expect(profileRequest.headers['Authorization'], 'Bearer jwt-123');
    expect(find.text('Halo, Budi Santoso 👋'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Staf Pengawasan'), findsWidgets);
    expect(find.text('198001012005011001'), findsOneWidget);

    final logoutButton = find.widgetWithText(OutlinedButton, 'Keluar');
    await tester.scrollUntilVisible(
      logoutButton,
      200,
      scrollable: find.descendant(
        of: find.byType(ProfilePage),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Keluar'));
    await tester.pumpAndSettle();

    expect(session.isUserLoggedIn, isFalse);
    expect(find.text('Selamat Datang'), findsOneWidget);
  });

  testWidgets('Token ditolak (401) mengembalikan ke halaman login', (
    tester,
  ) async {
    await _pumpApp(tester, (req) {
      if (req.url.path == '/api/auth/login') {
        return (200, _ok({'isResetPassword': false, 'token': 'jwt-lama'}));
      }
      return (
        401,
        _fail('Session Login Telah Usai, Silahkan Login kembali', status: 401),
      );
    });

    await _login(tester);

    expect(find.text('Selamat Datang'), findsOneWidget);
    expect(
      find.text('Session Login Telah Usai, Silahkan Login kembali'),
      findsOneWidget,
    );
  });
}
