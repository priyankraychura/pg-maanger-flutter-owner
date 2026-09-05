import '../../../../core/constants/app_constants.dart';
import '../../../../mock_database/mock_database.dart';
import '../../domain/entities/leave_notice_entity.dart';
import '../../domain/repositories/leave_notice_repository.dart';

class LeaveNoticeMockDatasource implements LeaveNoticeRepository {
  List<LeaveNoticeEntity> get _leaveNotices => MockDatabase.instance.leaveNotices;

  @override
  Future<List<LeaveNoticeEntity>> getLeaveNotices(String pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _leaveNotices.where((l) => l.pgId == pgId).toList();
  }

  @override
  Future<LeaveNoticeEntity> approveLeaveNotice(String id, {String? remarks}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _leaveNotices.indexWhere((l) => l.id == id);
    final l = _leaveNotices[index];
    final updated = LeaveNoticeEntity(id: l.id, pgId: l.pgId, tenantId: l.tenantId, tenantName: l.tenantName, roomNumber: l.roomNumber, requestDate: l.requestDate, moveOutDate: l.moveOutDate, reason: l.reason, status: LeaveNoticeStatus.approved, ownerRemarks: remarks ?? l.ownerRemarks);
    _leaveNotices[index] = updated;
    return updated;
  }

  @override
  Future<LeaveNoticeEntity> rejectLeaveNotice(String id, {required String remarks}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _leaveNotices.indexWhere((l) => l.id == id);
    final l = _leaveNotices[index];
    final updated = LeaveNoticeEntity(id: l.id, pgId: l.pgId, tenantId: l.tenantId, tenantName: l.tenantName, roomNumber: l.roomNumber, requestDate: l.requestDate, moveOutDate: l.moveOutDate, reason: l.reason, status: LeaveNoticeStatus.rejected, ownerRemarks: remarks);
    _leaveNotices[index] = updated;
    return updated;
  }
}
