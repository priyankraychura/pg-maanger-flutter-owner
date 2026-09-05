import '../../features/rooms/domain/entities/room_entity.dart';
import './tenants_table.dart';

/// Raw occupancy record — the single source of truth for which bed exists,
/// which room it belongs to, and which tenant (if any) occupies it.
class _BedSeed {
  final String id;
  final String roomId;
  final String bedNumber;
  final BedStatus status;
  final String? tenantId;
  const _BedSeed(this.id, this.roomId, this.bedNumber, this.status, [this.tenantId]);
}

const _bedSeeds = <_BedSeed>[
  _BedSeed('b1', 'r1', 'Bed 1', BedStatus.occupied, 't1'),
  _BedSeed('b2', 'r1', 'Bed 2', BedStatus.occupied, 't2'),
  _BedSeed('b3', 'r2', 'Bed 1', BedStatus.occupied, 't3'),
  _BedSeed('b4', 'r2', 'Bed 2', BedStatus.occupied, 't4'),
  _BedSeed('b5', 'r2', 'Bed 3', BedStatus.available),
  _BedSeed('b6', 'r5', 'Bed 1', BedStatus.occupied, 't5'),
  _BedSeed('b7', 'r5', 'Bed 2', BedStatus.occupied, 't6'),
  _BedSeed('b8', 'r5', 'Bed 3', BedStatus.available),
];

/// `beds` table — bed identity + occupancy. The occupant's display name is
/// derived from the [tenants] table so a tenant's name lives in one place only.
List<BedEntity> seedBeds() {
  final tenantNames = seedTenantNames();
  return _bedSeeds
      .map((b) => BedEntity(
            id: b.id,
            roomId: b.roomId,
            bedNumber: b.bedNumber,
            status: b.status,
            tenantId: b.tenantId,
            tenantName: b.tenantId == null ? null : tenantNames[b.tenantId],
          ))
      .toList();
}

/// Occupancy lookup used when deriving a tenant's room/bed assignment.
/// Returns the bed seed a tenant occupies, or `null` if unassigned.
({String bedId, String roomId, String bedNumber})? bedAssignmentForTenant(String tenantId) {
  for (final b in _bedSeeds) {
    if (b.tenantId == tenantId) {
      return (bedId: b.id, roomId: b.roomId, bedNumber: b.bedNumber);
    }
  }
  return null;
}
