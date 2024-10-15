import 'package:home_shift/domain/entities/settings.dart';
import 'package:home_shift/domain/repositories/settings_repostitory.dart';

class LoadSettingsUseCase {
  final SettingsRepository settingsRepository;

  LoadSettingsUseCase({required this.settingsRepository});

  Future<Settings> execute() async {
    return settingsRepository.loadSettings();
  }
}
