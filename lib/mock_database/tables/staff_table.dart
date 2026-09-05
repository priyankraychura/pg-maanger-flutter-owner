import '../../features/auth/domain/entities/user_role.dart';
import '../../features/roles/domain/entities/staff_entity.dart';

/// `staff` table — manager/helper accounts and the PGs & modules they can access.
List<StaffEntity> seedStaff() => [
      StaffEntity(id: 's1', name: 'Ravi Kumar', email: 'ravi.manager@pgmanager.com', phone: '9876543250', role: UserRole.manager, assignedPgIds: ['pg_001'], accessibleModules: ['dashboard', 'rooms', 'tenants', 'payments', 'complaints'], joinDate: DateTime(2024, 6, 1), status: StaffStatus.active),
      StaffEntity(id: 's2', name: 'Suresh Helper', email: 'suresh@pgmanager.com', phone: '9876543251', role: UserRole.helper, assignedPgIds: ['pg_001', 'pg_002'], accessibleModules: ['dashboard', 'rooms', 'complaints'], joinDate: DateTime(2024, 8, 15), status: StaffStatus.active),
    ];
