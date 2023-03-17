import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/provider/admin_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:http/http.dart' as http;

//문의하기
class B9 extends StatefulWidget {
  const B9({
    Key? key,
    required this.notifyParent,
    required this.textFieldFocusNode,
    required this.textFieldFocusNode2,
  }) : super(key: key);
  final Function(double, double)? notifyParent;
  final FocusNode textFieldFocusNode;
  final FocusNode textFieldFocusNode2;

  @override
  State<B9> createState() => _B9State();
}

class _B9State extends State<B9> {
  final myControllerTitleAsk = TextEditingController();
  final myControllerTextAsk = TextEditingController();
  
  postContact() async {
    ApiUrl apiUrl = ApiUrl();
    http.Response res = await api(apiUrl.contact, 'post', 'adminToken', {
      "subject": myControllerTitleAsk.text,
      "content": myControllerTextAsk.text,
    }, context);
    if(res.statusCode == 200){
      setState(() {
        myControllerTitleAsk.clear();
        myControllerTextAsk.clear();
      });

    }
  }
  
  
  @override
  Widget build(BuildContext contextB9) {
    return Container(
      child: Row(
        children: [
          SizedBox(width: 80.w),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Contact Us',
                style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF393838))),
            SizedBox(height: 46.w),
            Container(
              margin: EdgeInsets.only(left: 264.w),
              child: Text(
                  '불편하신 사항이나 문의사항이 생길 경우 메세지를 보내십시오.\n     현재 로그인 계정 이메일로 최대한 빨리 회신드리겠습니다.',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF393838))),
            ),
            SizedBox(height: 86.w),
            SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 69.w),
                          child: Text('로그인 계정',
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF393838)))),
                      Container(
                          margin: EdgeInsets.only(top: 31.w),
                          child: Text('제목',
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF393838)))),
                      Container(
                          margin: EdgeInsets.only(top: 23.w),
                          child: Text('내용',
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF393838))))
                    ],
                  ),
                  SizedBox(width: 26.w),
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        //로그인 계정
                        width: 640.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.w)),
                            border: Border.all(
                                color: const Color(0xFFFDB43B), width: 1.w)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              Provider.of<AdminInfo>(context, listen: false)
                                  .email,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.w,
                                color: Color(0xff393838),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        //제목
                        margin: const EdgeInsets.only(top: 20),
                        width: 640.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.w)),
                            border: Border.all(
                                color: const Color(0xFFFDB43B), width: 1.w)),
                        child: TextField(
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18.w,
                            color: Color(0xff393838),
                          ),
                          focusNode: widget.textFieldFocusNode,
                          onTap: () {},
                          maxLength: 70,
                          controller: myControllerTitleAsk,
                          decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.w)),
                                  borderSide:
                                      BorderSide(color: Colors.transparent))),
                        ),
                      ),
                      Container(
                        //내용
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.w)),
                            border: Border.all(
                                color: const Color(0xFFFDB43B), width: 1.w)),
                        width: 640.w,
                        height: 230.w,
                        child: TextField(
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18.w,
                            color: Color(0xff393838),
                          ),
                          focusNode: widget.textFieldFocusNode2,
                          onTap: () {},
                          maxLines: 8,
                          controller: myControllerTextAsk,
                          decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.w)),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ))),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 679.w, top: 24.w),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfigDialog(
                          postContact: postContact,
                        );
                      });
                },
                child: Text('글쓰기',
                    style: TextStyle(
                        fontSize: 20.sp, fontWeight: FontWeight.w400)),
                style: ElevatedButton.styleFrom(
                    elevation: 1.0,
                    primary: const Color(0xFFA666FB),
                    onPrimary: const Color(0xFFFFFFFF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.w)),
                    fixedSize: Size(150.w, 50.w)),
              ),
            )
          ])
        ],
      ),
    );
  }
}

class ConfigDialog extends StatefulWidget {
  const ConfigDialog({
    Key? key,

    required this.postContact,

  }) : super(key: key);
  final Function() postContact;

  @override
  State<ConfigDialog> createState() => _ConfigDialogState();
}

class _ConfigDialogState extends State<ConfigDialog> {
  

  
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
            child: Container(
                width: 600.w,
                height: 350.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.w),
                    color: const Color(0xFFFCF9F4)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '해당 내용으로 문의하시겠습니까?',
                      style: TextStyle(
                          color: Color(0xff393838),
                          fontWeight: FontWeight.w400,
                          fontSize: 24.w),
                    ),
                    SizedBox(height: 100.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(width: 80.w),
                        ElevatedButton(
                          onPressed: () async {
                            await widget.postContact();
                            Navigator.pop(context);
                          },
                          child: Text('확인',
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w400)),
                          style: ElevatedButton.styleFrom(
                              elevation: 1.0,
                              primary: const Color(0xFFFFFFFF),
                              onPrimary: const Color(0xFF393838),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.w)),
                              side: const BorderSide(color: Color(0xFFA666FB)),
                              fixedSize: Size(150.w, 50.w)),
                        ),
                        SizedBox(width: 50.w),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
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
                              side: const BorderSide(color: Color(0xFFA666FB)),
                              fixedSize: Size(150.w, 50.w)),
                        ),
                      ],
                    ),
                    SizedBox(height: 50.w),
                  ],
                ))));
  }
}
