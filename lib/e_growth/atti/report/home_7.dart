import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/provider/atti_child_data_management.dart';
import 'package:provider/provider.dart';
import 'package:treasure_map/provider/report_data_management.dart';

import '../../../widgets/custom_page_route.dart';
import '../atti5.dart';
import '../widget/child_select_btn.dart';
import '../widget/home_image.dart';
import 'atti_a.dart';
import 'atti_c.dart';
import 'atti_d.dart';
import 'home_2.dart';

class Home_7 extends StatefulWidget {
  const Home_7({
    Key? key,
    required this.nowPage,
    required this.changeScreen,
  }) : super(key: key);

  final int nowPage;
  final Function(Widget) changeScreen;

  @override
  State<Home_7> createState() => _Home_7State();
}

class _Home_7State extends State<Home_7> {
  int headCount = 30;
  int lineCount = 0;
  int modulo = 0;
  bool onOff = false;

  @override
  void initState() {
    headCount = Provider.of<ReportDataManagement>(context, listen: false).headCount;
    lineCount = (headCount/8).floor();
    modulo = headCount%8;
      Future.delayed(const Duration(milliseconds: 10), (){
      onOffSetTrue();
      });
    super.initState();
  }

  onOffSetTrue(){
    setState(() {
      onOff = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    int j = 0;
    return GestureDetector(
      onVerticalDragEnd: (DragEndDetails dragEndDetails) {
        if (dragEndDetails.primaryVelocity! > 0.0) {
          Navigator.of(context).push(CustomPageRoute(
              child: Home_2(
                  nextPage: Atti5(
                nowPage: 2,
              )),
              direction: AxisDirection.down));
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
        child: Stack(
          children: [
            Positioned(
              top: 55.w,
              child: HomeImage(
                nextPage: AttiD(
                    changeScreen: widget.changeScreen,
                    beforeWidget: this.widget,
                  name : "가나다",),
                changeScreen: widget.changeScreen,
                title: "개별유아 또래 간\n연결 및 영향 수준 ",
              ),
            ),

            for(int i=0;i<lineCount;i++)...[
              for(int k = 0; k<8;k++, j++)...[
                AnimatedPositioned(
                  child: ChildSelectBtn(inClassNumber : k + i *8, changeScreen: widget.changeScreen, beforeWidget: widget, goWidget: 1,),
                  duration: Duration(milliseconds: 1000 + j*30),
                  curve: Curves.fastOutSlowIn,
                  left: onOff != true ? -1000.w : (29 + 85*i).w,
                  top: (20 + 91*k).w,
                )
              ],
            ],
            for(int k = 0; k<modulo;k++, j++)...[
              AnimatedPositioned(
                child: ChildSelectBtn(inClassNumber : j, changeScreen: widget.changeScreen,beforeWidget: widget, goWidget: 1,),
                duration: Duration(milliseconds: 1000 + j*30),
                curve: Curves.fastOutSlowIn,
                left: onOff != true ? -1000.w : (29 + 85*lineCount).w,
                top: (20 + 91*k).w,
              )
            ],

            // for(int i = 0; i<(headCount/8).ceil() ; i++,j++)...[
            //   if(i<(headCount/8).ceil() - 1)...[
            //     for(int k = 0; k<8; k++, j++)...[
            //       AnimatedPositioned(
            //         child: ChildSelectBtn(),
            //         duration: Duration(milliseconds: 1000 + j*30),
            //         curve: Curves.fastOutSlowIn,
            //         left: onOff != true ? -1000.w : (29 + 85*i).w,
            //         top: (20 + 91*k).w,
            //       )
            //     ]
            //   ]else if(i == (headCount/8).ceil() - 1)...[
            //     for(int k = 0; k<headCount%8; k++, j++)...[
            //       AnimatedPositioned(
            //         child: ChildSelectBtn(),
            //         duration: Duration(milliseconds: 1000 + j*30),
            //         curve: Curves.fastOutSlowIn,
            //         left: onOff != true ? -1000.w : (24 + 85*i).w,
            //         top: (20 + 91*k).w,
            //       )
            //     ]
            //   ]
            // ],
          ],
        ),
      ),
    );
  }
}

