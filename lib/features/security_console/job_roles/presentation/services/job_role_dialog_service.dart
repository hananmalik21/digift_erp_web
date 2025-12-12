import 'package:flutter/foundation.dart';
import '../../data/models/job_role_model.dart';
import '../../data/models/job_role_dto.dart';
import '../../data/datasources/job_role_remote_datasource.dart';
import '../../data/models/create_job_role_request_dto.dart';
import '../../data/models/update_job_role_request_dto.dart';
import '../../../duty_roles/data/datasources/duty_role_remote_datasource.dart';
import '../../../duty_roles/data/models/duty_role_dto.dart';

class JobRoleDialogService {
  final JobRoleRemoteDataSource jobRoleDataSource;
  final DutyRoleRemoteDataSource dutyRoleDataSource;

  JobRoleDialogService(
    this.jobRoleDataSource, {
    DutyRoleRemoteDataSource? dutyRoleDataSource,
  }) : dutyRoleDataSource = dutyRoleDataSource ?? DutyRoleRemoteDataSourceImpl();

  /// Loads duty roles for selection
  Future<List<DutyRoleReference>> loadDutyRoles() async {
    try {
      final response = await dutyRoleDataSource.getDutyRoles(
        page: 1,
        limit: 1000,
        search: null,
        moduleId: null,
        status: null,
      );

      // Convert DutyRoleDto to DutyRoleReference
      return response.data.map((dto) {
        return DutyRoleReference(
          dutyRoleId: int.tryParse(dto.id) ?? 0,
          dutyRoleName: dto.dutyRoleName,
          roleCode: dto.roleCode,
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading duty roles: $e');
      }
      return [];
    }
  }

  /// Creates a new job role and returns the created JobRoleModel
  Future<JobRoleModel> createJobRole({
    required String jobRoleCode,
    required String jobRoleName,
    String? description,
    String? department,
    required String status,
    required String isSystemRole,
    required List<int> dutyRolesArray,
    required String createdBy,
    required List<DutyRoleReference> selectedDutyRoles,
  }) async {
    final request = CreateJobRoleRequestDto(
      jobRoleCode: jobRoleCode,
      jobRoleName: jobRoleName,
      description: description,
      department: department,
      status: status,
      isSystemRole: isSystemRole,
      dutyRolesArray: dutyRolesArray,
      createdBy: createdBy,
    );

    final response = await jobRoleDataSource.createJobRole(request);
    
    // Parse the response to create JobRoleModel
    return _parseJobRoleResponse(response, selectedDutyRoles);
  }

  /// Updates an existing job role and returns the updated JobRoleModel
  Future<JobRoleModel> updateJobRole({
    required int jobRoleId,
    required String jobRoleCode,
    required String jobRoleName,
    String? description,
    String? department,
    required String status,
    required String isSystemRole,
    required List<int> dutyRolesArray,
    required String updatedBy,
    required List<DutyRoleReference> selectedDutyRoles,
    JobRoleModel? originalRole,
  }) async {
    final request = UpdateJobRoleRequestDto(
      jobRoleCode: jobRoleCode,
      jobRoleName: jobRoleName,
      description: description,
      department: department,
      status: status,
      isSystemRole: isSystemRole,
      dutyRolesArray: dutyRolesArray,
      updatedBy: updatedBy,
    );

    final response = await jobRoleDataSource.updateJobRole(jobRoleId, request);
    
    // Parse the response to create JobRoleModel
    return _parseJobRoleResponse(response, selectedDutyRoles, originalRole: originalRole);
  }

  /// Parses API response to JobRoleModel
  JobRoleModel _parseJobRoleResponse(
    Map<String, dynamic> response,
    List<DutyRoleReference> selectedDutyRoles, {
    JobRoleModel? originalRole,
  }) {
    try {
      Map<String, dynamic>? dataToParse;
      
      // Try different response formats
      if (response.containsKey('data') && response['data'] is Map<String, dynamic>) {
        dataToParse = response['data'] as Map<String, dynamic>;
      } else if (response.containsKey('jobRole') && response['jobRole'] is Map<String, dynamic>) {
        dataToParse = response['jobRole'] as Map<String, dynamic>;
      } else if (response.containsKey('job_role_id') || response.containsKey('jobRoleId')) {
        // Response is already the job role data
        dataToParse = response;
      }
      
      if (dataToParse != null) {
        try {
          final dto = JobRoleDto.fromJson(dataToParse);
          final model = dto.toModel();
          // Ensure duty roles are set from selected ones
          return JobRoleModel(
            id: model.id,
            name: model.name,
            code: model.code,
            description: model.description,
            department: model.department,
            status: model.status,
            usersAssigned: model.usersAssigned,
            privilegesCount: model.privilegesCount,
            dutyRoles: selectedDutyRoles.map((dr) => dr.dutyRoleName).toList(),
            inheritsFrom: model.inheritsFrom,
            lastModified: model.lastModified,
          );
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing DTO: $e');
          }
        }
      }
      
      // Fallback: construct from form data
      return _createFallbackModel(response, selectedDutyRoles, originalRole);
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing job role response: $e');
      }
      // Fallback: construct from form data
      return _createFallbackModel(response, selectedDutyRoles, originalRole);
    }
  }

  /// Creates a fallback JobRoleModel from form data
  JobRoleModel _createFallbackModel(
    Map<String, dynamic> response,
    List<DutyRoleReference> selectedDutyRoles,
    JobRoleModel? originalRole,
  ) {
    // Try to extract from response first
    final jobRoleId = response['job_role_id'] as int? ?? 
                     response['jobRoleId'] as int? ?? 
                     (response['id'] is int ? response['id'] as int? : int.tryParse(response['id']?.toString() ?? '')) ??
                     (originalRole != null ? int.tryParse(originalRole.id) : null) ?? 
                     0;
    
    final jobRoleName = response['job_role_name']?.toString() ?? 
                        response['jobRoleName']?.toString() ?? 
                        response['name']?.toString() ??
                        (originalRole?.name ?? '');
    
    final jobRoleCode = response['job_role_code']?.toString() ?? 
                        response['jobRoleCode']?.toString() ?? 
                        response['code']?.toString() ??
                        (originalRole?.code ?? '');
    
    final description = response['description']?.toString() ?? 
                       (originalRole?.description ?? '');
    final department = response['department']?.toString() ?? 
                      (originalRole?.department ?? 'Unknown');
    final status = response['status']?.toString() ?? 
                  (originalRole?.status ?? 'Active');
    
    final dutyRoleNames = selectedDutyRoles.map((dr) => dr.dutyRoleName).toList();
    
    return JobRoleModel(
      id: jobRoleId.toString(),
      name: jobRoleName,
      code: jobRoleCode,
      description: description,
      department: department,
      status: status,
      usersAssigned: originalRole?.usersAssigned ?? 0,
      privilegesCount: originalRole?.privilegesCount ?? 0,
      dutyRoles: dutyRoleNames,
      inheritsFrom: originalRole?.inheritsFrom,
      lastModified: response['updated_at']?.toString() ?? 
                   response['updatedAt']?.toString() ?? 
                   response['created_at']?.toString() ?? 
                   response['createdAt']?.toString() ?? 
                   DateTime.now().toIso8601String(),
    );
  }
}
