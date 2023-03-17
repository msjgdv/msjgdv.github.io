import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:treasure_map/d_play/d4.dart';
import 'package:treasure_map/provider/app_management.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/image_container.dart';
import 'package:treasure_map/widgets/nuri.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../widgets/custom_container.dart';


class SampleRecord extends StatefulWidget {
  const SampleRecord({Key? key,
    required this.recordId,
  }) : super(key: key);
  final int recordId;

  @override
  State<SampleRecord> createState() => _SampleRecordState();
}

class _SampleRecordState extends State<SampleRecord> {
  var recordData;
  ApiUrl apiUrl = ApiUrl();
  Nuri nuri = Nuri();
  List<int> nuriTextOverLength = [];
  List<Image?> signImage = [];
  Color borderColor = const Color(0x9dC13BFD);
  DateTime? nowDate;

  List<String> weekDay = ["", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];

  getRecordData() async {
    recordData = null;
    http.Response recordRes = await api(
        '${apiUrl.record}/${widget.recordId}',
        'get',
        'signInToken',
        {},
        context);
    if (recordRes.statusCode == 200) {
      var recordRB = utf8.decode(recordRes.bodyBytes);
      recordData = jsonDecode(recordRB);


      // content.text = recordData["content"] ?? '';
      // environmentalSupport.text = recordData["environmentalSupport"] ?? '';
      // emotionalSupport.text = recordData["emotionalSupport"] ?? '';
      // linguisticSupport.text = recordData["linguisticSupport"] ?? '';

      if (recordData["time"] == null) {
        nowDate = DateTime.parse(recordData['date'] + " 00:00");
      } else {
        nowDate =
            DateTime.parse(recordData['date'] + ' ' + recordData['time']);
      }


      totalHeight = 910;
      nuriTextOverLength = [];
      for (int i = 0; i < recordData["children"].length; i++) {
        nuriTextOverLength.add(0);
        totalHeight = totalHeight + 40 + (recordData["nuri"][i].length < 1
            ? 0
            : (recordData["nuri"][i].length) - 1) * 27;
        // for (int j = 0; j < recordData["nuri"][i].length; j++) {
        //   if (nuri.areaCommentary[recordData['nuriAge']][int
        //       .parse(
        //       recordData["nuri"][i][j]
        //           .split('')[0]) - 1][int
        //       .parse(
        //       recordData["nuri"][i][j]
        //           .split('')[1]) - 1]
        //   [int
        //       .parse(
        //       recordData["nuri"][i][j]
        //           .split('')[2]) - 1].length > 25) {
        //     nuriTextOverLength[i]++;
        //   }
        // }
        totalHeight = totalHeight + nuriTextOverLength[i] * 20;
      }

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
      setState(() {});
    }
  }

  double totalHeight = 910;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecordData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.w))),
        child: Container(
          width: 1100.w,
          height: 600.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.w)),
            color: Color(0xffffffff),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 50.w
              ),
              Expanded(
                child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(
                        overscroll: false),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: const RangeMaintainingScrollPhysics(),
                      children: [
                        Stack(
                          children: [
                            Container(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 1053.w,
                                    // height: totalHeight,
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
                                              BorderRadius.only(
                                                  topLeft: Radius.circular(20.w)),
                                              cInsideColor: Color(0xffE5D0FE),
                                              cTopBorderWidth: 1.w,
                                              cLeftBorderWidth: 1.w,
                                              childWidget: Center(
                                                child: DailyRoutineTableTextStyle(
                                                  text:
                                                  Provider
                                                      .of<UserInfo>(
                                                      context, listen: false)
                                                      .value[2] +
                                                      "의 놀이관찰기록",
                                                ),
                                              ),
                                            ),
                                            CustomContainer(
                                              cBorderColor: borderColor,
                                              cTotalHeight: 50.w,
                                              cTotalWidth: 500.w,
                                              cBorderRadius:
                                              BorderRadius.only(
                                                  topRight: Radius.circular(20.w)),
                                              cInsideColor: Color(0xffCAACF2),
                                              cTopBorderWidth: 1.w,
                                              cLeftBorderWidth: 1.w,
                                              cRightBorderWidth: 1.w,
                                              childWidget: Center(
                                                child: DailyRoutineTableTextStyle(
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
                                                child: DailyRoutineTableTextStyle(
                                                  text: "생활주제",

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
                                                child: DailyRoutineTableTextStyle(
                                                  text: "주제",

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
                                                child: DailyRoutineTableTextStyle(
                                                  text: "결재",

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
                                                    ? DailyRoutineTableTextStyle(
                                                  text: recordData['mainTheme'] ?? '',
                                                ) : DailyRoutineTableTextStyle(
                                                  text: '',
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
                                                    ?
                                                DailyRoutineTableTextStyle(
                                                  text: recordData['theme'] ?? '',
                                                ) : DailyRoutineTableTextStyle(
                                                  text: '',
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
                                                child: DailyRoutineTableTextStyle(
                                                  text: '담임',

                                                ),
                                              ),
                                            ),
                                            CustomContainer(
                                              cBorderColor: borderColor,
                                              cTotalHeight: 70.w,
                                              cTotalWidth: 80.w,
                                              cInsideColor: Color(0xffffffff),
                                              cTopBorderWidth: 1.w,
                                              cLeftBorderWidth: 1.w,
                                              childWidget: Center(
                                                child: signImage.isNotEmpty
                                                    ? signImage[0] ??
                                                    Container()
                                                    : Container(),
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
                                                child: DailyRoutineTableTextStyle(
                                                  text: '원감',

                                                ),
                                              ),
                                            ),
                                            CustomContainer(
                                              cBorderColor: borderColor,
                                              cTotalHeight: 70.w,
                                              cTotalWidth: 80.w,
                                              cInsideColor: Color(0xffffffff),
                                              cTopBorderWidth: 1.w,
                                              cLeftBorderWidth: 1.w,
                                              childWidget: Center(
                                                child: signImage.length > 1
                                                    ? signImage[1] ??
                                                    Container()
                                                    : Container(),
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
                                                child: DailyRoutineTableTextStyle(
                                                  text: '원장',

                                                ),
                                              ),
                                            ),
                                            CustomContainer(
                                              cBorderColor: borderColor,
                                              cTotalHeight: 70.w,
                                              cTotalWidth: 80.w,
                                              cInsideColor: Color(0xffffffff),
                                              cTopBorderWidth: 1.w,
                                              cLeftBorderWidth: 1.w,
                                              cRightBorderWidth: 1.w,
                                              childWidget: Center(
                                                child: signImage.length > 2
                                                    ? signImage[2] ??
                                                    Container()
                                                    : Container(),
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
                                                child: DailyRoutineTableTextStyle(
                                                  text: "소주제",

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
                                                child: DailyRoutineTableTextStyle(
                                                  text: "놀이소주제",

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
                                                child: DailyRoutineTableTextStyle(
                                                  text: "놀이주제",

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
                                                child: DailyRoutineTableTextStyle(
                                                  text: "공간",

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
                                                    ? DailyRoutineTableTextStyle(
                                                  text: recordData['subTheme'] ?? '',
                                                ) : DailyRoutineTableTextStyle(
                                                  text: '',
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
                                                    ? DailyRoutineTableTextStyle(
                                                  text: recordData['subject'] ?? '',
                                                ) : DailyRoutineTableTextStyle(
                                                  text: '',
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
                                                    ? DailyRoutineTableTextStyle(
                                                  text: recordData['subject'] ?? '',
                                                ) : DailyRoutineTableTextStyle(
                                                  text: '',
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
                                                    ? DailyRoutineTableTextStyle(
                                                  text: recordData['space'] ?? '',
                                                ) : DailyRoutineTableTextStyle(
                                                  text: '',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),


                                        Row(
                                          children: [
                                            CustomContainer(
                                                cBorderColor: borderColor,
                                                cTotalHeight: 250.w,
                                                cTotalWidth: 464.w,
                                                cInsideColor: Color(0xffffffff),
                                                cTopBorderWidth: 1.w,
                                                cLeftBorderWidth: 1.w,
                                                childWidget: Stack(
                                                  children: [

                                                    if(recordData != null)...[
                                                      for(int i = 0; i <
                                                          recordData['imagePaths']
                                                              .length; i++)...[
                                                        for(int j = 0; j <
                                                            recordData['imagePaths']
                                                                .length; j++)...[
                                                          if(recordData['ls'][j] ==
                                                              i + 1)...[
                                                            ImageContainer(
                                                              rid: widget
                                                                  .recordId,
                                                              // scrollController: widget.scrollRemote,
                                                              imagePath: recordData['imagePaths'][j],
                                                              imageId: recordData['imageIds'][j],
                                                              positionX: recordData['xs'][j]
                                                                  .toDouble(),
                                                              positionY: recordData['ys'][j]
                                                                  .toDouble(),
                                                              totalWidth: recordData['ws'][j]
                                                                  .toDouble(),
                                                              totalHeight: recordData['hs'][j]
                                                                  .toDouble(),
                                                              level: recordData['ls'][j],
                                                              index: i,
                                                              getRecordData: getRecordData,
                                                              picture: false,
                                                            ),
                                                          ]
                                                        ]
                                                      ]
                                                    ]


                                                  ],
                                                )
                                            ),


                                            CustomContainer(
                                              cBorderColor: borderColor,
                                              cTotalHeight: 250.w,
                                              cTotalWidth: 589.w,
                                              cInsideColor: Color(0xffffffff),
                                              cTopBorderWidth: 1.w,
                                              cLeftBorderWidth: 1.w,
                                              cRightBorderWidth: 1.w,
                                              childWidget: ScrollConfiguration(
                                                behavior: const ScrollBehavior().copyWith(overscroll: false),
                                                child: ListView(
                                                  padding: EdgeInsets.zero,
                                                  physics: const RangeMaintainingScrollPhysics(),
                                                  children: [
                                                    DailyRoutineTableTextStyle(
                                                      text: recordData != null ? recordData["content"] ?? '' : '',
                                                    ),
                                                  ],
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
                                                child: DailyRoutineTableTextStyle(
                                                  text: "놀이참여유아",
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
                                                child: DailyRoutineTableTextStyle(
                                                  text: "누리과정관련요소",

                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (recordData != null) ...[
                                          for (int i = 0; i < recordData["children"]
                                              .length; i++) ...[
                                            Row(
                                              children: [
                                                CustomContainer(
                                                  cBorderColor: borderColor,
                                                  cTotalHeight: 40.w +
                                                      (recordData["nuri"][i]
                                                          .length < 1
                                                          ? 0
                                                          : (recordData["nuri"][i]
                                                          .length) - 1) * 27 +
                                                      nuriTextOverLength[i] * 20.w,
                                                  cTotalWidth: 100.w,
                                                  cInsideColor: Color(0xffCAACF2),
                                                  cTopBorderWidth: 1.w,
                                                  cLeftBorderWidth: 1.w,
                                                  childWidget: Stack(
                                                    children: [
                                                      Center(
                                                        child: DailyRoutineTableTextStyle(
                                                          text: recordData["children"][i],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                CustomContainer(
                                                    cBorderColor: borderColor,
                                                    cTotalHeight: 40.w +
                                                        (recordData["nuri"][i]
                                                            .length <
                                                            1
                                                            ? 0
                                                            : (recordData["nuri"][i]
                                                            .length) - 1) * 27 +
                                                        nuriTextOverLength[i] * 20
                                                            .w,
                                                    cTotalWidth: 953.w,
                                                    cInsideColor: Color(0xffffffff),
                                                    cTopBorderWidth: 1.w,
                                                    cLeftBorderWidth: 1.w,
                                                    cRightBorderWidth: 1.w,
                                                    childWidget: Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .start,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceAround,
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            for(int j = 0; j <
                                                                recordData["nuri"][i]
                                                                    .length; j++)...[
                                                              Row(

                                                                children: [
                                                                  Container(
                                                                    width: (953 - 60).w,
                                                                    child: DailyRoutineTableTextStyle(
                                                                      text: 'ㆍ' +
                                                                          nuri
                                                                              .area[recordData['nuriAge']][int
                                                                              .parse(
                                                                              recordData["nuri"][i][j]
                                                                                  .split(
                                                                                  '')[0]) -
                                                                              1] +
                                                                          ' : ' +
                                                                          nuri
                                                                              .areaContent[recordData['nuriAge']][int
                                                                              .parse(
                                                                              recordData["nuri"][i][j]
                                                                                  .split(
                                                                                  '')[0]) -
                                                                              1][int
                                                                              .parse(
                                                                              recordData["nuri"][i][j]
                                                                                  .split(
                                                                                  '')[1]) -
                                                                              1] +
                                                                          '(' +
                                                                          nuri
                                                                              .areaCommentary[recordData['nuriAge']][int
                                                                              .parse(
                                                                              recordData["nuri"][i][j]
                                                                                  .split(
                                                                                  '')[0]) -
                                                                              1][int
                                                                              .parse(
                                                                              recordData["nuri"][i][j]
                                                                                  .split(
                                                                                  '')[1]) -
                                                                              1][int
                                                                              .parse(
                                                                              recordData["nuri"][i][j]
                                                                                  .split(
                                                                                  '')[2]) -
                                                                              1] +
                                                                          ')',


                                                                    ),
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
                                                child: DailyRoutineTableTextStyle(
                                                  text: "유아관심",

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
                                                      ? DailyRoutineTableTextStyle(
                                                    text: recordData['interest'] ?? '',
                                                  ) : DailyRoutineTableTextStyle(
                                                    text: '',
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
                                                child: DailyRoutineTableTextStyle(
                                                  text: "놀이지원실제",

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
                                                child: DailyRoutineTableTextStyle(
                                                  text: "환경적지원",

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
                                                child: DailyRoutineTableTextStyle(
                                                  text: "정서적지원",

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
                                                child: DailyRoutineTableTextStyle(
                                                  text: "언어적 지원",

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
                                              childWidget: Center(
                                                child: DailyRoutineTableTextStyle(
                                                  text: recordData != null ? recordData["environmentalSupport"] ?? '': '',
                                                ),
                                              ),
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
                                                child: DailyRoutineTableTextStyle(
                                                  text: recordData != null ? recordData["emotionalSupport"] ?? '': '',
                                                ),
                                              ),
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
                                                child: DailyRoutineTableTextStyle(
                                                  text: recordData != null ? recordData["linguisticSupport"] ??'' : '',
                                                ),
                                              ),
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
                                                child: DailyRoutineTableTextStyle(
                                                  text: "놀이지원계획",

                                                ),
                                              ),
                                            ),
                                            CustomContainer(
                                                cBorderColor: borderColor,
                                                cTotalHeight: 60.w,
                                                cTotalWidth: 953.w,
                                                cInsideColor: Color(0xffffffff),
                                                cBorderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(
                                                      20.w),
                                                ),
                                                cTopBorderWidth: 1.w,
                                                cLeftBorderWidth: 1.w,
                                                cRightBorderWidth: 1.w,
                                                cBottomBorderWidth: 1.w,
                                                childWidget: Center(
                                                  child: recordData != null
                                                      ? DailyRoutineTableTextStyle(
                                                    text: recordData['supportPlan'] ?? '',
                                                  ) : DailyRoutineTableTextStyle(
                                                    text: '',
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),


                          ],
                        )
                      ],

                    )),
              ),
              SizedBox(
                  height: 10.w
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); //result 반영 dialog 종료
                },
                child: Text('닫기',
                    style: TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.w400)),
                style: ElevatedButton.styleFrom(
                    elevation: 1.0,
                    primary: const Color(0xFFFFFFFF),
                    onPrimary: const Color(0xFF393838),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.w)),
                    side: const BorderSide(color: Color(0xFFA666FB)),
                    fixedSize: Size(120.w, 40.w)),
              ),
              SizedBox(
                  height: 30.w
              ),
            ],
          ),
        )
    );
  }
}
