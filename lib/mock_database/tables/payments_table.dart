import '../../features/payments/domain/entities/payment_entity.dart';
import '../../features/tenants/domain/entities/tenant_entity.dart';
import './tenants_table.dart';

/// Canonical payment record. Tenant name & room number are NOT stored here;
/// they are resolved from the `tenants` table when building items.
class _PaymentSeed {
  final String id;
  final String pgId;
  final String tenantId;
  final double amount;
  final String description;
  final DateTime dueDate;
  final DateTime? paidDate;
  final PaymentStatus status;
  final String? method;
  final String? transactionId;
  final int month;
  final int year;
  const _PaymentSeed({required this.id, required this.pgId, required this.tenantId, required this.amount, required this.description, required this.dueDate, this.paidDate, required this.status, this.method, this.transactionId, required this.month, required this.year});
}

List<_PaymentSeed> _paymentSeeds() => [
      _PaymentSeed(id: 'p1', pgId: 'pg_001', tenantId: 't1', amount: 8500, description: 'July Rent', dueDate: DateTime(2026, 7, 5), paidDate: DateTime(2026, 7, 2), status: PaymentStatus.paid, method: 'UPI', transactionId: 'TXN123456789', month: 7, year: 2026),
      _PaymentSeed(id: 'p2', pgId: 'pg_001', tenantId: 't2', amount: 8500, description: 'July Rent', dueDate: DateTime(2026, 7, 5), status: PaymentStatus.pending, month: 7, year: 2026),
      _PaymentSeed(id: 'p3', pgId: 'pg_001', tenantId: 't3', amount: 7500, description: 'July Rent', dueDate: DateTime(2026, 7, 5), status: PaymentStatus.overdue, month: 7, year: 2026),
      _PaymentSeed(id: 'p4', pgId: 'pg_001', tenantId: 't5', amount: 5500, description: 'July Rent', dueDate: DateTime(2026, 7, 5), paidDate: DateTime(2026, 7, 1), status: PaymentStatus.paid, method: 'Cash', month: 7, year: 2026),
    ];

/// `payments` table — rent/charge items with tenant name & room derived from
/// the [tenants] table.
List<PaymentEntity> seedPayments({required List<TenantEntity> tenants}) {
  return _paymentSeeds().map((p) {
    final tenant = tenants.byId(p.tenantId);
    return PaymentEntity(
      id: p.id,
      pgId: p.pgId,
      tenantId: p.tenantId,
      tenantName: tenant.name,
      roomNumber: tenant.roomNumber ?? '',
      amount: p.amount,
      description: p.description,
      dueDate: p.dueDate,
      paidDate: p.paidDate,
      status: p.status,
      method: p.method,
      transactionId: p.transactionId,
      month: p.month,
      year: p.year,
    );
  }).toList();
}
