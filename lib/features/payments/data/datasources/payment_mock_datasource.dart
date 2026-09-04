import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentMockDatasource implements PaymentRepository {
  @override
  Future<List<PaymentEntity>> getPayments(String pgId, {int? month, int? year, PaymentStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _mockPayments.where((p) {
      bool matches = p.pgId == pgId;
      if (month != null) matches = matches && p.month == month;
      if (year != null) matches = matches && p.year == year;
      if (status != null) matches = matches && p.status == status;
      return matches;
    }).toList();
  }

  @override
  Future<PaymentSummaryEntity> getPaymentSummary(String pgId, {int? month, int? year}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay ~/ 2));
    final payments = _mockPayments.where((p) {
      bool matches = p.pgId == pgId;
      if (month != null) matches = matches && p.month == month;
      if (year != null) matches = matches && p.year == year;
      return matches;
    });

    double collected = 0;
    double pending = 0;
    double overdue = 0;

    for (var p in payments) {
      if (p.status == PaymentStatus.paid) {
        collected += p.amount;
      } else if (p.status == PaymentStatus.pending) {
        pending += p.amount;
      } else if (p.status == PaymentStatus.overdue) {
        overdue += p.amount;
      }
    }

    final total = collected + pending + overdue;
    final rate = total > 0 ? (collected / total) * 100 : 0.0;

    return PaymentSummaryEntity(
      totalCollected: collected,
      totalPending: pending,
      totalOverdue: overdue,
      collectionRate: rate,
    );
  }

  @override
  Future<PaymentEntity> markAsPaid(String paymentId, {required String method, String? transactionId}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _mockPayments.indexWhere((p) => p.id == paymentId);
    final p = _mockPayments[index];
    final updated = PaymentEntity(
      id: p.id, pgId: p.pgId, tenantId: p.tenantId, tenantName: p.tenantName, roomNumber: p.roomNumber, amount: p.amount, description: p.description, dueDate: p.dueDate, paidDate: DateTime.now(), status: PaymentStatus.paid, method: method, transactionId: transactionId, month: p.month, year: p.year,
    );
    _mockPayments[index] = updated;
    return updated;
  }

  @override
  Future<void> sendReminder(String paymentId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
  }

  @override
  Future<void> sendBulkReminder(String pgId, {int? month, int? year}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
  }

  static final _mockPayments = <PaymentEntity>[
    PaymentEntity(id: 'p1', pgId: 'pg_001', tenantId: 't1', tenantName: 'Ankit Kumar', roomNumber: 'A-101', amount: 8500, description: 'July Rent', dueDate: DateTime(2026, 7, 5), paidDate: DateTime(2026, 7, 2), status: PaymentStatus.paid, method: 'UPI', transactionId: 'TXN123456789', month: 7, year: 2026),
    PaymentEntity(id: 'p2', pgId: 'pg_001', tenantId: 't2', tenantName: 'Rahul Singh', roomNumber: 'A-101', amount: 8500, description: 'July Rent', dueDate: DateTime(2026, 7, 5), status: PaymentStatus.pending, month: 7, year: 2026),
    PaymentEntity(id: 'p3', pgId: 'pg_001', tenantId: 't3', tenantName: 'Sneha Gupta', roomNumber: 'A-102', amount: 7500, description: 'July Rent', dueDate: DateTime(2026, 7, 5), status: PaymentStatus.overdue, month: 7, year: 2026),
    PaymentEntity(id: 'p4', pgId: 'pg_001', tenantId: 't5', tenantName: 'Vikram Singh', roomNumber: 'B-101', amount: 5500, description: 'July Rent', dueDate: DateTime(2026, 7, 5), paidDate: DateTime(2026, 7, 1), status: PaymentStatus.paid, method: 'Cash', month: 7, year: 2026),
  ];
}
