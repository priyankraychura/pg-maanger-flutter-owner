/// Tenant entity.
class TenantEntity {
  final String id;
  final String pgId;
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final String? roomId;
  final String? bedId;
  final String? roomNumber;
  final String? bedNumber;
  final DateTime joinDate;
  final DateTime? moveOutDate;
  final TenantStatus status;
  final String? kycStatus;
  final String? emergencyContact;
  final String? emergencyContactName;
  final String? address;
  final String? occupation;
  final String? idProofType;
  final String? idProofNumber;

  const TenantEntity({
    required this.id,
    required this.pgId,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    this.roomId,
    this.bedId,
    this.roomNumber,
    this.bedNumber,
    required this.joinDate,
    this.moveOutDate,
    required this.status,
    this.kycStatus,
    this.emergencyContact,
    this.emergencyContactName,
    this.address,
    this.occupation,
    this.idProofType,
    this.idProofNumber,
  });
}

enum TenantStatus { active, pending, rejected, movedOut }

extension TenantStatusExtension on TenantStatus {
  String get label {
    switch (this) {
      case TenantStatus.active:
        return 'Active';
      case TenantStatus.pending:
        return 'Pending';
      case TenantStatus.rejected:
        return 'Rejected';
      case TenantStatus.movedOut:
        return 'Moved Out';
    }
  }
}
