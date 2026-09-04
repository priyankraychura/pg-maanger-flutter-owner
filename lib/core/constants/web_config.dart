/// Configuration for the companion web pages (Next.js app in `pg-web-pages`).
///
/// These pages are opened from the app (e.g. tenant invite links) and are
/// hosted separately from the NestJS API in [ApiEndpoints].
class WebConfig {
  WebConfig._();

  /// Base URL where the Next.js web pages are served.
  ///
  /// Local dev default is the Next.js dev server (`http://localhost:3000`).
  /// Change this to the deployed domain (e.g. `https://pgmanager.com`) later.
  ///
  /// Note: on an Android emulator, `localhost` refers to the emulator itself —
  /// use `http://10.0.2.2:3000` to reach a dev server on the host machine.
  static const String baseUrl = 'http://localhost:3000';

  /// Tenant invitation page route (see `app/invite/[token]/page.tsx`).
  static const String invitePath = '/invite';
}
