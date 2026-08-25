# Flutter Liquid Glass Navigation 🌊

A modern **Liquid Glass navigation bar** built with Flutter, designed with an iOS-inspired visual style while running natively on Android and other Flutter-supported platforms.

The project focuses on creating a smooth, lightweight and visually rich glass navigation experience using the [`liquid_glass_widgets`](https://pub.dev/packages/liquid_glass_widgets) package.

## ✨ Features

* 🧊 Liquid Glass navigation bar
* 🍎 iOS-inspired visual design
* ⚡ Smooth tab transitions
* 🎯 Animated selected-state icons
* 🔘 Filled icons for the active tab
* 🌙 Dark Mode
* ☀️ Light Mode
* 🔄 Animated Light/Dark mode switching
* 📱 Android optimized
* 🖥️ Responsive Flutter layout
* ♻️ Reduced unnecessary widget rebuilds
* 🎨 Minimal and modern UI
* 📳 Haptic feedback support
* 🧩 Easy to customize and extend

## 🎨 Navigation

The navigation bar contains four sections:

* **Chats**
* **Contacts**
* **Settings**
* **Profile**

The selected item automatically switches to its filled icon variant.

For example:

```text
Chats      → chat_bubble_2_fill
Contacts   → person_2_fill
Settings   → gear_alt_fill
Profile    → person_crop_circle_fill
```

## 🧊 Liquid Glass

The glass effect is provided by the `liquid_glass_widgets` package.

The project intentionally avoids stacking additional `BackdropFilter` effects on top of the library's Glass components. This helps reduce unnecessary GPU workload and keeps the implementation simple.

## 🌗 Light & Dark Mode

The application supports both Light and Dark themes.

### Dark Mode

```text
#08090D
```

### Light Mode

```text
#F5F5F7
```

A theme button is placed in the top-right corner of the interface.

Tapping the button switches between:

```text
☀️ Light Mode
🌙 Dark Mode
```

The icon transition is animated to provide a smoother experience.

## ⚡ Performance

The project is designed with Flutter performance in mind.

Some of the techniques used include:

* `RepaintBoundary`
* `ValueNotifier`
* `ValueListenableBuilder`
* `const` widgets where possible
* `IndexedStack`
* Adaptive quality provided by `liquid_glass_widgets`
* Avoiding unnecessary nested blur filters

The goal is to keep the interface responsive while rendering the glass effect.

> Actual performance depends on the device GPU, screen resolution, refresh rate and Flutter rendering environment.

## 🏗️ Architecture

The project uses a simple structure:

```text
MyApp
 └── NavigationDemo
      ├── Page content
      ├── Theme button
      └── GlassTabBar
           ├── Chats
           ├── Contacts
           ├── Settings
           └── Profile
```

The selected navigation index is managed using:

```dart
ValueNotifier<int>
```

This allows the navigation bar to update without unnecessarily rebuilding the entire application.

## 📦 Dependencies

Main dependency:

```yaml
dependencies:
  flutter:
    sdk: flutter

  liquid_glass_widgets: ^YOUR_VERSION
```

You can find the package here:

https://pub.dev/packages/liquid_glass_widgets

## 🚀 Getting Started

Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/flutter-liquid-glass-navigation.git
```

Enter the project directory:

```bash
cd flutter-liquid-glass-navigation
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

## 🎯 Design Goal

This project is **not intended to be an exact copy of Apple's implementation**.

The goal is to explore how an iOS-inspired Liquid Glass experience can be recreated in Flutter while maintaining good performance on Android devices.

The project focuses on:

**Glass + Motion + Depth + Performance**

rather than simply applying a blur effect to a container.

## 📸 Preview

Add screenshots or a screen recording here:

```markdown
![Preview](screenshots/preview.png)
```

## 🛠️ Customization

You can easily customize:

* Navigation items
* Icons
* Labels
* Background colors
* Light/Dark themes
* Glass appearance
* Navigation spacing
* Animation behavior

For example:

```dart
GlassTab(
  icon: const Icon(CupertinoIcons.chat_bubble_2),
  label: 'Chats',
)
```

## ⚠️ Notes

This project is experimental and focused on UI/UX exploration.

The Liquid Glass effect and rendering performance may vary depending on:

* Android device
* GPU
* Display resolution
* Refresh rate
* Flutter version
* Rendering backend

For the best experience, test the application on a physical device rather than relying only on an emulator.

## 📄 License

This project is available under the MIT License.

See [`LICENSE`](LICENSE) for more information.

---

### ⭐ If you find this project useful

Feel free to star the repository, experiment with the implementation, and improve the design.

Built with ❤️ and Flutter.
