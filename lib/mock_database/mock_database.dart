import '../features/auth/domain/entities/owner_entity.dart';
import '../features/complaints/domain/entities/complaint_entity.dart';
import '../features/invitations/domain/entities/invitation_entity.dart';
import '../features/leave_notices/domain/entities/leave_notice_entity.dart';
import '../features/menu/domain/entities/menu_plan_entity.dart';
import '../features/notices/domain/entities/notice_entity.dart';
import '../features/payments/domain/entities/payment_entity.dart';
import '../features/pg_management/domain/entities/pg_entity.dart';
import '../features/roles/domain/entities/staff_entity.dart';
import '../features/rooms/domain/entities/room_entity.dart';
import '../features/tenants/domain/entities/tenant_entity.dart';
import '../features/wifi/domain/entities/wifi_entity.dart';

import 'tables/beds_table.dart';
import 'tables/complaints_table.dart';
import 'tables/invitations_table.dart';
import 'tables/leave_notices_table.dart';
import 'tables/menus_table.dart';
import 'tables/notices_table.dart';
import 'tables/owners_table.dart';
import 'tables/payments_table.dart';
import 'tables/pgs_table.dart';
import 'tables/rooms_table.dart';
import 'tables/staff_table.dart';
import 'tables/tenants_table.dart';
import 'tables/wifi_table.dart';

/// In-memory stand-in for the app's NoSQL (DynamoDB) backend.
///
/// Each `late final` list below models a DynamoDB table (a collection of
/// items). Tables are seeded once, lazily, on first access and then held as
/// mutable growable lists for the app's lifetime, so mock create/update/delete
/// operations persist across screens — just like reads/writes against a real
/// table would.
///
/// Seed data lives in `tables/`, one file per table. Denormalized display
/// fields (e.g. a tenant's name on a payment item) are derived from their
/// owning table at seed time, so every fact has a single source of truth.
///
/// The datasources under `features/**/data/datasources/` are the repository
/// layer: they read from and write to these tables and add the mock network
/// latency. Swapping to real DynamoDB later means replacing those datasources,
/// not touching the widgets or providers.
class MockDatabase {
  MockDatabase._();

  /// Singleton handle — the one shared "database" instance.
  static final MockDatabase instance = MockDatabase._();

  // ─── Accounts ────────────────────────────────────────────────
  late final List<OwnerEntity> owners = List.of(seedOwners());
  late final List<StaffEntity> staff = List.of(seedStaff());

  // ─── Properties & inventory ──────────────────────────────────
  late final List<PgEntity> pgs = List.of(seedPgs());
  late final List<RoomEntity> rooms = List.of(seedRooms());
  late final List<BedEntity> beds = List.of(seedBeds());

  // ─── Residents ───────────────────────────────────────────────
  late final List<TenantEntity> tenants = List.of(seedTenants(rooms: rooms));

  // ─── Operations ──────────────────────────────────────────────
  late final List<PaymentEntity> payments = List.of(seedPayments(tenants: tenants));
  late final List<ComplaintEntity> complaints = List.of(seedComplaints(tenants: tenants));
  late final List<LeaveNoticeEntity> leaveNotices = List.of(seedLeaveNotices(tenants: tenants));
  late final List<NoticeEntity> notices = List.of(seedNotices());
  late final List<MenuPlanEntity> menuPlans = List.of(seedMenuPlans());
  late final List<WifiEntity> wifi = List.of(seedWifi());
  late final List<InvitationEntity> invitations = List.of(seedInvitations());
}
