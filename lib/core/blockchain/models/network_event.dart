import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Enumeration of decentralized event envelope types recognized by Fluoridian / TitheX relay.
enum NetworkEventType {
  taskCreated,
  marketplaceBid,
  bidAccepted,
  bidRejected,
  taskVerified,
  taskDisputed,
  warDeclared,
  pohHeartbeat,
}

extension NetworkEventTypeX on NetworkEventType {
  String toWireType() {
    switch (this) {
      case NetworkEventType.taskCreated:
        return 'TASK_CREATED';
      case NetworkEventType.marketplaceBid:
        return 'MARKETPLACE_BID';
      case NetworkEventType.bidAccepted:
        return 'BID_ACCEPTED';
      case NetworkEventType.bidRejected:
        return 'BID_REJECTED';
      case NetworkEventType.taskVerified:
        return 'TASK_VERIFIED';
      case NetworkEventType.taskDisputed:
        return 'TASK_DISPUTED';
      case NetworkEventType.warDeclared:
        return 'WAR_DECLARED';
      case NetworkEventType.pohHeartbeat:
        return 'POH_HEARTBEAT';
    }
  }

  static NetworkEventType fromWireType(String raw) {
    switch (raw.toUpperCase()) {
      case 'TASK_CREATED':
        return NetworkEventType.taskCreated;
      case 'MARKETPLACE_BID':
        return NetworkEventType.marketplaceBid;
      case 'BID_ACCEPTED':
        return NetworkEventType.bidAccepted;
      case 'BID_REJECTED':
        return NetworkEventType.bidRejected;
      case 'TASK_VERIFIED':
        return NetworkEventType.taskVerified;
      case 'TASK_DISPUTED':
        return NetworkEventType.taskDisputed;
      case 'WAR_DECLARED':
        return NetworkEventType.warDeclared;
      case 'POH_HEARTBEAT':
      default:
        return NetworkEventType.pohHeartbeat;
    }
  }
}

/// Event Envelope representing an off-chain/parallel-storage transaction
/// gossiped over Fluoridian / TitheX WebSocket relays and signed via mobile-vault-sdk.
/// Target Platforms: Android & Web.
class NetworkEvent {
  final String id; // SHA-256 hash of payload
  final String did; // did:nexus:...
  final NetworkEventType eventType;
  final Map<String, dynamic> payload;
  final String signature; // Ed25519 signature
  final DateTime createdAt;

  const NetworkEvent({
    required this.id,
    required this.did,
    required this.eventType,
    required this.payload,
    required this.signature,
    required this.createdAt,
  });

  /// Factory helper that computes the SHA-256 ID from the serialized JSON payload.
  factory NetworkEvent.create({
    required String did,
    required NetworkEventType eventType,
    required Map<String, dynamic> payload,
    String signature = 'placeholder_signature_ed25519',
    DateTime? createdAt,
  }) {
    final now = createdAt ?? DateTime.now().toUtc();
    final serialized = jsonEncode(payload);
    final idHash = sha256.convert(utf8.encode('$did:${eventType.toWireType()}:$serialized:${now.millisecondsSinceEpoch}')).toString();

    return NetworkEvent(
      id: idHash,
      did: did,
      eventType: eventType,
      payload: payload,
      signature: signature,
      createdAt: now,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'did': did,
    'eventType': eventType.toWireType(),
    'payload': jsonEncode(payload),
    'signature': signature,
    'createdAt': createdAt.toIso8601String(),
  };

  factory NetworkEvent.fromJson(Map<String, dynamic> json) {
    final rawPayload = json['payload'];
    final Map<String, dynamic> parsedPayload = rawPayload is String
        ? (jsonDecode(rawPayload) as Map<String, dynamic>)
        : (rawPayload as Map<String, dynamic>);

    return NetworkEvent(
      id: json['id'] as String,
      did: json['did'] as String,
      eventType: NetworkEventTypeX.fromWireType(json['eventType'] as String? ?? ''),
      payload: parsedPayload,
      signature: json['signature'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
