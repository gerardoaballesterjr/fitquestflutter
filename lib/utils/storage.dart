import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<Map<String, dynamic>> userInfo() async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'access');
  return JwtDecoder.decode(token as String);
}
