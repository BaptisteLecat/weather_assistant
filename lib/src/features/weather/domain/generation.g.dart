// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Generation _$$_GenerationFromJson(Map<String, dynamic> json) =>
    _$_Generation(
      id: json['id'] as String?,
      progress: json['progress'] as int,
      prompt: json['prompt'] as String,
      locationId: json['locationId'] as String?,
    );

Map<String, dynamic> _$$_GenerationToJson(_$_Generation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'progress': instance.progress,
      'prompt': instance.prompt,
      'locationId': instance.locationId,
    };
