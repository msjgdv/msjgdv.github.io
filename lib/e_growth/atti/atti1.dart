import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:http/http.dart' as http;

import '../../provider/atti_child_data_management.dart';
import '../../provider/class_data_management.dart';
import '../../provider/report_data_management.dart';
import '../../provider/survey_data_management.dart';
import '../../widgets/menu_bar.dart';

import '../../grow.dart';
import 'atti2.dart';
import 'atti5.dart';

class Atti1 extends StatefulWidget {
  const Atti1({Key? key}) : super(key: key);

  @override
  State<Atti1> createState() => _Atti1State();
}

class _Atti1State extends State<Atti1> {
  GlobalKey<ScaffoldState> _scaffoldState =
      GlobalKey<ScaffoldState>(); //appbar없는 menubar용
  int thisYear = DateTime.now().year;
  List<int> rid = [];
  List<String> className = [];
  List<int> turn = [];
  List<int> headCount = [];
  List<int> surveyCount = [];
  List<String> startDate = [];
  List<String> endDate = [];
  List<String> comment = [];
  int reportCount = 0;

  int getToday() {
    DateTime now = DateTime.now();
    int schoolYear = 0;
    if(DateTime.utc(now.year,3,1).compareTo(now) > 0){
      schoolYear = now.year - 1;
    }else{
      schoolYear = now.year;
    }
    var formatter = DateFormat('yyyy');
    var strToday = formatter.format(now);
    return schoolYear;
  }

  receiveAttiData() async {
    ApiUrl apiUrl = ApiUrl();
    http.Response attiRes = await api(apiUrl.atti + '?' + "year="+thisYear.toString(), 'get', 'signInToken', {}, context);
    if(attiRes.statusCode == 200){
      var attiRB = utf8.decode(attiRes.bodyBytes);
      var attiData = jsonDecode(attiRB);
      setState(() {
        for (int i = 0; i < attiData.length; i++) {
          rid.add(attiData[i]['identification']);
            className.add(attiData[i]['className']);
            turn.add(attiData[i]['turn']);
            headCount.add(attiData[i]['headCount']);
            surveyCount.add(attiData[i]['surveyCount']);
            startDate.add(attiData[i]['startDate']);
            endDate.add(attiData[i]['endDate']);
            comment.add(attiData[i]['comment']);
            if(endDate[i] == ''){
              // surveying = true;
            }
          }
          reportCount = attiData.length;
      });
    }
  }

  @override
  void initState() {
    thisYear = getToday();
    receiveAttiData();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(Image.asset('assets/backgrounds/atti/atti_main_page.png').image, context);
    return WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset('assets/backgrounds/atti/atti_main_page.png').image,
              )),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                key: _scaffoldState,
                endDrawer: MenuDrawer(),
                body:ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
                physics: const RangeMaintainingScrollPhysics(),
                      children: [
                    Container(
                      child: Column(children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(30.w, 18.w, 0.w, 0.w),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => IGrow()),
                                    );
                                  },
                                  icon: SvgPicture.asset(
                                      './assets/icons/icon_back.svg',
                                      width: 33.w,
                                      height: 27.8.w)),
                            ],
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.fromLTRB(1100.w, 48.19.w, 0.w, 0.w),
                        //   child: IconButton(
                        //       onPressed: () {
                        //         _scaffoldState.currentState?.openEndDrawer();
                        //       },
                        //       icon: SvgPicture.asset('./assets/icons/icon_menu.svg',
                        //           width: 33.w, height: 27.8.w)),
                        // ),
                        SizedBox(
                          height: 0.w,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/atti/atti_logo.svg',
                                height: 100.w,
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              SvgPicture.asset(
                                'assets/icons/atti/atti_logo_korean_icon.svg',
                                width: 140.w,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100.w,
                        ),
                        Container(
                          width: 230.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    thisYear--;
                                    receiveAttiData();
                                  });
                                },
                                icon: SvgPicture.asset(
                                  'assets/icons/icon_back.svg',
                                  width: 16.w,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "$thisYear 학년도",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff46423C),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    thisYear++;
                                    receiveAttiData();
                                  });
                                },
                                icon: SvgPicture.asset(
                                  'assets/icons/icon_next.svg',
                                  width: 16.w,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.w,
                        ),
                        ChoiceReport(
                          receiveReportData: receiveAttiData,
                          nowYear: thisYear,
                          startDate: startDate,
                          turn: turn,
                          rid: rid,
                          className: className,
                          endDate: endDate,
                          surveyCount: surveyCount,
                          headCount: headCount,
                          reportCount: reportCount,
                          comment: comment,
                          // surveying: surveying,
                        ),
                      ]),
                    )
                  ]),
                ),
              )),
        ));
  }
}

class ChoiceReport extends StatefulWidget {
  const ChoiceReport({
    Key? key,
    required this.endDate,
    required this.startDate,
    required this.surveyCount,
    required this.headCount,
    required this.turn,
    required this.className,
    required this.nowYear,
    required this.rid,
    required this.reportCount,
    required this.comment,
    required this.receiveReportData,
    // required this.surveying,
  }) : super(key: key);
  final List<int> rid;
  final List<String> className;
  final List<int> turn;
  final List<int> headCount;
  final List<int> surveyCount;
  final List<String> startDate;
  final List<String> endDate;
  final List<String> comment;
  final int reportCount;
  final nowYear;
  final Function() receiveReportData;
  // final bool surveying;

  @override
  State<ChoiceReport> createState() => _ChoiceReportState();
}

class _ChoiceReportState extends State<ChoiceReport> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 820.w,
      height: 305.w,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView(
          physics: const RangeMaintainingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            for (int i = 0; i < widget.reportCount; i++) ...[
              SurveyInfo(
                receiveReportData: widget.receiveReportData,
                nowStatus: widget.endDate[i] != '' ? 0 : 1,
                childHeadcount: widget.headCount[i],
                finishDate: widget.endDate[i] == ''
                    ? ""
                    : widget.endDate[i],
                startDate: widget.startDate[i],
                turn: widget.turn[i].toString(),
                surveyEndChildCount: widget.surveyCount[i],
                identification: widget.rid[i],
                comment: widget.comment[i],
                className: widget.className[i],
                nowYear: widget.nowYear,
              ),
              SizedBox(
                width: 70.w,
              )
            ],
            // if (DateTime.now().year == widget.nowYear) ...[
    if (true) ...[
              // if(widget.surveying)...[
              //
              // ]else...[
                SurveyInfo(
                  receiveReportData: widget.receiveReportData,
                  nowStatus: 2,
                  nowYear: widget.nowYear,
                ),
              // ]

            ],
            SizedBox(
              width: 5.w,
            ),
          ],
        ),
      ),
    );
  }
}

class SurveyInfo extends StatefulWidget {
  const SurveyInfo({
    Key? key,
    this.childHeadcount = 0,
    this.startDate = "",
    required this.nowStatus,
    this.turn = '',
    this.finishDate = '',
    this.surveyEndChildCount = 0,
    this.identification = 0,
    this.comment = '',
    this.className = '',
    required this.receiveReportData,
    required this.nowYear,
  }) : super(key: key);

  final int nowStatus;
  final String turn;
  final String startDate;
  final String finishDate;
  final int childHeadcount;
  final int surveyEndChildCount;
  final int identification;
  final String comment;
  final String className;
  final Function() receiveReportData;
  final int nowYear;

  @override
  State<SurveyInfo> createState() => _SurveyInfoState();
}

class _SurveyInfoState extends State<SurveyInfo> {
  final dropDownList = ['수정하기', '삭제'];
  List<String> status = ['보고서 보기', '조사중', '신규생성'];
  List<String> icon = [
    'assets/icons/atti/atti_completed_icon.svg',
    'assets/icons/atti/atti_under_icon.svg',
    'assets/icons/atti/atti_new_icon.svg',
  ];
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> _createList() {
      return dropDownList
          .map<DropdownMenuItem<String>>(
            (e) => DropdownMenuItem(
              enabled: true,
              alignment: Alignment.centerLeft,
              value: e,
              child: Text(e,
              style: TextStyle(
                color: Color(0xff393838),
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp
              ),),
            ),
          )
          .toList();
    }

    return Container(
      child: GestureDetector(
        child: Column(
          children: [
            Container(
              width: 225.w,
              height: 70.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.w),
                    topLeft: Radius.circular(20.w)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x294D4D4D),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(2, 2),
                  )
                ],
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xffBCEBB6), Color(0xff75D985)]),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 21.w, bottom: 15.w, top: 5.w, right: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.nowStatus == 2
                        ? Row()
                        : Row(
                            children: [
                              SurveyInfoText(
                                text: widget.className +
                                    "  " +
                                    widget.turn +
                                    '회차',
                              ),
                              Spacer(),
                              Container(
                                height: 30.w,
                                width: 30.w,
                                key: _globalKey,
                                child: GestureDetector(
                                  onTap: () {
                                    double _dialogOffsetY = _getPosition(_globalKey, "y");
                                    showAlignedDialog(
                                        offset: Offset(
                                                85.w,
                                            -MediaQuery.of(context).size.width / 2 +
                                                _dialogOffsetY + 175.w),
                                        barrierColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ReportSettingDialog(
                                            rid: widget.identification,
                                            receiveReportData: widget.receiveReportData,

                                          );
                                        });
                                  },
                                  child: Icon(
                                      Icons.menu,
                                      size: 30.w,
                                      color: Colors.white,
                                    ),
                                ),

                              ),
                            ],
                          ),
                    widget.nowStatus == 2
                        ? Row()
                        : Row(
                            children: [
                              SurveyInfoText(
                                text: widget.startDate,
                              ),
                              Spacer(),
                              SurveyInfoText(
                                text: widget.nowStatus == 1
                                    ? "${widget.surveyEndChildCount}/${widget.childHeadcount}"
                                    : "~${widget.finishDate}",
                              ),
                              SizedBox(
                                width: 3.w,
                              )
                            ],
                          )
                  ],
                ),
              ),
            ),
            Container(
              width: 225.w,
              height: 230.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20.w),
                    bottomLeft: Radius.circular(20.w)),
                color: Color(0xffffffff),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x294D4D4D),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(2, 2),
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 18.w, horizontal: 21.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.nowStatus == 2
                        ? SurveyInfoText(
                            text: "",
                          )
                        : SurveyInfoText(
                            text: widget.comment,
                          ),
                    Spacer(),
                    SvgPicture.asset(
                      icon[widget.nowStatus],
                      width: 38.w,
                    ),
                    SizedBox(
                      height: 12.w,
                    ),
                    Text(
                      status[widget.nowStatus],
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff46423C),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap: () async {
          Provider.of<SurveyDataManagement>(context, listen: false).rid =widget.identification;
          widget.nowStatus == 0
              ? receiveReportData(widget.identification, context)
              : widget.nowStatus == 1
                  ? surveying(widget.identification,context)
                  : showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return NewReportDialog(receiveReportData: widget.receiveReportData, nowYear: widget.nowYear,);
                      });
        },
      ),
    );
  }

  surveyedCheck(int rid) async {
    ApiUrl apiUrl = ApiUrl();
    http.Response attiChildRes =
    await api('${apiUrl.attiChild}/$rid', 'get', 'signInToken', {}, context);
    if(attiChildRes.statusCode == 200) {
      var attiChildRB = utf8.decode(attiChildRes.bodyBytes);
      var attiChildData = jsonDecode(attiChildRB);
      Provider.of<AttiChildDataManagement>(context, listen: false)
          .childList.clear();
        for (int i = 0; i < attiChildData.length; i++) {
          Image image = await imageApi(attiChildData[i]['imagePath'], 'signInToken', context);
          setState(() {
          Provider.of<AttiChildDataManagement>(context, listen: false)
              .childList
              .add(AttiChild(
              identification: attiChildData[i]['identification'],
              name: attiChildData[i]['name'],
              sex: attiChildData[i]['sex'],
              childFaceUrl: attiChildData[i]['imagePath'],
              childFace: image,
              attiSurveyed: attiChildData[i]['surveyed']
          ));
          });
        }
    }
  }

  receiveReportData(int rid, context) async {
    ApiUrl apiUrl = ApiUrl();
    http.Response attiReportRes =
    await api('${apiUrl.atti}/$rid', 'get', 'signInToken', {}, context);
    var attiData;
    if(attiReportRes.statusCode == 200) {
      var attiRB = utf8.decode(attiReportRes.bodyBytes);
      attiData = jsonDecode(attiRB);
      print(attiData);

      Provider
          .of<ReportDataManagement>(context, listen: false)
          .reportData = attiData;
      Provider
          .of<ReportDataManagement>(context, listen: false)
          .cids
          .clear();

      for (int i = 0; i < attiData.length; i++) {

        Provider
            .of<ReportDataManagement>(context, listen: false)
            .cids
            .addAll(attiData[i]['cid'].cast<int>());
      }
      Provider
          .of<ReportDataManagement>(context, listen: false)
          .cids = Provider
          .of<ReportDataManagement>(context, listen: false)
          .cids
          .toSet()
          .toList();

      Provider
          .of<AttiChildDataManagement>(context, listen: false)
          .childList.clear();
      for(int i = 0; i<attiData.length;i++){
        await surveyedCheck(attiData[i]['id']);
      }
      Provider
          .of<AttiChildDataManagement>(context, listen: false)
          .childList.toSet().toList();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Atti5()),
          );
    }
  }


  surveying(int rid, context){
    Provider.of<SurveyDataManagement>(context, listen: false).rid = rid;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Atti2()),
    );
  }
}

class SurveyInfoText extends StatefulWidget {
  const SurveyInfoText({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<SurveyInfoText> createState() => _SurveyInfoTextState();
}

class _SurveyInfoTextState extends State<SurveyInfoText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12.sp,
          color: Color(0xff46423C)),
    );
  }
}

class ReportSettingDialog extends StatefulWidget {
  const ReportSettingDialog({Key? key,
    required this.receiveReportData,
    required this.rid,
  }) : super(key: key);
  final Function() receiveReportData;
  final int rid;

  @override
  State<ReportSettingDialog> createState() => _ReportSettingDialogState();
}

class _ReportSettingDialogState extends State<ReportSettingDialog> {

  deleteReport() async {
    ApiUrl apiUrl = ApiUrl();
    http.Response attiRes =
    await api('${apiUrl.atti}/${widget.rid}', 'delete', 'signInToken', {}, context);
    if(attiRes.statusCode == 200) {
      setState(() {
        // widget.receiveReportData();
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Atti1()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150.w,
        height: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.w)),
          border: Border.all(width: 1, color: Color(0xFFA666FB)),
          color: Color(0xffffffff),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: () {
              Navigator.pop(context);
              showDialog(
                barrierColor: Colors.transparent,
                  barrierDismissible: false,
                  context: context, builder: (BuildContext context){
                return ReviseDialog(rid: widget.rid, receiveReportData: widget.receiveReportData);  });
            }, child: Text("수정하기")),
            TextButton(onPressed: () async {
              deleteReport();
            }, child: Text("삭제")),
          ],
        )
    );
  }
}


class ReviseDialog extends StatefulWidget {
  const ReviseDialog({Key? key,
    required this.rid,
    required this.receiveReportData,
  }) : super(key: key);
  final int rid;
  final Function() receiveReportData;

  @override
  State<ReviseDialog> createState() => _ReviseDialogState();
}

class _ReviseDialogState extends State<ReviseDialog> {
  TextEditingController _textEditingController = TextEditingController();

  modifyReport(String value, int rid) async {
    ApiUrl apiUrl = ApiUrl();
    http.Response attiRes =
    await api(apiUrl.atti, 'put', 'signInToken', {
      'rid' : rid.toString(),
      'comment' : value,
    }, context);
    if(attiRes.statusCode == 200) {
      setState(() {
        // widget.receiveReportData();
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Atti1()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.w))),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
            width: 550.w,
            height: 400.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20.w),
              ),
              color: Color(0xffF9FCF4),
            ),
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                physics: const RangeMaintainingScrollPhysics(),
                children: [
                  Column(
                    children: [
                      Container(
                        height: 80.w,
                        child: Center(
                          child: Text(
                            "코멘트 수정",
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff393838),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 450.w,
                        height: 200.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.w),
                            ),
                            color: Colors.white,
                            border: Border.all(width: 1, color: Color(0xff3BFD7E))),
                        child: Center(
                          child: Container(
                            width: 400.w,
                            height: 200.w,
                            child: TextField(
                              maxLines: 7,
                              controller: _textEditingController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none //밑줄 제거
                                  ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35.w,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 150.w,
                              height: 50.w,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  side: BorderSide(color: Color(0xffA666FB)),
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10.w),
                                  ),
                                  primary: Color(0xffffffff),
                                ),
                                onPressed: () async {
                                  modifyReport(_textEditingController.text, widget.rid);
                                },
                                child: Text('저장',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20.sp,
                                      color: Color(0xff393838),
                                    )),
                              )),
                          SizedBox(
                            width: 20.w,
                          ),
                          SizedBox(
                              width: 150.w,
                              height: 50.w,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  side: BorderSide(color: Color(0xffA666FB)),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(10.w)),
                                  primary: Color(0xffffffff),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('닫기',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20.sp,
                                      color: Color(0xff393838),
                                    )),
                              )),
                          // SizedBox(
                          //   width: 25.w,
                          // ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class NewReportDialog extends StatefulWidget {
  const NewReportDialog({Key? key,
    required this.receiveReportData,
    required this.nowYear,
  }) : super(key: key);
  final Function() receiveReportData;
  final int nowYear;

  @override
  State<NewReportDialog> createState() => _NewReportDialogState();
}

class _NewReportDialogState extends State<NewReportDialog> {
  ApiUrl apiUrl = ApiUrl();
  final commentTextField = TextEditingController();
  List<int> number = [];
  int now = -1;
  int cid = 0;
  bool makeAtti = true;

  int nowYear = DateTime.now().year;

  List<DropdownMenuItem<int>> classList() {
    return number
        .map<DropdownMenuItem<int>>(
          (e) => DropdownMenuItem(
            enabled: true,
            alignment: Alignment.centerLeft,
            value: e,
            child: Text(
              Provider.of<ClassDataManagement>(context, listen: false)
                  .classList[e]
                  .className,
              style: TextStyle(
                color: Color(0xff393838),
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp
              ),
            ),
          ),
        )
        .toList();
  }

  getClassInfo() async {
    http.Response classRes =
    await api('${apiUrl.getClass}/${widget.nowYear}', 'get', 'signInToken', {}, context);
    if(classRes.statusCode == 200) {
      var classRB = utf8.decode(classRes.bodyBytes);
      var classData = jsonDecode(classRB);
      setState(() {
        Provider
            .of<ClassDataManagement>(context, listen: false)
            .classList
            .clear();

        for (int i = 0; i < classData.length; i++) {
          Provider
              .of<ClassDataManagement>(context, listen: false)
              .classList
              .add(
              Class(
                  className: classData[i]['name'],
                  classTeacher: classData[i]['teacher'],
                  classChildAge: classData[i]['age'],
                  classComment:
                  classData[i]['comment'] ?? "",
                  classId: classData[i]['id'],
                  classCount: classData[i]['count'],
                  classTId: classData[i]['tid']));
          number.add(i);
        }
      });
    }
  }

  newSurvey(String comment, int classId) async {
    http.Response classRes =
    await api(apiUrl.atti, 'post', 'signInToken', {
      'comment': comment,
      'cid': classId.toString(),
    }, context);
    if(classRes.statusCode == 200) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Atti1()),
      );
    }
  }

  @override
  void initState() {
    getClassInfo();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
            child: Container(
          width: 800.w,
          height: 450.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.w),
              color: const Color(0xFFFCF9F4)),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,

            children: [
              SizedBox(
                height: 50.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "신규 생성",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 24.sp,
                      color: Color(0xff393838),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                        color: const Color(0xFFE2FFE5),
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(20.w)),
                        border: Border.all(
                            color: const Color(0x4D3BFD7E), width: 1.w)),
                    child: Center(
                      child: Text(
                        "반 이름",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff393838),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 400.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                        color: const Color(0xFFE2FFE5),
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(20.w)),
                        border: Border.all(
                            color: const Color(0x4D3BFD7E), width: 1.w)),
                    child: Center(
                      child: Text(
                        "코멘트",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff393838),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200.w,
                    height: 150.w,
                    decoration: BoxDecoration(
                        color: const Color(0xFFffffff),
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(20.w)),
                        border: Border.all(
                            color: const Color(0x4D3BFD7E), width: 1.w)),
                    child: Center(
                      child: makeAtti == true ? DropdownButton(
                        // menuMaxHeight: 200.w,
                        value: now == -1 ? null : now,
                        elevation: 16,
                        items: classList(),
                        onChanged: (value) {
                          setState(() {
                            for (int i = 0; i < classList().length; i++) {
                              if (classList()[i].value == value) {
                                now = i;
                                cid = Provider.of<ClassDataManagement>(context,
                                        listen: false)
                                    .classList[i]
                                    .classId;
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
                      ):
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    showToast("반 배정을 받지않은 선생님은 아띠맵을 시작할 수 없습니다.");
                                  });
                                },
                                child: Container(
                                  width: 180.w,
                                  height: 150.w,
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      size: 30.w,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                    ),
                  ),
                  Container(
                    width: 400.w,
                    height: 150.w,
                    decoration: BoxDecoration(
                        color: const Color(0xFFffffff),
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(20.w)),
                        border: Border.all(
                            color: const Color(0x4D3BFD7E), width: 1.w)),
                    child: TextField(
                      maxLines: 5,
                      onChanged: (val) {},
                      controller: commentTextField,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                          color: Color(0xff393838),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 38.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 150.w,
                      height: 50.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Color(0xffA666FB)),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.w),
                          ),
                          primary: Color(0xffffffff),
                        ),
                        onPressed: () {
                          makeAtti == true ? newSurvey(commentTextField.text, cid):Navigator.pop(context);
                        },
                        child: Text('저장',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20.sp,
                              color: Color(0xff393838),
                            )),
                      )),
                  SizedBox(
                    width: 20.w,
                  ),
                  SizedBox(
                      width: 150.w,
                      height: 50.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Color(0xffA666FB)),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.w)),
                          primary: Color(0xffffffff),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('닫기',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20.sp,
                              color: Color(0xff393838),
                            )),
                      )),
                  // SizedBox(
                  //   width: 25.w,
                  // ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}