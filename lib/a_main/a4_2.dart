import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/a_main/a4_3.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:treasure_map/widgets/api.dart';
import 'a4_1.dart';

class A4_2 extends StatefulWidget {
  const A4_2({Key? key,
    this.email = '',
    this.phoneNumber = '',
  }) : super(key: key);
  final String email;
  final String phoneNumber;

  @override
  State<A4_2> createState() => _A4_2State();
}

class _A4_2State extends State<A4_2> {
  static final autoLoginStorage = FlutterSecureStorage();
  final formKey = GlobalKey<FormState>();
  String authenticationNumber = '';

  setAuthenticationNumber(String number){
    return authenticationNumber = number;
  }

  ApiUrl apiUrl = ApiUrl();

  getCertifyEmail() async{
    http.Response res = await api('${apiUrl.email}?code=$authenticationNumber' , 'get', 'PWToken', {}, context);
    if(res.statusCode == 200){
      var rb = utf8.decode(res.bodyBytes);
      var data = jsonDecode(rb);
      await autoLoginStorage.write(
          key: "RePWToken", value: data['token']);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => A4_3(
              email: widget.email,
              phoneNumber: widget.phoneNumber,
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCF9F4),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: ListView(
            physics: const RangeMaintainingScrollPhysics(),
            children: [
              Row(
                children: [
                  Container(
                    width: 270.w,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 42,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 63,
                            ),
                            SvgPicture.asset(
                              'assets/icons/icon_find_pw.svg',
                              height: 32,
                              width: 32,
                            ),
                            SizedBox(
                              width: 17.w,
                            ),
                            Text(
                              '비밀번호 찾기',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 26.w,
                                color: Color(0xff393838),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 542.w,
                        ),
                        // Spacer(),
                        Row(
                          children: [
                            SizedBox(
                              width: 45.w,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                elevation: MaterialStateProperty.all(0),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => A4_1()),
                                );
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/icon_back.svg',
                                    height: 14.w,
                                    width: 23.w,
                                  ),
                                  SizedBox(
                                    width: 30.w,
                                  ),
                                  Text(
                                    '이전',
                                    style: TextStyle(
                                      fontSize: 26.w,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393838),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 45.w,
                        )
                      ],
                    ),
                  ),
                  AuthenticationNumberPage(
                    formKey: formKey,
                    setAuthenticationNumber: setAuthenticationNumber,
                    email: widget.email,
                    phoneNumber: widget.phoneNumber,
                  ),
                  Container(
                    width: 270.w,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 616.w,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 110.w,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                elevation: MaterialStateProperty.all(0),
                              ),
                              onPressed: () async {
                                getCertifyEmail();
                              },
                              child: Row(
                                children: [
                                  Text(
                                    '다음',
                                    style: TextStyle(
                                      fontSize: 26.w,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393838),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30.w,
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/icon_next.svg',
                                    height: 14.w,
                                    width: 23.w,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 45.w,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFindPWField extends StatelessWidget {
  final String _text;
  final FormFieldSetter _onSaved;
  final FormFieldValidator _validator;

  const CustomFindPWField(this._text, this._onSaved, this._validator);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: _onSaved,
      validator: _validator,
      onChanged: _onSaved,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        fontSize: 20.w,
        fontWeight: FontWeight.w400,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintStyle: TextStyle(
          fontSize: 20.w,
          fontWeight: FontWeight.w400,
          color: Color(0xff838383),
        ),
        hintText: "$_text",
        contentPadding: EdgeInsets.symmetric(
          vertical: 0.w,
          horizontal: 5.w,
        ),
      ),
    );
  }
}

class AuthenticationNumberPage extends StatefulWidget {
  const AuthenticationNumberPage({
    Key? key,
    required this.formKey,
    required this.setAuthenticationNumber,
    required this.email,
    required this.phoneNumber,
  }) : super(key: key);
  final String email;
  final String phoneNumber;
  final GlobalKey<FormState> formKey;
  final Function setAuthenticationNumber;

  @override
  State<AuthenticationNumberPage> createState() =>
      _AuthenticationNumberPageState();
}

class _AuthenticationNumberPageState extends State<AuthenticationNumberPage> {
  String authenticationNumber = '';
  final autoLoginStorage = FlutterSecureStorage();
  late Timer timer;
  var time = 0;
  bool timeout = false;
  Widget timeText() {
    var minute = (5 - (time / 60)).toInt();
    var second = '${60 - (time % 60)}'.padLeft(2, '0');

    return Row(
      children: [
        Text(
          '0',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xff393838),
          ),
        ),
        Text(
          '$minute',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xff393838),
          ),
        ),
        Text(
          ':',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xff393838),
          ),
        ),
        Text(
          second == '60' ? '00' :
          second,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xff393838),
          ),
        ),
      ],
    );
  }

  postFindPw() async{
    ApiUrl apiUrl = ApiUrl();
    http.Response res = await api(apiUrl.email, 'post', '', {
      'email': widget.email, 'phoneNumber': widget.phoneNumber
    }, context);
    if(res.statusCode == 200){
      var rb = utf8.decode(res.bodyBytes);
      var data = jsonDecode(rb);
      await autoLoginStorage.write(
          key: "PWToken", value: data['token']);
    }
  }
  @override
  void dispose() {
    timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        timeout = true;
        if (time == 300) {
          timeout = false;
          timer.cancel();
        } else if (time < 300) {
          time++;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        width: 700.w,
        height: 720.w,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 140.w,
              ),
              Container(
                width: 456.w,
                child: Text(
                  '비밀번호 재설정을 위한 임시코드가 담긴 이메일이 발송되었습니다.',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 26.w,
                    color: Color(0xff393838),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 9.w,
              ),
              Text(
                '이메일을 확인하시고 임시코드를 입력해주세요.',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20.w,
                  color: Color(0xff393838),
                ),
              ),
              SizedBox(
                height: 95.w,
              ),
              Container(
                width: 55.w,
                child: Center(
                  child: Row(
                    children: [
                      timeText(),
                      // Text(
                      //   '05',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.w400,
                      //     fontSize: 20.w,
                      //     color: Color(0xff393838),
                      //   ),
                      // ),
                      // Text(
                      //   ':00',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.w400,
                      //     fontSize: 20.w,
                      //     color: Color(0xff393838),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40.w,
              ),
              SizedBox(
                width: 350.w,
                child: CustomFindPWField('코드입력', (val) {
                  setState(() {
                    widget.setAuthenticationNumber(val);
                  });
                }, (val) {
                  if (val.length < 1) {
                    return '임시코드는 필수 사항입니다.';
                  } else if (val.length != 6) {
                    return '6자리 코드를 입력해주세요.';
                  }
                  return null;
                }),
              ),
              SizedBox(
                height: 75.w,
              ),
              Container(
                width: 330.w,
                child: Row(
                  children: [
                    Text(
                      '임시코드가 발송되지 않았다면?',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.w,
                        color: Color(0xff393838),
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        postFindPw();
                      },
                      child: Text(
                        '임시코드 다시받기',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.w,
                          color: Color(0xff393838),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
