import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../widgets/custom_page_route.dart';

class HomeImage extends StatefulWidget {
  const HomeImage({Key? key,
    required this.nextPage,
    required this.changeScreen,
    required this.title,
  }) : super(key: key);
  final String title;
  final Widget nextPage;
  final Function(Widget) changeScreen;

  @override
  State<HomeImage> createState() => _HomeImageState();
}

class _HomeImageState extends State<HomeImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
        if (dragEndDetails.primaryVelocity! < 0.0) {
          // CustomPageRoute(child:widget.nextPage, direction: AxisDirection.up);
          widget.changeScreen(widget.nextPage);
        }
      },
      child: Container(
        color: Color(0xfffcfcfc),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 720.w,
                    ),
                    Container(
                      height: 1.w,
                      width: 130.w,
                      color: Color(0xff71d882),
                    ),
                    SizedBox(
                      width: 25.w,
                    ),
                    Text(
                      '미래혁신을 위한 스마트 에듀케어',
                      style: TextStyle(
                        color: Color(0xff71d882),
                        fontSize: 12.w,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                  ],
                ),
                SizedBox(
                  height: 170.w,
                ),
                SizedBox(
                  width: 1030.w,
                  height: 180.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 480.w,
                      ),
                      Spacer(),
                      Text(
                        widget.title,
                        style: TextStyle(
                            letterSpacing: 7.0,
                            fontSize: 55.w,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff9027F4)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.w,),

                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                    width: 500.w,
                  ),
                  Text(
                    '또래관계 데이터 분석결과 보고서',
                    style: TextStyle(
                        letterSpacing: 3.0,
                        fontSize: 30.w,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff434342)),
                  ),
                ]),
                SizedBox(
                  height: 180.w,
                )

              ],
            ),
            Column(
              children: [
                SizedBox(height: 0.w,),
                Row(
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    IconButton(onPressed: (){
                      widget.changeScreen(widget.nextPage);

                    }, icon: SvgPicture.asset('assets/icons/icon_next.svg')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
