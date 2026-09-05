import '../../features/auth/domain/entities/owner_entity.dart';
import '../../features/auth/domain/entities/user_role.dart';

/// Id of the primary owner account. Used as the `createdBy` / `updatedBy`
/// foreign key on records seeded by the owner (notices, wifi, menu, …) so the
/// value lives in one place.
const String kPrimaryOwnerId = 'owner_001';

/// Default set of modules an owner/admin can access.
/// Referenced when seeding owners and when registering new accounts.
const List<String> kDefaultOwnerModules = [
  'dashboard',
  'rooms',
  'tenants',
  'payments',
  'complaints',
  'notices',
  'menu',
  'wifi',
  'leave_notices',
  'invitations',
  'roles',
  'settings',
];

/// `owners` table — the account records that can sign in to the owner app.
List<OwnerEntity> seedOwners() => [
      OwnerEntity(
        id: kPrimaryOwnerId,
        name: 'Priyank Sharma',
        email: 'priyank@pgmanager.com',
        phone: '9876543210',
        role: UserRole.admin,
        assignedPgIds: const ['pg_001', 'pg_002'],
        accessibleModules: kDefaultOwnerModules,
        joinDate: DateTime(2024, 3, 15),
      ),
    ];
