import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/locker_model.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/locker_3d_widget.dart';

class LockerViewScreen extends StatefulWidget {
  const LockerViewScreen({super.key});

  @override
  State<LockerViewScreen> createState() => _LockerViewScreenState();
}

class _LockerViewScreenState extends State<LockerViewScreen> {
  LockerCompartment? _selected;
  bool _showLegend = true;

  @override
  void initState() {
    super.initState();
    _selected = SampleData.myLocker;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Consumer<AppState>(
        builder: (context, state, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '3D Locker View',
                          style: GoogleFonts.syne(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.slate,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Drag to rotate · Tap to inspect · Pinch to zoom',
                          style: TextStyle(fontSize: 12, color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge.teal('1040×900×550mm'),
                ],
              ),

              const SizedBox(height: 20),

              // Zone + Filter bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ZoneChip(label: 'Zone A', active: false),
                    const SizedBox(width: 8),
                    _ZoneChip(label: 'Zone B', active: true),
                    const SizedBox(width: 8),
                    _ZoneChip(label: 'Zone C', active: false),
                    const SizedBox(width: 8),
                    _ZoneChip(label: 'Cooled Only', active: false),
                    const SizedBox(width: 8),
                    _ZoneChip(label: 'Available', active: false),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3D Locker
              AppCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Zone B · Structure',
                          style: GoogleFonts.syne(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            StatusBadge.green('Online'),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => setState(() => _showLegend = !_showLegend),
                              child: StatusBadge(
                                label: _showLegend ? 'Hide Legend' : 'Show Legend',
                                color: AppColors.muted,
                                bgColor: AppColors.offWhite,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 3D Model
                    SizedBox(
                      height: 420,
                      child: Center(
                        child: LockerStructure3D(
                          compartments: SampleData.compartments,
                          selectedId: _selected?.id,
                          onCompartmentTap: (c) {
                            setState(() => _selected = c);
                            state.selectCompartment(c.id);
                          },
                        ),
                      ),
                    ),

                    // Legend
                    if (_showLegend) ...[
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 16,
                        runSpacing: 10,
                        children: [
                          _LegendItem(color: AppColors.tealSurface, border: AppColors.teal, label: 'Your locker'),
                          _LegendItem(color: AppColors.cooledSurface, border: const Color(0xFF90CAF9), label: 'Cooled zone'),
                          _LegendItem(color: const Color(0xFFECEFF1), border: const Color(0xFFCFD8DC), label: 'Occupied'),
                          _LegendItem(color: const Color(0xFFF5F5F5), border: const Color(0xFFE0E0E0), label: 'Available'),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Selected compartment detail
              if (_selected != null) ...[
                Text(
                  'Selected Compartment',
                  style: GoogleFonts.syne(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                CompartmentDetail(
                  compartment: _selected!,
                  onReserve: _selected!.isAvailable
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '✅ Locker ${_selected!.id} reserved!',
                                style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
                              ),
                              backgroundColor: AppColors.teal,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        }
                      : null,
                ),
              ],

              const SizedBox(height: 20),

              // All compartments list
              Text(
                'All Compartments',
                style: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ...SampleData.compartments.map((c) => _CompartmentListItem(
                    compartment: c,
                    isSelected: _selected?.id == c.id,
                    onTap: () => setState(() {
                      _selected = c;
                      state.selectCompartment(c.id);
                    }),
                  )),

              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}

class _ZoneChip extends StatelessWidget {
  final String label;
  final bool active;

  const _ZoneChip({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final Color border;
  final String label;

  const _LegendItem({required this.color, required this.border, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: border, width: 1.5),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
      ],
    );
  }
}

class _CompartmentListItem extends StatelessWidget {
  final LockerCompartment compartment;
  final bool isSelected;
  final VoidCallback onTap;

  const _CompartmentListItem({
    required this.compartment,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = compartment;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.tealSurface : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.teal : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(c.type.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Locker ${c.id} · ${c.type.label}',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate,
                    ),
                  ),
                  Text(
                    'Zone ${c.zone} · Size ${c.size.label} · ${c.size.dimensions}',
                    style: const TextStyle(fontSize: 11, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            _statusChip(c),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(LockerCompartment c) {
    if (c.isMyLocker) return StatusBadge.teal('MINE');
    if (c.isCooled) return StatusBadge.blue('COOLED');
    if (c.isAvailable) return StatusBadge.green('FREE');
    return const StatusBadge(label: 'TAKEN', color: AppColors.muted, bgColor: Color(0xFFECEFF1));
  }
}
