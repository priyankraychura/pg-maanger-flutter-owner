import '../entities/payment_entity.dart';

abstract class PaymentRepository {
  Future<List<PaymentEntity>> getPayments(String pgId, {int? month, int? year, PaymentStatus? status});
  Future<PaymentSummaryEntity> getPaymentSummary(String pgId, {int? month, int? year});
  Future<PaymentEntity> markAsPaid(String paymentId, {required String method, String? transactionId});
  Future<void> sendReminder(String paymentId);
  Future<void> sendBulkReminder(String pgId, {int? month, int? year});
}
