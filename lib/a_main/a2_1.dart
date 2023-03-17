import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/a_main/a1.dart';
import 'package:treasure_map/a_main/a2_2.dart';
import 'package:treasure_map/widgets/custom_container.dart';

import 'package:flutter_svg/flutter_svg.dart';

class A2_1 extends StatefulWidget {
  const A2_1({Key? key}) : super(key: key);

  @override
  State<A2_1> createState() => _A2_1State();
}

class _A2_1State extends State<A2_1> {
  bool _isAllCheck = false;
  var _isPersonalConsent = false;
  var _isConditionConsent = false;
  double buttonOn = 1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xffFCF9F4),
      body: GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Row(
          children: [
            Container(
              width: 270.w,
              child: Column(
                children: [
                  SizedBox(
                    height: 57.w - MediaQuery.of(context).padding.top,
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
                  Spacer(),
                  Row(
                    children: [
                      SizedBox(
                        width: 45.w,
                      ),
                      ElevatedButton(
                        style:  ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
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
                    height: 105.w,
                  )
                ],
              ),
            ),
            Container(
              width: 700.w,
              child: Column(
                children: [
                  SizedBox(
                    height: 160.w - MediaQuery.of(context).padding.top,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Transform.scale(
                        scale: 2.1,
                        child: Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.w)),
                          activeColor: Color(0xffFFD288),
                          checkColor: Color(0xffffffff),
                          fillColor: MaterialStateProperty.all(Color(0xffFDB43B)),
                          value: _isAllCheck,
                          onChanged: (value) {
                            setState(() {
                              _isAllCheck = value!;
                              _isConditionConsent = value;
                              _isPersonalConsent = value;
                            });
                          },
                          //tristate: false,
                        ),
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      Text(
                        '모두 동의합니다.',
                        style: TextStyle(
                          fontSize: 20.w,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff393838),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 29.w,
                  ),
                  Column(
                    children: [
                      CustomContainer(
                        cTotalWidth: 700.w,
                        cTotalHeight: 60.w,
                        cBorderColor: Color(0xffFBB348).withOpacity(0.7),
                        cTopBorderWidth: 1.5.w,
                        cRightBorderWidth: 1.5.w,
                        cLeftBorderWidth: 1.5.w,
                        //cInsideColor: Color(0xffFFD288),
                        cInsideColor: Color(0xffFFD288),
                        cBorderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.w),
                          topLeft: Radius.circular(10.w),
                        ),
                        cShadowColor: Color(0xffA8A8A8).withOpacity(0.16),
                        cShadowOffset: Offset(3, 3),
                        cShadowBlurRadius: 6,
                        childWidget: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Transform.scale(
                              scale: 2.1,
                              child: Checkbox(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.w)),
                                fillColor: MaterialStateProperty.all(Color(0xffFDB43B)),
                                activeColor: Color(0xffFDB43B),
                                // checkColor: Colors.blue,
                                value: _isConditionConsent,
                                onChanged: (value) {
                                  setState(() {
                                    _isConditionConsent = value!;
                                    if (_isPersonalConsent == true &&
                                        _isConditionConsent == true) {
                                      _isAllCheck = true;
                                    } else if (_isPersonalConsent != true ||
                                        _isConditionConsent != true) {
                                      _isAllCheck = false;
                                    }
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                            ),
                            Text(
                              '이용약관에 대한 동의',
                              style: TextStyle(
                                fontSize: 20.w,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff393838),
                              ),
                            )
                          ],
                        ),
                      ),
                      // Container(
                      //   height: 130.w,
                      //   width: 700.w,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                      //     border: Border.all(color: Color(0xffFBB348), width: 1.5),
                      //     color: Colors.white,
                      //     boxShadow:[ BoxShadow(offset: Offset(3,3), color: Color(0xffA8A8A8).withOpacity(0.16),blurRadius: 6,)],
                      //   ),
                      // ),
                      CustomContainer(
                        cTotalHeight: 130.w,
                        cTotalWidth: 700.w,
                        cBorderColor: Color(0xffFBB348).withOpacity(0.7),
                        cTopBorderWidth: 1.5.w,
                        cBottomBorderWidth: 1.5.w,
                        cRightBorderWidth: 1.5.w,
                        cLeftBorderWidth: 1.5.w,
                        //cInsideColor: Color(0xffFFD288),
                        cInsideColor: Color(0xffffffff),
                        cBorderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10.w),
                          bottomLeft: Radius.circular(10.w),
                        ),
                        cShadowColor: Color(0xffA8A8A8).withOpacity(0.16),
                        cShadowOffset: Offset(3, 3),
                        cShadowBlurRadius: 6,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomContainer(
                        cTotalWidth: 700.w,
                        cTotalHeight: 60.w,
                        cBorderColor: Color(0xffFBB348).withOpacity(0.7),
                        cTopBorderWidth: 1.5.w,
                        cRightBorderWidth: 1.5.w,
                        cLeftBorderWidth: 1.5.w,
                        //cInsideColor: Color(0xffFFD288),
                        cInsideColor: Color(0xffFFD288),
                        cBorderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.w),
                          topLeft: Radius.circular(10.w),
                        ),
                        cShadowColor: Color(0xffA8A8A8).withOpacity(0.16),
                        cShadowOffset: Offset(3, 3),
                        cShadowBlurRadius: 6,
                        childWidget: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Transform.scale(
                              scale: 2.1,
                              child: Checkbox(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.w)),
                                fillColor: MaterialStateProperty.all(Color(0xffFDB43B)),
                                activeColor: Color(0xffFDB43B),
                                // activeColor: Colors.blue,
                                // checkColor: Colors.blue,
                                value: _isPersonalConsent,
                                onChanged: (value) {
                                  setState(() {
                                    _isPersonalConsent = value!;
                                    if (_isPersonalConsent == true &&
                                        _isConditionConsent == true) {
                                      _isAllCheck = true;
                                    } else if (_isPersonalConsent != true ||
                                        _isConditionConsent != true) {
                                      _isAllCheck = false;
                                    }
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                            ),
                            Text(
                              '개인정보 수집 이용에 대한 동의',
                              style: TextStyle(
                                fontSize: 20.w,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff393838),
                              ),
                            )
                          ],
                        ),
                      ),
                      CustomContainer(
                        cTotalHeight: 130.w,
                        cTotalWidth: 700.w,
                        cBorderColor: Color(0xffFBB348).withOpacity(0.7),
                        cTopBorderWidth: 1.5.w,
                        cBottomBorderWidth: 1.5.w,
                        cRightBorderWidth: 1.5.w,
                        cLeftBorderWidth: 1.5.w,
                        //cInsideColor: Color(0xffFFD288),
                        cInsideColor: Color(0xffffffff),
                        cBorderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10.w),
                          bottomLeft: Radius.circular(10.w),
                        ),
                        cShadowColor: Color(0xffA8A8A8).withOpacity(0.16),
                        cShadowOffset: Offset(3, 3),
                        cShadowBlurRadius: 6,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: 270.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [

                      SizedBox(
                        width: 110.w,
                      ),
                      _isAllCheck == true ?
                      ElevatedButton(
                        style:  ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        onPressed: () {if (_isAllCheck == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => A2_2()),
                          );
                        }},
                        child:
                        Row(
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
                      ) :
                      ElevatedButton(
                        style:  ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        onPressed: () {},
                        child:
                        Row(
                          children: [
                            Text(
                              '다음',
                              style: TextStyle(
                                fontSize: 26.w,
                                fontWeight: FontWeight.w400,
                                color: Colors.black12,
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                            ),
                            SvgPicture.asset(
                              'assets/icons/icon_next.svg',
                              height: 14.w,
                              width: 23.w,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 105.w,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

