import 'dart:typed_data';

/// Entity categories understood by the Fluoderpod GPU ingest path.
enum FluoderpodEntityType {
  task(1),
  player(2),
  guildHub(3),
  trap(4);

  const FluoderpodEntityType(this.code);
  final int code;
}

/// A single world entity, packed into 64 bytes for GPU buffer ingestion.
class EntityPacket {
  const EntityPacket({
    required this.id,
    required this.x,
    required this.y,
    this.z = 0,
    required this.type,
    this.status = 0,
    this.faction = 0,
    this.bountyMicro = 0,
  });

  final String id;

  /// Longitude / normalized world X.
  final double x;

  /// Latitude / normalized world Y.
  final double y;

  /// Elevation / world Z.
  final double z;
  final FluoderpodEntityType type;
  final int status;
  final int faction;

  /// Bounty in micro-units (value * 1e6).
  final int bountyMicro;
}

/// Packs [EntityPacket]s into a flat little-endian byte buffer.
///
/// Layout (64 bytes):
/// * 0..7   float64 x
/// * 8..15  float64 y
/// * 16..23 float64 z
/// * 24..27 uint32 type
/// * 28..31 uint32 status
/// * 32..35 uint32 faction
/// * 36..43 uint64 bounty (written as two uint32 halves; `setUint64` is
///          unsupported by dart2js, and this keeps Web builds portable)
/// * 44..63 20-byte truncated id hash
class EntityPacketEncoder {
  EntityPacketEncoder._();

  static const int packetSize = 64;
  static const int _idHashLength = 20;

  static Uint8List encodeBatch(List<EntityPacket> entities) {
    final buffer = Uint8List(entities.length * packetSize);
    final data = ByteData.sublistView(buffer);
    for (var i = 0; i < entities.length; i++) {
      _write(data, buffer, i * packetSize, entities[i]);
    }
    return buffer;
  }

  static void _write(
    ByteData data,
    Uint8List buffer,
    int o,
    EntityPacket e,
  ) {
    data.setFloat64(o + 0, e.x, Endian.little);
    data.setFloat64(o + 8, e.y, Endian.little);
    data.setFloat64(o + 16, e.z, Endian.little);
    data.setUint32(o + 24, e.type.code, Endian.little);
    data.setUint32(o + 28, e.status, Endian.little);
    data.setUint32(o + 32, e.faction, Endian.little);
    final bounty = e.bountyMicro < 0 ? 0 : e.bountyMicro;
    data.setUint32(o + 36, bounty % 0x100000000, Endian.little);
    data.setUint32(o + 40, bounty ~/ 0x100000000, Endian.little);
    _writeIdHash(buffer, o + 44, e.id);
  }

  /// Deterministic 20-byte FNV-1a derived fingerprint of [id].
  static void _writeIdHash(Uint8List out, int offset, String id) {
    var h = 0x811c9dc5;
    for (var i = 0; i < _idHashLength; i++) {
      for (final c in id.codeUnits) {
        h ^= c;
        h = (h * 0x01000193) & 0xFFFFFFFF;
      }
      h ^= i;
      h = (h * 0x01000193) & 0xFFFFFFFF;
      out[offset + i] = h & 0xFF;
    }
  }
}
