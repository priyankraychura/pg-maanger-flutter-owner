/// Notice entity for PG-wide announcements.
class NoticeEntity {
  final String id;
  final String pgId;
  final String title;
  final String description;
  final NoticePriority priority;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String createdBy;
  final bool isActive;

  const NoticeEntity({
    required this.id,
    required this.pgId,
    required this.title,
    required this.description,
    required this.priority,
    required this.createdAt,
    this.expiresAt,
    required this.createdBy,
    this.isActive = true,
  });
}

enum NoticePriority { low, medium, high, urgent }
