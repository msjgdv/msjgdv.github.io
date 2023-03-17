import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/a_main/a2_1.dart';
import 'package:treasure_map/a_main/a3_1.dart';
import 'package:treasure_map/a_main/a4_1.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:treasure_map/widgets/api.dart';

import '../provider/admin_info.dart';
import '../provider/app_management.dart';
import '../widgets/login_route.dart';
import '../widgets/set_admin_info.dart';
import 'package:provider/provider.dart';

import '../widgets/token_decode.dart';


class A1 extends StatefulWidget {
  const A1({
    Key? key,
    this.overToken = false,
    this.identification = 0,
    this.value = 0,
  }) : super(key: key);
  final bool overToken;
  final int identification;
  final dynamic value;

  @override
  State<A1> createState() => _A1State();
}

class _A1State extends State<A1> {

  @override
  Widget build(BuildContext context) {
    precacheImage(Image.asset('assets/backgrounds/main_page.png').image, context);
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset('assets/backgrounds/main_page.png').image,
          )),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body:ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const RangeMaintainingScrollPhysics(),
                children: [
                  Row(
                    children: [
                      Container(
                        width: 495.w,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: 121.w),
                              width: 250.w,
                              height: 96.w,
                              child: SvgPicture.asset('assets/logo/full_orange.svg',)                              // color: Colors.white,
                            ),
                            SizedBox(
                              height: 90.w,
                            ),
                            LoginPageForm(
                              overToken: widget.overToken,
                              identification: widget.identification,
                              value: widget.value,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 495.w,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomLoginField extends StatelessWidget {
  final String text;
  final FormFieldSetter _onSaved;
  final FormFieldValidator _validator;

  const CustomLoginField(this.text, this._onSaved, this._validator);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 250.w,
          child: TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp('[\\ ]')),
            ],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSaved: _onSaved,
            validator: _validator,
            onChanged: _onSaved,
            style: TextStyle(
              fontSize: 20.w,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
            obscureText: text == "비밀번호" ? true : false,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                fontSize: 20.w,
                fontWeight: FontWeight.w400,
                color: Color(0xffB2B2B2),
              ),
              hintText: "$text",
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0.w, horizontal: 16.w),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.w),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.w),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.w),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.w),
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

class LoginPageForm extends StatefulWidget {
  const LoginPageForm({
    Key? key,
    required this.overToken,
    required this.identification,
    required this.value,
  }) : super(key: key);
  final bool overToken;
  final int identification;
  final dynamic value;

  @override
  State<LoginPageForm> createState() => _LoginPageFormState();
}

class _LoginPageFormState extends State<LoginPageForm> {
  final formKey = GlobalKey<FormState>();
  String ID = '';
  String PW = '';
  String loginError = '';
  bool AutoLogin = false;
  static final autoLoginStorage = FlutterSecureStorage();
  ApiUrl apiUrl = ApiUrl();


  _getStatus() async{
    http.Response res = await api(apiUrl.status, 'get', 'signInToken', {}, context);
    if(res.statusCode == 200){
      var rb = utf8.decode(res.bodyBytes);
      var data = jsonDecode(rb);
      Provider.of<UserInfo>(context, listen: false).role = data['type'];
      Provider.of<UserInfo>(context, listen: false).service = data['status'];

      if(!widget.overToken){
        Provider.of<UserInfo>(context, listen: false).value.clear();
        for(int i = 0; i<data['value'].length;i++){
          Provider.of<UserInfo>(context, listen: false).value.add(data['value'][i]);
        }
      }else{
        Provider.of<UserInfo>(context, listen: false).value =  widget.value;
      }
    }
  }

  login() async{
    if (this.formKey.currentState!.validate()) {
      http.Response res = await api(apiUrl.loginIn, 'post', '', {
        'email': ID, 'password': PW
      }, context);

      if(res.statusCode == 200){
        if (AutoLogin == true) {
          await autoLoginStorage.write(key: "id", value: this.ID);
          await autoLoginStorage.write(
              key: "password", value: this.PW);
        } else if (AutoLogin == false) {
          await autoLoginStorage.delete(key: 'id');
          await autoLoginStorage.delete(key: 'password');
        }

        var resRB = utf8.decode(res.bodyBytes);
        var resData = jsonDecode(resRB);

        await autoLoginStorage.write(key: "signInToken", value: resData['token']);
        await autoLoginStorage.write(key: "cookie", value: res.headers['set-cookie']!);

        setAdminInfo(apiUrl.baseUrl,
            context.read<AdminInfo>().infoUpdate, context);
        await _getStatus();
        if (widget.overToken == true) {
          if (widget.identification ==
              tokenDecode(resData['token'], "identification")) {
            Navigator.pop(context);
          } else {
            loginRoute(context, Provider.of<UserInfo>(context, listen: false).role);
          }
        } else {
          loginRoute(context, Provider.of<UserInfo>(context, listen: false).role);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(
            height: 80.w,
            child: CustomLoginField(
              '아이디',
              (val) {
                setState(() {
                  ID = val;
                  loginError = "";
                });
              },
              (val) {
                if (val.length < 1) {
                  return '이메일은 필수사항입니다.';
                }
                // if (val.length < 2) {
                //   return '이메일은 5자 이상 입력 해주셔야합니다.';
                // }
                return null;
              },
            ),
          ),

          SizedBox(
            height: 80.w,
            child: CustomLoginField(
              "비밀번호",
              (val) {
                setState(() {
                  PW = val;
                  loginError = "";
                });
              },
              (val) {
                if (val.length < 1) {
                  return '비밀번호는 필수사항입니다.';
                }
                if (loginError == '401') {
                  return '이메일 혹은 비밀번호가 틀렸습니다.';
                }
                if (loginError == '412') {
                  return '이메일 형식이 잘못되었습니다.';
                }
                if (loginError == '500') {
                  return '서버에러';
                }
                return null;
              },
            ),
          ),

          SizedBox(
            width: 250.w,
            child: Row(
              children: [
                Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.w)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff000000).withOpacity(0.16),
                          offset: Offset(2, 2),
                          blurRadius: 6,
                        )
                      ],
                      color: Colors.white),
                  child: Transform.scale(
                    scale: 1.5.w,
                    child: Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.w)),
                        activeColor: Color(0xff555555),
                        checkColor: Color(0xffFDB43B),
                        fillColor: MaterialStateProperty.all(Color(0xffffffff)),
                        value: AutoLogin,
                        onChanged: (val) {
                          setState(() {
                            AutoLogin = val!;
                          });
                        }),
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                Text(
                  '자동로그인',
                  style: TextStyle(
                      color: Color(0xff393838),
                      fontSize: 20.w,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
          SizedBox(height: 70.w),
          Container(
            width: 250.w,
            height: 40.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffA666FB)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.w),
                    ))),
                onPressed: () {
                  login();
                },
                child: Text(
                  '로그인',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.w,
                      fontWeight: FontWeight.w700),
                )),
          ),
          SizedBox(
            width: 250.w,
            height: 40.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => A3_1()),
                    );
                  },
                  child: Text(
                    '아이디 찾기',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.w,
                      color: const Color(0xff393838),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => A4_1()),
                    );
                  },
                  child: Text(
                    '비밀번호 찾기',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.w,
                      color: const Color(0xff393838),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 230.w,
            height: 40.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '아직회원이 아니신가요?',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.w,
                    color: const Color(0xff393838),
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => A2_1()),
                    );
                  },
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.w,
                      color: const Color(0xff393838),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
