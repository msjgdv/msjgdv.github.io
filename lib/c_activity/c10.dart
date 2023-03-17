// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:treasure_map/widgets/api.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../provider/app_management.dart';
import '../widgets/overtab.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:widget_mask/widget_mask.dart';

import '../widgets/token_time_over.dart';

//---------------------------------------------------월별보고서---------------------------------------------------\\
class C10 extends StatefulWidget {
  const C10({
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
  State<C10> createState() => _C10State();
}

class _C10State extends State<C10> {
  static final autoLoginStorage = FlutterSecureStorage();
  bool dateOn = true;

  // List<GetMonthlyReportData> childMonthlyReportData = [];
  List<Image> childFace = [];

  List<TextEditingController> summary = [];
  List<TextEditingController> toHome = [];

  ApiUrl apiUrl = ApiUrl();
  var monthData;

  getChildMonthlyReportData() async {
    http.Response monthRes = await api(
        '${apiUrl.monthlyReport}/${Provider.of<UserInfo>(context, listen: false).value[0]}/$pageTimeStr',
        'get',
        'signInToken',
        {},
        context);
    if (monthRes.statusCode == 200) {
      var monthRB = utf8.decode(monthRes.bodyBytes);
      monthData = jsonDecode(monthRB);
      childFace.clear();
      summary.clear();
      toHome.clear();
      for (int i = 0; i < monthData.length; i++) {
        Image image =
            await imageApi(monthData[i]['imagePath'], 'signInToken', context);
        childFace.add(image);
        summary.add(TextEditingController());
        summary[i].text = monthData[i]['autoCreatedComment'];
        toHome.add(TextEditingController());
        // toHome[i].text = monthData[i]['comment'];
      }
      setState(() {});
    }
  }

  postChildMonthlyReportData(int id, String value, String type) async {
    http.Response monthRes = await api(
        apiUrl.monthlyReport,
        'post',
        'signInToken',
        {
          'value': value,
          'id': id.toString(),
          'type': type,
          'date': pageTimeStr,
          'cid':
              Provider.of<UserInfo>(context, listen: false).value[0].toString()
        },
        context);
    if (monthRes.statusCode == 200) {
      getChildMonthlyReportData();
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
      getChildMonthlyReportData();
      //데이터 넣어주기
      //ex) data = response["data"];
    });
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
                  if (monthData != null) ...[
                    for (int i = 0; i < monthData.length; i++) ...[
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: (345 +
                                    20 *
                                        (monthData[i]['autoCreatedComment']
                                                .split('\n')
                                                .length +
                                            1))
                                .w,
                            //color: Colors.black,
                            color: const Color(0xffFCFCFC),
                          ),
                          ChildMonthlyReportWidget(
                            monthData: monthData[i],
                            childFace: childFace[i],
                            postApi: postChildMonthlyReportData,
                            textMaxLine: monthData[i]['autoCreatedComment']
                                    .split('\n')
                                    .length +
                                1,
                            summary: summary[i],
                            toHome: toHome[i],
                          ),
                        ],
                      ),
                      if (i == monthData.length - 1) ...[
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
                      ] else ...[
                        Row(
                          children: [
                            Container(
                              width: 39.w,
                              height: 50.w,
                              color: const Color(0xffFCFCFC),
                            ),
                          ],
                        )
                      ]
                    ]
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChildMonthlyReportWidget extends StatefulWidget {
  ChildMonthlyReportWidget(
      {
      // required this.getMonthlyReport,
      required this.childFace,
      required this.postApi,
      required this.textMaxLine,
      required this.toHome,
      required this.summary,
      required this.monthData,
      Key? key})
      : super(key: key);

  // final GetMonthlyReportData getMonthlyReport;
  final monthData;
  final Image childFace;
  final Function(int, String, String) postApi;
  final int textMaxLine;
  final TextEditingController toHome;
  final TextEditingController summary;

  @override
  State<ChildMonthlyReportWidget> createState() =>
      _ChildMonthlyReportWidgetState();
}

class _ChildMonthlyReportWidgetState extends State<ChildMonthlyReportWidget> {
  bool enteringEmotionAlone = false;
  bool quittingEmotionAlone = false;

  List<int> enteringEmotion = [];
  List<int> quittingEmotion = [];

  double rowwidth = 82.w;
  double columnheight = 40.w;
  double rowheight = 80.w;
  Color columnhexcolor = const Color(0xFFFFEFD3);
  Color rowhexColor = const Color(0xFFFFFFFF);

  double borderradius = 20.w;
  double borderwidth = 1.w;
  Color borderhexcolor = const Color(0x4DFDB43B);

  double fontsize14 = 14.sp;
  Color fonthexcolor = const Color(0xFF393838);

  List<String> boyEmotions = [
    "assets/images/emotion_boy_happy_s.svg",
    "assets/images/emotion_boy_angry_s.svg",
    "assets/images/emotion_boy_excited_s.svg",
    "assets/images/emotion_boy_sadness_s.svg",
    "assets/images/emotion_boy_loneliness_s.svg",
    "assets/images/emotion_boy_concerned_s.svg",
  ];

  List<String> girlEmotions = [
    "assets/images/emotion_girl_happy_s.svg",
    "assets/images/emotion_girl_angry_s.svg",
    "assets/images/emotion_girl_excited_s.svg",
    "assets/images/emotion_girl_sadness_s.svg",
    "assets/images/emotion_girl_loneliness_s.svg",
    "assets/images/emotion_girl_concerned_s.svg",
  ];

  List<String> emotion = [
    'happy',
    'angry',
    'excite',
    'sad',
    'lonely',
    'worry',
  ];

  List<String> emotionKr = [
    '행복',
    '화남',
    '신남',
    '슬픔',
    '외로움',
    '걱정',
  ];

  @override
  void initState() {
    for (int i = 0; i < widget.monthData['quittingEmotion'].length; i++) {
      quittingEmotion.add(emotion.indexWhere(
          (emotion) => emotion == widget.monthData['quittingEmotion'][i]));
    }
    for (int i = 0; i < widget.monthData['enteringEmotion'].length; i++) {
      enteringEmotion.add(emotion.indexWhere(
          (emotion) => emotion == widget.monthData['enteringEmotion'][i]));
    }

    if (widget.monthData['quittingEmotion'].length == 1) {
      quittingEmotionAlone = true;
    }
    if (widget.monthData['enteringEmotion'].length == 1) {
      enteringEmotionAlone = true;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            WidgetMask(
              blendMode: BlendMode.srcATop,
              childSaveLayer: true,
              mask: widget.childFace,
              child: Container(
                width: 79.w,
                height: 100.w,
                decoration: BoxDecoration(
                  border: Border.all(color: borderhexcolor, width: borderwidth),
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: 242.w,
              height: 102.w,
              decoration: BoxDecoration(
                color: columnhexcolor,
                border: Border.all(color: borderhexcolor, width: borderwidth),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(borderradius),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x29B1B1B1),
                    blurRadius: 6,
                    offset: Offset(-2, 2),
                  )
                ],
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 120.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '유아명',
                            style:
                                TextStyle(fontSize: 14.sp, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                          width: 120.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                            color: rowhexColor,
                            border: Border.all(
                                color: borderhexcolor, width: borderwidth),
                          ),
                          child: Center(child: Text(widget.monthData['name']))),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 120.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(borderradius)),
                        ),
                        child: Center(
                          child: Text(
                            '학부모 알림',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MessageToParent();
                              });
                        },
                        child: Container(
                          width: 120.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                            color: rowhexColor,
                            border: Border.all(
                                color: borderhexcolor, width: borderwidth),
                          ),
                          child: Center(
                            child: Text(
                              widget.monthData['isReported'] ? 'Y' : 'N',
                              style: TextStyle(
                                  fontSize: fontsize14, color: fonthexcolor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        // SizedBox(
        //   height: 0.5.w,
        // ),
        Container(
          width: 1068.w,
          height: (242 + 20 * widget.textMaxLine).w,
          decoration: BoxDecoration(
            color: columnhexcolor,
            border: Border.all(color: borderhexcolor, width: borderwidth),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(borderradius),
                bottomRight: Radius.circular(borderradius),
                bottomLeft: Radius.circular(borderradius)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: rowwidth,
                        height: columnheight,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '출석',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: rowwidth,
                        height: rowheight,
                        decoration: BoxDecoration(
                          color: rowhexColor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            widget.monthData['attendance'][0].toString() +
                                '\n/' +
                                widget.monthData['attendance'][1].toString(),
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: rowwidth,
                        height: columnheight,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '등원시간',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: rowwidth,
                        height: rowheight,
                        decoration: BoxDecoration(
                          color: rowhexColor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            widget.monthData['enteringTime'][0].toString() +
                                '\n/' +
                                widget.monthData['enteringTime'][1].toString(),
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: rowwidth,
                        height: columnheight,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '하원시간',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: rowwidth,
                        height: rowheight,
                        decoration: BoxDecoration(
                          color: rowhexColor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            widget.monthData['quittingTime'][0].toString() +
                                '\n/' +
                                widget.monthData['quittingTime'][1].toString(),
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: rowwidth,
                        height: columnheight,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '체온',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: rowwidth,
                        height: rowheight,
                        decoration: BoxDecoration(
                          color: rowhexColor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            widget.monthData['temperature'].toString(),
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: rowwidth,
                        height: columnheight,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '신장',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: rowwidth,
                        height: rowheight,
                        decoration: BoxDecoration(
                          color: rowhexColor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            (widget.monthData['height'][0].toStringAsFixed(1) ==
                                        "-1.0"
                                    ? "0"
                                    : widget.monthData['height'][0]
                                        .toStringAsFixed(1)) +
                                '\n/' +
                                (widget.monthData['height'][1]
                                            .toStringAsFixed(1) ==
                                        "-1.0"
                                    ? "0"
                                    : widget.monthData['height'][1]
                                        .toStringAsFixed(1)),
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: rowwidth,
                        height: columnheight,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '체중',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: rowwidth,
                        height: rowheight,
                        decoration: BoxDecoration(
                          color: rowhexColor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            (widget.monthData['weight'][0].toStringAsFixed(1) ==
                                        '-1.0'
                                    ? "0"
                                    : widget.monthData['weight'][0]
                                        .toStringAsFixed(1)) +
                                '\n/' +
                                (widget.monthData['weight'][1]
                                            .toStringAsFixed(1) ==
                                        '-1.0'
                                    ? "0"
                                    : widget.monthData['weight'][1]
                                        .toStringAsFixed(1)),
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: rowwidth,
                        height: columnheight,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '등원감정',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: rowwidth,
                        height: rowheight,
                        decoration: BoxDecoration(
                          color: rowhexColor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (enteringEmotionAlone) ...[
                              SvgPicture.asset(
                                widget.monthData['sex']
                                    ? boyEmotions[enteringEmotion[0]]
                                    : girlEmotions[enteringEmotion[0]],
                                width: 50.w,
                              ),
                            ],
                            for (int i = 0;
                                i < enteringEmotion.length;
                                i++) ...[
                              Text(
                                emotionKr[enteringEmotion[i]],
                                style: TextStyle(
                                    fontSize: fontsize14, color: fonthexcolor),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: rowwidth,
                        height: columnheight,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '하원감정',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: rowwidth,
                        height: rowheight,
                        decoration: BoxDecoration(
                          color: rowhexColor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (quittingEmotionAlone) ...[
                              SvgPicture.asset(
                                widget.monthData['sex']
                                    ? boyEmotions[quittingEmotion[0]]
                                    : girlEmotions[quittingEmotion[0]],
                                width: 50.w,
                              ),
                            ],
                            for (int i = 0;
                                i < quittingEmotion.length;
                                i++) ...[
                              if (i < 3) ...[
                                Text(
                                  emotionKr[quittingEmotion[i]],
                                  style: TextStyle(
                                      fontSize: fontsize14,
                                      color: fonthexcolor),
                                ),
                              ]
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: rowwidth,
                        height: columnheight,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '식사',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: rowwidth,
                        height: rowheight,
                        decoration: BoxDecoration(
                          color: rowhexColor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            (widget.monthData['meal'][0].toStringAsFixed(1) ==
                                        '-1.0'
                                    ? '0'
                                    : widget.monthData['meal'][0]
                                        .toStringAsFixed(1)) +
                                '\n/' +
                                (widget.monthData['meal'][1]
                                            .toStringAsFixed(1) ==
                                        '-1.0'
                                    ? '0'
                                    : widget.monthData['meal'][1]
                                        .toStringAsFixed(1)),
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: rowwidth,
                        height: columnheight,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '낮잠',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: rowwidth,
                        height: rowheight,
                        decoration: BoxDecoration(
                          color: rowhexColor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            (widget.monthData['nap'][0].toStringAsFixed(1) ==
                                        '-1.0'
                                    ? '0'
                                    : widget.monthData['nap'][0]
                                        .toStringAsFixed(1)) +
                                '\n/' +
                                (widget.monthData['nap'][1]
                                            .toStringAsFixed(1) ==
                                        '-1.0'
                                    ? '0'
                                    : widget.monthData['nap'][1]
                                        .toStringAsFixed(1)),
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: rowwidth,
                        height: columnheight,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '구토/배변',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: rowwidth,
                        height: rowheight,
                        decoration: BoxDecoration(
                          color: rowhexColor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '구토 : ' +
                                (widget.monthData['defecationAndVomit'][0]
                                            .toStringAsFixed(1) ==
                                        "0.0"
                                    ? '0'
                                    : widget.monthData['defecationAndVomit'][0]
                                        .toStringAsFixed(1)) +
                                '\n/' +
                                '배변 : ' +
                                (widget.monthData['defecationAndVomit'][1]
                                            .toStringAsFixed(1) ==
                                        "-1.0"
                                    ? "0"
                                    : widget.monthData['defecationAndVomit'][1]
                                        .toStringAsFixed(1)),
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: rowwidth,
                        height: columnheight,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '투약',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: rowwidth,
                        height: rowheight,
                        decoration: BoxDecoration(
                          color: rowhexColor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            (widget.monthData['medicine'][0]
                                            .toStringAsFixed(1) ==
                                        "0.0"
                                    ? "0"
                                    : widget.monthData['medicine'][0]
                                        .toStringAsFixed(1)) +
                                '\n/' +
                                (widget.monthData['medicine'][1]
                                            .toStringAsFixed(1) ==
                                        "-1.0"
                                    ? "0"
                                    : widget.monthData['medicine'][1]
                                        .toStringAsFixed(1)),
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: rowwidth,
                        height: columnheight,
                        decoration: BoxDecoration(
                            color: columnhexcolor,
                            border: Border.all(
                                color: borderhexcolor, width: borderwidth),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(borderradius))),
                        child: Center(
                          child: Text(
                            '안전사고',
                            style:
                                TextStyle(fontSize: 14.sp, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: rowwidth,
                        height: rowheight,
                        decoration: BoxDecoration(
                          color: rowhexColor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            (widget.monthData['accident'][0]
                                            .toStringAsFixed(1) ==
                                        "0.0"
                                    ? "0"
                                    : widget.monthData['accident'][0]
                                        .toStringAsFixed(1)) +
                                '\n/' +
                                (widget.monthData['accident'][1]
                                            .toStringAsFixed(1) ==
                                        "0.0"
                                    ? "0"
                                    : widget.monthData['accident'][1]
                                        .toStringAsFixed(1)),
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 82.w,
                    height: (20 + widget.textMaxLine * 20).w,
                    decoration: BoxDecoration(
                        color: columnhexcolor,
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth)),
                    child: Center(
                      child: Text(
                        '요약',
                        style: TextStyle(
                            fontSize: fontsize14, color: fonthexcolor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                      width: 984.w,
                      height: (20 + widget.textMaxLine * 20).w,
                      decoration: BoxDecoration(
                          color: rowhexColor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth)),
                      child: Stack(
                        children: [
                          Focus(
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {
                              } else {
                                if (widget.monthData['comment'] ==
                                    widget.summary.text) {
                                } else {
                                  widget.postApi(
                                      widget.monthData['id'],
                                      widget.summary.text,
                                      "autoCreatedComment");
                                }
                              }
                            },
                            child: TextField(
                              maxLines: widget.textMaxLine,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: Color(0xff3C3C3B),
                              ),
                              controller: widget.summary,
                              // textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                // hintText: "ex)20221020",
                                // hintStyle: TextStyle(color: Colors.black26),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          // Text(
                          //   widget.getMonthlyReport.autoCreatedComment,
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.w400,
                          //     fontSize: 14.sp,
                          //     color: Color(0xff3C3C3B),
                          //   ),
                          // ),
                          Positioned(
                              right: 5.w,
                              top: 5.w,
                              child: GestureDetector(
                                onTap: () {
                                  widget.postApi(
                                      widget.monthData['id'], "", "autoCreate");
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
                      ))
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 82.w,
                    height: (100).w,
                    decoration: BoxDecoration(
                        color: columnhexcolor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(borderradius)),
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth)),
                    child: Center(
                      child: Text(
                        '가정연계',
                        style: TextStyle(
                            fontSize: fontsize14, color: fonthexcolor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    width: 984.w,
                    height: (100).w,
                    decoration: BoxDecoration(
                        color: rowhexColor,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(borderradius)),
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth)),
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        if (hasFocus) {
                        } else {
                          if (widget.toHome.text == '') {
                          } else if (widget.monthData['comment'] ==
                              widget.toHome.text) {
                          } else {
                            widget.postApi(widget.monthData['id'],
                                widget.toHome.text, "comment");
                            //해당 감정과 관련된 경험 api를 보내면 됩니다.
                            // _textEditingController.text
                          }
                        }
                      },
                      child: TextField(
                        maxLines:
                            widget.monthData['comment'].split('\n').length,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: Color(0xff3C3C3B),
                        ),
                        controller: widget.toHome,
                        // textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          // hintText: "ex)20221020",
                          // hintStyle: TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ), //외곽선
                        ),
                      ),
                    ),
                    // Text(
                    //   '',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w400,
                    //     fontSize: 14.sp,
                    //     color: Color(0xff3C3C3B),
                    //   ),
                    // )
                  )
                ],
              )
            ],
          ),
        )
      ],
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
                "현재 학부모 어플과 함께\n개발 중인 기능입니다.",
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
