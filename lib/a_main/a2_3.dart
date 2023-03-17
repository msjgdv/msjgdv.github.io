import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'a1.dart';

class A2_3 extends StatefulWidget {
  const A2_3({Key? key}) : super(key: key);

  @override
  State<A2_3> createState() => _A2_3State();
}

class _A2_3State extends State<A2_3> {

  @override
  Widget build(BuildContext context) {
    precacheImage(Image.asset('assets/backgrounds/signup_page.png').image, context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: Image.asset('assets/backgrounds/signup_page.png').image,
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
              physics: const RangeMaintainingScrollPhysics(),
              children: [
                Container(
                  height: 720.w,
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 130.w,
                        ),
                        Container(
                          width: 250.w,
                          height: 124.w,
                        ),
                        SizedBox(
                          height: 92.w,
                        ),
                        Text(
                          "스마트 에듀케어 플랫폼 Treasure Map 가입을 진심으로 축하드립니다.",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff393838),
                          ),
                        ),
                        Text(
                          "로그인후 서비스를 이용해 주시기 바랍니다.",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff393838),
                          ),
                        ),
                        SizedBox(
                          height: 153.w,
                        ),
                        SizedBox(
                          width: 310.w,
                          height: 37.w,
                          child: ElevatedButton(
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
                                Text(
                                  '로그인 화면으로 이동',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff393838),
                                  ),
                                ),
                                SizedBox(
                                  width: 34.w,
                                ),
                                SvgPicture.asset(
                                  'assets/icons/icon_next.svg',
                                  height: 14.w,
                                  width: 23.w,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
