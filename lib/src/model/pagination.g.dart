// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  page: (json['page'] as num?)?.toInt(),
  size: (json['per_page'] as num?)?.toInt(),
  count: (json['count'] as num?)?.toInt(),
  totalCount: (json['total_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'page': instance.page,
      'per_page': instance.size,
      'count': instance.count,
      'total_count': instance.totalCount,
    };
