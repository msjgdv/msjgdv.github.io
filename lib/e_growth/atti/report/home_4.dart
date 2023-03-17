import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home_4 extends StatefulWidget {
  const Home_4({Key? key,
    required this.nowPage,
    required this.changeScreen,
  }) : super(key: key);
  final int nowPage;
  final Function(Widget)? changeScreen;


  @override
  State<Home_4> createState() => _Home_4State();
}

class _Home_4State extends State<Home_4> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.w),
          bottomLeft: Radius.circular(50.w),
        ),
        color: Color(0xffFCFCFC),

      ),
      child: Column(
        children: [
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                physics: const RangeMaintainingScrollPhysics(),
                children: [
                  for (int i = 0; i < 0; i++) ...[

                  ],
                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: Color(0xfffcfcfc),
                            height: 10.w,
                            width: 39.w,
                          )
                        ],
                      )),
                  Container(
                    height: 50.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.w),
                      ),
                      color: Color(0xffFCFCFC),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
