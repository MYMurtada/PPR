import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/locker_model.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  AccessMethod? _filter;

  List<AccessLog> get _filtered {
    if (_filter == null) return SampleData.logs;
    return SampleData.logs.where((l) => l.method == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Access Logs',
            style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            'Complete audit trail of all access events.',
            style: TextStyle(fontSize: 13, color: AppColors.muted),
          ),

          const SizedBox(height: 20),

          // Security status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.slate, AppColors.slateMid],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('🔐', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AES-256 Encrypted · On-Premises',
                        style: GoogleFonts.syne(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'All logs stored locally in Saudi Arabia. Token revocation < 5s.',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: Colors.white54,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge.green('Secure'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(label: 'All', active: _filter == null, onTap: () => setState(() => _filter = null)),
                const SizedBox(width: 8),
                ...AccessMethod.values.map((m) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _FilterChip(
                    label: ['📱 App', '📡 NFC', '🔢 PIN'][m.index],
                    active: _filter == m,
                    onTap: () => setState(() => _filter = m),
                  ),
                )),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Stats row
          Row(
            children: [
              _MiniStat('Total Events', '${SampleData.logs.length}', AppColors.teal),
              const SizedBox(width: 12),
              _MiniStat('NFC Accesses', '${SampleData.logs.where((l) => l.method == AccessMethod.nfc).length}', AppColors.green),
              const SizedBox(width: 12),
              _MiniStat('PIN Fallbacks', '${SampleData.logs.where((l) => l.method == AccessMethod.pin).length}', AppColors.orange),
            ],
          ),

          const SizedBox(height: 20),

          // Log list grouped by date
          Text(
            'Today · ${DateFormat('MMM d, yyyy').format(DateTime.now())}',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 10),

          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: _filtered
                  .asMap()
                  .entries
                  .map((entry) => Column(
                        children: [
                          _LogRow(log: entry.value),
                          if (entry.key < _filtered.length - 1)
                            const Divider(height: 1, color: AppColors.divider),
                        ],
                      ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.teal : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? AppColors.teal : AppColors.border),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : AppColors.muted,
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: TextStyle(fontSize: 10, color: color.withOpacity(0.7), fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _LogRow extends StatelessWidget {
  final AccessLog log;

  const _LogRow({required this.log});

  Color get _bgColor {
    switch (log.method) {
      case AccessMethod.app:
        return AppColors.tealSurface;
      case AccessMethod.nfc:
        return AppColors.greenLight;
      case AccessMethod.pin:
        return AppColors.orangeLight;
    }
  }

  Color get _iconColor {
    switch (log.method) {
      case AccessMethod.app:
        return AppColors.teal;
      case AccessMethod.nfc:
        return AppColors.green;
      case AccessMethod.pin:
        return AppColors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(log.methodEmoji, style: const TextStyle(fontSize: 17)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _iconColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        log.methodLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _iconColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Locker ${log.lockerId}',
                      style: GoogleFonts.syne(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('HH:mm').format(log.timestamp),
                      style: const TextStyle(fontSize: 11, color: AppColors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  log.description,
                  style: const TextStyle(fontSize: 12, color: AppColors.muted, height: 1.4),
                ),
                if (log.tokenRevocationMs != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 12, color: AppColors.teal),
                      const SizedBox(width: 4),
                      Text(
                        'Token revoked in ${(log.tokenRevocationMs! / 1000).toStringAsFixed(1)}s',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
