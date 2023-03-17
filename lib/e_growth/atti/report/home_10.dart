import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/e_growth/atti/report/atti_g.dart';

import '../widget/home_image.dart';
import 'atti_a.dart';

class Home_10 extends StatefulWidget {
  const Home_10({Key? key,
    required this.nowPage,
    required this.changeScreen,

  }) : super(key: key);

  final int nowPage;
  final Function(Widget) changeScreen;

  @override
  State<Home_10> createState() => _Home_10State();
}

class _Home_10State extends State<Home_10> {
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
                  HomeImage(nextPage: AttiG(changeScreen: widget.changeScreen, beforeWidget: this.widget), changeScreen: widget.changeScreen, title: "우리반의 사회적   \n지위 분포도",),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
