import '../../features/invitations/domain/entities/invitation_entity.dart';
import './owners_table.dart';

/// `invitations` table — join links/invites generated per PG.
List<InvitationEntity> seedInvitations() => [
      InvitationEntity(
        id: 'inv_1',
        pgId: 'pg_001',
        type: InvitationType.open,
        link: 'https://pgmanager.com/invite/xyz123',
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        currentUses: 5,
        status: InvitationStatus.active,
        createdBy: kPrimaryOwnerId,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InvitationEntity(
        id: 'inv_2',
        pgId: 'pg_001',
        type: InvitationType.closed,
        link: 'https://pgmanager.com/invite/abc987',
        expiresAt: DateTime.now().add(const Duration(hours: 48)),
        maxUses: 1,
        currentUses: 0,
        status: InvitationStatus.active,
        createdBy: kPrimaryOwnerId,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        invitedEmail: 'newtenant@example.com',
      ),
      InvitationEntity(
        id: 'inv_3',
        pgId: 'pg_001',
        type: InvitationType.open,
        link: 'https://pgmanager.com/invite/def456',
        expiresAt: DateTime.now().subtract(const Duration(days: 1)),
        maxUses: 10,
        currentUses: 10,
        status: InvitationStatus.expired,
        createdBy: kPrimaryOwnerId,
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
    ];
