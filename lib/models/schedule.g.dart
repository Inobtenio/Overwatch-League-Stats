// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => new Schedule(
    matches: (json['matches'] as List)
        ?.map((e) => e as Map<String, dynamic>)
        ?.toList());

abstract class _$ScheduleSerializerMixin {
  List<Map<String, dynamic>> get matches;
  Map<String, dynamic> toJson() => <String, dynamic>{'matches': matches};
}
