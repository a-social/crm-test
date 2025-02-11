# crm_k

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.




## AES-256 Şifreleme

# Daha güvenli bir yöntem olarak AES-256 şifreleme kullanabilirsin.

# Önce Dart'ta AES-256 şifrelemesi için encrypt paketini ekle:
yaml
##

dependencies:
  encrypt: ^5.0.0
Şifreleme kodunu ekle:
##


import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:io';

void main() {
  final key = encrypt.Key.fromUtf8('1234567890123456'); // 16, 24 veya 32 byte olmalı
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  String originalCode = File('bin/server.dart').readAsStringSync();
  String encrypted = encrypter.encrypt(originalCode, iv: iv).base64;

  File('server_encrypted.txt').writeAsStringSync(encrypted);
  print('Server dosyası şifrelendi.');
}
Şifrelenmiş kodu açmak için:
dart
Kopyala
Düzenle
void main() {
  final key = encrypt.Key.fromUtf8('1234567890123456');
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  String encryptedData = File('server_encrypted.txt').readAsStringSync();
  String decrypted = encrypter.decrypt64(encryptedData, iv: iv);

  File('server_decoded.dart').writeAsStringSync(decrypted);
  Process.run('dart', ['server_decoded.dart']).then((result) {
    print(result.stdout);
  });
}
## 🔒 Bu yöntem ile sadece anahtara sahip olan kişiler server.dart kodunu okuyabilir ve çalıştırabilir.

<!-- 🔥 Sonuç
Yöntem	Açıklama	                                                                                    Güvenlik Seviyesi
Dart compile exe ile çalıştırılabilir dosya yapma	.dart kodunu .exe/.bin haline getirir ve gizler.	Orta ✅
Base64 ile kod gizleme	Kodları Base64 formatına çevirir, ancak teknik olarak çözülebilir.	            Düşük ⚠️
AES-256 ile şifreleme	Şifreleme anahtarı olmadan kod okunamaz hale gelir.	                            Yüksek 🔒
✅ Eğer sadece çalıştırılabilir hale getirmek istiyorsan → dart compile exe kullan.
🔒 Eğer kodlarını tamamen korumak istiyorsan → AES-256 şifreleme kullan.
 -->