import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../models/locker_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SampleData.user;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Profile card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.slate, AppColors.slateMid],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.teal, AppColors.tealDark],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user.initials,
                      style: GoogleFonts.syne(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  user.name,
                  style: GoogleFonts.syne(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(fontSize: 13, color: Colors.white54),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.teal.withOpacity(0.4)),
                  ),
                  child: Text(
                    '⭐ ${user.membershipTier}',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.teal,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Current reservation
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: 'Current Reservation', trailing: StatusBadge.green('Active')),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.tealSurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        'B-07',
                        style: GoogleFonts.syne(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.teal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Package Storage · Zone B',
                              style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          const Text('Size M · 500×350mm',
                              style: TextStyle(fontSize: 12, color: AppColors.muted)),
                          const SizedBox(height: 4),
                          const Text('📍 Floor 1 · Building B',
                              style: TextStyle(fontSize: 11, color: AppColors.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Security settings
          _SettingsGroup(
            title: 'Security',
            items: [
              _SettingItem(emoji: '🔐', label: 'NFC Access', sub: 'AES-256 · Challenge-response', trailing: const _Toggle(value: true)),
              _SettingItem(emoji: '🔢', label: 'PIN Fallback', sub: 'Offline access enabled', trailing: const _Toggle(value: true)),
              _SettingItem(emoji: '⚡', label: 'Token Revocation', sub: 'Currently < 2.1s', trailing: StatusBadge.green('Active')),
              _SettingItem(emoji: '🛡️', label: 'Data Sovereignty', sub: 'On-premises · Saudi Arabia', trailing: StatusBadge.teal('SA Region')),
            ],
          ),

          const SizedBox(height: 16),

          // Hardware settings
          _SettingsGroup(
            title: 'Hardware',
            items: [
              _SettingItem(emoji: '📡', label: 'WebSocket Sync', sub: 'Real-time hardware sync active', trailing: const _Toggle(value: true)),
              _SettingItem(emoji: '🌡️', label: 'HVAC Monitoring', sub: 'Cooled zone: 14°C', trailing: StatusBadge.blue('Online')),
              _SettingItem(emoji: '🔩', label: 'Control Unit', sub: 'Firmware v2.4.1 · C runtime', trailing: StatusBadge.green('OK')),
            ],
          ),

          const SizedBox(height: 16),

          // Preferences
          _SettingsGroup(
            title: 'Preferences',
            items: [
              _SettingItem(emoji: '🔔', label: 'Notifications', sub: 'Access alerts enabled', trailing: const _Toggle(value: true)),
              _SettingItem(emoji: '🌍', label: 'Language', sub: 'English', trailing: const Icon(Icons.chevron_right, color: AppColors.muted)),
              _SettingItem(emoji: '🎨', label: 'Theme', sub: 'Light (default)', trailing: const Icon(Icons.chevron_right, color: AppColors.muted)),
            ],
          ),

          const SizedBox(height: 16),

          // Reset onboarding
          Consumer<AppState>(
            builder: (context, state, _) => AppCard(
              onTap: () => state.resetOnboarding(),
              child: Row(
                children: [
                  const Text('🔄', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Restart Onboarding',
                            style: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700)),
                        const Text('Re-run the Q&A setup flow',
                            style: TextStyle(fontSize: 11, color: AppColors.muted)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.muted),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _SettingsGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 8),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: items.asMap().entries.map((e) {
              return Column(
                children: [
                  e.value,
                  if (e.key < items.length - 1)
                    const Divider(height: 1, color: AppColors.divider),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String emoji;
  final String label;
  final String sub;
  final Widget trailing;

  const _SettingItem({
    required this.emoji,
    required this.label,
    required this.sub,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.slate)),
                Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final bool value;
  const _Toggle({required this.value});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: (_) {},
      activeColor: AppColors.teal,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
