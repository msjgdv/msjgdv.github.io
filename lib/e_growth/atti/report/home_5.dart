import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/e_growth/atti/report/home_1.dart';

import '../../../widgets/custom_page_route.dart';
import '../widget/home_image.dart';
import 'atti_a.dart';
import 'home_2.dart';

class Home_5 extends StatefulWidget {
  const Home_5({Key? key,
    required this.nowPage,
    required this.changeScreen,
  }) : super(key: key);
  final int nowPage;
  final Function(Widget) changeScreen;


  @override
  State<Home_5> createState() => _Home_5State();
}

class _Home_5State extends State<Home_5> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onVerticalDragEnd: (DragEndDetails dragEndDetails){
      //   if (dragEndDetails.primaryVelocity! > 0.0) {
      //     Navigator.of(context).push(CustomPageRoute(
      //       child: Home_2(),
      //       direction: AxisDirection.down
      //     )
      //     );
      //
      //   }
      // },
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
            SizedBox(
              height: 55.w,
            ),
            HomeImage(changeScreen: widget.changeScreen, nextPage: AttiA(changeScreen: widget.changeScreen, beforeWidget: this.widget, ), title: "우리반의 또래관계\n분석현황",),

          ],
        ),
      ),
    );
  }
}
