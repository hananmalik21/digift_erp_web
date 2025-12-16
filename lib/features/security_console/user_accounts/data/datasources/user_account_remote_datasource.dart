import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_config.dart';
import '../models/user_account_dto.dart';
import '../models/create_user_account_request_dto.dart';
import '../models/update_user_account_request_dto.dart';
import '../../../function_privileges/data/models/paginated_response_dto.dart';

abstract class UserAccountRemoteDataSource {
  Future<PaginatedResponseDto<UserAccountDto>> getUsers({
    required int page,
    required int limit,
    String? search,
    String? accountStatus,
    String? accountType,
    String? username,
  });
  Future<Map<String, dynamic>> createUserAccount(CreateUserAccountRequestDto request);
  Future<Map<String, dynamic>> updateUserAccount(int userId, UpdateUserAccountRequestDto request);
  Future<UserAccountDto?> getUserAccountById(int userId);
  Future<Map<String, dynamic>> deleteUserAccount(int userId);
  Future<Map<String, dynamic>> resetPassword(int userId, String password, String updatedBy);
}

class UserAccountRemoteDataSourceImpl implements UserAccountRemoteDataSource {
  final ApiClient apiClient;

  UserAccountRemoteDataSourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClient(baseUrl: ApiConfig.baseUrl);

  @override
  Future<PaginatedResponseDto<UserAccountDto>> getUsers({
    required int page,
    required int limit,
    String? search,
    String? accountStatus,
    String? accountType,
    String? username,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    
    // Only add accountStatus if it's not null and not empty (null means "All Status" was selected)
    if (accountStatus != null && accountStatus.isNotEmpty) {
      queryParams['accountStatus'] = accountStatus.toUpperCase();
    }
    
    // Only add accountType if it's not null and not empty (null means "All Types" was selected)
    if (accountType != null && accountType.isNotEmpty) {
      queryParams['accountType'] = accountType;
    }
    
    if (username != null && username.isNotEmpty) {
      queryParams['username'] = username;
    }

    try {
      final response = await apiClient.get(
        '/api/users',
        queryParameters: queryParams,
      );

      // Handle paginated response
      List<dynamic>? dataList;
      Map<String, dynamic>? metaMap;

      if (response.containsKey('data') && response['data'] is List) {
        dataList = response['data'] as List<dynamic>;
      } else {
        return PaginatedResponseDto<UserAccountDto>(
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

      // Extract pagination meta
      if (response.containsKey('pagination')) {
        metaMap = response['pagination'] as Map<String, dynamic>;
      } else {
        final totalItems = response['total'] as int? ?? 
                          response['totalItems'] as int? ?? 
                          response['totalCount'] as int? ?? 
                          dataList.length;
        final totalPages = (totalItems / limit).ceil();
        
        metaMap = {
          'page': page,
          'limit': limit,
          'total': totalItems,
          'totalPages': totalPages,
          'hasNextPage': page < totalPages,
          'hasPrevPage': page > 1,
        };
      }

      return PaginatedResponseDto<UserAccountDto>(
        data: dataList
            .map((json) => UserAccountDto.fromJson(json as Map<String, dynamic>))
            .toList(),
        meta: PaginationMeta.fromJson(metaMap),
        activity: response['activity'] != null
            ? ActivityData.fromJson(response['activity'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      throw Exception('Failed to fetch users: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> createUserAccount(CreateUserAccountRequestDto request) async {
    try {
      final response = await apiClient.post(
        '/api/users/accounts',
        body: request.toJson(),
      );

      return response;
    } catch (e) {
      throw Exception('Failed to create user account: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> updateUserAccount(int userId, UpdateUserAccountRequestDto request) async {
    try {
      final response = await apiClient.put(
        '/api/users/$userId',
        body: request.toJson(),
      );

      return response;
    } catch (e) {
      throw Exception('Failed to update user account: ${e.toString()}');
    }
  }

  @override
  Future<UserAccountDto?> getUserAccountById(int userId) async {
    try {
      final response = await apiClient.get('/api/users/$userId');

      if (response.containsKey('data') && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return UserAccountDto.fromJson(data);
      } else if (response.containsKey('user_id') ||
                 response.containsKey('userId') ||
                 response.containsKey('id')) {
        return UserAccountDto.fromJson(response);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to fetch user account: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> deleteUserAccount(int userId) async {
    try {
      final response = await apiClient.delete('/api/users/$userId');
      return response;
    } catch (e) {
      throw Exception('Failed to delete user account: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword(int userId, String password, String updatedBy) async {
    try {
      final response = await apiClient.put(
        '/api/users/$userId/reset-password',
        body: {
          'password': password,
          'updatedBy': updatedBy,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to reset password: ${e.toString()}');
    }
  }
}
