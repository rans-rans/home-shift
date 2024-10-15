import 'package:home_shift/domain/entities/settings.dart';

abstract class LocalDataSource {
  Future<Settings> loadSettings();
  Future<void> toggleSettings(Settings settings);
}
