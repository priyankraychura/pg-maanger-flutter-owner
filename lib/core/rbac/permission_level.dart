/// The level of access a principal has on a single [AppModule].
///
/// Ordered from least to most access: [none] < [view] < [edit].
enum PermissionLevel { none, view, edit }

extension PermissionLevelInfo on PermissionLevel {
  /// Whether this level allows reading/opening the module.
  bool get canView => index >= PermissionLevel.view.index;

  /// Whether this level allows create/update/delete actions in the module.
  bool get canEdit => this == PermissionLevel.edit;

  String get label {
    switch (this) {
      case PermissionLevel.none:
        return 'No access';
      case PermissionLevel.view:
        return 'View';
      case PermissionLevel.edit:
        return 'Edit';
    }
  }

  String get key {
    switch (this) {
      case PermissionLevel.none:
        return 'none';
      case PermissionLevel.view:
        return 'view';
      case PermissionLevel.edit:
        return 'edit';
    }
  }

  static PermissionLevel fromKey(String? key) {
    switch (key) {
      case 'edit':
        return PermissionLevel.edit;
      case 'view':
        return PermissionLevel.view;
      default:
        return PermissionLevel.none;
    }
  }
}
