import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff305cac),
      surfaceTint: Color(0xff305cac),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff7aa2f7),
      onPrimaryContainer: Color(0xff00367d),
      secondary: Color(0xff00658c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff7dcfff),
      onSecondaryContainer: Color(0xff00587a),
      tertiary: Color(0xff6c4da4),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbb9af7),
      onTertiaryContainer: Color(0xff4c2c82),
      error: Color(0xffa53750),
      onError: Color(0xffffffff),
      errorContainer: Color(0xfff7768e),
      onErrorContainer: Color(0xff6e0a29),
      surface: Color(0xfffbf8fc),
      onSurface: Color(0xff1b1b1e),
      onSurfaceVariant: Color(0xff444748),
      outline: Color(0xff747878),
      outlineVariant: Color(0xffc4c7c8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303033),
      inversePrimary: Color(0xffaec6ff),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff001a43),
      primaryFixedDim: Color(0xffaec6ff),
      onPrimaryFixedVariant: Color(0xff0c4393),
      secondaryFixed: Color(0xffc5e7ff),
      onSecondaryFixed: Color(0xff001e2d),
      secondaryFixedDim: Color(0xff7fd0ff),
      onSecondaryFixedVariant: Color(0xff004c6a),
      tertiaryFixed: Color(0xffebdcff),
      onTertiaryFixed: Color(0xff260058),
      tertiaryFixedDim: Color(0xffd4bbff),
      onTertiaryFixedVariant: Color(0xff54358a),
      surfaceDim: Color(0xffdcd9dd),
      surfaceBright: Color(0xfffbf8fc),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f3f7),
      surfaceContainer: Color(0xfff0edf1),
      surfaceContainerHigh: Color(0xffeae7eb),
      surfaceContainerHighest: Color(0xffe4e1e5),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003377),
      surfaceTint: Color(0xff305cac),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff416bbc),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003b53),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff0075a1),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff432278),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff7b5cb4),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff6e0a29),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffb8455e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffbf8fc),
      onSurface: Color(0xff111114),
      onSurfaceVariant: Color(0xff333738),
      outline: Color(0xff4f5354),
      outlineVariant: Color(0xff6a6e6e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303033),
      inversePrimary: Color(0xffaec6ff),
      primaryFixed: Color(0xff416bbc),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff2352a2),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff0075a1),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff005b7e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff7b5cb4),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff624499),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc8c6c9),
      surfaceBright: Color(0xfffbf8fc),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f3f7),
      surfaceContainer: Color(0xffeae7eb),
      surfaceContainerHigh: Color(0xffdedce0),
      surfaceContainerHighest: Color(0xffd3d1d5),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002963),
      surfaceTint: Color(0xff305cac),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff114695),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003044),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff004f6e),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff38166e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff56378d),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff5f0020),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff88213b),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffbf8fc),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff292d2d),
      outlineVariant: Color(0xff464a4a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303033),
      inversePrimary: Color(0xffaec6ff),
      primaryFixed: Color(0xff114695),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003070),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff004f6e),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff00374e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff56378d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff3f1e75),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbab8bc),
      surfaceBright: Color(0xfffbf8fc),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f0f4),
      surfaceContainer: Color(0xffe4e1e5),
      surfaceContainerHigh: Color(0xffd6d3d7),
      surfaceContainerHighest: Color(0xffc8c6c9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffaec6ff),
      surfaceTint: Color(0xffaec6ff),
      onPrimary: Color(0xff002e6b),
      primaryContainer: Color(0xff7aa2f7),
      onPrimaryContainer: Color(0xff00367d),
      secondary: Color(0xffc3e6ff),
      onSecondary: Color(0xff00344a),
      secondaryContainer: Color(0xff7dcfff),
      onSecondaryContainer: Color(0xff00587a),
      tertiary: Color(0xffd4bbff),
      onTertiary: Color(0xff3d1b72),
      tertiaryContainer: Color(0xffbb9af7),
      onTertiaryContainer: Color(0xff4c2c82),
      error: Color(0xffffb2bc),
      onError: Color(0xff660224),
      errorContainer: Color(0xfff7768e),
      onErrorContainer: Color(0xff6e0a29),
      surface: Color(0xff131316),
      onSurface: Color(0xffe4e1e5),
      onSurfaceVariant: Color(0xffc4c7c8),
      outline: Color(0xff8e9192),
      outlineVariant: Color(0xff444748),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe4e1e5),
      inversePrimary: Color(0xff305cac),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff001a43),
      primaryFixedDim: Color(0xffaec6ff),
      onPrimaryFixedVariant: Color(0xff0c4393),
      secondaryFixed: Color(0xffc5e7ff),
      onSecondaryFixed: Color(0xff001e2d),
      secondaryFixedDim: Color(0xff7fd0ff),
      onSecondaryFixedVariant: Color(0xff004c6a),
      tertiaryFixed: Color(0xffebdcff),
      onTertiaryFixed: Color(0xff260058),
      tertiaryFixedDim: Color(0xffd4bbff),
      onTertiaryFixedVariant: Color(0xff54358a),
      surfaceDim: Color(0xff131316),
      surfaceBright: Color(0xff39393c),
      surfaceContainerLowest: Color(0xff0e0e11),
      surfaceContainerLow: Color(0xff1b1b1e),
      surfaceContainer: Color(0xff1f1f22),
      surfaceContainerHigh: Color(0xff2a2a2d),
      surfaceContainerHighest: Color(0xff353438),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcfdcff),
      surfaceTint: Color(0xffaec6ff),
      onPrimary: Color(0xff002356),
      primaryContainer: Color(0xff7aa2f7),
      onPrimaryContainer: Color(0xff00163c),
      secondary: Color(0xffc3e6ff),
      onSecondary: Color(0xff002d41),
      secondaryContainer: Color(0xff7dcfff),
      onSecondaryContainer: Color(0xff003a52),
      tertiary: Color(0xffe6d5ff),
      onTertiary: Color(0xff310c67),
      tertiaryContainer: Color(0xffbb9af7),
      onTertiaryContainer: Color(0xff2b0261),
      error: Color(0xffffd1d6),
      onError: Color(0xff53001b),
      errorContainer: Color(0xfff7768e),
      onErrorContainer: Color(0xff2f000c),
      surface: Color(0xff131316),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdadddd),
      outline: Color(0xffafb2b3),
      outlineVariant: Color(0xff8d9191),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe4e1e5),
      inversePrimary: Color(0xff0e4594),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff00102e),
      primaryFixedDim: Color(0xffaec6ff),
      onPrimaryFixedVariant: Color(0xff003377),
      secondaryFixed: Color(0xffc5e7ff),
      onSecondaryFixed: Color(0xff00131e),
      secondaryFixedDim: Color(0xff7fd0ff),
      onSecondaryFixedVariant: Color(0xff003b53),
      tertiaryFixed: Color(0xffebdcff),
      onTertiaryFixed: Color(0xff19003f),
      tertiaryFixedDim: Color(0xffd4bbff),
      onTertiaryFixedVariant: Color(0xff432278),
      surfaceDim: Color(0xff131316),
      surfaceBright: Color(0xff444447),
      surfaceContainerLowest: Color(0xff07070a),
      surfaceContainerLow: Color(0xff1d1d20),
      surfaceContainer: Color(0xff28282b),
      surfaceContainerHigh: Color(0xff323235),
      surfaceContainerHighest: Color(0xff3e3d40),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffecefff),
      surfaceTint: Color(0xffaec6ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa8c2ff),
      onPrimaryContainer: Color(0xff000a23),
      secondary: Color(0xffe2f2ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff7dcfff),
      onSecondaryContainer: Color(0xff00121d),
      tertiary: Color(0xfff6ecff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffd1b6ff),
      onTertiaryContainer: Color(0xff120030),
      error: Color(0xffffebed),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffacb8),
      onErrorContainer: Color(0xff210006),
      surface: Color(0xff131316),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeef0f1),
      outlineVariant: Color(0xffc0c3c4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe4e1e5),
      inversePrimary: Color(0xff0e4594),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffaec6ff),
      onPrimaryFixedVariant: Color(0xff00102e),
      secondaryFixed: Color(0xffc5e7ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff7fd0ff),
      onSecondaryFixedVariant: Color(0xff00131e),
      tertiaryFixed: Color(0xffebdcff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffd4bbff),
      onTertiaryFixedVariant: Color(0xff19003f),
      surfaceDim: Color(0xff131316),
      surfaceBright: Color(0xff505053),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1f1f22),
      surfaceContainer: Color(0xff303033),
      surfaceContainerHigh: Color(0xff3b3b3e),
      surfaceContainerHighest: Color(0xff47464a),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
