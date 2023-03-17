import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/e_growth/atti/report/atti_h.dart';
import 'package:treasure_map/e_growth/atti/report/home_1.dart';

import '../widget/home_image.dart';
import 'atti_a.dart';

class Home_11 extends StatefulWidget {
  const Home_11({Key? key,
    required this.nowPage,
    required this.changeScreen,

  }) : super(key: key);

  final int nowPage;
  final Function(Widget) changeScreen;

  @override
  State<Home_11> createState() => _Home_11State();
}

class _Home_11State extends State<Home_11> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (DragEndDetails dragEndDetails){
        if (dragEndDetails.primaryVelocity! > 0.0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home_1()),
          );
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
                  HomeImage(nextPage: AttiH(changeScreen: widget.changeScreen, beforeWidget: this.widget), changeScreen: widget.changeScreen, title: "우리반의 싫어하는\n또래 네트워크",),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
