// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:treasure_map/b_admin/b5_1.dart';
import 'package:treasure_map/provider/teacher_data_management.dart';

import '../provider/parent_data_management.dart';

//------------------------유치원 학부모님들------------------------\\

int parentNum = 0;
List<Parent> parentList = [];

class B8_1 extends StatefulWidget {
  const B8_1({Key? key, required this.notifyParent}) : super(key: key);
  final Function(double, double)? notifyParent;

  @override
  State<B8_1> createState() => _B8_1State();
}

class _B8_1State extends State<B8_1> {

  GlobalKey globalkeyCK = GlobalKey();

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

  void refreshParent(int num, Parent newParent) {
    setState(() {
      parentNum = num;
      parentList.add(newParent);
    });
  }

  @override
  Widget build(BuildContext context) {
    parentNum = Provider.of<ParentDataManagement>(context, listen: false).parentNum;
    parentList = Provider.of<ParentDataManagement>(context, listen: false).parentList;
    return SingleChildScrollView(
      child: Row(
        children: [
          SizedBox(width: 80.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            key: globalkeyCK,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 55.01),
                child: Row(
                  children: [
                    SizedBox(
                        height: 32.w,
                        child: Text('학부모 목록',
                            style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF393838)))),
                  ],
                ),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60.w,
                          height: 40.w,
                          margin: EdgeInsets.only(top: 46.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.w),
                              ),
                              border: Border.all(
                                  width: 1.w, color: const Color(0xffFDB43B)),
                              color: const Color(0xffFED796)),
                          child: const Center(child: AdminTableTextStyle(text: '번호')),
                        ),
                        Container(
                          width: 200.w,
                          height: 40.w,
                          margin: EdgeInsets.only(top: 46.w),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.w, color: const Color(0xffFDB43B)),
                              color: const Color(0xffFED796)),
                          child: const Center(child: AdminTableTextStyle(text: '아이디')),
                        ),
                        Container(
                          width: 180.w,
                          height: 40.w,
                          margin: EdgeInsets.only(top: 46.w),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.w, color: const Color(0xffFDB43B)),
                              color: const Color(0xffFED796)),
                          child: const Center(child: AdminTableTextStyle(text:'아이반')),
                        ),
                        Container(
                          width: 100.w,
                          height: 40.w,
                          margin: EdgeInsets.only(top: 46.w),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: const Color(0xffFDB43B)),
                              color: const Color(0xffFED796)),
                          child: const Center(child: AdminTableTextStyle(text:'관계')),
                        ),
                        Container(
                          width: 140.w,
                          height: 40.w,
                          margin: EdgeInsets.only(top: 46.w),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: const Color(0xffFDB43B)),
                              color: const Color(0xffFED796)),
                          child: const Center(child: AdminTableTextStyle(text:'학부모이름')),
                        ),
                        Container(
                          width: 182.w,
                          height: 40.w,
                          margin: EdgeInsets.only(top: 46.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.w),
                              ),
                              border: Border.all(
                                  width: 1, color: const Color(0xffFDB43B)),
                              color: const Color(0xffFED796)),
                          child: const Center(child: AdminTableTextStyle(text:'학부모연락처')),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                        child: Container(
                            width: 862.w,
                            height: 235.w,
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
                                for (int i = 0; i < parentNum; i++) ...[
                                  ParentListRow(
                                    parentIndex: i,
                                    name: parentList[i].name,
                                    className: parentList[i].childClassName,
                                    phoneNum: parentList[i].phoneNum,
                                    id: parentList[i].id,
                                    relation: parentList[i].relation,
                                  )
                                ]
                              ]),
                            ))),
                    SizedBox(height: 150.w),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200.w,
                            height: 50.w,
                            //margin: EdgeInsets.only(left: 100.w),
                            child: ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ReigsterParentDialog(
                                        refresh: refreshParent,
                                      );
                                    });
                              },
                              child: Text('학부모 등록',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.w)),
                              style: ElevatedButton.styleFrom(
                                  elevation: 1.0,
                                  primary: const Color(0xFFA666FB),
                                  onPrimary: const Color(0xFFFFFFFF),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.w)),
                                  fixedSize: Size(200.w, 50.w)),
                            ),
                          ),

                          ///학부모 수정
                          Container(
                            width: 200.w,
                            height: 50.w,
                            margin: EdgeInsets.only(left: 50.w),
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    barrierColor: Colors.transparent,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const ModifyParentDialog();
                                    });
                              },
                              child: Text('학부모 수정',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.w)),
                              style: ElevatedButton.styleFrom(
                                  elevation: 1.0,
                                  primary: const Color(0xFFA666FB),
                                  onPrimary: const Color(0xFFFFFFFF),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.w)),
                                  fixedSize: Size(200.w, 50.w)),
                            ),
                          ),

                          ///학부모 해제
                          Container(
                            width: 200.w,
                            height: 50.w,
                            margin: EdgeInsets.only(left: 50.w),
                            child: ElevatedButton(
                              onPressed: () async {
                                await showDialog(
                                    barrierColor: Colors.transparent,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const DismissParentDialog();
                                    });
                              },
                              child: Text('학부모 등록 해제',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.w)),
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

                  ])
            ],
          ),
        ],
      ),
    );
  }
}

class ParentListRow extends StatefulWidget {
  const ParentListRow(
      {required this.parentIndex,
        required this.name,
        required this.className,
        required this.phoneNum,
        required this.id,
        required this.relation,
        Key? key})
      : super(key: key);
  final parentIndex;
  final name;
  final className;
  final phoneNum;
  final id;
  final relation;

  @override
  State<ParentListRow> createState() => _ParentListRowState();
}

class _ParentListRowState extends State<ParentListRow> {
  Color bordercolor = const Color(0xFFFBB348);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 862.w,
      height: 40.w,
      child: Row(
        children: [
          ///아이디
          Container(
            width: 59.w,
            height: 40.w,
            decoration: BoxDecoration(border: Border.all(color: bordercolor)),
            child: Center(child: AdminTableTextStyle(text:(widget.parentIndex+1).toString())),
          ),
          Container(
            width: 200.w,
            height: 40.w,
            decoration: BoxDecoration(border: Border.all(color: bordercolor)),
            child: Center(child: AdminTableTextStyle(text:widget.id)),
          ),


          ///아이반
          Container(
            width: 180.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border.all(color: bordercolor, width: 1.w)),
            child: Center(child: AdminTableTextStyle(text:widget.className)),
          ),
          ///관계
          Container(
            width: 100.w,
            height: 40.w,
            decoration: BoxDecoration(border: Border.all(color: bordercolor)),
            child: Center(
              child: AdminTableTextStyle(text:widget.relation),
            ),
          ),

          ///학부모이름
          Container(
            width: 140.w,
            height: 40.w,
            decoration: BoxDecoration(
                border: Border.all(color: bordercolor, width: 1.w)),
            child: Center(child: AdminTableTextStyle(text:widget.name)),
          ),

          ///학부모 연락처
          Container(
            width: 181.w,
            height: 40.w,
            decoration: BoxDecoration(border: Border.all(color: bordercolor)),
            child: Center(child: AdminTableTextStyle(text:widget.phoneNum)),
          ),

        ],
      ),
    );
  }
}

class ReigsterParentDialog extends StatefulWidget {
  const ReigsterParentDialog({
    required this.refresh,
    Key? key}) : super(key: key);
  final Function(int, Parent) refresh;

  @override
  State<ReigsterParentDialog> createState() => _ReigsterParentDialog();
}

class _ReigsterParentDialog extends State<ReigsterParentDialog> {
  int newParentNum = 0; //새로 추가될 항목

  List<String> childClassList = [];
  List<String> childNameList = [];
  List<String> relationList = [];
  List<String> parentNameList = [];
  List<String> parentPhoneNumList = [];
  void setNewChildClass(int index, String newValue) {
    setState(() {
      childClassList[index] = newValue;
    });
  }
  void setNewChildName(int index, String newValue) {
    setState(() {
      childNameList[index] = newValue;
    });
  }
  void setNewRelation(int index, String newValue) {
    setState(() {
      relationList[index] = newValue;
    });
  }
  void setNewParentName(int index, String newValue) {
    setState(() {
      parentNameList[index] = newValue;
    });
  }
  void setNewParentPhoneNum(int index, String newValue) {
    setState(() {
      parentPhoneNumList[index] = newValue;
    });
  }

  void setNewRow() {
    setState(() {
      childClassList.add('');
      childNameList.add('');
      relationList.add('엄마');
      parentNameList.add('');
      parentPhoneNumList.add('');
    });
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
                    '학부모 등록',
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
                      width: 148.w,
                      height: 40.w,
                      margin: EdgeInsets.only(left: 20.w, top: 46.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.w),
                          ),
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text:'아이반')),
                    ),
                    Container(
                      width: 80.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text:'아이이름')),
                    ),
                    Container(
                      width: 100.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text:'관계')),
                    ),
                    Container(
                      width: 80.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text:'학부모이름')),
                    ),
                    Container(
                      width: 156.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.w),
                          ),
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text:'학부모연락처')),
                    ),
                  ],
                ),
                SingleChildScrollView(
                    child: Container(
                      width: 564.w,
                      height: 235.w,
                      margin: EdgeInsets.only(left: 20.w),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.w),
                              bottomRight: Radius.circular(10.w)),
                          border: Border.all(
                              color: const Color(0xFFFBB348), width: 1.w)),
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: ListView(
                            padding: EdgeInsets.zero,
                            physics: const RangeMaintainingScrollPhysics(),
                            children: [
                          for(int i=0;i<newParentNum;i++)...[
                            ParentRegisterRow(
                                newParentIndex: i,
                                newParentChildClassNameFunc: setNewChildClass,
                                newParentChildNameFunc: setNewChildName,
                                newParentRelationFunc: setNewRelation,
                                newParentNameFunc: setNewParentName,
                                newParentPhoneNumFunc: setNewParentPhoneNum
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
                          setState(() {
                            setNewRow();
                            newParentNum++;
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

class ParentRegisterRow extends StatefulWidget {
  const ParentRegisterRow({
    required this.newParentIndex,
    required this.newParentChildClassNameFunc,
    required this.newParentChildNameFunc,
    required this.newParentRelationFunc,
    required this.newParentNameFunc,
    required this.newParentPhoneNumFunc,
    Key? key}) : super(key: key);
  final int newParentIndex;
  final Function(int, String) newParentChildClassNameFunc;
  final Function(int, String) newParentChildNameFunc;
  final Function(int, String) newParentRelationFunc;
  final Function(int, String) newParentNameFunc;
  final Function(int, String) newParentPhoneNumFunc;
  @override
  State<ParentRegisterRow> createState() => _ParentRegisterRow();
}

class _ParentRegisterRow extends State<ParentRegisterRow> {
  List<String> testdropdownlist = ['엄마', '아빠'];
  String testselectedDropdown = '엄마';
  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomTextFieldA((newValue) {
          widget.newParentChildClassNameFunc(widget.newParentIndex, newValue);
        }, 0),
        CustomTextFieldA((newValue) {
          widget.newParentChildNameFunc(widget.newParentIndex, newValue);
        }, 1),
        // CustomTextFieldA((newValue) {
        //   widget.newParentRelationFunc(widget.newParentIndex, newValue);
        // }, 2),
        Container(
          width: 100.w,
          height: 40.w,
          decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: const Color(0xffFDB43B)),
          ),
          child: Center(
            child: DropdownButton(
              underline: const SizedBox(),//to eliminate an underline of DropdownButton
              value: testselectedDropdown,
              items: testdropdownlist.map((String item) {
                return DropdownMenuItem<String>(
                  child: AdminTableTextStyle(text:item),
                  value: item,
                );
              }).toList(),
              onChanged: (dynamic newvalue) {
                setState(() {
                  testselectedDropdown = newvalue;
                  widget.newParentRelationFunc(widget.newParentIndex, testselectedDropdown);
                });
              },
            ),
          ),
        ),
        CustomTextFieldA((newValue) {
          widget.newParentNameFunc(widget.newParentIndex, newValue);
        }, 3),
        CustomTextFieldA((newValue) {
          widget.newParentPhoneNumFunc(widget.newParentIndex, newValue);
        }, 4),
      ],
    );
  }
}

class CustomTextFieldA extends StatelessWidget {
  final FormFieldSetter _onSaved;
  final int index;
  CustomTextFieldA(this._onSaved, this.index, {Key? key}) : super(key: key);

  List<double> width = [147.w, 80.w, 100.w, 80.w, 155.w];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: width[index],
            height: 40.w,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1, color: const Color(0xffFDB43B)),
            ),
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
                    borderSide: BorderSide(
                      color: Colors.transparent
                      //Colors.green, //textfield unfocused 테두리
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.w),
                    borderSide: const BorderSide(
                      color: Colors.transparent
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


class ModifyParentDialog extends StatefulWidget {
  const ModifyParentDialog({Key? key}) : super(key: key);

  @override
  State<ModifyParentDialog> createState() => _ModifyParentDialog();
}

class _ModifyParentDialog extends State<ModifyParentDialog> {
  List<bool> checkList = [];
  List<String> childClassNameList = [];
  List<String> childNameList = [];
  List<String> relationList = [];
  List<String> parentNameList = [];
  List<String> parentPhoneNumList = [];
  bool check = false;

  void checkOnOff(int index, bool checked) {
    setState(() {
      checkList[index] = checked;
    });
  }

  void changeClassName(int index, String newValue) {
    setState(() {
      childClassNameList[index] = newValue;
    });
  }

  void changeChildName(int index, String newValue) {
    setState(() {
      childNameList[index] = newValue;
    });
  }

  void changeRelation(int index, String newValue) {
    setState(() {
      relationList[index] = newValue;
    });
  }

  void changeParentName(int index, String newValue) {
    setState(() {
      parentNameList[index] = newValue;
    });
  }

  void changeParentPhoneNum(int index, String newValue) {
    setState(() {
      parentPhoneNumList[index] = newValue;
    });
  }

  @override
  initState() {
    super.initState();
    for (int i = 0; i < parentNum; i++) {
      checkList.add(false);
      childClassNameList.add(parentList[i].childClassName);
      childNameList.add(parentList[i].childName);
      relationList.add(parentList[i].relation);
      parentNameList.add(parentList[i].name);
      parentPhoneNumList.add(parentList[i].phoneNum);
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
                    '학부모 수정',
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
                      width: 148.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text:'아이반')),
                    ),
                    Container(
                      width: 80.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text:'아이이름')),
                    ),
                    Container(
                      width: 100.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text:'관계')),
                    ),
                    Container(
                      width: 80.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text:'학부모이름')),
                    ),
                    Container(
                      width: 156.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.w),
                          ),
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text:'학부모연락처')),
                    ),
                  ],
                ),
                SingleChildScrollView(
                    child: Container(
                      width: 614.w,
                      height: 235.w,
                      margin: EdgeInsets.only(left: 20.w),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.w),
                              bottomRight: Radius.circular(10.w)),
                          border: Border.all(
                              color: const Color(0xFFFBB348), width: 1.w)),
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: ListView(
                            padding: EdgeInsets.zero,
                            physics: const RangeMaintainingScrollPhysics(),
                            children: [
                          for (int i = 0; i < parentNum; i++) ...[
                            ModifyClassListRow(
                              checkFunction: checkOnOff,
                              checkValue: checkList[i],
                              parentIndex: i,
                              className: childClassNameList[i],
                              modifiedClassNameFunc: changeClassName,
                              childName: childNameList[i],
                              modifiedChildNameFunc: changeChildName,
                              relation: relationList[i],
                              modifiedRelationFunc: changeRelation,
                              parentName: parentNameList[i],
                              modifiedParentNameFunc: changeParentName,
                              parentPhoneNum: parentPhoneNumList[i],
                              modifiedParentPhoneNumFunc: changeParentPhoneNum,
                            )
                          ]
                        ]),
                      ),
                    )),
                SizedBox(height: 42.w),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
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
                      ElevatedButton(
                        onPressed: () {
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
      {
        required this.checkFunction,
        required this.checkValue,
        required this.parentIndex,
        required this.className,
        required this.modifiedClassNameFunc,
        required this.childName,
        required this.modifiedChildNameFunc,
        required this.relation,
        required this.modifiedRelationFunc,
        required this.parentName,
        required this.modifiedParentNameFunc,
        required this.parentPhoneNum,
        required this.modifiedParentPhoneNumFunc,
        Key? key})
      : super(key: key);
  final Function(int, bool) checkFunction;
  final bool checkValue;
  final parentIndex;
  final className;
  final Function(int, String) modifiedClassNameFunc;
  final childName;
  final Function(int, String) modifiedChildNameFunc;
  final relation;
  final Function(int, String) modifiedRelationFunc;
  final parentName;
  final Function(int, String) modifiedParentNameFunc;
  final parentPhoneNum;
  final Function(int, String) modifiedParentPhoneNumFunc;

  @override
  State<ModifyClassListRow> createState() => _ModifyClassListRow();
}

class _ModifyClassListRow extends State<ModifyClassListRow> {
  Color bordercolor = const Color(0xFFFBB348);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.checkFunction(widget.parentIndex, !widget.checkValue);
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
                        widget.checkFunction(widget.parentIndex, value!);
                      });
                    }),
              ),
            ),
            ///아이반
            Container(
              width: 148.w,
              height: 40.w,
              decoration: BoxDecoration(
                  border: Border.all(color: bordercolor, width: 1.w)
              ),
              child: ModifyClassTextField(widget.className, (newValue) {
                setState(() {
                  widget.modifiedClassNameFunc(widget.parentIndex, newValue);
                });
              }, widget.checkValue),
            ),

            ///아이이름
            Container(
              width: 80.w,
              height: 40.w,
              decoration: BoxDecoration(
                  border: Border.all(color: bordercolor, width: 1.w)),
              child: ModifyClassTextField(widget.childName, (newValue) {
                setState(() {
                  widget.modifiedChildNameFunc(widget.parentIndex, newValue);
                });
              }, widget.checkValue),
            ),


            ///관계
            Container(
              width: 100.w,
              height: 40.w,
              decoration: BoxDecoration(border: Border.all(color: bordercolor)),
              child: Center(
                child:  ModifyClassTextField(widget.relation, (newValue) {
                  setState(() {
                    widget.modifiedRelationFunc(widget.parentIndex, newValue);
                  });
                }, widget.checkValue),
              ),
            ),
            ///학부모이름
            Container(
              width: 80.w,
              height: 40.w,
              decoration: BoxDecoration(border: Border.all(color: bordercolor)),
              child: Center(
                child:  ModifyClassTextField(widget.parentName, (newValue) {
                  setState(() {
                    widget.modifiedParentNameFunc(widget.parentIndex, newValue);
                  });
                }, widget.checkValue),
              ),
            ),
            ///학부모연락처
            Container(
              width: 155.w,
              height: 40.w,
              decoration: BoxDecoration(border: Border.all(color: bordercolor)),
              child: Center(
                child:  ModifyClassTextField(widget.parentPhoneNum, (newValue) {
                  setState(() {
                    widget.modifiedParentPhoneNumFunc(widget.parentIndex, newValue);
                  });
                }, widget.checkValue),
              ),
            )
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

  const ModifyClassTextField(this.text, this._onSaved, this.onCheck,
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
            // Container(
            //   width: 120.w,
            //   height: 40.w,
            //   decoration: BoxDecoration(
            //       border: Border.all(color: bordercolor, width: 1.w)),
            //   child: Center(child: Text(widget.name)),
            // ),
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

class DismissParentDialog extends StatefulWidget {
  const DismissParentDialog({Key? key,}) : super(key: key);

  @override
  State<DismissParentDialog> createState() => _DismissParentDialog();
}

class _DismissParentDialog extends State<DismissParentDialog> {


  List<bool> checkList = [];// true : 삭제
  List<Color> colorList = [];

  void checkOnOff(int index, bool checked) {
    setState(() {
      checkList[index] = checked;
      debugPrint('$checked');
      debugPrint("checkList(dismiss): $checkList");
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
    for (int i = 0; i < parentNum; i++) {
      checkList.add(false);
      colorList.add(Colors.transparent);
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
                    '반 삭제',
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
                      width: 200.w,
                      height: 40.w,
                      margin: EdgeInsets.only(left: 20.w, top: 46.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.w),
                          ),
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text:'아이디')),
                    ),
                    Container(
                      width: 148.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text:'아이반')),
                    ),
                    Container(
                      width: 100.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text:'관계')),
                    ),
                    Container(
                      width: 80.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text:'학부모이름')),
                    ),
                    Container(
                      width: 156.w,
                      height: 40.w,
                      margin: EdgeInsets.only(top: 46.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.w),
                          ),
                          border: Border.all(
                              width: 1, color: const Color(0xffFDB43B)),
                          color: const Color(0xffFED796)),
                      child: const Center(child: AdminTableTextStyle(text:'학부모연락처')),
                    ),
                  ],
                ),
                SingleChildScrollView(
                    child: Container(
                      width: 686.w,
                      height: 235.w,
                      margin: EdgeInsets.only(left: 20.w),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.w),
                              bottomRight: Radius.circular(10.w)),
                          border: Border.all(
                              color: const Color(0xFFFBB348), width: 1.w)),
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: ListView(
                            padding: EdgeInsets.zero,
                            physics: const RangeMaintainingScrollPhysics(),
                            children: [
                          for (int i = 0; i < parentNum; i++) ...[
                            DismissParentListRow(
                              checkFunction: checkOnOff,
                              checkValue: checkList[i],
                              colorValue: colorList[i],
                              parentIndex: i,
                              id: parentList[i].id,
                              childClass: parentList[i].childClassName,
                              relation: parentList[i].relation,
                              parentName: parentList[i].name,
                              parentPhoneNum: parentList[i].phoneNum,
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
                          setState(() {});
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

class DismissParentListRow extends StatefulWidget {
  const DismissParentListRow({
    required this.checkFunction,
    required this.checkValue,
    required this.colorValue,
    required this.parentIndex,
    required this.id,
    required this.childClass,
    required this.relation,
    required this.parentName,
    required this.parentPhoneNum,
    Key? key})
      : super(key: key);
  final Function(int, bool) checkFunction;
  final bool checkValue;
  final Color colorValue;
  final parentIndex;
  final id;
  final childClass;
  final relation;
  final parentName;
  final parentPhoneNum;

  @override
  State<DismissParentListRow> createState() => _DismissParentListRow();
}

class _DismissParentListRow extends State<DismissParentListRow> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.checkFunction(widget.parentIndex, !widget.checkValue);
        });
      },
      child: SizedBox(
        width: 680.w,
        height: 40.w,
        child: Row(
          children: [
            ///아이디
            Container(
              width: 200.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: widget.colorValue,
                  border: Border.all(color: const Color(0xFFFBB348), width: 1.w)),
              child: Center(child: AdminTableTextStyle(text:widget.id)),
            ),

            ///아이반
            Container(
              width: 148.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: widget.colorValue,
                  border: Border.all(color: const Color(0xFFFBB348), width: 1.w)),
              child: Center(child: AdminTableTextStyle(text:widget.childClass)),
            ),

            ///관계
            Container(
              width: 100.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: widget.colorValue,
                  border: Border.all(color: const Color(0xFFFBB348))
              ),
              child: Center(child: AdminTableTextStyle(text:widget.relation)),
            ),

            ///학부모이름
            Container(
              width: 80.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: widget.colorValue,
                  border: Border.all(color: const Color(0xFFFBB348))
              ),
              child: Center(
                child: AdminTableTextStyle(text:widget.parentName),
              ),
            ),

            ///학부모연락처
            Container(
              width: 156.w,
              height: 40.w,
              decoration: BoxDecoration(
                  color: widget.colorValue,
                  border: Border.all(color: const Color(0xFFFBB348))
              ),
              child: Center(
                child: AdminTableTextStyle(text:widget.parentPhoneNum),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

