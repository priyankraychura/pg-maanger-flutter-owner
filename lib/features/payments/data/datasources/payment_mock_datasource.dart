import '../../../../core/constants/app_constants.dart';
import '../../../../mock_database/mock_database.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentMockDatasource implements PaymentRepository {
  List<PaymentEntity> get _payments => MockDatabase.instance.payments;

  @override
  Future<List<PaymentEntity>> getPayments(String pgId, {int? month, int? year, PaymentStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _payments.where((p) {
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
    final payments = _payments.where((p) {
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
    final index = _payments.indexWhere((p) => p.id == paymentId);
    final p = _payments[index];
    final updated = PaymentEntity(
      id: p.id, pgId: p.pgId, tenantId: p.tenantId, tenantName: p.tenantName, roomNumber: p.roomNumber, amount: p.amount, description: p.description, dueDate: p.dueDate, paidDate: DateTime.now(), status: PaymentStatus.paid, method: method, transactionId: transactionId, month: p.month, year: p.year,
    );
    _payments[index] = updated;
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
}
