import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopicTextStyle extends StatefulWidget {
  const TopicTextStyle({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<TopicTextStyle> createState() => _TopicTextStyleState();
}

class _TopicTextStyleState extends State<TopicTextStyle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        color: Color(0xff393838),
        fontSize: 22.sp,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.left,
    );
  }
}

class ReportDefaultTextStyle extends StatefulWidget {
  const ReportDefaultTextStyle({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<ReportDefaultTextStyle> createState() => _ReportDefaultTextStyleState();
}

class _ReportDefaultTextStyleState extends State<ReportDefaultTextStyle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        color: Color(0xff393838),
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }
}
