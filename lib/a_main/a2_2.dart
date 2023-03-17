import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/a_main/a2_1.dart';
import 'package:treasure_map/a_main/a2_3.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class A2_2 extends StatefulWidget {
  const A2_2({Key? key}) : super(key: key);

  @override
  State<A2_2> createState() => _A2_2State();
}

class _A2_2State extends State<A2_2> {
  // final formKey = GlobalKey<FormState>();
  SignupPageForm signPage = SignupPageForm();
  static final autoLoginStorage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCF9F4),
      body: GestureDetector(
        onTap: (){
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
                          height: 40.w - MediaQuery.of(context).padding.top,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 63.w,
                            ),
                            SvgPicture.asset(
                              'assets/icons/icon_signup.svg',
                              height: 32.w,
                              width: 32.w,
                            ),
                            SizedBox(
                              width: 17.w,
                            ),
                            Text(
                              '회원가입',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 26.sp,
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
                              onPressed: () async {
                                await autoLoginStorage.delete(key: "signUpToken");
                                await autoLoginStorage.delete(key: "emailToken");


                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => A2_1()),
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
                                      fontSize: 26.sp,
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
                  SignupPageForm(
                    // key: formKey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSignupField extends StatelessWidget {
  final String _text;
  final FormFieldSetter _onSaved;
  final FormFieldValidator _validator;

  const CustomSignupField(this._text, this._onSaved, this._validator);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },

      maxLength: _text == '연락처' ? 11 : 50,
      onSaved: _onSaved,
      validator: _validator,
      onChanged: _onSaved,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: _text == '연락처' ? TextInputType.number : TextInputType.text,
      inputFormatters: [
        _text == '연락처'
            ? FilteringTextInputFormatter.digitsOnly
            : FilteringTextInputFormatter.deny(RegExp(""))
      ],
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black87,
      ),
      obscureText: _text == "비밀번호"
          ? true
          : false || _text == '비밀번호 확인'
          ? true
          : false,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w400,
          color: Color(0xff838383),
        ),
        hintText: "$_text",
        contentPadding: EdgeInsets.symmetric(
          vertical: 0.w,
          horizontal: 5.w,
        ),
        counterText: '',
      ),
    );
  }
}

class SignupPageForm extends StatefulWidget {
  const SignupPageForm({Key? key}) : super(key: key);

  @override
  State<SignupPageForm> createState() => _SignupPageFormState();
}

class _SignupPageFormState extends State<SignupPageForm> {
  String ID = '';
  String PW = '';
  String authenticationNumber = '';
  String sellPhoneNumber = '';
  String name = '';
  String confirmPW = '';
  String emailError = '';
  String authenticationNumberError = '';
  String signUpError = '';
  static final autoLoginStorage = FlutterSecureStorage();
  bool certificationTime = false;
  bool timeout = false;
  bool obtainCertification = false;
  final formKey = GlobalKey<FormState>();
  late Timer timer;
  var time = 0;

  ApiUrl apiUrl = ApiUrl();

  postCertifyEmail() async{
    http.Response res = await api(apiUrl.email, 'post', '', {
      'email': ID
    }, context);

    if(res.statusCode == 200){
      var rb = utf8.decode(res.bodyBytes);
      var data = jsonDecode(rb);
      await autoLoginStorage.write(
          key: "emailToken", value: data['token']);
      if(certificationTime == false){
        start();
      }else{
        reset();
      }
    }
  }

  getCertifyEmail() async{
    http.Response res = await api('${apiUrl.email}?code=$authenticationNumber' , 'get', '', {}, context);
    if(res.statusCode == 200){
      var rb = utf8.decode(res.bodyBytes);
      var data = jsonDecode(rb);
      await autoLoginStorage.write(
          key: "signUpToken",
          value: data['token']);
      obtainCertification = true;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Form(
          key: widget.key,
          child: Container(
            width: 700.w,
            height: 710.w,
            child: Column(
              children: [
                SizedBox(
                  height: 140.w - MediaQuery.of(context).padding.top,
                ),
                Container(

                  child: Text(

                    'ID로 사용할 이메일을 입력하세요',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff7744BA),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 40.w,
                ),
                Row(
                  children: [
                    Container(
                        width: 340.w,
                        child: CustomSignupField(
                          '이메일(ID)',
                              (val) {
                            setState(() {
                              this.ID = val;
                              this.emailError = '';
                            });
                          },
                              (val) {
                            if (val.length < 1) {
                              return '이메일은 필수사항입니다.';
                            }
                            if (!RegExp(
                                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(val)) {
                              return '이메일 형식이 아닙니다.';
                            }
                            if (this.emailError == '403') {
                              return '해당 아이디가 이미 존재합니다.';
                            }
                            if (this.emailError == '412') {
                              return '이메일형식이 잘못되었습니다.';
                            }
                            if (this.emailError == '500') {
                              return '서버 오류';
                            }
                            return null;
                          },
                        )),
                    SizedBox(
                      width: 80.w,
                    ),
                    SizedBox(
                      width: 280.w,
                      height: 50.w,
                      child:obtainCertification != true ?
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.w)),
                          primary: Color(0xffA666FB),
                        ),
                        child: certificationTime == false ?
                        Text(
                          '인증번호 받기',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20.sp,
                              color: Colors.white),
                        ):Text(
                          '인증번호 재전송',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20.sp,
                              color: Colors.white),
                        ),
                        onPressed: () async {
                          postCertifyEmail();
                        },
                      ):
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.w)),
                          primary: Color(0xff888888),
                        ),
                        child:
                        Text(
                          '인증 완료',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20.sp,
                              color: Colors.white),
                        ),
                        onPressed: (){
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30.w,
                ),
                Container(
                  width: 700.w,
                  child: Row(
                    children: [
                      Container(
                        width: 158.w,
                        child: CustomSignupField(
                          '인증번호 6자리',
                              (val) {
                            setState(() {
                              this.authenticationNumber = val;
                              this.authenticationNumberError = '';
                            });
                          },
                              (val) {
                            if (this.authenticationNumberError == '401') {
                              return '유효하지 않은 토큰입니다.';
                            }
                            if (this.authenticationNumberError == '412') {
                              return '코드가 맞지 않습니다.';
                            }
                            if (this.authenticationNumberError == '419') {
                              return '시간이 초과되었습니다.';
                            }
                            if (this.authenticationNumberError == '500') {
                              return '서버문제';
                            }
                            return null;
                          },
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 522.w,
                        child: Row(
                          children: [
                            timeText(),
                            Spacer(),
                            SizedBox(
                              width: 280.w,
                              height: 50.w,
                              child: obtainCertification == false ?
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                      new BorderRadius.circular(10.w)),
                                  side: BorderSide(
                                      width: 1, color: Color(0xffA666FB)),
                                  primary: Color(0xffA666FB),
                                ),
                                onPressed: () async {
                                  getCertifyEmail();
                                },
                                child: Text(
                                  '확인',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20.sp,
                                    color: Color(0xff393838),
                                  ),
                                ),
                              ):
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                      new BorderRadius.circular(10.w)),
                                  side: BorderSide(
                                      width: 1, color: Color(0xff888888)),
                                  primary: Color(0xffA666FB),
                                ),
                                onPressed: () {},
                                child: Text(
                                  '확인',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20.sp,
                                    color: Color(0xff888888),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.w,
                ),
                Container(
                  width: 700.w,
                  child: Row(
                    children: [
                      Container(
                        width: 340.w,
                        child: CustomSignupField(
                          '연락처',
                              (val) {
                            setState(() {
                              this.sellPhoneNumber = val;
                            });
                          },
                              (val) {
                            if (val.length < 1) {
                              return '연락처를 입력하여 주세요.';
                            }
                            if (val.length != 11) {
                              return "'-'를 제외하여 입력해주세요.";
                            }
                            return null;
                          },
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 280.w,
                        child: CustomSignupField(
                          '이름',
                              (val) {
                            setState(() {
                              this.name = val;
                            });
                          },
                              (val) {
                            if (val.length < 1) {
                              return '이름을 입력하여 주세요.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.w,
                ),
                Container(
                  width: 700.w,
                  child: CustomSignupField(
                    '비밀번호',
                        (val) {
                      setState(() {
                        this.PW = val;
                      });
                    },
                        (val) {
                      if (val.length < 1) {
                        return '비밀번호를 입력하여 주세요.';
                      } else if (val.length < 8) {
                        return '8자 이상 입력해주세요!';
                      } else if (!RegExp(
                          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,16}$')
                          .hasMatch(val)) {
                        return '특수문자를 포함하여 주세요.';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 30.w,
                ),
                Container(
                  width: 700.w,
                  child: CustomSignupField(
                    '비밀번호 확인',
                        (val) {
                      setState(() {
                        this.confirmPW = val;
                      });
                    },
                        (val) {
                      if (val.length < 1) {
                        return '비밀번호를 입력하여 주세요.';
                      }
                      if (val != this.PW) {
                        return '비밀번호와 일치하지 않습니다.';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 270.w,
          child: Column(
            children: [
              SizedBox(
                height: 616.w - MediaQuery.of(context).padding.top,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 110.w,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    onPressed: () {
                      if (this.formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => A2_3()),
                        );
                      }
                      //   if (_isAllCheck == true) {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => A2_2()),
                      //   );
                      // }
                    },
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            postSignUp();
                          },
                          child: Text(
                            '다음',
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff393838),
                            ),
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
    );
  }

  Widget timeText() {
    var minute = (5 - (time / 60)).toInt();
    var second = '${60 - (time % 60)}'.padLeft(2, '0');

    return obtainCertification == false
        ? Row(
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
    )
        : Text('인증되었습니다.',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: Color(0xff393838),
        ));
  }
  @override
  void dispose() {
    timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void start() {
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        timeout = true;
        if (time == 300) {
          timeout = false;
          timer.cancel();
        } else if (time < 300) {
          time++;
        }
        certificationTime = true;
      });
    });
  }

  void reset() {
    setState(() {
      timer.cancel();
      time = 0;
      start();
    });
  }

  Future<void> postSignUp() async {
    http.Response res = await api(apiUrl.localNew, 'post', 'signUpToken', {
      'password': PW, 'name': name, 'phoneNumber': sellPhoneNumber
    }, context);
    if (res.statusCode == 200) {
      await autoLoginStorage.delete(key: "signUpToken");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => A2_3()),
      );
    }
  }
}