import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/e_growth/atti/atti5.dart';
import 'package:provider/provider.dart';
import 'package:treasure_map/provider/report_data_management.dart';

import '../../../widgets/custom_page_route.dart';
import '../widget/child_select_btn.dart';
import '../widget/home_image.dart';
import 'atti_a.dart';
import 'atti_b.dart';
import 'atti_c.dart';
import 'home_2.dart';

class Home_6 extends StatefulWidget {
  const Home_6({
    Key? key,
    required this.nowPage,
    required this.changeScreen,
  }) : super(key: key);

  final int nowPage;
  final Function(Widget) changeScreen;

  @override
  State<Home_6> createState() => _Home_6State();
}

class _Home_6State extends State<Home_6> {
  int headCount = 1;
  int lineCount = 0;
  int modulo = 0;
  bool onOff = false;

  @override
  void initState() {
    headCount = Provider.of<ReportDataManagement>(context, listen: false).headCount;
    lineCount = (headCount/8).floor();
    modulo = headCount%8;
    super.initState();
  }

  onOffSetTrue(){
    setState(() {
      onOff = true;
    });
  }

  _afterLayout(_) {
    onOffSetTrue();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    int j = 0;
    return GestureDetector(
      onVerticalDragEnd: (DragEndDetails dragEndDetails) {
        if (dragEndDetails.primaryVelocity! > 0.0) {
          Navigator.of(context).push(CustomPageRoute(
              child: Home_2(nextPage : Atti5(nowPage: 1,)),
              direction: AxisDirection.down
          )
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
        child: Stack(
          children: [
            Positioned(
              top: 55.w,
              child:
                  HomeImage(
                    nextPage: AttiC(
                        changeScreen: widget.changeScreen,
                        beforeWidget: this.widget,
                    ),
                    changeScreen: widget.changeScreen,
                    title: "개별유아가\n좋아하는 친구들   ",
                  ),
            ),

            for(int i=0;i<lineCount;i++)...[
              for(int k = 0; k<8;k++, j++)...[
                AnimatedPositioned(
                  duration: Duration(milliseconds: 1000 + j*30),
                  curve: Curves.fastOutSlowIn,
                  left: onOff != true ? -1000.w : (29 + 85*i).w,
                  top: (20 + 91*k).w,
                  child: ChildSelectBtn(inClassNumber : k + i *8, changeScreen: widget.changeScreen, beforeWidget: widget, goWidget: 0,),
                )
              ],
            ],
            for(int k = 0; k<modulo;k++, j++)...[
              AnimatedPositioned(
                child: ChildSelectBtn(inClassNumber : j, changeScreen: widget.changeScreen,beforeWidget: widget, goWidget: 0,),
                duration: Duration(milliseconds: 1000 + j*30),
                curve: Curves.fastOutSlowIn,
                left: onOff != true ? -1000.w : (29 + 85*lineCount).w,
                top: (20 + 91*k).w,
              )
            ],

            // for(int i = 0; i<(headCount/8).ceil() ; i++,j++)...[
            //   if(i<=(headCount/8).ceil() -1)...[
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
