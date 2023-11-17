import 'package:flutter/material.dart';
import 'package:home_shift/domain/entities/settings.dart';
import 'package:home_shift/domain/use_cases/load_settings_use_case.dart';
import 'package:home_shift/domain/use_cases/toggle_settings_use_case.dart';

class SettingsProvider extends ChangeNotifier {
  final LoadSettingsUseCase loadSettingsUseCase;
  final ToggleSettingsUseCase toggleSettingsUseCase;
  late Settings _settings;

  SettingsProvider({
    required this.loadSettingsUseCase,
    required this.toggleSettingsUseCase,
  });

  Settings get settings => _settings;

  Future<void> toggleSettings(Settings settings) async {
    _settings = settings;
    await toggleSettingsUseCase.execute(settings);
    notifyListeners();
  }

  Future<void> loadSettings() async {
    _settings = await loadSettingsUseCase.execute();
    notifyListeners();
  }
}
