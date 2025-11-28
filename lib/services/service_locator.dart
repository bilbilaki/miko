import 'package:provider/provider.dart';
import '../providers/local_provider.dart';
import '../providers/zip_explorer_provider.dart';
import '../repositories/local_fs_repository.dart';
import 'user_data_service.dart';

/// Service locator setup for dependency injection.
///
/// This provides a centralized location to configure all providers and repositories
/// that should be available throughout the application.
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  /// Combines all providers into a single list for MultiProvider
  static List<ChangeNotifierProvider<dynamic>> getAllProviders() {
    return [...getProviders()];
  }

  static List<ChangeNotifierProvider> getProviders() {
    return [
      ChangeNotifierProvider(create: (_) => LocalProvider()),
      ChangeNotifierProvider(create: (_) => UserDataService()),
            ChangeNotifierProvider(create: (_) => ZipExplorerProvider()),

    ];
  }

  static List<Provider> getSingleProviders() {
    return [Provider<LocalFsRepository>(create: (_) => LocalFsRepository())];
  }
}
