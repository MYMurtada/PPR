import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'locker_view_screen.dart';
import 'reserve_screen.dart';
import 'logs_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _screens = [
    DashboardScreen(),
    LockerViewScreen(),
    ReserveScreen(),
    LogsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
          ),
          child: Scaffold(
            backgroundColor: AppColors.offWhite,
            body: SafeArea(
              child: IndexedStack(
                index: state.navIndex,
                children: _screens,
              ),
            ),
            bottomNavigationBar: _BottomNav(
              currentIndex: state.navIndex,
              onTap: state.setNavIndex,
            ),
          ),
        );
      },
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: '⊞', label: 'Home', index: 0, current: currentIndex, onTap: onTap),
              _NavItem(icon: '🌐', label: '3D View', index: 1, current: currentIndex, onTap: onTap),
              _NavItemCenter(onTap: () => onTap(2), current: currentIndex == 2),
              _NavItem(icon: '📋', label: 'Logs', index: 3, current: currentIndex, onTap: onTap),
              _NavItem(icon: '👤', label: 'Profile', index: 4, current: currentIndex, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final int index;
  final int current;
  final Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.tealSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: TextStyle(fontSize: 18, color: active ? null : Colors.grey)),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? AppColors.teal : AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemCenter extends StatelessWidget {
  final VoidCallback onTap;
  final bool current;

  const _NavItemCenter({required this.onTap, required this.current});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: current ? AppColors.tealDark : AppColors.teal,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.teal.withOpacity(0.4),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text('🔒', style: TextStyle(fontSize: 22)),
        ),
      ),
    );
  }
}
