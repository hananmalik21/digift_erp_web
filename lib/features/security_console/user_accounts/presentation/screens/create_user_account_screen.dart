import 'package:digify_erp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../widgets/create_user_form_steps.dart';

// State provider for form data and current step
final createUserFormProvider =
StateNotifierProvider<CreateUserFormNotifier, CreateUserFormState>((ref) {
  return CreateUserFormNotifier();
});

class CreateUserFormState {
  final int currentStep;
  final Set<int> completedSteps;
  final Map<String, dynamic> formData;
  final Map<String, String?> errors;

  CreateUserFormState({
    this.currentStep = 0,
    this.completedSteps = const {},
    this.formData = const {},
    this.errors = const {},
  });

  CreateUserFormState copyWith({
    int? currentStep,
    Set<int>? completedSteps,
    Map<String, dynamic>? formData,
    Map<String, String?>? errors,
  }) {
    return CreateUserFormState(
      currentStep: currentStep ?? this.currentStep,
      completedSteps: completedSteps ?? this.completedSteps,
      formData: formData ?? this.formData,
      errors: errors ?? this.errors,
    );
  }
}

class CreateUserFormNotifier extends StateNotifier<CreateUserFormState> {
  CreateUserFormNotifier() : super(CreateUserFormState());

  void goToStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (state.currentStep < 4) {
      final newCompleted = Set<int>.from(state.completedSteps)
        ..add(state.currentStep);
      state = state.copyWith(
        currentStep: state.currentStep + 1,
        completedSteps: newCompleted,
      );
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void updateFormData(String key, dynamic value) {
    final newData = Map<String, dynamic>.from(state.formData);
    newData[key] = value;
    state = state.copyWith(formData: newData);
  }

  void setError(String key, String? error) {
    final newErrors = Map<String, String?>.from(state.errors);
    if (error == null) {
      newErrors.remove(key);
    } else {
      newErrors[key] = error;
    }
    state = state.copyWith(errors: newErrors);
  }

  void reset() {
    state = CreateUserFormState();
  }
}

class CreateUserAccountScreen extends ConsumerWidget {
  const CreateUserAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createUserFormProvider);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Scaffold(
      backgroundColor: context.themeBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              children: [
                // Cancel Button
                InkWell(
                  onTap: () {
                    ref.read(createUserFormProvider.notifier).reset();
                    context.pop();
                  },
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.1),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.close,
                          size: 16,
                          color: context.themeTextPrimary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.7,
                            fontWeight: FontWeight.w500,
                            color: context.themeTextPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.person_add,
                    size: 24,
                    color: Color(0xFF155DFC),
                  ),
                ),
                const SizedBox(width: 12),
                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Create User Account',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15.1,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF0F172B),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Add a new user to the system',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4A5565),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isMobile) ...[
                  // Reset Button
                  InkWell(
                    onTap: () {
                      ref.read(createUserFormProvider.notifier).reset();
                    },
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.1),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh,
                            size: 16,
                            color: context.themeTextPrimary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Reset',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.8,
                              fontWeight: FontWeight.w500,
                              color: context.themeTextPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Create User Button
                  InkWell(
                    onTap: () {
                      // Handle create user
                    },
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF030213),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Create User',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.8,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),

            // Tabs Section (responsive + fixed border clipping)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(4), // prevent border cut
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;

                    // Simple breakpoints based on available width
                    final bool isCompact = width < 420;
                    final bool isMedium = width >= 420 && width < 900;

                    final double tabHeight = isCompact
                        ? 44
                        : isMedium
                        ? 52
                        : 56;

                    final double fontSize = isCompact
                        ? 11.5
                        : isMedium
                        ? 12.8
                        : 13.6;

                    final tabs = List.generate(5, (index) {
                      final isCompleted =
                      formState.completedSteps.contains(index);
                      final isActive = formState.currentStep == index;

                      // In compact mode we'll set fixed width; otherwise Expanded
                      if (isCompact) {
                        return SizedBox(
                          width: 140,
                          height: tabHeight,
                          child: _buildTab(
                            context: context,
                            index: index,
                            isCompleted: isCompleted,
                            isActive: isActive,
                            fontSize: fontSize,
                            onTap: () => ref
                                .read(createUserFormProvider.notifier)
                                .goToStep(index),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: SizedBox(
                            height: tabHeight,
                            child: _buildTab(
                              context: context,
                              index: index,
                              isCompleted: isCompleted,
                              isActive: isActive,
                              fontSize: fontSize,
                              onTap: () => ref
                                  .read(createUserFormProvider.notifier)
                                  .goToStep(index),
                            ),
                          ),
                        );
                      }
                    });

                    if (isCompact) {
                      // Horizontal scroll on very small widths
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: tabs),
                      );
                    }

                    return Row(children: tabs);
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Form Content
            const CreateUserFormSteps(),

            const SizedBox(height: 24),

            // Footer Note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.1),
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Color(0xFF4A5565),
                  ),
                  const SizedBox(width: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.6,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF4A5565),
                      ),
                      children: [
                        TextSpan(text: 'Fields marked with '),
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: Color(0xFFFB2C36)),
                        ),
                        TextSpan(text: ' are required'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required int index,
    required bool isCompleted,
    required bool isActive,
    required double fontSize,
    required VoidCallback onTap,
  }) {
    final titles = [
      'Account Details',
      'Personal Information',
      'Security Settings',
      'Additional Information',
      'System Settings',
    ];

    final icons = [
      Assets.icons.userIcon.path,
      Assets.icons.userIcon.path,
      Assets.icons.securityConsoleIcon.path,
      Assets.icons.additionalInfoIcon.path,
      Assets.icons.systemSettingIcon.path,
    ];

    Color backgroundColor;
    Color borderColor;
    Color textColor;
    Color iconColor;

    if (isActive) {
      // Active tab: Light blue background, dark blue underline and text
      backgroundColor = const Color(0xFFEFF6FF);
      borderColor = const Color(0xFF155DFC);
      textColor = const Color(0xFF1C398E);
      iconColor = const Color(0xFF155DFC);
    } else {
      // Inactive tab: White background, gray underline and text
      backgroundColor = Colors.white;
      borderColor = const Color(0xFFE5E7EB);
      textColor = const Color(0xFF4A5565);
      iconColor = const Color(0xFF9CA3AF);
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            bottom: BorderSide(color: borderColor, width: 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icons[index],
              color: iconColor,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                titles[index],
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
