import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:treasure_map/d_play/d3_7.dart';

// import 'package:image_size_getter/file_input.dart';
import 'package:treasure_map/provider/app_management.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/dropdown_child.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:http/http.dart' as http;

import '../widgets/custom_container.dart';
import '../widgets/image_container.dart';
import '../widgets/nuri.dart';
import 'd3_1.dart';

///관찰기록 작성페이지
class D3_2 extends StatefulWidget {
  const D3_2({
    Key? key,
    required this.nextPage,
    required this.prePage,
    required this.nowPage,
    this.scaffoldKey,
    required this.recordId,
    this.routePage,
    required this.changePage,
  }) : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final int recordId;
  final Function(Widget)? routePage;
  final Function(int) changePage;

  @override
  State<D3_2> createState() => _D3_2State();
}

class _D3_2State extends State<D3_2> {
  bool dateOff = false;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';
  final ScrollController _scrollController = ScrollController();
  bool scrollState = true;
  double totalHeight = 910;

  totalHeightSet(double value) {
    setState(() {
      totalHeight = value;
    });
  }

  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    setState(() {});
  }

  scrollRemote(bool onOff) {
    setState(() {
      scrollState = onOff;
    });
  }

  ApiUrl apiUrl = ApiUrl();

  modifyRecord(String method, String value) async {
    http.Response res = await api(apiUrl.record, 'patch', 'signInToken', {
      "id": widget.recordId.toString(), method: value
    }, context);
    if (res.statusCode == 200) {}
  }

  deleteRecord() async {
    http.Response recordRes = await api(
        apiUrl.record +
            '/' + widget.recordId.toString(),
        'delete',
        'signInToken',
        {},
        context);
    if (recordRes.statusCode == 200) {
      widget.changePage(2);
    }
  }

  double scrollOffset = 0;

  @override
  initState() {
    receiveData(pageTime);
    _scrollController.addListener(() {
      setState(() {
        scrollOffset = _scrollController.offset;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.w),
          bottomLeft: Radius.circular(50.w),
        ),
        color: Color(0xffFCFCFC),
      ),
      child: Column(
        children: [
          OverTab(
            nextPage: widget.nextPage,
            prePage: widget.prePage,
            nowPage: widget.nowPage,
            dateOnOff: dateOff,
            receiveData: receiveData,
            scaffoldKey: widget.scaffoldKey,
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                physics: scrollState
                    ? const RangeMaintainingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: totalHeight.w,
                            color: const Color(0xffFCFCFC),
                          ),
                        ],
                      ),
                      CreateNewRecord(
                        recordId: widget.recordId,
                        modifyRecord: modifyRecord,
                        scrollOffset: scrollOffset,
                        scrollRemote: scrollRemote,
                        totalHeightSet: totalHeightSet,
                      ),
                    ],
                  ),
                  Container(
                    width: 39.w,
                    height: 30.w,
                    color: const Color(0xffFCFCFC),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 50.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: const Color(0xffFCFCFC),
                        ),
                      ),
                      SizedBox(
                        width: 944.w,
                      ),

                      // SizedBox(
                      //   width: 40.w,
                      // ),
                      GestureDetector(
                        onTap: () {
                          deleteRecord();
                          // getRecordData();
                          // newRecord();
                        },
                        child: Container(
                          width: 100.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.w)),
                              color: Color(0xffC6A2FC),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x29000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                )
                              ]),
                          child: Center(
                            child: Text(
                              '삭제',
                              style: TextStyle(
                                  color: Color(0xff7649B7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50.w)),
                          color: const Color(0xffFCFCFC),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateNewRecord extends StatefulWidget {
  const CreateNewRecord({
    Key? key,
    required this.recordId,
    required this.modifyRecord,
    required this.scrollOffset,
    required this.scrollRemote,
    required this.totalHeightSet,
  }) : super(key: key);
  final int recordId;
  final Function(String, String) modifyRecord;
  final double scrollOffset;
  final Function(bool) scrollRemote;
  final Function(double) totalHeightSet;

  @override
  State<CreateNewRecord> createState() => _CreateNewRecordState();
}

class _CreateNewRecordState extends State<CreateNewRecord> {
  Color borderColor = const Color(0x9dC13BFD);

  List<String> weekDay = ["", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];

  TextEditingController content = TextEditingController();
  TextEditingController environmentalSupport = TextEditingController();
  TextEditingController emotionalSupport = TextEditingController();
  TextEditingController linguisticSupport = TextEditingController();

  List<Image?> signImage = [];

  List<DropDownChildInfo> dropDownChildInfo = [];
  List<DropDownChildInfo> checkedChild = [];
  int childId = 0;
  int selectIndex = 0;

  ApiUrl apiUrl = ApiUrl();

  bool onOff = false;
  var recordData;

  DateTime? nowDate;

  Nuri nuri = Nuri();

  bool selectWidget = false;
  double selectWidgetPosition = 0;

  String recordMethod = '';
  List<int> nuriTextOverLength = [];

  var recordThemeData;

  List<bool> shareReportBtn = [
    false,
    false,
    false,
    false,
  ];

  selectOnOff(bool onOff, String method) async {
    await getTheme(method);
    setState(() {
      recordMethod = method;
      selectWidget = onOff;
      selectWidgetPosition = widget.scrollOffset;
    });
  }

  getTheme(String method) async {
    http.Response recordThemeRes = await api(
        apiUrl.recordTheme +
            '?' +
            'cid=' +
            Provider
                .of<UserInfo>(context, listen: false)
                .value[0].toString() +
            '&type=' +
            method +
            '',
        'get',
        'signInToken',
        {},
        context);
    if (recordThemeRes.statusCode == 200) {
      var recordThemeRB = utf8.decode(recordThemeRes.bodyBytes);
      recordThemeData = jsonDecode(recordThemeRB);
    }
  }

  List<GlobalKey> globalKeyThisWidget = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  Offset? position;

  getPosition(GlobalKey key) {
    if (key.currentContext != null) {
      final RenderBox renderBox =
      key.currentContext!.findRenderObject() as RenderBox;
      position = renderBox.localToGlobal(Offset.zero);
      return position;
    }
  }

  setChildId(int newValue, int index) {
    setState(() {
      childId = newValue;
      selectIndex = index;
    });
  }
  bool imageDraw = false;

  getRecordData() async {
    // imageDraw = false;
    recordData = null;
    http.Response recordRes = await api(
        apiUrl.record + '/' + widget.recordId.toString(),
        'get',
        'signInToken',
        {},
        context);
    if (recordRes.statusCode == 200) {

      var recordRB = utf8.decode(recordRes.bodyBytes);
      recordData = jsonDecode(recordRB);
      checkedChild.clear();
      for (int i = 0; i < recordData["children"].length; i++) {
        checkedChild.add(DropDownChildInfo(
            childName: recordData["children"][i],
            childId: recordData["childIds"][i]));
      }
      makeDropDownData();

        content.text = recordData["content"] ?? '';
        environmentalSupport.text = recordData["environmentalSupport"] ?? '';
        emotionalSupport.text = recordData["emotionalSupport"] ?? '';
        linguisticSupport.text = recordData["linguisticSupport"] ?? '';


        if (recordData["time"] == null) {
          nowDate = DateTime.parse(recordData['date'] + " 00:00");
        } else {
          nowDate =
              DateTime.parse(recordData['date'] + ' ' + recordData['time']);
        }
        shareReportBtn[0] = recordData['daily'];

      totalHeight = 910;
      nuriTextOverLength = [];
      for (int i = 0; i < recordData["children"].length; i++) {
        nuriTextOverLength.add(0);
        totalHeight = totalHeight + 40 + (recordData["nuri"][i].length < 1
            ? 0
            : (recordData["nuri"][i].length) - 1) * 27;
        for(int j = 0; j < recordData["nuri"][i].length;j++){
          if(nuri.areaCommentary[recordData['nuriAge']][int
              .parse(
              recordData["nuri"][i][j]
                  .split('')[0]) - 1][int
              .parse(
              recordData["nuri"][i][j]
                  .split('')[1]) - 1]
          [int
              .parse(
              recordData["nuri"][i][j]
                  .split('')[2]) - 1].length > 25){
            nuriTextOverLength[i]++;
          }
        }
        totalHeight = totalHeight + nuriTextOverLength[i] * 20;
      }
      widget.totalHeightSet(totalHeight);
      signImage.clear();

      if (recordData['teacherSign'] != null) {
        signImage.add(
            await imageApi(recordData['teacherSign'], 'signInToken', context));
      } else {
        signImage.add(null);
      }
      if (recordData['viceDirectorSign'] != null) {
        signImage.add(await imageApi(
            recordData['viceDirectorSign'], 'signInToken', context));
      } else {
        signImage.add(null);
      }
      if (recordData['directorSign'] != null) {
        signImage.add(
            await imageApi(recordData['directorSign'], 'signInToken', context));
      } else {
        signImage.add(null);
      }

      imageDraw = true;
      setState(() {});
    }
  }



  getChildData() async {
    var formatter = DateFormat('yyyyMMdd');
    String toDayStr = formatter.format(DateTime.now());
    http.Response childRes =
    await api('${apiUrl.child}/$toDayStr?cid=${Provider.of<UserInfo>(context, listen: false).value[0]}', 'get', 'signInToken', {}, context);
    if (childRes.statusCode == 200) {
      var childRB = utf8.decode(childRes.bodyBytes);
      var childData = jsonDecode(childRB);

      setState(() {
        dropDownChildInfo.clear();
        for (int i = 0; i < childData.length; i++) {
          dropDownChildInfo.add(DropDownChildInfo(
              childName: childData[i]['name'], childId: childData[i]['id']));
        }
      });
    }
  }

  patchSign() async {
    http.Response childRes =
    await api(apiUrl.recordSign, 'patch', 'signInToken', {
      'id': widget.recordId.toString()
    }, context);
    if (childRes.statusCode == 200) {
      getRecordData();
    }
  }

  deleteNuri(int childId, String nuriCode) async {
    http.Response delNuriRes = await api(
        '${apiUrl.recordNuri}/${widget.recordId.toString()}/$childId/$nuriCode',
        'delete', 'signInToken', {}, context);
    if (delNuriRes.statusCode == 200) {
      await getRecordData();
      // totalHeight = 910;
      // for (int i = 0; i < recordData["children"].length; i++) {
      //   totalHeight = totalHeight + 40.w + (recordData["nuri"][i].length < 1
      //       ? 0
      //       : (recordData["nuri"][i].length) - 1) * 27.w;
      // }
      // widget.totalHeightSet(totalHeight);
    }
  }

  postRecordChild(int _id) async {
    http.Response recordRes = await api(
        apiUrl.recordChild,
        'post',
        'signInToken',
        {'id': widget.recordId.toString(), 'cid': _id.toString()},
        context);
    if (recordRes.statusCode == 200) {
      await getRecordData();
      // totalHeight = 910;
      // for (int i = 0; i < recordData["children"].length; i++) {
      //   totalHeight = totalHeight + 40.w + (recordData["nuri"][i].length < 1
      //       ? 0
      //       : (recordData["nuri"][i].length) - 1) * 27.w;
      // }
      // widget.totalHeightSet(totalHeight);
    }
  }

  deleteRecordChild(int _id) async {
    http.Response recordRes = await api(
        apiUrl.recordChild +
            '/' +
            widget.recordId.toString() +
            '/' +
            _id.toString(),
        'delete',
        'signInToken',
        {},
        context);
    if (recordRes.statusCode == 200) {
      recordSetting();
      totalHeight = 910;
      for (int i = 0; i < recordData["children"].length; i++) {
        // totalHeight = totalHeight + (60.w +
        //     (recordData["nuri"][i].length < 3 ? 0 : (recordData["nuri"][i]
        //         .length - 2)) * 28.w);
        totalHeight = totalHeight + 40.w + (recordData["nuri"][i].length < 1
            ? 0
            : (recordData["nuri"][i].length) - 1) * 27.w;
      }
      widget.totalHeightSet(totalHeight);
    }
  }

  dachBetweenNumber(String str) {
    String value = str.replaceAllMapped(
        RegExp(r".{1}"), (match) => "${match.group(0)}-");
    value = value.substring(0, value.length - 1);
    return value;
  }

  makeDropDownData() {
    for (int i = 0; i < checkedChild.length; i++) {
      if (dropDownChildInfo
          .indexWhere((menu) => menu.childId == checkedChild[i].childId) !=
          -1) {
        dropDownChildInfo.removeAt(dropDownChildInfo
            .indexWhere((menu) => menu.childId == checkedChild[i].childId));
      }
    }
  }

  recordSetting() async {
    await getChildData();
    await getRecordData();
    setState(() {
      onOff = true;
    });
  }

  @override
  void initState() {
    recordSetting();
    // TODO: implement initState
    super.initState();
  }

  double totalHeight = 910;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Container(
            width: 1053.w,
            height: totalHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.w),
                  topLeft: Radius.circular(20.w)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x29B1B1B1),
                  blurRadius: 6,
                  offset: Offset(-2, 2),
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 50.w,
                      cTotalWidth: 553.w,
                      cBorderRadius:
                      BorderRadius.only(topLeft: Radius.circular(20.w)),
                      cInsideColor: Color(0xffE5D0FE),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text:
                          Provider
                              .of<UserInfo>(context, listen: false)
                              .value[2] +
                              "의 놀이관찰기록",
                          title: true,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        // TimeOfDay? newTime = await showTimePicker(
                        //     initialEntryMode: TimePickerEntryMode.inputOnly,
                        //     context: context,
                        //     initialTime: TimeOfDay(
                        //         hour: DateTime.now().hour,
                        //         minute: DateTime.now().minute));
                        showDialog(
                            context: context, builder: (BuildContext context) {
                          return AijoaTimePicker(getRecordData: getRecordData,
                            modifyRecord: widget.modifyRecord,);
                        });


                        // if (newTime != null) {
                        //   await widget.modifyRecord(
                        //       'time',
                        //       newTime.hour.toString() +
                        //           ':' +
                        //           newTime.minute.toString());
                        //   getRecordData();
                        // }
                      },
                      child: CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 50.w,
                        cTotalWidth: 500.w,
                        cBorderRadius:
                        BorderRadius.only(topRight: Radius.circular(20.w)),
                        cInsideColor: Color(0xffCAACF2),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cRightBorderWidth: 1.w,
                        childWidget: Center(
                          child: RecordTableTextStyle(
                            text: nowDate == null
                                ? ''
                                : nowDate!.year.toString() +
                                '년 ' +
                                nowDate!.month.toString() +
                                '월 ' +
                                nowDate!.day.toString() +
                                '일 ' +
                                weekDay[nowDate!.weekday] +
                                ' ' +
                                nowDate!.hour.toString() +
                                '시 ' +
                                nowDate!.minute.toString() +
                                '분',
                            title: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 276.5.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: "생활주제",
                          title: true,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 276.5.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: "주제",
                          title: true,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 500.w,
                      cInsideColor: Color(0xffE5D0FE),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: "결재",
                          title: true,
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 70.w,
                      cTotalWidth: 276.5.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: recordData != null
                            ? RecordTextField(
                          method: 'mainTheme',
                          value: recordData['mainTheme'],
                          modifyRecord: widget.modifyRecord,
                          getRecordData: getRecordData,
                          globalKey: globalKeyThisWidget[0],
                          selectWidgetOnOff: selectOnOff,
                          widgetPositionSave: getPosition,
                        )
                            : RecordTextField(
                          method: 'mainTheme',
                          value: '',
                          modifyRecord: widget.modifyRecord,
                          getRecordData: getRecordData,
                          globalKey: globalKeyThisWidget[0],
                          selectWidgetOnOff: selectOnOff,
                          widgetPositionSave: getPosition,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 70.w,
                      cTotalWidth: 276.5.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: recordData != null
                            ? RecordTextField(
                          method: 'theme',
                          value: recordData['theme'],
                          modifyRecord: widget.modifyRecord,
                          getRecordData: getRecordData,
                          globalKey: globalKeyThisWidget[1],
                          selectWidgetOnOff: selectOnOff,
                          widgetPositionSave: getPosition,
                        )
                            : RecordTextField(
                          method: 'theme',
                          value: '',
                          modifyRecord: widget.modifyRecord,
                          getRecordData: getRecordData,
                          globalKey: globalKeyThisWidget[1],
                          selectWidgetOnOff: selectOnOff,
                          widgetPositionSave: getPosition,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 70.w,
                      cTotalWidth: 86.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '담임',
                          title: true,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        patchSign();
                      },
                      child: CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 70.w,
                        cTotalWidth: 80.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        childWidget: Center(
                          child: signImage.isNotEmpty ? signImage[0] ??
                              Container() : Container(),
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 70.w,
                      cTotalWidth: 87.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '원감',
                          title: true,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        patchSign();
                      },
                      child: CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 70.w,
                        cTotalWidth: 80.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        childWidget: Center(
                          child: signImage.length >1 ? signImage[1] ??
                              Container() : Container(),
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 70.w,
                      cTotalWidth: 87.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '원장',
                          title: true,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        patchSign();
                      },
                      child: CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 70.w,
                        cTotalWidth: 80.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cRightBorderWidth: 1.w,
                        childWidget: Center(
                          child: signImage.length > 2 ? signImage[2] ??
                              Container() : Container(),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 276.5.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: "소주제",
                          title: true,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 276.5.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: "놀이소주제",
                          title: true,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 250.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: "놀이주제",
                          title: true,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 250.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: "공간",
                          title: true,
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 70.w,
                      cTotalWidth: 276.5.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: recordData != null
                            ? RecordTextField(
                          method: 'subTheme',
                          value: recordData['subTheme'],
                          modifyRecord: widget.modifyRecord,
                          getRecordData: getRecordData,
                          globalKey: globalKeyThisWidget[2],
                          selectWidgetOnOff: selectOnOff,
                          widgetPositionSave: getPosition,
                        )
                            : RecordTextField(
                          method: 'subTheme',
                          value: '',
                          modifyRecord: widget.modifyRecord,
                          getRecordData: getRecordData,
                          globalKey: globalKeyThisWidget[2],
                          selectWidgetOnOff: selectOnOff,
                          widgetPositionSave: getPosition,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 70.w,
                      cTotalWidth: 276.5.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: recordData != null
                            ? RecordTextField(
                          method: 'subject',
                          value: recordData['subject'],
                          modifyRecord: widget.modifyRecord,
                          getRecordData: getRecordData,
                          globalKey: globalKeyThisWidget[3],
                          selectWidgetOnOff: selectOnOff,
                          widgetPositionSave: getPosition,
                        )
                            : RecordTextField(
                          method: 'subject',
                          value: '',
                          modifyRecord: widget.modifyRecord,
                          getRecordData: getRecordData,
                          globalKey: globalKeyThisWidget[3],
                          selectWidgetOnOff: selectOnOff,
                          widgetPositionSave: getPosition,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 70.w,
                      cTotalWidth: 250.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: recordData != null
                            ? RecordTextField(
                          method: 'subject',
                          value: recordData['subject'],
                          modifyRecord: widget.modifyRecord,
                          getRecordData: getRecordData,
                          globalKey: globalKeyThisWidget[4],
                          selectWidgetOnOff: selectOnOff,
                          widgetPositionSave: getPosition,
                        )
                            : RecordTextField(
                          method: 'subject',
                          value: '',
                          modifyRecord: widget.modifyRecord,
                          getRecordData: getRecordData,
                          globalKey: globalKeyThisWidget[4],
                          selectWidgetOnOff: selectOnOff,
                          widgetPositionSave: getPosition,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 70.w,
                      cTotalWidth: 250.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget: Center(
                        child: recordData != null
                            ? RecordTextField(
                          method: 'space',
                          value: recordData['space'],
                          modifyRecord: widget.modifyRecord,
                          getRecordData: getRecordData,
                          globalKey: globalKeyThisWidget[5],
                          selectWidgetOnOff: selectOnOff,
                          widgetPositionSave: getPosition,
                        )
                            : RecordTextField(
                          method: 'space',
                          value: '',
                          modifyRecord: widget.modifyRecord,
                          getRecordData: getRecordData,
                          globalKey: globalKeyThisWidget[5],
                          selectWidgetOnOff: selectOnOff,
                          widgetPositionSave: getPosition,
                        ),
                      ),
                    ),
                  ],
                ),


                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      onPanStart: (DragStartDetails dragStartDetails) {},
                      child: CustomContainer(
                          cBorderColor: borderColor,
                          cTotalHeight: 250.w,
                          cTotalWidth: 464.w,
                          cInsideColor: Color(0xffffffff),
                          cTopBorderWidth: 1.w,
                          cLeftBorderWidth: 1.w,
                          childWidget: Stack(
                            children: [
                              if(imageDraw)...[
                                if(recordData != null)...[
                                  for(int i = 0; i <
                                      recordData['imagePaths'].length; i++)...[
                                    for(int j = 0; j<recordData['imagePaths'].length; j++)...[
                                      if(recordData['ls'][j] == i+1)...[
                                        ImageContainer(
                                          rid : widget.recordId,
                                          scrollController: widget.scrollRemote,
                                          imagePath: recordData['imagePaths'][j],
                                          imageId: recordData['imageIds'][j],
                                          positionX: recordData['xs'][j].toDouble(),
                                          positionY: recordData['ys'][j].toDouble(),
                                          totalWidth: recordData['ws'][j].toDouble(),
                                          totalHeight: recordData['hs'][j].toDouble(),
                                          level: recordData['ls'][j],
                                          index: i,
                                          getRecordData: getRecordData,
                                        ),
                                      ]
                                    ]
                                  ]
                                ]
                              ]

                            ],
                          )
                      ),
                    ),


                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 250.w,
                      cTotalWidth: 589.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget:
                      Focus(
                        onFocusChange: (hasFocus) async {
                          if (hasFocus) {} else {
                            print("hasfocus");
                            // widget.selectWidgetOnOff(false);
                            if (recordData["content"] ==
                                content.text) {
                              print("!hasfocus same text");
                            } else {
                              print("!hasfocus diff text");
                              await widget.modifyRecord(
                                  'content', content.text);
                              getRecordData();
                            }
                          }
                        },
                        child:
                        TextField(
                          onTapOutside: (PointerDownEvent event) async {
                          },
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ), //외곽선
                          ),
                          controller: content,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff393838)),
                          maxLines: 20,
                        ),

                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 100.w,
                      cInsideColor: Color(0xffE5D0FE),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: "놀이참여유아",
                          title: true,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 953.w,
                      cInsideColor: Color(0xffE5D0FE),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: "누리과정관련요소",
                          title: true,
                        ),
                      ),
                    ),
                  ],
                ),
                if (recordData != null) ...[
                  for (int i = 0; i < recordData["children"].length; i++) ...[
                    Row(
                      children: [
                        CustomContainer(
                          cBorderColor: borderColor,
                          cTotalHeight: 40.w + (recordData["nuri"][i].length < 1
                              ? 0
                              : (recordData["nuri"][i].length) - 1) * 27 + nuriTextOverLength[i] * 20.w,
                          cTotalWidth: 100.w,
                          cInsideColor: Color(0xffCAACF2),
                          cTopBorderWidth: 1.w,
                          cLeftBorderWidth: 1.w,
                          childWidget: Stack(
                            children: [
                              Center(
                                child: RecordTableTextStyle(
                                  text: recordData["children"][i],
                                  title: true,
                                ),
                              ),
                              Positioned(
                                  top: 2.w,
                                  right: 2.w,
                                  child: GestureDetector(
                                    onTap: () {
                                      deleteRecordChild(
                                          recordData["childIds"][i]);
                                      makeDropDownData();
                                    },
                                    child: Container(
                                        width: 25.w,
                                        height: 25.w,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0x29505050),
                                                  offset: Offset(2, 2),
                                                  blurRadius: 6)
                                            ]
                                          // color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Icon(Icons.do_not_disturb_on,
                                              size: 25.w, color: Colors.white),
                                        )),
                                  ))
                            ],
                          ),
                        ),
                        CustomContainer(
                            cBorderColor: borderColor,
                            cTotalHeight: 40.w + (recordData["nuri"][i].length <
                                1 ? 0 : (recordData["nuri"][i].length) - 1 ) * 27 + nuriTextOverLength[i] * 20
                                .w,
                            cTotalWidth: 953.w,
                            cInsideColor: Color(0xffffffff),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            childWidget: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (int j = 0;
                                j < nuri.area[recordData['nuriAge']].length;
                                j++) ...[
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ChoiceNuriContent(
                                              nuriNumber: j,
                                              age: recordData["nuriAge"],
                                              childId: recordData['childIds'][i],
                                              recordId: widget.recordId,
                                              getRecordData: getRecordData,
                                            );
                                          });
                                    },
                                    child: Container(
                                      width: 70.w,
                                      height: 40.w +
                                          (recordData["nuri"][i].length < 1
                                              ? 0
                                              : (recordData["nuri"][i].length) -
                                              1) * 27 + nuriTextOverLength[i] * 20.w,
                                      decoration: BoxDecoration(
                                        border: Border(
                                            right:
                                            BorderSide(color: borderColor)),
                                        color: Color(0xffE5E5E5),
                                      ),
                                      child: Center(
                                        child: RecordTableTextStyle(
                                          title: true,
                                          text: nuri
                                              .area[recordData['nuriAge']][j],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for(int j = 0; j <
                                        recordData["nuri"][i].length; j++)...[
                                      Row(

                                        children: [
                                          Container(
                                            width: (953 - 70 * nuri.area[recordData['nuriAge']].length - 60).w,
                                            child: RecordTableTextStyle(
                                              text: 'ㆍ' + nuri
                                                .area[recordData['nuriAge']][int
                                                .parse(
                                                recordData["nuri"][i][j].split(
                                                    '')[0]) - 1] +
                                                ' : ' +
                                                nuri
                                                    .areaContent[recordData['nuriAge']][int
                                                    .parse(
                                                    recordData["nuri"][i][j]
                                                        .split('')[0]) - 1][int
                                                    .parse(
                                                    recordData["nuri"][i][j]
                                                        .split('')[1]) - 1] +
                                                '(' +
                                                nuri
                                                    .areaCommentary[recordData['nuriAge']][int
                                                    .parse(
                                                    recordData["nuri"][i][j]
                                                        .split('')[0]) - 1][int
                                                    .parse(
                                                    recordData["nuri"][i][j]
                                                        .split('')[1]) - 1][int
                                                    .parse(
                                                    recordData["nuri"][i][j]
                                                        .split('')[2]) - 1] +
                                                ')',
                                              title: false,
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15.w,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              deleteNuri(
                                                  recordData['childIds'][i],
                                                  recordData['nuri'][i][j]);
                                            },
                                            child: Container(
                                                width: 40.w,
                                                height: 25.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(5.w)),
                                                  color: Color(0xffFED796),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0x29505050),
                                                      blurRadius: 6,
                                                      offset: Offset(1,
                                                          1), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '삭제',
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: Color(0xff393838),
                                                    ),
                                                  ),
                                                )),
                                          ),

                                        ],
                                      )
                                    ]

                                  ],
                                ),

                              ],
                            )),
                      ],
                    ),
                  ],
                ],
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 60.w,
                  cTotalWidth: 1053.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cRightBorderWidth: 1.w,
                  childWidget: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 222.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.w)),
                          color: Color(0xffffffff),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 17.w,
                            ),
                            Container(
                                width: 150.w,
                                height: 25.w,
                                color: Colors.white,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (onOff) ...[
                                        ChildDropDownButton(
                                          setChildId: setChildId,
                                          dropDownChildInfo:
                                          dropDownChildInfo,
                                        ),
                                      ]
                                    ])),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                if (childId != 0) {
                                  setState(() {
                                    onOff = false;
                                    postRecordChild(childId);
                                    childId = 0;
                                  });
                                  Future.delayed(
                                      const Duration(milliseconds: 300), () {
                                    setState(() {
                                      onOff = true;
                                    });
                                  });
                                } else {}
                              },
                              child: Container(
                                width: 40.w,
                                height: 25.w,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.w)),
                                  // border: Border.all(width: 1.w, color: borderColor),
                                  color: Color(0xffC6A1FF),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x29000000),
                                      blurRadius: 6,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '추가',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff7748BA),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   width: 17.w,
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 60.w,
                      cTotalWidth: 100.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: "유아관심",
                          title: true,
                        ),
                      ),
                    ),
                    CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 60.w,
                        cTotalWidth: 953.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cRightBorderWidth: 1.w,
                        childWidget: Center(
                          child: recordData != null
                              ? RecordTextField(
                            method: 'interest',
                            value: recordData["interest"],
                            modifyRecord: widget.modifyRecord,
                            getRecordData: getRecordData,
                            globalKey: globalKeyThisWidget[7],
                            selectWidgetOnOff: selectOnOff,
                            widgetPositionSave: getPosition,
                          )
                              : RecordTextField(
                            method: 'interest',
                            value: '',
                            modifyRecord: widget.modifyRecord,
                            getRecordData: getRecordData,
                            globalKey: globalKeyThisWidget[7],
                            selectWidgetOnOff: selectOnOff,
                            widgetPositionSave: getPosition,
                          ),
                        )),
                  ],
                ),

                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 1053.w,
                      cInsideColor: Color(0xffE5D0FE),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: "놀이지원실제",
                          title: true,
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 351.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: "환경적지원",
                          title: true,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 351.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: "정서적지원",
                          title: true,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 351.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: "언어적 지원",
                          title: true,
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 90.w,
                      cTotalWidth: 351.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget:


                      Center(
                        child: Focus(
                          onFocusChange: (hasFocus) async {
                            if (hasFocus) {} else {
                              // widget.selectWidgetOnOff(false);
                              if (recordData["environmentalSupport"] ==
                                  environmentalSupport.text) {} else {
                                await widget.modifyRecord(
                                    'environmentalSupport',
                                    environmentalSupport.text);
                                getRecordData();
                              }
                            }
                          },
                          child: TextField(
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 0),
                              isDense: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ), //외곽선
                            ),
                            controller: environmentalSupport,
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff393838)),
                            maxLines: 20,
                          ),

                        ),

                      ),
                      // Center(
                      //   child: recordData != null
                      //       ? RecordTextField(
                      //           method: 'environmentalSupport',
                      //           value: recordData["environmentalSupport"],
                      //           modifyRecord: widget.modifyRecord,
                      //           getRecordData: getRecordData,
                      //           globalKey: globalKeyThisWidget[8],
                      //           selectWidgetOnOff: selectOnOff,
                      //           widgetPositionSave: getPosition,
                      //         )
                      //       : RecordTextField(
                      //           method: 'environmentalSupport',
                      //           value: '',
                      //           modifyRecord: widget.modifyRecord,
                      //           getRecordData: getRecordData,
                      //           globalKey: globalKeyThisWidget[8],
                      //           selectWidgetOnOff: selectOnOff,
                      //           widgetPositionSave: getPosition,
                      //         ),
                      // ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 90.w,
                      cTotalWidth: 351.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget:
                      Center(
                        child: Focus(
                          onFocusChange: (hasFocus) async {
                            if (hasFocus) {} else {
                              // widget.selectWidgetOnOff(false);
                              if (recordData["emotionalSupport"] ==
                                  emotionalSupport.text) {} else {
                                await widget.modifyRecord(
                                    'emotionalSupport', emotionalSupport.text);
                                getRecordData();
                              }
                            }
                          },
                          child: TextField(
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 0),
                              isDense: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ), //외곽선
                            ),
                            controller: emotionalSupport,
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff393838)),
                            maxLines: 20,
                          ),

                        ),

                      ),
                      // Center(
                      //   child: recordData != null
                      //       ? RecordTextField(
                      //           method: 'emotionalSupport',
                      //           value: recordData["emotionalSupport"],
                      //           modifyRecord: widget.modifyRecord,
                      //           getRecordData: getRecordData,
                      //           globalKey: globalKeyThisWidget[9],
                      //           selectWidgetOnOff: selectOnOff,
                      //           widgetPositionSave: getPosition,
                      //         )
                      //       : RecordTextField(
                      //           method: 'emotionalSupport',
                      //           value: '',
                      //           modifyRecord: widget.modifyRecord,
                      //           getRecordData: getRecordData,
                      //           globalKey: globalKeyThisWidget[9],
                      //           selectWidgetOnOff: selectOnOff,
                      //           widgetPositionSave: getPosition,
                      //         ),
                      // ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 90.w,
                      cTotalWidth: 351.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget:
                      Center(
                        child: Focus(
                          onFocusChange: (hasFocus) async {
                            if (hasFocus) {} else {
                              // widget.selectWidgetOnOff(false);
                              if (recordData["linguisticSupport"] ==
                                  linguisticSupport.text) {} else {
                                await widget.modifyRecord('linguisticSupport',
                                    linguisticSupport.text);
                                getRecordData();
                              }
                            }
                          },
                          child: TextField(
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 0),
                              isDense: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ), //외곽선
                            ),
                            controller: linguisticSupport,
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff393838)),
                            maxLines: 20,
                          ),

                        ),

                      ),
                      // Center(
                      //   child: recordData != null
                      //       ? RecordTextField(
                      //           method: 'linguisticSupport',
                      //           value: recordData["linguisticSupport"],
                      //           modifyRecord: widget.modifyRecord,
                      //           getRecordData: getRecordData,
                      //           globalKey: globalKeyThisWidget[10],
                      //           selectWidgetOnOff: selectOnOff,
                      //           widgetPositionSave: getPosition,
                      //         )
                      //       : RecordTextField(
                      //           method: 'linguisticSupport',
                      //           value: '',
                      //           modifyRecord: widget.modifyRecord,
                      //           getRecordData: getRecordData,
                      //           globalKey: globalKeyThisWidget[10],
                      //           selectWidgetOnOff: selectOnOff,
                      //           widgetPositionSave: getPosition,
                      //         ),
                      // ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 60.w,
                      cTotalWidth: 100.w,
                      cInsideColor: Color(0xffCAACF2),
                      cBorderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.w),
                      ),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: "놀이지원계획",
                          title: true,
                        ),
                      ),
                    ),
                    CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 60.w,
                        cTotalWidth: 953.w,
                        cInsideColor: Color(0xffffffff),
                        cBorderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20.w),
                        ),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cRightBorderWidth: 1.w,
                        cBottomBorderWidth: 1.w,
                        childWidget: Center(
                          child: recordData != null
                              ? RecordTextField(
                            method: 'supportPlan',
                            value: recordData["supportPlan"],
                            modifyRecord: widget.modifyRecord,
                            getRecordData: getRecordData,
                            globalKey: globalKeyThisWidget[11],
                            selectWidgetOnOff: selectOnOff,
                            widgetPositionSave: getPosition,
                          )
                              : RecordTextField(
                            method: 'supportPlan',
                            value: '',
                            modifyRecord: widget.modifyRecord,
                            getRecordData: getRecordData,
                            globalKey: globalKeyThisWidget[11],
                            selectWidgetOnOff: selectOnOff,
                            widgetPositionSave: getPosition,
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: 5.w,
            left: 510.w,
            child: GestureDetector(
              onTap: () {
                showAlignedDialog(
                    offset: Offset(-70.w, -355.w - ((totalHeight - 910) / 2).w),
                    barrierColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return ShareReport(daily: recordData['daily'],
                          rid: widget.recordId,
                          getRecordData: getRecordData,
                          shareReportBtn: shareReportBtn);
                    });
              },
              child: Icon(
                Icons.arrow_drop_down,
                size: 40.w,
                color: Color(0xff7649B7),
              ),
            )),
        Positioned(
          top: 275.w,
          left: 375.w,
          child: GestureDetector(
            onTap: () async {
              File image = await pickImage(ImageSource.camera, context);
              double height;
              double width;
              if (ImageSizeGetter
                  .getSize(FileInput(image))
                  .height > ImageSizeGetter
                  .getSize(FileInput(image))
                  .width) {
                height = 300.0;
                ImageSizeGetter
                    .getSize(FileInput(image))
                    .height * 300 / ImageSizeGetter
                    .getSize(FileInput(image))
                    .width;
                width = ImageSizeGetter
                    .getSize(FileInput(image))
                    .width * 300 / ImageSizeGetter
                    .getSize(FileInput(image))
                    .height;
              } else {
                height = ImageSizeGetter
                    .getSize(FileInput(image))
                    .height * 300 / ImageSizeGetter
                    .getSize(FileInput(image))
                    .width;
                width = 300.0;
              }

              imagePostApi(
                  apiUrl.recordImage,
                  'signInToken',
                  {
                    'id': widget.recordId.toString(),
                    'x': 50.toString(),
                    'y': 50.toString(),
                    'w': width.toString(),
                    'h': height.toString(),

                  },
                  image,
                  'post',
                  context,
                  getRecordData);
            },
            child: Stack(
              children: [
                Positioned(
                  top: 5.w,
                  left: 4.w,
                  child: Container(
                    width: 35.w,
                    height: 35.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.w)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x29505050),
                          blurRadius: 6,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/icons/icon_camera.svg',
                  width: 45.w,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 275.w,
          left: 419.w,
          child: GestureDetector(
            onTap: () async {
              File image = await pickImage(ImageSource.gallery, context);
              double height;
              double width;
              if (ImageSizeGetter
                  .getSize(FileInput(image))
                  .height > ImageSizeGetter
                  .getSize(FileInput(image))
                  .width) {
                height = 300.0;
                ImageSizeGetter
                    .getSize(FileInput(image))
                    .height * 300 / ImageSizeGetter
                    .getSize(FileInput(image))
                    .width;
                width = ImageSizeGetter
                    .getSize(FileInput(image))
                    .width * 300 / ImageSizeGetter
                    .getSize(FileInput(image))
                    .height;
              } else {
                height = ImageSizeGetter
                    .getSize(FileInput(image))
                    .height * 300 / ImageSizeGetter
                    .getSize(FileInput(image))
                    .width;
                width = 300.0;
              }

              imagePostApi(
                  apiUrl.recordImage,
                  'signInToken',
                  {
                    'id': widget.recordId.toString(),
                    'x': 50.toString(),
                    'y': 50.toString(),
                    'w': width.toString(),
                    'h': height.toString(),

                  },
                  image,
                  'post',
                  context,
                  getRecordData);
            },
            child: Stack(
              children: [
                Positioned(
                  top: 5.w,
                  left: 4.w,
                  child: Container(
                    width: 35.w,
                    height: 35.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.w)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x29505050),
                          blurRadius: 6,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/icons/icon_galery.svg',
                  width: 45.w,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 275.w,
          left: 1006.w,
          child: GestureDetector(
            onTap: () {},
            child: Stack(
              children: [
                Positioned(
                  top: 5.w,
                  left: 4.w,
                  child: Container(
                    width: 35.w,
                    height: 35.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.w)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x29505050),
                          blurRadius: 6,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/icons/icon_voice_record.svg',
                  width: 45.w,
                ),
              ],
            ),
          ),
        ),
        // Positioned(
        //   top: 480.w,
        //   left: 940.w,
        //   child: GestureDetector(
        //     onTap: () {},
        //     child: Container(
        //         width: 40.w,
        //         height: 25.w,
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.all(Radius.circular(5.w)),
        //           color: Color(0xffFED796),
        //           boxShadow: [
        //             BoxShadow(
        //               color: Color(0x29505050),
        //               blurRadius: 6,
        //               offset: Offset(1, 1), // changes position of shadow
        //             ),
        //           ],
        //         ),
        //         child: Center(
        //           child: Text(
        //             '수정',
        //             style: TextStyle(
        //               fontSize: 12.sp,
        //               fontWeight: FontWeight.w500,
        //               color: Color(0xff393838),
        //             ),
        //           ),
        //         )),
        //   ),
        // ),
        // Positioned(
        //   top: 480.w,
        //   left: 996.w,
        //   child: GestureDetector(
        //     onTap: () {},
        //     child: Container(
        //         width: 40.w,
        //         height: 25.w,
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.all(Radius.circular(5.w)),
        //           color: Color(0xffFED796),
        //           boxShadow: [
        //             BoxShadow(
        //               color: Color(0x29505050),
        //               blurRadius: 6,
        //               offset: Offset(1, 1), // changes position of shadow
        //             ),
        //           ],
        //         ),
        //         child: Center(
        //           child: Text(
        //             '삭제',
        //             style: TextStyle(
        //               fontSize: 12.sp,
        //               fontWeight: FontWeight.w500,
        //               color: Color(0xff393838),
        //             ),
        //           ),
        //         )),
        //   ),
        // ),
        if (selectWidget) ...[
          Positioned(
              top: position!.dy - 100.w + selectWidgetPosition,
              left:
              // recordMethod == 'space' ? position!.dx - 148.w :
              position!.dx - 147.5.w,
              child: Container(
                width: recordMethod == 'space' ? 240.w : 265.w,
                height: 150.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1.w, color: Color(0xffE5D0FE)),
                  borderRadius: BorderRadius.all(Radius.circular(10.w)),
                ),
                child: Stack(
                  children: [
                    ScrollConfiguration(
                        behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                        child: ListView(
                          padding: EdgeInsets.only(
                              top: 10.w, right: 20.w, left: 20.w, bottom: 10.w),
                          physics: const RangeMaintainingScrollPhysics(),
                          children: [
                            for (int i = recordThemeData['results'].length - 1;
                            i > -1;
                            i--) ...[
                              if (i != 0) ...[

                                SizedBox(
                                  height: 5.w,
                                ),
                              ],
                              GestureDetector(
                                  onTap: () async {
                                    FocusScopeNode currentFocus = FocusScope.of(
                                        context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    await widget.modifyRecord(recordMethod,
                                        recordThemeData['results'][i]);
                                    await getRecordData();
                                    setState(() {
                                      selectWidget = false;
                                    });
                                  },
                                  child: Text(
                                    recordThemeData['results'][i],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        color: Color(0xff393838)),
                                  )
                                // RecordTableTextStyle(title: false, text: "으어어어",),
                              ),
                            ]
                          ],
                        )),
                    Positioned(
                        top: 5.w,
                        right: 5.w,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectWidget = false;
                            });
                          },
                          child: Container(
                            width: 20.w,
                            height: 20.w,
                            child: SvgPicture.asset(
                              'assets/icons/icon_close_record.svg',
                              width: 10.w,
                            ),
                          ),
                        ))
                  ],
                ),
              ))
        ],

      ],
    );
  }
}
//
// class ChildDropDownButton extends StatefulWidget {
//   const ChildDropDownButton({
//     Key? key,
//     required this.dropDownChildInfo,
//     required this.setChildId,
//   }) : super(key: key);
//   final List<DropDownChildInfo> dropDownChildInfo;
//   final Function(int, int) setChildId;
//
//   @override
//   State<ChildDropDownButton> createState() => _ChildDropDownButtonState();
// }
//
// class _ChildDropDownButtonState extends State<ChildDropDownButton> {
//   List<int> number = [];
//   int now = -1;
//
//   List<DropdownMenuItem<int>> childList() {
//     return number
//         .map<DropdownMenuItem<int>>(
//           (e) =>
//           DropdownMenuItem(
//             enabled: true,
//             alignment: Alignment.centerLeft,
//             value: e,
//             child: Text(
//               widget.dropDownChildInfo[e].childName,
//               style: TextStyle(
//                   color: Color(0xff393838),
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w400),
//             ),
//           ),
//     )
//         .toList();
//   }
//
//   @override
//   void initState() {
//     for (int i = 0; i < widget.dropDownChildInfo.length; i++) {
//       number.add(i);
//     }
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 150.w,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(5.w)),
//         color: Colors.white,
//         border: Border.all(color: Color(0xffCF78FB), width: 1.w),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0x29000000),
//             blurRadius: 6,
//             offset: Offset(1, 1),
//           ),
//         ],
//       ),
//       child: Center(
//         child: Container(
//           width: 180.w,
//           child: DropdownButton(
//             isExpanded: true,
//             menuMaxHeight: 300.w,
//             value: now == -1 ? null : now,
//             elevation: 16,
//             items: childList(),
//             onChanged: (value) {
//               setState(() {
//                 for (int i = 0; i < childList().length; i++) {
//                   if (childList()[i].value == value) {
//                     widget.setChildId(widget.dropDownChildInfo[i].childId, i);
//                     now = i;
//                   }
//                 }
//               });
//             },
//             icon: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Icon(
//                   Icons.arrow_drop_down,
//                   size: 25.w,
//                   color: Color(0xff7F50C4),
//                 ),
//               ],
//             ),
//             alignment: AlignmentDirectional.topCenter,
//             underline: SizedBox.shrink(),
//           ),
//         ),
//       ),
//     );
//   }
// }

class ShareReport extends StatefulWidget {
  const ShareReport({Key? key,
    required this.daily,
    required this.rid,
    required this.getRecordData,
    required this.shareReportBtn,
  }) : super(key: key);
  final bool daily;
  final int rid;
  final List<bool> shareReportBtn;
  final Function() getRecordData;

  @override
  State<ShareReport> createState() => _ShareReportState();
}

class _ShareReportState extends State<ShareReport> {
  ApiUrl apiUrl = ApiUrl();

  // List<bool> shareReportBtn = [
  //   false,
  //   false,
  //   false,
  //   false,
  // ];

  postRecordToDaily() async {
    http.Response dailyRes = await api(
        apiUrl.recordToDaily, 'post', 'signInToken', {
      "id": widget.rid.toString(),
      "cid": Provider
          .of<UserInfo>(context, listen: false)
          .value[0].toString(),
    }, context);
    if (dailyRes.statusCode == 200) {
      widget.getRecordData();
    }
  }

  deleteRecordToDaily() async {
    http.Response dailyRes = await api(
        apiUrl.recordToDaily + '/' + widget.rid.toString(), 'delete',
        'signInToken', {}, context);
    if (dailyRes.statusCode == 200) {
      widget.getRecordData();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190.w,
      height: 195.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
          color: Color(0xffFFEFD3),
          boxShadow: [
            BoxShadow(
              color: Color(0x29959595),
              blurRadius: 3,
              offset: Offset(2, 2), // changes position of shadow
            ),
          ]),
      child: Stack(
        children: [
          Positioned(
              top: 3.5.w,
              right: 2.w,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_drop_up,
                  size: 40.w,
                  color: Color(0xffFDB43B),
                ),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        if (widget.shareReportBtn[0]) {

                          widget.shareReportBtn[0] = !widget.shareReportBtn[0];
                          deleteRecordToDaily();
                        } else {

                          widget.shareReportBtn[0] = !widget.shareReportBtn[0];
                          postRecordToDaily();
                        }
                      });
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                        border:
                        Border.all(color: Color(0xffFDB43B), width: 1.w),
                        color: widget.shareReportBtn[0]
                            ? Color(0xffFDB43B)
                            : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  RecordTableTextStyle(text: '하루일과', title: true),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.shareReportBtn[1] = !widget.shareReportBtn[1];
                      });
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                        border:
                        Border.all(color: Color(0xffFDB43B), width: 1.w),
                        color: widget.shareReportBtn[1]
                            ? Color(0xffFDB43B)
                            : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  RecordTableTextStyle(text: '주간놀이', title: true),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.shareReportBtn[2] = !widget.shareReportBtn[2];
                      });
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                        border:
                        Border.all(color: Color(0xffFDB43B), width: 1.w),
                        color: widget.shareReportBtn[2]
                            ? Color(0xffFDB43B)
                            : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  RecordTableTextStyle(text: '놀이흐름도', title: true),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.shareReportBtn[3] = !widget.shareReportBtn[3];
                      });
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                        border:
                        Border.all(color: Color(0xffFDB43B), width: 1.w),
                        color: widget.shareReportBtn[3]
                            ? Color(0xffFDB43B)
                            : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  RecordTableTextStyle(text: '놀이저널', title: true),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class ChoiceNuriContent extends StatefulWidget {
  const ChoiceNuriContent({
    Key? key,
    required this.nuriNumber,
    required this.age,
    required this.childId,
    required this.recordId,
    required this.getRecordData,
  }) : super(key: key);
  final int nuriNumber;
  final int age;
  final int childId;
  final int recordId;
  final Function() getRecordData;

  @override
  State<ChoiceNuriContent> createState() => _ChoiceNuriContentState();
}

class _ChoiceNuriContentState extends State<ChoiceNuriContent> {
  Nuri nuri = Nuri();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.w))),
      insetPadding: EdgeInsets.all(0),
      child: Container(
        width: 1060.w,
        height: 700.w,
        decoration: BoxDecoration(
            color: Color(0xfffffdf8),
            borderRadius: BorderRadius.all(Radius.circular(20.w)),
            boxShadow: [
              BoxShadow(
                offset: Offset(5, 5),
                color: Color(0x29B4B4B4),
                blurRadius: 6,
              ),
            ]),
        child: Column(
          children: [
            SizedBox(
              height: 24.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/icon_close_record.svg',
                    width: 30.w,
                  ),
                ),
                SizedBox(
                  width: 25.w,
                ),
              ],
            ),
            SizedBox(
              height: 50.w,
            ),
            if(nuri.areaContent[widget.age][widget.nuriNumber].length == 2)...[
              Row(
                children: [
                  SizedBox(
                    width: 21.w,
                  ),
                  CustomContainer(
                    cTotalHeight: 47.w,
                    cTotalWidth: 510.w,
                    cBorderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.w)),
                    cInsideColor: Color(0xffFED796),
                    cBorderColor: Color(0xffFBB348),
                    cLeftBorderWidth: 1.w,
                    cTopBorderWidth: 1.w,
                    childWidget: Center(
                        child: Text(
                          nuri.areaContent[widget.age][widget.nuriNumber][0],
                          style: TextStyle(
                            fontSize: 20.w,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff393838),
                          ),
                        )),
                  ),
                  CustomContainer(
                    cTotalHeight: 47.w,
                    cTotalWidth: 510.w,
                    cBorderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.w)),
                    cInsideColor: Color(0xffFED796),
                    cBorderColor: Color(0xffFBB348),
                    cLeftBorderWidth: 1.w,
                    cTopBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    childWidget: Center(
                        child: Text(
                          nuri.areaContent[widget.age][widget.nuriNumber][1],
                          style: TextStyle(
                            fontSize: 20.w,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff393838),
                          ),
                        )),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 21.w,
                  ),
                  CustomContainer(
                    cTotalWidth: 510.w,
                    cTotalHeight: 460.w,
                    cBorderColor: Color(0xfffbb348),
                    cBottomBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    // cRightBorderWidth: 1.w,
                    cInsideColor: Colors.white,
                    cBorderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(20.w)),
                    childWidget: Padding(
                      padding:
                      EdgeInsets.only(top: 21.w, left: 19.w, right: 36.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0;
                          i <
                              nuri.areaCommentary[widget.age][widget
                                  .nuriNumber][0]
                                  .length;
                          i++) ...[
                            if (i != 0) ...[
                              SizedBox(
                                height: 10.w,
                              )
                            ],
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ChoiceNuriEvaluation(
                                          nuriNumber: widget.nuriNumber,
                                          nuriAge: widget.age,
                                          contentNumber: 0,
                                          commentaryNumber: i,
                                          recordId: widget.recordId,
                                          childId: widget.childId,
                                          getRecordData: widget.getRecordData,
                                        );
                                      });
                                },
                                child: RecordTableContentTextStyle(
                                    text: (i + 1).toString() +
                                        '. ' +
                                        nuri.areaCommentary[widget.age][widget
                                            .nuriNumber]
                                        [0][i])),
                          ]
                        ],
                      ),
                    ),
                  ),

                  CustomContainer(
                    cTotalWidth: 510.w,
                    cTotalHeight: 460.w,
                    cBorderColor: Color(0xfffbb348),
                    cBottomBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cInsideColor: Colors.white,
                    cBorderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(20.w)),
                    childWidget: Padding(
                      padding:
                      EdgeInsets.only(top: 21.w, left: 19.w, right: 36.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0;
                          i <
                              nuri.areaCommentary[widget.age][widget
                                  .nuriNumber][1]
                                  .length;
                          i++) ...[
                            if (i != 0) ...[
                              SizedBox(
                                height: 10.w,
                              )
                            ],
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ChoiceNuriEvaluation(
                                        nuriNumber: widget.nuriNumber,
                                        nuriAge: widget.age,
                                        contentNumber: 1,
                                        commentaryNumber: i,
                                        recordId: widget.recordId,
                                        childId: widget.childId,
                                        getRecordData: widget.getRecordData,
                                      );
                                    });
                              },
                              child: RecordTableContentTextStyle(
                                  text: (i + 1).toString() +
                                      '. ' +
                                      nuri.areaCommentary[widget.age][widget
                                          .nuriNumber][1]
                                      [i]),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ] else
              ...[
                Row(
                  children: [
                    SizedBox(
                      width: 21.w,
                    ),
                    Container(
                      width: 340.w,
                      height: 47.w,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(20.w)),
                          color: Color(0xffFED796),
                          border: Border.all(
                              color: Color(0xffFBB348), width: 1.w)),
                      child: Center(
                          child: Text(
                            nuri.areaContent[widget.age][widget.nuriNumber][0],
                            style: TextStyle(
                              fontSize: 20.w,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff393838),
                            ),
                          )),
                    ),
                    Container(
                      width: 340.w,
                      height: 47.w,
                      decoration: BoxDecoration(
                        color: Color(0xffFED796),
                        border: Border(
                            top: BorderSide(color: Color(0xfffbb348),
                                width: 1.w),
                            bottom:
                            BorderSide(color: Color(0xfffbb348), width: 1.w)),
                      ),
                      child: Center(
                          child: Text(
                            nuri.areaContent[widget.age][widget.nuriNumber][1],
                            style: TextStyle(
                              fontSize: 20.w,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff393838),
                            ),
                          )),
                    ),
                    Container(
                      width: 340.w,
                      height: 47.w,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.only(topRight: Radius.circular(20.w)),
                          color: Color(0xffFED796),
                          border: Border.all(
                              color: Color(0xffFBB348), width: 1.w)),
                      child: Center(
                          child: Text(
                            nuri.areaContent[widget.age][widget.nuriNumber][2],
                            style: TextStyle(
                              fontSize: 20.w,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff393838),
                            ),
                          )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 21.w,
                    ),
                    CustomContainer(
                      cTotalWidth: 340.w,
                      cTotalHeight: 460.w,
                      cBorderColor: Color(0xfffbb348),
                      cBottomBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      cInsideColor: Colors.white,
                      cBorderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(20.w)),
                      childWidget: Padding(
                        padding:
                        EdgeInsets.only(top: 21.w, left: 19.w, right: 36.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0;
                            i <
                                nuri.areaCommentary[widget.age][widget
                                    .nuriNumber][0]
                                    .length;
                            i++) ...[
                              if (i != 0) ...[
                                SizedBox(
                                  height: 10.w,
                                )
                              ],
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ChoiceNuriEvaluation(
                                            nuriNumber: widget.nuriNumber,
                                            nuriAge: widget.age,
                                            contentNumber: 0,
                                            commentaryNumber: i,
                                            recordId: widget.recordId,
                                            childId: widget.childId,
                                            getRecordData: widget.getRecordData,
                                          );
                                        });
                                  },
                                  child: RecordTableContentTextStyle(
                                      text: (i + 1).toString() +
                                          '. ' +
                                          nuri.areaCommentary[widget.age][widget
                                              .nuriNumber]
                                          [0][i])),
                            ]
                          ],
                        ),
                      ),
                    ),
                    CustomContainer(
                      cTotalWidth: 340.w,
                      cTotalHeight: 460.w,
                      cBorderColor: Color(0xfffbb348),
                      cBottomBorderWidth: 1.w,
                      // cLeftBorderWidth: 1.w,
                      cInsideColor: Colors.white,
                      childWidget: Padding(
                        padding:
                        EdgeInsets.only(top: 21.w, left: 19.w, right: 36.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0;
                            i <
                                nuri.areaCommentary[widget.age][widget
                                    .nuriNumber][1]
                                    .length;
                            i++) ...[
                              if (i != 0) ...[
                                SizedBox(
                                  height: 10.w,
                                )
                              ],
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ChoiceNuriEvaluation(
                                          nuriNumber: widget.nuriNumber,
                                          nuriAge: widget.age,
                                          contentNumber: 1,
                                          commentaryNumber: i,
                                          recordId: widget.recordId,
                                          childId: widget.childId,
                                          getRecordData: widget.getRecordData,
                                        );
                                      });
                                },
                                child: RecordTableContentTextStyle(
                                    text: (i + 1).toString() +
                                        '. ' +
                                        nuri.areaCommentary[widget.age][widget
                                            .nuriNumber][1]
                                        [i]),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                    CustomContainer(
                      cTotalWidth: 340.w,
                      cTotalHeight: 460.w,
                      cBorderColor: Color(0xfffbb348),
                      cBottomBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      cInsideColor: Colors.white,
                      cBorderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(20.w)),
                      childWidget: Padding(
                        padding:
                        EdgeInsets.only(top: 21.w, left: 19.w, right: 36.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0;
                            i <
                                nuri.areaCommentary[widget.age][widget
                                    .nuriNumber][2]
                                    .length;
                            i++) ...[
                              if (i != 0) ...[
                                SizedBox(
                                  height: 10.w,
                                )
                              ],
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ChoiceNuriEvaluation(
                                          nuriNumber: widget.nuriNumber,
                                          nuriAge: widget.age,
                                          contentNumber: 2,
                                          commentaryNumber: i,
                                          recordId: widget.recordId,
                                          childId: widget.childId,
                                          getRecordData: widget.getRecordData,
                                        );
                                      });
                                },
                                child: RecordTableContentTextStyle(
                                    text: (i + 1).toString() +
                                        '. ' +
                                        nuri.areaCommentary[widget.age][widget
                                            .nuriNumber][2]
                                        [i]),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ]

          ],
        ),
      ),
    );
  }
}

class ChoiceNuriEvaluation extends StatefulWidget {
  const ChoiceNuriEvaluation({
    Key? key,
    required this.nuriNumber,
    required this.commentaryNumber,
    required this.contentNumber,
    required this.nuriAge,
    required this.recordId,
    required this.childId,
    required this.getRecordData,
  }) : super(key: key);
  final int nuriNumber;
  final int contentNumber;
  final int commentaryNumber;
  final int nuriAge;
  final int recordId;
  final int childId;
  final Function() getRecordData;

  @override
  State<ChoiceNuriEvaluation> createState() => _ChoiceNuriEvaluationState();
}

class _ChoiceNuriEvaluationState extends State<ChoiceNuriEvaluation> {
  Nuri nuri = Nuri();
  int age = 0;

  postNuri(int index) async {
    ApiUrl apiUrl = ApiUrl();
    String nuriCode = (widget.nuriNumber + 1).toString() +
        (widget.contentNumber + 1).toString() +
        (widget.commentaryNumber + 1).toString() + index.toString();
    http.Response nuriRes = await api(apiUrl.recordNuri, 'post', 'signInToken',
        {
          'id': widget.recordId.toString(),
          'cid': widget.childId.toString(),
          'nuriCode': nuriCode
        }, context);

    if (nuriRes.statusCode == 200) {
      Navigator.pop(context);
      widget.getRecordData();
    }
  }

  @override
  void initState() {
    if (widget.nuriAge < 3) {
      age = widget.nuriAge;
    } else {
      age = widget.nuriAge - 3;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.w))),
      insetPadding: EdgeInsets.all(0),
      child: Container(
        width: 1060.w,
        height: 700.w,
        decoration: BoxDecoration(
            color: Color(0xfffffdf8),
            borderRadius: BorderRadius.all(Radius.circular(20.w)),
            boxShadow: [
              BoxShadow(
                offset: Offset(5, 5),
                color: Color(0x29B4B4B4),
                blurRadius: 6,
              ),
            ]),
        child: Column(
          children: [
            SizedBox(
              height: 24.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/icon_close_record.svg',
                    width: 30.w,
                  ),
                ),
                SizedBox(
                  width: 25.w,
                ),
              ],
            ),
            SizedBox(
              height: 40.w,
            ),
            Row(
              children: [
                SizedBox(
                  width: 21.w,
                ),
                Container(
                  width: 340.w,
                  height: 47.w,
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(20.w)),
                      color: Color(0xffFED796),
                      border: Border.all(color: Color(0xffFBB348), width: 1.w)),
                  child: Center(
                      child: Text(
                        '1',
                        style: TextStyle(
                          fontSize: 20.w,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff393838),
                        ),
                      )),
                ),
                Container(
                  width: 340.w,
                  height: 47.w,
                  decoration: BoxDecoration(
                    color: Color(0xffFED796),
                    border: Border(
                        top: BorderSide(color: Color(0xfffbb348), width: 1.w),
                        bottom:
                        BorderSide(color: Color(0xfffbb348), width: 1.w)),
                  ),
                  child: Center(
                      child: Text(
                        '2',
                        style: TextStyle(
                          fontSize: 20.w,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff393838),
                        ),
                      )),
                ),
                Container(
                  width: 340.w,
                  height: 47.w,
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.only(topRight: Radius.circular(20.w)),
                      color: Color(0xffFED796),
                      border: Border.all(color: Color(0xffFBB348), width: 1.w)),
                  child: Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          fontSize: 20.w,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff393838),
                        ),
                      )),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 21.w,
                ),
                GestureDetector(
                  onTap: () {
                    postNuri(1);
                  },
                  child: CustomContainer(
                    cTotalWidth: 340.w,
                    cTotalHeight: 460.w,
                    cBorderColor: Color(0xfffbb348),
                    cBottomBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cInsideColor: Colors.white,
                    cBorderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(20.w)),
                    childWidget: Padding(
                      padding:
                      EdgeInsets.only(top: 21.w, left: 19.w, right: 36.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RecordTableContentTextStyle(
                              text: nuri.areaEvaluation[widget.nuriAge][widget
                                  .nuriNumber]
                              [widget.contentNumber]
                              [widget.commentaryNumber][0]),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    postNuri(2);
                  },
                  child: CustomContainer(
                    cTotalWidth: 340.w,
                    cTotalHeight: 460.w,
                    cBorderColor: Color(0xfffbb348),
                    cBottomBorderWidth: 1.w,
                    // cLeftBorderWidth: 1.w,
                    cInsideColor: Colors.white,
                    childWidget: Padding(
                      padding:
                      EdgeInsets.only(top: 21.w, left: 19.w, right: 36.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RecordTableContentTextStyle(
                              text: nuri.areaEvaluation[widget.nuriAge][widget
                                  .nuriNumber]
                              [widget.contentNumber]
                              [widget.commentaryNumber][1]),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    postNuri(3);
                  },
                  child: CustomContainer(
                    cTotalWidth: 340.w,
                    cTotalHeight: 460.w,
                    cBorderColor: Color(0xfffbb348),
                    cBottomBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cInsideColor: Colors.white,
                    cBorderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(20.w)),
                    childWidget: Padding(
                      padding:
                      EdgeInsets.only(top: 21.w, left: 19.w, right: 36.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RecordTableContentTextStyle(
                              text: nuri.areaEvaluation[widget.nuriAge][widget
                                  .nuriNumber]
                              [widget.contentNumber]
                              [widget.commentaryNumber][2]),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 150.w,
                  height: 50.w,
                  margin: EdgeInsets.only(left: 50.w),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ChoiceNuriContent(
                              nuriNumber: widget.nuriNumber,
                              age: widget.nuriAge,
                              childId: widget.childId,
                              recordId: widget.recordId,
                              getRecordData: widget.getRecordData,
                            );
                          });
                    },
                    child: Text('뒤로',
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.w400)),
                    style: ElevatedButton.styleFrom(
                      elevation: 1.0,
                      primary: const Color(0xFFFFFFFF),
                      onPrimary: const Color(0xFF393838),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.w)),
                      side: const BorderSide(color: Color(0xFFA666FB)),
                      // fixedSize: Size(150.w, 50.w)
                    ),
                  ),
                ),
                SizedBox(
                  width: 25.w,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


class AijoaTimePicker extends StatefulWidget {
  const AijoaTimePicker({Key? key,
    required this.getRecordData,
    required this.modifyRecord,
  }) : super(key: key);
  final Function(String, String) modifyRecord;
  final Function() getRecordData;

  @override
  State<AijoaTimePicker> createState() => _AijoaTimePickerState();
}

class _AijoaTimePickerState extends State<AijoaTimePicker> {
  TextEditingController hour = TextEditingController();
  TextEditingController minute = TextEditingController();
  bool noon = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (DateTime
        .now()
        .hour > 13) {
      hour.text = (DateTime
          .now()
          .hour - 12).toString();
      noon = false;
    } else {
      hour.text = DateTime
          .now()
          .hour
          .toString();
    }
    minute.text = DateTime
        .now()
        .minute
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
              child: Container(
                  width: 340.w,
                  height: 180.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.w),
                      color: const Color(0xFFFCF9F4)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30.w,
                      ),

                      Row(
                        children: [
                          SizedBox(
                            width: 30.w,
                          ),
                          Container(
                            width: 90.w,
                            height: 70.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10
                                  .w)),
                            ),
                            child: Center(
                              child: TextField(
                                controller: hour,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 40.sp,
                                    color: Color(0xff393838)
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textAlignVertical: TextAlignVertical(
                                    y: -1.w
                                ),
                                maxLength: 2,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  counterText: '',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: Color(0xff393838),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                height: 18.w,
                              ),
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: Color(0xff393838),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Container(
                            width: 90.w,
                            height: 70.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10
                                  .w)),
                            ),
                            child: Center(
                              child: TextField(
                                controller: minute,
                                keyboardType: TextInputType.number,
                                textAlignVertical: TextAlignVertical(
                                    y: -1.w
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 40.sp,
                                    color: Color(0xff393838)
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],

                                maxLength: 2,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  counterText: '',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    noon = true;
                                  });
                                },
                                child: Container(
                                  width: 50.w,
                                  height: 32.5.w,
                                  decoration: BoxDecoration(
                                    color: noon ? Color(0xffC6A2FC) : Colors
                                        .white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.w)),
                                    border: Border.all(
                                      width: 1.w, color: Color(0xffC6A2FC),),
                                  ),
                                  child: Center(
                                    child: Text("AM",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff393838),
                                      ),),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    noon = false;
                                  });
                                },
                                child: Container(
                                  width: 50.w,
                                  height: 32.5.w,
                                  decoration: BoxDecoration(
                                    color: noon ? Colors.white : Color(
                                        0xffC6A2FC),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.w)),
                                    border: Border.all(
                                      width: 1.w, color: Color(0xffC6A2FC),),
                                  ),
                                  child: Center(
                                    child: Text("PM",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff393838),
                                      ),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.w,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 180.w,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (int.parse(hour.text) < 13 && int.parse(minute
                                  .text) < 60) {
                                if (int.parse(hour.text) == 12 && int.parse(
                                    minute.text) > 0) {
                                  // showToast("시간을 올바르게 설정해주세요.");
                                  if(noon){
                                    await widget.modifyRecord(
                                        'time',
                                        hour.text +
                                            ':' +
                                            minute.text);
                                    widget.getRecordData();
                                    // pickTime(widget.id, widget.type);
                                  }else{

                                    hour.text = (int.parse(hour.text) - 12)
                                        .toString();
                                    await widget.modifyRecord(
                                        'time',
                                        hour.text +
                                            ':' +
                                            minute.text);
                                    widget.getRecordData();
                                  }
                                  Navigator.pop(context);
                                } else {
                                  if (noon) {
                                    await widget.modifyRecord(
                                        'time',
                                        hour.text +
                                            ':' +
                                            minute.text);
                                    widget.getRecordData();
                                  } else {
                                    await widget.modifyRecord(
                                        'time',
                                        (int.parse(hour.text) + 12).toString() +
                                            ':' +
                                            minute.text);
                                    widget.getRecordData();
                                  }
                                  Navigator.pop(context);
                                }
                              } else {
                                showToast("시간을 올바르게 설정해주세요.");
                              }
                            },
                            child: Container(
                              width: 60.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: Color(0xffC6A2FC),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x29000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  )
                                ],
                                borderRadius: BorderRadius.all(Radius.circular(
                                    10.w)),
                              ),
                              child: Center(
                                child: Text("확인",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff7649B7),
                                  ),),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 60.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x29000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  )
                                ],
                                borderRadius: BorderRadius.all(Radius.circular(
                                    10.w)),
                                border: Border.all(width: 1.w,
                                    color: Color(0xffC6A2FC)),
                              ),
                              child: Center(
                                child: Text("취소",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff7649B7),
                                  ),),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],)))),
    );
  }
}


class RecordTextField extends StatefulWidget {
  const RecordTextField({
    Key? key,
    required this.method,
    required this.value,
    required this.modifyRecord,
    required this.getRecordData,
    required this.globalKey,
    required this.selectWidgetOnOff,
    required this.widgetPositionSave,
  }) : super(key: key);
  final String method;
  final String? value;
  final Function(String, String) modifyRecord;
  final Function() getRecordData;
  final GlobalKey globalKey;
  final Function(bool, String) selectWidgetOnOff;
  final Function(GlobalKey) widgetPositionSave;

  @override
  State<RecordTextField> createState() => _RecordTextFieldState();
}

class _RecordTextFieldState extends State<RecordTextField> {
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // textEditingController.text = widget.value ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if(textEditingController.text != widget.value){
      textEditingController.text = widget.value ?? '';
    }

    return Focus(
        key: widget.globalKey,
        onFocusChange: (hasFocus) async {
          if (hasFocus) {

            if (widget.method == 'mainTheme' || widget.method == 'theme' ||
                widget.method == 'subTheme' || widget.method == 'subject' ||
                widget.method == 'space') {
              widget.selectWidgetOnOff(true, widget.method);
              widget.widgetPositionSave(widget.globalKey);
              focusNode.requestFocus();
            }
          } else {

            // widget.selectWidgetOnOff(false);
            if (widget.value == textEditingController.text) {} else {
              await widget.modifyRecord(
                  widget.method, textEditingController.text);
              await widget.getRecordData();
            }

          }
        },
        child: TextField(
          focusNode: focusNode,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ), //외곽선
          ),
          controller: textEditingController,
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff393838)),
        ));
  }
}