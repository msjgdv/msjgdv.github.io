import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/a_main/a1.dart';
import 'package:flutter_svg/flutter_svg.dart';


class A4_5 extends StatefulWidget {
  const A4_5({Key? key}) : super(key: key);

  @override
  State<A4_5> createState() => _A4_5State();
}

class _A4_5State extends State<A4_5> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCF9F4),
      body:ScrollConfiguration(
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
                        height: 600.w,
                      ),
                      // Spacer(),
                      Row(
                        children: [
                          SizedBox(
                            height: 26.w,
                            width: 45.w,
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 45.w,
                      )
                    ],
                  ),
                ),
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
                            '비밀번호 찾기 실패',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 26.w,
                              color: Color(0xff393838),
                            )
                        ),
                        SizedBox(
                          height: 46.w,
                        ),
                        Container(
                          width: 400.w,
                          child: Text(
                            '해당 정보와 일치하는 이메일을 찾을 수 없습니다..\n다시 시도해주시기 바랍니다.',
                            style: TextStyle(
                              fontSize: 20.w,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff393838),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 161.w,
                        ),
                        SizedBox(
                          width: 350.w,
                          height: 50.w,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(const Color(0xffA666FB)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.w),
                                      ))),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => A1()),
                                );
                              },
                              child: Text(
                                '로그인하러 가기',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.w,
                                    fontWeight: FontWeight.w700),
                              )),
                        )
                      ],
                    ),
                  ),
                ),

                Container(
                  width: 270.w,
                  child: Column(
                    children: [

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
