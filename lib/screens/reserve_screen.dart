import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/locker_model.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ReserveScreen extends StatefulWidget {
  const ReserveScreen({super.key});

  @override
  State<ReserveScreen> createState() => _ReserveScreenState();
}

class _ReserveScreenState extends State<ReserveScreen> {
  CompartmentType? _type;
  LockerSize _size = LockerSize.m;
  String _preference = 'proximity'; // or 'temperature'
  bool _assigned = false;
  bool _assigning = false;
  String? _assignedId;
  int _assignMs = 0;

  Future<void> _runAiAssignment() async {
    setState(() {
      _assigning = true;
      _assigned = false;
      _assignedId = null;
    });

    final stopwatch = Stopwatch()..start();
    await Future.delayed(const Duration(milliseconds: 165));
    stopwatch.stop();

    setState(() {
      _assigning = false;
      _assigned = true;
      _assignMs = stopwatch.elapsedMilliseconds;
      _assignedId = _type == CompartmentType.cooled ? 'C-01' : 'B-09';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reserve a Locker',
            style: GoogleFonts.syne(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            'Our AI will find the optimal compartment for you.',
            style: TextStyle(fontSize: 13, color: AppColors.muted),
          ),

          const SizedBox(height: 24),

          // ── Storage Type ───────────────────────────────────────
          _SectionTitle('1. Storage Type'),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.4,
            children: CompartmentType.values.map((type) {
              final sel = _type == type;
              return GestureDetector(
                onTap: () => setState(() {
                  _type = type;
                  _assigned = false;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.tealSurface : AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: sel ? AppColors.teal : AppColors.cardBorder,
                      width: sel ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(type.emoji, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              type.label,
                              style: GoogleFonts.syne(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: sel ? AppColors.tealDark : AppColors.slate,
                              ),
                            ),
                            Text(
                              type.description,
                              style: const TextStyle(fontSize: 10, color: AppColors.muted),
                            ),
                          ],
                        ),
                      ),
                      if (sel)
                        const Icon(Icons.check_circle, color: AppColors.teal, size: 16),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // ── Size ───────────────────────────────────────────────
          _SectionTitle('2. Size Preference'),
          const SizedBox(height: 4),
          const Text(
            'AI will recommend the best fit — you can override.',
            style: TextStyle(fontSize: 11, color: AppColors.muted),
          ),
          const SizedBox(height: 12),
          Row(
            children: LockerSize.values.map((size) {
              final sel = _size == size;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _size = size;
                    _assigned = false;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.tealSurface : AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: sel ? AppColors.teal : AppColors.cardBorder,
                        width: sel ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          size.label,
                          style: GoogleFonts.syne(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: sel ? AppColors.teal : AppColors.slate,
                          ),
                        ),
                        Text(
                          size.dimensions,
                          style: const TextStyle(fontSize: 10, color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // ── Assignment criteria ────────────────────────────────
          _SectionTitle('3. Assignment Criteria'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CriteriaCard(
                  emoji: '📍',
                  label: 'Proximity',
                  desc: 'Closest locker to you',
                  selected: _preference == 'proximity',
                  onTap: () => setState(() {
                    _preference = 'proximity';
                    _assigned = false;
                  }),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CriteriaCard(
                  emoji: '🌡️',
                  label: 'Temperature',
                  desc: 'Best cooling zone',
                  selected: _preference == 'temperature',
                  onTap: () => setState(() {
                    _preference = 'temperature';
                    _assigned = false;
                  }),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── AI Assign button ───────────────────────────────────
          if (!_assigned) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_type != null && !_assigning) ? _runAiAssignment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  disabledBackgroundColor: AppColors.tealLight,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.teal.withOpacity(0.4),
                ),
                child: _assigning
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'AI decision tree running...',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🤖', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Text(
                            'Find My Optimal Locker',
                            style: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            if (_type == null)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Center(
                  child: Text(
                    'Select a storage type to continue',
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ),
              ),
          ],

          // ── AI Result ─────────────────────────────────────────
          if (_assigned && _assignedId != null) ...[
            _AiResultCard(
              assignedId: _assignedId!,
              type: _type!,
              size: _size,
              assignMs: _assignMs,
              onConfirm: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '✅ Locker $_assignedId confirmed! AES-256 token issued.',
                      style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: AppColors.teal,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    duration: const Duration(seconds: 3),
                  ),
                );
                setState(() {
                  _assigned = false;
                  _type = null;
                  _size = LockerSize.m;
                  _preference = 'proximity';
                });
              },
              onOverride: () => setState(() => _assigned = false),
            ),
          ],

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.syne(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.slate,
      ),
    );
  }
}

class _CriteriaCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String desc;
  final bool selected;
  final VoidCallback onTap;

  const _CriteriaCard({
    required this.emoji,
    required this.label,
    required this.desc,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.tealSurface : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.teal : AppColors.cardBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.syne(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: selected ? AppColors.tealDark : AppColors.slate,
                    ),
                  ),
                  Text(desc, style: const TextStyle(fontSize: 10, color: AppColors.muted)),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: AppColors.teal, size: 16),
          ],
        ),
      ),
    );
  }
}

class _AiResultCard extends StatelessWidget {
  final String assignedId;
  final CompartmentType type;
  final LockerSize size;
  final int assignMs;
  final VoidCallback onConfirm;
  final VoidCallback onOverride;

  const _AiResultCard({
    required this.assignedId,
    required this.type,
    required this.size,
    required this.assignMs,
    required this.onConfirm,
    required this.onOverride,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.tealSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.teal.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🤖', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Assignment Complete',
                    style: GoogleFonts.syne(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.tealDark,
                    ),
                  ),
                  Text(
                    'Processed in ${assignMs}ms (<200ms target)',
                    style: const TextStyle(fontSize: 11, color: AppColors.teal),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Text(type.emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Locker $assignedId',
                        style: GoogleFonts.syne(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.slate,
                        ),
                      ),
                      Text(
                        '${type.label} · Size ${size.label} · ${size.dimensions}',
                        style: const TextStyle(fontSize: 12, color: AppColors.muted),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '📍 Closest available locker to your position',
                        style: TextStyle(fontSize: 11, color: AppColors.teal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onOverride,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.teal),
                    foregroundColor: AppColors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Override',
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Confirm Reservation ✓',
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
