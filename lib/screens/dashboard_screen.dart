import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/locker_model.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = now.hour < 12 ? 'Good morning' : now.hour < 17 ? 'Good afternoon' : 'Good evening';
    final dateStr = DateFormat('EEEE, d MMM yyyy').format(now);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.syne(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.slate,
                        ),
                        children: [
                          TextSpan(text: '$greeting, '),
                          TextSpan(
                            text: 'Ahmed ',
                            style: const TextStyle(color: AppColors.teal),
                          ),
                          const TextSpan(text: '👋'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$dateStr · ${SampleData.user.campus}',
                      style: const TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const _NotifButton(),
            ],
          ),

          const SizedBox(height: 24),

          // ── WS Status bar ────────────────────────────────────────
          Consumer<AppState>(
            builder: (context, state, _) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: state.wsConnected ? AppColors.greenLight : AppColors.orangeLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: state.wsConnected ? AppColors.green : AppColors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state.wsConnected
                        ? 'WebSocket: Connected · Hardware sync active'
                        : 'WebSocket: Offline mode · NFC + PIN available',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: state.wsConnected ? AppColors.green : AppColors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 22),

          // ── Stats grid ───────────────────────────────────────────
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.3,
            children: [
              StatCard(
                label: 'Current Utilization',
                value: '87%',
                sub: '↑ 3% · Target 90%',
                highlight: true,
              ),
              StatCard(
                label: 'Available Lockers',
                value: '24',
                sub: 'of 186 total',
                trailing: StatusBadge.teal('▲ 12 freed'),
              ),
              StatCard(
                label: 'Avg Retrieval',
                value: '18s',
                sub: '80% faster vs. manual',
              ),
              StatCard(
                label: 'Active Sessions',
                value: '9',
                sub: 'NFC:5 App:3 PIN:1',
              ),
            ],
          ),

          const SizedBox(height: 26),

          // ── My Active Locker ────────────────────────────────────
          SectionHeader(
            title: 'My Active Locker',
            trailing: StatusBadge.green('● ACTIVE'),
          ),
          const SizedBox(height: 14),
          _MyLockerCard(),

          const SizedBox(height: 26),

          // ── Utilization by size ─────────────────────────────────
          SectionHeader(
            title: 'Utilization by Size',
            trailing: const Text('Today', style: TextStyle(fontSize: 12, color: AppColors.muted)),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: UtilizationBar(label: 'Size S', value: 0.72)),
              const SizedBox(width: 12),
              Expanded(child: UtilizationBar(label: 'Size M', value: 0.91)),
              const SizedBox(width: 12),
              Expanded(child: UtilizationBar(label: 'Size L', value: 0.85)),
            ],
          ),

          const SizedBox(height: 26),

          // ── Cooled Zone ─────────────────────────────────────────
          SectionHeader(
            title: 'Cooled Section · C-01',
            trailing: StatusBadge.blue('12°C – 16°C'),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Consumer<AppState>(
              builder: (context, state, _) =>
                  TemperatureGauge(temperature: state.cooledTemp),
            ),
          ),

          const SizedBox(height: 26),

          // ── Recent Activity ────────────────────────────────────
          SectionHeader(
            title: 'Access Log',
            trailing: StatusBadge.teal('Today'),
          ),
          const SizedBox(height: 14),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Column(
              children: SampleData.logs.map((log) => _AccessLogItem(log: log)).toList(),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _NotifButton extends StatelessWidget {
  const _NotifButton();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: const Center(child: Text('🔔', style: TextStyle(fontSize: 18))),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.teal,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _MyLockerCard extends StatefulWidget {
  const _MyLockerCard();

  @override
  State<_MyLockerCard> createState() => _MyLockerCardState();
}

class _MyLockerCardState extends State<_MyLockerCard> {
  bool _unlocked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.slate, AppColors.slateMid],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.slate.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ACTIVE RESERVATION',
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      letterSpacing: 1.5,
                      color: Colors.white38,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.teal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'B · 07',
                      style: GoogleFonts.syne(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _unlocked
                      ? AppColors.teal.withOpacity(0.2)
                      : Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _unlocked ? AppColors.teal : Colors.white12,
                  ),
                ),
                child: Text(
                  _unlocked ? '🔓' : '🔒',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Meta grid
          Row(
            children: [
              _metaItem('Zone', 'Zone B · Floor 1'),
              _metaItem('Type', 'Package Storage'),
              _metaItem('Size', 'M — 500×350mm'),
            ],
          ),

          const SizedBox(height: 20),

          // Access buttons
          Row(
            children: [
              Expanded(child: _accessBtn('📡', 'NFC', false, () {})),
              const SizedBox(width: 10),
              Expanded(
                child: _accessBtn(
                  _unlocked ? '🔓' : '🔒',
                  _unlocked ? 'Lock' : 'Unlock',
                  true,
                  () => setState(() => _unlocked = !_unlocked),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: _accessBtn('🔢', 'PIN', false, () {})),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metaItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.dmSans(
              fontSize: 9,
              letterSpacing: 1.2,
              color: Colors.white30,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _accessBtn(String emoji, String label, bool primary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: primary ? AppColors.teal : Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primary ? AppColors.teal : Colors.white.withOpacity(0.1),
          ),
          boxShadow: primary
              ? [BoxShadow(color: AppColors.teal.withOpacity(0.4), blurRadius: 12)]
              : [],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessLogItem extends StatelessWidget {
  final AccessLog log;

  const _AccessLogItem({required this.log});

  Color get _iconBg {
    switch (log.method) {
      case AccessMethod.app:
        return AppColors.tealSurface;
      case AccessMethod.nfc:
        return AppColors.greenLight;
      case AccessMethod.pin:
        return AppColors.orangeLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(log.methodEmoji, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Locker ${log.lockerId} · ${log.methodLabel}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  log.description,
                  style: const TextStyle(fontSize: 11, color: AppColors.muted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            DateFormat('HH:mm').format(log.timestamp),
            style: const TextStyle(fontSize: 11, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
