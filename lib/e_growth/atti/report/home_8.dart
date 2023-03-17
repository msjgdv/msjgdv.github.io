import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/home_image.dart';
import 'atti_a.dart';
import 'atti_e.dart';

class Home_8 extends StatefulWidget {
  const Home_8({Key? key,
    required this.nowPage,
    required this.changeScreen,

  }) : super(key: key);

  final int nowPage;
  final Function(Widget) changeScreen;


  @override
  State<Home_8> createState() => _Home_8State();
}

class _Home_8State extends State<Home_8> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (DragEndDetails dragEndDetails){
        if (dragEndDetails.primaryVelocity! > 0.0) {
        }
      },
      child: Container(
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
              child: Column(
                children: [
                  SizedBox(
                    height: 55.w,
                  ),
                  HomeImage(nextPage: AttiE(changeScreen: widget.changeScreen, beforeWidget: this.widget), changeScreen: widget.changeScreen, title: "우리반 또래 관계도",),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
