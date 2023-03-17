// ignore_for_file: camel_case_types

import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../api/admin.dart';
import '../provider/admin_info.dart';
import '../provider/app_management.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'b1_4.dart';
import 'b2_2.dart';
import 'b2_6.dart';
import 'b2_7.dart';

class B2_1_Basic extends StatefulWidget {
  const B2_1_Basic({
    Key? key,
    required this.notifyParent,
    required this.directorPhoneNumber,
    required this.director,
    required this.address,
    required this.phoneNumber,
    required this.name,
  }) : super(key: key);
  final Function(double, double)? notifyParent;
  final String name;
  final String director;
  final String directorPhoneNumber;
  final String phoneNumber;
  final String address;

  @override
  State<B2_1_Basic> createState() => _B2_1_BasicState();
}

class _B2_1_BasicState extends State<B2_1_Basic> {
  GlobalKey globalkeyCK = GlobalKey();
  static const autoLoginStorage = FlutterSecureStorage();
  Map<String, String> headers = new Map();

  void initState() {
    getImg();
  }

  getImg() async {
    final token = await autoLoginStorage.read(key: "signInToken");
    headers['authorization'] = token!;
  }

  @override
  Widget build(BuildContext contextB2_1_basic) {
    return Row(children: [
      SizedBox(width: 47.w),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              //메인 프로필
              width: 893.w,
              height: 280.w,
              margin: EdgeInsets.only(top: 29.01.w),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.all(Radius.circular(20.w)),
                  border:
                      Border.all(color: const Color(0xFFFCCD7F), width: 1.w)),
              child: Row(
                //사진, 개인정보, 버튼
                children: [
                  Container(
                    //사진
                    color: const Color(0xFFFFFFFF),
                    width: 150.34.w,
                    height: 177.67.w,
                    margin: EdgeInsets.fromLTRB(54.w, 50.67.w, 0.w, 51.66.w),
                    child: contextB2_1_basic.read<AdminInfo>().adminFace,
                  ),
                  Container(
                    //개인정보
                    width: 375.5.w,
                    //color: Colors.red,
                    margin: EdgeInsets.fromLTRB(60.16.w, 67.w, 0.w, 0.w),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '아이디: ${contextB2_1_basic.watch<AdminInfo>().email}',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20.sp)),
                        Container(
                            margin: EdgeInsets.fromLTRB(0.w, 25.w, 0.w, 25.w),
                            child: Text(
                                '이름: ${contextB2_1_basic.watch<AdminInfo>().name}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.sp))),
                        Text(
                            '연락처: ${contextB2_1_basic.watch<AdminInfo>().phoneNumber}',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20.sp)),
                      ],
                    ),
                  ),
                  Container(
                    //버튼
                    //color: Colors.blueAccent,
                    width: 200.w,
                    // margin: EdgeInsets.fromLTRB(0.w, 103.w, 0.w, 0.w),
                    child: Column(
                      children: [
                        SizedBox(height: 40.w),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return B2_7();
                                });
                          },
                          child: Text('서명등록',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.sp)),
                          style: ElevatedButton.styleFrom(
                              elevation: 1.0,
                              primary: const Color(0xFFFFFFFF),
                              onPrimary: const Color(0xFF393838),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.w)),
                              side: const BorderSide(color: Color(0xFFA666FB)),
                              fixedSize: Size(200.w, 50.w)),
                        ),
                        SizedBox(height: 30.w),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return B2_2();
                                });
                            // showPopUpB2_2(contextB2_1_basic);
                          },
                          child: Text('내 정보 변경',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20.w)),
                          style: ElevatedButton.styleFrom(
                              elevation: 1.0,
                              primary: const Color(0xFFA666FB),
                              onPrimary: const Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.w)),
                              fixedSize: Size(200.w, 50.w)),
                        ),
                        SizedBox(height: 30.w),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(context: context, builder: (BuildContext context){
                              return SecuritySetting();
                            });
                          },
                          child: Text('개인/보안',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.sp)),
                          style: ElevatedButton.styleFrom(
                              elevation: 1.0,
                              primary: const Color(0xFFFFFFFF),
                              onPrimary: const Color(0xFF393838),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.w)),
                              side: const BorderSide(color: Color(0xFFA666FB)),
                              fixedSize: Size(200.w, 50.w)),
                        ),
                      ],
                    ),
                  )
                ],
              )),
          SizedBox(height: 62.w),
          Text('기관 정보',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22.w,
                  color: const Color(0xFF393838))),
          SizedBox(height: 20.w),
          Column(
            //우리유치원, 유치원정보
            children: [
              Container(
                width: 893.w,
                height: 40.w,
                decoration: BoxDecoration(
                    color: Color(0xFFFED796),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.w),
                        topLeft: Radius.circular(10.w))),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 178.w,
                      child: Center(
                        child: Text('기관명',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.w,
                                color: const Color(0xFF393838))),
                      ),
                    ),
                    Container(
                      width: 178.w,
                      child: Center(
                        child: Text('원장명',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.w,
                                color: const Color(0xFF393838))),
                      ),
                    ),
                    Container(
                      width: 178.w,
                      child: Center(
                        child: Text('원장연락처',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.w,
                                color: const Color(0xFF393838))),
                      ),
                    ),
                    Container(
                      width: 178.w,
                      child: Center(
                        child: Text('주소',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.w,
                                color: const Color(0xFF393838))),
                      ),
                    ),
                    Container(
                      width: 178.w,
                      child: Container(
                        child: Center(
                          child: Text('전화번호',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.w,
                                  color: const Color(0xFF393838))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 893.w,
                height: 40.w,
                decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10.w),
                        bottomLeft: Radius.circular(10.w)),
                    border:
                        Border.all(color: const Color(0xFFFDB43B), width: 1.w)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 178.w,
                      child: Center(
                        child: Text(widget.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.w,
                                color: const Color(0xFF393838))),
                      ),
                    ),
                    Container(
                      width: 178.w,
                      child: Center(
                        child: Text(widget.director,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.w,
                                color: const Color(0xFF393838))),
                      ),
                    ),
                    Container(
                      width: 178.w,
                      child: Center(
                        child: Text(widget.directorPhoneNumber,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.w,
                                color: const Color(0xFF393838))),
                      ),
                    ),
                    Container(
                      width: 178.w,
                      child: Center(
                        child: Text(widget.address,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.w,
                                color: const Color(0xFF393838))),
                      ),
                    ),
                    Container(
                      width: 178.w,
                      child: Center(
                        child: Text(widget.phoneNumber,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.w,
                                color: const Color(0xFF393838))),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 111.w),
          // ElevatedButton(
          //   onPressed: () {
          //     debugPrint('우리유치원 정보 수정');
          //   },
          //   child: Text('우리유치원 정보 수정',
          //       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.w)),
          //   style: ElevatedButton.styleFrom(
          //       elevation: 1.0,
          //       primary: const Color(0xFFA666FB),
          //       onPrimary: const Color(0xFFFFFFFF),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10)),
          //       fixedSize: Size(280.w, 50.w)),
          // ),
        ],
      ),
    ]);
  }
}

class SecuritySetting extends StatefulWidget {
  const SecuritySetting({Key? key,
    this.type = 'PW',
  }) : super(key: key);
  final String? type;

  @override
  State<SecuritySetting> createState() => _SecuritySettingState();
}

class _SecuritySettingState extends State<SecuritySetting> {
  List<bool> type = [
    false,
    false,
    false,
  ];

  String password = "";

  setPassword(String _password){
    setState(() {
      password = _password;
    });
  }


  securitySetting(int index) async{

    if(type[index] != true){
      if(index != 0){
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PasswordSetting(type: index, passwordSetting: setPassword, )),
        );
      }
      print("asdf");

      setState(() {
        for(int i = 0; i< 3;i++){
          type[i] = false;
        }
        type[index] = true;
      });

    }

  }

  @override
  void initState() {
    if(widget.type == 'PW'){
      type[0] = true;
    }else if(widget.type == 'simplePW'){
      type[1] = true;
    }else if(widget.type == "pattern"){
      type[2] = true;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
                child: Container(
                    width: 500.w,
                    height: 300.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.w),
                        color: const Color(0xFFFCF9F4)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30.w,
                          ),
                          Text("계정잠금",
                              style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF393838))),
                          SizedBox(
                            height: 30.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 25.w,
                              ),
                              SizedBox(
                                height: 100.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SelectCheckBox(onOff: type[0], index: 0,securitySetting:securitySetting),
                                    SelectCheckBox(onOff: type[1], index: 1,securitySetting:securitySetting),
                                    SelectCheckBox(onOff: type[2], index: 2,securitySetting:securitySetting),
                                  ],
                                ),
                              ),

                              SizedBox(width: 20.w,),
                              SizedBox(
                                height: 100.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('비밀번호',
                                        style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF393838))),
                                    Text('패턴',
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF393838))),
                                    Text('간편 비밀번호',
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF393838)))

                                  ],
                                ),
                              ),

                            ],
                          ),
                          SizedBox(
                            height: 25.w,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); //아무내용 없이 dialog 종료
                            },
                            child: Text('취소',
                                style: TextStyle(
                                    fontSize: 20.w, fontWeight: FontWeight.w400)),
                            style: ElevatedButton.styleFrom(
                                elevation: 1.0,
                                primary: const Color(0xFFFFFFFF),
                                onPrimary: const Color(0xFF393838),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.w)),
                                side: const BorderSide(color: Color(0xFFA666FB)),
                                fixedSize: Size(150.w, 50.w)),
                          ),

                        ]
                    )
                )
            )
        )
    );
  }
}

class SelectCheckBox extends StatefulWidget {
  const SelectCheckBox({Key? key,
    required this.onOff,
    required this.index,
    required this.securitySetting,
  }) : super(key: key);
  final bool onOff;
  final int index;
  final Function(int) securitySetting;

  @override
  State<SelectCheckBox> createState() => _SelectCheckBoxState();
}

class _SelectCheckBoxState extends State<SelectCheckBox> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          widget.securitySetting(widget.index);
        });
      },
      child: SizedBox(
        // width: 30.w,
        height: 28.w,
        child: Center(
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:  widget.onOff  ? Color(0xFFA666FB): Colors.white,
              border: Border.all(width: 2.w, color:  widget.onOff  ? Color(0xFFA666FB):Color(0xFFFCCD7F)),

            ),
            child: Center(
              child:Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.onOff ? Color(0xFFA666FB): Colors.white,
                  // border: Border.all(width: 1.w, color: Color(0xFFFCCD7F)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
