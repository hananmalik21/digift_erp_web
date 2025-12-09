import 'package:flutter/foundation.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_config.dart';
import '../models/operation_dto.dart';

abstract class OperationRemoteDataSource {
  Future<List<OperationDto>> getOperations();
}

class OperationRemoteDataSourceImpl implements OperationRemoteDataSource {
  final ApiClient apiClient;

  OperationRemoteDataSourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ??
            ApiClient(baseUrl: ApiConfig.baseUrl);

  @override
  Future<List<OperationDto>> getOperations() async {
    try {
      final response = await apiClient.get('/api/operations');

      if (kDebugMode) {
        print('Operations API Response: $response');
      }

      // Handle different response formats
      List<dynamic>? operationsList;

      if (response.containsKey('data') && response['data'] is List) {
        operationsList = response['data'] as List<dynamic>;
      } else if (response.containsKey('operations') && response['operations'] is List) {
        operationsList = response['operations'] as List<dynamic>;
      } else if (response.containsKey('results') && response['results'] is List) {
        operationsList = response['results'] as List<dynamic>;
      } else {
        // Try to find any array in the response
        for (var key in response.keys) {
          final value = response[key];
          if (value is List) {
            operationsList = value;
            break;
          }
        }
      }

      if (operationsList == null) {
        if (kDebugMode) {
          print('No operations list found in response');
        }
        return [];
      }

      return operationsList
          .map((json) => OperationDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching operations: $e');
      }
      throw Exception('Failed to fetch operations: ${e.toString()}');
    }
  }
}
