import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/a_main/a1.dart';
import 'package:treasure_map/a_main/a3_1.dart';
import 'package:treasure_map/a_main/a4_2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:http/http.dart' as http;


class A4_1 extends StatefulWidget {
  const A4_1({Key? key}) : super(key: key);

  @override
  State<A4_1> createState() => _A4_1State();
}

class _A4_1State extends State<A4_1> {
  final formKey = GlobalKey<FormState>();
  String ID = '';
  String sellPhoneNumber = '';
  static final autoLoginStorage = FlutterSecureStorage();

  setSellPhoneNumber(String phoneNumber){
    return sellPhoneNumber = phoneNumber;
  }

  setID(String Id){
    return ID = Id;
  }

  postFindPw() async{
    ApiUrl apiUrl = ApiUrl();
    http.Response res = await api(apiUrl.email, 'post', '', {
      'email': ID, 'phoneNumber': sellPhoneNumber
    }, context);
    if(res.statusCode == 200){
      var rb = utf8.decode(res.bodyBytes);
      var data = jsonDecode(rb);
      await autoLoginStorage.write(
          key: "PWToken", value: data['token']);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => A4_2(
              email: ID,
              phoneNumber: sellPhoneNumber,
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
                                  MaterialPageRoute(builder: (context) => A1()),
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
                  FindPwPageForm(formKey: formKey, ID: setID, sellPhoneNumber: setSellPhoneNumber,),
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
                                postFindPw();
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

class FindPwPageForm extends StatefulWidget {
  const FindPwPageForm({
    Key? key,
    required this.formKey,
    required this.sellPhoneNumber,
    required this.ID,
  }) : super(key: key);
  final GlobalKey<FormState> formKey;
  final Function ID;
  final Function sellPhoneNumber;
  @override
  State<FindPwPageForm> createState() => _FindPwPageFormState();
}

class _FindPwPageFormState extends State<FindPwPageForm> {
  final formKey = GlobalKey<FormState>();


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
                  height: 100.w,
                ),
                Text(
                  '비밀번호가 기억나지 않으시나요?',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 26.w,
                    color: Color(0xff393838),
                  ),
                ),
                SizedBox(
                  height: 46.w,
                ),
                Container(
                  width: 288.w,
                  child: Text(
                    'Tresure map의 아이디와 가입 시 등록한 연락처를 입력해주세요.',
                    style: TextStyle(
                      fontSize: 20.w,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff393838),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 85.w,
                ),
                SizedBox(
                  width: 350,
                  child: CustomFindPWField('아이디', (val) {
                    setState(() {
                      widget.ID(val);
                    });
                  }, (val) {
                    if (val.length < 1) {
                      return '아이디는 필수사항입니다.';
                    }
                    return null;
                  }),
                ),
                SizedBox(
                  height: 20.w,
                ),
                SizedBox(
                  width: 350,
                  child: CustomFindPWField('휴대전화번호', (val) {
                    setState(() {
                      widget.sellPhoneNumber(val);
                    });
                  }, (val) {
                    if (val.length < 1) {
                      return '휴대전화번호는 필수사항입니다.';
                    }
                    return null;
                  }),
                ),
                SizedBox(
                  height: 55.w,
                ),
                Container(
                  width: 350.w,
                  child: Text('아이디가 기억나지 않으시나요?',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.w,
                        color: Color(0xff393838),
                      )),
                ),
                SizedBox(
                  height: 12.w,
                ),
                SizedBox(
                    width: 350.w,
                    height: 50.w,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.w)),
                        primary: Color(0xffA666FB),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => A3_1()),
                        );
                      },
                      child: Text('아이디 찾기',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20.w,
                            color: Color(0xffffffff),
                          )),
                    ))
              ],
            ),
          )),
    );
  }
}
