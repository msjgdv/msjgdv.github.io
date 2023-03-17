import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/a_main/a1.dart';
import 'package:flutter_svg/flutter_svg.dart';


class A4_4 extends StatefulWidget {
  const A4_4({Key? key}) : super(key: key);

  @override
  State<A4_4> createState() => _A4_4State();
}

class _A4_4State extends State<A4_4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCF9F4),
      body: ScrollConfiguration(
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
                      SizedBox(
                        height: 50.w,
                      ),
                      // Spacer(),


                      SizedBox(
                        height: 45.w,
                      )
                    ],
                  ),
                ),
                Container(
                  width: 700.w,

                  child: Center(
                    child: Text(
                      '회원님의 비밀번호 재설정이 완료되었습니다.',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20.w,
                        color: Color(0xff393838),
                      ),
                    ),
                  ),
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
                            width: 0.w,
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
                                Text(
                                  '로그인하러 가기',
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
    );
  }
}
