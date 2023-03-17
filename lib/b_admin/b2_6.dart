import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:treasure_map/widgets/custom_container.dart';
import 'package:treasure_map/widgets/pattern_lock.dart';

import '../a_main/a6_1.dart';
import '../admin.dart';
import '../api/admin.dart';
import '../main.dart';
import '../provider/admin_info.dart';
import '../provider/app_management.dart';
import '../widgets/access_token_time_over.dart';
import '../widgets/login_route.dart';
import '../widgets/token_time_over.dart';

class PasswordSetting extends StatefulWidget {
  const PasswordSetting({
    Key? key,
    required this.type,
    required this.passwordSetting,
  }) : super(key: key);
  final int type;
  final Function(String) passwordSetting;

  @override
  State<PasswordSetting> createState() => _PasswordSettingState();
}

class _PasswordSettingState extends State<PasswordSetting> {
  String simplePW = '';
  String firstPassword = '';
  String secondPassword = '';
  List<bool> insertPW = [
    false,
    false,
    false,
    false,
  ];

  int count = 0;

  confirmPassword(String _password) {
    setState(() {
      secondPassword = _password;
      if (secondPassword == firstPassword) {
        widget.passwordSetting(firstPassword);
        Navigator.pop(context);
      } else {
        count = 2;
      }
    });
  }

  setPassword(String _password) {
    if (_password.length < 4) {
      setState(() {
        count = 4;
      });
    } else {
      setState(() {
        firstPassword = _password;
        count = 1;
      });
    }
  }

  simplePWSetting(String value) {
    if (value == 'X') {
      simplePW = '';
      setState(() {
        for (int i = 0; i < 4; i++) {
          insertPW[i] = false;
        }
      });
    } else if (value == '←') {
      if (simplePW.isNotEmpty) {
        simplePW = simplePW.substring(0, simplePW.length - 1);
      }
      setState(() {
        for (int i = 3; i > -1; i--) {
          if (insertPW[i]) {
            insertPW[i] = false;
            break;
          }
        }
      });
    } else if (value == '취소') {
      Navigator.pop(context);
    } else {
      if (simplePW.length < 4) {
        simplePW = simplePW + value;
        setState(() {
          for (int i = 0; i < 4; i++) {
            if (!insertPW[i]) {
              insertPW[i] = true;
              break;
            }
          }
        });
      }
    }
    print(simplePW);
    if (simplePW.length == 4) {
      if (count == 0) {
        setPassword(simplePW);
        simplePW = '';
      } else if (count == 1) {
        confirmPassword(simplePW);
        simplePW = '';
      } else if (count == 2) {
        setPassword(simplePW);
        simplePW = '';
      }
      for (int i = 0; i < 4; i++) {
        insertPW[i] = false;
      }
    }
  }


  @override
  void initState() {
    // Future.delayed(const Duration(milliseconds: 300), () {
    //   setState(() {
    //     test = false;
    //   });
    // });

    // WidgetsBinding.instance?.addPostFrameCallback(_afterLayout);
    // TODO: implement initState
    super.initState();
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
              width: 420.w,
            ),
            Container(
              width: 400.w,
              height: MediaQuery.of(context).size.height,
              child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: ListView(
                    physics: const RangeMaintainingScrollPhysics(),
                    children: [

                      SizedBox(
                        height: 80.w,
                      ),

                      if (widget.type == 2) ...[
                        Container(
                          height: 150.w,
                          child: Column(
                            children: [
                              Text(
                                '간편 비밀번호',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff393838)),
                              ),
                              SizedBox(
                                height: 10.w,
                              ),
                              if (count == 0) ...[
                                Text(
                                  '비밀번호를 입력해주세요.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393838)),
                                ),
                              ] else if (count == 1) ...[
                                Text(
                                  '한 번 더 입력해주세요.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393838)),
                                ),
                              ] else if (count == 2) ...[
                                Text(
                                  '비밀번호가 일치하지 않습니다.\n'
                                  '처음부터 다시 실행해주세요.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393838)),
                                ),
                              ],
                              Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: 30.w,
                                    height: 30.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.w)),
                                        color: insertPW[0]
                                            ? Color(0xFFFED796)
                                            : Colors.white,
                                        border: Border.all(
                                            width: 2.w,
                                            color: Color(0xFFFED796))),
                                  ),
                                  Container(
                                    width: 30.w,
                                    height: 30.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.w)),
                                        color: insertPW[1]
                                            ? Color(0xFFFED796)
                                            : Colors.white,
                                        border: Border.all(
                                            width: 2.w,
                                            color: Color(0xFFFED796))),
                                  ),
                                  Container(
                                    width: 30.w,
                                    height: 30.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.w)),
                                        color: insertPW[2]
                                            ? Color(0xFFFED796)
                                            : Colors.white,
                                        border: Border.all(
                                            width: 2.w,
                                            color: Color(0xFFFED796))),
                                  ),
                                  Container(
                                    width: 30.w,
                                    height: 30.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.w)),
                                        color: insertPW[3]
                                            ? Color(0xFFFED796)
                                            : Colors.white,
                                        border: Border.all(
                                            width: 2.w,
                                            color: Color(0xFFFED796))),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            NumberBtn(
                                number: "1", simplePWSetting: simplePWSetting),
                            NumberBtn(
                                number: "2", simplePWSetting: simplePWSetting),
                            NumberBtn(
                                number: "3", simplePWSetting: simplePWSetting),
                          ],
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            NumberBtn(
                                number: "4", simplePWSetting: simplePWSetting),
                            NumberBtn(
                                number: "5", simplePWSetting: simplePWSetting),
                            NumberBtn(
                                number: "6", simplePWSetting: simplePWSetting),
                          ],
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            NumberBtn(
                                number: "7", simplePWSetting: simplePWSetting),
                            NumberBtn(
                                number: "8", simplePWSetting: simplePWSetting),
                            NumberBtn(
                                number: "9", simplePWSetting: simplePWSetting),
                          ],
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            NumberBtn(
                                number: "X", simplePWSetting: simplePWSetting),
                            NumberBtn(
                                number: "0", simplePWSetting: simplePWSetting),
                            NumberBtn(
                                number: insertPW[0] ? "←" : "취소",
                                simplePWSetting: simplePWSetting),
                          ],
                        ),
                      ] else if (widget.type == 1) ...[

                        Container(
                          height: 30.w,
                          child: Text(
                            '패턴',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff393838)),
                          ),
                        ),


                        SizedBox(
                          height: 10.w,
                        ),
                        if (count == 0) ...[
                          Container(
                            height: 55.w,
                            child: Text(
                              '패턴을 입력해주세요.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff393838)),
                            ),
                          ),
                        ]
                        else if (count == 1) ...[
                          Container(
                            height: 55.w,
                            child: Text(
                              '한 번 더 입력해주세요.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff393838)),
                            ),
                          ),
                        ]
                        else if (count == 2) ...[
                          Container(
                            height: 55.w,
                            child: Text(
                              '패턴이 일치하지 않습니다.\n'
                              '처음부터 다시 실행해주세요.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff393838)),
                            ),
                          ),
                        ]else
                        ...[
                          Container(
                            height: 55.w,
                            child: Text(
                              '최소 4개 이상의 점을 연결해주세요.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff393838)),
                            ),
                          ),
                        ],
                        if (count == 0) ...[
                          PatternLock(
                            width: 400.w,
                            height: 400.w,
                            settingPassword: setPassword,
                          ),
                        ] else if (count == 1) ...[
                          PatternLock(
                            width: 400.w,
                            height: 400.w,
                            settingPassword: confirmPassword,
                          ),
                        ] else if (count == 2) ...[
                          PatternLock(
                            width: 400.w,
                            height: 400.w,
                            settingPassword: setPassword,
                          ),
                        ] else if (count == 4) ...[
                          PatternLock(
                            width: 400.w,
                            height: 400.w,
                            settingPassword: setPassword,
                          ),
                        ],
                        // PatternLock(
                        //   width: 400.w, height: 400.w, settingPassword: setPassword,),
                        SizedBox(
                          height: 25.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 120.w,
                            ),
                            SizedBox(
                              width: 50.w,
                              height: 50.w,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); //아무내용 없이 dialog 종료
                                },
                                child: Text(
                                  'X',
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFA666FB)),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.0,
                                  primary: const Color(0xFFFFFFFF),
                                  onPrimary: const Color(0xFF393838),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.w)),
                                  // side:
                                  // BorderSide(width: 2.w,color: Color(0xFFA666FB)),
                                  // fixedSize: Size(150.w, 50.w)
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120.w,
                            ),
                          ],
                        ),
                      ],
                    ],
                  )),
            ),
            SizedBox(
              width: 420.w,
            ),
          ],
        ),
      ),
    );
  }
}

class NumberBtn extends StatefulWidget {
  const NumberBtn({
    Key? key,
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
      onTap: () {
        widget.simplePWSetting(widget.number);
      },
      child: Container(
        width: 90.w,
        height: 90.w,
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.all(Radius.circular(20.w)),
            color: Colors.white,
            shape: BoxShape.circle
            // border: Border.all(width: 2.w, color: Color(0xFFFED796))
            ),
        child: Center(
          child: Text(
            widget.number,
            style: TextStyle(
              fontSize: widget.number == "취소" ? 24.sp : 30.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xff393838),
            ),
          ),
        ),
      ),
    );
  }
}
