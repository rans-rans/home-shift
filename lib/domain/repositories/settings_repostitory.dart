import 'package:home_shift/domain/entities/settings.dart';

abstract class SettingsRepository {
  Future<Settings> loadSettings();
  Future<void> toggleSettings(Settings settings);
}
