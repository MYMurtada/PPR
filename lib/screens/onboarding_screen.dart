import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/locker_model.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int _step = 0;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.12, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(parent: _slideController, curve: Curves.easeOut);
    _slideController.forward();
  }

  void _nextStep() {
    _slideController.reset();
    setState(() => _step++);
    _slideController.forward();
  }

  Future<void> _assignAndFinish(AppState state) async {
    await state.triggerAiAssignment();
    _nextStep();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate,
      body: SafeArea(
        child: Consumer<AppState>(
          builder: (context, state, _) {
            return Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  // Logo
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.teal,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('📦', style: TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Drop in',
                            style: GoogleFonts.syne(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Locker',
                            style: GoogleFonts.syne(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.teal,
                              height: 0.9,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Step indicator
                  Row(
                    children: List.generate(
                      _step == 3 ? 3 : 3,
                      (i) => Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: i <= _step ? AppColors.teal : Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Content
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: _buildStep(state),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStep(AppState state) {
    switch (_step) {
      case 0:
        return _StepStorageType(
          selectedType: state.selectedType,
          onSelect: (t) => state.selectType(t),
          onContinue: () {
            if (state.selectedType != null) _nextStep();
          },
        );
      case 1:
        return _StepSizeSelect(
          selectedSize: state.selectedSize,
          isLoading: state.aiAssigning,
          onSelect: (s) => state.selectSize(s),
          onContinue: () => _assignAndFinish(state),
        );
      case 2:
        return _StepConfirmation(
          assignedId: state.aiAssignedId ?? 'B-09',
          selectedType: state.selectedType!,
          selectedSize: state.selectedSize,
          onFinish: () {
            state.completeOnboarding();
            widget.onComplete();
          },
        );
      default:
        return const SizedBox();
    }
  }
}

// ─── Step 1: Storage Type ──────────────────────────────────────────────────────
class _StepStorageType extends StatelessWidget {
  final CompartmentType? selectedType;
  final Function(CompartmentType) onSelect;
  final VoidCallback onContinue;

  const _StepStorageType({
    required this.selectedType,
    required this.onSelect,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What do you\nneed to store?',
          style: GoogleFonts.syne(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Help us find your ideal locker type in seconds.',
          style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white54),
        ),
        const SizedBox(height: 36),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.0,
            children: CompartmentType.values.map((type) {
              final selected = selectedType == type;
              return GestureDetector(
                onTap: () => onSelect(type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.teal.withOpacity(0.15)
                        : Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? AppColors.teal : Colors.white.withOpacity(0.12),
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(type.emoji, style: const TextStyle(fontSize: 36)),
                      const SizedBox(height: 10),
                      Text(
                        type.label,
                        style: GoogleFonts.syne(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: selected ? AppColors.teal : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        type.description,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: Colors.white38,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: selectedType != null ? onContinue : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.teal,
              disabledBackgroundColor: Colors.white.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Continue →',
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Step 2: Size Selection ────────────────────────────────────────────────────
class _StepSizeSelect extends StatelessWidget {
  final LockerSize selectedSize;
  final bool isLoading;
  final Function(LockerSize) onSelect;
  final VoidCallback onContinue;

  const _StepSizeSelect({
    required this.selectedSize,
    required this.isLoading,
    required this.onSelect,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a size',
          style: GoogleFonts.syne(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Our AI will suggest the best fit — you can always override.',
          style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white54),
        ),
        const SizedBox(height: 32),
        Row(
          children: LockerSize.values.map((size) {
            final selected = selectedSize == size;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelect(size),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.teal.withOpacity(0.15)
                        : Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected ? AppColors.teal : Colors.white.withOpacity(0.12),
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        size.label,
                        style: GoogleFonts.syne(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: selected ? AppColors.teal : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        size.dimensions,
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          color: Colors.white38,
                        ),
                      ),
                      Text(
                        size.description,
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          color: Colors.white38,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // AI badge
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.teal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.teal.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🤖', style: TextStyle(fontSize: 26)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Recommends: Size M',
                      style: GoogleFonts.syne(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.teal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Based on your storage type and campus location B-3, Locker B-09 is your closest match. Decision in <200ms.',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: Colors.white60,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.teal,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Confirm & Assign →',
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

// ─── Step 3: Confirmation ──────────────────────────────────────────────────────
class _StepConfirmation extends StatelessWidget {
  final String assignedId;
  final CompartmentType selectedType;
  final LockerSize selectedSize;
  final VoidCallback onFinish;

  const _StepConfirmation({
    required this.assignedId,
    required this.selectedType,
    required this.selectedSize,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "You're all\nset! 🎉",
          style: GoogleFonts.syne(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Locker $assignedId is reserved. Access via app, NFC, or PIN.',
          style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white54),
        ),
        const SizedBox(height: 30),

        // Locker card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.teal, AppColors.tealDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LOCKER ID',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                assignedId,
                style: GoogleFonts.syne(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _tagChip(selectedType.emoji, selectedType.label),
                  const SizedBox(width: 8),
                  _tagChip('📐', 'Size ${selectedSize.label}'),
                  const SizedBox(width: 8),
                  _tagChip('🔐', 'AES-256'),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Access methods
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ACCESS METHODS',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white38,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _accessChip('📱', 'App', true)),
                  const SizedBox(width: 10),
                  Expanded(child: _accessChip('📡', 'NFC', false)),
                  const SizedBox(width: 10),
                  Expanded(child: _accessChip('🔢', 'PIN', false)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '• Offline-capable hybrid NFC + PIN access\n• Token revocation < 5s\n• Challenge-response authentication',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: Colors.white38,
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onFinish,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.teal,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Go to Dashboard →',
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tagChip(String emoji, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 5),
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
    );
  }

  Widget _accessChip(String emoji, String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: active ? AppColors.teal.withOpacity(0.2) : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active ? AppColors.teal.withOpacity(0.5) : Colors.white.withOpacity(0.08),
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
              color: active ? AppColors.teal : Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}
