import 'package:flutter/foundation.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_config.dart';
import '../models/module_dto.dart';

abstract class ModuleRemoteDataSource {
  Future<List<ModuleDto>> getModules();
}

class ModuleRemoteDataSourceImpl implements ModuleRemoteDataSource {
  final ApiClient apiClient;

  ModuleRemoteDataSourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ??
            ApiClient(baseUrl: ApiConfig.baseUrl);

  @override
  Future<List<ModuleDto>> getModules() async {
    try {
      final response = await apiClient.get('/api/modules');

      if (kDebugMode) {
        print('Modules API Response: $response');
      }

      // Handle different response formats
      List<dynamic>? modulesList;

      if (response.containsKey('data') && response['data'] is List) {
        modulesList = response['data'] as List<dynamic>;
      } else if (response.containsKey('modules') && response['modules'] is List) {
        modulesList = response['modules'] as List<dynamic>;
      } else if (response.containsKey('results') && response['results'] is List) {
        modulesList = response['results'] as List<dynamic>;
      } else {
        // Try to find any array in the response
        for (var key in response.keys) {
          final value = response[key];
          if (value is List) {
            modulesList = value;
            break;
          }
        }
      }

      if (modulesList == null) {
        if (kDebugMode) {
          print('No modules list found in response');
        }
        return [];
      }

      return modulesList
          .map((json) => ModuleDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching modules: $e');
      }
      throw Exception('Failed to fetch modules: ${e.toString()}');
    }
  }
}
