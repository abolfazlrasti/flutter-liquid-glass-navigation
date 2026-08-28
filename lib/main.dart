import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LiquidGlassWidgets.initialize(
    enablePerformanceMonitor: false,
  );

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

      // Smooth theme transition
      themeAnimationDuration: const Duration(milliseconds: 320),
      themeAnimationCurve: Curves.easeOutCubic,

      // LIGHT THEME
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        colorScheme: const ColorScheme.light(
          surface: Color(0xFFF5F5F7),
        ),
      ),

      // DARK THEME
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0xFF08090D),
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF08090D),
        ),
      ),

      home: NavigationDemo(
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class NavigationDemo extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const NavigationDemo({
    super.key,
    required this.onToggleTheme,
  });

  @override
  State<NavigationDemo> createState() => _NavigationDemoState();
}

class _NavigationDemoState extends State<NavigationDemo> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    _EmptyPage(),
    _EmptyPage(),
    _EmptyPage(),
    _EmptyPage(),
  ];

  void _selectTab(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // Prevent unnecessary transparent painting behind
      // the bottom navigation bar.
      extendBody: false,

      body: Stack(
        fit: StackFit.expand,
        children: [

          RepaintBoundary(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),

          Positioned(
            top: MediaQuery.paddingOf(context).top + 14,
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
          child: GlassTabBar.bottom(
            selectedIndex: _selectedIndex,
            onTabSelected: _selectTab,

            tabs: const [
              GlassTab(
                icon: Icon(
                  CupertinoIcons.chat_bubble_2,
                ),
                activeIcon: Icon(
                  CupertinoIcons.chat_bubble_2_fill,
                ),
                label: 'Chats',
              ),

              GlassTab(
                icon: Icon(
                  CupertinoIcons.person_2,
                ),
                activeIcon: Icon(
                  CupertinoIcons.person_2_fill,
                ),
                label: 'Contacts',
              ),

              GlassTab(
                icon: Icon(
                  CupertinoIcons.gear,
                ),
                activeIcon: Icon(
                  CupertinoIcons.gear_alt_fill,
                ),
                label: 'Settings',
              ),

              GlassTab(
                icon: Icon(
                  CupertinoIcons.person_crop_circle,
                ),
                activeIcon: Icon(
                  CupertinoIcons.person_crop_circle_fill,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onPressed;

  const _ThemeButton({
    required this.isDark,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(23),

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,

            width: 46,
            height: 46,

            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.82),

              borderRadius: BorderRadius.circular(23),

              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.07),
              ),

              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),

            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeInCubic,

                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: RotationTransition(
                        turns: Tween<double>(
                          begin: 0.08,
                          end: 0.0,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                  );
                },

                child: Icon(
                  isDark
                      ? CupertinoIcons.sun_max_fill
                      : CupertinoIcons.moon_fill,

                  key: ValueKey(isDark),

                  size: 21,

                  color: isDark
                      ? Colors.white
                      : const Color(0xFF202124),
                ),
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
