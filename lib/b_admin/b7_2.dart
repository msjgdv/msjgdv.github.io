import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:treasure_map/provider/teacher_data_management.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treasure_map/widgets/calendar.dart';
import '../admin.dart';
import '../api/admin.dart';
import '../provider/app_management.dart';
import '../provider/child_data_management.dart';
import '../provider/class_data_management.dart';
import '../widgets/api.dart';
import '../widgets/custom_container.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;

class B7_2 extends StatefulWidget {
  const B7_2({
    Key? key,
    required this.notifyParent,
    required this.schoolYearSetting,
    required this.schoolYear,
  }) : super(key: key);
  final Function(double, double)? notifyParent;
  final int schoolYear;
  final Function(int) schoolYearSetting;

  @override
  State<B7_2> createState() => _B7_2State();
}

class _B7_2State extends State<B7_2> {
  int nowYear = DateTime.now().year;
  ApiUrl apiUrl = ApiUrl();
  int sort = 0;
  List<bool> reverse = [false, false, false];

  @override
  void initState() {
    getChildInfo();
    getClassInfo();
    // TODO: implement initState
    super.initState();
  }

  getChildInfo() async {
    var formatter = DateFormat('yyyyMMdd');
    String toDayStr = formatter.format(DateTime.now());
    http.Response childRes = await api(
        '${apiUrl.child}/$toDayStr?cid=${Provider.of<UserInfo>(context, listen: false).value[0]}',
        'get',
        'signInToken',
        {},
        context);
    if (childRes.statusCode == 200) {
      var childRB = utf8.decode(childRes.bodyBytes);
      var childData = jsonDecode(childRB);
      Provider.of<ChildDataManagement>(context, listen: false)
          .childList
          .clear();
      for (int i = 0; i < childData.length; i++) {
        Provider.of<ChildDataManagement>(context, listen: false)
            .childList
            .add(Child(
              identification: childData[i]['id'],
              name: childData[i]['name'],
              sex: childData[i]['sex'],
              childFaceUrl: childData[i]['imagePath'],
              childFace: await imageApi(
                  childData[i]['imagePath'], 'adminToken', context),
              comment: childData[i]['comment'],
              birthday: childData[i]['birthday'],
              className: childData[i]['className'],
              relation: childData[i]['relation'],
              phoneNumber: childData[i]['parentPhoneNumber'],
              parentName: childData[i]['parentName'],
            ));
        setState(() {});
      }
    }
  }

  getClassInfo() async {
    http.Response classRes = await api(
        '${apiUrl.getClass}/${widget.schoolYear}',
        'get',
        'signInToken',
        {},
        context);
    if (classRes.statusCode == 200) {
      var classRB = utf8.decode(classRes.bodyBytes);
      var classData = jsonDecode(classRB);
      setState(() {
        Provider.of<ClassDataManagement>(context, listen: false)
            .classList
            .clear();
        for (int i = 0; i < classData.length; i++) {
          Provider.of<ClassDataManagement>(context, listen: false)
              .classList
              .add(Class(
                  className: classData[i]['name'],
                  classTeacher: classData[i]['teacher'],
                  classChildAge: classData[i]['age'],
                  classComment: classData[i]['comment'] ?? "",
                  classId: classData[i]['id'],
                  classCount: classData[i]['count'],
                  classTId: classData[i]['tid']));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          SizedBox(width: 45.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 900.w,
                margin: EdgeInsets.only(top: 44.01.w),
                child: Row(
                  children: [
                    SizedBox(
                        height: 32.w,
                        child: Text('영유아 목록',
                            style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF393838)))),
                    Spacer(),
                    SchoolYearSettingWidget(
                        schoolYear: widget.schoolYear,
                        schoolYearSetting: widget.schoolYearSetting,
                        getFunction: () => {getChildInfo(), getClassInfo()}),
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
                            cTotalWidth: 40.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cBorderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.w)),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget: const Center(
                                child: ChildSettingTextStyle(text: '사진')),
                          ),
                          // Container(
                          //   width: 40.w,
                          //   height: 40.w,
                          //   margin: EdgeInsets.only(top: 46.w),
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.only(
                          //         topLeft: Radius.circular(10.w),
                          //       ),
                          //       border: Border.all(
                          //           width: 1.w, color: const Color(0xffFDB43B)),
                          //       color: const Color(0xffFED796)),
                          //   child: const Center(child: ChildSettingTextStyle(text: '사진',)),
                          // ),
                          GestureDetector(
                            onTap: () {
                              if (reverse[0]) {
                                setState(() {
                                  Provider.of<ChildDataManagement>(context,
                                          listen: false)
                                      .childList
                                      .sort((a, b) => a.name.compareTo(b.name));

                                  reverse[0] = !reverse[0];
                                  sort = 1;
                                });
                              } else {
                                setState(() {
                                  Provider.of<ChildDataManagement>(context,
                                          listen: false)
                                      .childList
                                      .sort((a, b) => b.name.compareTo(a.name));

                                  reverse[0] = !reverse[0];
                                  sort = 1;
                                });
                              }
                            },
                            child: CustomContainer(
                              cTotalWidth: 100.w,
                              cTotalHeight: 40.w,
                              cInsideColor: const Color(0xffFED796),
                              cBorderColor: const Color(0xffFDB43B),
                              cTopBorderWidth: 1.w,
                              cLeftBorderWidth: 1.w,
                              childWidget: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Center(
                                      child: ChildSettingTextStyle(text: '이름')),
                                  if (sort == 1) ...[
                                    if (reverse[0]) ...[
                                      Icon(Icons.arrow_drop_up)
                                    ] else ...[
                                      Icon(Icons.arrow_drop_down)
                                    ]
                                  ] else ...[
                                    Container(
                                      width: 24.w,
                                      height: 40.w,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 5.w,
                                            child: Icon(
                                              Icons.arrow_drop_up,
                                              opticalSize: 10.w,
                                            ),
                                          ),
                                          Positioned(
                                            top: 12.w,
                                            child: Icon(
                                              Icons.arrow_drop_down,
                                              opticalSize: 10.w,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ]
                                ],
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 100.w,
                          //   height: 40.w,
                          //   margin: EdgeInsets.only(top: 46.w),
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //           width: 1, color: const Color(0xffFDB43B)),
                          //       color: const Color(0xffFED796)),
                          //   child: const Center(child: ChildSettingTextStyle(text: '이름')),
                          // ),
                          GestureDetector(
                            onTap: () {
                              if (reverse[1]) {
                                setState(() {
                                  Provider.of<ChildDataManagement>(context,
                                      listen: false)
                                      .childList
                                      .sort((a, b) => a.birthday.compareTo(b.birthday));

                                  reverse[1] = !reverse[1];
                                  sort = 2;
                                });
                              } else {
                                setState(() {
                                  Provider.of<ChildDataManagement>(context,
                                      listen: false)
                                      .childList
                                      .sort((a, b) => b.birthday.compareTo(a.birthday));

                                  reverse[1] = !reverse[1];
                                  sort = 2;
                                });
                              }
                            },
                            child: CustomContainer(
                              cTotalWidth: 130.w,
                              cTotalHeight: 40.w,
                              cInsideColor: const Color(0xffFED796),
                              cBorderColor: const Color(0xffFDB43B),
                              cTopBorderWidth: 1.w,
                              cLeftBorderWidth: 1.w,
                              childWidget: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Center(
                                      child: ChildSettingTextStyle(text: '생년월일')),
                                  if (sort == 2) ...[
                                    if (reverse[1]) ...[
                                      Icon(Icons.arrow_drop_up)
                                    ] else ...[
                                      Icon(Icons.arrow_drop_down)
                                    ]
                                  ] else ...[
                                    Container(
                                      width: 24.w,
                                      height: 40.w,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 5.w,
                                            child: Icon(
                                              Icons.arrow_drop_up,
                                              opticalSize: 10.w,
                                            ),
                                          ),
                                          Positioned(
                                            top: 12.w,
                                            child: Icon(
                                              Icons.arrow_drop_down,
                                              opticalSize: 10.w,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ]
                                ],
                              ),
                            ),
                          ),
                          // Container(
                          //   width: 130.w,
                          //   height: 40.w,
                          //   margin: EdgeInsets.only(top: 46.w),
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //           width: 1, color: const Color(0xffFDB43B)),
                          //       color: const Color(0xffFED796)),
                          //   child: const Center(child: ChildSettingTextStyle(text: '생년월일')),
                          // ),
                          CustomContainer(
                            cTotalWidth: 130.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget: const Center(
                                child: ChildSettingTextStyle(text: '소속반')),
                          ),
                          // Container(
                          //   width: 130.w,
                          //   height: 40.w,
                          //   margin: EdgeInsets.only(top: 46.w),
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //           width: 1, color: const Color(0xffFDB43B)),
                          //       color: const Color(0xffFED796)),
                          //   child: const Center(child: ChildSettingTextStyle(text: '소속반')),
                          // ),
                          CustomContainer(
                            cTotalWidth: 170.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget: const Center(
                                child: ChildSettingTextStyle(text: '코멘트')),
                          ),
                          // Container(
                          //   width: 170.w,
                          //   height: 40.w,
                          //   margin: EdgeInsets.only(top: 46.w),
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //           width: 1, color: const Color(0xffFDB43B)),
                          //       color: const Color(0xffFED796)),
                          //   child: const Center(child: ChildSettingTextStyle(text: '코멘트')),
                          // ),
                          CustomContainer(
                            cTotalWidth: 100.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget: const Center(
                                child: ChildSettingTextStyle(text: '학부모이름')),
                          ),
                          // Container(
                          //   width: 100.w,
                          //   height: 40.w,
                          //   margin: EdgeInsets.only(top: 46.w),
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //           width: 1, color: const Color(0xffFDB43B)),
                          //       color: const Color(0xffFED796)),
                          //   child: const Center(child: ChildSettingTextStyle(text: '학부모이름')),
                          // ),
                          CustomContainer(
                            cTotalWidth: 160.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget: const Center(
                                child: ChildSettingTextStyle(text: '학부모 전화번호')),
                          ),
                          // Container(
                          //   width: 160.w,
                          //   height: 40.w,
                          //   margin: EdgeInsets.only(top: 46.w),
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //           width: 1, color: const Color(0xffFDB43B)),
                          //       color: const Color(0xffFED796)),
                          //   child: const Center(child: ChildSettingTextStyle(text: '학부모 전화번호')),
                          // ),
                          CustomContainer(
                            cTotalWidth: 70.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cBorderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.w)),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            childWidget: const Center(
                                child: ChildSettingTextStyle(text: '관계')),
                          ),
                          // Container(
                          //   width: 70.w,
                          //   height: 40.w,
                          //   margin: EdgeInsets.only(top: 46.w),
                          //   decoration: BoxDecoration(
                          //       borderRadius: const BorderRadius.only(
                          //         topRight: Radius.circular(10),
                          //       ),
                          //       border: Border.all(
                          //           width: 1, color: const Color(0xffFDB43B)),
                          //       color: const Color(0xffFED796)),
                          //   child: const Center(child: ChildSettingTextStyle(text: '관계')),
                          // ),
                        ],
                      ),
                      Container(
                          width: 900.w,
                          height: 364.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xFFFBB348), width: 1.w)),
                          child: ScrollConfiguration(
                            behavior: const ScrollBehavior()
                                .copyWith(overscroll: false),
                            child: ListView(
                                padding: EdgeInsets.zero,
                                physics: const RangeMaintainingScrollPhysics(),
                                children: [
                                  for (int i = 0;
                                      i <
                                          Provider.of<ChildDataManagement>(
                                                  context,
                                                  listen: false)
                                              .childList
                                              .length;
                                      i++) ...[
                                    ChildListRow(
                                      relation:
                                          Provider.of<ChildDataManagement>(
                                                  context,
                                                  listen: false)
                                              .childList[i]
                                              .relation,
                                      birthday:
                                          Provider.of<ChildDataManagement>(
                                                  context,
                                                  listen: false)
                                              .childList[i]
                                              .birthday,
                                      childFace:
                                          Provider.of<ChildDataManagement>(
                                                  context,
                                                  listen: false)
                                              .childList[i]
                                              .childFace,
                                      className:
                                          Provider.of<ChildDataManagement>(
                                                  context,
                                                  listen: false)
                                              .childList[i]
                                              .className,
                                      phoneNumber:
                                          Provider.of<ChildDataManagement>(
                                                  context,
                                                  listen: false)
                                              .childList[i]
                                              .phoneNumber,
                                      parentName:
                                          Provider.of<ChildDataManagement>(
                                                  context,
                                                  listen: false)
                                              .childList[i]
                                              .parentName,
                                      comment: Provider.of<ChildDataManagement>(
                                              context,
                                              listen: false)
                                          .childList[i]
                                          .comment,
                                      name: Provider.of<ChildDataManagement>(
                                              context,
                                              listen: false)
                                          .childList[i]
                                          .name,
                                    )
                                  ]
                                ]),
                          )),
                      SizedBox(height: 21.w),
                      //
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
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return MakeChild(
                                          reLoadCInfo: getChildInfo,
                                        );
                                      });
                                },
                                child: Text('영유아 등록',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.sp)),
                                style: ElevatedButton.styleFrom(
                                    elevation: 1.0,
                                    primary: const Color(0xFFA666FB),
                                    onPrimary: const Color(0xFFFFFFFF),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.w)),
                                    fixedSize: Size(200.w, 50.w)),
                              ),
                            ),
                            Container(
                              width: 260.w,
                              height: 50.w,
                              margin: EdgeInsets.only(
                                left: 40.w,
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await showDialog(
                                      barrierColor: Colors.transparent,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ModifyChildDialog(
                                          reLoadCInfo: getChildInfo,
                                        );
                                      });
                                },
                                child: Text('영유아 정보 수정',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.sp)),
                                style: ElevatedButton.styleFrom(
                                    elevation: 1.0,
                                    primary: const Color(0xFFA666FB),
                                    onPrimary: const Color(0xFFFFFFFF),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.w)),
                                    fixedSize: Size(200.w, 50.w)),
                              ),
                            ),
                            Container(
                              width: 260.w,
                              height: 50.w,
                              margin: EdgeInsets.only(
                                left: 40.w,
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await showDialog(
                                      barrierColor: Colors.transparent,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DismissChildDialog(
                                          reloadTInfo: getChildInfo,
                                        );
                                      });
                                },
                                child: Text('영유아 등록 해제',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.sp)),
                                style: ElevatedButton.styleFrom(
                                    elevation: 1.0,
                                    primary: const Color(0xFFA666FB),
                                    onPrimary: const Color(0xFFFFFFFF),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.w)),
                                    fixedSize: Size(200.w, 50.w)),
                              ),
                            )
                          ]),
                      // SizedBox(height: 50.w)
                    ]),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ChildListRow extends StatefulWidget {
  const ChildListRow({
    Key? key,
    required this.birthday,
    required this.comment,
    required this.className,
    required this.relation,
    required this.phoneNumber,
    required this.parentName,
    required this.name,
    required this.childFace,
  }) : super(key: key);
  final Image childFace;
  final String name;
  final String birthday;
  final String className;
  final String comment;
  final String parentName;
  final String phoneNumber;
  final String relation;

  @override
  State<ChildListRow> createState() => _ChildListRowState();
}

class _ChildListRowState extends State<ChildListRow> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 862.w,
      height: 52.w,
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 52.w,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Color(0xFFFBB348), width: 1.w),
                    bottom: BorderSide(color: Color(0xFFFBB348), width: 1.w))),
            child: Center(
              child: widget.childFace,
              //   Image.file(
              // widget.childFace,
              // fit: BoxFit.cover,

              // )
            ),
          ),
          Container(
            width: 100.w,
            height: 52.w,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Color(0xFFFBB348), width: 1.w),
                    bottom: BorderSide(color: Color(0xFFFBB348), width: 1.w))),
            child: Center(child: ChildSettingTextStyle(text: widget.name)),
          ),
          Container(
            width: 130.w,
            height: 52.w,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Color(0xFFFBB348), width: 1.w),
                    bottom: BorderSide(color: Color(0xFFFBB348), width: 1.w))),
            child: Center(child: ChildSettingTextStyle(text: widget.birthday)),
          ),
          Container(
            width: 130.w,
            height: 52.w,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Color(0xFFFBB348), width: 1.w),
                    bottom: BorderSide(color: Color(0xFFFBB348), width: 1.w))),
            child: Center(child: ChildSettingTextStyle(text: widget.className)),
          ),
          Container(
            width: 170.w,
            height: 52.w,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Color(0xFFFBB348), width: 1.w),
                    bottom: BorderSide(color: Color(0xFFFBB348), width: 1.w))),
            child: Center(
              child: ChildSettingTextStyle(text: widget.comment),
            ),
          ),
          Container(
            width: 100.w,
            height: 52.w,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Color(0xFFFBB348), width: 1.w),
                    bottom: BorderSide(color: Color(0xFFFBB348), width: 1.w))),
            child: Center(
              child: ChildSettingTextStyle(text: widget.parentName),
            ),
          ),
          Container(
            width: 160.w,
            height: 52.w,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Color(0xFFFBB348), width: 1.w),
                    bottom: BorderSide(color: Color(0xFFFBB348), width: 1.w))),
            child: Center(
              child: ChildSettingTextStyle(text: widget.phoneNumber),
            ),
          ),
          Container(
            width: 68.w,
            height: 52.w,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xFFFBB348), width: 1.w))),
            child: Center(
              child: ChildSettingTextStyle(text: widget.relation),
            ),
          ),
        ],
      ),
    );
  }
}

class MakeChild extends StatefulWidget {
  const MakeChild({
    Key? key,
    required this.reLoadCInfo,
  }) : super(key: key);

  final Function reLoadCInfo;

  @override
  State<MakeChild> createState() => _MakeChildState();
}

class _MakeChildState extends State<MakeChild> {
  int makeChildNum = 0;
  List<Map<String, dynamic>> createChildInfo = [];
  List<dynamic> createPictureInfo = [];
  File? file;
  late FormData formData;

  List<int> id = [];
  List<String> name = [];
  List<String> birthday = [];
  List<bool> sex = [];
  List<String> imageName = [];
  List<String> comment = [];
  List<File?> imageFiles = [];
  List<String> phoneNumber = [];
  List<String> parentName = [];
  List<String> relation = [];

  List<MultipartFile> multi = [];

  createChild(
    List<int> id,
    List<String> name,
    List<String> birthday,
    List<bool> sex,
    List<String> imageName,
    List<String> comment,
    List<String> phoneNumber,
    List<String> parentName,
    List<String> relation,
    List<File?> imageFiles,
  ) async {
    ApiUrl apiUrl = ApiUrl();
    for (int i = 0; i < id.length; i++) {
      if (imageFiles[i] != null) {
        imageName[i] = imageFiles[i]!.path.split('/').last;
        multi.add(await MultipartFile.fromFile(imageFiles[i]!.path,
            filename: imageName[i]));
      } else {}

      createChildInfo.add({
        "id": id[i],
        "name": name[i],
        "birthday": birthday[i],
        "sex": sex[i],
        "imageName": imageName[i],
        "comment": comment[i],
        "parentName": parentName[i],
        "parentPhoneNumber": phoneNumber[i],
        "relation": relation[i],
      });
      formData = FormData.fromMap(
          {"imageFiles": multi, "createList": createChildInfo});
    }
    imagesPostApi(apiUrl.child, 'adminToken', formData, 'post', context, widget.reLoadCInfo);
  }

  setNewChildName(int index, String newValue) {
    setState(() {
      name[index] = newValue;
    });
  }

  setNewChildId(int index, int newValue) {
    setState(() {
      id[index] = newValue;
    });
  }

  setNewChildBirthday(int index, String newValue) {
    setState(() {
      birthday[index] = newValue;
    });
  }

  setNewChildSex(int index, bool newValue) {
    setState(() {
      sex[index] = newValue;
    });
  }

  setNewChildImageName(int index, String newValue) {
    setState(() {
      imageName[index] = newValue;
    });
  }

  setNewChildComment(int index, String newValue) {
    setState(() {
      comment[index] = newValue;
    });
  }

  setNewChildImageFiles(int index, File newValue) {
    setState(() {
      imageFiles[index] = newValue;
    });
  }

  setNewChildParentPhoneNumber(int index, String newValue) {
    setState(() {
      phoneNumber[index] = newValue;
    });
  }

  setNewChildParentName(int index, String newValue) {
    setState(() {
      parentName[index] = newValue;
    });
  }

  setNewChildParentRelation(int index, String newValue) {
    setState(() {
      relation[index] = newValue;
    });
  }

  setNewRow() {
    setState(() {
      id.add(0);
      name.add('');
      birthday.add('');
      sex.add(true);
      imageName.add("");
      comment.add("");
      imageFiles.add(file);
      phoneNumber.add('');
      parentName.add('');
      relation.add('');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                    '영유아 등록',
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF393838)),
                  ),
                ),
                SizedBox(
                  height: 47.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomContainer(
                      cTotalWidth: 100.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cBorderRadius:
                          BorderRadius.only(topLeft: Radius.circular(10.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: const Center(
                          child: ChildSettingTextStyle(text: '사진')),
                    ),
                    // Container(
                    //   width: 100.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(left: 0.w, top: 46.w),
                    //   decoration: BoxDecoration(
                    //       borderRadius: const BorderRadius.only(
                    //         topLeft: Radius.circular(10),
                    //       ),
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: ChildSettingTextStyle(text: '사진')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 120.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: const Center(
                          child: ChildSettingTextStyle(text: '이름')),
                    ),
                    // Container(
                    //   width: 120.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: ChildSettingTextStyle(text: '이름')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 160.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: const Center(
                          child: ChildSettingTextStyle(text: '소속반')),
                    ),
                    // Container(
                    //   width: 160.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: ChildSettingTextStyle(text: '소속반')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 150.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: const Center(
                          child: ChildSettingTextStyle(text: '생년월일')),
                    ),
                    // Container(
                    //   width: 150.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: ChildSettingTextStyle(text: '생년월일')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 80.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: const Center(
                          child: ChildSettingTextStyle(text: '성별')),
                    ),
                    // Container(
                    //   width: 80.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: ChildSettingTextStyle(text: '성별')),
                    // ),
                    // Container(
                    //   width: 200.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: Text('보호자아이디')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 120.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: const Center(
                          child: ChildSettingTextStyle(text: '학부모이름')),
                    ),
                    // Container(
                    //   width: 120.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: ChildSettingTextStyle(text: '학부모이름')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 150.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: const Center(
                          child: ChildSettingTextStyle(text: '제 1보호자 연락처')),
                    ),
                    // Container(
                    //   width: 150.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: ChildSettingTextStyle(text: '제 1보호자 연락처')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 80.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cBorderRadius:
                          BorderRadius.only(topRight: Radius.circular(10.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget: const Center(
                          child: ChildSettingTextStyle(text: '관계')),
                    ),
                    // Container(
                    //   width: 80.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       borderRadius: const BorderRadius.only(
                    //         topRight: Radius.circular(10),
                    //       ),
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: ChildSettingTextStyle(text: '관계')),
                    // ),
                  ],
                ),
                SingleChildScrollView(
                    child: Container(
                  width: 960.w,
                  height: 235.w,
                  margin: EdgeInsets.only(left: 0.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // borderRadius: const BorderRadius.only(
                      //     bottomLeft: Radius.circular(10),
                      //     bottomRight: Radius.circular(10)),
                      border: Border.all(
                          color: const Color(0xFFFBB348), width: 1.w)),
                  child: ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const RangeMaintainingScrollPhysics(),
                        children: [
                          for (int i = 0; i < makeChildNum; i++) ...[
                            MakeChildRow(
                              newChildFile: setNewChildImageFiles,
                              newChildBirthday: setNewChildBirthday,
                              newChildComment: setNewChildComment,
                              newChildId: setNewChildId,
                              newChildImageName: setNewChildImageName,
                              newChildName: setNewChildName,
                              newChildSex: setNewChildSex,
                              newChildParentPhoneNumber:
                                  setNewChildParentPhoneNumber,
                              newChildParentName: setNewChildParentName,
                              newChildParentRelation: setNewChildParentRelation,
                              index: i,
                            ),
                          ]
                        ]),
                  ),
                )),
                SizedBox(height: 42.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          makeChildNum++;
                        });
                        setNewRow();
                      },
                      child: Text('추가',
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
                    SizedBox(
                      width: 50.w,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        createChild(
                          id,
                          name,
                          birthday,
                          sex,
                          imageName,
                          comment,
                          phoneNumber,
                          parentName,
                          relation,
                          imageFiles,
                        );
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
                    SizedBox(
                      width: 50.w,
                    ),
                    ElevatedButton(
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
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class MakeChildRow extends StatefulWidget {
  const MakeChildRow({
    Key? key,
    required this.newChildId,
    required this.newChildBirthday,
    required this.newChildComment,
    required this.newChildFile,
    required this.newChildImageName,
    required this.newChildName,
    required this.newChildSex,
    required this.newChildParentPhoneNumber,
    required this.newChildParentName,
    required this.newChildParentRelation,
    required this.index,
  }) : super(key: key);
  final Function(int, int) newChildId;
  final Function(int, String) newChildName;
  final Function(int, String) newChildBirthday;
  final Function(int, bool) newChildSex;
  final Function(int, String) newChildImageName;
  final Function(int, String) newChildComment;
  final Function(int, File) newChildFile;
  final Function(int, String) newChildParentPhoneNumber;
  final Function(int, String) newChildParentName;
  final Function(int, String) newChildParentRelation;
  final int index;

  @override
  State<MakeChildRow> createState() => _MakeChildRowState();
}

class _MakeChildRowState extends State<MakeChildRow> {
  List<String> className = [];
  List<int> number = [];
  List<int> cId = [];
  int now = -1;
  DateTime nowTime = DateTime.now();
  String nowTimeFormat = '';

  bool sex = true;
  String _thatDateStr = '';

  changeDate(DateTime thatDate) {
    var formatter = DateFormat('yyyy-MM-dd');
    _thatDateStr = formatter.format(thatDate);
    widget.newChildBirthday(widget.index, _thatDateStr);
  }

  var img;

  List<DropdownMenuItem<int>> classList() {
    return number
        .map<DropdownMenuItem<int>>(
          (e) => DropdownMenuItem(
            enabled: true,
            alignment: Alignment.centerLeft,
            value: e,
            child: Text(
              className[e],
              style: TextStyle(
                  color: Color(0xff393838),
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp),
            ),
          ),
        )
        .toList();
  }

  @override
  void initState() {
    nowTimeFormat = DateFormat('yyyyMMdd').format(nowTime);
    for (int i = 0;
        i <
            Provider.of<ClassDataManagement>(context, listen: false)
                .classList
                .length;
        i++) {
      number.add(i);
      className.add(Provider.of<ClassDataManagement>(context, listen: false)
          .classList[i]
          .className);
      cId.add(Provider.of<ClassDataManagement>(context, listen: false)
          .classList[i]
          .classId);
    }
    number.add(Provider.of<ClassDataManagement>(context, listen: false)
        .classList
        .length);
    className.add("배정 취소");

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 913.w,
      height: 40.w,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              img = await pickImage(context);
              widget.newChildFile(widget.index, img);
            },
            child: Container(
                width: 100.w,
                height: 40.w,
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(color: Color(0xffFBB348), width: 1.w),
                        bottom:
                            BorderSide(color: Color(0xffFBB348), width: 1.w))),
                child: img == null
                    ? SvgPicture.asset('assets/icons/icon_galery.svg')
                    : Image.file(
                        img,
                        fit: BoxFit.cover,
                      )),
          ),
          Container(
            width: 120.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Color(0xffFBB348), width: 1.w),
                    bottom: BorderSide(color: Color(0xffFBB348), width: 1.w))),
            child: Center(
                child: CustomTextField(
              width: 100.w,
              onSaved: (newValue) {
                widget.newChildName(widget.index, newValue);
              },
            )),
          ),
          Container(
            width: 160.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Color(0xffFBB348), width: 1.w),
                    bottom: BorderSide(color: Color(0xffFBB348), width: 1.w))),
            child: Center(
              child: DropdownButton(
                // menuMaxHeight: 200.w,
                value: now == -1 ? null : now,
                elevation: 16,
                items: classList(),
                onChanged: (value) {
                  setState(() {
                    for (int i = 0; i < classList().length; i++) {
                      if (classList()[i].value == value) {
                        if (Provider.of<TeacherDataManagement>(context,
                                        listen: false)
                                    .teacherList
                                    .length -
                                1 ==
                            i) {
                          widget.newChildId(widget.index, 0);
                        } else {
                          widget.newChildId(widget.index, cId[i]);
                          now = i;
                        }
                      }
                    }
                  });
                },
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.arrow_drop_down,
                      size: 30.w,
                      color: Colors.blue,
                    ),
                  ],
                ),
                alignment: AlignmentDirectional.topCenter,
                underline: SizedBox.shrink(),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AijoaCalendar(
                      changeDate: changeDate,
                      nowDate: DateTime.now(),
                    );
                  });
            },
            child: Container(
              width: 150.w,
              height: 40.w,
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(color: Color(0xffFBB348), width: 1.w),
                      bottom:
                          BorderSide(color: Color(0xffFBB348), width: 1.w))),
              child: Center(
                  child: Text(_thatDateStr == '' ? '생일 입력해주세요.' : _thatDateStr,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff707070)))),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                sex = !sex;
                widget.newChildSex(widget.index, sex);
              });
            },
            child: Container(
              width: 80.w,
              height: 40.w,
              decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Color(0xffFBB348), width: 1.w),
                    bottom: BorderSide(color: Color(0xffFBB348), width: 1.w)),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.transparent
                //   )
                // ]
              ),
              child: Center(
                child: sex == true
                    ? Text('남',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w400))
                    : Text('여',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w400)),
              ),
            ),
          ),
          Container(
            width: 120.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Color(0xffFBB348), width: 1.w),
                    bottom: BorderSide(color: Color(0xffFBB348), width: 1.w))),
            child: Center(
                child: CustomTextField(
              width: 100.w,
              onSaved: (newValue) {
                widget.newChildParentName(widget.index, newValue);
              },
            )),
          ),
          Container(
            width: 150.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Color(0xffFBB348), width: 1.w),
                    bottom: BorderSide(color: Color(0xffFBB348), width: 1.w))),
            child: Center(
                child: CustomTextField(
              width: 149.w,
              onSaved: (newValue) {
                widget.newChildParentPhoneNumber(widget.index, newValue);
              },
            )),
          ),
          Container(
            width: 78.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xffFBB348), width: 1.w))),
            child: Center(
                child: CustomTextField(
              width: 149.w,
              onSaved: (newValue) {
                widget.newChildParentRelation(widget.index, newValue);
              },
            )),
          ),
        ],
      ),
    );
  }
}

Future pickImage(context) async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemp = File(image.path);
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageTemp.path,
      aspectRatio: CropAspectRatio(ratioX: 3.5, ratioY: 4.5),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    return File(croppedFile!.path);
  } on PlatformException catch (e) {
    print('Failed to pick image: $e');
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.hint = '',
    this.onlyNumber = false,
    required this.width,
    required this.onSaved,
    this.index = 0,
  }) : super(key: key);
  final String hint;
  final bool onlyNumber;
  final double width;
  final int index;
  final FormFieldSetter onSaved;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: widget.width,
            height: 37.w,
            // decoration: BoxDecoration(
            //   border: Border.all(width: 1, color: const Color(0xffFDB43B)),
            // ),
            child: Center(
              child: TextFormField(
                textAlign: TextAlign.center,
                inputFormatters: [
                  widget.onlyNumber == true
                      ? FilteringTextInputFormatter.digitsOnly
                      : FilteringTextInputFormatter.deny(RegExp(""))
                ],
                maxLength: widget.onlyNumber == true ? 8 : 50,
                keyboardType: widget.onlyNumber == true
                    ? TextInputType.number
                    : TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSaved: widget.onSaved,
                onChanged: widget.onSaved,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xffB2B2B2),
                  ),
                  border: const OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.w, horizontal: 16.w),
                  enabledBorder: const OutlineInputBorder(
                    //borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent
                        //Colors.green, //textfield unfocused 테두리
                        ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.w),
                    borderSide: const BorderSide(color: Colors.transparent
                        //Colors.blue, //textfield focused 테두리
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
              ),
            ))
      ],
    );
  }
}

class ModifyChildDialog extends StatefulWidget {
  const ModifyChildDialog({
    required this.reLoadCInfo,
    Key? key,
  }) : super(key: key);
  final Function() reLoadCInfo;

  @override
  State<ModifyChildDialog> createState() => _ModifyChildDialogState();
}

class _ModifyChildDialogState extends State<ModifyChildDialog> {
  static final autoLoginStorage = FlutterSecureStorage();
  List<String> classNameList = [];
  List<int> classIdList = [];
  List<bool> checkList = [];
  List<String> childBirthdayList = [];
  List<String> childNameList = [];
  List<bool> childSexList = [];
  List<Image> childFaceList = [];
  List<String> childCommentList = [];
  List<File?> childImageFile = [];
  List<String> childImageName = [];
  List<MultipartFile> imageFiles = [];
  late FormData formData;

  checkOnOff(int index, bool checked) {
    setState(() {
      checkList[index] = checked;
    });
  }

  changeClassId(int index, int newValue) {
    setState(() {
      classIdList[index] = newValue;
    });
  }

  changeChildFace(int index, Image newValue) {
    setState(() {
      childFaceList[index] = newValue;
    });
  }

  changeChildBirthday(int index, String newValue) {
    setState(() {
      childBirthdayList[index] = newValue;
    });
  }

  changeChildName(int index, String newValue) {
    setState(() {
      childNameList[index] = newValue;
    });
  }

  changeChildSex(int index, bool newValue) {
    setState(() {
      childSexList[index] = newValue;
    });
  }

  changeChildComment(int index, String newValue) {
    setState(() {
      childCommentList[index] = newValue;
    });
  }

  changeChildFile(int index, File newValue) {
    setState(() {
      childImageFile[index] = newValue;
    });
  }

  correctionChild() async {
    ApiUrl apiUrl = ApiUrl();
    List<Map<String, dynamic>> correctionList = [];

    for (int i = 0; i < checkList.length; i++) {
      if (checkList[i] == true) {
        if (childImageFile[i] != null) {
          childImageName[i] = childImageFile[i]!.path.split('/').last;
          print(childImageName[i]);
          imageFiles.add(await MultipartFile.fromFile(childImageFile[i]!.path,
              filename: childImageName[i]));
        } else {}
        correctionList.add({
          "id": Provider.of<ChildDataManagement>(context, listen: false)
              .childList[i]
              .identification,
          "cid": classIdList[i],
          "name": childNameList[i],
          "birthday": childBirthdayList[i],
          "sex": childSexList[i],
          "imageName": childImageName[i],
          "comment": childCommentList[i]
        });
      }
    }
    formData = FormData.fromMap(
        {"imageFiles": imageFiles, "correctionList": correctionList});
    imagesPostApi(apiUrl.child, 'adminToken', formData, 'put', context, widget.reLoadCInfo);
  }

  @override
  void initState() {
    for (int i = 0;
        i <
            Provider.of<ClassDataManagement>(context, listen: false)
                .classList
                .length;
        i++) {
      classNameList.add(Provider.of<ClassDataManagement>(context, listen: false)
          .classList[i]
          .className);
    }
    for (int i = 0;
        i <
            Provider.of<ChildDataManagement>(context, listen: false)
                .childList
                .length;
        i++) {
      checkList.add(false);
      childBirthdayList.add(
          Provider.of<ChildDataManagement>(context, listen: false)
              .childList[i]
              .birthday);
      childNameList.add(Provider.of<ChildDataManagement>(context, listen: false)
          .childList[i]
          .name);
      childSexList.add(Provider.of<ChildDataManagement>(context, listen: false)
          .childList[i]
          .sex);
      childCommentList.add(
          Provider.of<ChildDataManagement>(context, listen: false)
              .childList[i]
              .comment);
      childFaceList.add(Provider.of<ChildDataManagement>(context, listen: false)
          .childList[i]
          .childFace);
      childImageFile.add(null);
      childImageName.add('');
      int indexNumber = classNameList.indexOf(
          Provider.of<ChildDataManagement>(context, listen: false)
              .childList[i]
              .className);
      if (indexNumber != -1) {
        classIdList.add(Provider.of<ClassDataManagement>(context, listen: false)
            .classList[classNameList.indexOf(
                Provider.of<ChildDataManagement>(context, listen: false)
                    .childList[i]
                    .className)]
            .classId);
      } else {
        classIdList.add(-1);
      }
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool check = false;
    return Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            width: 1000.w,
            height: 550.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w),
                color: const Color(0xFFFCF9F4)),
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const RangeMaintainingScrollPhysics(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0.w, 47.w, 0.w, 0.w),
                        child: Text(
                          '영유아 정보 수정',
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
                              cTotalWidth: 50.w,
                              cTotalHeight: 40.w,
                              cInsideColor: const Color(0xffFED796),
                              cBorderColor: const Color(0xffFDB43B),
                              cBorderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.w)),
                              cTopBorderWidth: 1.w,
                              cLeftBorderWidth: 1.w,
                              childWidget: Checkbox(
                                value: check,
                                onChanged: ((newValue) {
                                  setState(() {
                                    check = !check;
                                    for (int i = 0; i < checkList.length; i++) {
                                      checkList[i] = check;
                                    }
                                  });
                                }),
                              )),
                          // Container(
                          //     width: 50.w,
                          //     height: 40.w,
                          //     margin: EdgeInsets.only(left: 20.w, top: 46.w),
                          //     decoration: BoxDecoration(
                          //         borderRadius: const BorderRadius.only(
                          //           topLeft: Radius.circular(10),
                          //         ),
                          //         border: Border.all(
                          //             width: 1, color: const Color(0xffFDB43B)),
                          //         color: const Color(0xffFED796)),
                          //     child: Checkbox(
                          //       value: check,
                          //       onChanged: ((newValue) {
                          //         setState(() {
                          //           check = !check;
                          //           for (int i = 0; i < checkList.length; i++) {
                          //             checkList[i] = check;
                          //           }
                          //         });
                          //       }),
                          //     )),
                          CustomContainer(
                            cTotalWidth: 160.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget: const Center(
                                child: ChildSettingTextStyle(text: '반이름')),
                          ),
                          // Container(
                          //   width: 160.w,
                          //   height: 40.w,
                          //   margin: EdgeInsets.only(top: 46.w),
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //           width: 1, color: const Color(0xffFDB43B)),
                          //       color: const Color(0xffFED796)),
                          //   child: const Center(child: ChildSettingTextStyle(text: '반이름')),
                          // ),
                          CustomContainer(
                            cTotalWidth: 120.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget: const Center(
                                child: ChildSettingTextStyle(text: '이름')),
                          ),
                          // Container(
                          //   width: 120.w,
                          //   height: 40.w,
                          //   margin: EdgeInsets.only(top: 46.w),
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //           width: 1, color: const Color(0xffFDB43B)),
                          //       color: const Color(0xffFED796)),
                          //   child: const Center(child: ChildSettingTextStyle(text: '이름')),
                          // ),
                          CustomContainer(
                            cTotalWidth: 160.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget: const Center(
                                child: ChildSettingTextStyle(text: '생일')),
                          ),
                          // Container(
                          //   width: 160.w,
                          //   height: 40.w,
                          //   margin: EdgeInsets.only(top: 46.w),
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //           width: 1, color: const Color(0xffFDB43B)),
                          //       color: const Color(0xffFED796)),
                          //   child: const Center(child: ChildSettingTextStyle(text: '생일')),
                          // ),
                          CustomContainer(
                            cTotalWidth: 80.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget: const Center(
                                child: ChildSettingTextStyle(text: '성별')),
                          ),
                          // Container(
                          //   width: 80.w,
                          //   height: 40.w,
                          //   margin: EdgeInsets.only(top: 46.w),
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //           width: 1, color: const Color(0xffFDB43B)),
                          //       color: const Color(0xffFED796)),
                          //   child: const Center(child: ChildSettingTextStyle(text: '성별')),
                          // ),
                          CustomContainer(
                            cTotalWidth: 100.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget: const Center(
                                child: ChildSettingTextStyle(text: '사진')),
                          ),
                          // Container(
                          //   width: 100.w,
                          //   height: 40.w,
                          //   margin: EdgeInsets.only(top: 46.w),
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //           width: 1, color: const Color(0xffFDB43B)),
                          //       color: const Color(0xffFED796)),
                          //   child: const Center(child: ChildSettingTextStyle(text: '사진')),
                          // ),
                          CustomContainer(
                            cTotalWidth: 188.w,
                            cTotalHeight: 40.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cBorderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.w)),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            childWidget: const Center(
                                child: ChildSettingTextStyle(text: '코멘트')),
                          ),
                          // Container(
                          //   width: 188.w,
                          //   height: 40.w,
                          //   margin: EdgeInsets.only(top: 46.w),
                          //   decoration: BoxDecoration(
                          //       borderRadius: const BorderRadius.only(
                          //         topRight: Radius.circular(10),
                          //       ),
                          //       border: Border.all(
                          //           width: 1, color: const Color(0xffFDB43B)),
                          //       color: const Color(0xffFED796)),
                          //   child: const Center(child: ChildSettingTextStyle(text: '코멘트')),
                          // ),
                        ],
                      ),
                      Container(
                        width: 858.w,
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
                          behavior: const ScrollBehavior()
                              .copyWith(overscroll: false),
                          child: ListView(
                              padding: EdgeInsets.zero,
                              physics: const RangeMaintainingScrollPhysics(),
                              children: [
                                for (int i = 0; i < checkList.length; i++) ...[
                                  ChildModifyRow(
                                    checked: checkList[i],
                                    classId: classIdList[i],
                                    childFace: childFaceList[i],
                                    changeBirthdayList: changeChildBirthday,
                                    changeCheckList: checkOnOff,
                                    changeClassList: changeClassId,
                                    changeComment: childCommentList[i],
                                    changeCommentList: changeChildComment,
                                    changeImageList: changeChildFace,
                                    changeSexList: changeChildSex,
                                    childBirthday: childBirthdayList[i],
                                    childSex: childSexList[i],
                                    childName: childNameList[i],
                                    changeChildName: changeChildName,
                                    index: i,
                                    changeImageFile: changeChildFile,
                                  ),
                                ]
                              ]),
                        ),
                      ),
                      SizedBox(height: 42.w),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: ElevatedButton(
                                onPressed: () async {
                                  List<int> classIds = [];
                                  for (int i = 0; i < checkList.length; i++) {
                                    // classIds.add(classList[i].classId);
                                  }
                                  correctionChild();
                                  //     classIds,
                                  //     classChildAgeList,
                                  //     classTeacherList,
                                  //     classCommentList,
                                  //     classNameList,
                                  //     checkList
                                  // );

                                  Navigator.pop(context); //result 반영 dialog 종료
                                },
                                child: Text('저장',
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w400)),
                                style: ElevatedButton.styleFrom(
                                    elevation: 1.0,
                                    primary: const Color(0xFFFFFFFF),
                                    onPrimary: const Color(0xFF393838),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.w)),
                                    side: const BorderSide(
                                        color: Color(0xFFA666FB)),
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
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w400)),
                                style: ElevatedButton.styleFrom(
                                    elevation: 1.0,
                                    primary: const Color(0xFFFFFFFF),
                                    onPrimary: const Color(0xFF393838),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.w)),
                                    side: const BorderSide(
                                        color: Color(0xFFA666FB)),
                                    fixedSize: Size(150.w, 50.w)),
                              ),
                            )
                          ])
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class ChildModifyRow extends StatefulWidget {
  const ChildModifyRow({
    Key? key,
    required this.checked,
    required this.classId,
    required this.childFace,
    required this.changeBirthdayList,
    required this.changeCheckList,
    required this.changeClassList,
    required this.changeComment,
    required this.changeCommentList,
    required this.changeImageList,
    required this.changeSexList,
    required this.childBirthday,
    required this.childSex,
    required this.index,
    required this.changeChildName,
    required this.childName,
    required this.changeImageFile,
  }) : super(key: key);
  final Function(int, bool) changeCheckList;
  final Function(int, int) changeClassList;
  final Function(int, Image) changeImageList;
  final Function(int, String) changeBirthdayList;
  final Function(int, bool) changeSexList;
  final Function(int, String) changeCommentList;
  final Function(int, String) changeChildName;
  final String childName;
  final bool checked;
  final int classId;
  final Image childFace;
  final String childBirthday;
  final bool childSex;
  final String changeComment;
  final int index;
  final Function(int, File) changeImageFile;

  @override
  State<ChildModifyRow> createState() => _ChildModifyRowState();
}

class _ChildModifyRowState extends State<ChildModifyRow> {
  List<int> number = [];
  List<String> className = [];
  List<int> cId = [];
  int now = -1;
  var img;

  String _thatDateStr = '';

  changeDate(DateTime thatDate) {
    var formatter = DateFormat('yyyy-MM-dd');
    _thatDateStr = formatter.format(thatDate);
    widget.changeBirthdayList(widget.index, _thatDateStr);
  }

  List<DropdownMenuItem<int>> classList() {
    return number
        .map<DropdownMenuItem<int>>(
          (e) => DropdownMenuItem(
            enabled: true,
            alignment: Alignment.centerLeft,
            value: e,
            child: Text(
              className[e],
              style: TextStyle(
                  color: Color(0xff393838),
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp),
            ),
          ),
        )
        .toList();
  }

  @override
  void initState() {
    for (int i = 0;
        i <
            Provider.of<ClassDataManagement>(context, listen: false)
                .classList
                .length;
        i++) {
      number.add(i);
      className.add(Provider.of<ClassDataManagement>(context, listen: false)
          .classList[i]
          .className);
      cId.add(Provider.of<ClassDataManagement>(context, listen: false)
          .classList[i]
          .classId);
    }
    number.add(Provider.of<ClassDataManagement>(context, listen: false)
        .classList
        .length);
    if (widget.classId == -1) {
      now = -1;
    } else {
      now = cId.indexOf(widget.classId);
    }
    className.add("배정 취소");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.changeCheckList(widget.index, true);
        });
      },
      child: SizedBox(
        width: 862.w,
        height: 40.w,
        child: Row(children: [
          SizedBox(
            width: 50.w,
            height: 50.w,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                      width: 1,
                      color: const Color(0xffFDB43B),
                    ),
                    bottom:
                        BorderSide(width: 1, color: const Color(0xffFDB43B))),
              ),
              child: Checkbox(
                  value: widget.checked,
                  onChanged: (value) {
                    setState(() {
                      widget.changeCheckList(widget.index, !widget.checked);
                    });
                  }),
            ),
          ),
          widget.checked
              ? Container(
                  //반이름
                  width: 160.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                            width: 1,
                            color: const Color(0xffFDB43B),
                          ),
                          bottom: BorderSide(
                              width: 1, color: const Color(0xffFDB43B))),
                      color: const Color(0xffffffff)),
                  child: Center(
                    child: DropdownButton(
                      // menuMaxHeight: 200.w,
                      value: now == -1 ? null : now,
                      elevation: 16,
                      items: classList(),
                      onChanged: (value) {
                        setState(() {
                          for (int i = 0; i < classList().length; i++) {
                            if (classList()[i].value == value) {
                              if (cId.length == i) {
                                widget.changeClassList(widget.index, 0);
                                now = -1;
                              } else {
                                widget.changeClassList(widget.index, cId[i]);
                                now = i;
                              }
                            }
                          }
                        });
                      },
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.arrow_drop_down,
                            size: 30.w,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      alignment: AlignmentDirectional.topCenter,
                      underline: SizedBox.shrink(),
                    ),
                  ),
                )
              : Container(
                  //반이름
                  width: 160.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                            width: 1,
                            color: const Color(0xffFDB43B),
                          ),
                          bottom: BorderSide(
                              width: 1, color: const Color(0xffFDB43B))),
                      color: const Color(0xffffffff)),
                  child: Center(
                    child: ChildSettingTextStyle(
                      text: now == -1 ? "" : className[now],
                    ),
                  ),
                ),
          widget.checked
              ? Container(
                  //이름
                  width: 120.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                            width: 1,
                            color: const Color(0xffFDB43B),
                          ),
                          bottom: BorderSide(
                              width: 1, color: const Color(0xffFDB43B))),
                      color: const Color(0xffffffff)),
                  child: Center(
                      child: CustomTextField(
                    hint: widget.childName,
                    onSaved: ((newValue) {
                      widget.changeChildName(widget.index, newValue);
                    }),
                    width: 160.w,
                  )),
                )
              : Container(
                  //이름
                  width: 120.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                            width: 1,
                            color: const Color(0xffFDB43B),
                          ),
                          bottom: BorderSide(
                              width: 1, color: const Color(0xffFDB43B))),
                      color: const Color(0xffffffff)),
                  child: Center(
                      child: ChildSettingTextStyle(
                    text: widget.childName,
                  )),
                ),
          widget.checked
              ? GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AijoaCalendar(
                            changeDate: changeDate,
                            nowDate: DateTime.now(),
                          );
                        });
                  },
                  child: Container(
                    width: 160.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                            width: 1,
                            color: const Color(0xffFDB43B),
                          ),
                          bottom: BorderSide(
                              width: 1, color: const Color(0xffFDB43B))),
                    ),
                    child: Center(
                        child: Text(widget.childBirthday,
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff707070)))),
                  ),
                )
              : Container(
                  width: 160.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                            width: 1,
                            color: const Color(0xffFDB43B),
                          ),
                          bottom: BorderSide(
                              width: 1, color: const Color(0xffFDB43B))),
                      color: const Color(0xffffffff)),
                  child: Center(
                      child: ChildSettingTextStyle(
                    text: widget.childBirthday,
                  )),
                ),
          widget.checked
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.changeSexList(widget.index, !widget.childSex);
                    });
                  },
                  child: Container(
                    width: 80.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                            width: 1,
                            color: const Color(0xffFDB43B),
                          ),
                          bottom: BorderSide(
                              width: 1, color: const Color(0xffFDB43B))),
                    ),
                    child: Center(
                      child: widget.childSex == true
                          ? Text('남',
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w400))
                          : Text('여',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400)),
                    ),
                  ),
                )
              : Container(
                  width: 80.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                            width: 1,
                            color: const Color(0xffFDB43B),
                          ),
                          bottom: BorderSide(
                              width: 1, color: const Color(0xffFDB43B))),
                      color: const Color(0xffffffff)),
                  child: Center(
                      child: ChildSettingTextStyle(
                    text: widget.childSex == true ? '남' : '여',
                  )),
                ),
          widget.checked
              ? Container(
                  width: 100.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                            width: 1,
                            color: const Color(0xffFDB43B),
                          ),
                          bottom: BorderSide(
                              width: 1, color: const Color(0xffFDB43B))),
                      color: const Color(0xffffffff)),
                  child: GestureDetector(
                      onTap: () async {
                        img = await pickImage(context);
                        setState(() {
                          widget.changeImageFile(widget.index, img);
                        });
                      },
                      child: img == null ? widget.childFace : Image.file(img)),
                )
              : Container(
                  width: 100.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                            width: 1,
                            color: const Color(0xffFDB43B),
                          ),
                          bottom: BorderSide(
                              width: 1, color: const Color(0xffFDB43B))),
                      color: const Color(0xffffffff)),
                  child: img == null ? widget.childFace : Image.file(img),
                ),
          widget.checked
              ? Container(
                  width: 186.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                            width: 1,
                            color: const Color(0xffFDB43B),
                          ),
                          bottom: BorderSide(
                              width: 1, color: const Color(0xffFDB43B))),
                      color: const Color(0xffffffff)),
                  child: Center(
                      child: CustomTextField(
                    hint: widget.changeComment,
                    onSaved: ((newValue) {
                      widget.changeCommentList(widget.index, newValue);
                    }),
                    width: 160.w,
                  )),
                )
              : Container(
                  width: 186.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1, color: const Color(0xffFDB43B))),
                      color: const Color(0xffffffff)),
                  child: Center(
                      child: ChildSettingTextStyle(
                    text: widget.changeComment,
                  )),
                ),
        ]),
      ),
    );
  }
}

class DismissChildDialog extends StatefulWidget {
  const DismissChildDialog({
    Key? key,
    required this.reloadTInfo,
  }) : super(key: key);
  final Function reloadTInfo;

  @override
  State<DismissChildDialog> createState() => _DismissChildDialogState();
}

class _DismissChildDialogState extends State<DismissChildDialog> {
  List<bool> checkList = [];
  List<Color> colorList = [];

  void checkOnOff(int index, bool checked) {
    setState(() {
      checkList[index] = checked;
      debugPrint('$checked');
      print("checkList(dismiss): $checkList");
      if (checked == true) {
        colorList[index] = Colors.lightGreenAccent;
      } else {
        colorList[index] = Colors.transparent;
      }
    });
  }

  @override
  initState() {
    super.initState();
    for (int i = 0;
        i <
            Provider.of<ChildDataManagement>(context, listen: false)
                .childList
                .length;
        i++) {
      checkList.add(false);
      colorList.add(Colors.transparent);
    }
  }

  postDeleteChild(List<int> index) async {
    ApiUrl apiUrl = ApiUrl();
    PostChildDelete postChildDelete = PostChildDelete(deleteList: index);
    http.Response res = await api(
        apiUrl.deleteChild, 'post', 'adminToken', postChildDelete, context);
    if (res.statusCode == 200) {
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
                    '영유아 등록 해제',
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
                      cTotalWidth: 80.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cBorderRadius:
                          BorderRadius.only(topLeft: Radius.circular(10.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: const Center(
                          child: ChildSettingTextStyle(text: '이름')),
                    ),
                    // Container(
                    //   width: 80.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(left: 20.w, top: 46.w),
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.only(
                    //         topLeft: Radius.circular(10.w),
                    //       ),
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: ChildSettingTextStyle(text: '이름')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 100.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: const Center(
                          child: ChildSettingTextStyle(text: '소속반')),
                    ),
                    // Container(
                    //   width: 100.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: ChildSettingTextStyle(text: '소속반')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 100.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: const Center(
                          child: ChildSettingTextStyle(text: '생년월일')),
                    ),
                    // Container(
                    //   width: 100.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: ChildSettingTextStyle(text: '생년월일')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 170.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: const Center(
                          child: ChildSettingTextStyle(text: '코멘트')),
                    ),
                    // Container(
                    //   width: 170.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: ChildSettingTextStyle(text: '코멘트')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 200.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: const Center(
                          child: ChildSettingTextStyle(text: '보호자 아이디')),
                    ),
                    // Container(
                    //   width: 200.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: ChildSettingTextStyle(text: '보호자 아이디')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 80.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: const Center(
                          child: ChildSettingTextStyle(text: '학부모 이름')),
                    ),
                    // Container(
                    //   width: 80.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: ChildSettingTextStyle(text: '학부모 이름')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 170.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cBorderRadius:
                          BorderRadius.only(topRight: Radius.circular(20.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget: const Center(
                          child: ChildSettingTextStyle(text: '학부모 연락처')),
                    ),
                    // Container(
                    //   width: 170.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.only(
                    //         topRight: Radius.circular(10.w),
                    //       ),
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(child: ChildSettingTextStyle(text: '학부모 연락처')),
                    // ),
                  ],
                ),
                SingleChildScrollView(
                    child: Container(
                  width: 900.w,
                  height: 235.w,
                  margin: EdgeInsets.only(left: 20.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.only(
                      //     bottomLeft: Radius.circular(10),
                      //     bottomRight: Radius.circular(10)),
                      border: Border.all(
                          color: const Color(0xFFFBB348), width: 1.w)),
                  child: ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const RangeMaintainingScrollPhysics(),
                        children: [
                          for (int i = 0;
                              i <
                                  Provider.of<ChildDataManagement>(context,
                                          listen: false)
                                      .childList
                                      .length;
                              i++) ...[
                            DismissChildListRow(
                              checkFunction: checkOnOff,
                              checkValue: checkList[i],
                              colorValue: colorList[i],
                              childIndex: i,
                              name: Provider.of<ChildDataManagement>(context,
                                      listen: false)
                                  .childList[i]
                                  .name,
                              className: Provider.of<ChildDataManagement>(
                                      context,
                                      listen: false)
                                  .childList[i]
                                  .className,
                              comment: Provider.of<ChildDataManagement>(context,
                                      listen: false)
                                  .childList[i]
                                  .comment,
                              parentId: Provider.of<ChildDataManagement>(
                                      context,
                                      listen: false)
                                  .childList[i]
                                  .parentName,
                              parentPhoneNumber:
                                  Provider.of<ChildDataManagement>(context,
                                          listen: false)
                                      .childList[i]
                                      .phoneNumber,
                              parentName: Provider.of<ChildDataManagement>(
                                      context,
                                      listen: false)
                                  .childList[i]
                                  .parentName,
                              birthday: Provider.of<ChildDataManagement>(
                                      context,
                                      listen: false)
                                  .childList[i]
                                  .birthday,
                            )
                          ]
                        ]),
                  ),
                )),
                SizedBox(height: 42.w),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('삭제');
                      setState(() {
                        List<int> classIds = [];
                        for (int i = 0; i < checkList.length; i++) {
                          if (checkList[i] == true) {
                            classIds.add(Provider.of<ChildDataManagement>(
                                    context,
                                    listen: false)
                                .childList[i]
                                .identification);
                          }
                        }
                        postDeleteChild(classIds);
                      });
                      Navigator.pop(context);
                    },
                    child: Text('해제',
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

class DismissChildListRow extends StatefulWidget {
  const DismissChildListRow(
      {required this.checkFunction,
      required this.checkValue,
      required this.colorValue,
      required this.name,
      required this.comment,
      required this.className,
      required this.parentName,
      required this.parentPhoneNumber,
      required this.birthday,
      required this.parentId,
      required this.childIndex,
      Key? key})
      : super(key: key);
  final Function(int, bool) checkFunction;
  final bool checkValue;
  final Color colorValue;
  final childIndex;
  final String name;
  final String className;
  final String birthday;
  final String comment;
  final String parentId;
  final String parentName;
  final String parentPhoneNumber;

  @override
  State<DismissChildListRow> createState() => _DismissChildListRowState();
}

class _DismissChildListRowState extends State<DismissChildListRow> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.checkFunction(widget.childIndex, !widget.checkValue);
        });
      },
      child: SizedBox(
        width: 862.w,
        height: 40.w,
        child: Row(
          children: [
            ///이름
            Container(
              width: 80.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: widget.colorValue,
                  border: Border(
                      right: BorderSide(
                          color: const Color(0xFFFBB348), width: 1.w),
                      bottom: BorderSide(
                          color: const Color(0xFFFBB348), width: 1.w))),
              child: Center(child: ChildSettingTextStyle(text: widget.name)),
            ),

            ///담당반
            Container(
              width: 100.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: widget.colorValue,
                  border: Border(
                      right: BorderSide(
                          color: const Color(0xFFFBB348), width: 1.w),
                      bottom: BorderSide(
                          color: const Color(0xFFFBB348), width: 1.w))),
              child:
                  Center(child: ChildSettingTextStyle(text: widget.className)),
            ),

            ///연락처
            Container(
              width: 100.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: widget.colorValue,
                  border: Border(
                      right: BorderSide(
                          color: const Color(0xFFFBB348), width: 1.w),
                      bottom: BorderSide(
                          color: const Color(0xFFFBB348), width: 1.w))),
              child:
                  Center(child: ChildSettingTextStyle(text: widget.birthday)),
            ),

            ///아이디
            Container(
              width: 170.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: widget.colorValue,
                  border: Border(
                      right: BorderSide(
                          color: const Color(0xFFFBB348), width: 1.w),
                      bottom: BorderSide(
                          color: const Color(0xFFFBB348), width: 1.w))),
              child: Center(child: ChildSettingTextStyle(text: widget.comment)),
            ),
            Container(
              width: 200.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: widget.colorValue,
                  border: Border(
                      right: BorderSide(
                          color: const Color(0xFFFBB348), width: 1.w),
                      bottom: BorderSide(
                          color: const Color(0xFFFBB348), width: 1.w))),
              child:
                  Center(child: ChildSettingTextStyle(text: widget.parentId)),
            ),
            Container(
              width: 80.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: widget.colorValue,
                  border: Border(
                      right: BorderSide(
                          color: const Color(0xFFFBB348), width: 1.w),
                      bottom: BorderSide(
                          color: const Color(0xFFFBB348), width: 1.w))),
              child:
                  Center(child: ChildSettingTextStyle(text: widget.parentName)),
            ),

            ///코멘트
            Container(
              width: 168.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: widget.colorValue,
                  border: Border(
                      bottom: BorderSide(
                          color: const Color(0xFFFBB348), width: 1.w))),
              child: Center(
                child: ChildSettingTextStyle(text: widget.parentPhoneNumber),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChildSettingTextStyle extends StatefulWidget {
  const ChildSettingTextStyle({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<ChildSettingTextStyle> createState() => _ChildSettingTextStyleState();
}

class _ChildSettingTextStyleState extends State<ChildSettingTextStyle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: Color(0xff393838)),
    );
  }
}
