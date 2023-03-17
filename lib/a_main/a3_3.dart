import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/a_main/a1.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treasure_map/a_main/a4_1.dart';



class A3_3 extends StatefulWidget {
  const A3_3({
    Key? key,
    required this.userIds,
  }) : super(key: key);
  final userIds;

  @override
  State<A3_3> createState() => _A3_3State();
}

class _A3_3State extends State<A3_3> {
  String userID = '';

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
                          height: 145.w,
                        ),
                        Text('회원님의 아이디는',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20.w,
                              color: Color(0xff393838),
                            )),
                        for(int i = 0; i< widget.userIds.length;i++)...[
                          Text(widget.userIds[i]['email'].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 25.w,
                                color: Color(0xff393838),
                              )),
                        ],
                        Text('입니다.',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20.w,
                              color: Color(0xff393838),
                            )),
                        SizedBox(
                          height: 151.w,
                        ),
                        SizedBox(
                          width: 350.w,
                          height: 50.w,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>A4_1()));
                            },
                            child: Text(
                              '비밀번호 찾기',
                              style: TextStyle(
                                  color: Color(0xff393838),
                                  fontSize: 20.w,
                                  fontWeight: FontWeight.w400),
                            ),
                            style: OutlinedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.w)),
                              side:
                              BorderSide(width: 1, color: Color(0xffA666FB)),
                              primary: Color(0xffA666FB),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.w,
                        ),
                        SizedBox(
                          width: 350.w,
                          height: 50.w,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      const Color(0xffA666FB)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
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
                                    fontWeight: FontWeight.w400),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 270.w,
                  child: Column(
                    children: [],
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
