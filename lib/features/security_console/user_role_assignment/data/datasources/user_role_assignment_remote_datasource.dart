import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/api_config.dart';
import '../../../user_accounts/data/models/user_account_dto.dart';
import '../../../function_privileges/data/models/paginated_response_dto.dart';

abstract class UserRoleAssignmentRemoteDataSource {
  Future<PaginatedResponseDto<UserAccountDto>> getUsers({
    required int page,
    required int limit,
    String? search,
  });
}

class UserRoleAssignmentRemoteDataSourceImpl
    implements UserRoleAssignmentRemoteDataSource {
  final ApiClient apiClient;

  UserRoleAssignmentRemoteDataSourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClient(baseUrl: ApiConfig.baseUrl);

  @override
  Future<PaginatedResponseDto<UserAccountDto>> getUsers({
    required int page,
    required int limit,
    String? search,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
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
      }

      // Parse pagination metadata
      final currentPage = metaMap?['page'] as int? ?? page;
      final totalPages = metaMap?['totalPages'] as int? ?? 1;
      final totalItems = metaMap?['total'] as int? ?? 0;
      final hasNextPage = metaMap?['hasNextPage'] as bool? ?? false;
      final hasPrevPage = metaMap?['hasPrevPage'] as bool? ?? false;

      // Parse user accounts
      final users = dataList
          .map((json) => UserAccountDto.fromJson(json as Map<String, dynamic>))
          .toList();

      return PaginatedResponseDto<UserAccountDto>(
        data: users,
        meta: PaginationMeta(
          currentPage: currentPage,
          totalPages: totalPages,
          totalItems: totalItems,
          itemsPerPage: limit,
          hasNextPage: hasNextPage,
          hasPreviousPage: hasPrevPage,
        ),
      );
    } catch (e) {
      throw Exception('Failed to fetch users: ${e.toString()}');
    }
  }
}


