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

      // ─────────────────────────────────────────
      // LIGHT THEME
      // ─────────────────────────────────────────
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        colorScheme: const ColorScheme.light(
          surface: Color(0xFFF5F5F7),
        ),
      ),

      // ─────────────────────────────────────────
      // DARK THEME
      // ─────────────────────────────────────────
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
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  void _selectTab(int index) {
    if (_selectedIndex.value == index) return;

    _selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: Stack(
        children: [
          // ─────────────────────────────────────
          // PAGES
          // ─────────────────────────────────────
          RepaintBoundary(
            child: ValueListenableBuilder<int>(
              valueListenable: _selectedIndex,
              builder: (context, index, _) {
                return IndexedStack(
                  index: index,
                  children: const [
                    _EmptyPage(),
                    _EmptyPage(),
                    _EmptyPage(),
                    _EmptyPage(),
                  ],
                );
              },
            ),
          ),

          // ─────────────────────────────────────
          // THEME BUTTON
          // ─────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 14,
            right: 18,
            child: _ThemeButton(
              isDark: isDark,
              onPressed: widget.onToggleTheme,
            ),
          ),
        ],
      ),

      // ─────────────────────────────────────────
      // LIQUID GLASS NAVIGATION
      // ─────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: RepaintBoundary(
          child: ValueListenableBuilder<int>(
            valueListenable: _selectedIndex,
            builder: (context, selectedIndex, _) {
              return GlassTabBar.bottom(
                selectedIndex: selectedIndex,
                onTabSelected: _selectTab,
                tabs: [
                  GlassTab(
                    icon: Icon(
                      selectedIndex == 0
                          ? CupertinoIcons.chat_bubble_2_fill
                          : CupertinoIcons.chat_bubble_2,
                    ),
                    label: 'Chats',
                  ),
                  GlassTab(
                    icon: Icon(
                      selectedIndex == 1
                          ? CupertinoIcons.person_2_fill
                          : CupertinoIcons.person_2,
                    ),
                    label: 'Contacts',
                  ),
                  GlassTab(
                    icon: Icon(
                      selectedIndex == 2
                          ? CupertinoIcons.gear_alt_fill
                          : CupertinoIcons.gear,
                    ),
                    label: 'Settings',
                  ),
                  GlassTab(
                    icon: Icon(
                      selectedIndex == 3
                          ? CupertinoIcons.person_crop_circle_fill
                          : CupertinoIcons.person_crop_circle,
                    ),
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

// ───────────────────────────────────────────────
// THEME BUTTON
// ───────────────────────────────────────────────

class _ThemeButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onPressed;

  const _ThemeButton({
    required this.isDark,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.06),
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.12)
                  : Colors.black.withOpacity(0.08),
            ),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: RotationTransition(
                    turns: Tween<double>(
                      begin: 0.15,
                      end: 0,
                    ).animate(animation),
                    child: child,
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
    );
  }
}

// ───────────────────────────────────────────────
// EMPTY PAGE
// ───────────────────────────────────────────────

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