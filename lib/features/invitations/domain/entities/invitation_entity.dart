/// Invitation entity for both open and closed links.
class InvitationEntity {
  final String id;
  final String pgId;
  final InvitationType type;
  final String link;
  final DateTime expiresAt;
  final int? maxUses;
  final int currentUses;
  final InvitationStatus status;
  final String createdBy;
  final DateTime createdAt;
  final String? invitedEmail; // Only for closed links

  const InvitationEntity({
    required this.id,
    required this.pgId,
    required this.type,
    required this.link,
    required this.expiresAt,
    this.maxUses,
    required this.currentUses,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    this.invitedEmail,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isUsedUp => maxUses != null && currentUses >= maxUses!;
}

enum InvitationType { open, closed }
enum InvitationStatus { active, expired, revoked }

extension InvitationTypeExtension on InvitationType {
  String get label {
    switch (this) {
      case InvitationType.open: return 'Open Link';
      case InvitationType.closed: return 'Closed Link';
    }
  }
}
