import 'dart:convert';
import 'dart:math';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/provider/app_management.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/dropdown_child.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/nuri.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../widgets/custom_container.dart';
import 'd3_1.dart';

class D9 extends StatefulWidget {
  const D9({
    Key? key,
    required this.nextPage,
    required this.prePage,
    required this.nowPage,
    this.scaffoldKey,
    this.scheduleYearData,
    this.pageTime = '',
    this.targetClass,
    this.childId = -1,
  }) : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final scheduleYearData;
  final bool? targetClass;
  final int childId;
  final String pageTime;

  @override
  State<D9> createState() => _D9State();
}

class _D9State extends State<D9> {
  bool dateOff = false;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    setState(() {});
  }

  @override
  initState() {
    receiveData(pageTime);
    super.initState();
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
                padding: EdgeInsets.zero,
                physics: const RangeMaintainingScrollPhysics(),
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: 1105.w,
                            color: const Color(0xffFCFCFC),
                          ),
                        ],
                      ),
                      NuriProcessAnalysisTable(
                        date: widget.scheduleYearData,
                        pageTime: widget.pageTime,
                        childId: widget.childId,
                        targetClass: widget.targetClass,
                      ),
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

class NuriProcessAnalysisTable extends StatefulWidget {
  const NuriProcessAnalysisTable({
    Key? key,
    required this.date,
    this.targetClass,
    this.pageTime = '',
    this.childId = -1,
  }) : super(key: key);
  final date;
  final bool? targetClass;
  final String pageTime;
  final int childId;

  @override
  State<NuriProcessAnalysisTable> createState() =>
      _NuriProcessAnalysisTableState();
}

class _NuriProcessAnalysisTableState extends State<NuriProcessAnalysisTable> {
  ApiUrl apiUrl = ApiUrl();
  Nuri nuri = Nuri();
  Color borderColor = const Color(0x9dC13BFD);
  List<TextEditingController> commentTextField = [];
  List<DropDownChildInfo> childList = [];
  int childId = 0;
  int selectIndex = 0;
  bool onOff = false;
  List<SelectMonth> monthData = [];
  int monthCount = 0;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String nowMonth = '';
  String nowMonthStr = '';
  String dataMonthStr = '';
  String dataYear = '';
  String dataMonth = '';
  int dataChildId = 0;
  int selectMonthIndex = 0;
  bool targetClass = false;
  bool dataTargetClass = false;
  bool graphType = true;
  int targetIndex = -1;
  List<String> target = [
    '학급별',
    '유아별'
  ];
  List<Image?> signImage = [];
  var nuriData;
  var nuriCommentData;

  getChildData() async {
    onOff = false;
    http.Response childRes =
    await api('${apiUrl.child}/$nowMonth${'01'}?cid=${Provider.of<UserInfo>(context, listen: false).value[0]}', 'get', 'signInToken', {}, context);
    if (childRes.statusCode == 200) {
      var childRB = utf8.decode(childRes.bodyBytes);
      var childData = jsonDecode(childRB);
      print(childData);
      setState(() {
        childList.clear();
        for (int i = 0; i < childData.length; i++) {
          childList.add(DropDownChildInfo(
              childName: childData[i]['name'], childId: childData[i]['id']));
        }
      });
      onOff = true;
    }
  }
  
  getCommentData() async{
    Nuri nuri = Nuri();
    http.Response res = await api(apiUrl.nuriChild, 'post', 'signInToken', {
      "academicYear": widget.date['year'],
      "year": dataYear,
      "month": dataMonth,
      "id": dataChildId,
    }, context);
    if(res.statusCode == 200){
      var commentRB = utf8.decode(res.bodyBytes);
      nuriCommentData = jsonDecode(commentRB);
      for(int j = 0; j< nuri.area[nuriData['nuriAge']].length;j++){
        String comment = '';
        for(int i = 0;i<nuriCommentData['nuries'].length;i++){
          if(nuriCommentData['nuries'][i].substring(0,1) == (j+1).toString()){
            String nuriText = nuri.areaEvaluation[nuriData['nuriAge']]
            [int.parse(nuriCommentData['nuries'][i].substring(0,1))-1]
            [int.parse(nuriCommentData['nuries'][i].substring(1,2))-1]
            [int.parse(nuriCommentData['nuries'][i].substring(2,3))-1]
            [int.parse(nuriCommentData['nuries'][i].substring(3,4))-1];
            if(comment != ''){
              comment = '$comment\n' ;
            }
            comment = '$comment${nuriText.split('예 : ')[0]}' ;
          }
        }

        patchNuriData(j+1,comment);
      }


    }
  }

  getNuriData(bool re) async {
    http.Response? nuriRes;
    if(re){
      if(dataTargetClass){
        nuriRes = await api(
            '${apiUrl.nuriClass}/${widget.date['year']}/$dataYear$dataMonth/${Provider.of<UserInfo>(context, listen: false).value[0]}',
            'get',
            'signInToken',
            {},
            context);
      }else{
        nuriRes = await api(
            '${apiUrl.nuriChild}/${widget.date['year']}/$dataYear$dataMonth/$dataChildId',
            'get',
            'signInToken',
            {},
            context);
      }
    }else{
      if(targetClass){
        nuriRes = await api(
            '${apiUrl.nuriClass}/${widget.date['year']}/$nowMonth/${Provider.of<UserInfo>(context, listen: false).value[0]}',
            'get',
            'signInToken',
            {},
            context);
      }else{
        nuriRes = await api(
            '${apiUrl.nuriChild}/${widget.date['year']}/$nowMonth/$childId',
            'get',
            'signInToken',
            {},
            context);
      }
    }

    if (nuriRes!.statusCode == 200) {
      var nuriRB = utf8.decode(nuriRes.bodyBytes);

      setState(() {
        nuriData = jsonDecode(nuriRB);

        dataMonthStr = nowMonthStr;
        dataChildId = childId;
        dataYear = nowMonth.substring(0,4);
        dataMonth = nowMonth.substring(4);
        if(re){
        }else{
          dataTargetClass = targetClass;
        }
        commentTextField.clear();
        if(nuriData['comments'] != null){
          for(int i = 0;i<nuriData['comments'].length;i++){

            commentTextField.add(TextEditingController(text: nuriData['comments'][i]['comment']));
          }
        }
      });
      signImage.clear();

      if(nuriData['teacherSign'] != null){
        signImage.add(await imageApi(nuriData['teacherSign'], 'signInToken', context));
      }else{
        signImage.add(null);
      }
      if(nuriData['viceDirectorSign'] != null){
        signImage.add(await imageApi(nuriData['viceDirectorSign'], 'signInToken', context));
      }else{
        signImage.add(null);
      }
      if(nuriData['directorSign'] != null){
        signImage.add(await imageApi(nuriData['directorSign'], 'signInToken', context));
      }else{
        signImage.add(null);
      }
      setState(() {});
    }
  }
  patchSign() async {
    http.Response? childRes;
    if(dataTargetClass){
      childRes =
      await api(apiUrl.nuriClassSign, 'patch', 'signInToken', {
        "academicYear": widget.date['year'].toString(),
        "year": dataYear.toString(),
        "month": dataMonth.toString(),
        "cid": Provider.of<UserInfo>(context, listen: false).value[0].toString(),
      }, context);
    }else{
      childRes =
      await api(apiUrl.nuriChildSign, 'patch', 'signInToken', {
        "academicYear": widget.date['year'].toString(),
        "year": dataYear.toString(),
        "month": dataMonth.toString(),
        "id": dataChildId.toString(),
      }, context);
    }

    if (childRes!.statusCode == 200) {
      getNuriData(true);
    }
  }
  patchNuriData(int index, String comment) async {
    http.Response nuriRes = await api(
        apiUrl.nuriChild ,
        'patch',
        'signInToken',
        {
          "academicYear": widget.date['year'].toString(),
          "year": dataYear.toString(),
          "month": dataMonth.toString(),
          "id": dataChildId.toString(),
          'category' : index,
          "comment": comment
        },
        context);
    if (nuriRes.statusCode == 200) {
      getNuriData(true);
    }
  }

  setChildId(int newValue, int index) {
    setState(() {
      childId = newValue;
      selectIndex = index;
    });
  }

  setMonthStr(String newValue, int index, String newValueStr) {
    setState(() {
      nowMonth = newValue;
      selectMonthIndex = index;
      nowMonthStr = newValueStr;
    });
  }

  setTarget(String newValue, int index) {
    if(newValue == '학급별'){
      setState(() {
        targetClass = true;
      });
    }else{
      setState(() {
        targetClass = false;
      });
    }
  }

  lineCounter(String string){
    int count = 0;
    for(int i = 0; i< string.split('\n').length;i++){
      count = count + (string.split('\n')[i].length / 35).ceil();
    }
    return count == 0 ? 1:count;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // recordSetting();

    startDate = DateTime.parse(widget.date['startDate']);
    endDate = DateTime.parse(widget.date['endDate']);
    if (endDate.year - startDate.year > 0) {
      monthCount = endDate.month + 12 - startDate.month + 1;
    } else {
      monthCount = endDate.month - startDate.month + 1;
    }

    for (int i = startDate.month; i < startDate.month + monthCount; i++) {
      if (i > 12) {
        String monthString = (i - 12).toString();
        if (monthString.length == 1) {
          monthString = '0$monthString';
        }
        monthData.add(SelectMonth(
            date: '${endDate.year}년 ${i - 12}월',
            dataMonth: endDate.year.toString() + monthString));
      } else {
        String monthString = i.toString();
        if (monthString.length == 1) {
          monthString = '0$monthString';
        }
        monthData.add(SelectMonth(
            date: '${startDate.year}년 $i월',
            dataMonth: startDate.year.toString() + monthString));
      }
    }
    if(widget.pageTime != ''){
      nowMonth = widget.pageTime!;
      if(widget.targetClass!){
        targetClass = widget.targetClass!;
        targetIndex = 0;
      }else{
        targetClass = widget.targetClass!;
        childId = widget.childId!;
        targetIndex = 1;
      }
      getNuriData(false);
    }

  }

  @override
  Widget build(BuildContext context) {

    return Container(
        width: 1053.w,
        height: 1105.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.w), topLeft: Radius.circular(20.w)),
          boxShadow: [
            BoxShadow(
              color: Color(0x29ffffff),
              blurRadius: 6,
              offset: Offset(-2, 2),
            )
          ],
        ),
        child: Column(children: [
          Row(children: [
            CustomContainer(
              cBorderColor: borderColor,
              cTotalHeight: 119.w,
              cTotalWidth: 553.w,
              cBorderRadius: BorderRadius.only(topLeft: Radius.circular(20.w)),
              cInsideColor: Color(0xffCAACF2),
              cTopBorderWidth: 1.w,
              cLeftBorderWidth: 1.w,
              childWidget: Center(
                child: RecordTableTextStyle(
                  text: "${"${widget.date['year']}년도 " +
                      Provider.of<UserInfo>(context, listen: false).value[2]}의 누리과정분석",
                  title: false,
                ),
              ),
            ),
            Column(
              children: [
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 40.w,
                  cTotalWidth: 500.w,
                  cBorderRadius:
                      BorderRadius.only(topRight: Radius.circular(20.w)),
                  cInsideColor: Color(0xffE5D0FE),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cRightBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: "결재",
                      title: false,
                    ),
                  ),
                ),
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 80.w,
                      cTotalWidth: 86.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '담임',
                          title: false,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        patchSign();
                      },
                      child: CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 80.w,
                        cTotalWidth: 80.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        childWidget: Center(
                          child: signImage.isNotEmpty  ? signImage[0] ?? Container() : Container(),
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 80.w,
                      cTotalWidth: 87.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '원감',
                          title: false,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        patchSign();
                      },
                      child: CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 80.w,
                        cTotalWidth: 80.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        childWidget: Center(
                          child: signImage.length > 1  ? signImage[1] ?? Container() : Container(),
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 80.w,
                      cTotalWidth: 87.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '원장',
                          title: false,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        patchSign();
                      },
                      child: CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 80.w,
                        cTotalWidth: 80.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cRightBorderWidth: 1.w,
                        cBottomBorderWidth: 1.w,
                        childWidget: Center(
                          child: signImage.length > 2  ? signImage[2] ?? Container() : Container(),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ]),
          Row(
            children: [
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 87.w,
                cBorderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(20.w)),
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "대상",
                    title: false,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 168.w,
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // if (onOff) ...[
                      TargetDropDownButton(
                        borderColor: Colors.transparent,
                        borderRadius: 0,
                        width: 166,
                        shadow: false,
                        btnColor: Color(0xffFDB43B),
                        dropDownTarget: target,
                        setTarget: setTarget,
                        index: targetIndex,
                      ),
                    // ]
                  ],
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 87.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "월설정",
                    title: false,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 248.w,
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  MonthDropDownButton(
                    dropDownMonthInfo: monthData,
                    setChildId: setMonthStr,
                    getChildData: getChildData,
                    borderColor: Colors.transparent,
                    borderRadius: 0,
                    width: 246,
                    shadow: false,
                    btnColor: Color(0xffFDB43B),
                    index: widget.pageTime,
                  ),
                ]),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 87.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "해당유아",
                    title: false,
                  ),
                ),
              ),
              if(targetClass)...[
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 40.w,
                  cTotalWidth: 298.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cBottomBorderWidth: 1.w,
                  cRightBorderWidth: 1.w,
                ),
              ]else...[
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 40.w,
                  cTotalWidth: 298.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cBottomBorderWidth: 1.w,
                  cRightBorderWidth: 1.w,
                  childWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (onOff) ...[
                        ChildDropDownButton(
                          dropDownChildInfo: childList,
                          setChildId: setChildId,
                          borderColor: Colors.transparent,
                          borderRadius: 0,
                          width: 296,
                          shadow: false,
                          btnColor: const Color(0xffFDB43B),
                          index: widget.childId,
                        ),
                      ]
                    ],
                  ),
                ),
              ],

              SizedBox(
                width: 20.w,
              ),
              GestureDetector(
                onTap: () {
                  getNuriData(false);
                },
                child: Container(
                  width: 40.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    color: Color(0xffFED796),
                    borderRadius: BorderRadius.all(Radius.circular(5.w)),
                  ),
                  child: Center(
                      child: Text(
                    "검색",
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff393838)),
                  )),
                ),
              )
            ],
          ),
          SizedBox(
            height: 50.w,
          ),
          if (nuriData != null) ...[
            if(dataTargetClass)...[
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          CustomContainer(
                            cBorderColor: borderColor,
                            cTotalHeight: 415.w,
                            cTotalWidth: 637.w,
                            cInsideColor: Color(0xffffffff),
                            cBorderRadius:
                            BorderRadius.only(topLeft: Radius.circular(20.w)),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            childWidget: Stack(
                              children: [
                                Center(
                                  child: graphType ?
                                  NuriGraphViewer(
                                    categoryCount: nuriData['categoryScores'].length,
                                    categoryScore:
                                    nuriData["categoryScores"].cast<String>(),
                                  ):
                                  NuriBarGraph(
                                      categoryCount: nuriData['categoryScores'].length,
                                      categoryScore:
                                      nuriData["categoryScores"].cast<String>(),
                                  ),
                                  // NuriGraphViewer(
                                  //   categoryCount: nuriData['categoryScores'].length,
                                  //   categoryScore:
                                  //   nuriData["categoryScores"].cast<String>(),
                                  // ),
                                ),
                                Positioned(
                                    top: 20.w,
                                    right: 20.w,
                                    child:   GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          graphType = !graphType;
                                        });
                                      },
                                      child: Container(
                                        width: 80.w,
                                        height: 30.w,
                                        decoration: BoxDecoration(
                                          color: Color(0xffFED796),
                                          borderRadius: BorderRadius.all(Radius.circular(5.w)),
                                        ),
                                        child: Center(
                                            child: Text(
                                              graphType ? "레이더 차트" : '막대 그래프',
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff393838)),
                                            )),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          for (int i = 0;
                          i < nuriData['categoryScores'].length;
                          i++) ...[
                            NuriTable(
                              count: i,
                              age: nuriData['nuriAge'],
                              subCategoryScores:
                              nuriData['subCategoryScores'][i].cast<String>(),
                              last: i == nuriData['categoryScores'].length - 1
                                  ? true
                                  : false,
                            )
                          ],
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              CustomContainer(
                                cBorderColor: borderColor,
                                cTotalHeight: 40.w,
                                cTotalWidth: 96.w,
                                cInsideColor: Color(0xffE5D0FE),

                                cTopBorderWidth: 1.w,
                                // cLeftBorderWidth: 1.w,
                                childWidget: Center(
                                  child: Center(
                                    child: RecordTableTextStyle(
                                      text: "관찰기간",
                                      title: false,
                                    ),
                                  ),
                                ),
                              ),
                              CustomContainer(
                                cBorderColor: borderColor,
                                cTotalHeight: 40.w,
                                cTotalWidth: 320.w,
                                cInsideColor: Color(0xffffffff),
                                cBorderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20.w)),
                                cTopBorderWidth: 1.w,
                                cLeftBorderWidth: 1.w,
                                cRightBorderWidth: 1.w,
                                childWidget: Center(
                                  child: RecordTableTextStyle(
                                    text: dataMonthStr,
                                    title: false,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          CustomContainer(
                            cBorderColor: borderColor,
                            cTotalHeight:
                            (375 + (80 * nuriData["categoryScores"].length))
                                .w,
                            cTotalWidth: 415.w,
                            cInsideColor: Color(0xffffffff),
                            cBorderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20.w)),
                            cTopBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            cBottomBorderWidth: 1.w,
                            childWidget: Focus(
                              // onFocusChange: (hasFocus) {
                              //   if (hasFocus) {
                              //   } else {
                              //     if (nuriData['comment'] == commentTextField.text) {
                              //     } else {
                              //       // patchNuriData(commentTextField.text);
                              //     }
                              //   }
                              // },
                              child: TextField(
                                readOnly: true,
                                maxLines: 30,
                                textAlignVertical: TextAlignVertical.center,
                                style:TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff393838)),
                                // controller: commentTextField,
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ), //외곽선
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            ]else...[
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          CustomContainer(
                            cBorderColor: borderColor,
                            cTotalHeight: 415.w,
                            cTotalWidth: 637.w,
                            cInsideColor: Color(0xffffffff),
                            cBorderRadius:
                            BorderRadius.only(topLeft: Radius.circular(20.w)),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            childWidget: Stack(
                              children: [
                                Center(
                                  child: graphType ?
                                  NuriGraphViewer(
                                    categoryCount: nuriData['categoryScores'].length,
                                    categoryScore:
                                    nuriData["categoryScores"].cast<String>(),
                                  ):
                                  NuriBarGraph(
                                    categoryCount: nuriData['categoryScores'].length,
                                    categoryScore:
                                    nuriData["categoryScores"].cast<String>(),
                                  ),
                                  // NuriGraphViewer(
                                  //   categoryCount: nuriData['categoryScores'].length,
                                  //   categoryScore:
                                  //   nuriData["categoryScores"].cast<String>(),
                                  // ),
                                ),
                                Positioned(
                                    top: 20.w,
                                    right: 20.w,
                                    child:   GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          graphType = !graphType;
                                        });
                                      },
                                      child: Container(
                                        width: 80.w,
                                        height: 30.w,
                                        decoration: BoxDecoration(
                                          color: Color(0xffFED796),
                                          borderRadius: BorderRadius.all(Radius.circular(5.w)),
                                        ),
                                        child: Center(
                                            child: Text(
                                              graphType ? "레이더 차트" : '막대 그래프',
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff393838)),
                                            )),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          for (int i = 0;
                          i < nuriData['categoryScores'].length;
                          i++) ...[
                            NuriTable(
                              count: i,
                              age: nuriData['nuriAge'],
                              subCategoryCounts:
                              nuriData['subCategoryCounts'][i].cast<int>(),
                              last: i == nuriData['categoryScores'].length - 1
                                  ? true
                                  : false,
                            )
                          ],
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              CustomContainer(
                                cBorderColor: borderColor,
                                cTotalHeight: 40.w,
                                cTotalWidth: 96.w,
                                cInsideColor: Color(0xffE5D0FE),

                                cTopBorderWidth: 1.w,
                                // cLeftBorderWidth: 1.w,
                                childWidget: Center(
                                  child: RecordTableTextStyle(
                                    text: "관찰기간",
                                    title: false,
                                  ),
                                ),
                              ),
                              CustomContainer(
                                cBorderColor: borderColor,
                                cTotalHeight: 40.w,
                                cTotalWidth: 320.w,
                                cInsideColor: Color(0xffffffff),
                                cBorderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20.w)),
                                cTopBorderWidth: 1.w,
                                cLeftBorderWidth: 1.w,
                                cRightBorderWidth: 1.w,
                                childWidget: Center(
                                  child: RecordTableTextStyle(
                                    text: dataMonthStr,
                                    title: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          CustomContainer(
                            cBorderColor: borderColor,
                            cTotalHeight:
                            (375 + (80 * nuriData["categoryScores"].length))
                                .w,
                            cTotalWidth: 415.w,
                            cInsideColor: Color(0xffffffff),
                            cBorderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20.w)),
                            cTopBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            cBottomBorderWidth: 1.w,
                            childWidget: Stack(
                              children: [
                                ListView(
                                  padding: EdgeInsets.zero,
                                  children: [
                                    for(int i = 0; i< commentTextField.length;i++)...[
                                      RecordTableTextStyle(
                                        text: nuri.area[nuriData['nuriAge']][nuriData['comments'][i]['category'] -1],
                                        title: false,
                                      ),
                                      Focus(
                                        onFocusChange: (hasFocus) {
                                          if (hasFocus) {
                                          } else {
                                            if
                                            (nuriData['comments'][i] == commentTextField[i].text) {
                                            } else {
                                              patchNuriData(nuriData['comments'][i]['category'],commentTextField[i].text);
                                            }
                                          }
                                        },
                                        child: TextField(
                                          maxLines: lineCounter(commentTextField[i].text),
                                          textAlignVertical: TextAlignVertical.center,
                                          style:TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff393838)),
                                          controller: commentTextField[i],
                                          textAlign: TextAlign.start,
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ), //외곽선
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 415.w,
                                        height: 1.w,
                                        color: borderColor,
                                      )
                                    ]

                                  ],
                                ),
                                Positioned(
                                    right: 5.w,
                                    top: 5.w,
                                    child: GestureDetector(
                                      onTap: () {
                                        getCommentData();
                                      },
                                      child: Container(
                                        width: 35.w,
                                        height: 35.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10.w)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x29505050),
                                              blurRadius: 6,
                                              offset: Offset(
                                                  1, 1), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.refresh,
                                          size: 24.w,
                                          color: Color(0xffA666FB),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            ]

          ]
        ]));
  }
}

class NuriGraphViewer extends StatefulWidget {
  const NuriGraphViewer({
    Key? key,
    required this.categoryCount,
    required this.categoryScore,
  }) : super(key: key);
  final int categoryCount;
  final List<String> categoryScore;

  @override
  State<NuriGraphViewer> createState() => _NuriGraphViewerState();
}

class _NuriGraphViewerState extends State<NuriGraphViewer> {
  final radius1 = 50;
  final radius2 = 100;
  final radius3 = 150;
  double radiusChild = 0;

  List<List<GlobalKey>> pointDot = [[], [], []];
  List<List<Offset>> pointPosition = [[], [], []];
  List<GlobalKey> polygonDot = [];
  List<Offset> polygonPosition = [];

  GlobalKey parentWidget = GlobalKey();
  Offset parentPosition = Offset.zero;

  // List<double> categoryScore = [1.2, 2.2, 2, 2.5, 1.8, 1.9];

  List<String> area5 = [
    '신체운동ㆍ건강',
    '의사소통',
    '사회관계',
    '예술경험',
    '자연탐구',
  ];
  List<String> area6 = [
    '기본생활',
    '신체운동',
    '의사소통',
    '사회관계',
    '예술경험',
    '자연탐구',
  ];

  getPosition(GlobalKey key) {
    if (key.currentContext != null) {
      final RenderBox renderBox =
          key.currentContext!.findRenderObject() as RenderBox;
      Offset position = renderBox.localToGlobal(Offset.zero);
      return position;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // radiusChild = 360 / categoryCount;
    // for(int i = 0; i< 3;i++){
    //   for(int j = 0; j< categoryCount;j++){
    //     pointDot[i].add(GlobalKey());
    //   }
    // }
    // for(int i = 0; i< categoryCount;i++){
    //   polygonDot.add(GlobalKey());
    // }
  }

  _afterLayout(_) {
    if(mounted){
      setState(() {
        pointPosition = [[], [], []];
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < widget.categoryCount; j++) {
            pointPosition[i].add(getPosition(pointDot[i][j]));
            parentPosition = getPosition(parentWidget);
          }
        }
        polygonPosition = [];
        for (int i = 0; i < widget.categoryCount; i++) {
          polygonPosition.add(getPosition(polygonDot[i]));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    pointDot = [[], [], []];
    radiusChild = 360 / widget.categoryCount;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < widget.categoryCount; j++) {
        pointDot[i].add(GlobalKey());
      }
    }
    for (int i = 0; i < widget.categoryCount; i++) {
      polygonDot.add(GlobalKey());
    }
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    return Container(
      key: parentWidget,
      child: Center(
        child: Stack(
          children: [
            for (int i = 0; i < widget.categoryCount; i++) ...[
              Center(
                child: Transform.rotate(
                  angle: (90 * math.pi / 180) + math.pi,
                  child: Transform(
                      transform: Matrix4.identity()
                        ..translate(radius1.w * cos(radians(radiusChild * i)),
                            radius1.w * sin(radians(radiusChild * i))),
                      child: Container(
                        key: pointDot[0][i],
                        width: 2.w,
                        height: 2.w,
                        // color: Colors.black,
                      )),
                ),
              ),
              Center(
                child: Transform.rotate(
                  angle: (90 * math.pi / 180) + math.pi,
                  child: Transform(
                      transform: Matrix4.identity()
                        ..translate(radius2.w * cos(radians(radiusChild * i)),
                            radius2.w * sin(radians(radiusChild * i))),
                      child: Container(
                        key: pointDot[1][i],
                        width: 2.w,
                        height: 2.w,
                        // color: Colors.black,
                      )),
                ),
              ),
              Center(
                child: Transform.rotate(
                  angle: (90 * math.pi / 180) + math.pi,
                  child: Transform(
                      transform: Matrix4.identity()
                        ..translate(radius3.w * cos(radians(radiusChild * i)),
                            radius3.w * sin(radians(radiusChild * i))),
                      child: Container(
                        key: pointDot[2][i],
                        width: 2.w,
                        height: 2.w,
                        // color: Colors.black,
                      )),
                ),
              ),
              if (widget.categoryCount > 5) ...[
                Center(
                  child: Transform.rotate(
                    angle: (90 * math.pi / 180) + math.pi,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..translate(180.w * cos(radians(radiusChild * i)),
                            180.w * sin(radians(radiusChild * i))),
                      child: Transform.rotate(
                          angle: (-90 * math.pi / 180) + math.pi,
                          child: Text(
                            area6[i],
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff393838)),
                          )),
                    ),
                  ),
                ),
              ] else ...[
                Center(
                  child: Transform.rotate(
                    angle: (90 * math.pi / 180) + math.pi,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..translate(180.w * cos(radians(radiusChild * i)),
                            180.w * sin(radians(radiusChild * i))),
                      child: Transform.rotate(
                          angle: (-90 * math.pi / 180) + math.pi,
                          child: Text(
                            area5[i],
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff393838)),
                          )),
                    ),
                  ),
                ),
              ]

              // Transform.rotate(
              //   angle: ((radiusChild) * i * math.pi / 180) + math.pi,
              //   child: Transform(
              //       transform: Matrix4.identity()
              //         ..translate(
              //             0 * cos(radians(radiusChild * i)) - (radius - 160).w,
              //             0 * sin(radians(radiusChild * i))),
              //       child: Container(
              //         width: 100.w,
              //       height: 1.w,
              //       color: Colors.red,)),
              // ),
            ],
            if (pointPosition[0].isNotEmpty) ...[
              for (int i = 0; i < widget.categoryCount; i++) ...[
                if (i == widget.categoryCount - 1) ...[
                  Center(
                    child: CustomPaint(
                        size: Size(637.w, 415.w),
                        painter: MyPainter(
                          lineStart: pointPosition[0][i] - parentPosition,
                          lineEnd: pointPosition[0][0] - parentPosition,
                        )),
                  )
                ] else ...[
                  Center(
                    child: CustomPaint(
                        size: Size(637.w, 415.w),
                        painter: MyPainter(
                          lineStart: pointPosition[0][i] - parentPosition,
                          lineEnd: pointPosition[0][i + 1] - parentPosition,
                        )),
                  )
                ]
              ]
            ],
            if (pointPosition[1].isNotEmpty) ...[
              for (int i = 0; i < widget.categoryCount; i++) ...[
                if (i == widget.categoryCount - 1) ...[
                  Center(
                    child: CustomPaint(
                        size: Size(637.w, 415.w),
                        painter: MyPainter(
                          lineStart: pointPosition[1][i] - parentPosition,
                          lineEnd: pointPosition[1][0] - parentPosition,
                        )),
                  )
                ] else ...[
                  Center(
                    child: CustomPaint(
                        size: Size(637.w, 415.w),
                        painter: MyPainter(
                          lineStart: pointPosition[1][i] - parentPosition,
                          lineEnd: pointPosition[1][i + 1] - parentPosition,
                        )),
                  )
                ]
              ]
            ],
            if (pointPosition[2].isNotEmpty) ...[
              for (int i = 0; i < widget.categoryCount; i++) ...[
                if (i == widget.categoryCount - 1) ...[
                  Center(
                    child: CustomPaint(
                        size: Size(637.w, 415.w),
                        painter: MyPainter(
                          lineStart: pointPosition[2][i] - parentPosition,
                          lineEnd: pointPosition[2][0] - parentPosition,
                        )),
                  )
                ] else ...[
                  Center(
                    child: CustomPaint(
                        size: Size(637.w, 415.w),
                        painter: MyPainter(
                          lineStart: pointPosition[2][i] - parentPosition,
                          lineEnd: pointPosition[2][i + 1] - parentPosition,
                        )),
                  )
                ]
              ]
            ],
            if (polygonPosition.isNotEmpty) ...[
              if (polygonPosition.length > 5) ...[
                CustomPaint(
                  painter: PolygonPainter(
                    strokeColor: Color(0xffA3EFE0),
                    strokeWidth: 6.w,
                    paintingStyle: PaintingStyle.fill,
                    offsetA:
                        polygonPosition[0] - parentPosition - Offset(-8.w, 8.w),
                    offsetB:
                        polygonPosition[1] - parentPosition - Offset(-8.w, 8.w),
                    offsetC:
                        polygonPosition[2] - parentPosition - Offset(-8.w, 8.w),
                    offsetD:
                        polygonPosition[3] - parentPosition - Offset(-8.w, 8.w),
                    offsetE:
                        polygonPosition[4] - parentPosition - Offset(-8.w, 8.w),
                    offsetF:
                        polygonPosition[5] - parentPosition - Offset(-8.w, 8.w),
                  ),
                ),
              ] else ...[
                CustomPaint(
                  painter: PolygonPainter(
                    strokeColor: Color(0xffA3EFE0),
                    strokeWidth: 6.w,
                    paintingStyle: PaintingStyle.fill,
                    offsetA:
                        polygonPosition[0] - parentPosition - Offset(-8.w, 8.w),
                    offsetB:
                        polygonPosition[1] - parentPosition - Offset(-8.w, 8.w),
                    offsetC:
                        polygonPosition[2] - parentPosition - Offset(-8.w, 8.w),
                    offsetD:
                        polygonPosition[3] - parentPosition - Offset(-8.w, 8.w),
                    offsetE:
                        polygonPosition[4] - parentPosition - Offset(-8.w, 8.w),
                  ),
                ),
              ]
            ],
            if (pointPosition[0].isNotEmpty) ...[
              for (int i = 0; i < widget.categoryCount; i++) ...[
                if (i == widget.categoryCount - 1) ...[
                  Center(
                    child: CustomPaint(
                        size: Size(637.w, 415.w),
                        painter: MyPainter(
                          lineStart: polygonPosition[i] -
                              parentPosition -
                              Offset(-8.w, 8.w),
                          lineEnd: polygonPosition[0] -
                              parentPosition -
                              Offset(-8.w, 8.w),
                          strokeWidth: 6,
                          strokeColor: Color(0xff65B7A7),
                        )),
                  )
                ] else ...[
                  Center(
                    child: CustomPaint(
                        size: Size(637.w, 415.w),
                        painter: MyPainter(
                          lineStart: polygonPosition[i] -
                              parentPosition -
                              Offset(-8.w, 8.w),
                          lineEnd: polygonPosition[i + 1] -
                              parentPosition -
                              Offset(-8.w, 8.w),
                          strokeWidth: 6,
                          strokeColor: Color(0xff65B7A7),
                        )),
                  )
                ]
              ]
            ],
            for (int i = 0; i < widget.categoryCount; i++) ...[
              Center(
                child: Transform.rotate(
                  angle: (90 * math.pi / 180) + math.pi,
                  child: Transform(
                      transform: Matrix4.identity()
                        ..translate(
                            (double.parse(widget.categoryScore[i]) * 50).w *
                                cos(radians(radiusChild * i)),
                            (double.parse(widget.categoryScore[i]) * 50).w *
                                sin(radians(radiusChild * i))),
                      child: Container(
                        key: polygonDot[i],
                        width: 16.w,
                        height: 16.w,
                        color: double.parse(widget.categoryScore[i]) * 50 == 0
                            ? Colors.transparent
                            : Color(0xff65B7A7),
                      )),
                ),
              ),
              Center(
                child: Transform.rotate(
                  angle: (90 * math.pi / 180) + math.pi,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(
                          (double.parse(widget.categoryScore[i]) * 50).w *
                              cos(radians(radiusChild * i)),
                          (double.parse(widget.categoryScore[i]) * 50).w *
                              sin(radians(radiusChild * i))),
                    child: Transform.rotate(
                        angle: (-90 * math.pi / 180) + math.pi,
                        child: Text(
                          widget.categoryScore[i],
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff393838)),
                        )),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  const MyPainter({
    Key? key,
    required this.lineEnd,
    required this.lineStart,
    this.strokeWidth = 3,
    this.strokeColor = const Color(0xff1D1D1B),
  });

  final Offset lineStart;
  final Offset lineEnd;
  final double strokeWidth;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = lineStart;
    final p2 = lineEnd;
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth.w
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}

class PolygonPainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  final Offset offsetA;
  final Offset offsetB;
  final Offset offsetC;
  final Offset offsetD;
  final Offset offsetE;
  final Offset? offsetF;

  PolygonPainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke,
      this.offsetA = Offset.zero,
      this.offsetB = Offset.zero,
      this.offsetC = Offset.zero,
      this.offsetD = Offset.zero,
      this.offsetE = Offset.zero,
      this.offsetF});

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(
        getPolygonPath(offsetA, offsetB, offsetC, offsetD, offsetE, offsetF),
        paint);
  }

  Path getPolygonPath(Offset offsetA, Offset offsetB, Offset offsetC,
      Offset offsetD, Offset offsetE, Offset? offsetF) {
    if (offsetF != null) {
      return Path()
        ..moveTo(offsetA.dx, offsetA.dy)
        ..lineTo(offsetB.dx, offsetB.dy)
        ..lineTo(offsetC.dx, offsetC.dy)
        ..lineTo(offsetD.dx, offsetD.dy)
        ..lineTo(offsetE.dx, offsetE.dy)
        ..lineTo(offsetF.dx, offsetF.dy)
        ..lineTo(offsetA.dx, offsetA.dy);
    }
    return Path()
      ..moveTo(offsetA.dx, offsetA.dy)
      ..lineTo(offsetB.dx, offsetB.dy)
      ..lineTo(offsetC.dx, offsetC.dy)
      ..lineTo(offsetD.dx, offsetD.dy)
      ..lineTo(offsetE.dx, offsetE.dy)
      ..lineTo(offsetA.dx, offsetA.dy);
  }

  @override
  bool shouldRepaint(PolygonPainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class NuriTable extends StatefulWidget {
  const NuriTable({
    Key? key,
    required this.count,
    required this.age,
    this.subCategoryCounts,
    this.subCategoryScores,
    this.last = false,
  }) : super(key: key);
  final int age;
  final int count;
  final List<int>? subCategoryCounts;
  final List<String>? subCategoryScores;
  final bool last;

  @override
  State<NuriTable> createState() => _NuriTableState();
}

class _NuriTableState extends State<NuriTable> {
  Nuri nuri = Nuri();

  @override
  Widget build(BuildContext context) {
    Color borderColor = const Color(0x9dC13BFD);
    return Column(
      children: [
        Row(
          children: [
            CustomContainer(
              cBorderColor: borderColor,
              cTotalHeight: 40.w,
              cTotalWidth: 158.5.w,
              cInsideColor: Color(0xffCAACF2),
              cTopBorderWidth: 1.w,
              cLeftBorderWidth: 1.w,
              childWidget: Center(
                child: RecordTableTextStyle(
                  text: nuri.area[widget.age][widget.count],
                  title: false,
                ),
              ),
            ),
            CustomContainer(
              cBorderColor: borderColor,
              cTotalHeight: 40.w,
              cTotalWidth: 159.5.w,
              cInsideColor: Color(0xffE5D0FE),
              cTopBorderWidth: 1.w,
              cLeftBorderWidth: 1.w,
              childWidget: Center(
                child: RecordTableTextStyle(
                  text: nuri.areaContent[widget.age][widget.count][0],
                  title: false,
                ),
              ),
            ),
            CustomContainer(
              cBorderColor: borderColor,
              cTotalHeight: 40.w,
              cTotalWidth: 159.5.w,
              cInsideColor: Color(0xffE5D0FE),
              cTopBorderWidth: 1.w,
              cLeftBorderWidth: 1.w,
              childWidget: Center(
                child: RecordTableTextStyle(
                  text: nuri.areaContent[widget.age][widget.count][1],
                  title: false,
                ),
              ),
            ),
            if (nuri.areaContent[widget.age][widget.count].length > 2) ...[
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 159.5.w,
                cInsideColor: Color(0xffE5D0FE),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: nuri.areaContent[widget.age][widget.count][2],
                    title: false,
                  ),
                ),
              ),
            ] else ...[
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 159.5.w,
                cInsideColor: Color(0xffE5D0FE),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
              ),
            ]
          ],
        ),
        Row(
          children: [
            CustomContainer(
              cBorderColor: borderColor,
              cTotalHeight: 40.w,
              cTotalWidth: 158.5.w,
              cInsideColor: Color(0xffffffff),
              cBorderRadius: widget.last
                  ? BorderRadius.only(bottomLeft: Radius.circular(20.w))
                  : BorderRadius.zero,
              cTopBorderWidth: 1.w,
              cLeftBorderWidth: 1.w,
              cBottomBorderWidth: widget.last ? 1.w : 0,
              childWidget: Center(
                child: RecordTableTextStyle(
                  text: "집계",
                  title: false,
                ),
              ),
            ),
            CustomContainer(
              cBorderColor: borderColor,
              cTotalHeight: 40.w,
              cTotalWidth: 159.5.w,
              cInsideColor: Color(0xffffffff),
              cTopBorderWidth: 1.w,
              cLeftBorderWidth: 1.w,
              cBottomBorderWidth: widget.last ? 1.w : 0,
              childWidget: Center(
                child: RecordTableTextStyle(
                  text: widget.subCategoryCounts != null ? widget.subCategoryCounts![0].toString() : widget.subCategoryScores![0],
                  title: false,
                ),
              ),
            ),
            CustomContainer(
              cBorderColor: borderColor,
              cTotalHeight: 40.w,
              cTotalWidth: 159.5.w,
              cInsideColor: Color(0xffffffff),
              cTopBorderWidth: 1.w,
              cLeftBorderWidth: 1.w,
              cBottomBorderWidth: widget.last ? 1.w : 0,
              childWidget: Center(
                child: RecordTableTextStyle(
                  text: widget.subCategoryCounts != null ? widget.subCategoryCounts![1].toString() : widget.subCategoryScores![1],
                  title: false,
                ),
              ),
            ),
            if (nuri.areaContent[widget.age][widget.count].length > 2) ...[
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 159.5.w,
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                cBottomBorderWidth: widget.last ? 1.w : 0,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: widget.subCategoryCounts != null ? widget.subCategoryCounts![2].toString() : widget.subCategoryScores![2],
                    title: false,
                  ),
                ),
              ),
            ] else ...[
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 159.5.w,
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                cBottomBorderWidth: widget.last ? 1.w : 0,
              ),
            ]
          ],
        ),
      ],
    );
  }
}


class NuriBarGraph extends StatefulWidget {
  const NuriBarGraph({Key? key,
    required this.categoryCount,
    required this.categoryScore,
  }) : super(key: key);
  final int categoryCount;
  final List<String> categoryScore;

  @override
  State<NuriBarGraph> createState() => _NuriBarGraphState();
}

class _NuriBarGraphState extends State<NuriBarGraph> {
  @override
  Widget build(BuildContext context) {
    List<String> area5 = [
      '신체운동ㆍ건강',
      '의사소통',
      '사회관계',
      '예술경험',
      '자연탐구',
    ];
    List<String> area6 = [
      '기본생활',
      '신체운동',
      '의사소통',
      '사회관계',
      '예술경험',
      '자연탐구',
    ];
    return Container(
      width: 600.w,
      height: 380.w,
      // color: Colors.red,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
              bottom: 80.w,
              child: Container(
                height: 1.w,
                width: 550.w,
                color: Color(0x661D1D1B),
              )),
          Positioned(
              bottom: 130.w,
              child: Container(
                height: 1.w,
                width: 550.w,
                color: Color(0x661D1D1B),
              )),
          Positioned(
              bottom: 180.w,
              child: Container(
                height: 1.w,
                width: 550.w,
                color: Color(0x661D1D1B),
              )),
          Positioned(
              bottom: 230.w,
              child: Container(
                height: 1.w,
                width: 550.w,
                color: Color(0x661D1D1B),
              )),
          Positioned(
              bottom: 280.w,
              child: Container(
                height: 1.w,
                width: 550.w,
                color: Color(0x661D1D1B),
              )),

          Positioned(
            left: 5.w,
            bottom: 22.w,
            child:  Container(
              width: 20.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RecordTableTextStyle(
                  text: '0',
                  title: false,
          ),
                ],
              ),
            ),),
          Positioned(
            left: 5.w,
            bottom: 72.w,
            child:  Container(
              width: 20.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RecordTableTextStyle(
                    text: '0.5',
                    title: false,
                  ),
                ],
              ),
            ),),
          Positioned(
            left: 5.w,
            bottom: 122.w,
            child:  Container(
              width: 20.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RecordTableTextStyle(
                    text: '1.0',
                    title: false,
                  ),
                ],
              ),
            ),),
          Positioned(
            left: 5.w,
            bottom: 172.w,
            child:  Container(
              width: 20.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RecordTableTextStyle(
                    text: '1.5',
                    title: false,
                  ),
                ],
              ),
            ),),
          Positioned(
            left: 5.w,
            bottom: 222.w,
            child:  Container(
              width: 20.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RecordTableTextStyle(
                    text: '2.0',
                    title: false,
                  ),
                ],
              ),
            ),),
          Positioned(
            left: 5.w,
            bottom: 272.w,
            child:  Container(
              width: 20.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RecordTableTextStyle(
                    text: '2.5',
                    title: false,
                  ),
                ],
              ),
            ),),
          Positioned(
            left: 5.w,
            bottom: 322.w,
            child:  Container(
              width: 20.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RecordTableTextStyle(
                    text: '3.0',
                    title: false,
                  ),
                ],
              ),
            ),),
          Positioned(
            right: 0.w,
            bottom: 0.w,
            child: Container(
              width: 600.w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for(int i = 0; i< widget.categoryCount;i++)...[
                    BarGraphBar(text: widget.categoryCount == 6 ? area6[i] : area5[i], categoryCount: widget.categoryCount, categoryScore: double.parse(widget.categoryScore[i])),
                  ]
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 30.w,
              child: Container(
                height: 3.w,
                width: 550.w,
                color: Color(0xff1D1D1B),
              )),
        ],
      ),
    );
  }
}


class BarGraphBar extends StatefulWidget {
  const BarGraphBar({Key? key,
    required this.text,
    required this.categoryCount,
    required this.categoryScore,
  }) : super(key: key);
  final String text;
  final int categoryCount;
  final double categoryScore;

  @override
  State<BarGraphBar> createState() => _BarGraphBarState();
}

class _BarGraphBarState extends State<BarGraphBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.categoryCount == 6 ? 90.w : 108.w,
      height: 350.w,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            bottom: 30.w,
              child: CustomContainer(
            cTotalWidth: widget.categoryCount == 6 ? 70.w : 85.w,
            cTotalHeight: (widget.categoryScore * 100).w,
            cInsideColor: Color(0xffA3EFE0),
            cBorderColor: Color(0xff65B7A7),
            cRightBorderWidth: widget.categoryScore == 0 ? 0 : 6.w,
            cLeftBorderWidth: widget.categoryScore == 0 ? 0 : 6.w,
            cTopBorderWidth: widget.categoryScore == 0 ? 0 : 6.w,
          )),

          Positioned(
              bottom: widget.categoryScore == 0 ? widget.categoryCount == 6 ? 30 : 35 :((widget.categoryCount == 6 ? 20.w : 17.5) + widget.categoryScore * 100).w,
              child: Container(
                width: widget.categoryCount == 6 ? 25.w : 30.w,
                height: widget.categoryCount == 6 ? 20.w : 25.w,
                color: Color(0xff65B7A7),
                child: Center(
                  child: Text(
                    widget.categoryScore.toString(),
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
              )),
          Positioned(
            left: 0.w,
              bottom: 15.w,
              child: Container(
                height: 317.w,
                width: 1.w,
                color: Color(0x661D1D1B),
              )
          ),
          Positioned(
            bottom: 5,
            child: RecordTableTextStyle(
              text: widget.text,
              title: false,
            ),
          ),
        ],
      ),
    );
  }
}



