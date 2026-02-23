import 'package:drop_in_locker/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/locker_model.dart';
import '../theme/app_theme.dart';

class LockerStructure3D extends StatefulWidget {
  final List<LockerCompartment> compartments;
  final String? selectedId;
  final Function(LockerCompartment) onCompartmentTap;

  const LockerStructure3D({
    super.key,
    required this.compartments,
    this.selectedId,
    required this.onCompartmentTap,
  });

  @override
  State<LockerStructure3D> createState() => _LockerStructure3DState();
}

class _LockerStructure3DState extends State<LockerStructure3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _rotationAnim;
  double _dragX = 0;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _rotationAnim = Tween<double>(begin: -3, end: 3).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  Color _compartmentColor(LockerCompartment c) {
    if (widget.selectedId == c.id || c.isMyLocker) return AppColors.tealSurface;
    if (c.isCooled) return AppColors.cooledSurface;
    if (c.status == LockerStatus.occupied) return const Color(0xFFECEFF1);
    return const Color(0xFFF5F5F5);
  }

  Color _compartmentBorder(LockerCompartment c) {
    if (widget.selectedId == c.id || c.isMyLocker) return AppColors.teal;
    if (c.isCooled) return const Color(0xFF90CAF9);
    if (c.status == LockerStatus.occupied) return const Color(0xFFCFD8DC);
    return const Color(0xFFE0E0E0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (d) {
        setState(() {
          _dragX = (_dragX + d.delta.dx * 0.3).clamp(-20.0, 20.0);
        });
      },
      onHorizontalDragEnd: (_) {
        setState(() => _dragX = 0);
      },
      child: AnimatedBuilder(
        animation: _rotationAnim,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY((_rotationAnim.value + _dragX) * 0.017453),
            child: child,
          );
        },
        child: SizedBox(
          width: 340,
          height: 400,
          child: CustomPaint(
            painter: LockerPainter(
              compartments: widget.compartments,
              selectedId: widget.selectedId,
              compartmentColor: _compartmentColor,
              compartmentBorder: _compartmentBorder,
            ),
            child: _buildTappableOverlay(),
          ),
        ),
      ),
    );
  }

  Widget _buildTappableOverlay() {
    // Row heights for tap regions
    final rowHeights = [85.0, 70.0, 65.0, 55.0];
    final rowTops = [10.0, 100.0, 175.0, 245.0];
    final paddingX = 14.0;

    return SizedBox(
      width: 340,
      height: 400,
      child: Stack(
        children: widget.compartments.map((c) {
          final rowH = rowHeights[c.row.clamp(0, 3)];
          final rowT = rowTops[c.row.clamp(0, 3)];
          final cols = widget.compartments.where((x) => x.row == c.row).length;
          final colW = (310.0 - paddingX * 2) / cols;
          final colX = paddingX + c.col * colW;

          return Positioned(
            top: rowT,
            left: colX,
            width: colW - 4,
            height: rowH - 4,
            child: GestureDetector(
              onTap: () => widget.onCompartmentTap(c),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class LockerPainter extends CustomPainter {
  final List<LockerCompartment> compartments;
  final String? selectedId;
  final Color Function(LockerCompartment) compartmentColor;
  final Color Function(LockerCompartment) compartmentBorder;

  LockerPainter({
    required this.compartments,
    this.selectedId,
    required this.compartmentColor,
    required this.compartmentBorder,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Draw 3D body ──────────────────────────────────────────────
    final sideOffset = 30.0;

    // Front face background
    final bodyPaint = Paint()..color = const Color(0xFFF0F4F4);
    final bodyPath = Path()
      ..moveTo(14, 5)
      ..lineTo(w - 50, 5)
      ..lineTo(w - 50, h - 40)
      ..lineTo(14, h - 40)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    // Right side face
    final rightPaint = Paint()..color = const Color(0xFFCFD8DC);
    final rightPath = Path()
      ..moveTo(w - 50, 5)
      ..lineTo(w - 20, 5 - 25)
      ..lineTo(w - 20, h - 40 - 25)
      ..lineTo(w - 50, h - 40)
      ..close();
    canvas.drawPath(rightPath, rightPaint);

    // Top face
    final topPaint = Paint()..color = const Color(0xFFECEFF1);
    final topPath = Path()
      ..moveTo(14, 5)
      ..lineTo(w - 50, 5)
      ..lineTo(w - 20, -20)
      ..lineTo(44, -20)
      ..close();
    canvas.drawPath(topPath, topPaint);

    // Outer border
    final borderPaint = Paint()
      ..color = const Color(0xFFCFD8DC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(bodyPath, borderPaint);
    canvas.drawPath(rightPath, borderPaint);
    canvas.drawPath(topPath, borderPaint);

    // ── Draw compartment cells ────────────────────────────────────
    final rowHeights = [85.0, 70.0, 65.0, 55.0];
    final rowTops = [10.0, 100.0, 175.0, 245.0];
    final paddingX = 14.0;
    final cellPaddingX = 4.0;
    final cellPaddingY = 4.0;
    final bodyWidth = w - 50 - 14;

    for (final c in compartments) {
      final cols = compartments.where((x) => x.row == c.row).length;
      final colW = bodyWidth / cols;
      final rowH = rowHeights[c.row.clamp(0, 3)];
      final rowT = rowTops[c.row.clamp(0, 3)];

      final cellRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          paddingX + c.col * colW + cellPaddingX,
          rowT + cellPaddingY,
          colW - cellPaddingX * 2,
          rowH - cellPaddingY * 2,
        ),
        const Radius.circular(8),
      );

      // Cell background
      final cellPaint = Paint()..color = compartmentColor(c);
      canvas.drawRRect(cellRect, cellPaint);

      // Cell border
      final cellBorderPaint = Paint()
        ..color = compartmentBorder(c)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (selectedId == c.id || c.isMyLocker) ? 2.0 : 1.0;
      canvas.drawRRect(cellRect, cellBorderPaint);

      // Handle bar
      final handlePaint = Paint()
        ..color = compartmentBorder(c).withOpacity(0.7)
        ..style = PaintingStyle.fill;
      final handleRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          paddingX + c.col * colW + colW - 30,
          rowT + rowH / 2 - 4,
          20,
          8,
        ),
        const Radius.circular(4),
      );
      canvas.drawRRect(handleRect, handlePaint);

      // Status dot
      final dotColor = c.isMyLocker
          ? AppColors.teal
          : c.isCooled
              ? AppColors.cooledBlue
              : c.status == LockerStatus.available
                  ? AppColors.teal.withOpacity(0.6)
                  : Colors.grey;
      canvas.drawCircle(
        Offset(paddingX + c.col * colW + colW - 14, rowT + 12),
        4,
        Paint()..color = dotColor,
      );

      // Side face of cell (3D effect)
      final sideFaceColor = compartmentColor(c).withOpacity(0.3);
      final sidePaint = Paint()..color = sideFaceColor;
      final sideX = w - 50;
      final sideW = sideOffset - 4;
      final sideTop = rowT + cellPaddingY;
      final sideH = rowH - cellPaddingY * 2;

      if (c.col == cols - 1) {
        final sidePath = Path()
          ..moveTo(sideX, sideTop)
          ..lineTo(sideX + sideW, sideTop - 20)
          ..lineTo(sideX + sideW, sideTop - 20 + sideH)
          ..lineTo(sideX, sideTop + sideH)
          ..close();
        canvas.drawPath(sidePath, sidePaint);
        canvas.drawPath(
          sidePath,
          Paint()
            ..color = compartmentBorder(c).withOpacity(0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5,
        );
      }
    }

    // ── Shadow ────────────────────────────────────────────────────
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w / 2 - 15, h - 20),
        width: w - 40,
        height: 20,
      ),
      shadowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant LockerPainter old) =>
      old.selectedId != selectedId || old.compartments != compartments;
}

// ─── Compartment Detail Panel ─────────────────────────────────────────────────
class CompartmentDetail extends StatelessWidget {
  final LockerCompartment compartment;
  final VoidCallback? onReserve;

  const CompartmentDetail(
      {super.key, required this.compartment, this.onReserve});

  @override
  Widget build(BuildContext context) {
    final c = compartment;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(c.type.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Locker ${c.id}',
                    style: GoogleFonts.syne(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate,
                    ),
                  ),
                  Text(
                    '${c.type.label} · Zone ${c.zone}',
                    style:
                        const TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ],
              ),
              const Spacer(),
              _statusBadge(c),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _infoChip('Size ${c.size.label}', '📐'),
              _infoChip(c.size.dimensions, '📏'),
              if (c.temperature != null) _infoChip('${c.temperature}°C', '🌡️'),
            ],
          ),
          if (c.isAvailable && onReserve != null) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onReserve,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Reserve This Locker',
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
          if (c.isMyLocker) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.tealGlow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified, color: AppColors.teal, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'This is your active locker',
                    style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.tealDark),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoChip(String label, String emoji) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate)),
        ],
      ),
    );
  }

  Widget _statusBadge(LockerCompartment c) {
    if (c.isMyLocker) return StatusBadge.teal('MY LOCKER');
    if (c.isCooled) return StatusBadge.blue('COOLED');
    if (c.status == LockerStatus.available) return StatusBadge.green('FREE');
    return StatusBadge(
        label: 'TAKEN',
        color: AppColors.muted,
        
        bgColor: const Color(0xFFECEFF1));
  }
}
