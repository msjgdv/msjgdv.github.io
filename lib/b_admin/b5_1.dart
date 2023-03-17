import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:treasure_map/admin.dart';
import 'package:treasure_map/widgets/custom_container.dart';
import '../api/admin.dart';
import '../provider/class_data_management.dart';
import '../provider/teacher_data_management.dart';
import '../widgets/api.dart';

int classNum = 0;
List<Class> classList = [];
Color bordercolor = const Color(0xFFFBB348);

class B5_1 extends StatefulWidget {
  const B5_1({
    Key? key,
    required this.notifyParent,
    required this.schoolYearSetting,
    required this.schoolYear,
  }) : super(key: key);
  final Function(double, double)? notifyParent;
  final int schoolYear;
  final Function(int) schoolYearSetting;

  @override
  State<B5_1> createState() => _B5_1State();
}

class _B5_1State extends State<B5_1> {
  GlobalKey globalkeyCK = GlobalKey();
  int nowYear = DateTime.now().year;
  ApiUrl apiUrl = ApiUrl();

  void refreshClass(int num, Class newClass) {
    setState(() {
      classNum = num;
      classList.add(newClass);
    });
  }



  getClassInfo() async {
    http.Response classRes =
    await api('${apiUrl.getClass}/${widget.schoolYear}', 'get', 'signInToken', {}, context);
    if(classRes.statusCode == 200) {
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
              classComment:
              classData[i]['comment'] ?? "",
              classId: classData[i]['id'],
              classCount: classData[i]['count'],
              classTId: classData[i]['tid']));
        }
      });
    }
  }

  getTeacherInfo() async {
    http.Response teacherRes =
    await api('${apiUrl.teacher}', 'get', 'adminToken', {}, context);
    if(teacherRes.statusCode == 200) {
      var teacherRB = utf8.decode(teacherRes.bodyBytes);
      var teacherData = jsonDecode(teacherRB);
      setState(() {
        Provider.of<TeacherDataManagement>(context, listen: false)
            .teacherList
            .clear();
        for (int i = 0; i < teacherData.length; i++) {
          Provider.of<TeacherDataManagement>(context, listen: false)
              .teacherList
              .add(Teacher(
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
    getClassInfo();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    classNum = Provider.of<ClassDataManagement>(context, listen: false)
        .classList
        .length;
    classList =
        Provider.of<ClassDataManagement>(context, listen: false).classList;
    return Row(
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
                      child: Text('학급 목록',
                          style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF393838)))),
                  Spacer(),
                  SchoolYearSettingWidget(
                      schoolYear: widget.schoolYear,
                      schoolYearSetting: widget.schoolYearSetting,
                      getFunction: () => {getTeacherInfo(), getClassInfo()}),
                ],
              ),
            ),
            Container(
              // height: 550.w,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 46.w,
                    ),
                    Row(
                      children: [
                        CustomContainer(
                          cTotalHeight: 40.w,
                          cTotalWidth: 70.w,
                          cBorderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.w),
                          ),
                          cInsideColor: const Color(0xffFED796),
                          cBorderColor: const Color(0xffFDB43B),
                          cTopBorderWidth: 1.w,
                          cLeftBorderWidth: 1.w,

                          childWidget: const Center(
                              child: AdminTableTextStyle(text: '번호')),
                        ),

                        Container(
                          width: 150.w,
                          height: 40.w,
                          // margin: EdgeInsets.only(top: 46.w),
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(width: 1, color: bordercolor),
                                left: BorderSide(width: 1, color: bordercolor),
                              ),
                              //     Border.all(
                              //         width: 1, color: const Color(0xffFDB43B)
                              // ),
                              color: const Color(0xffFED796)),
                          child: const Center(
                              child: AdminTableTextStyle(text: '학급 연령')),
                        ),
                        Container(
                          width: 150.w,
                          height: 40.w,
                          // margin: EdgeInsets.only(top: 46.w),
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(width: 1, color: bordercolor),
                                left: BorderSide(width: 1, color: bordercolor),
                              ),
                              color: const Color(0xffFED796)),
                          child: const Center(
                              child: AdminTableTextStyle(text: '학급 이름')),
                        ),
                        Container(
                          width: 150.w,
                          height: 40.w,
                          // margin: EdgeInsets.only(top: 46.w),
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(width: 1, color: bordercolor),
                                left: BorderSide(width: 1, color: bordercolor),
                              ),
                              color: const Color(0xffFED796)),
                          child: const Center(
                              child: AdminTableTextStyle(text: '담당선생님')),
                        ),
                        Container(
                          width: 100.w,
                          height: 40.w,
                          // margin: EdgeInsets.only(top: 46.w),
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(width: 1, color: bordercolor),
                                left: BorderSide(width: 1, color: bordercolor),
                              ),
                              color: const Color(0xffFED796)),
                          child: const Center(
                              child: AdminTableTextStyle(text: '영유아수')),
                        ),
                        CustomContainer(
                          cTotalHeight: 40.w,
                          cTotalWidth: 280.w,
                          cBorderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.w),
                          ),
                          cInsideColor: const Color(0xffFED796),
                          cBorderColor: const Color(0xffFDB43B),
                          cTopBorderWidth: 1.w,
                          cLeftBorderWidth: 1.w,
                          cRightBorderWidth: 1.w,
                          childWidget: const Center(
                              child: AdminTableTextStyle(text: '코멘트')),
                        ),
                      ],
                    ),
                    Container(
                        width: 900.w,
                        height: 360.w,
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
                                for (int i = 0; i < classNum; i++) ...[
                                  ClassList(
                                    classIndex: i,
                                    className: classList[i].className,
                                    classTeacher: classList[i].classTeacher,
                                    classChildAge: classList[i].classChildAge,
                                    classComment: classList[i].classComment,
                                    classCount: classList[i].classCount,
                                  )
                                ]
                              ]),
                        )),
                    SizedBox(height: 25.w),
                    // Spacer(),
                    Row(children: [
                      SizedBox(
                        width: 25.w,
                      ),
                      SizedBox(
                        width: 260.w,
                        height: 50.w,
                        child: ElevatedButton(
                          onPressed: () async {
                            debugPrint('학급 등록');
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext contextB11_2) {
                                  return ReigsterClassDialog(
                                    reLoadCInfo: getClassInfo,
                                    reLoadTInfo: getTeacherInfo,
                                    refresh: refreshClass,
                                    year: widget.schoolYear,
                                  );
                                });
                          },
                          child: Text('학급 등록',
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
                      //아이 수정
                      Container(
                        width: 260.w,
                        height: 50.w,
                        margin: EdgeInsets.only(left: 40.w),
                        child: ElevatedButton(
                          onPressed: () async {
                            debugPrint('학급 수정');
                            await showDialog(
                                barrierColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return ModifyClassDialog(
                                    reLoadCInfo: getClassInfo,
                                    reLoadTInfo: getTeacherInfo,
                                    year: widget.schoolYear,
                                  );
                                });
                          },
                          child: Text('학급 수정',
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
                      Container(
                        width: 260.w,
                        height: 50.w,
                        margin: EdgeInsets.only(left: 40.w),
                        child: ElevatedButton(
                          onPressed: () async {
                            debugPrint('학급 삭제');
                            await showDialog(
                                barrierColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return DismissClassDialog(
                                    reLoadCInfo: getClassInfo,
                                    reLoadTInfo: getTeacherInfo,
                                  );
                                });
                          },
                          child: Text('학급 삭제',
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
                      )
                    ]),
                    // SizedBox(
                    //   height: 50.w,
                    // )
                  ]),
            )
          ],
        ),
      ],
    );
  }
}

class ClassList extends StatefulWidget {
  ClassList(
      {required this.classIndex,
      required this.className,
      required this.classTeacher,
      required this.classChildAge,
      required this.classComment,
      required this.classCount,
      Key? key})
      : super(key: key);
  int classIndex;
  String className;
  String classTeacher;
  String classChildAge;
  String classComment;
  int classCount;

  @override
  State<ClassList> createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  Color bordercolor = const Color(0xFFFBB348);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 862.w,
      height: 40.w,
      child: Row(
        children: [
          ///반 이름
          Container(
            width: 70.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border(
              right: BorderSide(width: 1, color: bordercolor),
              bottom: BorderSide(width: 1, color: bordercolor),
            )),
            child: Center(
                child: AdminTableTextStyle(
                    text: (widget.classIndex + 1).toString())),
          ),
          Container(
            width: 150.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border(
              right: BorderSide(width: 1, color: bordercolor),
              bottom: BorderSide(width: 1, color: bordercolor),
            )),
            child:
                Center(child: AdminTableTextStyle(text: widget.classChildAge)),
          ),
          Container(
            width: 150.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border(
              right: BorderSide(width: 1, color: bordercolor),
              bottom: BorderSide(width: 1, color: bordercolor),
            )),
            child: Center(child: AdminTableTextStyle(text: widget.className)),
          ),

          ///담당선생님
          Container(
            width: 150.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border(
              right: BorderSide(width: 1, color: bordercolor),
              bottom: BorderSide(width: 1, color: bordercolor),
            )),
            child:
                Center(child: AdminTableTextStyle(text: widget.classTeacher)),
          ),

          ///학생수
          Container(
            width: 100.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border(
              right: BorderSide(width: 1, color: bordercolor),
              bottom: BorderSide(width: 1, color: bordercolor),
            )),
            child: Center(
                child: AdminTableTextStyle(text: widget.classCount.toString())),
          ),

          ///코멘트
          Container(
            width: 278.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(width: 1, color: bordercolor),
            )),
            child: Center(
              child: AdminTableTextStyle(text: widget.classComment),
            ),
          ),
        ],
      ),
    );
  }
}

class ReigsterClassDialog extends StatefulWidget {
  const ReigsterClassDialog(
      {required this.refresh,
      required this.year,
      required this.reLoadCInfo,
      required this.reLoadTInfo,
      Key? key})
      : super(key: key);
  final Function(int, Class) refresh;
  final int year;
  final Function reLoadCInfo;
  final Function reLoadTInfo;

  @override
  State<ReigsterClassDialog> createState() => _ReigsterClassDialogState();
}

class _ReigsterClassDialogState extends State<ReigsterClassDialog> {
  createClass(List<String> age, List<String> name, List<String> comment,
      List<int> id) async {
    List<Map<String, dynamic>> create = [];
    print(widget.year);

    for (int i = 0; i < age.length; i++) {
      create.add({
        "age": age[i],
        "name": name[i],
        "id": id[i] == "" ? null : id[i],
        "comment": comment[i],
        "year": widget.year
      });
    }
    CreateClass createClass = CreateClass(
      createList: create,
    );

    ApiUrl apiUrl = ApiUrl();
    http.Response res = await api(apiUrl.getClass, 'post', 'adminToken', createClass, context);
    if(res.statusCode == 200){
      widget.reLoadTInfo();
      widget.reLoadCInfo();
    }
  }

  int newClassNum = 0; //새로 추가될 항목

  List<String> classNameList = [];
  List<int> classTeacherlist = [];
  List<String> classChildAgeList = [];
  List<String> classCommentList = [];
  List<int> teacherNumber = [];
  List<int> tId = [];

  void setNewClassName(int index, String newValue) {
    setState(() {
      classNameList[index] = newValue;
    });
  }

  void setNewClassTeacher(int index, int newValue, int number) {
    for (int i = 0; i < classNameList.length; i++) {
      for (int j = 0;
          j <
              Provider.of<TeacherDataManagement>(context, listen: false)
                  .teacherList
                  .length;
          j++) {
        if (classTeacherlist[i] ==
            Provider.of<TeacherDataManagement>(context, listen: false)
                .teacherList[j]
                .id) {
          teacherNumber[i] = j;
        }
      }
    }
    setState(() {
      classTeacherlist[index] = newValue;
    });

    setState(() {
      for (int i = 0; i < classTeacherlist.length; i++) {
        if (newValue == 0) {
          // classTeacherlist[index] = newValue;
          // teacherNumber[index] = number;
        } else {
          if (classTeacherlist[i] == newValue) {
            classTeacherlist[i] = 0;
            teacherNumber[i] = -1;
          }
        }
      }
      classTeacherlist[index] = newValue;
      teacherNumber[index] = number;
    });
  }

  void setNewClassChildAge(int index, String newValue) {
    setState(() {
      classChildAgeList[index] = newValue;
    });
  }

  void setNewClassComment(int index, String newValue) {
    setState(() {
      classCommentList[index] = newValue;
    });
  }

  void setNewRow() {
    setState(() {
      classNameList.add('');
      classTeacherlist.add(0);
      classChildAgeList.add('');
      classCommentList.add('');
      teacherNumber.add(-1);
    });
  }

  @override
  void initState() {
    for (int i = 0;
        i <
            Provider.of<TeacherDataManagement>(context, listen: false)
                .teacherList
                .length;
        i++) {
      if (Provider.of<TeacherDataManagement>(context, listen: false)
              .teacherList[i]
              .className ==
          "") {
        tId.add(Provider.of<TeacherDataManagement>(context, listen: false)
            .teacherList[i]
            .id);
      }
    }

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
                    '학급 추가',
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
                      cTotalHeight: 40.w,
                      cTotalWidth: 180.w,
                      cBorderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.w),
                      ),
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: const Center(
                          child: AdminTableTextStyle(text: '학급 이름')),
                    ),
                    // Container(
                    //   width: 180.w,
                    //   height: 40.w,
                    //   decoration: BoxDecoration(
                    //       borderRadius: const BorderRadius.only(
                    //         topLeft: Radius.circular(10),
                    //       ),
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(
                    //       child: AdminTableTextStyle(text: '학급 이름')),
                    // ),
                    CustomContainer(
                      cTotalHeight: 40.w,
                      cTotalWidth: 328.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: const Center(
                          child: AdminTableTextStyle(text: '담당선생님')),
                    ),
                    // Container(
                    //   width: 328.w,
                    //   height: 40.w,
                    //
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(
                    //       child: AdminTableTextStyle(text: '담당선생님')),
                    // ),
                    CustomContainer(
                      cTotalHeight: 40.w,
                      cTotalWidth: 120.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: const Center(
                          child: AdminTableTextStyle(text: '학급 연령')),
                    ),
                    // Container(
                    //   width: 120.w,
                    //   height: 40.w,
                    //
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(
                    //       child: AdminTableTextStyle(text: '학급 연령')),
                    // ),
                    CustomContainer(
                      cTotalHeight: 40.w,
                      cTotalWidth: 180.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cBorderRadius: BorderRadius.only(topRight: Radius.circular(10.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget: const Center(
                          child: AdminTableTextStyle(text: '코멘트')),
                    ),
                    // Container(
                    //   width: 180.w,
                    //   height: 40.w,
                    //
                    //   decoration: BoxDecoration(
                    //       borderRadius: const BorderRadius.only(
                    //         topRight: Radius.circular(10),
                    //       ),
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child:
                    //       const Center(child: AdminTableTextStyle(text: '코멘트')),
                    // ),
                  ],
                ),
                SingleChildScrollView(
                    child: Container(
                  width: 808.w,
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
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const RangeMaintainingScrollPhysics(),
                        children: [
                          for (int i = 0; i < newClassNum; i++) ...[
                            ClassRegisterRow(
                              newClassIndex: i,
                              newClassNameFunc: setNewClassName,
                              newClassTeacherFunc: setNewClassTeacher,
                              newClassAgeFunc: setNewClassChildAge,
                              newClassCommentFunc: setNewClassComment,
                              tId: tId,
                              teacherNumber: teacherNumber[i],
                              newClassCount: classNameList.length,
                              newClassAgeList: classChildAgeList[i],
                            )
                          ]
                        ]),
                  ),
                )),
                SizedBox(height: 52.w),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 225.w),
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint('추가');
                          setState(() {
                            setNewRow();
                            newClassNum++;
                          });
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
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50.w),
                      child: ElevatedButton(
                        onPressed: () {
                          debugPrint('저장');
                          createClass(classChildAgeList, classNameList,
                              classCommentList, classTeacherlist);

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
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

class ClassRegisterRow extends StatefulWidget {
  const ClassRegisterRow(
      {required this.newClassIndex,
      required this.newClassNameFunc,
      required this.newClassTeacherFunc,
      required this.newClassAgeFunc,
      required this.newClassCommentFunc,
      required this.tId,
      required this.teacherNumber,
      required this.newClassCount,
      required this.newClassAgeList,
      Key? key})
      : super(key: key);
  final int newClassCount;
  final int newClassIndex;
  final Function(int, String) newClassNameFunc;
  final Function(int, int, int) newClassTeacherFunc;
  final Function(int, String) newClassAgeFunc;
  final Function(int, String) newClassCommentFunc;
  final String newClassAgeList;
  final List<int> tId;
  final int teacherNumber;

  @override
  State<ClassRegisterRow> createState() => _ClassRegisterRowState();
}

class _ClassRegisterRowState extends State<ClassRegisterRow> {
  List<String> teacherName = [];
  List<int> tId = [];
  List<int> number = [];
  String selectedTeacherName = '';
  GlobalKey _globalKey = GlobalKey();

  _getPosition(GlobalKey key, String XY) {
    if (key.currentContext != null) {
      final RenderBox renderBox =
          key.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      if (XY == 'x') {
        return position.dx;
      } else {
        return position.dy;
      }
    }
  }

  List<DropdownMenuItem<int>> teacherList() {
    return number
        .map<DropdownMenuItem<int>>(
          (e) => DropdownMenuItem(
            enabled: true,
            alignment: Alignment.centerLeft,
            value: e,
            child: Text(
              teacherName[e],
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
    for (int i = 0; i < widget.tId.length; i++) {
      number.add(i);
    }
    for (int i = 0; i < widget.tId.length; i++) {
      for (int j = 0;
          j <
              Provider.of<TeacherDataManagement>(context, listen: false)
                  .teacherList
                  .length;
          j++) {
        if (widget.tId[i] ==
            Provider.of<TeacherDataManagement>(context, listen: false)
                .teacherList[j]
                .id) {
          teacherName.add(
              Provider.of<TeacherDataManagement>(context, listen: false)
                      .teacherList[j]
                      .name +
                  "(" +
                  Provider.of<TeacherDataManagement>(context, listen: false)
                      .teacherList[j]
                      .email +
                  ")");
        }
      }
    }
    teacherName.add("배정 취소");

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomTextFieldA((newValue) {
          widget.newClassNameFunc(widget.newClassIndex, newValue);
        }, 0, false),
        Container(
          height: 40.w,
          width: 328.w,
          decoration: BoxDecoration(
              border: Border(
            right: BorderSide(width: 1, color: bordercolor),
            bottom: BorderSide(width: 1, color: bordercolor),
          )),
          child: Center(
            child: DropdownButton(
              // menuMaxHeight: 200.w,
              value: widget.teacherNumber == -1 ? null : widget.teacherNumber,
              elevation: 16,
              items: teacherList(),
              onChanged: (value) {
                setState(() {
                  for (int i = 0; i < teacherList().length; i++) {
                    if (teacherList()[i].value == value) {
                      if (Provider.of<TeacherDataManagement>(context,
                                      listen: false)
                                  .teacherList
                                  .length -
                              1 <
                          i) {
                        widget.newClassTeacherFunc(widget.newClassIndex, 0, -1);
                      } else {
                        widget.newClassTeacherFunc(
                            widget.newClassIndex, widget.tId[i], i);
                      }
                    }
                  }
                  selectedTeacherName = value.toString();
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
        Container(
            width: 120.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border(
              right: BorderSide(width: 1, color: bordercolor),
              bottom: BorderSide(width: 1, color: bordercolor),
            )),
            child: Center(
              child: SizedBox(
                key: _globalKey,
                width: 110.w,
                height: 35.w,
                child: TextButton(
                  onPressed: () {
                    double _dialogOffsetX = _getPosition(_globalKey, "x");
                    double _dialogOffsetY = _getPosition(_globalKey, "y");
                    print(_dialogOffsetY);
                    print(-MediaQuery.of(context).size.height / 2);
                    showAlignedDialog(
                        offset: Offset(
                            -MediaQuery.of(context).size.width / 2 +
                                _dialogOffsetX +
                                50.w,
                            40.w),
                        barrierColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return AgeSelectDialog(
                            newClassAgeFunc: widget.newClassAgeFunc,
                            index: widget.newClassIndex,
                          );
                        });
                  },
                  child: Text(
                    widget.newClassAgeList,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: Color(0xff393838),
                    ),
                  ),
                ),
              ),
            )),
        // CustomTextFieldA((newValue) {
        //   widget.newClassAgeFunc(widget.newClassIndex, newValue);
        // }, 2),
        CustomTextFieldA((newValue) {
          widget.newClassCommentFunc(widget.newClassIndex, newValue);
        }, 3, true),
      ],
    );
  }
}

class AgeSelectDialog extends StatefulWidget {
  const AgeSelectDialog({
    Key? key,
    required this.newClassAgeFunc,
    required this.index,
  }) : super(key: key);
  final Function(int, String) newClassAgeFunc;
  final int index;

  @override
  State<AgeSelectDialog> createState() => _AgeSelectDialogState();
}

class _AgeSelectDialogState extends State<AgeSelectDialog> {
  List<int> buttonState = [0, 0, 0, 0, 0, 0];
  bool special = false;

  specialBtnOnOff(bool onOff) {
    if (onOff) {
      for (int i = 0; i < buttonState.length; i++) {
        buttonState[i] = 0;
      }
      special = true;
      widget.newClassAgeFunc(widget.index, "특수반");
    } else if (!onOff) {
      special = false;
      widget.newClassAgeFunc(widget.index, "");
    }
    setState(() {});
  }

  buttonOnOff(int index, bool onOff) {
    if (onOff) {
      special = false;
      if (buttonState.contains(1)) {
        if (buttonState.indexOf(1) > index) {
          for (int i = index; i < buttonState.indexOf(1); i++) {
            buttonState[i] = 4;
          }
          buttonState[index] = 2;
          buttonState[buttonState.indexOf(1)] = 3;
        } else if (buttonState.indexOf(1) < index) {
          for (int i = buttonState.indexOf(1) + 1; i < index; i++) {
            buttonState[i] = 4;
          }
          buttonState[index] = 3;
          buttonState[buttonState.indexOf(1)] = 2;
        }
      } else if (buttonState.contains(2)) {
        if (buttonState.indexOf(2) > index) {
          for (int i = index + 1; i < buttonState.indexOf(3); i++) {
            buttonState[i] = 4;
          }
          buttonState[index] = 2;
        } else if (buttonState.indexOf(2) < index &&
            buttonState.lastIndexOf(3) > index) {
          if (buttonState.indexOf(3) > index) {
            buttonState[index] = 2;
            for (int i = 0; i < index; i++) {
              buttonState[i] = 0;
            }
          }
        } else if (buttonState.lastIndexOf(3) < index) {
          for (int i = buttonState.lastIndexOf(3); i < index; i++) {
            buttonState[i] = 4;
          }
          buttonState[index] = 3;
        }
      } else {
        buttonState[index] = 1;
      }
      if (buttonState.contains(2)) {
        widget.newClassAgeFunc(
            widget.index,
            "만" +
                buttonState.indexOf(2).toString() +
                "~" +
                buttonState.indexOf(3).toString() +
                "세반");
      } else {
        widget.newClassAgeFunc(
            widget.index, "만" + buttonState.indexOf(1).toString() + "세반");
      }
    } else if (onOff == false) {
      if (buttonState.contains(2)) {
        if (buttonState.indexOf(2) == index) {
          if (buttonState.contains(4)) {
            buttonState[buttonState.indexOf(2)] = 0;
            buttonState[buttonState.indexOf(4)] = 2;
          } else {
            buttonState[buttonState.indexOf(2)] = 0;
            buttonState[buttonState.indexOf(3)] = 1;
          }
        } else if (buttonState.indexOf(3) == index) {
          if (buttonState.contains(4)) {
            buttonState[buttonState.indexOf(3)] = 0;
            buttonState[buttonState.lastIndexOf(4)] = 3;
          } else {
            buttonState[buttonState.indexOf(3)] = 0;
            buttonState[buttonState.indexOf(2)] = 1;
          }
        } else if (buttonState.indexOf(4) == index) {
          for (int i = buttonState.indexOf(4) + 1;
              i < buttonState.length;
              i++) {
            buttonState[i] = 0;
          }
          buttonState[buttonState.lastIndexOf(4)] = 3;
        } else if (buttonState.lastIndexOf(4) == index) {
          for (int i = buttonState.lastIndexOf(4) - 1; i >= 0; i--) {
            buttonState[i] = 0;
          }
          buttonState[buttonState.lastIndexOf(4)] = 2;
        } else if (buttonState[index] == 4) {
          for (int i = index + 1; i < buttonState.length; i++) {
            buttonState[i] = 0;
          }
          buttonState[buttonState.lastIndexOf(4)] = 3;
        }
      } else {
        buttonState[index] = 0;
      }
      if (buttonState.contains(2)) {
        widget.newClassAgeFunc(
            widget.index,
            "만" +
                buttonState.indexOf(2).toString() +
                "~" +
                buttonState.indexOf(3).toString() +
                "세반");
      } else if (buttonState.contains(1)) {
        widget.newClassAgeFunc(
            widget.index, "만" + buttonState.indexOf(1).toString() + "세반");
      } else {
        widget.newClassAgeFunc(widget.index, "");
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.w))),
        child: Container(
          width: 300.w,
          height: 50.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.w)),
            border: Border.all(width: 1, color: Color(0xFFA666FB)),
            color: Color(0xffffffff),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < buttonState.length; i++) ...[
                AgeButton(
                  buttonState: buttonState[i],
                  number: i,
                  buttonOnOff: buttonOnOff,
                ),
              ],
              SpecialButton(
                btnOnOff: special,
                btnOdOffFunc: specialBtnOnOff,
              )
            ],
          ),
        ));
  }
}

class SpecialButton extends StatefulWidget {
  const SpecialButton({
    Key? key,
    required this.btnOnOff,
    required this.btnOdOffFunc,
  }) : super(key: key);
  final bool btnOnOff;
  final Function(bool) btnOdOffFunc;

  @override
  State<SpecialButton> createState() => _SpecialButtonState();
}

class _SpecialButtonState extends State<SpecialButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.btnOdOffFunc(!widget.btnOnOff);
        });
      },
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: widget.btnOnOff == false ? Colors.white : Color(0xFFA666FB),
          borderRadius: BorderRadius.all(Radius.circular(20.w)),
        ),
        child: Center(
          child: Text(
            "특수",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: widget.btnOnOff == true ? Colors.white : Color(0xff393838),
            ),
          ),
        ),
      ),
    );
  }
}

class AgeButton extends StatefulWidget {
  const AgeButton({
    Key? key,
    required this.buttonState,
    required this.number,
    required this.buttonOnOff,
  }) : super(key: key);
  final int number;
  final int buttonState;
  final Function(int, bool) buttonOnOff;

  @override
  State<AgeButton> createState() => _AgeButtonState();
}

class _AgeButtonState extends State<AgeButton> {
  List<BorderRadius> _borderRadius = [
    BorderRadius.all(
      Radius.circular(0),
    ),
    BorderRadius.all(
      Radius.circular(20.w),
    ),
    BorderRadius.only(
      topLeft: Radius.circular(20.w),
      bottomLeft: Radius.circular(20.w),
    ),
    BorderRadius.only(
        topRight: Radius.circular(20.w), bottomRight: Radius.circular(20.w)),
    BorderRadius.all(
      Radius.circular(0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.buttonOnOff(
              widget.number, widget.buttonState == 0 ? true : false);
        });
      },
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: widget.buttonState == 0 ? Colors.white : Color(0xFFA666FB),
          borderRadius: _borderRadius[widget.buttonState],
        ),
        child: Center(
          child: Text(
            widget.number.toString(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: widget.buttonState != 0 ? Colors.white : Color(0xff393838),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldA extends StatelessWidget {
  final FormFieldSetter _onSaved;
  final int index;
  final bool last;

  const CustomTextFieldA(this._onSaved, this.index, this.last);

  @override
  Widget build(BuildContext context) {
    List<double> widthList = [180.w, 328.w, 120.w, 178.w];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: widthList[index],
            height: 40.w,
            decoration: BoxDecoration(
                border: last
                    ? Border(
                        bottom: BorderSide(width: 1, color: bordercolor),
                      )
                    : Border(
                        right: BorderSide(width: 1, color: bordercolor),
                        bottom: BorderSide(width: 1, color: bordercolor),
                      )),
            child: Center(
              child: TextFormField(
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

class ModifyClassDialog extends StatefulWidget {
  const ModifyClassDialog({
    Key? key,
    required this.reLoadTInfo,
    required this.reLoadCInfo,
    required this.year,
  }) : super(key: key);
  final Function reLoadCInfo;
  final Function reLoadTInfo;
  final int year;

  @override
  State<ModifyClassDialog> createState() => _ModifyClassDialog();
}

class _ModifyClassDialog extends State<ModifyClassDialog> {
  List<bool> checkList = [];
  List<String> classNameList = [];
  List<int> classTeacherList = [];
  List<String> classChildAgeList = [];
  List<String> classCommentList = [];
  List<int> teacherNumber = [];

  bool check = false;

  void checkOnOff(int index, bool checked) {
    setState(() {
      checkList[index] = checked;
      debugPrint('$checked');
      print("checkList(modify): $checkList");
    });
  }

  void changeClassName(int index, String newValue) {
    setState(() {
      classNameList[index] = newValue;
    });
  }

  void changeClassTeacher(int index, int newValue, int number) {
    setState(() {
      for (int i = 0; i < classTeacherList.length; i++) {
        if (newValue == 0) {
        } else {
          if (classTeacherList[i] == newValue) {
            classTeacherList[i] = 0;
            teacherNumber[i] = -1;
            checkList[i] = true;
          }
        }
      }
      classTeacherList[index] = newValue;
      teacherNumber[index] = number;
    });
  }

  void changeClassChildAge(int index, String newValue) {
    setState(() {
      classChildAgeList[index] = newValue;
    });
  }

  void changeClassComment(int index, String newValue) {
    setState(() {
      classCommentList[index] = newValue;
    });
  }

  correctionClass(List<int> cid, List<String> age, List<int> tid,
      List<String> comment, List<String> name, List<bool> checked) async {
    List<Map<String, dynamic>> correction = [];

    for (int i = 0; i < cid.length; i++) {
      if (checked[i] == true) {
        correction.add({
          'cid': cid[i],
          "age": age[i],
          "tid": tid[i],
          "name": name[i],
          "comment": comment[i],
        });
      }
    }
    CorrectionClass correctionClass =
        CorrectionClass(correctionList: correction);
    ApiUrl apiUrl = ApiUrl();
    http.Response res = await api(apiUrl.getClass, 'put', 'adminToken', correctionClass, context);
    if(res.statusCode == 200){
      widget.reLoadTInfo();
      widget.reLoadCInfo();
    }
  }

  @override
  initState() {
    super.initState();
    for (int i = 0; i < classNum; i++) {
      checkList.add(false);
      classNameList.add(classList[i].className);
      classTeacherList.add(classList[i].classTId);
      classChildAgeList.add(classList[i].classChildAge);
      classCommentList.add(classList[i].classComment);
      teacherNumber.add(-1);
      for (int j = 0;
          j <
              Provider.of<TeacherDataManagement>(context, listen: false)
                  .teacherList
                  .length;
          j++) {
        if (classTeacherList[i] ==
            Provider.of<TeacherDataManagement>(context, listen: false)
                .teacherList[j]
                .id) {
          teacherNumber[i] = j;
        }
      }
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
                    '학급 수정',
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
                      cTotalHeight: 40.w,
                      cTotalWidth: 50.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cBorderRadius: BorderRadius.only(topLeft: Radius.circular(10.w)),
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
                      ),
                    ),
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
                      cTotalHeight: 40.w,
                      cTotalWidth: 180.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                          child: AdminTableTextStyle(text: '학급 이름')),
                    ),
                    // Container(
                    //   width: 180.w,
                    //   height: 40.w,
                    //
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(
                    //       child: AdminTableTextStyle(text: '학급 이름')),
                    // ),
                    CustomContainer(
                      cTotalHeight: 40.w,
                      cTotalWidth: 328.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                          child: AdminTableTextStyle(text: '담당선생님')),
                    ),
                    // Container(
                    //   width: 328.w,
                    //   height: 40.w,
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(
                    //       child: AdminTableTextStyle(text: '담당선생님')),
                    // ),
                    CustomContainer(
                      cTotalHeight: 40.w,
                      cTotalWidth: 120.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                          child: AdminTableTextStyle(text: '학급 연령')),
                    ),
                    // Container(
                    //   width: 120.w,
                    //   height: 40.w,
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(
                    //       child: AdminTableTextStyle(text: '학급 연령')),
                    // ),
                    CustomContainer(
                      cTotalHeight: 40.w,
                      cTotalWidth: 180.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cBorderRadius: BorderRadius.only(topRight: Radius.circular(10.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget: Center(
                          child: AdminTableTextStyle(text: '코멘트')),
                    ),
                    // Container(
                    //   width: 180.w,
                    //   height: 40.w,
                    //   decoration: BoxDecoration(
                    //       borderRadius: const BorderRadius.only(
                    //         topRight: Radius.circular(10),
                    //       ),
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child:
                    //       const Center(child: AdminTableTextStyle(text: '코멘트')),
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
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const RangeMaintainingScrollPhysics(),
                        children: [
                          for (int i = 0; i < classNum; i++) ...[
                            ModifyClassListRow(
                              checkFunction: checkOnOff,
                              checkValue: checkList[i],
                              classIndex: i,
                              className: classNameList[i],
                              modifiedClassNameFunc: changeClassName,
                              classTeacher: classTeacherList[i],
                              modifiedClassTeacherFunc: changeClassTeacher,
                              classChildAge: classChildAgeList[i],
                              modifiedClassChildAgeFunc: changeClassChildAge,
                              classComment: classCommentList[i],
                              modifiedClassCommentFunc: changeClassComment,
                              teacherNumber: teacherNumber[i],
                            )
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
                              classIds.add(classList[i].classId);
                            }
                            correctionClass(
                                classIds,
                                classChildAgeList,
                                classTeacherList,
                                classCommentList,
                                classNameList,
                                checkList);

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
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w400)),
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

class ModifyClassListRow extends StatefulWidget {
  const ModifyClassListRow(
      {required this.checkFunction,
      required this.checkValue,
      required this.classIndex,
      required this.className,
      required this.modifiedClassNameFunc,
      required this.classTeacher,
      required this.modifiedClassTeacherFunc,
      required this.classChildAge,
      required this.modifiedClassChildAgeFunc,
      required this.classComment,
      required this.modifiedClassCommentFunc,
      required this.teacherNumber,
      Key? key})
      : super(key: key);
  final int teacherNumber;
  final Function(int, bool) checkFunction;
  final bool checkValue;
  final classIndex;
  final className;
  final Function(int, String) modifiedClassNameFunc;
  final classTeacher;
  final Function(int, int, int) modifiedClassTeacherFunc;
  final classChildAge;
  final Function(int, String) modifiedClassChildAgeFunc;
  final classComment;
  final Function(int, String) modifiedClassCommentFunc;

  @override
  State<ModifyClassListRow> createState() => _ModifyClassListRow();
}

class _ModifyClassListRow extends State<ModifyClassListRow> {
  List<String> teacherName = [];
  List<int> number = [];
  GlobalKey _globalKey = GlobalKey();

  _getPosition(GlobalKey key, String XY) {
    if (key.currentContext != null) {
      final RenderBox renderBox =
          key.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      if (XY == 'x') {
        return position.dx;
      } else {
        return position.dy;
      }
    }
  }

  List<DropdownMenuItem<int>> teacherList() {
    return number
        .map<DropdownMenuItem<int>>(
          (e) => DropdownMenuItem(
            enabled: true,
            alignment: Alignment.centerLeft,
            value: e,
            child: Text(
              teacherName[e],
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
            Provider.of<TeacherDataManagement>(context, listen: false)
                .teacherList
                .length;
        i++) {
      number.add(i);
      teacherName.add(Provider.of<TeacherDataManagement>(context, listen: false)
              .teacherList[i]
              .name +
          "(" +
          Provider.of<TeacherDataManagement>(context, listen: false)
              .teacherList[i]
              .email +
          ")");
    }
    teacherName.add("배정 취소");
    number.add(Provider.of<TeacherDataManagement>(context, listen: false)
        .teacherList
        .length);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.checkFunction(widget.classIndex, !widget.checkValue);
        });
      },
      child: SizedBox(
        width: 862.w,
        height: 40.w,
        child: Row(
          children: [
            SizedBox(
              width: 50.w,
              height: 50.w,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(width: 1, color: bordercolor),
                    bottom: BorderSide(width: 1, color: bordercolor),
                  ),
                ),
                child: Checkbox(
                    value: widget.checkValue,
                    onChanged: (value) {
                      setState(() {
                        widget.checkFunction(widget.classIndex, value!);
                      });
                    }),
              ),
            ),

            ///반이름
            CustomContainer(
              cTotalWidth: 180.w,
              cTotalHeight: 40.w,
              cInsideColor: const Color(0xffffffff),
              cBorderColor: const Color(0xfffbb348),
              cRightBorderWidth: 1.w,
              cBottomBorderWidth: 1.w,
              childWidget: ModifyClassTextField(widget.className, (newValue) {
                setState(() {
                  widget.modifiedClassNameFunc(widget.classIndex, newValue);
                });
              }, widget.checkValue),
            ),

            // Container(
            //   width: 180.w,
            //   height: 40.w,
            //   decoration: BoxDecoration(
            //       border: Border.all(color: bordercolor, width: 1.w)),
            //   child: ModifyClassTextField(widget.className, (newValue) {
            //     setState(() {
            //       widget.modifiedClassNameFunc(widget.classIndex, newValue);
            //     });
            //   }, widget.checkValue),
            // ),

            ///담당선생님
            Container(
              width: 328.w,
              height: 40.w,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(width: 1, color: bordercolor),
                  bottom: BorderSide(width: 1, color: bordercolor),
                ),
              ),
              child: Center(
                child: DropdownButton(
                  value:
                      widget.teacherNumber == -1 ? null : widget.teacherNumber,
                  elevation: 16,
                  items: teacherList(),
                  onChanged: (value) {
                    setState(() {
                      widget.checkFunction(widget.classIndex, true);
                      String num = value.toString();
                      int number = int.parse(num);

                      for (int i = 0; i < teacherList().length; i++) {
                        String _num = teacherList()[i].value.toString();
                        int _number = int.parse(_num);

                        if (teacherName[_number] == teacherName[number]) {
                          if (Provider.of<TeacherDataManagement>(context,
                                          listen: false)
                                      .teacherList
                                      .length -
                                  1 <
                              i) {
                            widget.modifiedClassTeacherFunc(
                                widget.classIndex, 0, -1);
                          } else {
                            widget.modifiedClassTeacherFunc(
                                widget.classIndex,
                                context
                                    .read<TeacherDataManagement>()
                                    .teacherList[i]
                                    .id,
                                number);
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

              // ModifyClassTextField(widget.classTeacher, (newValue) {
              //   setState(() {
              //     widget.modifiedClassTeacherFunc(widget.classIndex, newValue);
              //   });
              // }, widget.checkValue),
            ),

            ///학생수
            Container(
              key: _globalKey,
              width: 120.w,
              height: 40.w,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(width: 1, color: bordercolor),
                  bottom: BorderSide(width: 1, color: bordercolor),
                ),
              ),
              child: TextButton(
                onPressed: () {
                  double _dialogOffsetX = _getPosition(_globalKey, "x");
                  showAlignedDialog(
                      offset: Offset(
                          -MediaQuery.of(context).size.width / 2 +
                              _dialogOffsetX +
                              50.w,
                          40.w),
                      barrierColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext context) {
                        return AgeSelectDialog(
                          newClassAgeFunc: widget.modifiedClassChildAgeFunc,
                          index: widget.classIndex,
                        );
                      });
                },
                child: Text(
                  widget.classChildAge,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Color(0xff393838),
                  ),
                ),
              ),

            ),

            ///코멘트
            Container(
              width: 178.w,
              height: 40.w,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: bordercolor),
                ),
              ),
              child: Center(
                child: ModifyClassTextField(widget.classComment, (newValue) {
                  setState(() {
                    widget.modifiedClassCommentFunc(
                        widget.classIndex, newValue);
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

class ModifyClassTextField extends StatelessWidget {
  final bool onCheck;
  final String text;
  final FormFieldSetter _onSaved;

  const ModifyClassTextField(this.text, this._onSaved, this.onCheck, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            height: 37.w,
            child: onCheck == true
                ? TextFormField(
                    textAlign: TextAlign.center,
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
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.w, horizontal: 16.w),
                      enabledBorder: const OutlineInputBorder(
                        //borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.transparent, //textfield unfocused 테두리
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(10.w),
                        borderSide: const BorderSide(
                          color: Colors.transparent, //textfield focused 테두리
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(10.w),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(10.w),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white, //textfield 내부
                    ),
                  )
                // Container(
                //   width: 120.w,
                //   height: 40.w,
                //   decoration: BoxDecoration(
                //       border: Border.all(color: bordercolor, width: 1.w)),
                //   child: Center(child: Text(widget.name)),
                // ),
                : Center(
                    child: Text(
                      text,
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

class DismissClassDialog extends StatefulWidget {
  const DismissClassDialog({
    required this.reLoadTInfo,
    required this.reLoadCInfo,
    Key? key,
  }) : super(key: key);
  final Function reLoadCInfo;
  final Function reLoadTInfo;

  @override
  State<DismissClassDialog> createState() => _DismissClassDialog();
}

class _DismissClassDialog extends State<DismissClassDialog> {
  List<bool> checkList = []; // true : 삭제
  List<Color> colorList = [];

  void checkOnOff(int index, bool checked) {
    setState(() {
      checkList[index] = checked;
      if (checked == true) {
        colorList[index] = Colors.yellow;
      } else {
        colorList[index] = Colors.white;
      }
    });
  }

  @override
  initState() {
    super.initState();
    for (int i = 0; i < classNum; i++) {
      checkList.add(false);
      colorList.add(Colors.white);
    }
  }

  deleteClass(List<int> classNum) async {
    DeleteClass deleteClass = DeleteClass(deleteList: classNum);
    ApiUrl apiUrl = ApiUrl();
    http.Response res = await api(apiUrl.deleteClass, 'post', 'adminToken', deleteClass, context);
    if(res.statusCode == 200){
      widget.reLoadTInfo();
      widget.reLoadCInfo();
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
                    '학급 삭제',
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
                    SizedBox(width: 20.w),
                    CustomContainer(
                      cTotalWidth: 180.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cBorderRadius: BorderRadius.only(topLeft: Radius.circular(10.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget:
                      const Center(
                          child: AdminTableTextStyle(text: '학급 이름')),
                    ),
                    CustomContainer(
                      cTotalWidth: 328.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget:
                      const Center(
                          child: AdminTableTextStyle(text: '담당선생님')),
                    ),
                    // Container(
                    //   width: 328.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child: const Center(
                    //       child: AdminTableTextStyle(text: '담당선생님')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 120.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget:
                      const Center(
                          child: AdminTableTextStyle(text: '나이')),
                    ),
                    // Container(
                    //   width: 120.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child:
                    //       const Center(child: AdminTableTextStyle(text: '나이')),
                    // ),
                    CustomContainer(
                      cTotalWidth: 180.w,
                      cTotalHeight: 40.w,
                      cInsideColor: const Color(0xffFED796),
                      cBorderColor: const Color(0xffFDB43B),
                      cBorderRadius: BorderRadius.only(topRight: Radius.circular(10.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget:
                      const Center(
                          child: AdminTableTextStyle(text: '코멘트')),
                    ),
                    // Container(
                    //   width: 180.w,
                    //   height: 40.w,
                    //   margin: EdgeInsets.only(top: 46.w),
                    //   decoration: BoxDecoration(
                    //       borderRadius: const BorderRadius.only(
                    //         topRight: Radius.circular(10),
                    //       ),
                    //       border: Border.all(
                    //           width: 1, color: const Color(0xffFDB43B)),
                    //       color: const Color(0xffFED796)),
                    //   child:
                    //       const Center(child: AdminTableTextStyle(text: '코멘트')),
                    // ),
                  ],
                ),
                SingleChildScrollView(
                    child: Container(
                  width: 808.w,
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
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const RangeMaintainingScrollPhysics(),
                        children: [
                          for (int i = 0; i < classNum; i++) ...[
                            DismissClassListRow(
                              checkFunction: checkOnOff,
                              checkValue: checkList[i],
                              colorValue: colorList[i],
                              classIndex: i,
                              className: classList[i].className,
                              classTeacher: classList[i].classTeacher,
                              classChildAge:
                                  classList[i].classChildAge.toString(),
                              classComment: classList[i].classComment,
                            )
                          ]
                        ]),
                  ),
                )),
                SizedBox(height: 42.w),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                    onPressed: () {
                      List<int> classIds = [];
                      for (int i = 0; i < checkList.length; i++) {
                        if (checkList[i] == true) {
                          classIds.add(classList[i].classId);
                        }
                      }

                      deleteClass(classIds);

                      debugPrint('삭제');
                      setState(() {});
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

class DismissClassListRow extends StatefulWidget {
  const DismissClassListRow(
      {required this.checkFunction,
      required this.checkValue,
      required this.colorValue,
      required this.classIndex,
      required this.className,
      required this.classTeacher,
      required this.classChildAge,
      required this.classComment,
      Key? key})
      : super(key: key);
  final Function(int, bool) checkFunction;
  final bool checkValue;
  final Color colorValue;
  final classIndex;
  final className;
  final classTeacher;
  final classChildAge;
  final classComment;

  @override
  State<DismissClassListRow> createState() => _DismissClassListRow();
}

class _DismissClassListRow extends State<DismissClassListRow> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.checkFunction(widget.classIndex, !widget.checkValue);
        });
      },
      child: SizedBox(
        width: 808.w,
        height: 40.w,
        child: Row(
          children: [
            ///반이름
            CustomContainer(
              cTotalWidth: 180.w,
              cTotalHeight: 40.w,
              cInsideColor: widget.colorValue,
              cBorderColor: const Color(0xfffbb348),
              cRightBorderWidth: 1.w,
              cBottomBorderWidth: 1.w,
              childWidget:
                  Center(child: AdminTableTextStyle(text: widget.className)),
            ),

            ///담당선생님
            CustomContainer(
                cTotalWidth: 328.w,
                cTotalHeight: 40.w,
                cInsideColor: widget.colorValue,
                cBorderColor: const Color(0xfffbb348),
                cRightBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                    child: AdminTableTextStyle(text: widget.classTeacher))),

            ///아이수
            CustomContainer(
              cTotalWidth: 120.w,
              cTotalHeight: 40.w,
              cInsideColor: widget.colorValue,
              cBorderColor: const Color(0xfffbb348),
              cRightBorderWidth: 1.w,
              cBottomBorderWidth: 1.w,
              childWidget: Center(
                  child: AdminTableTextStyle(text: widget.classChildAge)),
            ),

            ///코멘트
            CustomContainer(
              cTotalWidth: 178.w,
              cTotalHeight: 40.w,
              cInsideColor: widget.colorValue,
              cBorderColor: const Color(0xfffbb348),
              cBottomBorderWidth: 1.w,
              childWidget:
                  Center(child: AdminTableTextStyle(text: widget.classComment)),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminTableTextStyle extends StatefulWidget {
  const AdminTableTextStyle({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<AdminTableTextStyle> createState() => _AdminTableTextStyleState();
}

class _AdminTableTextStyleState extends State<AdminTableTextStyle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
          fontSize: 16.w,
          fontWeight: FontWeight.w400,
          color: Color(0xff393838)),
    );
  }
}
