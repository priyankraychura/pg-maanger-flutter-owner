/// Notice entity for PG-wide announcements.
class NoticeEntity {
  final String id;
  final String pgId;
  final String title;
  final String category;
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
    required this.category,
    required this.description,
    required this.priority,
    required this.createdAt,
    this.expiresAt,
    required this.createdBy,
    this.isActive = true,
  });
}

enum NoticePriority { low, medium, high, urgent }

/// Categories a notice can be filed under.
enum NoticeCategory { general, maintenance, payment, event, emergency }

extension NoticeCategoryInfo on NoticeCategory {
  /// Stable string id stored on the notice record.
  String get key {
    switch (this) {
      case NoticeCategory.general:
        return 'general';
      case NoticeCategory.maintenance:
        return 'maintenance';
      case NoticeCategory.payment:
        return 'payment';
      case NoticeCategory.event:
        return 'event';
      case NoticeCategory.emergency:
        return 'emergency';
    }
  }

  String get label {
    switch (this) {
      case NoticeCategory.general:
        return 'General';
      case NoticeCategory.maintenance:
        return 'Maintenance';
      case NoticeCategory.payment:
        return 'Payment';
      case NoticeCategory.event:
        return 'Event';
      case NoticeCategory.emergency:
        return 'Emergency';
    }
  }

  static NoticeCategory fromKey(String key) {
    for (final c in NoticeCategory.values) {
      if (c.key == key) return c;
    }
    return NoticeCategory.general;
  }
}
