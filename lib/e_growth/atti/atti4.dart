import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treasure_map/e_growth/atti/atti1.dart';
import 'package:treasure_map/e_growth/atti/atti3.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../provider/atti_child_data_management.dart';
import '../../provider/survey_data_management.dart';

class Atti4 extends StatefulWidget {
  const Atti4({Key? key}) : super(key: key);

  @override
  State<Atti4> createState() => _Atti4State();
}

class _Atti4State extends State<Atti4> {

  GlobalKey backGroundImageSize = GlobalKey();
  bool selected = true;
  List<int> positionNumber = [];
  List<bool> visibility = [];
  List<List<int>> pointing = [[], [], []];
  double trainPosition = 1300.w;
  List<int> addedTrain = [0, 0, 0];
  int animationTime = 0;
  int nowTrain = 0;
  int j = 0;
  bool startOn = false;
  Matrix4 transformTrain = Matrix4.rotationY(0);
  int touchBlockerInt = 1;
  int trueCount = 0;
  int headCount = 0;
  bool backButtonVisibility = true;


  List<Timer> soundTimer = [];

  List<AudioPlayer> player = [AudioPlayer(),AudioPlayer(),AudioPlayer(),AudioPlayer(),AudioPlayer(),AudioPlayer(),AudioPlayer(),AudioPlayer(),];
  List<String> audioAsset = [
    'sound/voice/audio_2_1.mp3',
    'sound/voice/audio_2_2.mp3',
    'sound/voice/audio_3_1.mp3',
    'sound/voice/audio_3_2.mp3',
    'sound/voice/audio_4_1.mp3',
    'sound/voice/audio_4_2.mp3',
    'sound/voice/audio_5_1.mp3',
    'sound/voice/audio_5_2.mp3',
    'sound/voice/audio_6_1.mp3',
    'sound/voice/audio_6_2.mp3',
    'sound/effect/scene2_trainApproach.mp3',
    'sound/effect/scene2_arrow.mp3',
    'sound/effect/4-3. Merry_Go_Silent_Film_Light.mp3',
  ];

  AudioPlayer trainGetOnPlayer = AudioPlayer();


  trainGetOnSoundPlayer() async {
    trainGetOnPlayer.stop();
    await trainGetOnPlayer.setSource(AssetSource('sound/effect/scene2_getonoff.mp3'));
    trainGetOnPlayer.resume();
  }




  soundPlayer(int index, bool voice) async {
    int sex = 0;
    Provider.of<SurveyDataManagement>(context, listen: false).sex ? sex = 0: sex = 1;
    if(voice){
      await player[index].setSource(AssetSource(audioAsset[index * 2 + sex]));
    }else{
      await player[index+5].setSource(AssetSource(audioAsset[10+index]));
    }
    if(voice){
      player[index].resume();
    }else{
      player[index+5].resume();
    }
  }



  visibilityOnOff(int number, bool onOff) {
    setState(() {
      visibility[number] = !onOff;
      if (!onOff == false) {
        trueCount ++;
      } else if (!onOff == true) {
        trueCount --;
      }
    });
    setState(() {
      if (trueCount == headCount - 1) {
        startOn = true;
      }
      if (trueCount != headCount - 1) {
        startOn = false;
      }
    });
  }

  pointChild(int _pointing, int _inClassNumber) {
    setState(() {
      pointing[_pointing].add(_inClassNumber);
    });
  }

  pointChildRemove(int _pointing, int _inClassNumber) {
    setState(() {
      pointing[_pointing].remove(_inClassNumber);
    });
  }

  trainLengthController(int _pointing, int sum) {
    setState(() {
      addedTrain[_pointing] = addedTrain[_pointing] + sum;
    });
  }

  trainPositionController(double sum) {
    setState(() {
      trainPosition = trainPosition + sum;
    });
  }

  _getSize(GlobalKey key) {
    if (key.currentContext != null) {
      final RenderBox renderBox =
      key.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size.height;
    }
  }

  endSurvey() async {
      List<int> idHolder = [];
      for(int i = 0 ; i< Provider
          .of<AttiChildDataManagement>(context, listen: false)
          .childList.length;i++){
        idHolder.add(Provider
            .of<AttiChildDataManagement>(context, listen: false)
            .childList[i].identification);
      }
    Provider
        .of<SurveyDataManagement>(context, listen: false)
        .threePoint
        .clear();
    Provider
        .of<SurveyDataManagement>(context, listen: false)
        .twoPoint
        .clear();
    Provider
        .of<SurveyDataManagement>(context, listen: false)
        .onePoint
        .clear();

    for (int i = 0; i < pointing[0].length; i++) {
      Provider
          .of<SurveyDataManagement>(context, listen: false)
          .threePoint
          .add(
          Provider
              .of<AttiChildDataManagement>(context, listen: false)
              .childList[pointing[0][i]]
              .identification);
    }
    for (int i = 0; i < pointing[2].length; i++) {
      Provider
          .of<SurveyDataManagement>(context, listen: false)
          .twoPoint
          .add(
          Provider
              .of<AttiChildDataManagement>(context, listen: false)
              .childList[pointing[2][i]]
              .identification);
    }
    for (int i = 0; i < pointing[1].length; i++) {
      Provider
          .of<SurveyDataManagement>(context, listen: false)
          .onePoint
          .add(
          Provider
              .of<AttiChildDataManagement>(context, listen: false)
              .childList[pointing[1][i]]
              .identification);
    }
    ApiUrl apiUrl = ApiUrl();
    http.Response res = await api(apiUrl.attiSurvey, Provider
        .of<AttiChildDataManagement>(context, listen: false)
        .childList[idHolder
        .indexWhere((idHolder) =>
    idHolder == Provider
        .of<SurveyDataManagement>(context, listen: false)
        .cid)].attiSurveyed == false ? 'post' : 'put', 'signInToken',
        {
    'cid': Provider
        .of<SurveyDataManagement>(context, listen: false)
        .cid,
    'rid': Provider
        .of<SurveyDataManagement>(context, listen: false)
        .rid,

    'positivePoint': Provider
        .of<SurveyDataManagement>(context, listen: false)
        .positivePoint,
    'twoPoint':
    Provider
        .of<SurveyDataManagement>(context, listen: false)
        .twoPoint,
    'onePoint':
    Provider
        .of<SurveyDataManagement>(context, listen: false)
        .onePoint,
    'threePoint': Provider
        .of<SurveyDataManagement>(context, listen: false)
        .threePoint,
    }
    , context);
    if(res.statusCode == 200){
      finSurvey();
    }
  }


  finSurvey() {
    soundPlayer(2, false);
    setState(() {
      touchBlockerInt = 1;
      startOn = false;
      selected = !selected;
      backButtonVisibility = false;
    });


    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        animationTime = 5000;
        trainPosition = -3000.w;
      });
    });
    Future.delayed(const Duration(milliseconds: 6000), () {
      setState(() {
        transformTrain = Matrix4.rotationY(math.pi);
        animationTime = 5000;
        trainPosition = 4000.w;
      });
    });
    Future.delayed(const Duration(milliseconds: 11000), () {
      setState(() {
        player[7].stop();
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Atti1()),
      );
    });
  }

  @override
  void initState() {
    soundPlayer(0, true);

    headCount = Provider
        .of<AttiChildDataManagement>(context, listen: false)
        .childList
        .length;
    for (int i = 0;
    i <
        Provider
            .of<AttiChildDataManagement>(context, listen: false)
            .childList
            .length;
    i++) {
      visibility.add(true);
      if (Provider
          .of<SurveyDataManagement>(context, listen: false)
          .inClassNumber ==
          i) {
        positionNumber.add(0);
        j--;
      } else {
        positionNumber.add(i + j);
      }
    }
    Future.delayed(const Duration(milliseconds: 0), () {
      setState(() {
        animationTime = 5000;
        trainPosition = -3000.w;
      });
    });
    soundTimer.add(Timer(Duration(milliseconds: 2000), () {
      soundPlayer(0, false);
    }));
    // Future.delayed(const Duration(milliseconds: 2000), () {
    //   setState(() {
    //     Provider.of<SoundManagement>(context, listen: false).playTrainSound();
    //   });
    // });
    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        transformTrain = Matrix4.rotationY(math.pi);
        animationTime = 5000;
        trainPosition = 4000.w;
      });
    });
    Future.delayed(const Duration(milliseconds: 10000), () {
      setState(() {
        transformTrain = Matrix4.rotationY(0);
        animationTime = 5000;
        trainPosition = 510.w;
      });
      // if (Provider
      //     .of<SurveyDataManagement>(context, listen: false)
      //     .sex) {
      //   Provider.of<SoundManagement>(context, listen: false).play04Sound0();
      // } else {
      //   Provider.of<SoundManagement>(context, listen: false).play04Sound1();
      // }
    });
    soundTimer.add(Timer(const Duration(milliseconds: 10000), (){
      soundPlayer(1, true);
    }));
    Future.delayed(const Duration(milliseconds: 15000), () {
      setState(() {
        selected = !selected;
        animationTime = 500;
      });
    });
    Future.delayed(const Duration(milliseconds: 15500), () {
      setState(() {
        touchBlockerInt = 0;
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(children: [
              SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Stack(children: [
                    AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                        top: selected
                            ? 0
                            : MediaQuery
                            .of(context)
                            .size
                            .height -
                            _getSize(backGroundImageSize),
                        child: Stack(children: [
                          Image.asset(
                            'assets/backgrounds/atti/atti_survey_02.png',
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            key: backGroundImageSize,
                          ),
                          AnimatedPositioned(
                              duration: Duration(
                                  milliseconds: animationTime),
                              curve: Curves.fastOutSlowIn,
                              top: 234.w,
                              left: trainPosition,
                              child: GestureDetector(
                                  onHorizontalDragEnd:
                                      (DragEndDetails dragEndDetails) {
                                    if (dragEndDetails.primaryVelocity! >
                                        0.0) {
                                      if (nowTrain == 0) {} else
                                      if (nowTrain == 1) {
                                        setState(() {
                                          soundPlayer(1, false);
                                          player[2].stop();
                                          trainPosition = trainPosition +
                                              470 +
                                              (addedTrain[1] * 93);
                                          nowTrain--;
                                        });
                                      } else if (nowTrain == 2) {
                                        setState(() {
                                          soundPlayer(1, false);
                                          player[3].stop();
                                          trainPosition = trainPosition +
                                              470 +
                                              (addedTrain[2] * 93);
                                          nowTrain--;
                                        });
                                      }
                                    } else
                                    if (dragEndDetails.primaryVelocity! <
                                        0.0) {
                                      if (nowTrain == 2) {} else
                                      if (nowTrain == 1) {
                                        setState(() {
                                          soundPlayer(1, false);
                                          player[2].stop();
                                          soundPlayer(3, true);
                                          trainPosition = trainPosition -
                                              470 -
                                              (addedTrain[2] * 93);
                                          nowTrain++;
                                        });
                                      } else if (nowTrain == 0) {
                                        setState(() {
                                          soundPlayer(1, false);
                                          // player[].stop();
                                          soundPlayer(2, true);
                                          trainPosition = trainPosition -
                                              470 -
                                              (addedTrain[1] * 93);
                                          nowTrain++;
                                        });
                                      }
                                      // setState(() {
                                      //   nowTrain++;
                                      //   trainPosition = trainPosition - 470;
                                      // });

                                    }
                                  },
                                  child: Transform(
                                    transform: transformTrain,
                                    child: TrainImage(
                                      positionNumber: positionNumber,
                                      addedTrain: addedTrain,
                                      pointing: pointing,
                                      getOffChild: pointChildRemove,
                                      visibilityOnOff: visibilityOnOff,
                                      trainLengthController:
                                      trainLengthController,
                                      trainPositionController:
                                      trainPositionController,
                                        trainGetOnSoundPlayer:trainGetOnSoundPlayer,
                                    ),
                                  ))),
                          for (int i = 0;
                          i <
                              Provider
                                  .of<AttiChildDataManagement>(context,
                                  listen: false)
                                  .childList
                                  .length;
                          i++) ...[
                            if (Provider
                                .of<SurveyDataManagement>(context,
                                listen: false)
                                .inClassNumber ==
                                i)
                              ...[]
                            else
                              ...[
                                BackGroundChild(
                                  positionNumber: positionNumber[i],
                                  inClassNumber: i,
                                  visibility: visibility[i],
                                  visibilityOnOff: visibilityOnOff,
                                  pointing: pointChild,
                                  nowTrain: nowTrain,
                                  trainLengthController: trainLengthController,
                                  trainPositionController:
                                  trainPositionController,
                                  trainList: pointing,
                                    trainGetOnSoundPlayer:trainGetOnSoundPlayer,
                                ),
                              ],
                          ],
                        ])),

                    for(int i = 0; i < touchBlockerInt; i++)...[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          color: Colors.transparent,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height,
                        ),
                      ),
                    ],
                    Positioned(
                        top: 10.w,
                        left: 10.w,
                        child: Visibility(
                          visible: backButtonVisibility,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                for(int i = 0; i < 6; i++){
                                  player[i].stop();
                                }
                                soundTimer[0].cancel();
                                soundTimer[1].cancel();
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Atti3()),
                              );
                            },
                            icon: SvgPicture.asset(
                              'assets/images/atti/atti_back.svg',
                            ),
                            iconSize: 50.w,
                            color: Color(0xffA666FC),
                          ),
                        )),
                    Positioned(
                        bottom: 20.w,
                        right: 20.w,
                        child: Visibility(
                          visible: startOn,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                for(int i = 0; i < 6; i++){
                                  player[i].stop();
                                }
                                soundTimer[0].cancel();
                                soundTimer[1].cancel();
                                soundPlayer(4, true);
                                endSurvey();
                              });
                            },
                            icon: Stack(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/atti/icon_atti_start.svg',
                                ),
                                Positioned(
                                    top: 10.w,
                                    left: 14.w,
                                    child: Text(
                                      '출발',
                                      style: TextStyle(
                                          fontFamily: "Nanum Pen Script",
                                          fontSize: 37.w,
                                          color: Colors.white),
                                    ))
                              ],
                            ),
                            iconSize: 70.w,
                            color: Color(0xffA666FC),
                          ),
                        )),
                  ]))
            ])));
  }
}



class BackGroundChild extends StatefulWidget {
  const BackGroundChild({
    Key? key,
    required this.inClassNumber,
    required this.visibility,
    required this.visibilityOnOff,
    required this.positionNumber,
    required this.pointing,
    required this.nowTrain,
    required this.trainLengthController,
    required this.trainPositionController,
    required this.trainList,
    required this.trainGetOnSoundPlayer,
  }) : super(key: key);
  final int positionNumber;
  final int inClassNumber;
  final bool visibility;
  final Function(int, bool) visibilityOnOff;
  final Function(int, int) pointing;
  final List<List<int>> trainList;
  final int nowTrain;
  final Function(int, int) trainLengthController;
  final Function(double) trainPositionController;
  final Function() trainGetOnSoundPlayer;

  @override
  State<BackGroundChild> createState() => _BackGroundChildState();
}

class _BackGroundChildState extends State<BackGroundChild> {
  List<String> imageUrl = [
    'assets/images/atti/child_type_01_01.svg',
    'assets/images/atti/child_type_01_02.svg',
  ];
  List<List<double>> childImageInfo = [
    [1050, 540],
    [800, 550],
    [550, 550],
    [400, 550],
    [200, 550],
    [300, 620],
    [700, 570],
    [950, 580],
    [80, 550],
    [20, 650],
    [800, 630],
    [1000, 740],
    [1100, 600],
    [150, 620],
    [400, 630],
    [500, 650],
    [600, 700],
    [920, 650],
    [680, 650],
    [240, 700],
    [80, 740],
    [750, 740],
    [400, 780],
    [650, 805],
    [250, 800],
    [900, 810],
    [1100, 800],
    [100, 820],
    [150, 850],
  ];

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: childImageInfo[widget.positionNumber][1].w,
        left: childImageInfo[widget.positionNumber][0].w,
        child: GestureDetector(
            onTap: () {
              setState(() {
                widget.trainGetOnSoundPlayer();
                widget.visibilityOnOff(
                    widget.inClassNumber, widget.visibility);
                widget.pointing(widget.nowTrain, widget.inClassNumber);
              });
              if (widget.trainList[widget.nowTrain].length == 12) {
                widget.trainLengthController(widget.nowTrain, 1);
                widget.trainPositionController(-93);
              }
              if (widget.trainList[widget.nowTrain].length == 15) {
                widget.trainLengthController(widget.nowTrain, 1);
                widget.trainPositionController(-93);
              }
              if (widget.trainList[widget.nowTrain].length == 18) {
                widget.trainLengthController(widget.nowTrain, 1);
                widget.trainPositionController(-93);
              }
              if (widget.trainList[widget.nowTrain].length == 21) {
                widget.trainLengthController(widget.nowTrain, 1);
                widget.trainPositionController(-93);
              }
              if (widget.trainList[widget.nowTrain].length == 24) {
                widget.trainLengthController(widget.nowTrain, 1);
                widget.trainPositionController(-93);
              }
            },
            child: Container(
              width: 120.w,
              height: 200.w,
              child: Stack(
                children: [
                  Positioned(
                      child: Visibility(
                          visible: widget.visibility,
                          child: ChildWithShadow(
                            childFace: Provider
                                .of<AttiChildDataManagement>(
                                context,
                                listen: false)
                                .childList[widget.inClassNumber]
                                .childFace,
                            imageType: widget.positionNumber % 2,
                          ))),
                ],
              ),
            )));
  }
}

class TrainImage extends StatefulWidget {
  const TrainImage({
    Key? key,
    required this.positionNumber,
    required this.addedTrain,
    required this.pointing,
    required this.getOffChild,
    required this.visibilityOnOff,
    required this.trainLengthController,
    required this.trainPositionController,
    required this.trainGetOnSoundPlayer,
  }) : super(key: key);
  final List<int> positionNumber;
  final List<List<int>> pointing;
  final List<int> addedTrain;
  final Function(int, int) getOffChild;
  final Function(int, bool) visibilityOnOff;
  final Function(int, int) trainLengthController;
  final Function(double) trainPositionController;
  final Function() trainGetOnSoundPlayer;

  @override
  State<TrainImage> createState() => _TrainImageState();
}

class _TrainImageState extends State<TrainImage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10000.w,
      height: 300.w,
      child: Stack(
        children: [
          Positioned(
            top: 65.w,
            child: SvgPicture.asset(
              'assets/images/atti/train_head.svg',
              width: 300.w,
            ),
          ),
          Positioned(
              width: 10000.w,
              height: 300.w,
              top: 0.w,
              left: 250.w,
              child: Stack(
                children: [
                  Container(
                    width: 10000.w,
                    height: 234.w,
                  ),
                  Positioned(
                      top: 147.w,
                      child: SvgPicture.asset(
                          'assets/images/atti/train_type_01_01_02.svg',
                          width: 132.5.w)),
                  Positioned(
                      left: 132.w,
                      top: 153.w,
                      child: SvgPicture.asset(
                        'assets/images/atti/train_type_01_02_02.svg',
                        width: 276.w,
                      )),
                  for (int i = 0; i < widget.addedTrain[0]; i++) ...[
                    Positioned(
                        left: (132 + (i + 1) * 93).w,
                        top: 153.w,
                        child: SvgPicture.asset(
                          'assets/images/atti/train_type_01_02_02.svg',
                          width: 276.w,
                        )),
                  ],
                  Positioned(
                      left: (355 + 93 * widget.addedTrain[0]).w,
                      top: 147.w,
                      child: SvgPicture.asset(
                        'assets/images/atti/train_type_01_03_02.svg',
                        width: 132.w,
                      )),
                  for (int i = 0; i < widget.pointing[0].length; i++) ...[
                    Positioned(
                        top: (20 + (i % 3 * 40)).w,
                        left: ((60 + i ~/ 3 * 120) - i * 15).w,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                             widget.trainGetOnSoundPlayer();
                            });

                            widget.visibilityOnOff(
                                widget.pointing[0][i], false);
                            widget.getOffChild(0, widget.pointing[0][i]);
                            if (widget.pointing[0].length == 11) {
                              widget.trainLengthController(0, -1);
                              widget.trainPositionController(93);
                            }
                            if (widget.pointing[0].length == 14) {
                              widget.trainLengthController(0, -1);
                              widget.trainPositionController(93);
                            }
                            if (widget.pointing[0].length == 17) {
                              widget.trainLengthController(0, -1);
                              widget.trainPositionController(93);
                            }
                            if (widget.pointing[0].length == 20) {
                              widget.trainLengthController(0, -1);
                              widget.trainPositionController(93);
                            }
                            if (widget.pointing[0].length == 23) {
                              widget.trainLengthController(0, -1);
                              widget.trainPositionController(93);
                            }
                          },
                          child: ChildWithShadow(
                            imageType: (widget.positionNumber[i] % 2),
                            childFace: Provider
                                .of<AttiChildDataManagement>(
                                context,
                                listen: false)
                                .childList[widget.pointing[0][i]]
                                .childFace,
                          ),
                        )),
                  ],
                  Positioned(
                      top: 147.w,
                      child: SvgPicture.asset(
                        'assets/images/atti/train_type_01_01_01.svg',
                        width: 132.5.w,
                      )),
                  Positioned(
                      left: 132.w,
                      top: 153.w,
                      child: SvgPicture.asset(
                        'assets/images/atti/train_type_01_02_01.svg',
                        width: 276.w,
                      )),
                  for (int i = 0; i < widget.addedTrain[0]; i++) ...[
                    Positioned(
                        left: (132 + (i + 1) * 93).w,
                        top: 153.w,
                        child: SvgPicture.asset(
                          'assets/images/atti/train_type_01_02_01.svg',
                          width: 276.w,
                        )),
                  ],
                  Positioned(
                      left: (355 + 93 * widget.addedTrain[0]).w,
                      top: 147.w,
                      child: SvgPicture.asset(
                        'assets/images/atti/train_type_01_03_01.svg',
                        width: 132.w,
                      )),
                ],
              )),
          Positioned(
              width: 10000.w,
              height: 300.w,
              top: 0.w,
              left: (720 + widget.addedTrain[0] * 93).w,
              child: Stack(
                children: [
                  Container(
                    width: 10000.w,
                    height: 234.w,
                  ),
                  Positioned(
                      top: 147.w,
                      child: SvgPicture.asset(
                          'assets/images/atti/train_type_02_01_02.svg',
                          width: 132.5.w)),
                  Positioned(
                      left: 132.w,
                      top: 153.w,
                      child: SvgPicture.asset(
                        'assets/images/atti/train_type_02_02_02.svg',
                        width: 276.w,
                      )),
                  for (int i = 0; i < widget.addedTrain[1]; i++) ...[
                    Positioned(
                        left: (132 + (i + 1) * 93).w,
                        top: 153.w,
                        child: SvgPicture.asset(
                          'assets/images/atti/train_type_02_02_02.svg',
                          width: 276.w,
                        )),
                  ],
                  Positioned(
                      left: (355 + 93 * widget.addedTrain[1]).w,
                      top: 147.w,
                      child: SvgPicture.asset(
                        'assets/images/atti/train_type_02_03_02.svg',
                        width: 132.w,
                      )),
                  for (int i = 0; i < widget.pointing[1].length; i++) ...[
                    Positioned(
                        top: (20 + (i % 3 * 40)).w,
                        left: ((60 + i ~/ 3 * 120) - i * 15).w,
                        child: GestureDetector(
                          onTap: () {
                            widget.visibilityOnOff(
                                widget.pointing[1][i], false);
                            widget.getOffChild(1, widget.pointing[1][i]);
                            if (widget.pointing[1].length == 11) {
                              widget.trainLengthController(1, -1);
                              widget.trainPositionController(93);
                            }
                            if (widget.pointing[1].length == 14) {
                              widget.trainLengthController(1, -1);
                              widget.trainPositionController(93);
                            }
                            if (widget.pointing[1].length == 17) {
                              widget.trainLengthController(1, -1);
                              widget.trainPositionController(93);
                            }
                            if (widget.pointing[1].length == 20) {
                              widget.trainLengthController(1, -1);
                              widget.trainPositionController(93);
                            }
                            if (widget.pointing[1].length == 23) {
                              widget.trainLengthController(1, -1);
                              widget.trainPositionController(93);
                            }
                          },


                          child: ChildWithShadow(
                            imageType: (widget.positionNumber[i] % 2),
                            childFace: Provider
                                .of<AttiChildDataManagement>(
                                context,
                                listen: false)
                                .childList[widget.pointing[1][i]]
                                .childFace,
                          ),
                        )),
                  ],
                  Positioned(
                      top: 147.w,
                      child: SvgPicture.asset(
                        'assets/images/atti/train_type_02_01_01.svg',
                        width: 132.5.w,
                      )),
                  Positioned(
                      left: 132.w,
                      top: 153.w,
                      child: SvgPicture.asset(
                        'assets/images/atti/train_type_02_02_01.svg',
                        width: 276.w,
                      )),
                  for (int i = 0; i < widget.addedTrain[1]; i++) ...[
                    Positioned(
                        left: (132 + (i + 1) * 93).w,
                        top: 153.w,
                        child: SvgPicture.asset(
                          'assets/images/atti/train_type_02_02_01.svg',
                          width: 276.w,
                        )),
                  ],
                  Positioned(
                      left: (355 + 93 * widget.addedTrain[1]).w,
                      top: 147.w,
                      child: SvgPicture.asset(
                        'assets/images/atti/train_type_02_03_01.svg',
                        width: 132.w,
                      )),
                ],
              )),
          Positioned(
              width: 10000.w,
              height: 300.w,
              top: 0.w,
              left:
              (1190 + widget.addedTrain[0] * 93 + widget.addedTrain[1] * 93)
                  .w,
              child: Stack(
                children: [
                  Container(
                    width: 10000.w,
                    height: 234.w,
                  ),
                  Positioned(
                      top: 147.w,
                      child: SvgPicture.asset(
                          'assets/images/atti/train_type_01_01_02.svg',
                          width: 132.5.w)),
                  Positioned(
                      left: 132.w,
                      top: 153.w,
                      child: SvgPicture.asset(
                        'assets/images/atti/train_type_01_02_02.svg',
                        width: 276.w,
                      )),
                  for (int i = 0; i < widget.addedTrain[2]; i++) ...[
                    Positioned(
                        left: (132 + (i + 1) * 93).w,
                        top: 153.w,
                        child: SvgPicture.asset(
                          'assets/images/atti/train_type_01_02_02.svg',
                          width: 276.w,
                        )),
                  ],
                  Positioned(
                      left: (355 + 93 * widget.addedTrain[2]).w,
                      top: 147.w,
                      child: SvgPicture.asset(
                        'assets/images/atti/train_type_01_03_02.svg',
                        width: 132.w,
                      )),
                  for (int i = 0; i < widget.pointing[2].length; i++) ...[
                    Positioned(
                        top: (20 + (i % 3 * 40)).w,
                        left: ((60 + i ~/ 3 * 120) - i * 15).w,
                        child: GestureDetector(
                          onTap: () {
                            widget.visibilityOnOff(
                                widget.pointing[2][i], false);
                            widget.getOffChild(2, widget.pointing[2][i]);
                            if (widget.pointing[2].length == 11) {
                              widget.trainLengthController(2, -1);
                              widget.trainPositionController(93);
                            }
                            if (widget.pointing[2].length == 14) {
                              widget.trainLengthController(2, -1);
                              widget.trainPositionController(93);
                            }
                            if (widget.pointing[2].length == 17) {
                              widget.trainLengthController(2, -1);
                              widget.trainPositionController(93);
                            }
                            if (widget.pointing[2].length == 20) {
                              widget.trainLengthController(2, -1);
                              widget.trainPositionController(93);
                            }
                            if (widget.pointing[2].length == 23) {
                              widget.trainLengthController(2, -1);
                              widget.trainPositionController(93);
                            }
                          },
                          child: ChildWithShadow(
                            imageType: (widget.positionNumber[i] % 2),
                            childFace: Provider
                                .of<AttiChildDataManagement>(
                                context,
                                listen: false)
                                .childList[widget.pointing[2][i]]
                                .childFace,
                          ),
                        )),
                  ],
                  Positioned(
                      top: 147.w,
                      child: SvgPicture.asset(
                        'assets/images/atti/train_type_01_01_01.svg',
                        width: 132.5.w,
                      )),
                  Positioned(
                      left: 132.w,
                      top: 153.w,
                      child: SvgPicture.asset(
                        'assets/images/atti/train_type_01_02_01.svg',
                        width: 276.w,
                      )),
                  for (int i = 0; i < widget.addedTrain[2]; i++) ...[
                    Positioned(
                        left: (132 + (i + 1) * 93).w,
                        top: 153.w,
                        child: SvgPicture.asset(
                          'assets/images/atti/train_type_01_02_01.svg',
                          width: 276.w,
                        )),
                  ],
                  Positioned(
                      left: (355 + 93 * widget.addedTrain[2]).w,
                      top: 147.w,
                      child: SvgPicture.asset(
                        'assets/images/atti/train_type_01_03_01.svg',
                        width: 132.w,
                      )),
                ],
              )),
          Positioned(
            top: 100.w,
            left: 135.w,
            child: WidgetMask(
                blendMode: BlendMode.srcATop,
                childSaveLayer: true,
                mask:
                Provider
                    .of<AttiChildDataManagement>(context, listen: false)
                    .childList[Provider
                    .of<SurveyDataManagement>(context,
                    listen: false)
                    .inClassNumber]
                    .childFace,
                child: Container(
                  width: 60.w,
                  height: 77.2.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class ChildWithShadow extends StatefulWidget {
  const ChildWithShadow({
    Key? key,
    required this.imageType,
    required this.childFace,
  }) : super(key: key);
  final int imageType;
  final Image childFace;

  @override
  State<ChildWithShadow> createState() => _ChildWithShadowState();
}

class _ChildWithShadowState extends State<ChildWithShadow> {
  List<String> imageAsset = [
    'assets/images/atti/child_type_01_01.svg',
    'assets/images/atti/child_type_01_02.svg'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 102.w,
      height: 167.w,
      child: Stack(
        children: [
          Positioned(
              top: 2.w,
              left: 2.w,
              child: SvgPicture.asset(
                imageAsset[widget.imageType],
                width: 102.w,
                color: Color((0x22000000)),
              )),
          Positioned(
              top: 4.w,
              left: 0.w,
              child: SvgPicture.asset(
                imageAsset[widget.imageType],
                width: 100.w,
              )),
          Positioned(
            top: 0.w,
            left: widget.imageType == 0 ? 20.w : 10.w,
            child: WidgetMask(
                blendMode: BlendMode.srcATop,
                childSaveLayer: true,
                mask: widget.childFace,
                child: Container(
                  width: 60.w,
                  height: 77.2.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
