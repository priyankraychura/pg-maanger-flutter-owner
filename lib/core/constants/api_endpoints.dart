/// API endpoint constants for future NestJS backend integration.
/// All endpoints are defined here for easy swapping.
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL — change this when connecting to NestJS
  static const String baseUrl = 'http://localhost:3000/api/owner';

  // Auth
  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String logout = '/auth/logout';

  // Profile
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';

  // PG Management
  static const String pgs = '/pgs';
  static const String pgDetail = '/pgs/:id';

  // Rooms & Beds
  static const String rooms = '/pgs/:pgId/rooms';
  static const String roomDetail = '/rooms/:id';
  static const String beds = '/rooms/:roomId/beds';

  // Tenants
  static const String tenants = '/pgs/:pgId/tenants';
  static const String tenantDetail = '/tenants/:id';
  static const String pendingApprovals = '/pgs/:pgId/tenants/pending';
  static const String approveTenant = '/tenants/:id/approve';
  static const String rejectTenant = '/tenants/:id/reject';

  // Invitations
  static const String invitations = '/pgs/:pgId/invitations';
  static const String createInvitation = '/pgs/:pgId/invitations/create';
  static const String revokeInvitation = '/invitations/:id/revoke';

  // Payments
  static const String payments = '/pgs/:pgId/payments';
  static const String paymentSummary = '/pgs/:pgId/payments/summary';
  static const String markPaid = '/payments/:id/mark-paid';
  static const String sendReminder = '/payments/:id/reminder';

  // Complaints
  static const String complaints = '/pgs/:pgId/complaints';
  static const String respondComplaint = '/complaints/:id/respond';

  // Notices
  static const String notices = '/pgs/:pgId/notices';
  static const String createNotice = '/pgs/:pgId/notices/create';

  // Menu
  static const String menu = '/pgs/:pgId/menu';
  static const String updateMeal = '/pgs/:pgId/menu/:dayNumber';

  // WiFi
  static const String wifi = '/pgs/:pgId/wifi';

  // Leave Notices
  static const String leaveNotices = '/pgs/:pgId/leave-notices';
  static const String approveLeaveNotice = '/leave-notices/:id/approve';
  static const String rejectLeaveNotice = '/leave-notices/:id/reject';

  // Staff / Roles
  static const String staff = '/staff';
  static const String inviteStaff = '/staff/invite';
}
