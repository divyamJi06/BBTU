import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermission(Permission permission) async {
  final status = await permission.request();
  // print(status);
  if (status.isDenied) {
    requestPermission(permission);
  }
}
