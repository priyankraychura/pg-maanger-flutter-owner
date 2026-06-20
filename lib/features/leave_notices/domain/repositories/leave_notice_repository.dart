import '../entities/leave_notice_entity.dart';

abstract class LeaveNoticeRepository {
  Future<List<LeaveNoticeEntity>> getLeaveNotices(String pgId);
  Future<LeaveNoticeEntity> approveLeaveNotice(String id, {String? remarks});
  Future<LeaveNoticeEntity> rejectLeaveNotice(String id, {required String remarks});
}
