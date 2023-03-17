import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//==================아이좋아 서비스 구매===================\\
class B3 extends StatefulWidget {
  const B3({Key? key, required this.notifyParent}) : super(key: key);
  final Function(double, double)? notifyParent;

  @override
  State<B3> createState() => _B3State();
}

class _B3State extends State<B3> {

  GlobalKey globalkeyCK = GlobalKey();

  // void initState(){
  //   WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
  //     widget.notifyParent!(getBoxSize(globalkeyCK), getBoxPosition(globalkeyCK));
  //     //print(getBoxSize(globalkeyCK));
  //     //print(getBoxPosition(globalkeyCK));
  //     print('b3');
  //   });
  // }

  getBoxSize(GlobalKey key){
    if(key.currentContext != null){
      final RenderBox renderBox =
      key.currentContext!.findRenderObject() as RenderBox;
      final double sizeY = renderBox.size.height;
      return sizeY;
    }
  }
  getBoxPosition(GlobalKey key) {
    if (key.currentContext != null) {
      final RenderBox renderBox =
      key.currentContext!.findRenderObject() as RenderBox;
      final double positionY = renderBox.localToGlobal(Offset.zero).dy;
      return positionY;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 900.w,
      height: 600.w,
      child:Center(child: Text("개발 중",
      style: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: Color(0xff393838),
      ),)),
    );
  }
}


