import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:treasure_map/a_main/a1.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../provider/app_management.dart';

void tokenTimeOverPopUP(context) {
  final autoLoginStorage = FlutterSecureStorage();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(

          child: Container(
            width: 500.w,
            height: 200.w,
            child: Column(
              children: [
                SizedBox(
                  height: 50.w,
                ),
                Container(
                  child: Text('로그인 인증시간이 만료 되었습니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.w,
                    color: Color(0xff393838),
                    fontWeight: FontWeight.w400
                  ),),
                ),
                Spacer(),
                Container(
                  width: 120.w,
                  height: 35.w,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    onPressed: () async {
                      String? token = await autoLoginStorage.read(
                          key: "signInToken");
                      Map<String, dynamic> payload = Jwt.parseJwt(token.toString());
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => A1(overToken: true, identification: payload["identification"], value: Provider.of<UserInfo>(context, listen: false).value[0],)),

                      );

                    },
                    child: Text('확인',
                    style: TextStyle(
                      fontSize: 17.w
                    ),),
                  ),
                ),
                SizedBox(
                  height: 40.w,
                )
              ],
            ),
          ),
        );
      });
}
