import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class DeviceReachability {
  static Future<bool> isAvailable() async {
    final states = await Connectivity().checkConnectivity();
    return states.any((state) => state != ConnectivityResult.none);
  }

  static Future<http.Response> request(
    String resource,
    bool useReadMethod,
  ) {
    final address = Uri.parse(resource);
    return useReadMethod ? http.get(address) : http.head(address);
  }
}