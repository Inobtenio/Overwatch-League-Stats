import 'package:json_annotation/json_annotation.dart';
part 'schedule.g.dart';

@JsonSerializable()
class Schedule extends Object with _$ScheduleSerializerMixin {
  final List<Map<String, dynamic>> matches;

  Schedule({this.matches});

  factory Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);
}
