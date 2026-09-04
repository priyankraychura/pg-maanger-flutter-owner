import '../entities/notice_entity.dart';

abstract class NoticeRepository {
  Future<List<NoticeEntity>> getNotices(String pgId);
  Future<NoticeEntity> createNotice({
    required String pgId,
    required String title,
    required String description,
    required NoticePriority priority,
    DateTime? expiresAt,
  });
  Future<NoticeEntity> updateNotice(String id, {String? title, String? description, NoticePriority? priority, DateTime? expiresAt, bool? isActive});
  Future<void> deleteNotice(String id);
}
