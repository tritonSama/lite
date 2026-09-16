import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constants/enums.dart';
import '../../../core/utils/firestore_converters.dart';

part 'credential.freezed.dart';
part 'credential.g.dart';

@freezed
abstract class Credential with _$Credential {
  const factory Credential({
    required String id,
    required String ownerId,
    required CredentialType credentialType,
    required String label,
    required String storagePath,
    String? downloadUrl,
    @Default(CredentialStatus.uploaded) CredentialStatus status,
    @TimestampConverter() DateTime? expiresAt,
    @TimestampConverter() required DateTime uploadedAt,
    @TimestampConverter() DateTime? verifiedAt,
    String? verifiedBy,
    required String mimeType,
    @Default(0) int fileSizeBytes,
  }) = _Credential;

  factory Credential.fromJson(Map<String, dynamic> json) =>
      _$CredentialFromJson(json);
}
