import 'package:get_it/get_it.dart';

import '../features/auth/data/datasources/auth_mock_datasource.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/pg_management/data/datasources/pg_mock_datasource.dart';
import '../features/pg_management/domain/repositories/pg_repository.dart';
import '../features/dashboard/data/datasources/dashboard_mock_datasource.dart';
import '../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../features/rooms/data/datasources/room_mock_datasource.dart';
import '../features/rooms/domain/repositories/room_repository.dart';
import '../features/tenants/data/datasources/tenant_mock_datasource.dart';
import '../features/tenants/domain/repositories/tenant_repository.dart';
import '../features/invitations/data/datasources/invitation_mock_datasource.dart';
import '../features/invitations/domain/repositories/invitation_repository.dart';
import '../features/payments/data/datasources/payment_mock_datasource.dart';
import '../features/payments/domain/repositories/payment_repository.dart';
import '../features/complaints/data/datasources/complaints_mock_datasource.dart';
import '../features/complaints/domain/repositories/complaints_repository.dart';
import '../features/notices/data/datasources/notice_mock_datasource.dart';
import '../features/notices/domain/repositories/notice_repository.dart';
import '../features/menu/data/datasources/menu_mock_datasource.dart';
import '../features/menu/domain/repositories/menu_repository.dart';
import '../features/wifi/data/datasources/wifi_mock_datasource.dart';
import '../features/wifi/domain/repositories/wifi_repository.dart';
import '../features/leave_notices/data/datasources/leave_notice_mock_datasource.dart';
import '../features/leave_notices/domain/repositories/leave_notice_repository.dart';
import '../features/roles/data/datasources/role_mock_datasource.dart';
import '../features/roles/domain/repositories/role_repository.dart';

/// Service locator using get_it.
/// To switch from mock to real API, just change the datasource registration.
final getIt = GetIt.instance;

void setupServiceLocator() {
  // ─── Auth ──────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthMockDatasource(),
  );

  // ─── PG Management ────────────────────────────────────────
  getIt.registerLazySingleton<PgRepository>(
    () => PgMockDatasource(),
  );

  // ─── Dashboard ─────────────────────────────────────────────
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardMockDatasource(),
  );

  // ─── Rooms ──────────────────────────────────────────────────
  getIt.registerLazySingleton<RoomRepository>(
    () => RoomMockDatasource(),
  );

  // ─── Tenants ────────────────────────────────────────────────
  getIt.registerLazySingleton<TenantRepository>(
    () => TenantMockDatasource(),
  );

  // ─── Invitations ────────────────────────────────────────────
  getIt.registerLazySingleton<InvitationRepository>(
    () => InvitationMockDatasource(),
  );

  // ─── Payments ───────────────────────────────────────────────
  getIt.registerLazySingleton<PaymentRepository>(
    () => PaymentMockDatasource(),
  );

  // ─── Complaints ─────────────────────────────────────────────
  getIt.registerLazySingleton<ComplaintsRepository>(
    () => ComplaintsMockDatasource(),
  );

  // ─── Notices ────────────────────────────────────────────────
  getIt.registerLazySingleton<NoticeRepository>(
    () => NoticeMockDatasource(),
  );

  // ─── Menu ───────────────────────────────────────────────────
  getIt.registerLazySingleton<MenuRepository>(
    () => MenuMockDatasource(),
  );

  // ─── WiFi ───────────────────────────────────────────────────
  getIt.registerLazySingleton<WifiRepository>(
    () => WifiMockDatasource(),
  );

  // ─── Leave Notices ──────────────────────────────────────────
  getIt.registerLazySingleton<LeaveNoticeRepository>(
    () => LeaveNoticeMockDatasource(),
  );

  // ─── Roles / Staff ──────────────────────────────────────────
  getIt.registerLazySingleton<RoleRepository>(
    () => RoleMockDatasource(),
  );
}
