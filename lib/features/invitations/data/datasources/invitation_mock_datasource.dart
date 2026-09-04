import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/invitation_entity.dart';
import '../../domain/repositories/invitation_repository.dart';

class InvitationMockDatasource implements InvitationRepository {
  @override
  Future<List<InvitationEntity>> getInvitations(String pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _mockInvitations.where((i) => i.pgId == pgId).toList();
  }

  @override
  Future<InvitationEntity> createInvitation({required String pgId, required InvitationType type, required DateTime expiresAt, int? maxUses, String? invitedEmail}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return InvitationEntity(
      id: 'inv_${DateTime.now().millisecondsSinceEpoch}',
      pgId: pgId,
      type: type,
      link: 'https://pgmanager.com/invite/${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: expiresAt,
      maxUses: maxUses,
      currentUses: 0,
      status: InvitationStatus.active,
      createdBy: 'owner_001',
      createdAt: DateTime.now(),
      invitedEmail: invitedEmail,
    );
  }

  @override
  Future<void> revokeInvitation(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
  }

  @override
  Future<void> resendInvitation(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
  }

  static final _mockInvitations = <InvitationEntity>[
    InvitationEntity(
      id: 'inv_1',
      pgId: 'pg_001',
      type: InvitationType.open,
      link: 'https://pgmanager.com/invite/xyz123',
      expiresAt: DateTime.now().add(const Duration(days: 7)),
      currentUses: 5,
      status: InvitationStatus.active,
      createdBy: 'owner_001',
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
      createdBy: 'owner_001',
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
      createdBy: 'owner_001',
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
    ),
  ];
}
