# UPGRADE-01: High-Throughput Riverpod Binary Streamer
**Agent Role:** Agent Epsilon (Systems & State Specialist)  
**Target Scope:** Android & Web  
**Objective:** Stream live marketplace tasks, player locations, and faction hubs as packed binary byte buffers directly into GPU memory without rebuilding widget trees.

---

## 1. Technical Specification

### 1.1 Binary Entity Packet Protocol
Each world entity is serialized as a 64-byte continuous struct:
* `offset 0..7` (`float64`): Latitude / Normalized World X
* `offset 8..15` (`float64`): Longitude / Normalized World Y
* `offset 16..23` (`float64`): Altitude / Elevation Z
* `offset 24..27` (`uint32`): Entity Type (`1 = Task`, `2 = Player`, `3 = Guild Hub`, `4 = Trap/Combat`)
* `offset 28..31` (`uint32`): Entity Status / Sub-state flags
* `offset 32..35` (`uint32`): Faction ID (`0 = Neutral`, `1 = Cyan`, `2 = Gold`)
* `offset 36..43` (`uint64`): Bounty / Value (in micro-units)
* `offset 44..63` (`bytes20`): Truncated 160-bit entity UUID or Hash

### 1.2 Target Source Files to Modify / Create
1. Create `lib/core/fluoderpod/entity_packet_encoder.dart`:
   * High-speed `ByteData` packer converting `Task`, `PlayerState`, and `Team` models into `Uint8List`.
2. Update `lib/core/fluoderpod/fluoderpod_bridge.dart`:
   * Add `streamEntities(List<EntityPacket> entities)` and batch flush methods.
3. Wire provider in `lib/core/fluoderpod/fluoderpod_providers.dart`:
   * `fluoderpodEntityStreamProvider` which listens to `taskListProvider` and location changes and triggers `ingestBatch`.

---

## 2. Step-by-Step Implementation Instructions

### Step 1: Create Entity Packet Encoder
Write `lib/core/fluoderpod/entity_packet_encoder.dart`:
```dart
import 'dart:typed_data';

class EntityPacketEncoder {
  static const int packetSize = 64;

  static Uint8List encodeBatch(List<Map<String, dynamic>> items) {
    final buffer = Uint8List(items.length * packetSize);
    final byteData = ByteData.view(buffer.buffer);

    for (int i = 0; i < items.length; i++) {
      final offset = i * packetSize;
      final item = items[i];
      byteData.setFloat64(offset + 0, (item['x'] as num).toDouble(), Endian.little);
      byteData.setFloat64(offset + 8, (item['y'] as num).toDouble(), Endian.little);
      byteData.setFloat64(offset + 16, (item['z'] as num? ?? 0.0).toDouble(), Endian.little);
      byteData.setUint32(offset + 24, item['type'] as int, Endian.little);
      byteData.setUint32(offset + 28, item['status'] as int? ?? 0, Endian.little);
      byteData.setUint32(offset + 32, item['faction'] as int? ?? 0, Endian.little);
      byteData.setUint64(offset + 36, item['bounty'] as int? ?? 0, Endian.little);
    }
    return buffer;
  }
}
```

### Step 2: Test & Verify
Create unit test in `test/core/fluoderpod_encoder_test.dart` to verify binary offsets and byte ordering.

---

## 3. Build & Verification Commands

```powershell
# 1. Run Flutter tests for the encoder
flutter test test/core/fluoderpod_encoder_test.dart

# 2. Re-run static analysis
flutter analyze lib/core/fluoderpod/
```
