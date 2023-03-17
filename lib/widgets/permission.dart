import 'package:permission_handler/permission_handler.dart';

class PermissionAccept{
  Future<bool> permissionStorage() async{
    Map<Permission, PermissionStatus> statuses =
    await [Permission.storage].request();

    if(await Permission.storage.isGranted){
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  Future<bool> permissionCamera() async{
    Map<Permission, PermissionStatus> statuses =
    await [Permission.camera].request();

    if(await Permission.camera.isGranted){
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

}
