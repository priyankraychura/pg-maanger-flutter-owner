/// App-wide constant values.
class AppConstants {
  AppConstants._();

  static const String appName = 'PG Manager Owner';
  static const String appVersion = '1.0.0';

  // Mock delay to simulate API calls (milliseconds)
  static const int mockApiDelay = 800;

  // Pagination
  static const int defaultPageSize = 20;

  // OTP
  static const int otpLength = 6;
  static const int otpResendSeconds = 30;

  // File upload
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png'];

  // Invitation link expiry options (in hours)
  static const List<int> invitationExpiryOptions = [24, 72, 168, 336, 720];
  static const List<String> invitationExpiryLabels = [
    '24 Hours',
    '3 Days',
    '7 Days',
    '14 Days',
    '30 Days',
  ];
}
