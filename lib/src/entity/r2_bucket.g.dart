// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'r2_bucket.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [R2Bucket] is to generate the code for a copyWith(...) function.
extension $R2BucketCopyWithExtension on R2Bucket {
  R2Bucket copyWith({String? name, DateTime? creationDate}) {
    return R2Bucket(
      name: name ?? this.name,
      creationDate: creationDate ?? this.creationDate,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

R2Bucket _$R2BucketFromJson(Map<String, dynamic> json) => R2Bucket(
  name: json['name'] as String,
  creationDate: json['creationDate'] == null
      ? null
      : DateTime.parse(json['creationDate'] as String),
);

Map<String, dynamic> _$R2BucketToJson(R2Bucket instance) => <String, dynamic>{
  'name': instance.name,
  'creationDate': ?instance.creationDate?.toIso8601String(),
};
