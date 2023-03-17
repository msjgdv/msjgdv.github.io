import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../admin.dart';
import '../api/admin.dart';
import 'b2_5.dart';
//회원 탈퇴
final autoLoginStorage = FlutterSecureStorage();

class showPopUpB2_4 extends StatefulWidget {
  const showPopUpB2_4({Key? key}) : super(key: key);

  @override
  State<showPopUpB2_4> createState() => _showPopUpB2_4State();
}

class _showPopUpB2_4State extends State<showPopUpB2_4> {
  final myControllerNameQuit = TextEditingController();
  final myControllerEmailQuit = TextEditingController();
  final myControllerPwdQuit = TextEditingController();

  List<String> quitInfo = List<String>.filled(3, '');

  bool checkConfirm = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
              width: 800.w,
              height: 550.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.w),
                  color: const Color(0xFFFCF9F4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 800.w,
                      height: 35.w,
                      margin: EdgeInsets.fromLTRB(0.w, 40.w, 0.w, 0.w),
                      child: Text('회원 탈퇴',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24.sp,
                              color: const Color(0xFF393838)))),
                  Container(
                    width: 550.w,
                    height: 286.w,
                    margin: EdgeInsets.fromLTRB(125.w, 20.w, 125.w, 0.w),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: const Color(0xFFFDB43B), width: 1.w),
                        borderRadius: BorderRadius.circular(10.w)),
                    child: Column(
                      children: [
                        Container(
                          // width: 179.w,
                            height: 230.w,
                            // margin: EdgeInsets.fromLTRB(0.w, 99.w, 0.w, 0.w),
                            child: Center(
                                child: Text('안내 문구 출력',
                                    style: TextStyle(
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFFAAAAAA))))),
                        Container(
                          // margin: EdgeInsets.fromLTRB(15.w, 98.w, 0.w, 0.w),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 2.w,
                                    ),
                                    Checkbox(
                                        fillColor: MaterialStateProperty.all(
                                            Color(0xffFDB43B)),
                                        value: checkConfirm,
                                        onChanged: (val) {
                                          setState(() {
                                            checkConfirm = val!;
                                          });
                                        }),
                                  ],
                                ),
                                Container(
                                  height: 20.w,
                                  // margin: EdgeInsets.only(left: 15.w),
                                  child: Center(
                                    child: Text(
                                        '상기 TreasureMap 회원탈퇴 시 처리사항 안내를 확인하였으며 동의합니다.',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF393838))),
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                  Container(
                    width: 349.w,
                    height: 20.w,
                    margin: EdgeInsets.fromLTRB(125.w, 19.w, 0.w, 0.w),
                    child: Text('보안을 위해 회원님의 이름과 이메일, 비밀번호를 확인합니다.',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF393838))),
                  ),
                  Row(children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(38.w, 49.w, 0.w, 0.w),
                      child: Row(children: [
                        SizedBox(
                          width: 26.w,
                          height: 20.w,
                          child: Text('이름',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF393838))),
                        ),
                        Container(
                          width: 140.w,
                          height: 20.w,
                          margin: EdgeInsets.only(left: 10.w),
                          child: TextField(
                            controller: myControllerNameQuit,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF393838))
                          ),
                        ),
                        Container(
                          width: 39.w,
                          height: 20.w,
                          margin: const EdgeInsets.only(left: 20),
                          child: Text('이메일',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF393838))),
                        ),
                        Container(
                          width: 149.w,
                          height: 20.w,
                          margin: EdgeInsets.only(left: 10.w),
                          child: TextField(
                            controller: myControllerEmailQuit,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF393838))
                          ),
                        ),
                        Container(
                          width: 52.w,
                          height: 20.w,
                          margin: const EdgeInsets.only(left: 20),
                          child: Text('비밀번호',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF393838))),
                        ),
                        Container(
                          width: 149.w,
                          height: 20.w,
                          margin: EdgeInsets.only(left: 10.w),
                          child: TextField(
                            obscureText: true,
                            controller: myControllerPwdQuit,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF393838))
                          ),
                        ),
                      ]),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(20.w, 29, 0.w, 0.w),
                        child: checkConfirm == true ? ElevatedButton(
                            onPressed: () async {
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              //textfield로 받은 정보 출력
                              quitInfo[0] = myControllerNameQuit.text;
                              quitInfo[1] = myControllerEmailQuit.text;
                              quitInfo[2] = myControllerPwdQuit.text;
                              String responseError = '200';
                              Dio dio = Dio();
                              final client = RestAdminClient(dio: dio);

                              final adminToken = await autoLoginStorage.read(
                                  key: "adminToken");

                              AdminCheck adminCheck = AdminCheck(
                                name: myControllerNameQuit.text,
                                email: myControllerEmailQuit.text,
                                password: myControllerPwdQuit.text,);

                              final response = await client
                                  .postAdminCheck(adminToken.toString(), adminCheck)
                                  .catchError((Object obj) {
                                final res = (obj as DioError).response;
                                switch (res!.statusCode) {
                                  case 401:
                                    responseError = res.statusCode.toString();
                                    print(401);
                                    break;
                                  case 403:
                                    responseError = res.statusCode.toString();
                                    print(403);
                                    break;
                                  case 412:
                                    responseError = res.statusCode.toString();
                                    showToast('개인정보가 일치하지 않습니다.');
                                    print(412);
                                    break;
                                  case 419:
                                    responseError = res.statusCode.toString();
                                    print(419);
                                    break;
                                  case 500:
                                    responseError = res.statusCode.toString();
                                    print(500);
                                    break;
                                  default:
                                    responseError = res.statusCode.toString();
                                    break;
                                }
                                return obj.response;
                              });
                              if (responseError == '200') {
                                String name = myControllerNameQuit.text;
                                String email = myControllerEmailQuit.text;
                                String password = myControllerPwdQuit.text;
                                showDialog(context: context, builder: (BuildContext context){
                                  return showPopUpB2_5(name: name, pwd: password, email: email,);
                                });

                              }

                              //Navigator.pop(context, quitInfo);//결과 반영 dialog 종료
                            },
                            child: Text('본인확인',
                                style: TextStyle(
                                    fontSize: 14.w,
                                    fontWeight: FontWeight.w400)),
                            style: ElevatedButton.styleFrom(
                              elevation: 1.0,
                              primary: const Color(0xFFA666FB),
                              onPrimary: const Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.w)),
                              //fixedSize: Size(80.w,40.w)
                            )): ElevatedButton(
                            onPressed: () {
                              showToast('회원 탈퇴 약관에 동의해주세요.');
                            },
                            child: Text('본인확인',
                                style: TextStyle(
                                    fontSize: 14.w,
                                    fontWeight: FontWeight.w400)),
                            style: ElevatedButton.styleFrom(
                              elevation: 1.0,
                              primary: Colors.grey,
                              onPrimary: const Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.w)),
                              //fixedSize: Size(80.w,40.w)
                            )))

                  ])
                ],
              )),
        ),
      ),
    );
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
