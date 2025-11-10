import 'package:flutter/services.dart';

class NativeCommunicator {
  static const MethodChannel _channel = MethodChannel('com.example.app/native');

  static Future<String> invokeNativeMethod(String method, [Map<String, dynamic>? arguments]) async {
    try {
      final String result = await _channel.invokeMethod(method, arguments);
      return result;
    } on PlatformException catch (e) {
      print("Failed to invoke native method: '${e.message}'.");
      return "Error: ${e.message}";
    }
  }
}
