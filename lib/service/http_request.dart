import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      // You can log the cert.subject if you want to restrict it more
      return true; // allow any cert (not recommended for prod)
    };
    return client;
  }
}

Future<void> loadCertificate() async {
  final sslCert = await rootBundle.load('assets/certificates/fullchain.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
}
