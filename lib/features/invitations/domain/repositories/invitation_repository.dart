import '../entities/invitation_entity.dart';

abstract class InvitationRepository {
  Future<List<InvitationEntity>> getInvitations(String pgId);
  Future<InvitationEntity> createInvitation({
    required String pgId,
    required InvitationType type,
    required DateTime expiresAt,
    int? maxUses,
    String? invitedEmail,
  });
  Future<void> revokeInvitation(String id);
  Future<void> resendInvitation(String id);
}
