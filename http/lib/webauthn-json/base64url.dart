import 'dart:convert';
import 'dart:typed_data';

/// A simple typedef for readability
typedef Base64UrlString = String;

/// Convert a base64url-encoded string (no padding, '-' and '_' instead of '+' and '/') 
/// into a [Uint8List] of bytes.
Uint8List base64urlToBuffer(Base64UrlString baseurl64String) {
  // 1. Convert base64url to standard base64
  final padding = '=='.substring(0, (4 - (baseurl64String.length % 4)) % 4);
  final base64String = baseurl64String
      .replaceAll('-', '+')
      .replaceAll('_', '/') 
    + padding;

  // 2. Decode the standard base64 string into bytes
  return base64.decode(base64String);
}

/// Convert a [Uint8List] of bytes into a base64url-encoded string 
/// (no padding, '+' -> '-', '/' -> '_')
Base64UrlString bufferToBase64url(Uint8List buffer) {
  // 1. Encode to standard base64
  final base64String = base64.encode(buffer);

  // 2. Replace characters to get base64url format and remove any '=' padding
  return base64String
      .replaceAll('+', '-')
      .replaceAll('/', '_')
      .replaceAll('=', '');
}
