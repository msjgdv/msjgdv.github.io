// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:treasure_map/provider/teacher_data_management.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:treasure_map/widgets/api.dart';
import '../admin.dart';
import '../api/admin.dart';
import '../main.dart';
import '../widgets/custom_container.dart';
import '../widgets/token_time_over.dart';
import 'b5_1.dart';

int teacherNum = 0;
List<Teacher> teacherList = [];

class B6_1 extends StatefulWidget {
  const B6_1({Key? key,
    required this.notifyParent,
    required this.schoolYear,
    required this.schoolYearSetting,
  }) : super(key: key);
  final Function(double, double)? notifyParent;
  final int schoolYear;
  final Function(int) schoolYearSetting;

  @override
  State<B6_1> createState() => _B6_1State();
}

class _B6_1State extends State<B6_1> {
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


  getTeacherInfo() async {
    ApiUrl apiUrl = ApiUrl();
    http.Response teacherRes =
    await api('${apiUrl.teacher}', 'get', 'adminToken', {}, context);
    if(teacherRes.statusCode == 200) {
      var teacherRB = utf8.decode(teacherRes.bodyBytes);
      var teacherData = jsonDecode(teacherRB);
      print(teacherData);
      setState(() {
        Provider
            .of<TeacherDataManagement>(context, listen: false)
            .teacherList
            .clear();
        for (int i = 0; i < teacherData.length; i++) {
          Provider
              .of<TeacherDataManagement>(context, listen: false)
              .teacherList
              .add(
              Teacher(
                name: teacherData[i]['name'],
                className: teacherData[i]['className'],
                phoneNum: teacherData[i]['phoneNumber'],
                id: teacherData[i]['id'],
                email: teacherData[i]['email'],
              ));
        }
      });
    }

  }

  @override
  void initState() {

    getTeacherInfo();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // teacherNum = Provider.of<TeacherDataManagement>(context, listen: false).teacherNum;
    teacherList = Provider.of<TeacherDataManagement>(context, listen: false).teacherList;
    return SingleChildScrollView(
      child: Row(
        children: [
          SizedBox(width: 45.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            key: globalkeyCK,
            children: [
              Container(
                width: 900.w,
                margin: EdgeInsets.only(top: 44.01.w),
                child: Row(
                  children: [
                    SizedBox(
                        height: 32.w,
                        child: Text('선생님 목록',
                            style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF393838)))),
                    Spacer(),
                    SchoolYearSettingWidget(schoolYear: widget.schoolYear, schoolYearSetting: widget.schoolYearSetting, getFunction: ()=> getTeacherInfo(),),
                  ],
                ),
              ),
              Container(
                // height: 550.w,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 46.w,
                      ),
                      Row(
                        children: [
                          CustomContainer(
                            cTotalWidth: 70.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cBorderRadius: BorderRadius.only(topLeft: Radius.circular(10.w)),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget:
                            const Center(child: AdminTableTextStyle(text : '번호')),
                          ),
                          CustomContainer(
                            cTotalWidth: 195.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget:
                            const Center(child: AdminTableTextStyle(text : '이름')),
                          ),
                          CustomContainer(
                            cTotalWidth: 215.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget:
                            const Center(child: AdminTableTextStyle(text : '담당반')),
                          ),
                          CustomContainer(
                            cTotalWidth: 210.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget:
                            const Center(child: AdminTableTextStyle(text : '연락처')),
                          ),
                          CustomContainer(
                            cTotalWidth: 210.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cBorderRadius: BorderRadius.only(topRight: Radius.circular(10.w)),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            childWidget:
                            const Center(child: AdminTableTextStyle(text : '아이디')),
                          ),

                        ],
                      ),
                      Container(
                          width: 900.w,
                          height: 360.w,
                          decoration: BoxDecoration(
                              color: Colors.white,

                              border: Border.all(
                                  color: const Color(0xFFFBB348),
                                  width: 1.w)),
                          child: ScrollConfiguration(
                            behavior: const ScrollBehavior().copyWith(overscroll: false),
                            child: ListView(
                                padding: EdgeInsets.zero,
                                physics: const RangeMaintainingScrollPhysics(),
                                children: [
                              for (int i = 0; i < Provider.of<TeacherDataManagement>(context, listen: false).teacherList.length; i++) ...[
                                TeacherListRow(
                                  teacherIndex: i,
                                  name: Provider.of<TeacherDataManagement>(context, listen: false).teacherList[i].name,
                                  className: Provider.of<TeacherDataManagement>(context, listen: false).teacherList[i].className,
                                  phoneNum: Provider.of<TeacherDataManagement>(context, listen: false).teacherList[i].phoneNum,
                                  id: Provider.of<TeacherDataManagement>(context, listen: false).teacherList[i].email,

                                )
                              ]

                            ]),
                          )),
                      SizedBox(height: 25.w),
                      // Spacer(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 25.w,
                            ),
                            SizedBox(
                              width: 260.w,
                              height: 50.w,
                              //margin: EdgeInsets.only(left: 100.w),
                              child: ElevatedButton(
                                onPressed: () async {
                                  debugPrint('선생님 등록');
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ReigsterTeacherDialog(
                                          refresh: getTeacherInfo,
                                        );
                                      });
                                },
                                child: Text('선생님 등록',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.sp)),
                                style: ElevatedButton.styleFrom(
                                    elevation: 1.0,
                                    primary: const Color(0xFFA666FB),
                                    onPrimary: const Color(0xFFFFFFFF),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.w)),
                                    fixedSize: Size(200.w, 50.w)),
                              ),
                            ),

                            ///선생님 수정

                            Container(
                              width: 260.w,
                              height: 50.w,
                              margin: EdgeInsets.only(left: 40.w, right: 50.w),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await showDialog(
                                      barrierColor: Colors.transparent,
                                      context: context,
                                      builder: (BuildContext context) {
                                        debugPrint('showDialog');
                                        return DismissTeacherDialog(
                                          reloadTInfo: getTeacherInfo,
                                        );
                                      });
                                },
                                child: Text('선생님 등록 해제',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.sp)),
                                style: ElevatedButton.styleFrom(
                                    elevation: 1.0,
                                    primary: const Color(0xFFA666FB),
                                    onPrimary: const Color(0xFFFFFFFF),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.w)),
                                    fixedSize: Size(220.w, 50.w)),
                              ),
                            )
                          ]),

                    ]),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class TeacherListRow extends StatefulWidget {
  const TeacherListRow(
      {required this.teacherIndex,
      required this.name,
      required this.className,
      required this.phoneNum,
      required this.id,

      Key? key})
      : super(key: key);
  final teacherIndex;
  final name;
  final className;
  final phoneNum;
  final id;


  @override
  State<TeacherListRow> createState() => _TeacherListRowState();
}

class _TeacherListRowState extends State<TeacherListRow> {
  Color bordercolor = const Color(0xFFFBB348);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 862.w,
      height: 40.w,
      child: Row(
        children: [
          ///이름

          Container(
            width: 70.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border(right: BorderSide(color: bordercolor, width: 1.w),
                bottom: BorderSide(color: bordercolor, width: 1.w))),
            child: Center(child: AdminTableTextStyle(text : (widget.teacherIndex+1).toString())),
          ),
          Container(
            width: 195.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border(right: BorderSide(color: bordercolor, width: 1.w),
                    bottom: BorderSide(color: bordercolor, width: 1.w))),
            child: Center(child: AdminTableTextStyle(text : widget.name)),
          ),

          ///담당반
          Container(
            width: 215.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border(right: BorderSide(color: bordercolor, width: 1.w),
                    bottom: BorderSide(color: bordercolor, width: 1.w))),
            child: Center(child: AdminTableTextStyle(text : widget.className)),
          ),

          ///연락처
          Container(
            width: 210.w,
            height: 40.w,
            decoration: BoxDecoration(border: Border(right: BorderSide(color: bordercolor, width: 1.w),
                bottom: BorderSide(color: bordercolor, width: 1.w))),
            child: Center(child: AdminTableTextStyle(text : widget.phoneNum)),
          ),

          ///아이디
          Container(
            width: 208.w,
            height: 40.w,
            decoration: BoxDecoration(border: Border(
                bottom: BorderSide(color: bordercolor, width: 1.w))),
            child: Center(child: AdminTableTextStyle(text : widget.id)),
          ),
        ],
      ),
    );
  }
}

class ApplyTeachers{
  int id;
  String email;
  String name;
  String phoneNumber;

  ApplyTeachers({
   required this.phoneNumber,
   required this.id,
   required this.name,
   required this.email,
});
}

class ReigsterTeacherDialog extends StatefulWidget {
  const ReigsterTeacherDialog({required this.refresh, Key? key})
      : super(key: key);
  final Function() refresh;

  @override
  State<ReigsterTeacherDialog> createState() => _ReigsterTeacherDialogState();
}

class _ReigsterTeacherDialogState extends State<ReigsterTeacherDialog> {
  List<ApplyTeachers> applyTeachers = [];
  ApiUrl apiUrl = ApiUrl();
  getApplyList() async {

    http.Response res = await api(apiUrl.apply, 'get', 'adminToken', {}, context);
    if(res.statusCode == 200){
      var applyRB = utf8.decode(res.bodyBytes);
      var applyData = jsonDecode(applyRB);
      setState(() {
        print(applyData);
        widget.refresh;
        applyTeachers.clear();
        for (int i = 0; i < applyData.length; i++) {
          applyTeachers.add(ApplyTeachers(phoneNumber: applyData[i]['phoneNumber'],
              id: applyData[i]['id'],
              name: applyData[i]['name'],
              email: applyData[i]['email']));
        }
      });
    }
  }
  @override
  void initState() {
    getApplyList();

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Future<void> approvedBtn(bool AorD, int teacherIndex) async {
      if (AorD == true) {
        Identification identification = Identification(id: applyTeachers[teacherIndex].id);
        http.Response res = await api(apiUrl.teacher, 'post', 'adminToken',
            identification, context);
        if(res.statusCode == 200){
          getApplyList();
          widget.refresh();
        }
      }else if(AorD != true){
        DeleteTeacher deleteTeacher = DeleteTeacher(deleteList: [applyTeachers[teacherIndex].id]);
        http.Response res = await api('${apiUrl.apply}/${applyTeachers[teacherIndex].id}', 'delete', 'adminToken',
            {}, context);
        if(res.statusCode == 200){
          getApplyList();
          widget.refresh();
        }
      }
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
            width: 1000.w,
            height: 550.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w),
                color: const Color(0xFFFCF9F4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0.w, 47.w, 0.w, 0.w),
                  child: Text(
                    '선생님 등록',
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF393838)),
                  ),
                ),
                SizedBox(
                  height: 46.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    CustomContainer(
                      cTotalWidth: 150.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cBorderRadius: BorderRadius.only(topLeft: Radius.circular(10.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget:
                      const Center(child: AdminTableTextStyle(text : '이름')),
                    ),

                    CustomContainer(
                      cTotalWidth: 320.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget:
                      const Center(child: AdminTableTextStyle(text : '아이디')),
                    ),

                    CustomContainer(
                      cTotalWidth: 200.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget:
                      const Center(child: AdminTableTextStyle(text : '연락처')),
                    ),

                    CustomContainer(
                      cTotalWidth: 100.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget:
                      const Center(child: AdminTableTextStyle(text : '허가')),
                    ),

                    CustomContainer(
                      cTotalWidth: 100.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cBorderRadius: BorderRadius.only(topRight: Radius.circular(10.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget:
                      const Center(child: AdminTableTextStyle(text : '반려')),
                    ),
                  ],
                ),
                SingleChildScrollView(
                    child: Container(
                  width: 870.w,
                  height: 235.w,
                  margin: EdgeInsets.only(left: 20.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.only(
                      //     bottomLeft: Radius.circular(10.w),
                      //     bottomRight: Radius.circular(10.w)),
                      border: Border.all(
                          color: const Color(0xFFFBB348), width: 1.w)),
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: ListView(
                            padding: EdgeInsets.zero,
                            physics: const RangeMaintainingScrollPhysics(),
                        children: [
                      for (int i = 0; i <
                          applyTeachers.length
                      ; i++) ...[
                        TeacherRegisterRow(
                          teacherIndex: i,
                          name: applyTeachers[i].name,
                          phoneNum: applyTeachers[i].phoneNumber,
                          id: applyTeachers[i].email,
                          approvedBtn: approvedBtn,
                        )
                      ]
                    ]),
                  ),
                )),
                SizedBox(height: 42.w),
                ElevatedButton(
                  onPressed: () {
                    debugPrint('창 닫기');

                    Navigator.pop(context); //result 반영 dialog 종료
                  },
                  child: Text('창 닫기',
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w400)),
                  style: ElevatedButton.styleFrom(
                      elevation: 1.0,
                      primary: const Color(0xFFFFFFFF),
                      onPrimary: const Color(0xFF393838),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.w)),
                      side: const BorderSide(color: Color(0xFFA666FB)),
                      fixedSize: Size(150.w, 50.w)),
                )
              ],
            )),
      ),
    );
  }
}

class TeacherRegisterRow extends StatefulWidget {
  const TeacherRegisterRow(
      {required this.teacherIndex,
      required this.name,
      required this.phoneNum,
      required this.id,
      required this.approvedBtn,
      Key? key})
      : super(key: key);
  final teacherIndex;
  final name;
  final phoneNum;
  final id;
  final Function(bool, int) approvedBtn;

  @override
  State<TeacherRegisterRow> createState() => _TeacherRegisterRow();
}

class _TeacherRegisterRow extends State<TeacherRegisterRow> {
  Color bordercolor = const Color(0xFFFBB348);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 862.w,
      height: 40.w,
      child: Row(
        children: [
          ///이름
          Container(
            width: 150.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border(right: BorderSide(width: 1,color: bordercolor),
                bottom: BorderSide(width: 1,color: bordercolor),)),
            child: Center(child: AdminTableTextStyle(text : widget.name)),
          ),

          ///아이디
          Container(
            width: 320.w,
            height: 40.w,
            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: bordercolor),
              bottom: BorderSide(width: 1,color: bordercolor),)),
            child: Center(child: AdminTableTextStyle(text : widget.id)),
          ),

          // ///담당반
          // Container(
          //   width: 150.w,
          //   height: 40.w,
          //   decoration: BoxDecoration(
          //       border: Border.all(color: bordercolor, width: 1.w)),
          //   child: Center(child: Text(widget.className)),
          // ),

          ///연락처
          Container(
            width: 200.w,
            height: 40.w,
            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: bordercolor),
              bottom: BorderSide(width: 1,color: bordercolor),)),
            child: Center(child: AdminTableTextStyle(text : widget.phoneNum)),
          ),

          ///허가
          Container(
            width: 100.w,
            height: 40.w,
            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: bordercolor),
              bottom: BorderSide(width: 1,color: bordercolor),)),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  print('허가');
                  widget.approvedBtn(true, widget.teacherIndex);
                },
                child: const AdminTableTextStyle(text : '허가'),
              ),
            ),
          ),

          ///반려
          Container(
            width: 98.w,
            height: 40.w,
            decoration: BoxDecoration(border: Border(
              bottom: BorderSide(width: 1,color: bordercolor),)),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  print('반려');
                  widget.approvedBtn(false, widget.teacherIndex);
                },
                child: const AdminTableTextStyle(text : '반려'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ModifyTeacherDialog extends StatefulWidget {
  const ModifyTeacherDialog({Key? key}) : super(key: key);

  @override
  State<ModifyTeacherDialog> createState() => _ModifyTeacherDialog();
}

class _ModifyTeacherDialog extends State<ModifyTeacherDialog> {
  List<bool> checkList = [];
  List<String> nameList = [];
  List<String> classNameList = [];
  List<String> phoneNumList = [];
  List<int> idList = [];
  List<String> commentList = [];
  bool check = false;

  void checkOnOff(int index, bool checked) {
    setState(() {
      checkList[index] = checked;
      debugPrint('$checked');
      print("checkList(modify): $checkList");
    });
  }

  void changeName(int index, String newValue) {
    setState(() {
      nameList[index] = newValue;
    });
  }

  void changeClassName(int index, String newValue) {
    setState(() {
      classNameList[index] = newValue;
    });
  }

  void changePhoneNum(int index, String newValue) {
    setState(() {
      phoneNumList[index] = newValue;
    });
  }

  void changeId(int index, int newValue) {
    setState(() {
      idList[index] = newValue;
    });
  }

  void changeComment(int index, String newValue) {
    setState(() {
      commentList[index] = newValue;
    });
  }

  @override
  initState() {
    super.initState();
    for (int i = 0; i < teacherNum; i++) {
      checkList.add(false);
      nameList.add(teacherList[i].name);
      classNameList.add(teacherList[i].className);
      phoneNumList.add(teacherList[i].phoneNum);
      idList.add(teacherList[i].id);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
            width: 1000.w,
            height: 550.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w),
                color: const Color(0xFFFCF9F4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0.w, 47.w, 0.w, 0.w),
                  child: Text(
                    '선생님 수정',
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF393838)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 50.w,
                        height: 40.w,
                        margin: EdgeInsets.only(left: 20.w, top: 46.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.w),
                            ),
                            border: Border.all(
                                width: 1, color: const Color(0xffFDB43B)),
                            color: const Color(0xffFED796)),
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
                        )
                    ),
                    Container(
                      width: 121.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text : '이름')),
                    ),
                    Container(
                      width: 140.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text : '담당반')),
                    ),
                    Container(
                      width: 160.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text : '연락처')),
                    ),
                    Container(
                      width: 240.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text : '아이디')),
                    ),
                    Container(
                      width: 201.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.w),
                          ),
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text : '코멘트')),
                    ),
                  ],
                ),
                SingleChildScrollView(
                    child: Container(
                  width: 912.w,
                  height: 235.w,
                  margin: EdgeInsets.only(left: 20.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // borderRadius: const BorderRadius.only(
                      //     bottomLeft: Radius.circular(10),
                      //     bottomRight: Radius.circular(10)),
                      border: Border.all(
                          color: const Color(0xFFFBB348), width: 1.w)),
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: ListView(
                            padding: EdgeInsets.zero,
                            physics: const RangeMaintainingScrollPhysics(),
                        children: [
                      for (int i = 0; i < teacherNum; i++) ...[
                        ModifyTeacherListRow(
                          checkFunction: checkOnOff,
                          checkValue: checkList[i],
                          teacherIndex: i,
                          name: nameList[i],
                          modifiedNameFunc: changeName,
                          className: classNameList[i],
                          modifiedClassNameFunc: changeClassName,
                          phoneNum: phoneNumList[i],
                          modifiedPhoneNumFunc: changePhoneNum,
                          id: idList[i],
                          modifiedIdFunc: changeId,
                          comment: commentList[i],
                          modifiedCommentFunc: changeComment,
                        )
                      ]
                    ]),
                  ),
                )),
                SizedBox(height: 42.w),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context); //result 반영 dialog 종료
                      },
                      child: Text('저장',
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.w400)),
                      style: ElevatedButton.styleFrom(
                          elevation: 1.0,
                          primary: const Color(0xFFFFFFFF),
                          onPrimary: const Color(0xFF393838),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w)),
                          side: const BorderSide(color: Color(0xFFA666FB)),
                          fixedSize: Size(150.w, 50.w)),
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint('취소');
                        Navigator.pop(context); //result 반영 dialog 종료
                      },
                      child: Text('취소',
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.w400)),
                      style: ElevatedButton.styleFrom(
                          elevation: 1.0,
                          primary: const Color(0xFFFFFFFF),
                          onPrimary: const Color(0xFF393838),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w)),
                          side: const BorderSide(color: Color(0xFFA666FB)),
                          fixedSize: Size(150.w, 50.w)),
                    ),
                  )
                ])
              ],
            )),
      ),
    );
  }
}


///
class ModifyTeacherListRow extends StatefulWidget {
  const ModifyTeacherListRow(
      {required this.checkFunction,
      required this.checkValue,
      required this.teacherIndex,
      required this.name,
      required this.modifiedNameFunc,
      required this.className,
      required this.modifiedClassNameFunc,
      required this.phoneNum,
      required this.modifiedPhoneNumFunc,
      required this.id,
      required this.modifiedIdFunc,
      required this.comment,
      required this.modifiedCommentFunc,
      Key? key})
      : super(key: key);
  final Function(int, bool) checkFunction;
  final bool checkValue;
  final teacherIndex;
  final name;
  final Function(int, String) modifiedNameFunc;
  final className;
  final Function(int, String) modifiedClassNameFunc;
  final phoneNum;
  final Function(int, String) modifiedPhoneNumFunc;
  final id;
  final Function(int, int) modifiedIdFunc;
  final comment;
  final Function(int, String) modifiedCommentFunc;

  @override
  State<ModifyTeacherListRow> createState() => _ModifyTeacherListRowState();
}

class _ModifyTeacherListRowState extends State<ModifyTeacherListRow> {
  Color bordercolor = const Color(0xFFFBB348);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.checkFunction(widget.teacherIndex, !widget.checkValue);
        });
      },
      child: SizedBox(
        width: 862.w,
        height: 40.w,
        child: Row(
          children: [
            SizedBox(
              width: 49.w,
              height: 50.w,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: const Color(0xffFDB43B)),
                ),
                child: Checkbox(
                    value: widget.checkValue,
                    onChanged: (value) {
                      setState(() {
                        widget.checkFunction(widget.teacherIndex, value!);
                      });
                    }),
              ),
            ),
            ///이름
            Container(
              width: 121.w,
              height: 40.w,
              decoration: BoxDecoration(
                  border: Border.all(color: bordercolor, width: 1.w),),
              child: ModifyTeacherTextField(widget.name, (newValue) {
                setState(() {
                  widget.modifiedNameFunc(widget.teacherIndex, newValue);
                });
              }, widget.checkValue),
            ),

            ///담당반
            Container(
              width: 140.w,
              height: 40.w,
              decoration: BoxDecoration(
                  border: Border.all(color: bordercolor, width: 1.w)),
              child:ModifyTeacherTextField(widget.className, (newValue) {
                setState(() {
                  widget.modifiedNameFunc(widget.teacherIndex, newValue);
                });
              }, widget.checkValue),
            ),

            ///연락처
            Container(
              width: 160.w,
              height: 40.w,
              decoration: BoxDecoration(border: Border.all(color: bordercolor)),
              child: ModifyTeacherTextField(widget.phoneNum, (newValue) {
                setState(() {
                  widget.modifiedNameFunc(widget.teacherIndex, newValue);
                });
              }, widget.checkValue),
            ),

            ///아이디
            Container(
              width: 240.w,
              height: 40.w,
              decoration: BoxDecoration(border: Border.all(color: bordercolor)),
              child: ModifyTeacherTextField(widget.id, (newValue) {
                setState(() {
                  widget.modifiedNameFunc(widget.teacherIndex, newValue);
                });
              }, widget.checkValue),
            ),

            ///코멘트
            Container(
              width: 200.w,
              height: 40.w,
              decoration: BoxDecoration(border: Border.all(color: bordercolor)),
              child: Center(
                child: ModifyTeacherTextField(widget.comment, (newValue) {
                  setState(() {
                    widget.modifiedNameFunc(widget.teacherIndex, newValue);
                  });
                }, widget.checkValue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModifyTeacherTextField extends StatelessWidget {
  final bool onCheck;
  final String text;
  final FormFieldSetter _onSaved;

  const ModifyTeacherTextField(this.text, this._onSaved, this.onCheck,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            height: 38.w,
            child: onCheck == true
                ? TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: _onSaved,
                  onChanged: _onSaved,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffB2B2B2),
                    ),
                    hintText: text,
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 0.w, horizontal: 16.w),
                    enabledBorder: const OutlineInputBorder(
                      //borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.white, //textfield unfocused 테두리
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.w),
                      borderSide: const BorderSide(
                        color: Colors.blue, //textfield focused 테두리
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.w),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.w),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white, //textfield 내부
                  ),
                )

                : Center(
                  child: Text(text,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xffB2B2B2),
                    ),
                  ),
                ))
      ],
    );
  }
}

class DismissTeacherDialog extends StatefulWidget {
  const DismissTeacherDialog({Key? key,
    required this.reloadTInfo,
  }) : super(key: key);
  final Function reloadTInfo;

  @override
  State<DismissTeacherDialog> createState() => _DismissTeacherDialogState();
}

class _DismissTeacherDialogState extends State<DismissTeacherDialog> {
  List<bool> checkList = [];
  List<Color> colorList = [];

  void checkOnOff(int index, bool checked) {
    setState(() {
      checkList[index] = checked;
      debugPrint('$checked');
      print("checkList(dismiss): $checkList");
      if(checked == true ) {
        colorList[index] = Colors.lightGreenAccent;
      } else {
        colorList[index] = Colors.transparent;
      }
    });
  }
  @override
  initState() {
    super.initState();
    for (int i = 0; i < Provider.of<TeacherDataManagement>(context, listen: false)
        .teacherList.length; i++) {
      checkList.add(false);
      colorList.add(Colors.transparent);
    }
  }
  putDeleteTeacher(List<int> index) async {
    ApiUrl apiUrl = ApiUrl();
    DeleteTeacher deleteTeacher = DeleteTeacher(deleteList:index);
    http.Response res = await api(apiUrl.teacher, 'put', 'adminToken', deleteTeacher, context);
    if(res.statusCode == 200){
      widget.reloadTInfo();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
            width: 1000.w,
            height: 550.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w),
                color: const Color(0xFFFCF9F4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0.w, 47.w, 0.w, 0.w),
                  child: Text(
                    '선생님 등록 해제',
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF393838)),
                  ),
                ),
                SizedBox(
                  height: 46.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    CustomContainer(
                      cTotalWidth: 121.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cBorderRadius: BorderRadius.only(topLeft: Radius.circular(10.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget:
                      const Center(child: AdminTableTextStyle(text : '이름')),
                    ),
                    // Container(
                    //   width: 121.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(left: 20.w, top: 46.w),
                    //   decoration: BoxDecoration(
                    //       borderRadius: const BorderRadius.only(
                    //         topLeft: Radius.circular(10),
                    //       ),
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: AdminTableTextStyle(text : '이름')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 140.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget:
                      const Center(child: AdminTableTextStyle(text : '담당반')),
                    ),
                    // Container(
                    //   width: 140.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: AdminTableTextStyle(text : '담당반')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 160.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget:
                      const Center(child: AdminTableTextStyle(text : '연락처')),
                    ),
                    // Container(
                    //   width: 160.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: AdminTableTextStyle(text : '연락처')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 240.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget:
                      const Center(child: AdminTableTextStyle(text : '아이디')),
                    ),
                    // Container(
                    //   width: 240.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: AdminTableTextStyle(text : '아이디')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 201.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cBorderRadius: BorderRadius.only(topRight: Radius.circular(10.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget:
                      const Center(child: AdminTableTextStyle(text : '코멘트')),
                    ),
                    // Container(
                    //   width: 201.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       borderRadius: const BorderRadius.only(
                    //         topRight: Radius.circular(10),
                    //       ),
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: AdminTableTextStyle(text : '코멘트')),
                    // ),
                  ],
                ),
                SingleChildScrollView(
                    child: Container(
                      width: 862.w,
                      height: 235.w,
                      margin: EdgeInsets.only(left: 20.w),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // borderRadius: const BorderRadius.only(
                          //     bottomLeft: Radius.circular(10),
                          //     bottomRight: Radius.circular(10)),
                          border: Border.all(
                              color: const Color(0xFFFBB348), width: 1.w)),
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: ListView(
                            padding: EdgeInsets.zero,
                            physics: const RangeMaintainingScrollPhysics(),
                            children: [
                          for (int i = 0; i < Provider.of<TeacherDataManagement>(context, listen: false)
                              .teacherList.length; i++) ...[
                            DismissTeacherListRow(
                              checkFunction: checkOnOff,
                              checkValue: checkList[i],
                              colorValue: colorList[i],
                              teacherIndex: i,
                              name: Provider.of<TeacherDataManagement>(context, listen: false)
                                  .teacherList[i].name,
                              className: Provider.of<TeacherDataManagement>(context, listen: false)
                                  .teacherList[i].className,
                              phoneNum: Provider.of<TeacherDataManagement>(context, listen: false)
                                  .teacherList[i].phoneNum,
                              id: Provider.of<TeacherDataManagement>(context, listen: false)
                                  .teacherList[i].email,

                            )
                          ]
                        ]),
                      ),
                    )
                ),
                SizedBox(height: 42.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('삭제');
                      setState(() {
                        List<int> classIds = [];
                        for (int i = 0; i < checkList.length; i++) {
                          if (checkList[i] == true) {
                            classIds.add( Provider.of<TeacherDataManagement>(context, listen: false)
                                .teacherList[i].id);
                          }
                        }
                        putDeleteTeacher(classIds);
                        
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('삭제',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                    style: ElevatedButton.styleFrom(
                        elevation: 1.0,
                        primary: const Color(0xFFFFFFFF),
                        onPrimary: const Color(0xFF393838),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w)),
                        side: const BorderSide(color: Color(0xFFA666FB)),
                        fixedSize: const Size(150, 50)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 50.w),
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint('취소');
                        Navigator.pop(context); //result 반영 dialog 종료
                      },
                      child: Text('취소',
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.w400)),
                      style: ElevatedButton.styleFrom(
                          elevation: 1.0,
                          primary: const Color(0xFFFFFFFF),
                          onPrimary: const Color(0xFF393838),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w)),
                          side: const BorderSide(color: Color(0xFFA666FB)),
                          fixedSize: Size(150.w, 50.w)),
                    ),
                  )
                ])
              ],
            )),
      ),
    );
  }
}

class DismissTeacherListRow extends StatefulWidget {
  const DismissTeacherListRow({
  required this.checkFunction,
    required this.checkValue,
    required this.colorValue,
    required this.teacherIndex,
    required this.name,
    required this.className,
    required this.phoneNum,
    required this.id,

    Key? key})
      : super(key: key);
  final Function(int, bool) checkFunction;
  final bool checkValue;
  final Color colorValue;
  final teacherIndex;
  final name;
  final className;
  final phoneNum;
  final id;


  @override
  State<DismissTeacherListRow> createState() => _DismissTeacherListRowState();
}

class _DismissTeacherListRowState extends State<DismissTeacherListRow> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.checkFunction(widget.teacherIndex, !widget.checkValue);
        });
      },
      child: SizedBox(
        width: 862.w,
        height: 40.w,
        child: Row(
          children: [
            ///이름
            Container(
              width: 121.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: widget.colorValue,
                  border: Border(right: BorderSide(color: const Color(0xFFFBB348), width: 1.w),
                  bottom: BorderSide(color: const Color(0xFFFBB348), width: 1.w))),
              child: Center(child: AdminTableTextStyle(text : widget.name)),
            ),

            ///담당반
            Container(
              width: 140.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: widget.colorValue,
                  border: Border(right: BorderSide(color: const Color(0xFFFBB348), width: 1.w),
                      bottom: BorderSide(color: const Color(0xFFFBB348), width: 1.w))),
              child: Center(child: AdminTableTextStyle(text : widget.className)),
            ),

            ///연락처
            Container(
              width: 160.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: widget.colorValue,
                  border: Border(right: BorderSide(color: const Color(0xFFFBB348), width: 1.w),
                      bottom: BorderSide(color: const Color(0xFFFBB348), width: 1.w))
              ),
              child: Center(child: AdminTableTextStyle(text : widget.phoneNum)),
            ),

            ///아이디
            Container(
              width: 240.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: widget.colorValue,
                  border: Border(right: BorderSide(color: const Color(0xFFFBB348), width: 1.w),
                      bottom: BorderSide(color: const Color(0xFFFBB348), width: 1.w))
              ),
              child: Center(child: AdminTableTextStyle(text : widget.id)),
            ),

            ///코멘트
            Container(
              width: 199.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: widget.colorValue,
                  border: Border(
                      bottom: BorderSide(color: const Color(0xFFFBB348), width: 1.w))
              ),
              // child: Center(
              //   child: Text(widget.comment),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

