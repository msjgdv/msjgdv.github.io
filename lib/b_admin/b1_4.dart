import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/custom_container.dart';
import 'package:treasure_map/widgets/pattern_lock.dart';
import 'package:http/http.dart' as http;
import '../a_main/a6_1.dart';
import '../admin.dart';
import '../api/admin.dart';
import '../main.dart';
import '../provider/admin_info.dart';
import '../provider/app_management.dart';
import '../widgets/access_token_time_over.dart';
import '../widgets/login_route.dart';
import '../widgets/token_time_over.dart';

class AdminGateCheck extends StatefulWidget {
  const AdminGateCheck({Key? key,
    this.type = 'simplePW',
  }) : super(key: key);
  final String type;

  @override
  State<AdminGateCheck> createState() => _AdminGateCheckState();
}

class _AdminGateCheckState extends State<AdminGateCheck> {
  TextEditingController myControllerPwdCheck = TextEditingController();
  String pwdCheck = '';

  final autoLoginStorage = const FlutterSecureStorage();

  postPW() async {
    ApiUrl apiUrl = ApiUrl();
    pwdCheck = myControllerPwdCheck.text;
    http.Response res = await api(apiUrl.check, 'post', 'signInToken', {
      'password': pwdCheck,
      'type': "admin"
    }, context);
    if(res.statusCode == 200){
      var pwTokenRB = utf8.decode(res.bodyBytes);
      var pwTokenData = jsonDecode(pwTokenRB);
      await autoLoginStorage.write(
          key: "adminToken", value: pwTokenData['token']);
      http.Response statusRes = await api(apiUrl.status, 'get', 'adminToken', {}, context);
      if(statusRes.statusCode == 200){
        var statusRB = utf8.decode(statusRes.bodyBytes);
        var statusData = jsonDecode(statusRB);
        Provider.of<UserInfo>(context, listen: false).auth = statusData["status"];
        Provider.of<UserInfo>(context, listen: false).role = statusData["type"];
        print(Provider.of<UserInfo>(context, listen: false).auth);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminPage()),
        );
      }
    }
  }

  String simplePW = '';
  List<bool> insertPW = [
    false,
    false,
    false,
    false,
  ];

  setPassword(String _password){
    setState(() {
      simplePW = _password;
    });
  }

  simplePWSetting(String value){
    if(value == 'X'){
      simplePW = '';
      setState(() {
        for(int i = 0; i<4;i++){
          insertPW[i] = false;
        }
      });
    }else if(value == '←'){
      if(simplePW.isNotEmpty){
        simplePW = simplePW.substring(0,simplePW.length-1);
      }
      setState(() {
        for(int i = 3; i>-1;i--){
          if(insertPW[i]){
            insertPW[i] = false;
            break;
          }
        }
      });
    }else if(value == '취소'){
      Navigator.pop(context);
    }else{
      if(simplePW.length < 4){
        simplePW = simplePW + value;
        setState(() {
          for(int i = 0; i<4;i++){
            if(!insertPW[i]){
              insertPW[i] = true;
              break;
            }
          }
        });
      }
    }
    print(simplePW);
    if(simplePW.length == 4){
      print("postAPI");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFFFCF9F4),
        child: Row(
          children: [
            SizedBox(
              width: 395.w,
            ),
            Container(
              width: 450.w,
              height: MediaQuery.of(context).size.height,
              child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: const RangeMaintainingScrollPhysics(),
                    children: [


                      if(widget.type == 'PW')...[
                        SizedBox(
                          height: 150.w,
                        ),
                        SvgPicture.asset(
                          'assets/icons/icon_find_pw.svg',
                          width: 35.w,
                        ),
                        SizedBox(
                          height: 26.w,
                        ),
                        Text('비밀번호를 입력해주세요.',
                        style: TextStyle(
                          color: Color(0xff393838),
                          fontSize: 20.sp,

                        ),
                        textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 180.w,
                        ),

                        Container(
                            width: 450.w,
                            height: 50.w,
                            child: TextField(

                              style: TextStyle(
                                fontSize: 30.w,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff393838),
                              ),
                              textAlign: TextAlign.start,
                              obscureText: true,
                              controller: myControllerPwdCheck,
                              decoration:
                              InputDecoration(border: InputBorder.none, //밑줄 제거
                                hintText: '비밀번호 입력',
                                hintStyle: TextStyle(
                                 fontSize: 20.sp,
                                 color: Color(0xffB1B1B1)
                                ),

                              ),
                            )),
                        SizedBox(
                          height: 10.w,
                        ),
                        Container(
                          width: 500.w,
                          height: 2.w,
                          color: Color(0xFFFBB348),
                        ),

                        SizedBox(
                          height: 50.5.w,
                        ),
                        Row(
                          children: [

                            ElevatedButton(
                              onPressed: () async {
                                postPW();
                              },
                              child: Text('확인',
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w400,
                                  color: Colors.white)),

                              style: ElevatedButton.styleFrom(
                                  elevation: 1.0,
                                  primary: const Color(0xffA666FB),
                                  onPrimary: const Color(0xFF393838),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.w)),
                                  side:
                                  const BorderSide(color: Color(0xFFA666FB)),
                                  fixedSize: Size(200.w, 50.w)),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); //아무내용 없이 dialog 종료
                                // loginRoute(context, Provider.of<UserInfo>(context, listen: false).role);
                              },
                              child: Text('취소',
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w400)),
                              style: ElevatedButton.styleFrom(
                                  elevation: 1.0,
                                  primary: const Color(0xFFFFFFFF),
                                  onPrimary: const Color(0xFF393838),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.w)),
                                  side:
                                  const BorderSide(color: Color(0xFFA666FB)),
                                  fixedSize: Size(200.w, 50.w)),
                            ),

                          ],
                        )
                      ]else if(widget.type == 'simplePW')...[
                        SizedBox(
                          height: 104.w,
                        ),
                        SvgPicture.asset(
                          'assets/icons/icon_find_pw.svg',
                          width: 35.w,
                        ),
                        SizedBox(
                          height: 26.w,
                        ),
                        Text('비밀번호를 입력해주세요.',
                          style: TextStyle(
                            color: Color(0xff393838),
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 59.w,),
                        Row(
                          children: [
                            SizedBox(
                              width: 62.w,
                            ),
                            Container(
                              width: 324.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 36.w,
                                    height: 36.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20.w)),
                                      color: insertPW[0] ? Color(0xFFFED796) : Colors.white,
                                      border: Border.all(width: 2.w, color: Color(0xFFFED796))
                                    ),
                                  ),
                                  Container(
                                    width: 36.w,
                                    height: 36.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(20.w)),
                                        color: insertPW[1] ? Color(0xFFFED796) : Colors.white,
                                        border: Border.all(width: 2.w, color: Color(0xFFFED796))
                                    ),
                                  ),
                                  Container(
                                    width: 36.w,
                                    height: 36.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(20.w)),
                                        color: insertPW[2] ? Color(0xFFFED796) : Colors.white,
                                        border: Border.all(width: 2.w, color: Color(0xFFFED796))
                                    ),
                                  ),
                                  Container(
                                    width: 36.w,
                                    height: 36.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(20.w)),
                                        color: insertPW[3] ? Color(0xFFFED796) : Colors.white,
                                        border: Border.all(width: 2.w, color: Color(0xFFFED796))
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 62.w,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40.w,
                        ),
                        Row(
                          children: [
                            SizedBox(width: 50.w,),
                            Container(
                              width: 350.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  NumberBtn(number: "1",simplePWSetting: simplePWSetting),
                                  NumberBtn(number: "2",simplePWSetting: simplePWSetting),
                                  NumberBtn(number: "3",simplePWSetting: simplePWSetting),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 50.w,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30.w,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 50.w,
                            ),
                            SizedBox(
                              width: 350.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  NumberBtn(number: "4",simplePWSetting: simplePWSetting),
                                  NumberBtn(number: "5",simplePWSetting: simplePWSetting),
                                  NumberBtn(number: "6",simplePWSetting: simplePWSetting),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 50.w,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30.w,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 50.w,
                            ),
                            SizedBox(
                              width: 350.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  NumberBtn(number: "7",simplePWSetting: simplePWSetting),
                                  NumberBtn(number: "8",simplePWSetting: simplePWSetting),
                                  NumberBtn(number: "9",simplePWSetting: simplePWSetting),
                                ],
                              ),

                            ),
                            SizedBox(
                              width: 50.w,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30.w,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 50.w,
                            ),
                            SizedBox(
                              width: 350.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  NumberBtn(number: "X",simplePWSetting: simplePWSetting),
                                  NumberBtn(number: "0",simplePWSetting: simplePWSetting),
                                  NumberBtn(number: insertPW[0] ?  "←" : "취소", simplePWSetting: simplePWSetting),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 50.w,
                            ),
                          ],
                        ),

                      ]else if(widget.type == 'pattern')...[
                        SizedBox(
                          height: 150.w,
                        ),
                        SvgPicture.asset(
                          'assets/icons/icon_find_pw.svg',
                          width: 35.w,
                        ),
                        SizedBox(
                          height: 26.w,
                        ),
                        Text('패턴을 입력해주세요.',
                          style: TextStyle(
                            color: Color(0xff393838),
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20.w,
                        ),
                        PatternLock(width: 300.w, height: 300.w, settingPassword: setPassword,),
                        SizedBox(
                          height: 25.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 120.w,),
                            SizedBox(
                              width: 50.w,
                              height: 50.w,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); //아무내용 없이 dialog 종료
                                  // loginRoute(context, Provider.of<UserInfo>(context, listen: false).role);
                                },
                                child: Text('X',
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w400,
                                    color: Color(0xFFA666FB)),),
                                style: ElevatedButton.styleFrom(
                                    elevation: 2.0,
                                    primary: const Color(0xFFFFFFFF),
                                    onPrimary: const Color(0xFF393838),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.w)),
                                    side:
                                    BorderSide(width: 1.w,color: Color(0xFFA666FB)),
                                    // fixedSize: Size(150.w, 50.w)
                                ),
                              ),
                            ),
                            SizedBox(width: 120.w,),
                          ],
                        ),
                      ],


                    ],
                  )),
            ),
            SizedBox(
              width: 395.w,
            ),
          ],
        ),
      ),
    );
  }
}

class NumberBtn extends StatefulWidget {
  const NumberBtn({Key? key,
    required this.number,
    required this.simplePWSetting,
  }) : super(key: key);
  final String number;
  final Function(String) simplePWSetting;

  @override
  State<NumberBtn> createState() => _NumberBtnState();
}

class _NumberBtnState extends State<NumberBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.simplePWSetting(widget.number);
      },
      child: Container(
        width: 70.w,
        height: 70.w,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.all(Radius.circular(20.w)),
            color: Colors.white,
            shape: BoxShape.circle,
          border: Border.all(width: 1.w, color: Color(0x4dA666FB))
        ),
        child: Center(
          child: Text(widget.number,
            style: TextStyle(
              fontSize: widget.number == "취소" ? 20.sp:24.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xff393838),
            ),),
        ),
      ),
    );
  }
}
