/// Payment entity for rent and other charges.
class PaymentEntity {
  final String id;
  final String pgId;
  final String tenantId;
  final String tenantName;
  final String roomNumber;
  final double amount;
  final String description;
  final DateTime dueDate;
  final DateTime? paidDate;
  final PaymentStatus status;
  final String? method;
  final String? transactionId;
  final int month;
  final int year;

  const PaymentEntity({
    required this.id,
    required this.pgId,
    required this.tenantId,
    required this.tenantName,
    required this.roomNumber,
    required this.amount,
    required this.description,
    required this.dueDate,
    this.paidDate,
    required this.status,
    this.method,
    this.transactionId,
    required this.month,
    required this.year,
  });
}

enum PaymentStatus { paid, pending, overdue, partial }

extension PaymentStatusExtension on PaymentStatus {
  String get label {
    switch (this) {
      case PaymentStatus.paid: return 'Paid';
      case PaymentStatus.pending: return 'Pending';
      case PaymentStatus.overdue: return 'Overdue';
      case PaymentStatus.partial: return 'Partial';
    }
  }
}

/// Payment summary metrics for dashboard and payment list.
class PaymentSummaryEntity {
  final double totalCollected;
  final double totalPending;
  final double totalOverdue;
  final double collectionRate;

  const PaymentSummaryEntity({
    required this.totalCollected,
    required this.totalPending,
    required this.totalOverdue,
    required this.collectionRate,
  });
}
