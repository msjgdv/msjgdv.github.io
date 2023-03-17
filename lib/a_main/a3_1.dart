import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/a_main/a1.dart';
import 'package:treasure_map/a_main/a3_2.dart';
import 'package:treasure_map/a_main/a3_3.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:http/http.dart' as http;


class A3_1 extends StatefulWidget {
  const A3_1({Key? key}) : super(key: key);

  @override
  State<A3_1> createState() => _A3_1State();
}

class _A3_1State extends State<A3_1> {


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
                          height: 42,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 63,
                            ),
                            SvgPicture.asset(
                              'assets/icons/icon_find_id.svg',
                              height: 32,
                              width: 32,
                            ),
                            SizedBox(
                              width: 17.w,
                            ),
                            Text(
                              '아이디 찾기',
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
                  FindIdPageForm(),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFindIdField extends StatelessWidget {
  final String _text;
  final FormFieldSetter _onSaved;
  final FormFieldValidator _validator;

  const CustomFindIdField(this._text, this._onSaved, this._validator);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: _onSaved,
      validator: _validator,
      onChanged: _onSaved,
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


class FindIdPageForm extends StatefulWidget {
  const FindIdPageForm({Key? key}) : super(key: key);

  @override
  State<FindIdPageForm> createState() => _FindIdPageFormState();
}

class _FindIdPageFormState extends State<FindIdPageForm> {
  String name = '';
  String sellPhoneNumber = '';
  String findIdError = '';
  final formKey = GlobalKey<FormState>();

  findId() async{
    ApiUrl apiUrl = ApiUrl();
    http.Response res = await api(apiUrl.findId, 'post', '', {
      'name': name, 'phoneNumber': sellPhoneNumber
    }, context);
    if(res.statusCode == 200){
      var rb = utf8.decode(res.bodyBytes);
      var data = jsonDecode(rb);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            A3_3(userIds: data,)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this.formKey,
      child: Row(
        children: [
          Container(
              width: 700.w,
              height: 720.w,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 175.w,
                    ),
                    Text(
                      '아이디가 기억나지 않으시나요?',
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
                      width: 258.w,
                      child: Text(
                        '가입 시 등록한 회원정보를 통해 아이디 찾기를 진행해 주세요.',
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
                      width: 340,
                      child: CustomFindIdField(
                          '이름',
                              (val){
                            setState(() {
                              this.name = val;
                            });
                          },
                              (val){
                            if (val.length <1){
                              return '이름은 필수사항입니다.';
                            }
                            return null;
                          }
                      ),

                    ),
                    SizedBox(
                      height: 20.w,
                    ),
                    SizedBox(
                      width: 340,
                      child: CustomFindIdField(
                          '휴대전화번호',
                              (val){
                            setState(() {
                              this.sellPhoneNumber = val;
                            });
                          },
                              (val){
                            if (val.length <1){
                              return '휴대전화번호는 필수사항입니다.';
                            }
                            return null;
                          }
                      ),

                    ),

                  ],
                ),
              )
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
                        findId();
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
    );
  }
}
