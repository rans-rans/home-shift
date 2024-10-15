import "package:flutter/material.dart";
import "package:home_shift/data/data_sources/local_data_sources/local_data_source_impl.dart";
import "package:home_shift/data/data_sources/remote_data_sources/api/api_client.dart";
import "package:home_shift/data/data_sources/remote_data_sources/remote_data_source_repo/remote_data_source_impl.dart";
import "package:home_shift/data/repositories/settings_repo_impl.dart";
import "package:home_shift/data/repositories/wallpaper_repo_impl.dart";
import "package:home_shift/domain/use_cases/download_image_use_case.dart";
import "package:home_shift/domain/use_cases/get_image_bytes_use_case.dart";
import "package:home_shift/domain/use_cases/get_image_use_case.dart";
import "package:home_shift/domain/use_cases/load_settings_use_case.dart";
import "package:home_shift/domain/use_cases/toggle_settings_use_case.dart";

import "package:home_shift/presentation/provider/settings_provider.dart";
import "package:home_shift/presentation/provider/wallpaper_provider.dart";
import "package:http/http.dart" as http;
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

class ProviderInjector extends StatelessWidget {
  final Widget child;
  final SharedPreferences sharedPrefs;
  const ProviderInjector({
    required this.child,
    required this.sharedPrefs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final remoteDataSource = RemoteDataSourceImpl(
      apiClient: ApiClient(httpClient: http.Client()),
    );
    final localDataSource = LocalDataSourceImpl(sharedPreferences: sharedPrefs);

    final wallpaperRespository = WallpaperRepoImpl(remoteDataSource: remoteDataSource);
    final settingsRepository = SettingsRepoImpl(localDataSource: localDataSource);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(
            toggleSettingsUseCase: ToggleSettingsUseCase(
              settingsRepository: settingsRepository,
            ),
            loadSettingsUseCase: LoadSettingsUseCase(
              settingsRepository: settingsRepository,
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => WallpaperProvider(
            getImageDataUseCase: GetImageDataUseCase(
              wallpaperRepository: wallpaperRespository,
            ),
            downloadImageUseCase: DownloadImageUseCase(
              wallpaperRepository: wallpaperRespository,
            ),
            getImageBytesUseCase:
                GetImageBytesUseCase(wallpaperRepository: wallpaperRespository),
          ),
        ),
      ],
      child: child,
    );
  }
}
