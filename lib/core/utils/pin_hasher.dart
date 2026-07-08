import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Hashes a PIN before storing it in Hive, so the raw PIN never touches
/// disk. This is a local-device lock, not a security-critical secret, but
/// hashing is still good practice.
class PinHasher {
  PinHasher._();

  static String hash(String pin) {
    final bytes = utf8.encode('dito_gym_tracker_salt::$pin');
    return sha256.convert(bytes).toString();
  }

  static bool verify(String pin, String hash) {
    return PinHasher.hash(pin) == hash;
  }
}
