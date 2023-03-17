// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/provider/record_management.dart';

//------------------------알림기록------------------------\\
double fontSize20 = 20.sp;
Color fontColor = const Color(0xFF393838);

int recordNum = 0;
List<Record> recordList = [];
int pageNum = 0;
int currentPageNum = 0;

class B14 extends StatefulWidget {
  const B14({Key? key, required this.notifyParent}) : super(key: key);
  final Function(double, double)? notifyParent;

  @override
  State<B14> createState() => _B14State();
}

class _B14State extends State<B14> {
  GlobalKey globalkeyCK = GlobalKey();

  getBoxSize(GlobalKey key) {
    if (key.currentContext != null) {
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

  bool check = false;
  List<bool> checkList = [];

  void checkOnOff(int index, bool checked) {
    setState(() {
      checkList[index] = checked;
    });
  }

  @override
  initState() {
    recordNum = Provider.of<RecordDataManagement>(context, listen: false).recordNum;
    recordList = Provider.of<RecordDataManagement>(context, listen: false).recordList;
    pageNum = recordNum ~/ 10;
    super.initState();
    for (int i = 0; i < recordNum; i++) {
      checkList.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 30.w,
                  height: 30.w,
                  child: Checkbox(
                      value: check,
                      onChanged: ((newValue) {
                        setState(() {
                          check = !check;
                          for (int i = 0; i < pageNum; i++) {
                            checkList[i] = check;
                          }
                        });
                      })),
                ),
                SizedBox(width: 20.w),
                SizedBox(
                  width: 74.w,
                  height: 29.w,
                  child: Text(
                    '전체선택',
                    style: TextStyle(fontSize: fontSize20, color: fontColor),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 21.w,
            ),
            Row(
              children: [
                SizedBox(width: 50.w),
                Container(
                  width: 130.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.w),
                      ),
                      border:
                          Border.all(width: 1, color: const Color(0xffFDB43B)),
                      color: const Color(0xffFED796)),
                  child: const Center(child: Text('발생시간')),
                ),
                Container(
                  width: 130.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: const Color(0xffFDB43B)),
                      color: const Color(0xffFED796)),
                  child: const Center(child: Text('종류')),
                ),
                Container(
                  width: 550.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.w),
                      ),
                      border:
                          Border.all(width: 1, color: const Color(0xffFDB43B)),
                      color: const Color(0xffFED796)
                  ),
                  child: const Center(child: Text('알림내용')),
                ),
              ],
            ),
            for(int i =0;i<10;i++)...[
              Row(
                children: [
                  SizedBox(
                    width: 30.w,
                    height: 30.w,
                    child: Checkbox(
                      value: check,
                      onChanged: ((newValue) {
                        setState(() {
                          check = !check;
                          for(int i=0;i<checkList.length;i++) {
                            checkList[i] = check;
                          }
                        });
                      }),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Container(
                    width: 130.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: const Color(0xffFDB43B)),
                    ),
                  ),
                  Container(
                    width: 130.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: const Color(0xffFDB43B)),
                    ),
                  ),
                  Container(
                    width: 550.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: const Color(0xffFDB43B)),
                    ),
                  )
                ],
              )
            ]
          ],
        )
      ],
    );
  }
}
