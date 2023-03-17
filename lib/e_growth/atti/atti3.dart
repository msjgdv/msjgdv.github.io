import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/e_growth/atti/atti2.dart';

import 'package:treasure_map/provider/survey_data_management.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';

import '../../provider/atti_child_data_management.dart';
import 'atti4.dart';

class Atti3 extends StatefulWidget {
  const Atti3({
    Key? key,
  }) : super(key: key);

  @override
  State<Atti3> createState() => _Atti3State();
}

class _Atti3State extends State<Atti3> {
  List<Map<int, bool>> pickedChild = [];
  List<bool> visibility = [];
  List<int> positionNumber = [];
  List<bool> positivePointing = [];
  int j = 0;

  double heightSize = 1240 * 790.h/1240.w;

  List<AudioPlayer> player = [AudioPlayer(),AudioPlayer()];
  List<String> audioAsset = [
    'sound/voice/audio_0_1.mp3',
    'sound/voice/audio_0_2.mp3',
    'sound/voice/audio_1_1.mp3',
    'sound/voice/audio_1_2.mp3',
  ];

  soundPlayer(int index,) async {
    int sex = 0;
    Provider.of<SurveyDataManagement>(context, listen: false).sex ? sex = 0: sex = 1;
    // ByteData bytes = await rootBundle.load(audioAsset[index * 2 + sex]);
    // Uint8List audioBytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    // await player[index].setSourceBytes(audioBytes);
    await player[index].setSource(AssetSource(audioAsset[index * 2 + sex]));
    player[index].resume();
  }

  Timer t = Timer(Duration(milliseconds: 8000), () {});

  visibilityOnOff(int nowWidget, bool onOff) {
    setState(() {
      visibility[nowWidget] = !onOff;
    });
  }

  positivePoint(int positive, bool onOff) {
    positivePointing[positive] = !onOff;
  }

  @override
  void initState() {
    print(heightSize);
    print(789-heightSize);
    print(1240/790 > 1240.w/790.h ? 530.w : (530 - 789-heightSize).w);
    soundPlayer(0);
    t = Timer(Duration(milliseconds: 8000), () {
      soundPlayer(1);
    });

    for (int i = 0;
        i <
            Provider.of<AttiChildDataManagement>(context, listen: false)
                .childList
                .length;
        i++) {
      visibility.add(false);
      positivePointing.add(false);
      if (Provider.of<SurveyDataManagement>(context, listen: false)
              .inClassNumber ==
          i) {
        positionNumber.add(0);
        j--;
      } else {
        positionNumber.add(i + j);
      }
    }
    Provider.of<SurveyDataManagement>(context, listen: false)
        .positivePoint
        .clear();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double degrees = -12;
    double radians = degrees * math.pi / 180;
    precacheImage(Image.asset('assets/backgrounds/atti/atti_survey_01.png').image, context);
    return WillPopScope(
        onWillPop: () async => false,
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset('assets/backgrounds/atti/atti_survey_01.png').image,
            )),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Stack(children: [
                      Positioned(
                          top: 10.w,
                          left: 10.w,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                player[0].stop();
                                player[1].stop();
                                t.cancel();
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Atti2()),
                              );
                            },
                            icon: SvgPicture.asset(
                              'assets/images/atti/atti_back.svg',
                            ),
                            iconSize: 50.w,
                            color: Color(0xffA666FC),
                          )),
                      for (int i = 0;
                          i <
                              Provider.of<AttiChildDataManagement>(context,
                                      listen: false)
                                  .childList
                                  .length;
                          i++) ...[
                        if (Provider.of<SurveyDataManagement>(context,
                                    listen: false)
                                .inClassNumber ==
                            i)
                          ...[]
                        else ...[
                          BackGroundChild(
                            positionNumber: positionNumber[i],
                            inClassNumber: i,
                            visibility: visibility[positionNumber[i]],
                            visibilityOnOff: visibilityOnOff,
                            positiveOnOff: positivePoint,
                            childFace: Provider.of<AttiChildDataManagement>(
                                    context,
                                    listen: false)
                                .childList[i]
                                .childFace,
                          ),
                        ],
                      ],
                      Positioned(
                          // top: 468.w,
                        bottom: 1240/790 > 1240.w/790.h ? 132.w : (132 - (789 - heightSize)).w,
                          left: 563.w,
                          child: SvgPicture.asset(
                            'assets/images/atti/child_type_01_02.svg',
                            width: 120.w,
                            color: Color(0x22000000),
                            // color: Color(0xffA666FC),
                          )),
                      Positioned(
                          bottom: 1240/790 > 1240.w/790.h ? 129.w : (129 - (789 - heightSize)).w,
                          // top: 465.w,
                          left: 560.w,
                          child: SvgPicture.asset(
                            'assets/images/atti/child_type_01_02.svg',
                            width: 120.w,
                            // color: Color(0xffA666FC),
                          )),
                      Positioned(
                          bottom: 1240/790 > 1240.w/790.h ? 239.w : (239 - (789 - heightSize)).w,
                          // top: 460.w,
                          left: 574.w,
                          child: WidgetMask(
                              blendMode: BlendMode.srcATop,
                              childSaveLayer: true,
                              mask: Provider.of<AttiChildDataManagement>(
                                      context,
                                      listen: false)
                                  .childList[Provider.of<SurveyDataManagement>(
                                          context,
                                          listen: false)
                                      .inClassNumber]
                                  .childFace,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                width: 70.w,
                                height: 90.w,
                              ))),
                      Positioned(
                          bottom: 1240/790 > 1240.w/790.h ? 291.5.w : (291.5 - (789 - heightSize)).w,
                          // top: 436.w,
                          left: 597.w,
                          child: SvgPicture.asset(
                            'assets/images/atti/crown.svg',
                            color: Color(0x22000000),
                            width: 80.w,
                            // color: Color(0xffA666FC),
                          )),
                      Positioned(
                          bottom: 1240/790 > 1240.w/790.h ? 288.5.w : (288.5 - (789 - heightSize)).w,
                          // top: 433.w,
                          left: 594.w,
                          child: SvgPicture.asset(
                            'assets/images/atti/crown.svg',
                            width: 80.w,
                            // color: Color(0xffA666FC),
                          )),
                      Positioned(
                        bottom: -10.w,
                          // top: 550.w,
                          left: 680.w,
                          child: IconButton(
                            onPressed: () {
                              for (int i = 0;
                                  i <
                                      Provider.of<AttiChildDataManagement>(
                                              context,
                                              listen: false)
                                          .childList
                                          .length;
                                  i++) {
                                if (positivePointing[i] == true) {
                                  Provider.of<SurveyDataManagement>(context,
                                          listen: false)
                                      .positivePoint
                                      .add(Provider.of<AttiChildDataManagement>(
                                              context,
                                              listen: false)
                                          .childList[i]
                                          .identification);
                                }
                              }
                              Navigator.pop(context);
                              setState(() {
                                player[0].stop();
                                player[1].stop();
                                t.cancel();

                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Atti4()),
                              );
                            },
                            icon: Stack(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/atti/sign.svg',
                                ),
                                Positioned(
                                    top: 49.w,
                                    left: 30.w,
                                    child: Transform.rotate(
                                      angle: radians,
                                      child: Text(
                                        "기차 타러가요!",
                                        style: TextStyle(
                                            fontFamily: "BM JUA_TTF",
                                            fontSize: 20.w,
                                            color: Color(0xff706046)),
                                      ),
                                    ))
                              ],
                            ),
                            iconSize: 200.w,
                            // color: Color(0xffA666FC),
                          )),
                    ])))));
  }
}

class BackGroundChild extends StatefulWidget {
  const BackGroundChild({
    Key? key,
    required this.inClassNumber,
    required this.visibility,
    required this.visibilityOnOff,
    required this.positionNumber,
    required this.positiveOnOff,
    required this.childFace,
  }) : super(key: key);
  final int positionNumber;
  final int inClassNumber;
  final bool visibility;
  final Image childFace;
  final Function(int, bool) visibilityOnOff;
  final Function(int, bool) positiveOnOff;

  @override
  State<BackGroundChild> createState() => _BackGroundChildState();
}

class _BackGroundChildState extends State<BackGroundChild> {
  AudioPlayer player = AudioPlayer();
  String audioAsset = 'assets/sound/effect/scene1_turnHat.mp3';

  soundPlayer() async {
    // ByteData bytes = await rootBundle.load(audioAsset);
    // Uint8List audioBytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    await player.setSource(AssetSource('sound/effect/scene1_turnHat.mp3'));
    // await player.setSourceBytes(audioBytes);
  }


  List<String> imageUrl = [
    'assets/images/atti/child_type_01_01.svg',
    'assets/images/atti/child_type_01_02.svg',
  ];
  List<List<double>> childImageInfo = [
    [10, 184, 286, 1050, 240],
    [0, 170, 322, 800, 250],
    [20, 213, 290, 550, 250],
    [13.5, 174, 275, 400, 250],
    [3, 170, 282, 200, 250],
    [0, 196, 273, 300, 320],
    [19.5, 200, 294, 700, 270],
    [10.5, 196, 268, 950, 280],
    [10, 191, 270, 100, 250],
    [12, 179, 275, 40, 350],
    [5.5, 187, 286, 800, 330],
    [0, 191, 288, 1000, 440],
    [7, 178, 279, 1100, 400],
    [0, 196, 291, 150, 320],
    [0, 199, 269, 400, 330],
    [0, 194, 295, 500, 350],
    [3, 180, 265, 600, 350],
    [1, 205, 274, 920, 360],
    [0, 186, 276, 700, 400],
    [6.5, 186, 275, 240, 400],
    [22.5, 204, 286, 80, 440],
    [10, 208, 300, 850, 440],
    [13, 197, 280, 400, 480],
    [5, 181, 292, 320, 530],
    [21.5, 202, 305, 200, 540],
    [12, 188, 300, 950, 540],
    [13, 206, 295, 1050, 560],
    [16, 189, 300, 50, 550],
    [3, 196, 318, 150, 550],
  ];

  @override
  void initState() {
    soundPlayer();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: childImageInfo[widget.positionNumber][4].w,
        left: childImageInfo[widget.positionNumber][3].w,
        child: GestureDetector(
            onTap: () {
              setState(() {
                player.resume();
                widget.visibilityOnOff(
                    widget.positionNumber, widget.visibility);
                widget.positiveOnOff(widget.inClassNumber, widget.visibility);
              });
            },
            child: Container(
              width: 120.w,
              height: 200.w,
              child: Stack(
                children: [
                  Positioned(
                    top: 33.w,
                    left: 3.w,
                    height: 163.w,
                    child: SvgPicture.asset(
                        imageUrl[widget.positionNumber % 2],
                      color: Color((0x22000000)),),
                    width: 100.w,
                  ),
                  Positioned(
                      top: 35.w,
                      left: widget.positionNumber % 2 == 0 ? 23.w : 15.w,
                      child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color((0x22000000)),
                            ),
                            width: 58.w,
                            height: 58.w,
                          )),
                  Visibility(
                    visible: widget.visibility,
                    child: Positioned(
                      height: 43.7.w,
                      left: widget.positionNumber % 2 == 0 ? 40.w : 30.w,
                      child: SvgPicture.asset('assets/images/atti/cone.svg'),
                      width: 28.w,),
                  ),

                  Positioned(
                      top: 30.w,
                      height: 163.w,
                      child: SvgPicture.asset(
                          imageUrl[widget.positionNumber % 2]),
                  width: 100.w,),
                  Positioned(
                      top: 27.w,
                      left: widget.positionNumber % 2 == 0 ? 23.w : 15.w,
                      child: WidgetMask(
                          blendMode: BlendMode.srcATop,
                          childSaveLayer: true,
                          mask: widget.childFace,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            width: 58.w,
                            height: 74.5.w,
                          ))),
                  Visibility(
                    visible: widget.visibility,
                    child: Positioned(
                      height: 43.7.w,
                        left: widget.positionNumber % 2 == 0 ? 40.w : 30.w,
                        child: SvgPicture.asset('assets/images/atti/cone.svg'),
                    width: 28.w,),
                  ),
                ],
              ),
            )));
  }
}

