

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:treasure_map/e_growth/atti/atti1.dart';
import 'package:treasure_map/provider/atti_child_data_management.dart';

import 'package:treasure_map/provider/survey_data_management.dart';
import 'package:treasure_map/widgets/api.dart';
import 'dart:ui';
import 'package:widget_mask/widget_mask.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audioplayers/audioplayers.dart';

import 'atti3.dart';

class Atti2 extends StatefulWidget {
  const Atti2({
    Key? key,

  }) : super(key: key);


  @override
  State<Atti2> createState() => _Atti2State();
}

class _Atti2State extends State<Atti2> {
  int j = 0;

  surveyedCheck() async {
    ApiUrl apiUrl = ApiUrl();
    http.Response res = await api('${apiUrl.attiChild}/${Provider.of<SurveyDataManagement>(context,listen: false).rid}', 'get', 'signInToken', {}, context);
    if(res.statusCode == 200){
      var childRB = utf8.decode(res.bodyBytes);
      var childData = jsonDecode(childRB);
      Provider.of<AttiChildDataManagement>(context, listen: false)
          .childList
          .clear();
        for (int i = 0; i < childData.length; i++) {
          Image image = await imageApi(childData[i]['imagePath'], 'signInToken', context);
          setState(() {
          Provider.of<AttiChildDataManagement>(context, listen: false)
              .childList
              .add(AttiChild(
              identification: childData[i]['identification'],
              name: childData[i]['name'],
              sex: childData[i]['sex'],
              childFaceUrl: childData[i]['imagePath'],
              childFace: image,
              attiSurveyed: childData[i]['surveyed']
          ));
          });
        }
      int surveyTrue = 0;
      for (int i = 0;
      i < context.read<AttiChildDataManagement>().childList.length;
      i++) {
        context
            .read<AttiChildDataManagement>()
            .childList[i].attiSurveyed =
            childData[i]['surveyed'];

        if (childData[i]['surveyed'] == true) {
          surveyTrue++;
        }
      }
      if (surveyTrue ==
          context.read<AttiChildDataManagement>().childList.length) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SurveyedCheckDialog();
            });
      }
    }
  }

  @override
  void initState() {
    surveyedCheck();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int columnCount =
        Provider.of<AttiChildDataManagement>(context, listen: false)
                .childList
                .length ~/
            6;
    int rowCount = Provider.of<AttiChildDataManagement>(context, listen: false)
            .childList
            .length %
        6;
    precacheImage(Image.asset('assets/backgrounds/atti/atti_survey_page.png').image, context);
    return WillPopScope(
        onWillPop: () async => false,
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset('assets/backgrounds/atti/atti_survey_page.png').image,
            )),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Positioned(
                        top: 30.w,
                        left: 10.w,
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Atti1()),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Color(0xffA666FC),
                          ),
                          iconSize: 50.w,
                          color: Color(0xffA666FC),
                        )),
                    Center(
                      child: Container(
                        width: 1026.w,
                        height: 740.w,
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior().copyWith(overscroll: false),
                          child: ListView(
                            physics: const RangeMaintainingScrollPhysics(),
                            children: [
                              for (int i = 0; i < columnCount + 1; i++) ...[
                                Row(
                                  children: [
                                    if (i <= columnCount - 1) ...[
                                      for (int j = 0; j < 6; j++) ...[
                                        ChildFaceButton(
                                          childFace: context
                                              .watch<AttiChildDataManagement>()
                                              .childList[i * 6 + j]
                                              .childFace,
                                          childNumber: context
                                              .watch<AttiChildDataManagement>()
                                              .childList[i * 6 + j]
                                              .identification,
                                          surveyed: context
                                              .watch<AttiChildDataManagement>()
                                              .childList[i * 6 + j]
                                              .attiSurveyed,
                                          name: context
                                              .watch<AttiChildDataManagement>()
                                              .childList[i * 6 + j]
                                              .name,
                                          rid: Provider.of<SurveyDataManagement>(context, listen: false).rid,
                                          inClassNumber: i * 6 + j,
                                          sex: context
                                              .watch<AttiChildDataManagement>()
                                              .childList[i * 6 + j]
                                              .sex,
                                        ),
                                      ]
                                    ] else
                                      for (int j = 0; j < rowCount; j++) ...[
                                        ChildFaceButton(
                                          childFace: context
                                              .watch<AttiChildDataManagement>()
                                              .childList[i * 6 + j]
                                              .childFace,
                                          childNumber: context
                                              .watch<AttiChildDataManagement>()
                                              .childList[i * 6 + j]
                                              .identification,
                                          surveyed: context
                                              .watch<AttiChildDataManagement>()
                                              .childList[i * 6 + j]
                                              .attiSurveyed,
                                          name: context
                                              .watch<AttiChildDataManagement>()
                                              .childList[i * 6 + j]
                                              .name,
                                          rid: Provider.of<SurveyDataManagement>(context, listen: false).rid,
                                          inClassNumber: i * 6 + j,
                                          sex: context
                                              .watch<AttiChildDataManagement>()
                                              .childList[i * 6 + j]
                                              .sex,
                                        ),
                                      ]
                                  ],
                                )
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}

class ChildFaceButton extends StatefulWidget {
  const ChildFaceButton({
    Key? key,
    required this.childFace,
    required this.childNumber,
    required this.surveyed,
    required this.name,
    required this.inClassNumber,
    required this.rid,
    required this.sex,
  }) : super(key: key);
  final Image childFace;
  final int childNumber;
  final bool surveyed;
  final String name;
  final int inClassNumber;
  final int rid;
  final bool sex;

  @override
  State<ChildFaceButton> createState() => _ChildFaceButtonState();
}

class _ChildFaceButtonState extends State<ChildFaceButton> {
  AudioPlayer player = AudioPlayer();
  String audioasset = 'assets/sound/effect/scene0_click.mp3';

  soundPlayer() async {
    await player.setSource(AssetSource('sound/effect/scene0_click.mp3'));
  }

  @override
  void initState() {
    soundPlayer();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          width: 116.w,
          margin:
              EdgeInsets.only(top: 0.w, left: 25.w, right: 30.w, bottom: 0.w),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 8.w),
                width: 100.w,
                height: 129.w,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x297B7B7B),
                      // spreadRadius: ,
                      blurRadius: 4,
                      offset: Offset(3, 3),
                    )
                  ],
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              Center(
                child: WidgetMask(
                    blendMode: BlendMode.srcATop,
                    childSaveLayer: true,
                    mask: widget.childFace,
                    child: Container(
                      width: 100.w,
                      height: 129.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    )),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 100.w,
                ),
                child: Container(
                  height: 36.w,
                  width: 116.w,
                  // margin: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(26.w)),
                    color: widget.surveyed == true
                        ? Color(0xff999999)
                        : Color(0xffA666FC),
                  ),
                  child: Center(
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 17.w,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          )),
      onTap: () async {
        player.resume();
        // Provider.of<SoundManagement>(context, listen: false).playClickSound();

        showDialog(
            barrierDismissible: false,
            barrierColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) {
              return ConfirmDialog(
                name: widget.name,
                id: widget.childNumber,
                rid: widget.rid,
                childFace: widget.childFace,
                surveyed: widget.surveyed,
                inClassNumber: widget.inClassNumber,
                sex: widget.sex,
              );
            });

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => C2()),
        // );
      },
    );
  }
}

class ConfirmDialog extends StatefulWidget {
  const ConfirmDialog({
    Key? key,
    required this.name,
    required this.rid,
    required this.id,
    required this.childFace,
    required this.surveyed,
    required this.inClassNumber,
    required this.sex,
  }) : super(key: key);
  final String name;
  final int id;
  final int rid;
  final Image childFace;
  final bool surveyed;
  final int inClassNumber;
  final bool sex;

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.w))),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.w)),
          color: Color(0xffF9FCF4),
        ),
        width: 800.w,
        height: 450.w,
        child: Column(
          children: [
            SizedBox(
              height: 81.w,
            ),
            Row(
              children: [
                SizedBox(
                  width: 204.w,
                ),
                Container(
                    width: 175.w,
                    height: 202.w,
                    color: Color(0xffF9FCF4),
                    child: WidgetMask(
                        blendMode: BlendMode.srcATop,
                        childSaveLayer: true,
                        mask: widget.childFace,
                        child: Container(
                          width: 175.w,
                          height: 202.w,
                          color: Colors.white,
                        ))),
                SizedBox(
                  width: 71.w,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 30.w,
                    ),
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 24.w,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff393838),
                      ),
                    ),
                    SizedBox(
                      height: 19.w,
                    ),
                    widget.surveyed == true
                        ? Text(
                            "이미 조사를\n마친 아이입니다",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.w,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffF96797),
                            ),
                          )
                        : Text(
                            '이 친구가 맞나요?',
                            style: TextStyle(
                              fontSize: 18.w,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff393838),
                            ),
                          ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 60.w,
            ),
            Container(
              width: 350.w,
              child: Row(
                children: [
                  Container(
                    width: 150.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.w)),
                        border: Border.all(
                          width: 1.w,
                          color: Color(0xffA666FB),
                        )),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xffffffff)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w),
                          ))),
                      onPressed: () {
                        Provider.of<SurveyDataManagement>(context, listen: false).inClassNumber = widget.inClassNumber;
                        Provider.of<SurveyDataManagement>(context, listen: false).cid = widget.id;
                        Provider.of<SurveyDataManagement>(context, listen: false).sex = widget.sex;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Atti3(),
                          ),
                        );
                      },
                      child: widget.surveyed == true
                          ? Text(
                              "다시하기",
                              style: TextStyle(
                                fontSize: 18.w,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff393838),
                              ),
                            )
                          : Text(
                              "맞아요",
                              style: TextStyle(
                                fontSize: 18.w,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff393838),
                              ),
                            ),
                    ),
                  ),

                  // ),)),
                  Spacer(),

                  Container(
                    width: 150.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.w)),
                        border: Border.all(
                          width: 1.w,
                          color: Color(0xffA666FB),
                        )),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xffffffff)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w),
                          ))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: widget.surveyed == true
                          ? Text(
                              "그만하기",
                              style: TextStyle(
                                fontSize: 18.w,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff393838),
                              ),
                            )
                          : Text(
                              "아니에요",
                              style: TextStyle(
                                fontSize: 18.w,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff393838),
                              ),
                            ),
                    ),
                  ),

                  // SizedBox(
                  //   width: 30.w,
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SurveyedCheckDialog extends StatefulWidget {
  const SurveyedCheckDialog({Key? key}) : super(key: key);

  @override
  State<SurveyedCheckDialog> createState() => _SurveyedCheckDialogState();
}

class _SurveyedCheckDialogState extends State<SurveyedCheckDialog> {
  finSurvey() async{
    ApiUrl apiUrl = ApiUrl();
    http.Response res = await api(apiUrl.atti + '/' + Provider.of<SurveyDataManagement>(context, listen: false).rid.toString(), 'patch', 'signInToken', {}, context);
    if(res.statusCode == 200){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Atti1()),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 400.w,
        height: 250.w,
        child: Container(
          padding: EdgeInsets.only(top: 30, left: 30, right: 30),
          child: Column(
            children: [
              Text(
                "이번 회차의 모든 아이들이\n조사를 완료하였습니다.\n\n보고서를 작성하시겠습니까?",
                style: TextStyle(
                  fontSize: 18.w,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff393838),
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "보고서가 생성되면 수정할 수 없습니다.",
                style: TextStyle(
                  fontSize: 15.w,
                  fontWeight: FontWeight.w400,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 25.w,
              ),
              Container(
                width: 350.w,
                height: 50.w,
                child: Row(
                  children: [
                    Container(
                      width: 150.w,
                      height: 40.w,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xffA666FB)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.w),
                                ))),
                        onPressed: () async {
                          finSurvey();
                        },
                        child: Text(
                          "예",
                          style: TextStyle(
                            fontSize: 18.w,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff393838),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),

                    Container(
                      width: 150.w,
                      height: 40.w,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xffCAACF2)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.w),
                                ))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "아니오",
                          style: TextStyle(
                            fontSize: 18.w,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff393838),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
