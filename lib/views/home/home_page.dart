import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/profile/profile_controller.dart';
import '../../core/session.dart';
import '../../data/profile/profile_service.dart';
import '../dashboard/dashboard_page.dart';
import '../profile/profile_page.dart';
import '../reports/reports_page.dart';

/// Kerangka utama setelah login, berisi navigasi bawah.
/// Setara `_Layout.cshtml` + `NavBar` di web.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Profil dimuat sekali di sini dan dipakai Dashboard & Profil.
    return ChangeNotifierProvider(
      create: (context) => ProfileController(
        context.read<ProfileService>(),
        context.read<Session>(),
      )..index(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack menjaga posisi scroll tiap tab saat berpindah.
      body: IndexedStack(
        index: _index,
        children: const [DashboardPage(), ReportsPage(), ProfilePage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Laporan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
