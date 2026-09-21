import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'nexus_waitlist_entry.freezed.dart';
part 'nexus_waitlist_entry.g.dart';

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) => timestamp?.toDate();

  @override
  Timestamp? toJson(DateTime? date) =>
      date == null ? null : Timestamp.fromDate(date);
}

@freezed
abstract class NexusWaitlistEntry with _$NexusWaitlistEntry {
  const factory NexusWaitlistEntry({
    required String userId,
    required String name,
    required String email,
    @TimestampConverter() DateTime? joinedAt,
  }) = _NexusWaitlistEntry;

  factory NexusWaitlistEntry.fromJson(Map<String, dynamic> json) =>
      _$NexusWaitlistEntryFromJson(json);
}
