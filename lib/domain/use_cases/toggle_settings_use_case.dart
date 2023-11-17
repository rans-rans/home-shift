import 'package:home_shift/domain/entities/settings.dart';
import 'package:home_shift/domain/repositories/settings_repostitory.dart';

class ToggleSettingsUseCase {
  final SettingsRepository settingsRepository;

  ToggleSettingsUseCase({required this.settingsRepository});

  Future<void> execute(Settings settings) async {
    await settingsRepository.toggleSettings(settings);
  }
}
