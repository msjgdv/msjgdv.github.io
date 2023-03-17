import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReportPageHeader extends StatefulWidget {
  const ReportPageHeader({Key? key,
    required this.title,
    required this.changeScreen,
    required this.beforeWidget,
    required this.nextPage,
    this.afterWidget,
    this.name = '',
  }) : super(key: key);
  final String name;
  final String title;
  final Function(Widget) changeScreen;
  final Widget? beforeWidget;
  final Widget? afterWidget;
  final bool nextPage;

  @override
  State<ReportPageHeader> createState() => _ReportPageHeaderState();
}

class _ReportPageHeaderState extends State<ReportPageHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffFCFCFC),
      child: Row(
        children: [
          Container(
            width: 26.w,
          ),
          widget.beforeWidget != null ? IconButton(onPressed: (){
            widget.changeScreen(widget.beforeWidget!);
          }, icon: SvgPicture.asset('assets/icons/icon_back.svg', width: 15.w,)):SizedBox(width: 49.w,),
          Spacer(),
          Text(widget.name,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24.w,
              color: Color(0xff393838),
            ),),
          Text(widget.title,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 24.w,
            color: Color(0xff393838),
          ),),
          Spacer(),
          widget.nextPage == true ? IconButton(onPressed: (){
            widget.changeScreen(widget.afterWidget!);

          }, icon: SvgPicture.asset('assets/icons/icon_next.svg', width: 15.w,)):
              SizedBox(width: 49.w,),
          SizedBox(
            width: 26.w,
          ),
        ],
      ),
    );
  }
}
