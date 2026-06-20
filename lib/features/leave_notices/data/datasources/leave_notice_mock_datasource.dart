import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/leave_notice_entity.dart';
import '../../domain/repositories/leave_notice_repository.dart';

class LeaveNoticeMockDatasource implements LeaveNoticeRepository {
  @override
  Future<List<LeaveNoticeEntity>> getLeaveNotices(String pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _mockLeaveNotices.where((l) => l.pgId == pgId).toList();
  }

  @override
  Future<LeaveNoticeEntity> approveLeaveNotice(String id, {String? remarks}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _mockLeaveNotices.indexWhere((l) => l.id == id);
    final l = _mockLeaveNotices[index];
    final updated = LeaveNoticeEntity(id: l.id, pgId: l.pgId, tenantId: l.tenantId, tenantName: l.tenantName, roomNumber: l.roomNumber, requestDate: l.requestDate, moveOutDate: l.moveOutDate, reason: l.reason, status: LeaveNoticeStatus.approved, ownerRemarks: remarks ?? l.ownerRemarks);
    _mockLeaveNotices[index] = updated;
    return updated;
  }

  @override
  Future<LeaveNoticeEntity> rejectLeaveNotice(String id, {required String remarks}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _mockLeaveNotices.indexWhere((l) => l.id == id);
    final l = _mockLeaveNotices[index];
    final updated = LeaveNoticeEntity(id: l.id, pgId: l.pgId, tenantId: l.tenantId, tenantName: l.tenantName, roomNumber: l.roomNumber, requestDate: l.requestDate, moveOutDate: l.moveOutDate, reason: l.reason, status: LeaveNoticeStatus.rejected, ownerRemarks: remarks);
    _mockLeaveNotices[index] = updated;
    return updated;
  }

  static final _mockLeaveNotices = <LeaveNoticeEntity>[
    LeaveNoticeEntity(id: 'ln1', pgId: 'pg_001', tenantId: 't3', tenantName: 'Sneha Gupta', roomNumber: 'A-102', requestDate: DateTime.now().subtract(const Duration(days: 2)), moveOutDate: DateTime.now().add(const Duration(days: 28)), reason: 'Job transfer to another city', status: LeaveNoticeStatus.pending),
    LeaveNoticeEntity(id: 'ln2', pgId: 'pg_001', tenantId: 't1', tenantName: 'Ankit Kumar', roomNumber: 'A-101', requestDate: DateTime.now().subtract(const Duration(days: 45)), moveOutDate: DateTime.now().subtract(const Duration(days: 15)), reason: 'Found a flat', status: LeaveNoticeStatus.approved, ownerRemarks: 'Clearance done.'),
  ];
}
