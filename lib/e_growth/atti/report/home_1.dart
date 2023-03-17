import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../widgets/custom_page_route.dart';
import '../widget/home_image.dart';
import 'atti_a.dart';
import 'home_2.dart';

class Home_1 extends StatefulWidget {
  const Home_1({Key? key,

  }) : super(key: key);


  @override
  State<Home_1> createState() => _Home_1State();
}

class _Home_1State extends State<Home_1> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (DragEndDetails dragEndDetails){
        if (dragEndDetails.primaryVelocity! < 0.0) {
          Navigator.of(context).push(CustomPageRoute(
              child: Home_2(),
              direction: AxisDirection.up
          )
          );
        }
      },
      child: Container(
        color: Colors.grey,
        child: Stack(
          children: [
            SvgPicture.asset('assets/images/atti/atti_home_1_background.svg',
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
            ),
            Positioned(
              top: 245.w,
              left: 570.w,
              child: SvgPicture.asset('assets/icons/atti/atti_logo.svg'),),
            Positioned(
                top: 400.w,
                left: 560.w,
                child: Text('또래관계 데이터 분석 결과 보고서',
            style: TextStyle(
             decoration: TextDecoration.none,
              fontSize: 20.sp,
              color: Color(0xff393838),
              fontWeight: FontWeight.w600,
            ),)),
            Positioned(
                top: 640.w,
                left: 800.w,
                child: Text('미래혁신을 위한 스마트 에듀케어',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 13.sp,
                    color: Color(0xff393838),
                    fontWeight: FontWeight.w600,
                  ),)),
            Positioned(
              top: 630.w,
              left: 610.w,
              child: Icon(Icons.keyboard_arrow_down,
              size: 60.w,
              color: Color(0xff393838),)),
          ],
        ),
      ),
    );
  }
}
