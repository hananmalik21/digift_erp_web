import 'package:flutter/foundation.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_config.dart';
import '../models/job_role_dto.dart';
import '../models/create_job_role_request_dto.dart';
import '../models/update_job_role_request_dto.dart';
import '../../../function_privileges/data/models/paginated_response_dto.dart';

abstract class JobRoleRemoteDataSource {
  Future<PaginatedResponseDto<JobRoleDto>> getJobRoles({
    required int page,
    required int limit,
    String? search,
    String? department,
    String? status,
  });
  Future<Map<String, dynamic>> createJobRole(CreateJobRoleRequestDto request);
  Future<Map<String, dynamic>> updateJobRole(int id, UpdateJobRoleRequestDto request);
  Future<void> deleteJobRole(int id);
}

class JobRoleRemoteDataSourceImpl implements JobRoleRemoteDataSource {
  final ApiClient apiClient;

  JobRoleRemoteDataSourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClient(baseUrl: ApiConfig.baseUrl);

  @override
  Future<PaginatedResponseDto<JobRoleDto>> getJobRoles({
    required int page,
    required int limit,
    String? search,
    String? department,
    String? status,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (search != null && search.isNotEmpty) {
      queryParams['jobRoleName'] = search;
    }
    
    if (department != null && department.isNotEmpty && department != 'All') {
      queryParams['department'] = department;
    }
    
    if (status != null && status.isNotEmpty && status != 'All' && status != 'All Status') {
      queryParams['status'] = status.toUpperCase();
    }

    if (kDebugMode) {
      print('GET /api/job-roles');
      print('Query Parameters: $queryParams');
    }

    try {
      final response = await apiClient.get(
        '/api/job-roles',
        queryParameters: queryParams,
      );

      if (kDebugMode) {
        print('Job Roles API Response: $response');
      }

      // Handle different response formats
      List<dynamic>? dataList;
      Map<String, dynamic>? metaMap;

      if (response.containsKey('data') && response['data'] is List) {
        dataList = response['data'] as List<dynamic>;
      } else if (response.containsKey('jobRoles') && response['jobRoles'] is List) {
        dataList = response['jobRoles'] as List<dynamic>;
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
        if (kDebugMode) {
          print('No job roles list found in response');
        }
        return PaginatedResponseDto<JobRoleDto>(
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

      return PaginatedResponseDto<JobRoleDto>(
        data: dataList
            .map((json) => JobRoleDto.fromJson(json as Map<String, dynamic>))
            .toList(),
        meta: PaginationMeta.fromJson(metaMap),
        activity: response['activity'] != null
            ? ActivityData.fromJson(response['activity'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching job roles: $e');
      }
      throw Exception('Failed to fetch job roles: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> createJobRole(CreateJobRoleRequestDto request) async {
    try {
      final response = await apiClient.post(
        '/api/job-roles',
        body: request.toJson(),
      );

      if (kDebugMode) {
        print('Create Job Role API Response: $response');
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating job role: $e');
      }
      throw Exception('Failed to create job role: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> updateJobRole(int id, UpdateJobRoleRequestDto request) async {
    try {
      final response = await apiClient.put(
        '/api/job-roles/$id',
        body: request.toJson(),
      );

      if (kDebugMode) {
        print('Update Job Role API Response: $response');
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating job role: $e');
      }
      throw Exception('Failed to update job role: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteJobRole(int id) async {
    try {
      await apiClient.delete('/api/job-roles/$id');

      if (kDebugMode) {
        print('Delete Job Role API Success: Job role $id deleted');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting job role: $e');
      }
      throw Exception('Failed to delete job role: ${e.toString()}');
    }
  }
}
