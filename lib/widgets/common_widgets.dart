import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ─── STAT CARD ───────────────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? sub;
  final bool highlight;
  final Widget? trailing;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.sub,
    this.highlight = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: highlight ? AppColors.teal : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlight ? Colors.transparent : AppColors.cardBorder,
        ),
        boxShadow: highlight
            ? [BoxShadow(color: AppColors.teal.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 6))]
            : [],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: highlight ? Colors.white.withOpacity(0.1) : AppColors.tealGlow,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: highlight ? Colors.white70 : AppColors.muted,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: GoogleFonts.syne(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: highlight ? Colors.white : AppColors.teal,
                ),
              ),
              if (sub != null) ...[
                const SizedBox(height: 4),
                Text(
                  sub!,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: highlight ? Colors.white60 : AppColors.muted,
                  ),
                ),
              ],
              if (trailing != null) ...[
                const SizedBox(height: 8),
                trailing!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ─── SECTION HEADER ──────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        if (trailing != null) trailing!,
      ],
    );
  }
}

// ─── STATUS BADGE ─────────────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  factory StatusBadge.teal(String label) => StatusBadge(
        label: label,
        color: AppColors.teal,
        bgColor: AppColors.tealSurface,
      );

  factory StatusBadge.green(String label) => StatusBadge(
        label: label,
        color: AppColors.green,
        bgColor: AppColors.greenLight,
      );

  factory StatusBadge.blue(String label) => StatusBadge(
        label: label,
        color: AppColors.blue,
        bgColor: AppColors.blueLight,
      );

  factory StatusBadge.orange(String label) => StatusBadge(
        label: label,
        color: AppColors.orange,
        bgColor: AppColors.orangeLight,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ─── TEAL BUTTON ─────────────────────────────────────────────────────────────
class TealButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final String? icon;
  final bool isOutlined;
  final bool fullWidth;

  const TealButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.isOutlined = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Text(icon!, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isOutlined ? AppColors.slate : Colors.white,
          ),
        ),
      ],
    );

    if (isOutlined) {
      return SizedBox(
        width: fullWidth ? double.infinity : null,
        child: OutlinedButton(onPressed: onTap, child: child),
      );
    }

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: Colors.white,
          shadowColor: AppColors.teal.withOpacity(0.4),
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: child,
      ),
    );
  }
}

// ─── APP CARD ─────────────────────────────────────────────────────────────────
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? color;
  final List<BoxShadow>? boxShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: color ?? AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: boxShadow,
        ),
        child: child,
      ),
    );
  }
}

// ─── UTILIZATION BAR ─────────────────────────────────────────────────────────
class UtilizationBar extends StatelessWidget {
  final String label;
  final double value; // 0.0 - 1.0
  final Color? color;

  const UtilizationBar({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(value * 100).toInt()}%',
            style: GoogleFonts.syne(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.slate,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 5,
              backgroundColor: AppColors.offWhite,
              valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.teal),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ACCESS METHOD CHIP ───────────────────────────────────────────────────────
class AccessMethodChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const AccessMethodChip({
    super.key,
    required this.emoji,
    required this.label,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.teal : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? AppColors.teal : Colors.white.withOpacity(0.12),
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
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

// ─── TEMPERATURE GAUGE ────────────────────────────────────────────────────────
class TemperatureGauge extends StatelessWidget {
  final double temperature;
  final double minTemp;
  final double maxTemp;

  const TemperatureGauge({
    super.key,
    required this.temperature,
    this.minTemp = 12.0,
    this.maxTemp = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (temperature - minTemp) / (maxTemp - minTemp);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${temperature.toStringAsFixed(1)}°',
              style: GoogleFonts.syne(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: AppColors.teal,
                height: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'C',
                style: GoogleFonts.syne(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
            ),
            const Spacer(),
            StatusBadge.green('Optimal'),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: AppColors.offWhite,
            valueColor: AlwaysStoppedAnimation<Color>(
              Color.lerp(AppColors.cooledBlue, AppColors.teal, progress)!,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${minTemp.toInt()}°C', style: const TextStyle(fontSize: 11, color: AppColors.muted)),
            Text('Target: ${((minTemp + maxTemp) / 2).toStringAsFixed(0)}°C',
                style: const TextStyle(fontSize: 11, color: AppColors.muted)),
            Text('${maxTemp.toInt()}°C', style: const TextStyle(fontSize: 11, color: AppColors.muted)),
          ],
        ),
      ],
    );
  }
}
