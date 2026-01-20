import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../home/presentation/pages/homepage.dart';
import '../state/app_state.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: 'Karibu Nyimbo za Kristo',
      description:
          'Mjudo kamili wa nyimbo za kumsifu na kumwabudu Mungu wetu, sasa kiganjani mwako.',
      icon: CupertinoIcons.book_fill,
    ),
    OnboardingContent(
      title: 'Tafuta na Hifadhi',
      description:
          'Tafuta nyimbo kwa namba au kichwa kwa urahisi, na hifadhi zile unazozipenda.',
      icon: CupertinoIcons.heart_fill,
    ),
    OnboardingContent(
      title: 'Usomaji Bora',
      description:
          'Badilisha muonekano kulingana na mazingira yako. Furahia Light na Dark mode.',
      icon: CupertinoIcons.moon_stars_fill,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentPage < _contents.length - 1)
                    TextButton(
                      onPressed: () => _completeOnboarding(context),
                      child: Text(
                        'Ruka',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                  HapticFeedback.selectionClick();
                },
                itemCount: _contents.length,
                itemBuilder: (context, index) {
                  final content = _contents[index];
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon Circle
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 40,
                                spreadRadius: 0,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: index == 0
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.book_fill,
                                      size: 64,
                                      color: colorScheme.primary,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        left: 4,
                                      ),
                                      child: Transform.rotate(
                                        angle: 0.785, // 45 degrees in radians
                                        child: Icon(
                                          CupertinoIcons.music_note_2,
                                          size: 32,
                                          // Simulate cutout by blending the container color over the scaffold background
                                          color: Color.alphaBlend(
                                            colorScheme.primary.withValues(
                                              alpha: 0.1,
                                            ),
                                            theme.scaffoldBackgroundColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Icon(
                                  content.icon,
                                  size: 64,
                                  color: colorScheme.primary,
                                ),
                        ),
                        const SizedBox(height: 48),

                        // Title
                        Text(
                          content.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Text(
                          content.description,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            height: 1.5,
                          ),
                        ),

                        // Theme Toggle for index 2
                        if (index == 2) ...[
                          const SizedBox(height: 32),
                          Consumer<AppState>(
                            builder: (context, appState, child) {
                              final isLight =
                                  appState.themeMode == ThemeMode.light;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest
                                      .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(32),
                                  border: Border.all(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      CupertinoIcons.moon_fill,
                                      size: 20,
                                      color: !isLight
                                          ? colorScheme.primary
                                          : colorScheme.onSurface.withValues(
                                              alpha: 0.3,
                                            ),
                                    ),
                                    const SizedBox(width: 12),
                                    Switch.adaptive(
                                      value: isLight,
                                      onChanged: (value) {
                                        HapticFeedback.lightImpact();
                                        appState.setThemeMode(
                                          value
                                              ? ThemeMode.light
                                              : ThemeMode.dark,
                                        );
                                      },
                                      activeTrackColor: colorScheme.primary,
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(
                                      CupertinoIcons.sun_max_fill,
                                      size: 20,
                                      color: isLight
                                          ? colorScheme.primary
                                          : colorScheme.onSurface.withValues(
                                              alpha: 0.3,
                                            ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Controls
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page Indicators
                  Row(
                    children: List.generate(_contents.length, (index) {
                      final isActive = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        margin: const EdgeInsets.only(right: 12),
                        height: isActive ? 36 : 8,
                        width: isActive ? 36 : 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? colorScheme.primary.withValues(alpha: 0.1)
                              : colorScheme.onSurface.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: isActive
                              ? Border.all(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                )
                              : null,
                        ),
                        child: Center(
                          child: isActive
                              ? Icon(
                                  _contents[index].icon,
                                  size: 18,
                                  color: colorScheme.primary,
                                )
                              : const SizedBox.shrink(),
                        ),
                      );
                    }),
                  ),

                  // Next/Done Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        if (_currentPage < _contents.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _completeOnboarding(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentPage == _contents.length - 1
                                ? 'Anza'
                                : 'Mbele',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _currentPage == _contents.length - 1
                                ? CupertinoIcons.checkmark_alt
                                : CupertinoIcons.arrow_right,
                            size: 18,
                          ),
                        ],
                      ),
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

  void _completeOnboarding(BuildContext context) async {
    // Navigate to Home
    await context.read<AppState>().completeOnboarding();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final IconData icon;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.icon,
  });
}
