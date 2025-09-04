import 'package:device_info_plus/device_info_plus.dart';

class AdService {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Future<String?> getDeviceId() async {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    return androidInfo.id;
  }
}
