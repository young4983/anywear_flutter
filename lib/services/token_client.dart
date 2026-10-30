import 'dart:async';
import 'dart:convert';

import '../l10n/locale_utils.dart';
import 'dart:io';
import 'dart:typed_data';

/// Permanent Decart keys never go through this client. Supply the signed-in
/// user's short-lived app access token from your existing authentication layer.
class TokenClient {
  TokenClient({required this.endpoint, this.accessTokenProvider});

  final Uri endpoint;
  final Future<String?> Function()? accessTokenProvider;

  Future<String> fetch() async {
    if (endpoint.scheme != 'https' ||
        endpoint.host.isEmpty ||
        endpoint.userInfo.isNotEmpty ||
        endpoint.hasQuery ||
        endpoint.hasFragment) {
      throw TokenException(currentAppLocalizations().tokenEndpointInvalid);
    }
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);
    try {
      final appToken = await accessTokenProvider?.call();
      final request = await client.postUrl(endpoint);
      // Do not follow a redirect with the app's Authorization header.
      request.followRedirects = false;
      request.headers.contentType = ContentType.json;
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      if (appToken != null && appToken.isNotEmpty) {
        request.headers.set(
          HttpHeaders.authorizationHeader,
          'Bearer $appToken',
        );
      }
      request.write('{}');
      final response = await request.close().timeout(
        const Duration(seconds: 15),
      );
      if (response.statusCode == 401 || response.statusCode == 403) {
        throw TokenException(currentAppLocalizations().loginExpired);
      }
      if (response.statusCode == 429) {
        throw TokenException(currentAppLocalizations().serviceBusy);
      }
      if (response.statusCode != 200) {
        throw TokenException(currentAppLocalizations().serviceUnavailable);
      }
      final bytes = BytesBuilder(copy: false);
      await for (final chunk in response.timeout(const Duration(seconds: 15))) {
        if (bytes.length + chunk.length > 64 * 1024) {
          throw TokenException(currentAppLocalizations().invalidResponse);
        }
        bytes.add(chunk);
      }
      return parseTokenResponse(utf8.decode(bytes.takeBytes()));
    } finally {
      client.close(force: true);
    }
  }
}

String parseTokenResponse(String body) {
  try {
    final payload = jsonDecode(body);
    if (payload is! Map<String, dynamic>) {
      throw const FormatException();
    }
    final token = payload['apiKey'];
    // Current Decart responses use signed JWTs; older responses used ek_.
    // This is format validation only. Decart verifies the token signature.
    if (token is! String ||
        !((token.startsWith('ek_') && token.length > 3) ||
            RegExp(
              r'^[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+$',
            ).hasMatch(token))) {
      throw const FormatException();
    }
    final expiresAt = payload['expiresAt'];
    if (expiresAt is String) {
      final expiry = DateTime.tryParse(expiresAt);
      if (expiry == null || !expiry.isAfter(DateTime.now().toUtc())) {
        throw const FormatException();
      }
    }
    return token;
  } on FormatException {
    throw TokenException(currentAppLocalizations().credentialExpired);
  }
}

class TokenException implements Exception {
  const TokenException(this.message);
  final String message;
  @override
  String toString() => message;
}
