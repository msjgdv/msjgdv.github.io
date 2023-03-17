import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:treasure_map/e_growth/atti/report/atti_c.dart';
import 'package:treasure_map/provider/atti_child_data_management.dart';
import 'package:widget_mask/widget_mask.dart';

import '../report/atti_d.dart';

class ChildSelectBtn extends StatefulWidget {
  const ChildSelectBtn({Key? key,
    required this.inClassNumber,
    required this.changeScreen,
    required this.beforeWidget,
    required this.goWidget,
    this.changeChild,
  }) : super(key: key);
  final Function(Widget) changeScreen;
  final Widget beforeWidget;
  final int inClassNumber;
  final int goWidget;
  final Function(int)? changeChild;


  @override
  State<ChildSelectBtn> createState() => _ChildSelectBtnState();
}

class _ChildSelectBtnState extends State<ChildSelectBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.changeChild!(widget.inClassNumber);
        // if(widget.goWidget == 0){
        //   widget.changeScreen(AttiC(changeScreen: widget.changeScreen, beforeWidget: widget.beforeWidget, inClassNumber: widget.inClassNumber));
        // }else if(widget.goWidget == 1){
        //   widget.changeScreen(AttiD(changeScreen: widget.changeScreen, beforeWidget: widget.beforeWidget, inClassNumber: widget.inClassNumber));
        // }

      },
      child: Container(
        width: 70.w,
        height: 70.w,
        child: Stack(
          children: [
            Positioned(
              left: 5.w,
              child:WidgetMask(
                  blendMode: BlendMode.srcATop,
                  childSaveLayer: true,
                  mask: Provider.of<AttiChildDataManagement>(context, listen: false).childList[widget.inClassNumber].childFace,
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(width: 1.w, color: Color(0x1AA666FC)),
                      boxShadow:[
                        BoxShadow(
                          color: Color(0x297B7B7B),
                          blurRadius: 4,
                          offset: Offset(3, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  ),),



            ),
            Positioned(
              top: 50.w,
              left: 0.w,
              child: Container(
                width: 70.w,
                height: 20.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    border: Border.all(width: 1.w,color: Color(0x4DA666FC))
                ),
                child: Center(
                  child: Text(Provider.of<AttiChildDataManagement>(context, listen: false).childList[widget.inClassNumber].name,
                    style: TextStyle(
                        fontSize: 12.w,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff393838)
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}