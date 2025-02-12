import 'dart:convert';
import 'package:crypto/crypto.dart';

void main() {
  String password = "ananamı"; // Test için şifre
  String hashedPassword = sha512.convert(utf8.encode(password)).toString();

  print("SHA-512 ile Hashlenmiş Şifre: $hashedPassword");
}
