import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/profile/profile_controller.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // Data contoh — ganti dengan data dari API/database.
  static const _stats = [
    (icon: Icons.shopping_bag_outlined, label: 'Pesanan', value: '128'),
    (icon: Icons.payments_outlined, label: 'Pendapatan', value: 'Rp 12,4 jt'),
    (icon: Icons.people_outline, label: 'Pelanggan', value: '86'),
    (icon: Icons.inventory_2_outlined, label: 'Produk', value: '42'),
  ];

  static const _activities = [
    (
      icon: Icons.shopping_cart_outlined,
      title: 'Pesanan baru #1024',
      time: '5 menit lalu',
    ),
    (
      icon: Icons.person_add_alt_outlined,
      title: 'Pelanggan baru terdaftar',
      time: '1 jam lalu',
    ),
    (
      icon: Icons.check_circle_outline,
      title: 'Pesanan #1019 selesai',
      time: '3 jam lalu',
    ),
    (
      icon: Icons.inventory_outlined,
      title: 'Stok produk diperbarui',
      time: 'Kemarin',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final profile = context.watch<ProfileController>().profile;
    final name = profile?.nama ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 0,
                  color: colors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: colors.onPrimary,
                          child: Text(
                            name.isEmpty ? '?' : name[0].toUpperCase(),
                            style: text.titleLarge?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo, $name 👋',
                                style: text.titleLarge?.copyWith(
                                  color: colors.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile?.jabatan ?? 'Memuat profil...',
                                style: text.bodyMedium?.copyWith(
                                  color: colors.onPrimary.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Ringkasan',
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth > 600 ? 4 : 2;
                    return GridView.count(
                      crossAxisCount: columns,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.4,
                      children: [
                        for (final s in _stats)
                          _StatCard(
                            icon: s.icon,
                            label: s.label,
                            value: s.value,
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Aktivitas Terbaru',
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: colors.outlineVariant),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (final (i, a) in _activities.indexed) ...[
                        if (i > 0) const Divider(height: 1),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colors.secondaryContainer,
                            foregroundColor: colors.onSecondaryContainer,
                            child: Icon(a.icon, size: 20),
                          ),
                          title: Text(a.title),
                          subtitle: Text(a.time),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: colors.primary),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: text.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  label,
                  style: text.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
