import 'package:flutter/material.dart' show ThemeMode;

/// User-configurable app settings.
class AppSettings {
  const AppSettings({
    this.lessonsPerRound = 5,
    this.themeMode = ThemeMode.system,
    this.languageCode,
  });

  /// How many completed lessons make up one paid round. Editable any time;
  /// only affects rounds created after the change.
  final int lessonsPerRound;

  /// Light, dark, or follow the phone's system setting.
  final ThemeMode themeMode;

  /// 'en', 'ro' or 'ru'. Null until the user picks one, meaning: follow the
  /// phone's language when it's supported, English otherwise.
  final String? languageCode;

  AppSettings copyWith({int? lessonsPerRound, ThemeMode? themeMode, String? languageCode}) =>
      AppSettings(
        lessonsPerRound: lessonsPerRound ?? this.lessonsPerRound,
        themeMode: themeMode ?? this.themeMode,
        languageCode: languageCode ?? this.languageCode,
      );

  Map<String, dynamic> toJson() => {
        'lessonsPerRound': lessonsPerRound,
        'themeMode': themeMode.name,
        'languageCode': languageCode,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        lessonsPerRound: json['lessonsPerRound'] as int? ?? 5,
        themeMode: ThemeMode.values.firstWhere(
          (m) => m.name == json['themeMode'],
          orElse: () => ThemeMode.system,
        ),
        languageCode: json['languageCode'] as String?,
      );
}
