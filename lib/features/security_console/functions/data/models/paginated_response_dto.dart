import 'package:flutter/foundation.dart';

class PaginatedResponseDto<T> {
  final List<T> data;
  final PaginationMeta meta;
  final ActivityData? activity;

  PaginatedResponseDto({
    required this.data,
    required this.meta,
    this.activity,
  });

  factory PaginatedResponseDto.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return PaginatedResponseDto<T>(
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => fromJsonT(item))
              .toList() ??
          [],
      meta: PaginationMeta.fromJson(
        json['meta'] as Map<String, dynamic>? ?? {},
      ),
      activity: json['activity'] != null
          ? ActivityData.fromJson(json['activity'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ActivityData {
  final int totalActiveValue;
  final int totalInactiveValue;

  ActivityData({
    required this.totalActiveValue,
    required this.totalInactiveValue,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(
      totalActiveValue: json['total_active_value'] as int? ?? 0,
      totalInactiveValue: json['total_inactive_value'] as int? ?? 0,
    );
  }
}

class PaginationMeta {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginationMeta({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    // Handle different pagination field formats
    final currentPage = json['currentPage'] as int? ?? 
                       json['page'] as int? ?? 
                       json['current_page'] as int? ??
                       json['pageNumber'] as int? ??
                       1;
    
    final itemsPerPage = json['itemsPerPage'] as int? ??
                        json['limit'] as int? ??
                        json['pageSize'] as int? ??
                        json['per_page'] as int? ??
                        json['size'] as int? ??
                        10;
    
    final totalItems = json['totalItems'] as int? ??
                      json['total'] as int? ??
                      json['totalCount'] as int? ??
                      json['total_count'] as int? ??
                      json['count'] as int? ??
                      0;
    
    // Calculate totalPages if not provided
    final totalPages = json['totalPages'] as int? ??
                      json['total_pages'] as int? ??
                      json['pageCount'] as int? ??
                      (totalItems > 0 ? ((totalItems / itemsPerPage).ceil()) : 1);
    
    final hasNextPage = json['hasNextPage'] as bool? ??
                       json['has_next_page'] as bool? ??
                       (currentPage < totalPages);
    
    final hasPreviousPage = json['hasPreviousPage'] as bool? ??
                           json['has_previous_page'] as bool? ??
                           (currentPage > 1);

    if (kDebugMode) {
      print('PaginationMeta parsed:');
      print('  currentPage: $currentPage');
      print('  totalPages: $totalPages');
      print('  totalItems: $totalItems');
      print('  itemsPerPage: $itemsPerPage');
      print('  hasNextPage: $hasNextPage');
      print('  hasPreviousPage: $hasPreviousPage');
    }

    return PaginationMeta(
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
      itemsPerPage: itemsPerPage,
      hasNextPage: hasNextPage,
      hasPreviousPage: hasPreviousPage,
    );
  }
}

