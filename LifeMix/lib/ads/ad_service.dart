import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class AdService {
  static Future<bool> isHuawei() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.manufacturer?.toLowerCase() == 'huawei';
    }
    return false;
  }
}
