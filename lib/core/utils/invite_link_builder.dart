import 'dart:convert';

import '../constants/web_config.dart';

/// Builds self-expiring web links for tenant invitations.
///
/// The link embeds a token that encodes the PG context and an absolute expiry
/// timestamp, so the web page can validate it without a backend round-trip.
/// Once the token's [exp] time has passed (24 hours by default), the web page
/// treats the link as expired.
class InviteLinkBuilder {
  InviteLinkBuilder._();

  /// Current token schema version, so the web page can evolve the payload.
  static const int _version = 1;

  /// Builds a tenant invite link valid for [validFor] (default 24 hours).
  static String buildTenantInviteLink({
    required String pgId,
    required String pgName,
    Duration validFor = const Duration(hours: 24),
  }) {
    final now = DateTime.now();
    final payload = <String, dynamic>{
      'v': _version,
      'pgId': pgId,
      'pgName': pgName,
      'iat': now.millisecondsSinceEpoch,
      'exp': now.add(validFor).millisecondsSinceEpoch,
    };

    // base64url without padding, so the token is URL-safe.
    final token = base64Url
        .encode(utf8.encode(jsonEncode(payload)))
        .replaceAll('=', '');

    return '${WebConfig.baseUrl}${WebConfig.invitePath}/$token';
  }
}
