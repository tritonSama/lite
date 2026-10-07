import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hblite/core/fluoderpod/entity_packet_encoder.dart';

void main() {
  test('encodes 64-byte little-endian packets', () {
    final bytes = EntityPacketEncoder.encodeBatch(const [
      EntityPacket(
        id: 'a',
        x: 1.5,
        y: -2.5,
        z: 3.0,
        type: FluoderpodEntityType.task,
        status: 7,
        faction: 2,
        bountyMicro: 0x1_0000_0005,
      ),
      EntityPacket(id: 'b', x: 0, y: 0, type: FluoderpodEntityType.player),
    ]);
    expect(bytes.length, 128);
    final d = ByteData.sublistView(bytes);
    expect(d.getFloat64(0, Endian.little), 1.5);
    expect(d.getFloat64(8, Endian.little), -2.5);
    expect(d.getFloat64(16, Endian.little), 3.0);
    expect(d.getUint32(24, Endian.little), 1);
    expect(d.getUint32(28, Endian.little), 7);
    expect(d.getUint32(32, Endian.little), 2);
    expect(d.getUint32(36, Endian.little), 5);
    expect(d.getUint32(40, Endian.little), 1);
    expect(d.getUint32(64 + 24, Endian.little), 2);
  });

  test('id hash is deterministic and distinct', () {
    Uint8List h(String id) => EntityPacketEncoder.encodeBatch([
          EntityPacket(id: id, x: 0, y: 0, type: FluoderpodEntityType.task),
        ]).sublist(44);
    expect(h('x'), h('x'));
    expect(h('x'), isNot(h('y')));
  });
}
