import '../../localization/l10n.dart';
import '../../rgb_validator.dart';

class UrlValidator extends TranslatedValidator<String> {
  UrlValidator({
    this.protocols = const ['http', 'https', 'ftp'],
    this.requireTld = true,
    this.requireProtocol = false,
    this.allowUnderscore = false,
    this.hostWhitelist = const [],
    this.hostBlacklist = const [],
    super.errorText,
    super.checkNullOrEmpty,
  });

  final List<String> protocols;
  final bool requireTld;
  final bool requireProtocol;
  final bool allowUnderscore;
  final List<String> hostWhitelist;
  final List<String> hostBlacklist;

  final int _maxUrlLength = 2083;

  @override
  String get translatedErrorText =>
      FormBuilderLocalizations.current.urlErrorText;

  @override
  String? validateValue(String valueCandidate) {
    return isURL(valueCandidate) ? null : errorText;
  }

  bool isURL(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.length > _maxUrlLength ||
        value.startsWith('mailto:')) {
      return false;
    }

    final uri = Uri.tryParse(value);
    if (uri == null) return false;

    // Protocol check
    if (requireProtocol && (uri.scheme.isEmpty)) {
      return false;
    }

    if (uri.scheme.isNotEmpty &&
        !protocols.contains(uri.scheme.toLowerCase())) {
      return false;
    }

    final host = uri.host;

    if (host.isEmpty) return false;

    // ❌ HARD REJECT: IP addresses
    if (_isIP(host)) return false;

    // Allow localhost (remove this if you want stricter validation)
    if (host != 'localhost' &&
        !isFQDN(
          host,
          requireTld: requireTld,
          allowUnderscores: allowUnderscore,
        )) {
      return false;
    }

    if (hostWhitelist.isNotEmpty && !hostWhitelist.contains(host)) {
      return false;
    }

    if (hostBlacklist.isNotEmpty && hostBlacklist.contains(host)) {
      return false;
    }

    return true;
  }

  bool isFQDN(
    String str, {
    bool requireTld = true,
    bool allowUnderscores = false,
  }) {
    final parts = str.split('.');

    if (requireTld) {
      final tld = parts.removeLast();
      if (parts.isEmpty || !RegExp(r'^[a-z]{2,}$', caseSensitive: false).hasMatch(tld)) {
        return false;
      }
    }

    final partPattern = allowUnderscores
        ? r'^[a-z0-9-_]+$'
        : r'^[a-z0-9-]+$';

    for (final part in parts) {
      if (!RegExp(partPattern, caseSensitive: false).hasMatch(part)) {
        return false;
      }

      if (part.startsWith('-') ||
          part.endsWith('-') ||
          part.contains('---') ||
          (allowUnderscores && part.contains('__'))) {
        return false;
      }
    }

    return true;
  }

  // Simple IP detector (IPv4 + IPv6)
  bool _isIP(String host) {
    final ipv4 = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    final ipv6 = RegExp(r'^[0-9a-fA-F:]+$');

    if (ipv4.hasMatch(host)) {
      final parts = host.split('.');
      return parts.every((p) {
        final n = int.tryParse(p);
        return n != null && n >= 0 && n <= 255;
      });
    }

    return ipv6.hasMatch(host);
  }
}