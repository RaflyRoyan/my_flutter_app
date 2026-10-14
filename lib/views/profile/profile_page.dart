import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/profile/profile_controller.dart';
import '../../data/profile/profile.dart';

/// Padanan `Views/Profile/Index.cshtml`. Data dari `GET /api/profile`.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final controller = context.read<ProfileController>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    // Session dihapus -> AuthGate otomatis kembali ke LoginPage.
    if (confirmed == true) await controller.logout();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();
    final profile = controller.profile;

    final Widget body;
    if (controller.isLoading && profile == null) {
      body = const Center(child: CircularProgressIndicator());
    } else if (profile == null) {
      body = _ErrorView(
        message: controller.message ?? 'Data profil tidak tersedia.',
        onRetry: controller.index,
      );
    } else {
      body = RefreshIndicator(
        onRefresh: controller.index,
        child: _ProfileView(profile: profile, onLogout: () => _logout(context)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SafeArea(child: body),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({required this.profile, required this.onLogout});

  final Profile profile;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final rows = [
      (icon: Icons.badge_outlined, label: 'NIP', value: profile.nip),
      (icon: Icons.work_outline, label: 'Jabatan', value: profile.jabatan),
      (icon: Icons.apartment_outlined, label: 'Bidang', value: profile.bidang),
      (
        icon: Icons.military_tech_outlined,
        label: 'Golongan',
        value: profile.golongan,
      ),
      (icon: Icons.email_outlined, label: 'Email', value: profile.email ?? '-'),
      (icon: Icons.phone_outlined, label: 'No. HP', value: profile.hp),
      (icon: Icons.home_outlined, label: 'Alamat', value: profile.alamat),
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 8),
            Center(
              child: CircleAvatar(
                radius: 44,
                backgroundColor: colors.primary,
                child: Text(
                  profile.nama.isEmpty ? '?' : profile.nama[0].toUpperCase(),
                  style: text.headlineMedium?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              profile.nama,
              textAlign: TextAlign.center,
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${profile.jenisPegawai} • ${profile.aktif}',
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: colors.outlineVariant),
              ),
              child: Column(
                children: [
                  for (final (i, r) in rows.indexed) ...[
                    if (i > 0) const Divider(height: 1),
                    ListTile(
                      leading: Icon(r.icon),
                      title: Text(
                        r.label,
                        style: text.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      subtitle: Text(
                        r.value.isEmpty ? '-' : r.value,
                        style: text.bodyLarge,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.error,
                side: BorderSide(color: colors.error),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
