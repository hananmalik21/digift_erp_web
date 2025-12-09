import 'package:flutter/foundation.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_config.dart';
import '../models/function_privilege_dto.dart';
import '../models/paginated_response_dto.dart';

abstract class FunctionPrivilegeRemoteDataSource {
  Future<PaginatedResponseDto<FunctionPrivilegeDto>> getFunctionPrivileges({
    required int page,
    required int limit,
    String? search,
    int? moduleId,
    int? operationId,
    String? status,
  });

  Future<FunctionPrivilegeDto> getFunctionPrivilegeById(String id);
  Future<FunctionPrivilegeDto> createFunctionPrivilege({
    required String privilegeCode,
    required String privilegeName,
    required String description,
    required int moduleId,
    required String functionId,
    required int operationId,
    required String status,
    required String createdBy,
  });
  Future<FunctionPrivilegeDto> updateFunctionPrivilege({
    required String id,
    required String privilegeName,
    required String description,
    required int moduleId,
    required String functionId,
    required int operationId,
    required String status,
    required String updatedBy,
  });
  Future<void> deleteFunctionPrivilege(String id);
}

class FunctionPrivilegeRemoteDataSourceImpl implements FunctionPrivilegeRemoteDataSource {
  final ApiClient apiClient;

  FunctionPrivilegeRemoteDataSourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ??
            ApiClient(baseUrl: ApiConfig.baseUrl);

  @override
  Future<PaginatedResponseDto<FunctionPrivilegeDto>> getFunctionPrivileges({
    required int page,
    required int limit,
    String? search,
    int? moduleId,
    int? operationId,
    String? status,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    
    if (moduleId != null) {
      queryParams['moduleId'] = moduleId.toString();
    }
    
    if (operationId != null) {
      queryParams['operationId'] = operationId.toString();
    }
    
    if (status != null && status.isNotEmpty && status != 'All Status') {
      queryParams['status'] = status.toUpperCase();
    }

    if (kDebugMode) {
      print('GET /api/function-privileges');
      print('Query Parameters: $queryParams');
    }

    try {
      final response = await apiClient.get(
        '/api/function-privileges',
        queryParameters: queryParams,
      );

      if (kDebugMode) {
        print('Function Privileges API Response: $response');
      }

      // Handle different response formats
      List<dynamic>? dataList;
      Map<String, dynamic>? metaMap;

      if (response.containsKey('data') && response['data'] is List) {
        dataList = response['data'] as List<dynamic>;
      } else if (response.containsKey('privileges') && response['privileges'] is List) {
        dataList = response['privileges'] as List<dynamic>;
      } else if (response.containsKey('results') && response['results'] is List) {
        dataList = response['results'] as List<dynamic>;
      } else {
        for (var key in response.keys) {
          final value = response[key];
          if (value is List) {
            dataList = value;
            break;
          }
        }
      }

      if (response.containsKey('meta') && response['meta'] is Map) {
        metaMap = response['meta'] as Map<String, dynamic>;
      } else if (response.containsKey('pagination') && response['pagination'] is Map) {
        metaMap = response['pagination'] as Map<String, dynamic>;
      } else if (response.containsKey('totalPages') || 
                 response.containsKey('total_pages') ||
                 response.containsKey('total') ||
                 response.containsKey('page')) {
        final totalItems = response['total'] as int? ??
                          response['totalItems'] as int? ??
                          response['total_count'] as int? ??
                          dataList?.length ?? 0;
        
        final currentPageFromResponse = response['page'] as int? ??
                                       response['currentPage'] as int? ??
                                       response['current_page'] as int? ??
                                       page;
        
        final itemsPerPageFromResponse = response['limit'] as int? ??
                                        response['itemsPerPage'] as int? ??
                                        response['per_page'] as int? ??
                                        response['pageSize'] as int? ??
                                        limit;
        
        final totalPagesFromResponse = response['totalPages'] as int? ??
                                      response['total_pages'] as int? ??
                                      response['pageCount'] as int? ??
                                      (totalItems > 0 ? ((totalItems / itemsPerPageFromResponse).ceil()) : 1);

        metaMap = {
          'currentPage': currentPageFromResponse,
          'totalPages': totalPagesFromResponse,
          'totalItems': totalItems,
          'itemsPerPage': itemsPerPageFromResponse,
          'hasNextPage': currentPageFromResponse < totalPagesFromResponse,
          'hasPreviousPage': currentPageFromResponse > 1,
        };
      } else {
        final dataLength = dataList?.length ?? 0;
        final calculatedTotalPages = dataLength > 0 ? ((dataLength / limit).ceil()) : 1;
        
        metaMap = {
          'currentPage': page,
          'totalPages': calculatedTotalPages,
          'totalItems': dataLength,
          'itemsPerPage': limit,
          'hasNextPage': page < calculatedTotalPages,
          'hasPreviousPage': page > 1,
        };
      }

      // metaMap is guaranteed to be non-null at this point due to all code paths above
      final formattedResponse = {
        'data': dataList ?? [],
        'meta': metaMap,
        // Include activity object from API response if present
        if (response.containsKey('activity')) 'activity': response['activity'],
      };

      if (kDebugMode) {
        print('Formatted Response with Activity: ${formattedResponse['activity']}');
      }

      return PaginatedResponseDto<FunctionPrivilegeDto>.fromJson(
        formattedResponse,
        (json) => FunctionPrivilegeDto.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Failed to fetch function privileges: ${e.toString()}');
    }
  }

  @override
  Future<FunctionPrivilegeDto> getFunctionPrivilegeById(String id) async {
    try {
      final response = await apiClient.get('/api/function-privileges/$id');
      return FunctionPrivilegeDto.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch function privilege: ${e.toString()}');
    }
  }

  @override
  Future<FunctionPrivilegeDto> createFunctionPrivilege({
    required String privilegeCode,
    required String privilegeName,
    required String description,
    required int moduleId,
    required String functionId,
    required int operationId,
    required String status,
    required String createdBy,
  }) async {
    try {
      // Convert functionId to int if it's a numeric string, otherwise keep as string
      final functionIdValue = int.tryParse(functionId) ?? functionId;
      
      final requestBody = {
        'privilegeCode': privilegeCode,
        'privilegeName': privilegeName,
        'description': description,
        'moduleId': moduleId,
        'functionId': functionIdValue,
        'operationId': operationId,
        'status': status.toUpperCase(),
        'createdBy': createdBy,
      };

      if (kDebugMode) {
        print('Creating function privilege with body: $requestBody');
      }

      final response = await apiClient.post(
        '/api/function-privileges',
        body: requestBody,
      );

      if (kDebugMode) {
        print('Create function privilege response: $response');
      }

      return FunctionPrivilegeDto.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create function privilege: ${e.toString()}');
    }
  }

  @override
  Future<FunctionPrivilegeDto> updateFunctionPrivilege({
    required String id,
    required String privilegeName,
    required String description,
    required int moduleId,
    required String functionId,
    required int operationId,
    required String status,
    required String updatedBy,
  }) async {
    try {
      // Convert functionId to int if it's a numeric string, otherwise keep as string
      final functionIdValue = int.tryParse(functionId) ?? functionId;
      
      final requestBody = {
        'privilegeName': privilegeName,
        'description': description,
        'moduleId': moduleId,
        'functionId': functionIdValue,
        'operationId': operationId,
        'status': status.toUpperCase(),
        'updatedBy': updatedBy,
      };

      if (kDebugMode) {
        print('Updating function privilege $id with body: $requestBody');
      }

      final response = await apiClient.put(
        '/api/function-privileges/$id',
        body: requestBody,
      );

      if (kDebugMode) {
        print('Update function privilege response: $response');
      }

      return FunctionPrivilegeDto.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update function privilege: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteFunctionPrivilege(String id) async {
    try {
      if (kDebugMode) {
        print('Deleting function privilege with id: $id');
      }

      await apiClient.delete('/api/function-privileges/$id');

      if (kDebugMode) {
        print('Function privilege deleted successfully');
      }
    } catch (e) {
      throw Exception('Failed to delete function privilege: ${e.toString()}');
    }
  }
}
