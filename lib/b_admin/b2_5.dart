import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../a_main/a1.dart';
import '../api/admin.dart';


const autoLoginStorage = FlutterSecureStorage();

class showPopUpB2_5 extends StatefulWidget {
  const showPopUpB2_5({
    required this.email,
    required this.name,
    required this.pwd,
    Key? key,
  }) : super(key: key);
  final String name;
  final String email;
  final String pwd;

  @override
  State<showPopUpB2_5> createState() => _showPopUpB2_5State();
}

class _showPopUpB2_5State extends State<showPopUpB2_5> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 480.w,
          height: 250.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: const Color(0xFF7649B7), width: 1.w),
              color: const Color(0xFFE2D3FE)),
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(0.w, 74.w, 0.w, 0.w),
                  child: Text('정말로 탈퇴하시겠습니까?',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF393838)))),
              Container(
                margin: EdgeInsets.fromLTRB(59.w, 62.w, 0.w, 0.w),
                child: Row(
                  children: [
                    SizedBox(
                        //width: 150.w,
                        height: 50.w,
                        child: ElevatedButton(
                            onPressed: () async {
                              String responseError = '200';
                              //final client = RestWithdrawClient(dio);

                              final adminToken = await autoLoginStorage.read(
                                  key: "adminToken");

                              AdminCheck adminCheck = AdminCheck(name: widget.name, email: widget.email, password: widget.pwd);

                              // final response = await client
                              //     .postAdminWithdraw(token2.toString(), adminCheck)
                              //     .catchError((Object obj) {
                              //   final res = (obj as DioError).response;
                              //   switch (res!.statusCode) {
                              //     case 401:
                              //       responseError = res.statusCode.toString();
                              //       print(401);
                              //       break;
                              //     case 403:
                              //       responseError = res.statusCode.toString();
                              //       print(403);
                              //       break;
                              //     case 412:
                              //       responseError = res.statusCode.toString();
                              //       showToast('개인정보가 일치하지 않습니다.');
                              //       print(412);
                              //       break;
                              //     case 419:
                              //       responseError = res.statusCode.toString();
                              //       print(419);
                              //       break;
                              //     case 500:
                              //       responseError = res.statusCode.toString();
                              //       print(500);
                              //       break;
                              //     default:
                              //       break;
                              //   }
                              //   return obj.response;
                              // });
                              if (responseError == '200') {
                                Navigator.pop(
                                  context, );
                                autoLoginStorage.delete(key: "login");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const A1()));
                              }
                            },
                            child: Text('예, 탈퇴합니다',
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w400)),
                            style: ElevatedButton.styleFrom(
                                elevation: 1.0,
                                primary: const Color(0xFFFFFFFF),
                                onPrimary: const Color(0xFF393838),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.w)),
                                side: const BorderSide(
                                    color: Color(0xFFA666FB))))),
                    Container(
                        width: 150.w,
                        height: 50.w,
                        margin: EdgeInsets.fromLTRB(62.w, 0.w, 0.w, 0.w),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); //결과 반영 dialog 종료
                            },
                            child: Text('아니오',
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w400)),
                            style: ElevatedButton.styleFrom(
                                elevation: 1.0,
                                primary: const Color(0xFFFFFFFF),
                                onPrimary: const Color(0xFF393838),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.w)),
                                side: const BorderSide(
                                    color: Color(0xFFA666FB)))))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}


void showToast(String message) {
  Fluttertoast.showToast(
      textColor: Colors.white,
      msg: message,
      backgroundColor: Colors.grey,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM);
}
