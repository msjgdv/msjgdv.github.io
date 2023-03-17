// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:treasure_map/widgets/token_decode.dart';
// import 'package:treasure_map/widgets/token_time_over.dart';
// import 'package:dio/dio.dart';
//
// import '../api/login.dart';
//
// accessTokenCheck(context) async {
//   final autoLoginStorage = FlutterSecureStorage();
//   int _timeStamp = DateTime.now().millisecondsSinceEpoch - 10000;
//   final _token = await autoLoginStorage.read(key: "signInToken");
//   final tokenTimeStamp = tokenDecode(_token!, "exp");
//
//   if (_timeStamp >= tokenTimeStamp) {
//     Dio dio = Dio();
//     final client = restLoginClient;
//     final refreshToken = await autoLoginStorage
//         .read(key: "cookie");
//     String responseError = '200';
//     final response = await client
//         .getNewAccessToken(_token, refreshToken.toString().split('=')[1].split(';')[0])
//         .catchError((Object obj) {
//       final res = (obj as DioError).response;
//       switch (res!.statusCode) {
//         case 401:
//           responseError = '401';
//           break;
//         case 419:
//           responseError = '419';
//           tokenTimeOverPopUP(context);
//           break;
//         case 500:
//           responseError = '500';
//           break;
//         default:
//           break;
//       }
//     });
//     if(responseError == '200'){
//       await autoLoginStorage.write(
//           key: "signInToken", value: response.token);
//     }
//   } else {
//     return;
//   }
// }
