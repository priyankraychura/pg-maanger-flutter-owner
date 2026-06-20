import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/repositories/notice_repository.dart';

class NoticeMockDatasource implements NoticeRepository {
  @override
  Future<List<NoticeEntity>> getNotices(String pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _mockNotices.where((n) => n.pgId == pgId && n.isActive).toList();
  }

  @override
  Future<NoticeEntity> createNotice({required String pgId, required String title, required String description, required NoticePriority priority, DateTime? expiresAt}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final notice = NoticeEntity(id: 'n_${DateTime.now().millisecondsSinceEpoch}', pgId: pgId, title: title, description: description, priority: priority, createdAt: DateTime.now(), expiresAt: expiresAt, createdBy: 'owner_001');
    _mockNotices.insert(0, notice);
    return notice;
  }

  @override
  Future<NoticeEntity> updateNotice(String id, {String? title, String? description, NoticePriority? priority, DateTime? expiresAt, bool? isActive}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _mockNotices.indexWhere((n) => n.id == id);
    final n = _mockNotices[index];
    final updated = NoticeEntity(id: n.id, pgId: n.pgId, title: title ?? n.title, description: description ?? n.description, priority: priority ?? n.priority, createdAt: n.createdAt, expiresAt: expiresAt ?? n.expiresAt, createdBy: n.createdBy, isActive: isActive ?? n.isActive);
    _mockNotices[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteNotice(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    _mockNotices.removeWhere((n) => n.id == id);
  }

  static final _mockNotices = <NoticeEntity>[
    NoticeEntity(id: 'n1', pgId: 'pg_001', title: 'Water Tank Cleaning', description: 'Water supply will be disrupted tomorrow from 10 AM to 2 PM.', priority: NoticePriority.high, createdAt: DateTime.now().subtract(const Duration(hours: 3)), createdBy: 'owner_001'),
    NoticeEntity(id: 'n2', pgId: 'pg_001', title: 'New WiFi Password', description: 'WiFi password has been changed. Check WiFi section.', priority: NoticePriority.medium, createdAt: DateTime.now().subtract(const Duration(days: 1)), createdBy: 'owner_001'),
  ];
}
