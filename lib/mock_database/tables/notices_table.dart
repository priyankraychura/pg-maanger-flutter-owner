import '../../features/notices/domain/entities/notice_entity.dart';
import './owners_table.dart';

/// `notices` table — announcements posted by the owner for a PG.
List<NoticeEntity> seedNotices() => [
      NoticeEntity(id: 'n1', pgId: 'pg_001', title: 'Water Tank Cleaning', category: NoticeCategory.maintenance.key, description: 'Water supply will be disrupted tomorrow from 10 AM to 2 PM.', priority: NoticePriority.high, createdAt: DateTime.now().subtract(const Duration(hours: 3)), createdBy: kPrimaryOwnerId),
      NoticeEntity(id: 'n2', pgId: 'pg_001', title: 'New WiFi Password', category: NoticeCategory.general.key, description: 'WiFi password has been changed. Check WiFi section.', priority: NoticePriority.medium, createdAt: DateTime.now().subtract(const Duration(days: 1)), createdBy: kPrimaryOwnerId),
    ];
