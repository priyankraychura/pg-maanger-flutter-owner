import '../../../../core/constants/app_constants.dart';
import '../../../../mock_database/mock_database.dart';
import '../../../../mock_database/tables/owners_table.dart';
import '../../domain/entities/invitation_entity.dart';
import '../../domain/repositories/invitation_repository.dart';

class InvitationMockDatasource implements InvitationRepository {
  List<InvitationEntity> get _invitations => MockDatabase.instance.invitations;

  @override
  Future<List<InvitationEntity>> getInvitations(String pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _invitations.where((i) => i.pgId == pgId).toList();
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
      createdBy: kPrimaryOwnerId,
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
}
