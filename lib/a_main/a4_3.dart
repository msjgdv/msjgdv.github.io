import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/a_main/a4_2.dart';
import 'package:treasure_map/a_main/a4_4.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:http/http.dart' as http;


class A4_3 extends StatefulWidget {
  const A4_3({Key? key,
    this.email = '',
    this.phoneNumber = '',
  }) : super(key: key);
  final String email;
  final String phoneNumber;

  @override
  State<A4_3> createState() => _A4_3State();
}

class _A4_3State extends State<A4_3> {
  final formKey = GlobalKey<FormState>();
  static final autoLoginStorage = FlutterSecureStorage();

  String confirmPW = '';

  setPW(String pw){
    return confirmPW = pw;
  }
  ApiUrl apiUrl = ApiUrl();
  
  reNewPw() async{
    http.Response res = await api(apiUrl.reset, 'post', 'RePWToken', {
      'password': confirmPW
    }, context);
    if(res.statusCode == 200){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => A4_4()),
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
                          height: 42.w,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 63.w,
                            ),
                            SvgPicture.asset(
                              'assets/icons/icon_find_pw.svg',
                              height: 32.w,
                              width: 32.w,
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
                                  MaterialPageRoute(builder: (context) => A4_2(
                                    email: widget.email,
                                    phoneNumber: widget.phoneNumber,
                                  )),
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
                  ResetPwPageForm(formKey: formKey, setPW: setPW),
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
                                reNewPw();
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



class CustomResetPWField extends StatelessWidget {
  final String _text;
  final FormFieldSetter _onSaved;
  final FormFieldValidator _validator;

  const CustomResetPWField(this._text, this._onSaved, this._validator);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: _onSaved,
      validator: _validator,
      onChanged: _onSaved,
      obscureText: true,
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

class ResetPwPageForm extends StatefulWidget {
  const ResetPwPageForm({
    Key? key,
    required this.formKey,
    required this.setPW,
  }) : super(key: key);
  final GlobalKey<FormState> formKey;
  final Function setPW;

  @override
  State<ResetPwPageForm> createState() => _ResetPwPageFormState();
}

class _ResetPwPageFormState extends State<ResetPwPageForm> {
  String PW = '';
  String confirmPW = '';

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
                height: 170.w,
              ),
              Text(
                '새로운 비밀번호를 입력해주세요.',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20.w,
                  color: Color(0xff393838),
                ),
              ),
              SizedBox(
                height: 100.w,
              ),
              SizedBox(
                width: 360.w,
                child: CustomResetPWField('비밀번호', (val) {
                  setState(() {
                    this.PW = val;
                  });
                }, (val) {
                  if (val.length < 1) {
                    return '비밀번호는 필수 사항입니다.';
                  } else if (val.length < 8) {
                    return '비밀번호는 8자 이상 입력해주세요.';
                  } else if (!RegExp(
                      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,16}$')
                      .hasMatch(val)) {
                    return '특수문자를 포함하여 주세요.';
                  }
                  return null;
                }),
              ),
              SizedBox(
                height: 45.w,
              ),
              SizedBox(
                width: 360.w,
                child: CustomResetPWField('비밀번호 확인', (val) {
                  setState(() {
                    this.confirmPW = val;
                    widget.setPW(val);
                  });
                }, (val) {
                  if (val.length < 1) {
                    return '비밀번호 확인은 필수 사항입니다.';
                  } else if (this.PW != val) {
                    return '비밀번호와 일치하지 않습니다.';
                  }
                  return null;
                }),
              ),
              SizedBox(
                height: 55.w,
              ),
              Text(
                '8 - 16자의 영문 대소문자, 숫자, 특수문자가 포함되어야 합니다.',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.w,
                  color: Color(0xff393838),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
