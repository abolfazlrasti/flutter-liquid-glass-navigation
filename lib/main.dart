import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LiquidGlassWidgets.initialize(enablePerformanceMonitor: false);

  runApp(
    LiquidGlassWidgets.wrap(
      brightnessResolver: Theme.maybeBrightnessOf,
      adaptiveQuality: true,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    HapticFeedback.selectionClick();

    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode: _themeMode,

      themeAnimationDuration: const Duration(milliseconds: 260),

      themeAnimationCurve: Curves.easeOutCubic,

      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,

        scaffoldBackgroundColor: const Color(0xFFF5F5F7),

        colorScheme: const ColorScheme.light(surface: Color(0xFFF5F5F7)),

        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,

        scaffoldBackgroundColor: const Color(0xFF08090D),

        colorScheme: const ColorScheme.dark(surface: Color(0xFF08090D)),

        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),

      home: NavigationDemo(onToggleTheme: _toggleTheme),
    );
  }
}

class NavigationDemo extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const NavigationDemo({super.key, required this.onToggleTheme});

  @override
  State<NavigationDemo> createState() => _NavigationDemoState();
}

class _NavigationDemoState extends State<NavigationDemo> {
  // ValueNotifier باعث می‌شود برای تغییر Tab
  // کل Scaffold setState نشود.
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  // صفحات فقط یک‌بار ساخته می‌شوند.
  static const List<Widget> _pages = [
    _EmptyPage(),
    _EmptyPage(),
    _EmptyPage(),
    _EmptyPage(),
  ];

  void _selectTab(int index) {
    if (_selectedIndex.value == index) return;

    HapticFeedback.selectionClick();

    _selectedIndex.value = index;
  }

  @override
  void dispose() {
    _selectedIndex.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // جلوگیری از paint اضافی پشت Navigation Bar
      extendBody: false,

      body: Stack(
        fit: StackFit.expand,
        children: [
          RepaintBoundary(
            child: ValueListenableBuilder<int>(
              valueListenable: _selectedIndex,
              builder: (context, selectedIndex, child) {
                return IndexedStack(index: selectedIndex, children: _pages);
              },
            ),
          ),

          Positioned(
            top: topPadding + 14,
            right: 18,

            child: RepaintBoundary(
              child: _ThemeButton(
                isDark: isDark,
                onPressed: widget.onToggleTheme,
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        top: false,

        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 14),

        child: RepaintBoundary(
          child: ValueListenableBuilder<int>(
            valueListenable: _selectedIndex,
            builder: (context, selectedIndex, child) {
              return GlassTabBar.bottom(
                selectedIndex: selectedIndex,

                onTabSelected: _selectTab,

                tabs: const [
                  GlassTab(
                    icon: Icon(CupertinoIcons.chat_bubble_2),

                    activeIcon: Icon(CupertinoIcons.chat_bubble_2_fill),

                    label: 'Chats',
                  ),

                  GlassTab(
                    icon: Icon(CupertinoIcons.person_2),

                    activeIcon: Icon(CupertinoIcons.person_2_fill),

                    label: 'Contacts',
                  ),

                  GlassTab(
                    icon: Icon(CupertinoIcons.gear),

                    activeIcon: Icon(CupertinoIcons.gear_alt_fill),

                    label: 'Settings',
                  ),

                  GlassTab(
                    icon: Icon(CupertinoIcons.person_crop_circle),

                    activeIcon: Icon(CupertinoIcons.person_crop_circle_fill),

                    label: 'Profile',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ThemeButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onPressed;

  const _ThemeButton({required this.isDark, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.92);

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.13)
        : Colors.black.withValues(alpha: 0.07);

    final iconColor = isDark ? Colors.white : const Color(0xFF202124);

    return Material(
      color: Colors.transparent,

      borderRadius: BorderRadius.circular(23),

      child: InkWell(
        onTap: onPressed,

        borderRadius: BorderRadius.circular(23),

        splashColor: Colors.transparent,

        highlightColor: Colors.transparent,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),

          curve: Curves.easeOutCubic,

          width: 46,
          height: 46,

          decoration: BoxDecoration(
            color: backgroundColor,

            borderRadius: BorderRadius.circular(23),

            border: Border.all(color: borderColor),

            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.045),
                      blurRadius: 16,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),

          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),

              switchInCurve: Curves.easeOutCubic,

              switchOutCurve: Curves.easeInCubic,

              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,

                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.82,
                      end: 1.0,
                    ).animate(animation),

                    child: child,
                  ),
                );
              },

              child: Icon(
                isDark ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_fill,

                key: ValueKey<bool>(isDark),

                size: 21,

                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyPage extends StatelessWidget {
  const _EmptyPage();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,

      child: const SizedBox.expand(),
    );
  }
}