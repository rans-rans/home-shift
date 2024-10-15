import 'package:home_shift/data/data_sources/data_source_repos/local_data_source_repo.dart';
import 'package:home_shift/domain/entities/settings.dart';
import 'package:home_shift/domain/repositories/settings_repostitory.dart';

class SettingsRepoImpl implements SettingsRepository {
  final LocalDataSource localDataSource;

  SettingsRepoImpl({
    required this.localDataSource,
  });

  @override
  Future<Settings> loadSettings() {
    return localDataSource.loadSettings();
  }

  @override
  Future<void> toggleSettings(Settings settings) async {
    localDataSource.toggleSettings(settings);
  }
}
