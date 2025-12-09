import 'package:flutter/foundation.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_config.dart';
import '../models/function_dto.dart';
import '../models/paginated_response_dto.dart';

abstract class FunctionRemoteDataSource {
  Future<PaginatedResponseDto<FunctionDto>> getFunctions({
    required int page,
    required int limit,
    String? search,
    String? module,
    int? moduleId,
    String? status,
    Map<String, String>? dynamicFilters,
  });

  Future<FunctionDto> createFunction({
    required int moduleId,
    required String functionCode,
    required String functionName,
    required String description,
    required String status,
    required String createdBy,
  });

  Future<FunctionDto> updateFunction({
    required String id,
    required String functionName,
    required String description,
    required String status,
    required String updatedBy,
    int? moduleId,
  });

  Future<void> deleteFunction(String id);
}

class FunctionRemoteDataSourceImpl implements FunctionRemoteDataSource {
  final ApiClient apiClient;

  FunctionRemoteDataSourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ??
            ApiClient(baseUrl: ApiConfig.baseUrl);

  @override
  Future<PaginatedResponseDto<FunctionDto>> getFunctions({
    required int page,
    required int limit,
    String? search,
    String? module,
    int? moduleId,
    String? status,
    Map<String, String>? dynamicFilters,
  }) async {

    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    // If dynamic filters are provided, use them instead of generic search
    if (dynamicFilters != null && dynamicFilters.isNotEmpty) {
      queryParams.addAll(dynamicFilters);
    } else if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    
    // Use moduleId if provided, otherwise fall back to module name
    if (moduleId != null) {
      queryParams['moduleId'] = moduleId.toString();
    } else if (module != null && module.isNotEmpty && module != 'All Modules') {
      queryParams['module'] = module;
    }
    // Only add status if it's not already in dynamicFilters
    if (status != null && status.isNotEmpty && status != 'All Status') {
      if (dynamicFilters == null || !dynamicFilters.containsKey('status')) {
        queryParams['status'] = status;
      }
    }

    try {
      final response = await apiClient.get(
        '/api/functions',
        queryParameters: queryParams,
      );

      // Debug: Log the actual response structure
      if (kDebugMode) {
        print('API Response keys: ${response.keys.toList()}');
        print('Full API Response: $response');
        if (response.containsKey('data') && (response['data'] as List).isNotEmpty) {
          print('First data item keys: ${(response['data'] as List).first.keys.toList()}');
          print('First data item: ${(response['data'] as List).first}');
        }
        if (response.containsKey('meta')) {
          print('Meta data: ${response['meta']}');
        }
        if (response.containsKey('pagination')) {
          print('Pagination data: ${response['pagination']}');
        }
      }

      // Handle different response formats
      // Format 1: { data: [...], meta: {...} }
      // Format 2: { data: [...], pagination: {...} }
      // Format 3: { data: [...], total, page, limit, totalPages } (pagination at root)
      // Format 4: { functions: [...], pagination: {...} }
      // Format 5: { results: [...], total: ..., page: ... }

      List<dynamic>? dataList;
      Map<String, dynamic>? metaMap;

      // First, find the data array
      if (response.containsKey('data') && response['data'] is List) {
        dataList = response['data'] as List<dynamic>?;
      } else if (response.containsKey('functions') && response['functions'] is List) {
        dataList = response['functions'] as List<dynamic>?;
      } else if (response.containsKey('results') && response['results'] is List) {
        dataList = response['results'] as List<dynamic>?;
      } else {
        // Try to find any array in the response
        for (var key in response.keys) {
          final value = response[key];
          if (value is List) {
            dataList = value;
            break;
          }
        }
      }

      // Now find pagination metadata
      if (response.containsKey('meta') && response['meta'] is Map) {
        // Standard format: { data: [...], meta: {...} }
        metaMap = response['meta'] as Map<String, dynamic>?;
      } else if (response.containsKey('pagination') && response['pagination'] is Map) {
        // Alternative format: { data: [...], pagination: {...} }
        metaMap = response['pagination'] as Map<String, dynamic>?;
      } else if (response.containsKey('totalPages') || 
                 response.containsKey('total_pages') ||
                 response.containsKey('total') ||
                 response.containsKey('page')) {
        // Pagination info at root level: { data: [...], total, page, limit, totalPages }
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
        // No pagination info found, calculate from data
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

      // Extract activity data if present
      Map<String, dynamic>? activityData;
      if (response.containsKey('activity') && response['activity'] is Map) {
        activityData = response['activity'] as Map<String, dynamic>;
      }

      // Create a properly formatted response
      final formattedResponse = {
        'data': dataList ?? [],
        'meta': metaMap ?? {
          'currentPage': page,
          'totalPages': 1,
          'totalItems': 0,
          'itemsPerPage': limit,
          'hasNextPage': false,
          'hasPreviousPage': false,
        },
        if (activityData != null) 'activity': activityData,
      };

      return PaginatedResponseDto<FunctionDto>.fromJson(
        formattedResponse,
        (json) => FunctionDto.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Failed to fetch functions: ${e.toString()}');
    }
  }

  @override
  Future<FunctionDto> createFunction({
    required int moduleId,
    required String functionCode,
    required String functionName,
    required String description,
    required String status,
    required String createdBy,
  }) async {
    try {
      final requestBody = {
        'moduleId': moduleId,
        'functionCode': functionCode,
        'functionName': functionName,
        'description': description,
        'status': status.toUpperCase(), // Ensure ACTIVE/INACTIVE
        'createdBy': createdBy,
      };

      if (kDebugMode) {
        print('Creating function with body: $requestBody');
      }

      final response = await apiClient.post(
        '/api/functions',
        body: requestBody,
      );

      if (kDebugMode) {
        print('Create function response: $response');
      }

      return FunctionDto.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create function: ${e.toString()}');
    }
  }

  @override
  Future<FunctionDto> updateFunction({
    required String id,
    required String functionName,
    required String description,
    required String status,
    required String updatedBy,
    int? moduleId,
  }) async {
    try {
      final requestBody = {
        'functionName': functionName,
        'description': description,
        'status': status.toUpperCase(), // Ensure ACTIVE/INACTIVE
        'updatedBy': updatedBy,
        if (moduleId != null) 'moduleId': moduleId,
      };

      if (kDebugMode) {
        print('Updating function $id with body: $requestBody');
      }

      final response = await apiClient.put(
        '/api/functions/$id',
        body: requestBody,
      );

      if (kDebugMode) {
        print('Update function response: $response');
      }

      return FunctionDto.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update function: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteFunction(String id) async {
    try {
      if (kDebugMode) {
        print('Deleting function with id: $id');
      }

      await apiClient.delete('/api/functions/$id');

      if (kDebugMode) {
        print('Function deleted successfully');
      }
    } catch (e) {
      throw Exception('Failed to delete function: ${e.toString()}');
    }
  }
}

