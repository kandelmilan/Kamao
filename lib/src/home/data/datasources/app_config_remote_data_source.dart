import 'package:kamao/core/core.dart';
import '../models/app_config_model.dart';

abstract class AppConfigRemoteDataSource {
  Future<AppConfigModel> getAppConfig();
}

class AppConfigRemoteDataSourceImpl implements AppConfigRemoteDataSource {
  AppConfigRemoteDataSourceImpl(this._apiService);
  final ApiService _apiService;

  @override
  Future<AppConfigModel> getAppConfig() async {
    // NOTE: adjust to whatever your ApiEndpoints class already uses —
    // this is the '/public/app-config' path relative to your base URL.
    final response = await _apiService.get(ApiEndpoints.appConfig);
    final data = response.data['data'] as Map<String, dynamic>? ?? const {};
    return AppConfigModel.fromJson(data);
  }
}
