import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  // Data contoh — penjualan 7 hari terakhir (dalam jutaan rupiah).
  static const _weekly = [
    (day: 'Sen', value: 1.2),
    (day: 'Sel', value: 2.4),
    (day: 'Rab', value: 1.8),
    (day: 'Kam', value: 3.1),
    (day: 'Jum', value: 2.7),
    (day: 'Sab', value: 3.6),
    (day: 'Min', value: 2.0),
  ];

  static const _topProducts = [
    (name: 'Kopi Susu Gula Aren', sold: 342),
    (name: 'Roti Bakar Coklat', sold: 218),
    (name: 'Teh Lemon', sold: 176),
    (name: 'Kentang Goreng', sold: 129),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final maxValue = _weekly
        .map((d) => d.value)
        .reduce((a, b) => a > b ? a : b);
    final total = _weekly.fold<double>(0, (sum, d) => sum + d.value);

    return Scaffold(
      appBar: AppBar(title: const Text('Laporan')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Penjualan 7 Hari Terakhir',
                        style: text.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total Rp ${total.toStringAsFixed(1).replaceAll('.', ',')} jt',
                        style: text.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 180,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (final d in _weekly)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        d.value.toStringAsFixed(1),
                                        style: text.labelSmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        height: 130 * d.value / maxValue,
                                        decoration: BoxDecoration(
                                          color: d.value == maxValue
                                              ? colors.primary
                                              : colors.primaryContainer,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        d.day,
                                        style: text.labelSmall?.copyWith(
                                          color: colors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Produk Terlaris',
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (final (i, p) in _topProducts.indexed) ...[
                        if (i > 0) const Divider(height: 1),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colors.secondaryContainer,
                            foregroundColor: colors.onSecondaryContainer,
                            child: Text('${i + 1}'),
                          ),
                          title: Text(p.name),
                          trailing: Text(
                            '${p.sold} terjual',
                            style: text.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
