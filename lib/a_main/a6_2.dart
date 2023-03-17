import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/a_main/a1.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/custom_container.dart';
import 'package:http/http.dart' as http;
import 'a6_5.dart';

class A6_2 extends StatefulWidget {
  const A6_2({Key? key}) : super(key: key);

  @override
  State<A6_2> createState() => _A6_2State();
}

class _A6_2State extends State<A6_2> {
  static const autoLoginStorage = FlutterSecureStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(Image.asset('assets/backgrounds/main_page.png').image, context);
    return WillPopScope(
        onWillPop: () async => false,
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset('assets/backgrounds/main_page.png').image,
            )),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: ListView(
            physics: const RangeMaintainingScrollPhysics(),
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        SizedBox(
                          height: 57.w,
                        ),
                        GestureDetector(
                          onTap: (){
                            autoLoginStorage.delete(key: "id");
                            autoLoginStorage.delete(key: "password");
                            autoLoginStorage.delete(key: "signInToken");
                            autoLoginStorage.delete(key: "adminToken");
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const A1()),
                                    (route) => false);
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 63.w,
                              ),
                              SvgPicture.asset(
                                'assets/icons/icon_back.svg',
                                height: 32.w,
                                width: 32.w,
                              ),
                              SizedBox(
                                width: 17.w,
                              ),
                              Text(
                                '나가기',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 26.sp,
                                  color: Color(0xff393838),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 91.w,
                          width: 250.w,
                        ),
                        SizedBox(
                          height: 100.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  width: 150.w,
                                  height: 150.w,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color(0xffffffff)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.w),
                                        ))),
                                    onPressed: () {
                                      showDialog(
                                          barrierColor: Colors.transparent,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return MakeKindergarten();
                                          });
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icons/icon_director.svg',
                                      height: 101.w,
                                      width: 117.w,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.w,
                                ),
                                Text(
                                  '원장선생님',
                                  style: TextStyle(
                                      color: Color(0xff46423C),
                                      fontSize: 20.w,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 200.w,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: 150.w,
                                  height: 150.w,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color(0xffffffff)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.w),
                                        ))),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => A6_5()),
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icons/icon_teacher.svg',
                                      height: 123.w,
                                      width: 80.w,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.w,
                                ),
                                Text(
                                  '담임선생님',
                                  style: TextStyle(
                                      color: Color(0xff46423C),
                                      fontSize: 20.w,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}

class MakeKindergarten extends StatefulWidget {
  const MakeKindergarten({Key? key}) : super(key: key);

  @override
  State<MakeKindergarten> createState() => _MakeKindergartenState();
}

class _MakeKindergartenState extends State<MakeKindergarten> {
  static final autoLoginStorage = FlutterSecureStorage();
  List<TextEditingController> _textEditingController = [];

  ApiUrl apiUrl = ApiUrl();
  @override
  void initState() {
    for (int i = 0; i < 3; i++) {
      _textEditingController.add(TextEditingController());
      _textEditingController[i] = TextEditingController();
    }

    // TODO: implement initState
    super.initState();
  }

  dataUpload() async{
    http.Response res = await api(apiUrl.kindergarten, 'post', 'signInToken', {
      'name': _textEditingController[0].text,
      'phoneNumber': _textEditingController[1].text,
      'address': _textEditingController[2].text
    }, context);
    return res.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.w))),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          width: 800.w,
          height: 450.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.w)),
            color: Color(0xffFCF9F4),
          ),
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
              physics: const RangeMaintainingScrollPhysics(),
              children: [
                SizedBox(
                  height: 103.w,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomContainer(
                            cTotalWidth: 221.w,
                            cTotalHeight: 50.w,
                            cBorderRadius:
                                BorderRadius.only(topLeft: Radius.circular(10.w)),
                            cBorderColor: Color(0xffFBB348),
                            cInsideColor: Color(0xffFED796),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            cBottomBorderWidth: 1.w,
                            childWidget: Center(
                              child: Text(
                                '영유아교육기관명',
                                style: TextStyle(
                                    color: Color(0xff393838),
                                    fontSize: 20.w,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          CustomContainer(
                            cTotalWidth: 305.w,
                            cTotalHeight: 50.w,
                            cBorderRadius:
                                BorderRadius.only(topRight: Radius.circular(10.w)),
                            cBorderColor: Color(0xfffdb43b),
                            cInsideColor: Color(0xffffffff),
                            cBottomBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            cTopBorderWidth: 1.w,
                            childWidget: TextField(
                              controller: _textEditingController[0],
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ), //외곽선
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomContainer(
                            cTotalWidth: 221.w,
                            cTotalHeight: 50.w,
                            cBorderColor: Color(0xffFBB348),
                            cInsideColor: Color(0xffFED796),
                            cLeftBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            cBottomBorderWidth: 1.w,
                            childWidget: Center(
                              child: Text(
                                '기관 전화번호',
                                style: TextStyle(
                                    color: Color(0xff393838),
                                    fontSize: 20.w,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          CustomContainer(
                            cTotalWidth: 305.w,
                            cTotalHeight: 50.w,
                            cBorderColor: Color(0xfffdb43b),
                            cInsideColor: Color(0xffffffff),
                            cRightBorderWidth: 1.w,
                            cBottomBorderWidth: 1.w,
                            childWidget: TextField(
                              controller: _textEditingController[1],
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              maxLength: 11,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ), //외곽선
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomContainer(
                            cTotalWidth: 221.w,
                            cTotalHeight: 50.w,
                            cBorderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.w)),
                            cBorderColor: Color(0xffFBB348),
                            cInsideColor: Color(0xffFED796),
                            cLeftBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            cBottomBorderWidth: 1.w,
                            childWidget: Center(
                              child: Text(
                                '주소',
                                style: TextStyle(
                                    color: Color(0xff393838),
                                    fontSize: 20.w,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          CustomContainer(
                            cTotalWidth: 305.w,
                            cTotalHeight: 50.w,
                            cBorderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10.w)),
                            cBorderColor: Color(0xfffdb43b),
                            cInsideColor: Color(0xffffffff),
                            cRightBorderWidth: 1.w,
                            cBottomBorderWidth: 1.w,
                            childWidget: TextField(
                              controller: _textEditingController[2],
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ), //외곽선
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 92.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.w, color: Color(0xffA666FB)),
                          borderRadius: BorderRadius.all(Radius.circular(10.w))),
                      width: 150.w,
                      height: 50.w,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xffffffff)),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w),
                            ))),
                        onPressed: () {
                          confirm(context, dataUpload);
                        },
                        child: Text(
                          '확인',
                          style: TextStyle(
                              color: Color(0xff393838),
                              fontSize: 20.w,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.w, color: Color(0xffA666FB)),
                          borderRadius: BorderRadius.all(Radius.circular(10.w))),
                      width: 150.w,
                      height: 50.w,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xffffffff)),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w),
                            ))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '뒤로',
                          style: TextStyle(
                              color: Color(0xff393838),
                              fontSize: 20.w,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

confirm(context, Function dataUpload) {
  return showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.w))),
          child: Container(
            width: 480.w,
            height: 250.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.w)),
              border: Border.all(width: 1.w, color: Color(0xff7649B7)),
              color: Color(0xffE2D3FE),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 45.w,
                ),
                Text(
                  '이후 진행시 원장선생님으로 역할이 고정 되며\n다른 역할로 바꿀수 없습니다.\n정말로 진행하시겠습니까?',
                  style: TextStyle(
                      color: Color(0xff393838),
                      fontSize: 18.w,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 39.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1.w, color: Color(0xffA666FB)),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.w))),
                      width: 150.w,
                      height: 50.w,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xffffffff)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w),
                            ))),
                        onPressed: () {
                          int statusCode = dataUpload();
                          if(statusCode == 200){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => A1()),
                            );
                          }

                          // Navigator.of(context).pop();
                        },
                        child: Text(
                          '확인',
                          style: TextStyle(
                              color: Color(0xff393838),
                              fontSize: 20.w,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1.w, color: Color(0xffA666FB)),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.w))),
                      width: 150.w,
                      height: 50.w,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xffffffff)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w),
                            ))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '취소',
                          style: TextStyle(
                              color: Color(0xff393838),
                              fontSize: 20.w,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}
