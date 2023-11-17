import 'package:home_shift/data/data_sources/data_source_repos/local_data_source_repo.dart';
import 'package:home_shift/domain/entities/settings.dart';
import 'package:home_shift/utils/constants/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<Settings> loadSettings() async {
    final settingsData = sharedPreferences.getString(settingsKey);
    return Settings.fromJson(settingsData);
  }

  @override
  Future<void> toggleSettings(Settings settings) async {
    await sharedPreferences.setString(
      settingsKey,
      settings.toJson(),
    );
  }
}
