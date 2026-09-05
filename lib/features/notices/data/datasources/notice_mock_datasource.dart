import '../../../../core/constants/app_constants.dart';
import '../../../../mock_database/mock_database.dart';
import '../../../../mock_database/tables/owners_table.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/repositories/notice_repository.dart';

class NoticeMockDatasource implements NoticeRepository {
  List<NoticeEntity> get _notices => MockDatabase.instance.notices;

  @override
  Future<List<NoticeEntity>> getNotices(String pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _notices.where((n) => n.pgId == pgId && n.isActive).toList();
  }

  @override
  Future<NoticeEntity> createNotice({required String pgId, required String title, required String category, required String description, required NoticePriority priority, DateTime? expiresAt}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final notice = NoticeEntity(id: 'n_${DateTime.now().millisecondsSinceEpoch}', pgId: pgId, title: title, category: category, description: description, priority: priority, createdAt: DateTime.now(), expiresAt: expiresAt, createdBy: kPrimaryOwnerId);
    _notices.insert(0, notice);
    return notice;
  }

  @override
  Future<NoticeEntity> updateNotice(String id, {String? title, String? category, String? description, NoticePriority? priority, DateTime? expiresAt, bool? isActive}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _notices.indexWhere((n) => n.id == id);
    final n = _notices[index];
    final updated = NoticeEntity(id: n.id, pgId: n.pgId, title: title ?? n.title, category: category ?? n.category, description: description ?? n.description, priority: priority ?? n.priority, createdAt: n.createdAt, expiresAt: expiresAt ?? n.expiresAt, createdBy: n.createdBy, isActive: isActive ?? n.isActive);
    _notices[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteNotice(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    _notices.removeWhere((n) => n.id == id);
  }
}
