// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:treasure_map/api/activity.dart';
import 'package:treasure_map/widgets/calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provider/app_management.dart';
import '../widgets/api.dart';
import '../widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:aligned_dialog/aligned_dialog.dart';

//---------------------------------------------------안전사고---------------------------------------------------\\
class C8 extends StatefulWidget {
  const C8({
    Key? key,
    required this.nextPage,
    required this.prePage,
    required this.nowPage,
    this.scaffoldKey,
  }) : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<C8> createState() => _C8State();
}

class _C8State extends State<C8> {
  static final autoLoginStorage = FlutterSecureStorage();
  bool dateOn = false;

  bool selected = true;
  bool dropDownOn = true;
  int childId = 0;

  List<DropDownChildInfo> dropDownChildInfo = [];
  List<GetAccident> childAccidentData = [];
  List<List<TextEditingController>> textEditingController = [];
  List<String> accidentTime = [];
  setChildId(int newValue) {
    setState(() {
      childId = newValue;
    });
  }

  List<String> testchildnamelist = [];
  ApiUrl apiUrl = ApiUrl();

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

  postAccidentData() async {
    http.Response accidentRes =
    await api(apiUrl.accident, 'post', 'signInToken', {
      'id': childId.toString(),
      'cid': Provider.of<UserInfo>(context, listen: false).value[0].toString()
    }, context);
    if(accidentRes.statusCode == 200){
        setState(() {
          receiveData(pageTime);
          childId = 0;
        });
    }
  }

  getChildAccidentData() async {
    http.Response accidentRes =
    await api(apiUrl.accident + '/' + Provider.of<UserInfo>(context, listen: false).value[0].toString(), 'get', 'signInToken', {}, context);
    if(accidentRes.statusCode == 200){
      var accidentRB = utf8.decode(accidentRes.bodyBytes);
      var accidentData = jsonDecode(accidentRB);
      textEditingController.clear();
      childAccidentData.clear();
      accidentTime.clear();

        setState(() {
          for (int i = 0; i < accidentData.length; i++) {
            childAccidentData.add(GetAccident(
                name: accidentData[i]['name'],
                date: accidentData[i]['date'],
                id: accidentData[i]['id'],
                sex: accidentData[i]['sex'],
                accidentType: accidentData[i]['accidentType'],
                aid: accidentData[i]['aid'],
                cause: accidentData[i]['cause'],
                contactTime: accidentData[i]['contactTime'],
                hospitalAction: accidentData[i]['hospitalAction'],
                isAmbulanced: accidentData[i]['isAmbulanced'],
                isInsuranced: accidentData[i]['isInsuranced'],
                medicalFee: accidentData[i]['medicalFee'],
                place: accidentData[i]['place'],
                situation: accidentData[i]['situation'],
                teacherAction: accidentData[i]['teacherAction'],
                time: accidentData[i]['time']));
            textEditingController.add([]);
            for(int j = 0; j< 7; j++){
              textEditingController[i].add(TextEditingController());
            }
            textEditingController[i][0].text = accidentData[i]['teacherAction'];
            textEditingController[i][1].text = accidentData[i]['hospitalAction'];

            try{
              int fee = accidentData[i]['medicalFee'].toInt();
              if(accidentData[i]['medicalFee'] == fee){
                textEditingController[i][2].text = fee.toString();
              }else{
                textEditingController[i][2].text = accidentData[i]['medicalFee'].toString();
              }
            } catch(e){
              textEditingController[i][2].text = accidentData[i]['medicalFee'] == null
                  ? ""
                  : accidentData[i]['medicalFee'].toString();
            }

            textEditingController[i][3].text = accidentData[i]['place'];
            textEditingController[i][4].text = accidentData[i]['situation'];
            textEditingController[i][5].text = accidentData[i]['cause'];
            textEditingController[i][6].text = accidentData[i]['accidentType'];
            accidentTime.add('');
            for (int j = 0; j < accidentData[i]['time'].split(':').length - 1; j++) {
              accidentTime[i] = accidentTime[i] + accidentData[i]['time'].split(':')[j];
              if(j == 0){
                accidentTime[i] = accidentTime[i] + ":";
              }
            }
          }
        });
    }
  }

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  receiveData(DateTime dateTime) async {
    //api 보내는 날짜를 바꿈
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    //api 통신 후 데이터 받아오기

    //......
    setState(() {
      getChildAccidentData();
      //데이터 넣어주기
      //ex) data = response["data"];
    });
  }

  @override
  initState() {
    receiveData(pageTime);
    super.initState();
    //애들 갯수 구해서 childNum에 쑤셔박기
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.w),
          bottomLeft: Radius.circular(50.w),
        ),
        color: const Color(0xffFCFCFC),
      ),
      child: Column(
        children: [
          OverTab(
            nextPage: widget.nextPage,
            prePage: widget.prePage,
            nowPage: widget.nowPage,
            dateOnOff: dateOn,
            receiveData: receiveData,
            scaffoldKey: widget.scaffoldKey,
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                physics: const RangeMaintainingScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 49.w,
                            height: 50.w,
                            color: const Color(0xffFCFCFC),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          selected
                              ? setState(() {
                                  getChildData();
                                  selected = !selected;
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    setState(() {
                                      dropDownOn = false;
                                    });
                                  });
                                })
                              : setState(() {});
                        },
                        child: AnimatedContainer(
                          width: selected ? 100.w : 200.w,
                          height: selected ? 50.w : 50.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.w)),
                            color: Color(0xffFFD288),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x29000000),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(left: selected ? 444.w : 344.w),
                          duration: Duration(milliseconds: 500),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 10.w,
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                width: selected ? 0.w : 120.w,
                                height: 35.w,
                                // color: Colors.white,
                                child: selected
                                    ? Icon(
                                        Icons.add,
                                        size: 24.w,
                                        color: Color(0xffA76917),
                                      )
                                    : Container(
                                        width: 100.w,
                                        height: 35.w,
                                        color: Colors.white,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              dropDownOn
                                                  ? Container()
                                                  : ChildDropDownButton(
                                                      setChildId: setChildId,
                                                      dropDownChildInfo:
                                                          dropDownChildInfo,
                                                    ),
                                            ])),
                              ),
                              Spacer(),
                              Container(
                                child: GestureDetector(
                                  onTap: () {
                                    if (selected) {
                                      getChildData();
                                      selected = !selected;
                                      Future.delayed(
                                          const Duration(milliseconds: 500), () {
                                        setState(() {
                                          dropDownOn = false;
                                        });
                                      });
                                    } else {
                                      childId != 0
                                          ? setState(() {
                                              selected = !selected;
                                              dropDownOn = true;
                                              postAccidentData();
                                            })
                                          : setState(() {});
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    width: 50.w,
                                    height: 35.w,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10.w)),
                                      color: selected
                                          ? Colors.transparent
                                          : Color(0xffffffff),
                                      boxShadow: [
                                        selected
                                            ? BoxShadow(
                                                color: Colors.transparent,
                                              )
                                            : BoxShadow(
                                                color: Color(0x29000000),
                                                blurRadius: 6,
                                                offset: Offset(0, 3),
                                              ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        '추가',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xffA76917),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30.w,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30.w,
                  ),
                  for (int i = childAccidentData.length - 1; i >= 0; i--) ...[
                    Row(
                      children: [
                        Container(
                          width: 39.w,
                          height: 373.w,
                          color: const Color(0xffFCFCFC),
                        ),
                        ChildAccidentWidget(
                          getAccident: childAccidentData[i],
                          receiveData: receiveData,
                          accidentTime: accidentTime[i],
                          textEditingController: textEditingController[i],
                        ),
                      ],
                    ),
                    if (i != 0) ...[
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: 50.w,
                            color: const Color(0xffFCFCFC),
                          ),
                        ],
                      )
                    ],
                  ],
                  Row(
                    children: [
                      Container(
                        width: 39.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          color: const Color(0xffFCFCFC),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50.w)),
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

class DropDownChildInfo {
  String childName;
  int childId;

  DropDownChildInfo({
    required this.childName,
    required this.childId,
  });
}

class ChildDropDownButton extends StatefulWidget {
  const ChildDropDownButton({
    Key? key,
    required this.dropDownChildInfo,
    required this.setChildId,
  }) : super(key: key);
  final List<DropDownChildInfo> dropDownChildInfo;
  final Function(int) setChildId;

  @override
  State<ChildDropDownButton> createState() => _ChildDropDownButtonState();
}

class _ChildDropDownButtonState extends State<ChildDropDownButton> {
  List<int> number = [];
  int now = -1;

  List<DropdownMenuItem<int>> childList() {
    return number
        .map<DropdownMenuItem<int>>(
          (e) => DropdownMenuItem(
            enabled: true,
            alignment: Alignment.centerLeft,
            value: e,
            child: Text(
              widget.dropDownChildInfo[e].childName,
              style: TextStyle(
                color: Color(0xff393838),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400
              ),
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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      // menuMaxHeight: 200.w,
      value: now == -1 ? null : now,
      elevation: 16,
      items: childList(),
      onChanged: (value) {
        setState(() {
          for (int i = 0; i < childList().length; i++) {
            if (childList()[i].value == value) {
              widget.setChildId(widget.dropDownChildInfo[i].childId);
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
            size: 30.w,
            color: Color(0xffa666fb),
          ),
        ],
      ),
      alignment: AlignmentDirectional.topCenter,
      underline: SizedBox.shrink(),
    );
  }
}

class ChildAccidentWidget extends StatefulWidget {
  ChildAccidentWidget({
    required this.getAccident,
    required this.receiveData,
    required this.textEditingController,
    required this.accidentTime,
    Key? key}) : super(key: key);
  final GetAccident getAccident;
  final Function(DateTime) receiveData;
  final List<TextEditingController> textEditingController;
  final String accidentTime;

  @override
  State<ChildAccidentWidget> createState() => _ChildAccidentWidgetState();
}

class _ChildAccidentWidgetState extends State<ChildAccidentWidget> {
  static final autoLoginStorage = FlutterSecureStorage();
  Color columnhexcolor = const Color(0xFFFFEFD3);
  Color columnhexcolor2 = const Color(0xFFFFFDF8);
  Color rowhexcolor = const Color(0xFFFFFFFF);

  double borderradius = 20.w;
  double borderwidth = 1.w;
  Color borderhexcolor = const Color(0x4DFDB43B);

  double fontsize14 = 14.sp;
  Color fonthexcolor = const Color(0xFF393838);


  deleteAccident() async {
    ApiUrl apiUrl = ApiUrl();
    http.Response accidentRes =
    await api(apiUrl.accident + '/' + widget.getAccident.aid.toString(), 'delete', 'signInToken', {}, context);
    if(accidentRes.statusCode == 200){
      widget.receiveData(DateTime.now());
    }
  }

  changeDate(DateTime thatDate){
    String _thatDateStr = '';
    var formatter = DateFormat('yyyyMMdd');
    _thatDateStr = formatter.format(thatDate);
    putAccident("date", _thatDateStr);
  }

  putAccident(String type, String value) async {
    ApiUrl apiUrl = ApiUrl();
    http.Response accidentRes =
    await api(apiUrl.accident, 'put', 'signInToken', {
      'value': value, 'aid': widget.getAccident.aid.toString(), 'type': type
    }, context);
    if(accidentRes.statusCode == 200){
      setState(() {
        widget.receiveData(DateTime.now());
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 1057.w,
          height: 302.w,
          decoration: BoxDecoration(
            color: columnhexcolor,
            border: Border.all(color: borderhexcolor, width: borderwidth),
            borderRadius: BorderRadius.all(Radius.circular(borderradius)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x29B1B1B1),
                blurRadius: 6,
                offset: Offset(-2, 2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 90.w,
                        height: 70.w,
                        decoration: BoxDecoration(
                            color: columnhexcolor,
                            border: Border.all(
                                color: borderhexcolor, width: borderwidth),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(borderradius))),
                        child: Center(
                          child: Text(
                            '유아명',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                          width: 90.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: rowhexcolor,
                            border: Border.all(
                                color: borderhexcolor, width: borderwidth),
                          ),
                          child: Center(
                              child: AccidentCustomText(
                                  text: widget.getAccident.name)))
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 90.w,
                        height: 70.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '성별',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                          width: 90.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: rowhexcolor,
                            border: Border.all(
                                color: borderhexcolor, width: borderwidth),
                          ),
                          child: Center(
                              child: AccidentCustomText(
                                  text: widget.getAccident.sex ? "남" : "여")))
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 200.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor2,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '사고일시',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 100.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: columnhexcolor,
                              border: Border.all(
                                  color: borderhexcolor, width: borderwidth),
                            ),
                            child: Center(
                              child: Text(
                                '날짜',
                                style: TextStyle(
                                    fontSize: fontsize14, color: fonthexcolor),
                              ),
                            ),
                          ),
                          Container(
                              width: 100.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: columnhexcolor,
                                border: Border.all(
                                    color: borderhexcolor, width: borderwidth),
                              ),
                              child: Center(
                                child: Text(
                                  '시간',
                                  style: TextStyle(
                                      fontSize: fontsize14,
                                      color: fonthexcolor),
                                ),
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              showAlignedDialog(
                                  offset: Offset(-103.w, 0.w),
                                  barrierColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context){
                                    return AijoaCalendar(changeDate: changeDate, nowDate: DateTime.now(),);
                                  }
                              );
                            },
                            child: Container(
                              width: 100.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                color: rowhexcolor,
                                border: Border.all(
                                    color: borderhexcolor, width: borderwidth),
                              ),
                              child: Center(
                                child: Text(
                                  widget.getAccident.date,
                                  style: TextStyle(
                                      fontSize: fontsize14,
                                      color: fonthexcolor),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              showDialog(context: context, builder: (BuildContext context){
                                return AijoaTimePicker(putAccident: putAccident);
                              });

                              // pickTime();
                            },
                            child: Container(
                              width: 100.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                color: rowhexcolor,
                                border: Border.all(
                                    color: borderhexcolor, width: borderwidth),
                              ),
                              child: Center(
                                child: Text(
                                  widget.accidentTime,
                                  style: TextStyle(
                                      fontSize: fontsize14,
                                      color: fonthexcolor),
                                ),

                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 675.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                            color: columnhexcolor2,
                            border: Border.all(
                                color: borderhexcolor, width: borderwidth),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(borderradius))),
                        child: Center(
                          child: Text(
                            '조치내용',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 97.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: columnhexcolor,
                                  border: Border.all(
                                      color: borderhexcolor,
                                      width: borderwidth),
                                ),
                                child: Center(
                                  child: Text(
                                    '원내치료',
                                    style: TextStyle(
                                        fontSize: 11.sp, color: fonthexcolor),
                                  ),
                                ),
                              ),
                              Container(
                                width: 97.w,
                                height: 80.w,
                                decoration: BoxDecoration(
                                  color: rowhexcolor,
                                  border: Border.all(
                                      color: borderhexcolor,
                                      width: borderwidth),
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 97.w,
                                    child: Focus(
                                      onFocusChange: (hasFocus) {
                                        if (hasFocus) {
                                        } else {
                                         if (widget.getAccident.teacherAction ==
                                              widget.textEditingController[0].text) {
                                          } else {
                                            putAccident('teacherAction', widget.textEditingController[0].text);
                                            //api를 보내면 됩니다.
                                            // _textEditingController.text
                                          }
                                        }
                                      },
                                      child: TextField(
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff393838)
                                        ),
                                        controller: widget.textEditingController[0],
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          // hintText: "ex)1530",
                                          // hintStyle: TextStyle(
                                          //     color: Colors.black26
                                          // ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ), //외곽선
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 97.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: columnhexcolor,
                                  border: Border.all(
                                      color: borderhexcolor,
                                      width: borderwidth),
                                ),
                                child: Center(
                                  child: Text(
                                    '병원치료',
                                    style: TextStyle(
                                        fontSize: 11.sp, color: fonthexcolor),
                                  ),
                                ),
                              ),
                              Container(
                                width: 97.w,
                                height: 80.w,
                                decoration: BoxDecoration(
                                  color: rowhexcolor,
                                  border: Border.all(
                                      color: borderhexcolor,
                                      width: borderwidth),
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 97.w,
                                    child: Focus(
                                      onFocusChange: (hasFocus) {
                                        if (hasFocus) {
                                        } else {
                                          if (widget.getAccident.hospitalAction ==
                                              widget.textEditingController[1].text) {
                                          } else {
                                            putAccident('hospitalAction', widget.textEditingController[1].text);
                                            //api를 보내면 됩니다.
                                            // _textEditingController.text
                                          }
                                        }
                                      },
                                      child: TextField(
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff393838)
                                        ),
                                        controller: widget.textEditingController[1],
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          // hintText: "ex)1530",
                                          // hintStyle: TextStyle(
                                          //     color: Colors.black26
                                          // ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ), //외곽선
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 97.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: columnhexcolor,
                                  border: Border.all(
                                      color: borderhexcolor,
                                      width: borderwidth),
                                ),
                                child: Center(
                                  child: Text(
                                    '치료비',
                                    style: TextStyle(
                                        fontSize: 11.sp, color: fonthexcolor),
                                  ),
                                ),
                              ),
                              Container(
                                width: 97.w,
                                height: 80.w,
                                decoration: BoxDecoration(
                                  color: rowhexcolor,
                                  border: Border.all(
                                      color: borderhexcolor,
                                      width: borderwidth),
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 97.w,
                                    child: Focus(
                                      onFocusChange: (hasFocus) {
                                        if (hasFocus) {
                                        } else {
                                          if (widget.getAccident.medicalFee ==
                                              widget.textEditingController[2].text) {
                                          } else {
                                            putAccident('medicalFee', widget.textEditingController[2].text);
                                            //api를 보내면 됩니다.
                                            // _textEditingController.text
                                          }
                                        }
                                      },
                                      child: TextField(
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff393838)
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          // FilteringTextInputFormatter.digitsOnly,
                                          FilteringTextInputFormatter.allow(RegExp("[0-9|.]")),
                                        ],
                                        controller: widget.textEditingController[2],
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          // hintText: "ex)1530",
                                          // hintStyle: TextStyle(
                                          //     color: Colors.black26
                                          // ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ), //외곽선
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 97.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: columnhexcolor,
                                  border: Border.all(
                                      color: borderhexcolor,
                                      width: borderwidth),
                                ),
                                child: Center(
                                  child: Text(
                                    '보험처리 유무',
                                    style: TextStyle(
                                        fontSize: 11.sp, color: fonthexcolor),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: (){
                                    try{
                                      putAccident('isInsuranced', widget.getAccident.isInsuranced == true ? "false" : "true");
                                    }catch(e){
                                      putAccident('isInsuranced', 'false');
                                    }
                                  },
                                  child: Container(
                                      width: 97.w,
                                      height: 80.w,
                                      decoration: BoxDecoration(
                                        color: rowhexcolor,
                                        border: Border.all(
                                            color: borderhexcolor,
                                            width: borderwidth),
                                      ),
                                      child: Center(
                                          child: AccidentCustomText(
                                              text: widget.getAccident.isInsuranced == null ? "" : widget.getAccident.isInsuranced == true ? "보험적용" : "보험미적용")
                                      )
                                  )
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 97.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: columnhexcolor,
                                  border: Border.all(
                                      color: borderhexcolor,
                                      width: borderwidth),
                                ),
                                child: Center(
                                  child: Text(
                                    '119 연락 유무',
                                    style: TextStyle(
                                        fontSize: 11.sp, color: fonthexcolor),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: (){
                                    try{
                                      putAccident('isAmbulanced', widget.getAccident.isAmbulanced == true ? "false" : "true");
                                    }catch(e){
                                      putAccident('isAmbulanced', 'false');
                                    }
                                  },
                                  child: Container(
                                      width: 97.w,
                                      height: 80.w,
                                      decoration: BoxDecoration(
                                        color: rowhexcolor,
                                        border: Border.all(
                                            color: borderhexcolor,
                                            width: borderwidth),
                                      ),
                                      child: Center(
                                          child: AccidentCustomText(
                                              text: widget.getAccident.isAmbulanced == null ? "" : widget.getAccident.isAmbulanced == true ? "119 연락" : "119 미연락")
                                      )
                                  )
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 190.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: columnhexcolor,
                                  border: Border.all(
                                      color: borderhexcolor,
                                      width: borderwidth),
                                ),
                                child: Center(
                                  child: Text(
                                    '학부모 연락 시점',
                                    style: TextStyle(
                                        fontSize: 11.sp, color: fonthexcolor),
                                  ),
                                ),
                              ),
                              Container(
                                width: 190.w,
                                height: 80.w,
                                decoration: BoxDecoration(
                                  color: rowhexcolor,
                                  border: Border.all(
                                      color: borderhexcolor,
                                      width: borderwidth),
                                ),
                                child: Center(
                                    child: AccidentCustomText(
                                        text: widget.getAccident.contactTime)),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
              Container(
                width: 1055.w,
                height: 30.w,
                decoration: BoxDecoration(
                    color: columnhexcolor2,
                    border:
                        Border.all(color: borderhexcolor, width: borderwidth)),
                child: Center(
                    child: Text(
                  '사고내용',
                  style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
                )),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 263.75.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '발생장소',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: 263.75.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                            color: rowhexcolor,
                            border: Border.all(
                                color: borderhexcolor, width: borderwidth),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(borderradius))),
                        child: Center(
                          child: SizedBox(
                            width: 263.w,
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                if (hasFocus) {
                                } else {
                                  if (widget.getAccident.place ==
                                      widget.textEditingController[3].text) {
                                  } else {
                                    putAccident('place', widget.textEditingController[3].text);
                                    //api를 보내면 됩니다.
                                    // _textEditingController.text
                                  }
                                }
                              },
                              child: TextField(
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff393838)
                                ),
                                controller: widget.textEditingController[3],
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  // hintText: "ex)1530",
                                  // hintStyle: TextStyle(
                                  //     color: Colors.black26
                                  // ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ), //외곽선
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 263.75.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '당시 활동내용',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: 263.75.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: rowhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 263.w,
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                if (hasFocus) {
                                } else {
                                  if (widget.getAccident.situation ==
                                      widget.textEditingController[4].text) {
                                  } else {
                                    putAccident('situation', widget.textEditingController[4].text);
                                    //api를 보내면 됩니다.
                                    // _textEditingController.text
                                  }
                                }
                              },
                              child: TextField(
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff393838)
                                ),
                                controller: widget.textEditingController[4],
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  // hintText: "ex)1530",
                                  // hintStyle: TextStyle(
                                  //     color: Colors.black26
                                  // ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ), //외곽선
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 263.75.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '상해를 입힌 시설 설비',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: 263.75.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: rowhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 263.w,
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                if (hasFocus) {
                                } else {
                                  if (widget.getAccident.cause ==
                                      widget.textEditingController[5].text) {
                                  } else {
                                    putAccident('cause', widget.textEditingController[5].text);
                                    //api를 보내면 됩니다.
                                    // _textEditingController.text
                                  }
                                }
                              },
                              child: TextField(
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff393838)
                                ),
                                controller: widget.textEditingController[5],
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  // hintText: "ex)1530",
                                  // hintStyle: TextStyle(
                                  //     color: Colors.black26
                                  // ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ), //외곽선
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 263.75.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '상해 유형',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: 263.75.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                            color: rowhexcolor,
                            border: Border.all(
                                color: borderhexcolor, width: borderwidth),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(borderradius))),
                        child: Center(
                          child: SizedBox(
                            width: 263.w,
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                if (hasFocus) {
                                } else {
                                  if (widget.getAccident.accidentType ==
                                      widget.textEditingController[6].text) {
                                  } else {
                                    putAccident('accidentType', widget.textEditingController[6].text);
                                    //api를 보내면 됩니다.
                                    // _textEditingController.text
                                  }
                                }
                              },
                              child: TextField(
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff393838)
                                ),
                                controller: widget.textEditingController[6],
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  // hintText: "ex)1530",
                                  // hintStyle: TextStyle(
                                  //     color: Colors.black26
                                  // ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ), //외곽선
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        Row(
          children: [
            SizedBox(
              height: 31.w,
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 100.w,
              height: 40.w,
              margin: EdgeInsets.only(left: 811.w),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 1.0,
                    primary: const Color(0xFFFFD288),
                    onPrimary: fonthexcolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.w)),
                    fixedSize: Size(150.w, 50.w)),
                onPressed: () {
                  showDialog(context: context, builder: (BuildContext context){
                    return MessageToParent();
                  });
                },
                child: Text(
                  '출력',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffA76917),
                  ),
                ),
              ),
            ),
            Container(
              width: 100.w,
              height: 40.w,
              margin: EdgeInsets.only(left: 40.w),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 1.0,
                    primary: const Color(0xFFFFD288),
                    onPrimary: fonthexcolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.w)),
                    fixedSize: Size(150.w, 50.w)),
                onPressed: () {
                  deleteAccident();
                },
                child: Text(
                  '삭제',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffA76917),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AccidentCustomText extends StatefulWidget {
  const AccidentCustomText({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<AccidentCustomText> createState() => _AccidentCustomTextState();
}

class _AccidentCustomTextState extends State<AccidentCustomText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
        color: const Color(0xff393838),
      ),
    );
  }
}



class MessageToParent extends StatefulWidget {
  const MessageToParent({Key? key}) : super(key: key);

  @override
  State<MessageToParent> createState() => _MessageToParentState();
}

class _MessageToParentState extends State<MessageToParent> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 8,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.w))),
        child: Container(
          width: 550.w,
          height: 285.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.w)),
            border: Border.all(width: 1.w, color: Color(0xFF7649B7)),
            color: Color(0xffE2D3FE),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "현재 개발 중인 기능입니다.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.w,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff393838),
                ),
              ),
              SizedBox(
                height: 60.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(width: 80.w),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('확인',
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
                  // SizedBox(width: 50.w),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //   },
                  //   child: Text('취소',
                  //       style: TextStyle(
                  //           fontSize: 20.sp, fontWeight: FontWeight.w400)),
                  //   style: ElevatedButton.styleFrom(
                  //       elevation: 1.0,
                  //       primary: const Color(0xFFFFFFFF),
                  //       onPrimary: const Color(0xFF393838),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10)),
                  //       side: const BorderSide(color: Color(0xFFA666FB)),
                  //       fixedSize: Size(150.w, 50.w)),
                  // ),
                ],
              ),
              SizedBox(
                height: 35.w,
              )
            ],
          ),
        ));
  }
}


class AijoaTimePicker extends StatefulWidget {
  const AijoaTimePicker({Key? key,
    required this.putAccident
  }) : super(key: key);
  final Function(String, String) putAccident;


  @override
  State<AijoaTimePicker> createState() => _AijoaTimePickerState();
}

class _AijoaTimePickerState extends State<AijoaTimePicker> {
  final autoLoginStorage = FlutterSecureStorage();
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
                                  if(noon){
                                    widget.putAccident('time', hour.text + ":" + minute.text);
                                  }else{
                                    hour.text = (int.parse(hour.text) - 12)
                                        .toString();
                                    widget.putAccident('time', hour.text + ":" + minute.text);
                                  }
                                  Navigator.pop(context);
                                } else {
                                  if (noon) {
                                    if(hour.text.length == 1){
                                      widget.putAccident('time', '0'+hour.text + ":" + minute.text);
                                    }else{
                                      widget.putAccident('time', hour.text + ":" + minute.text);
                                    }
                                  } else {
                                    setState(() {
                                      widget.putAccident('time', (int.parse(hour.text) + 12).toString() + ":" + minute.text);
                                    });
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