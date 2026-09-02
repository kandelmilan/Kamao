// PATCH — apply this to your existing paginated_response.dart
//
// Your real API returns `page` (see the /dprs response you shared),
// not `pageIndex`. This one-line fallback makes the existing class work
// with both, without touching anything else about it.

import 'package:equatable/equatable.dart';

/// Generic paginated response wrapper
/// Handles pagination metadata for any list-based API response
class PaginatedResponse<T> extends Equatable {
  final List<T> items;
  final int pageIndex;
  final int totalPages;
  final int totalCount;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  const PaginatedResponse({
    required this.items,
    required this.pageIndex,
    required this.totalPages,
    required this.totalCount,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final itemsList =
        (json['items'] as List<dynamic>?)
            ?.map((item) => fromJsonT(item as Map<String, dynamic>))
            .toList() ??
        [];

    return PaginatedResponse<T>(
      items: itemsList,
      // API returns `page`, not `pageIndex` — accept either.
      pageIndex: json['pageIndex'] ?? json['page'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'items': items.map((item) => toJsonT(item)).toList(),
      'pageIndex': pageIndex,
      'totalPages': totalPages,
      'totalCount': totalCount,
      'pageSize': pageSize,
      'hasPreviousPage': hasPreviousPage,
      'hasNextPage': hasNextPage,
    };
  }

  @override
  List<Object?> get props => [
    items,
    pageIndex,
    totalPages,
    totalCount,
    pageSize,
    hasPreviousPage,
    hasNextPage,
  ];
}
