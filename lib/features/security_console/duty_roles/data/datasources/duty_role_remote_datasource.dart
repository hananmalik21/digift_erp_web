import 'package:flutter/foundation.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_config.dart';
import '../models/create_duty_role_request_dto.dart';
import '../models/update_duty_role_request_dto.dart';
import '../models/duty_role_dto.dart';
import '../../../function_privileges/data/models/paginated_response_dto.dart';

abstract class DutyRoleRemoteDataSource {
  Future<PaginatedResponseDto<DutyRoleDto>> getDutyRoles({
    required int page,
    required int limit,
    String? search,
    int? moduleId,
    String? status,
  });
  Future<DutyRoleDto?> getDutyRoleById(int id);
  Future<Map<String, dynamic>> createDutyRole(CreateDutyRoleRequestDto request);
  Future<Map<String, dynamic>> updateDutyRole(int id, UpdateDutyRoleRequestDto request);
  Future<void> deleteDutyRole(int id);
}

class DutyRoleRemoteDataSourceImpl implements DutyRoleRemoteDataSource {
  final ApiClient apiClient;

  DutyRoleRemoteDataSourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClient(baseUrl: ApiConfig.baseUrl);

  @override
  Future<PaginatedResponseDto<DutyRoleDto>> getDutyRoles({
    required int page,
    required int limit,
    String? search,
    int? moduleId,
    String? status,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (search != null && search.isNotEmpty) {
      queryParams['dutyRoleName'] = search;
    }
    
    if (moduleId != null) {
      queryParams['moduleId'] = moduleId.toString();
    }
    
    if (status != null && status.isNotEmpty && status != 'All' && status != 'All Status') {
      queryParams['status'] = status.toUpperCase();
    }

    try {
      final response = await apiClient.get(
        '/api/duty-roles',
        queryParameters: queryParams,
      );

      // Handle different response formats
      List<dynamic>? dataList;
      Map<String, dynamic>? metaMap;

      if (response.containsKey('data') && response['data'] is List) {
        dataList = response['data'] as List<dynamic>;
      } else if (response.containsKey('dutyRoles') && response['dutyRoles'] is List) {
        dataList = response['dutyRoles'] as List<dynamic>;
      } else if (response.containsKey('results') && response['results'] is List) {
        dataList = response['results'] as List<dynamic>;
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

      if (dataList == null) {
        return PaginatedResponseDto<DutyRoleDto>(
          data: [],
          meta: PaginationMeta(
            currentPage: page,
            totalPages: 1,
            totalItems: 0,
            itemsPerPage: limit,
            hasNextPage: false,
            hasPreviousPage: false,
          ),
        );
      }

      // Extract meta information
      if (response.containsKey('meta')) {
        metaMap = response['meta'] as Map<String, dynamic>;
      } else if (response.containsKey('pagination')) {
        metaMap = response['pagination'] as Map<String, dynamic>;
      } else {
        // Create default meta from response or calculate
        final totalItems = response['total'] as int? ?? 
                          response['totalItems'] as int? ?? 
                          response['totalCount'] as int? ?? 
                          dataList.length;
        final totalPages = (totalItems / limit).ceil();
        
        metaMap = {
          'currentPage': page,
          'totalPages': totalPages,
          'totalItems': totalItems,
          'itemsPerPage': limit,
          'hasNextPage': page < totalPages,
          'hasPreviousPage': page > 1,
        };
      }

      return PaginatedResponseDto<DutyRoleDto>(
        data: dataList
            .map((json) => DutyRoleDto.fromJson(json as Map<String, dynamic>))
            .toList(),
        meta: PaginationMeta.fromJson(metaMap),
        activity: response['activity'] != null
            ? ActivityData.fromJson(response['activity'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      throw Exception('Failed to fetch duty roles: ${e.toString()}');
    }
  }

  @override
  Future<DutyRoleDto?> getDutyRoleById(int id) async {
    try {
      final response = await apiClient.get('/api/duty-roles/$id');

      if (response.containsKey('data') && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return DutyRoleDto.fromJson(data);
      } else if (response.containsKey('duty_role_id') || 
                 response.containsKey('dutyRoleId') || 
                 response.containsKey('id')) {
        return DutyRoleDto.fromJson(response);
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to fetch duty role: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> createDutyRole(CreateDutyRoleRequestDto request) async {
    try {
      final response = await apiClient.post(
        '/api/duty-roles',
        body: request.toJson(),
      );

      return response;
    } catch (e) {
      throw Exception('Failed to create duty role: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> updateDutyRole(int id, UpdateDutyRoleRequestDto request) async {
    try {
      final response = await apiClient.put(
        '/api/duty-roles/$id',
        body: request.toJson(),
      );

      return response;
    } catch (e) {
      throw Exception('Failed to update duty role: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteDutyRole(int id) async {
    try {
      await apiClient.delete('/api/duty-roles/$id');
    } catch (e) {
      throw Exception('Failed to delete duty role: ${e.toString()}');
    }
  }
}
