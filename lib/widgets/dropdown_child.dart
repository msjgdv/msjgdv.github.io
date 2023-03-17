import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropDownChildInfo {
  String childName;
  int childId;

  DropDownChildInfo({
    required this.childName,
    required this.childId,
  });
}

class SelectMonth{
  String date;
  String dataMonth;

  SelectMonth({
    required this.date,
    required this.dataMonth,
  });
}


class ChildDropDownButton extends StatefulWidget {
  const ChildDropDownButton({
    Key? key,
    required this.dropDownChildInfo,
    required this.setChildId,
    this.btnColor = const Color(0xff7F50C4),
    this.width = 150,
    this.borderRadius = 5,
    this.borderColor = const Color(0xffCF78FB),
    this.shadow = true,
    this.index = -1,
  }) : super(key: key);
  final List<DropDownChildInfo> dropDownChildInfo;
  final Function(int, int) setChildId;
  final Color btnColor;
  final double width;
  final double borderRadius;
  final Color borderColor;
  final bool shadow;
  final int index;

  @override
  State<ChildDropDownButton> createState() => _ChildDropDownButtonState();
}

class _ChildDropDownButtonState extends State<ChildDropDownButton> {
  List<int> number = [];
  int now = -1;

  List<DropdownMenuItem<int>> childList() {
    return number
        .map<DropdownMenuItem<int>>(
          (e) =>
          DropdownMenuItem(
            enabled: true,
            alignment: Alignment.centerLeft,
            value: e,
            child: Text(
              widget.dropDownChildInfo[e].childName,
              style: TextStyle(
                  color: Color(0xff393838),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
    )
        .toList();
  }

  @override
  void initState() {
    for (int i = 0; i < widget.dropDownChildInfo.length; i++) {
      number.add(i);
    }
    now = widget.dropDownChildInfo.indexWhere((childData) => childData.childId == widget.index);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // for (int i = 0; i < widget.dropDownChildInfo.length; i++) {
    //   number.add(i);
    // }
    return Container(
      width: widget.width.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius.w)),
        color: Colors.white,
        border: Border.all(color: widget.borderColor, width: 1.w),
        boxShadow: [
          if(widget.shadow)...[
            BoxShadow(
              color: Color(0x29000000),
              blurRadius: 6,
              offset: Offset(1, 1),
            ),
          ]
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: (widget.width - 10).w,
            child: DropdownButton(
              isExpanded: true,
              menuMaxHeight: 300.w,
              value: now == -1 ? null : now,
              elevation: 16,
              items: childList(),
              onChanged: (value) {
                setState(() {
                  for (int i = 0; i < childList().length; i++) {
                    if (childList()[i].value == value) {
                      widget.setChildId(widget.dropDownChildInfo[i].childId, i);
                      now = i;
                    }
                  }
                });
              },
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_drop_down,
                    size: 25.w,
                    color: widget.btnColor,
                  ),
                ],
              ),
              alignment: AlignmentDirectional.topCenter,
              underline: SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}


class MonthDropDownButton extends StatefulWidget {
  const MonthDropDownButton({
    Key? key,
    required this.dropDownMonthInfo,
    required this.setChildId,
    required this.getChildData,
    this.btnColor = const Color(0xff7F50C4),
    this.width = 150,
    this.borderRadius = 5,
    this.borderColor = const Color(0xffCF78FB),
    this.shadow = true,
    this.index = '',

  }) : super(key: key);
  final List<SelectMonth> dropDownMonthInfo;
  final Function(String, int, String) setChildId;
  final Color btnColor;
  final double width;
  final double borderRadius;
  final Color borderColor;
  final bool shadow;
  final String index;
  final Function() getChildData;

  @override
  State<MonthDropDownButton> createState() => _MonthDropDownButtonState();
}

class _MonthDropDownButtonState extends State<MonthDropDownButton> {
  List<int> number = [];
  int now = -1;

  List<DropdownMenuItem<int>> childList() {
    return number
        .map<DropdownMenuItem<int>>(
          (e) =>
          DropdownMenuItem(
            enabled: true,
            alignment: Alignment.centerLeft,
            value: e,
            child: Text(
              widget.dropDownMonthInfo[e].date,
              style: TextStyle(
                  color: Color(0xff393838),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
    )
        .toList();
  }

  @override
  void initState() {
    for (int i = 0; i < widget.dropDownMonthInfo.length; i++) {
      number.add(i);
    }
    now = widget.dropDownMonthInfo.indexWhere((monthData) => monthData.dataMonth == widget.index);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // for (int i = 0; i < widget.dropDownChildInfo.length; i++) {
    //   number.add(i);
    // }
    return Container(
      width: widget.width.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius.w)),
        color: Colors.white,
        border: Border.all(color: widget.borderColor, width: 1.w),
        boxShadow: [
          if(widget.shadow)...[
            BoxShadow(
              color: Color(0x29000000),
              blurRadius: 6,
              offset: Offset(1, 1),
            ),
          ]
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: (widget.width - 10).w,
            child: DropdownButton(
              isExpanded: true,
              menuMaxHeight: 300.w,
              value: now == -1 ? null : now,
              elevation: 16,
              items: childList(),
              onChanged: (value) {
                setState(() {
                  for (int i = 0; i < childList().length; i++) {
                    if (childList()[i].value == value) {
                      widget.setChildId(widget.dropDownMonthInfo[i].dataMonth, i, widget.dropDownMonthInfo[i].date);
                      now = i;
                    }
                  }
                  widget.getChildData();
                });
              },
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_drop_down,
                    size: 25.w,
                    color: widget.btnColor,
                  ),
                ],
              ),
              alignment: AlignmentDirectional.topCenter,
              underline: SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class TargetDropDownButton extends StatefulWidget {
  const TargetDropDownButton({
    Key? key,
    required this.dropDownTarget,
    required this.setTarget,
    this.btnColor = const Color(0xff7F50C4),
    this.width = 150,
    this.borderRadius = 5,
    this.borderColor = const Color(0xffCF78FB),
    this.shadow = true,
    this.index = -1,
  }) : super(key: key);
  final List<String> dropDownTarget;
  final Function(String, int) setTarget;
  final Color btnColor;
  final double width;
  final double borderRadius;
  final Color borderColor;
  final bool shadow;
  final int? index;

  @override
  State<TargetDropDownButton> createState() => _TargetDropDownButtonState();
}

class _TargetDropDownButtonState extends State<TargetDropDownButton> {
  List<int> number = [];
  int now = -1;

  List<DropdownMenuItem<int>> childList() {
    return number
        .map<DropdownMenuItem<int>>(
          (e) =>
          DropdownMenuItem(
            enabled: true,
            alignment: Alignment.centerLeft,
            value: e,
            child: Text(
              widget.dropDownTarget[e],
              style: TextStyle(
                  color: Color(0xff393838),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
    )
        .toList();
  }

  @override
  void initState() {
    for (int i = 0; i < widget.dropDownTarget.length; i++) {
      number.add(i);
    }
    now = widget.index!;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // for (int i = 0; i < widget.dropDownChildInfo.length; i++) {
    //   number.add(i);
    // }
    return Container(
      width: widget.width.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius.w)),
        color: Colors.white,
        border: Border.all(color: widget.borderColor, width: 1.w),
        boxShadow: [
          if(widget.shadow)...[
            BoxShadow(
              color: Color(0x29000000),
              blurRadius: 6,
              offset: Offset(1, 1),
            ),
          ]
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: (widget.width - 10).w,
            child: DropdownButton(
              isExpanded: true,
              menuMaxHeight: 300.w,
              value: now == -1 ? null : now,
              elevation: 16,
              items: childList(),
              onChanged: (value) {
                setState(() {
                  for (int i = 0; i < childList().length; i++) {
                    if (childList()[i].value == value) {
                      widget.setTarget(widget.dropDownTarget[i], i);
                      now = i;
                    }
                  }
                });
              },
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_drop_down,
                    size: 25.w,
                    color: widget.btnColor,
                  ),
                ],
              ),
              alignment: AlignmentDirectional.topCenter,
              underline: SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}