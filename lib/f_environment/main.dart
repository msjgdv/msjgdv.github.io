import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:treasure_map/environment.dart';
import 'package:treasure_map/f_environment/widget/Info_page_widget.dart';
import 'package:treasure_map/f_environment/widget/classinfo_widget.dart';
import 'package:treasure_map/f_environment/widget/kinder_info_widget.dart';
import 'package:treasure_map/f_environment/widget/notice_widget.dart';
import 'package:treasure_map/f_environment/widget/teacher_info_widget.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:async';

class SmartInfoPanelMain extends StatefulWidget {
  const SmartInfoPanelMain({
    Key? key,
    required this.attendResponse,
    required this.envResponse,
    required this.mainDataResponse,
  }) : super(key: key);
  final dynamic envResponse;
  final dynamic attendResponse;
  final dynamic mainDataResponse;

  @override
  State<SmartInfoPanelMain> createState() => _SmartInfoPanelMainState();
}

class _SmartInfoPanelMainState extends State<SmartInfoPanelMain> {
  static final autoLoginStorage = FlutterSecureStorage();

  List<double> classGraphRate = [];
  List<double> childGraphRate = [];
  List<String> classGraphName = [];

  int childNumTotal = 0;
  int classNumTotal = 0;

  List<int> classCounts = [];
  List<int> childrenCounts = [];

  int nowPageNumber = 0;

  List<Widget> pages = [];

  Color weatherFontColorReal = Color(0xffa27258);
  Color weatherDataFontColorReal = Color(0xffc45d1a);

  double mainPageHeight = 1040.w;

  Widget myWidget = Container();
  int timerI = 1;

  Image? kinderImage;
  List<Image> floorImages = [];
  List<Image> directorImages = [];
  List<Image> teacherImages = [];
  List<Image> committees = [];

  List<List<Image>> classTeacherImage = [];
  List<List<Image>> classChildImage = [];
  List<String> classNameDeco = [];
  List<List<int>> classChildCounts = [];
  List<Image?> eventImage = [];
  List<Image?> infoImage = [];

  late Map<String, dynamic> attend;
  late Map<String, dynamic> env;
  late Map<String, dynamic> mainData;

  String weatherAssets = 'assets/images/borabora/airple_weather/no_weather_data.png';
  int nowTeacherIndex = 0;
  int nowClassIndex = 0;
  Image voidPage =
  Image.asset("assets/images/borabora/childlifedata/void_page.png");
  int infoPageNumber = 0;
  bool infoPage = false;
  int noticeCount = 0;

  Timer delayTimer = Timer(Duration(milliseconds: 1000), () {});
  Timer periodicTimer = Timer.periodic(const Duration(seconds: 200), (timer) {});

  ApiUrl apiUrl = ApiUrl();

  delayTimerController(int seconds, Function() function){
    delayTimer = Timer(Duration(seconds: seconds), () {
      setState(() {
        function();
      });
    });
  }

  noticeRouth(){
    if(infoPageNumber >= noticeCount){
     setState(() {
       infoPageNumber = 0;
       pageRouting();
     });
    }else{
          delayTimerController(15, (){infoPageNumber++; noticeRouth();});
          delayTimer;
    }
  }


  pageRouting() {
    setState(() {
      nowPageNumber++;
      if (nowPageNumber == 0) {
        mainPageHeight = 1040.w;
        myWidget = pages[nowPageNumber];
      }else if(nowPageNumber == 1){
        mainPageHeight = 891.w;
        myWidget = pages[nowPageNumber];
      }else if(nowPageNumber == 2){
        mainPageHeight = 1040.w;
        myWidget = pages[nowPageNumber];
      }else if(nowPageNumber == 3){
        mainPageHeight = 891.w;
        myWidget = pages[nowPageNumber];
      }else if(nowPageNumber == 4){
        infoPage = true;
        noticeRouth();
      }else if(nowPageNumber == 5){
        infoPage = false;
        nowPageNumber = 0;
        mainPageHeight = 1040.w;
        myWidget = pages[nowPageNumber];
      }
    });
  }

  //글씨색
  List<Color> weatherFontColor = [
    Color(0xffc45d1a),
    Color(0xff139894),
    Color(0xff7c546c),
    Color(0xff04acd1),
    Color(0xff1d74cc),
    Color(0xff5529a2),
    Color(0xffa27258),
    Color(0xff1864a3),
  ];
  List<Color> weatherDataFontColor = [
    Color(0xff42372c),
    Color(0xff39605f),
    Color(0xffffffff),
    Color(0xff2d3a44),
    Color(0xff2c3342),
    Color(0xffffffff),
    Color(0xfff45f1e),
    Color(0xff2f3846),
  ];
  List<Color> weatherDustEmotionColors = [
    Color(0xffB9221B),
    Color(0xff1362AC),
    Color(0xff196ABA),
    Color(0xff6D45DB),
    Color(0xffAF1D7E),
    Color(0xffFA7425),
    Color(0xff308885),
    Color(0xff3253AC),
  ];
  Color weatherDustEmotionColor = Colors.white;


  envData() {
    setState(() {
      weatherType = env["weatherType"];
      switch (weatherType) {
        case "해/구름":
          weatherAssets =
          'assets/images/borabora/airple_weather/sunny_cloudy.png';
          weatherFontColorReal = weatherFontColor[0];
          weatherDataFontColorReal = weatherDataFontColor[0];
          weatherDustEmotionColor = weatherDustEmotionColors[0];
          break;
        case "구름":
          weatherAssets = 'assets/images/borabora/airple_weather/cloudy.png';
          weatherFontColorReal = weatherFontColor[3];
          weatherDataFontColorReal = weatherDataFontColor[3];
          weatherDustEmotionColor = weatherDustEmotionColors[1];
          break;
        case "비":
          weatherAssets = 'assets/images/borabora/airple_weather/rain_only.png';
          weatherFontColorReal = weatherFontColor[4];
          weatherDataFontColorReal = weatherDataFontColor[4];
          weatherDustEmotionColor = weatherDustEmotionColors[2];
          break;
        case "눈":
          weatherAssets = 'assets/images/borabora/airple_weather/snow_only.png';
          weatherFontColorReal = weatherFontColor[5];
          weatherDataFontColorReal = weatherDataFontColor[5];
          weatherDustEmotionColor = weatherDustEmotionColors[3];
          break;
        case "눈/비":
          weatherAssets = 'assets/images/borabora/airple_weather/snow_rain.png';
          weatherFontColorReal = weatherFontColor[2];
          weatherDataFontColorReal = weatherDataFontColor[2];
          weatherDustEmotionColor = weatherDustEmotionColors[4];
          break;
        case "맑음":
          weatherAssets = 'assets/images/borabora/airple_weather/sunny.png';
          weatherFontColorReal = weatherFontColor[6];
          weatherDataFontColorReal = weatherDataFontColor[6];
          weatherDustEmotionColor = weatherDustEmotionColors[5];
          break;
        case "바람":
          weatherAssets = 'assets/images/borabora/airple_weather/wind.png';
          weatherFontColorReal = weatherFontColor[1];
          weatherDataFontColorReal = weatherDataFontColor[1];
          weatherDustEmotionColor = weatherDustEmotionColors[6];
          break;
        case "강한 비":
          weatherAssets = 'assets/images/borabora/airple_weather/heavyrain.png';
          weatherFontColorReal = weatherFontColor[7];
          weatherDataFontColorReal = weatherDataFontColor[7];
          weatherDustEmotionColor = weatherDustEmotionColors[7];
          break;


      }
    });

  }

  baseData() async {
    final token = await autoLoginStorage.read(key: "signInToken");
    Map<String, String> headers = new Map();
    headers['authorization'] = token!;

    if(mainData["kindergarten"]["imagePath"] == ''){
      kinderImage = null;
    }else{
      kinderImage = await imageApi(mainData["kindergarten"]["imagePath"], 'signInToken', context);
    }


    for (int i = 0; i < mainData["kindergarten"]["floorPlan"].length; i++) {
      floorImages.add(await imageApi(mainData["kindergarten"]["floorPlan"][i], 'signInToken', context)
    );
    }
    List<int> classNumEach =
        mainData["kindergarten"]["classCounts"].cast<int>();
    List<int> childNumEach =
        mainData["kindergarten"]["childrenCounts"].cast<int>();

    for (int i = 0; i < mainData["kindergarten"]["classAges"].length; i++) {
      //총 학급수 계산
      classNumTotal += classNumEach[i];
      childNumTotal += childNumEach[i];
    }
    for (int i = 0; i < mainData["kindergarten"]["classAges"].length; i++) {
      //그래프 비율 계산
      classGraphRate.add(classNumEach[i] / classNumTotal);
      childGraphRate.add(childNumEach[i] / childNumTotal);
    }
    for (int i = 0; i < mainData["directors"].length; i++) {
      directorImages.add(await imageApi(mainData["directors"][i]["imagePath"], 'signInToken', context)
    );
    }
    for (int i = 0; i < mainData["teachers"].length; i++) {
      teacherImages.add(await imageApi(mainData["teachers"][i]["imagePath"], 'signInToken', context)
    );
    }

    for (int i = 0; i < mainData["committees"].length; i++) {
      committees.add(await imageApi(mainData["committees"][i]["imagePath"], 'signInToken', context)
    );
    }

    for (int i = 0; i < mainData["classInfo"].length; i++) {
      classTeacherImage.add([]);
      classChildImage.add([]);
      classChildCounts.add([]);

      for (int j = 0; j < mainData["classInfo"][i]["teachers"].length; j++) {
        classTeacherImage[i].add(await imageApi(mainData["classInfo"][i]["teachers"][j]["imagePath"], 'signInToken', context)
    );
      }
      int maleChild = 0;
      int femaleChild = 0;
      for (int j = 0; j < mainData["classInfo"][i]["children"].length; j++) {
        classChildImage[i].add(await imageApi(mainData["classInfo"][i]["children"][j]["imagePath"], 'signInToken', context)
    );

        if (mainData["classInfo"][i]["children"][j]["sex"] == true) {
          maleChild++;
        } else {
          femaleChild++;
        }
      }
      classChildCounts[i].add(mainData["classInfo"][i]["children"].length);
      classChildCounts[i].add(maleChild);
      classChildCounts[i].add(femaleChild);

      for (int j = 0; j < mainData["classInfo"][i]["age"].length; j++) {
        switch (mainData["classInfo"][i]["age"]) {
          case "만0세반":
          case "만0~1세반":
          case "만0~2세반":
          case "만0~3세반":
          case "만0~4세반":
          case "만0~5세반":
            classNameDeco
                .add('assets/images/borabora/class_info_deco/0class.png');
            break;
          case "만1세반":
          case "만1~2세반":
          case "만1~3세반":
          case "만1~4세반":
          case "만1~5세반":
            classNameDeco
                .add('assets/images/borabora/class_info_deco/1class.png');
            break;
          case "만2세반":
          case "만2~3세반":
          case "만2~4세반":
          case "만2~5세반":
            classNameDeco
                .add('assets/images/borabora/class_info_deco/2class.png');
            break;
          case "만3세반":
          case "만3~4세반":
          case "만3~5세반":
            classNameDeco
                .add('assets/images/borabora/class_info_deco/3class.png');
            break;
          case "만4세반":
          case "만4~5세반":
            classNameDeco
                .add('assets/images/borabora/class_info_deco/4class.png');
            break;
          case "만5세반":
            classNameDeco
                .add('assets/images/borabora/class_info_deco/5class.png');
            break;
          default:
            break;
        }
      }
    }
    int j =0;
    infoImage.clear();

    noticeCount =mainData["notices"]["noticePathNumbers"].length == 0 ? 0 : (mainData["notices"]["noticePathNumbers"].last/3).ceil();

      for (int i = 0;i <30; i++) {
        if (mainData["notices"]["noticePathNumbers"].contains(i+1)) {
          infoImage.add(await imageApi(mainData["notices"]["noticePaths"][j], 'signInToken', context)
          );
          j++;
        } else {
          infoImage.add(null);
        }
      }

    j=0;

    for(int i = 0; i< 8;i++){
      if (mainData['news']['eventImageNumbers'].contains(i+1)) {
        eventImage.add(await imageApi(mainData['news']["eventImagePaths"][j], 'signInToken', context)
        );
        j++;
      } else {
        eventImage.add(null);
      }
    }
    setState(() {
    });
  }



  rotateClass(int key) {
    setState(() {
      if (key == 0) {
        nowClassIndex++;
        if (nowClassIndex > mainData["classInfo"].length - 1) {
          nowClassIndex = 0;
        }
      }
      if (key == 1) {
        nowTeacherIndex++;
        if (nowTeacherIndex > mainData["teachers"].length - 1) {
          nowTeacherIndex = 0;
        }
      }
    });
  }

  startLoading() async{
    await baseData();
    // await envData();
    pages = [
      KinderInfoWidget(
          data: mainData,
          kindergartenImage: kinderImage,
          classGraphRate: classGraphRate,
          childGraphRate: childGraphRate,
          floorImage: floorImages,nextPage: pageRouting,
      timer: delayTimer,
      delayTimer: delayTimerController,
      ),
      TeacherInfoWidget(
          data: mainData,
          committeesImage: committees,
          directorImage: directorImages,
          teacherImage: teacherImages,nextPage: pageRouting,
        timer: delayTimer,
        delayTimer: delayTimerController,),
      ClassInfoWidget(
          classChildImage: classChildImage,
          classTeacherImage: classTeacherImage,
          classNameDeco: classNameDeco,
          data: mainData,
          classChildCount: classChildCounts,
          rotateClass: rotateClass,nextPage: pageRouting,
        timer: delayTimer,
        delayTimer: delayTimerController,),
      NoticeWidget(
        data: mainData, eventImage: eventImage,
      nextPage: pageRouting,
        timer: delayTimer,
        delayTimer: delayTimerController,),
    ];
    setState(() {
      mainPageHeight = 1040.w;
      myWidget = pages[0];
    });
  }

  List<String> pmMessage = ['좋음', '보통', '나쁨', '매우나쁨'];
  String sensorPm25 = '';
  String sensorPm10 = '';
  String weatherPm25 = '';
  String weatherPm10 = '';

  @override
  void initState() {

    attend = Map<String, dynamic>.from(widget.attendResponse);
    env = Map<String, dynamic>.from(widget.envResponse);
    mainData = Map<String, dynamic>.from(widget.mainDataResponse);
    envData();
    if(double.parse(env['sensorPm10'][0]) <30){
      sensorPm10 = pmMessage[0];
    }else if(double.parse(env['sensorPm10'][0]) <80){
      sensorPm10 = pmMessage[1];
    }else if(double.parse(env['sensorPm10'][0]) <150){
      sensorPm10 = pmMessage[2];
    }else if(double.parse(env['sensorPm10'][0]) >150){
      sensorPm10 = pmMessage[3];
    }
    if(double.parse(env['sensorPm25'][0]) <15){
      sensorPm25 = pmMessage[0];
    }else if(double.parse(env['sensorPm25'][0]) <35){
      sensorPm25 = pmMessage[1];
    }else if(double.parse(env['sensorPm25'][0]) <75){
      sensorPm25 = pmMessage[2];
    }else if(double.parse(env['sensorPm25'][0]) >75){
      sensorPm25 = pmMessage[3];
    }
    if(env['weatherPm25'][0]=='-'){
      weatherType = '-';
    }else {
      if (double.parse(env['weatherPm25'][0]) < 15) {
        weatherPm25 = pmMessage[0];
      } else if (double.parse(env['weatherPm25'][0]) < 35) {
        weatherPm25 = pmMessage[1];
      } else if (double.parse(env['weatherPm25'][0]) < 75) {
        weatherPm25 = pmMessage[2];
      } else if (double.parse(env['weatherPm25'][0]) > 75) {
        weatherPm25 = pmMessage[3];
      }
      if (double.parse(env['weatherPm10'][0]) < 30) {
        weatherPm10 = pmMessage[0];
      } else if (double.parse(env['weatherPm10'][0]) < 80) {
        weatherPm10 = pmMessage[1];
      } else if (double.parse(env['weatherPm10'][0]) < 150) {
        weatherPm10 = pmMessage[2];
      } else if (double.parse(env['weatherPm10'][0]) > 150) {
        weatherPm10 = pmMessage[3];
      }
    }


    periodicTimer = Timer.periodic(const Duration(seconds: 300), (timer) {
      attend = Map<String, dynamic>.from(widget.attendResponse);
      if(Map<String, dynamic>.from(widget.envResponse)['weatherType']=='-'){
      }else{
        env = Map<String, dynamic>.from(widget.envResponse);

        if(double.parse(env['sensorPm10'][0]) <30){
          sensorPm10 = pmMessage[0];
        }else if(double.parse(env['sensorPm10'][0]) <80){
          sensorPm10 = pmMessage[1];
        }else if(double.parse(env['sensorPm10'][0]) <150){
          sensorPm10 = pmMessage[2];
        }else if(double.parse(env['sensorPm10'][0]) >150){
          sensorPm10 = pmMessage[3];
        }
        if(double.parse(env['sensorPm25'][0]) <15){
          sensorPm25 = pmMessage[0];
        }else if(double.parse(env['sensorPm25'][0]) <35){
          sensorPm25 = pmMessage[1];
        }else if(double.parse(env['sensorPm25'][0]) <75){
          sensorPm25 = pmMessage[2];
        }else if(double.parse(env['sensorPm25'][0]) >75){
          sensorPm25 = pmMessage[3];
        }
        if(double.parse(env['weatherPm25'][0]) <15){
          weatherPm25 = pmMessage[0];
        }else if(double.parse(env['weatherPm25'][0]) <35){
          weatherPm25 = pmMessage[1];
        }else if(double.parse(env['weatherPm25'][0]) <75){
          weatherPm25 = pmMessage[2];
        }else if(double.parse(env['weatherPm25'][0]) >75){
          weatherPm25 = pmMessage[3];
        }
        if(double.parse(env['weatherPm10'][0]) <30){
          weatherPm10 = pmMessage[0];
        }else if(double.parse(env['weatherPm10'][0]) <80){
          weatherPm10 = pmMessage[1];
        }else if(double.parse(env['weatherPm10'][0]) <150){
          weatherPm10 = pmMessage[2];
        }else if(double.parse(env['weatherPm10'][0]) >150){
          weatherPm10 = pmMessage[3];
        }
      }

    });
    mainData["news"]["classesSpecialDays"];
    periodicTimer;
    startLoading();
    super.initState();
  }
  String weatherType = '';
  // String weatherTemperature = '';
  //
  // String weatherHumidity = '';
  // String weatherPm10 = '';
  // String weatherPm25 = '';
  // var sensorLocation = '';
  // var sensorTemperature = '';
  // var sensorHumidity = '';
  // var sensorPm25 = '';
  // var sensorPm10 = '';
  // var sensorCo2 = '';
  // var sensorTvoc = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          delayTimer.cancel();
          periodicTimer.cancel();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IEnvironment()),
          );
          // tapPage();
        },
        child: Stack(
          children: [
            Positioned(
              top: (-((1080 / 2) - (1080 * (1240 / 1920)) / 2)).w,
              left: (-((1920 / 2) - (1920 * (1240 / 1920)) / 2)).w,
              child: Transform.scale(
                scale: 1240 / 1920,
                child: infoPage
                    ? Container(
                        width: 1920.w,
                        height: 1080.w,
                        color: Color(0xffEFFFFE),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 127.w,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                for (int i = 0; i < 3; i++) ...[
                                  infoImage[infoPageNumber * 3 + i] == null
                                      ? Container(
                                    width: 581.29.w,
                                    height: 824.87.w,
                                    child:Stack(
                                      children: [
                                        Positioned(
                                            top: 25.79.w,
                                            left: 8.14.w,
                                            child: Container(
                                              width: 565.01.w,
                                              height: 799.08.w,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(0x29b1b1b1),
                                                    offset: Offset(-2.w, 2.w),
                                                    blurRadius: 6.w,
                                                  ),
                                                ],
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        20.w)),
                                              ),
                                            )),
                                        Container(
                                          width: 581.29.w,
                                          height: 824.87.w,
                                          child: SvgPicture.asset(
                                            'assets/images/borabora/childlifedata/info_page_deco.svg',
                                            height: 32.w,
                                            width: 32.w,
                                          ),
                                        )
                                      ],
                                    ),

                                  )
                                      : Container(
                                    width: 581.29.w,
                                    height: 824.87.w,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                            top: 25.79.w,
                                            left: 8.14.w,
                                            child: Container(
                                              width: 565.w,
                                              height: 800.w,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        20.w)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color(0x29b1b1b1),
                                                    offset: Offset(-2.w, 2.w),
                                                    blurRadius: 6.w,
                                                  ),
                                                ],
                                              ),

                                              child: Padding(
                                                padding: EdgeInsets.all(20.w),
                                                child: WidgetMask(
                                                  blendMode: BlendMode.srcATop,
                                                  childSaveLayer: true,
                                                  mask: infoImage[infoPageNumber * 3 + i]!,
                                                  child: Container(

                                                    width: 565.01.w,
                                                    height: 799.08.w,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20.w)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )),
                                        Container(
                                          width: 581.29.w,
                                          height: 824.87.w,
                                          child: SvgPicture.asset(
                                            'assets/images/borabora/childlifedata/info_page_deco.svg',
                                            height: 32.w,
                                            width: 32.w,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ]
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: 1920.w,
                        height: 1080.w,
                        decoration: const BoxDecoration(
                          color: Color(0xffCEF5F3),
                        ),
                        child: Stack(
                          children: [
                            ///공기질
                            if(weatherType == '-')...[
                              Positioned(
                                  bottom: 0.w,
                                  right: 0.w,
                                  child: Container(
                                width: 905.w,
                                height: 596.w,
                                // margin:
                                //     EdgeInsets.only(right: 18.w, bottom: 16.w,left: 20.w),
                                decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.all(Radius.circular(20.w)),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('assets/images/borabora/airple_weather/no_weather_data.png'),
                                    )),))
                            ]else...[
                              Positioned(
                                bottom: 20.w,
                                right: 20.w,
                                child: Container(
                                  width: 820.w,
                                  height: 515.w,
                                  // margin:
                                  //     EdgeInsets.only(right: 18.w, bottom: 16.w,left: 20.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20.w)),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: weatherType == '-' ? AssetImage('assets/images/borabora/airple_weather/no_weather_data.png'): AssetImage(weatherAssets),
                                      )),
                                  child: Stack(
                                    children: [
                                      if(weatherType != '-')...[
                                        Positioned(
                                          top: 98.w,
                                          left: 428.w,
                                          child:
                                          AirData(
                                            name: '온도',
                                            data: env['weatherTemperature'][0] +'도',
                                            data2: env['sensorTemperature'][0] +'도',
                                            nameColor: weatherFontColorReal,
                                            dataColor: weatherDataFontColorReal,
                                            emotionColor: weatherDustEmotionColor,
                                          ),
                                        ),
                                        Positioned(
                                          top: 185.w,
                                          left: 428.w,
                                          child:   AirData(
                                            name: '습도',
                                            data: env['weatherHumidity'][0] +'%',
                                            data2: env['sensorHumidity'][0] +'%',
                                            nameColor: weatherFontColorReal,
                                            dataColor: weatherDataFontColorReal,
                                            emotionColor: weatherDustEmotionColor,
                                          ),  ),
                                        Positioned(
                                          top: 260.w,
                                          left: 428.w,
                                          child: AirData(
                                            name: 'CO2',
                                            data: 'ㆍ',
                                            data2: env['sensorTvoc'][0] + 'ppm',
                                            nameColor: weatherFontColorReal,
                                            dataColor: weatherDataFontColorReal,
                                            emotionColor: weatherDustEmotionColor,
                                          ),
                                        ),
                                        Positioned(
                                          top: 345.w,
                                          left: 428.w,
                                          child:
                                          AirData(
                                            name: '미세먼지',
                                            data: weatherPm10,
                                            data2: sensorPm10,
                                            nameColor: weatherFontColorReal,
                                            dataColor: weatherDataFontColorReal,
                                            emotionColor: weatherDustEmotionColor,
                                          ),
                                        ),
                                        Positioned(
                                          top: 425.w,
                                          left: 428.w,
                                          child: AirData(
                                            name: '초미세먼지',
                                            data: weatherPm25,
                                            data2: sensorPm25,
                                            nameColor: weatherFontColorReal,
                                            dataColor: weatherDataFontColorReal,
                                            emotionColor: weatherDustEmotionColor,
                                          ),),

                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 560.w,
                                            ),
                                            Container(
                                              child: Text(
                                                  '실외',
                                                  style: TextStyle(
                                                    fontFamily: 'GamjaFlower',
                                                    color:
                                                    weatherFontColorReal,
                                                    fontSize: 40.sp,
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                  )),
                                              margin: EdgeInsets.only(
                                                  top: 35.w),
                                            ),
                                            SizedBox(
                                              width: 87.w,
                                            ),
                                            Container(
                                              child: Text(
                                                  '실내',
                                                  style: TextStyle(
                                                    fontFamily: 'GamjaFlower',
                                                    color:
                                                    weatherFontColorReal,
                                                    fontSize: 40.sp,
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                  )),
                                              margin: EdgeInsets.only(
                                                  top: 35.w),
                                            ),

                                          ],
                                        ),
                                      ]

                                    ],
                                  ),
                                ),
                              ),
                            ],
                            // Positioned(
                            //   bottom: 20.w,
                            //   right: 20.w,
                            //   child: Container(
                            //     width: 820.w,
                            //     height: 515.w,
                            //     // margin:
                            //     //     EdgeInsets.only(right: 18.w, bottom: 16.w,left: 20.w),
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.all(Radius.circular(20.w)),
                            //         image: DecorationImage(
                            //           fit: BoxFit.cover,
                            //           image: weatherType == '-' ? AssetImage('assets/images/borabora/airple_weather/no_weather_data.png'): AssetImage(weatherAssets),
                            //         )),
                            //     child: Stack(
                            //       children: [
                            //         if(weatherType != '-')...[
                            //           Positioned(
                            //             top: 98.w,
                            //             left: 428.w,
                            //             child:
                            //             AirData(
                            //               name: '온도',
                            //               data: env['weatherTemperature'][0] +'도',
                            //               data2: env['sensorTemperature'][0] +'도',
                            //               nameColor: weatherFontColorReal,
                            //               dataColor: weatherDataFontColorReal,
                            //               emotionColor: weatherDustEmotionColor,
                            //             ),
                            //           ),
                            //           Positioned(
                            //             top: 185.w,
                            //             left: 428.w,
                            //             child:   AirData(
                            //               name: '습도',
                            //               data: env['weatherHumidity'][0] +'%',
                            //               data2: env['sensorHumidity'][0] +'%',
                            //               nameColor: weatherFontColorReal,
                            //               dataColor: weatherDataFontColorReal,
                            //               emotionColor: weatherDustEmotionColor,
                            //             ),  ),
                            //           Positioned(
                            //             top: 260.w,
                            //             left: 428.w,
                            //             child: AirData(
                            //               name: 'CO2',
                            //               data: 'ㆍ',
                            //               data2: env['sensorTvoc'][0] + 'ppm',
                            //               nameColor: weatherFontColorReal,
                            //               dataColor: weatherDataFontColorReal,
                            //               emotionColor: weatherDustEmotionColor,
                            //             ),
                            //           ),
                            //           Positioned(
                            //             top: 345.w,
                            //             left: 428.w,
                            //             child:
                            //             AirData(
                            //               name: '미세먼지',
                            //               data: weatherPm10,
                            //               data2: sensorPm10,
                            //               nameColor: weatherFontColorReal,
                            //               dataColor: weatherDataFontColorReal,
                            //               emotionColor: weatherDustEmotionColor,
                            //             ),
                            //           ),
                            //           Positioned(
                            //             top: 425.w,
                            //             left: 428.w,
                            //             child: AirData(
                            //               name: '초미세먼지',
                            //               data: weatherPm25,
                            //               data2: sensorPm25,
                            //               nameColor: weatherFontColorReal,
                            //               dataColor: weatherDataFontColorReal,
                            //               emotionColor: weatherDustEmotionColor,
                            //             ),),
                            //
                            //           Row(
                            //             children: [
                            //               SizedBox(
                            //                 width: 560.w,
                            //               ),
                            //               Container(
                            //                 child: Text(
                            //                     '실외',
                            //                     style: TextStyle(
                            //                       fontFamily: 'GamjaFlower',
                            //                       color:
                            //                       weatherFontColorReal,
                            //                       fontSize: 40.sp,
                            //                       fontWeight: FontWeight.w400,
                            //                       fontStyle: FontStyle.normal,
                            //                     )),
                            //                 margin: EdgeInsets.only(
                            //                     top: 35.w),
                            //               ),
                            //               SizedBox(
                            //                 width: 87.w,
                            //               ),
                            //               Container(
                            //                 child: Text(
                            //                     '실내',
                            //                     style: TextStyle(
                            //                       fontFamily: 'GamjaFlower',
                            //                       color:
                            //                       weatherFontColorReal,
                            //                       fontSize: 40.sp,
                            //                       fontWeight: FontWeight.w400,
                            //                       fontStyle: FontStyle.normal,
                            //                     )),
                            //                 margin: EdgeInsets.only(
                            //                     top: 35.w),
                            //               ),
                            //
                            //             ],
                            //           ),
                            //         ]
                            //
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            Positioned(
                              top: 20.w,
                              left: 20.w,
                              bottom: 20.w,

                              child: Column(
                                children: [
                                  Container(
                                      width: 1040.w,
                                      height: mainPageHeight,
                                      // margin:
                                      //     EdgeInsets.only(left: 20.w, top: 20.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: const Color(0x6663e6d7),
                                          width: 1.w,
                                        ),
                                        borderRadius: BorderRadius.circular(20.w),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0x29b1b1b1),
                                            offset: Offset(-2.w, 2.w),
                                            blurRadius: 6.w,
                                            spreadRadius: 0.w,
                                          ),
                                          BoxShadow(
                                            color: const Color(0x29dbdbdb),
                                            offset: Offset(-2.w, -4.w),
                                            blurRadius: 6.w,
                                            spreadRadius: 0.w,
                                          ),
                                        ],
                                      ),

                                      ///<각 페이지의 왼쪽 위젯이 들어갈 자리입니다, widgetleft
                                      child: myWidget

                                      ///각 페이지의 왼쪽 위젯이 들어갈 자리입니다>
                                      ),
                                  if (mainPageHeight < 1000.w) ...[
                                    SizedBox(
                                      height: 20.w,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Container(
                                          width: 1047.w,
                                          height: 129.w,
                                          color: Colors.white,
                                          // decoration: BoxDecoration(
                                          //     // border: Border.all(
                                          //     //     color: Color(0xff707070),
                                          //     //     width: 1)
                                          // ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '(주)아이좋아',
                                                style: TextStyle(
                                                  color: Color(0xff393838),
                                                  fontSize: 21.sp,

                                                ),
                                              ),
                                              SizedBox(
                                                width: 20.w,
                                              ),
                                              SvgPicture.asset('assets/icons/icon_aijoa_logo_yellow.svg',
                                              height: 57.w,),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    // SizedBox(
                                    //   height: 20.w,
                                    // ),
                                  ],
                                  // SizedBox(
                                  //   height: 20.w,
                                  // ),
                                ],

                              ),
                            ),

                            /// 등원유아 수, 공기질
                            /// 가로그래프의 경우 아시다시피 세로그래프를 => 가로그래프 로 회전시킨거라
                            /// 가로그래프의 길이(width)를 넓힐 경우 => 해당 구역의 height가 늘어나 밑에 overflow가 발생합니다
                            /// 이는 차후에 수정해 나가야 할 듯 싶습니다.
                            Positioned(
                              top: 20.w,
                              right: 20.w,
                              child: Container(
                                width: 818.w,
                                height: 514.w,
                                // margin:
                                //     EdgeInsets.only(left: 20.w,right: 20.w, top: 20.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.w)),
                                    border: Border.all(
                                        color: const Color(0x6663e6d7),
                                        width: 1),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Color(0x29b1b1b1),
                                          offset: Offset(-2, 2),
                                          blurRadius: 6,
                                          spreadRadius: 0),
                                      BoxShadow(
                                          color: Color(0x29dbdbdb),
                                          offset: Offset(-2, -4),
                                          blurRadius: 6,
                                          spreadRadius: 0)
                                    ],
                                    color: const Color(0xffffffff)),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 40.w, top: 40.w),
                                      child: Text(
                                        '등원유아 수',
                                        style: TextStyle(
                                          color: const Color(0xff39605f),
                                          fontSize: 20.sp,
                                          fontFamily: 'NotoSansKR',
                                          fontWeight: FontWeight.w700,
                                        ),
                                        strutStyle: StrutStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w700,
                                          forceStrutHeight: true,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        ///남아
                                        Column(
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 182.w,
                                                height: 110.w,
                                                margin: EdgeInsets.only(
                                                    left: 26.w, top: 16.w),
                                                decoration:
                                                    const BoxDecoration(
                                                        image:
                                                            DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                    'assets/childlifedata/02_3.jpg',
                                                  ),
                                                )),
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 130.w, top: 60.w),
                                                  child: Text("남아",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'GamjaFlower',
                                                        color: const Color(
                                                            0xff39605f),
                                                        fontSize: 30.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                      )),
                                                )),
                                            Container(
                                                width: 336.w,
                                                height: 20.w,
                                                margin: EdgeInsets.only(
                                                    left: 40.w),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Color(0x4d63e66d),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          Color(0x33adadad),
                                                      offset: Offset(1, 1),
                                                      blurRadius: 1,
                                                      spreadRadius: 0,
                                                    ),
                                                  ],
                                                ),
                                                child: Container(
                                                  width: (336 *
                                                          attend["maleRate"]
                                                              .toDouble())
                                                      .w,
                                                  height: 20.w,
                                                  margin: EdgeInsets.only(
                                                      right: (336 -
                                                              336 *
                                                                  attend["maleRate"]
                                                                      .toDouble())
                                                          .w),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.w),
                                                    color: const Color(
                                                        0x4d63e66d),
                                                  ),
                                                  child: Text(
                                                    (100 *
                                                                attend["maleRate"]
                                                                    .toDouble())
                                                            .toStringAsFixed(
                                                                1) +
                                                        "%",
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color:
                                                          Color(0xFF393838),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          "NotoSansKR",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                    textAlign:
                                                        TextAlign.right,
                                                  ),
                                                )
                                                //남아
                                                )
                                          ],
                                        ),

                                        ///남아
                                        SizedBox(width: 50.w),

                                        ///여아
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                    width: 182.w,
                                                    height: 110.w,
                                                    margin: EdgeInsets.only(
                                                        top: 16.w),
                                                    decoration:
                                                        const BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          'assets/childlifedata/02_4.jpg'),
                                                    )),
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 130.w,
                                                          top: 60.w),
                                                      child: Text("여아",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'GamjaFlower',
                                                            color: const Color(
                                                                0xff39605f),
                                                            fontSize: 30.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                            fontStyle:
                                                                FontStyle
                                                                    .normal,
                                                          )),
                                                    )),
                                              ],
                                            ),
                                            Container(
                                                width: 336.w,
                                                height: 20.w,
                                                margin: EdgeInsets.only(
                                                    left: 20.w),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Color(0x4de66363),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          Color(0x33adadad),
                                                      offset: Offset(1, 1),
                                                      blurRadius: 1,
                                                      spreadRadius: 0,
                                                    ),
                                                  ],
                                                ),
                                                child: Container(
                                                  // width: 336.w,
                                                  height: 20.w,
                                                  margin: EdgeInsets.only(
                                                      right: (336 -
                                                              336 *
                                                                  attend["femaleRate"]
                                                                      .toDouble())
                                                          .w),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(18.w),
                                                      color: const Color(
                                                          0xffffc9c9)),
                                                  child: Text(
                                                    (100 *
                                                                attend["femaleRate"]
                                                                    .toDouble())
                                                            .toStringAsFixed(
                                                                1) +
                                                        "%",
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color:
                                                          Color(0xFF393838),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          "NotoSansKR",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                    textAlign:
                                                        TextAlign.right,
                                                  ),
                                                ))
                                          ],
                                        )

                                        ///여아
                                      ],
                                    ),

                                    ///학급별그래프
                                    Container(
                                        width: 70.w,
                                        height: 29.w,
                                        margin: EdgeInsets.only(
                                            left: 40.w, top: 40.w),
                                        child: // 학급별
                                            Text("학급별",
                                                style: TextStyle(
                                                    color: Color(0xff39605f),
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    fontFamily: "NotoSansKR",
                                                    fontStyle:
                                                        FontStyle.normal,
                                                    fontSize: 20.sp),
                                                textAlign: TextAlign.left)),
                                    Container(
                                        width: 748.w,
                                        height: 180.w,
                                        margin: EdgeInsets.only(
                                            left: 40.w, top: 20.w),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            // crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              for (int i = 0;
                                                  i <
                                                      attend["rateByClass"]
                                                          .length;
                                                  i++) ...[
                                                Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.only(
                                                                bottom: 2.w),
                                                        child: Text(
                                                            (100 * attend["rateByClass"][i].toDouble())
                                                                    .toStringAsFixed(
                                                                        1) +
                                                                "%",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'NotoSansKR',
                                                              color: Color(
                                                                  0xff393838),
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                            )),
                                                      ),
                                                      Container(
                                                          width: 20.w,
                                                          height: (125.0 *
                                                                  attend["rateByClass"]
                                                                          [i]
                                                                      .toDouble())
                                                              .w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xffc7f7f5),
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        10.w),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10.w)),
                                                          )),
                                                      Container(
                                                          width: 74.8.w,
                                                          height: 3.w,
                                                          // margin: EdgeInsets.only(left: 40.w),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Color(
                                                                      0xff63e6d7))),
                                                      SizedBox(
                                                        height: 30.w,
                                                        child: Center(
                                                          child: Text(
                                                              attend["classList"]
                                                                      [i]
                                                                  .toString(),
                                                              style:
                                                                  TextStyle(

                                                                color: Color(
                                                                    0xff000000),
                                                                fontSize:
                                                                    14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                              )),
                                                        ),
                                                      )
                                                    ]),
                                              ]
                                            ])),

                                    ///학급별그래프
                                  ],
                                ),

                                ///등원유아 수
                              ),
                            ),

                            // SizedBox(
                            //   height: 12.w,
                            // ),

                            // ///공기질
                            // Positioned(
                            //   bottom: 20.w,
                            //   right: 20.w,
                            //   child: Container(
                            //     width: 820.w,
                            //     height: 515.w,
                            //     // margin:
                            //     //     EdgeInsets.only(right: 18.w, bottom: 16.w,left: 20.w),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.all(Radius.circular(20.w)),
                            //         image: DecorationImage(
                            //       fit: BoxFit.cover,
                            //       image: weatherType == '-' ? AssetImage('assets/images/borabora/airple_weather/no_weather_data.png'): AssetImage(weatherAssets),
                            //     )),
                            //     child: Stack(
                            //       children: [
                            //         if(weatherType != '-')...[
                            //           Positioned(
                            //             top: 98.w,
                            //             left: 428.w,
                            //             child:
                            //             AirData(
                            //               name: '온도',
                            //               data: env['weatherTemperature'][0] +'도',
                            //               data2: env['sensorTemperature'][0] +'도',
                            //               nameColor: weatherFontColorReal,
                            //               dataColor: weatherDataFontColorReal,
                            //               emotionColor: weatherDustEmotionColor,
                            //             ),
                            //           ),
                            //           Positioned(
                            //             top: 185.w,
                            //             left: 428.w,
                            //             child:   AirData(
                            //               name: '습도',
                            //               data: env['weatherHumidity'][0] +'%',
                            //               data2: env['sensorHumidity'][0] +'%',
                            //               nameColor: weatherFontColorReal,
                            //               dataColor: weatherDataFontColorReal,
                            //               emotionColor: weatherDustEmotionColor,
                            //             ),  ),
                            //           Positioned(
                            //             top: 260.w,
                            //             left: 428.w,
                            //             child: AirData(
                            //               name: 'CO2',
                            //               data: 'ㆍ',
                            //               data2: env['sensorTvoc'][0] + 'ppm',
                            //               nameColor: weatherFontColorReal,
                            //               dataColor: weatherDataFontColorReal,
                            //               emotionColor: weatherDustEmotionColor,
                            //             ),
                            //           ),
                            //           Positioned(
                            //             top: 345.w,
                            //             left: 428.w,
                            //             child:
                            //             AirData(
                            //               name: '미세먼지',
                            //               data: weatherPm10,
                            //               data2: sensorPm10,
                            //               nameColor: weatherFontColorReal,
                            //               dataColor: weatherDataFontColorReal,
                            //               emotionColor: weatherDustEmotionColor,
                            //             ),
                            //           ),
                            //           Positioned(
                            //             top: 425.w,
                            //             left: 428.w,
                            //             child: AirData(
                            //               name: '초미세먼지',
                            //               data: weatherPm25,
                            //               data2: sensorPm25,
                            //               nameColor: weatherFontColorReal,
                            //               dataColor: weatherDataFontColorReal,
                            //               emotionColor: weatherDustEmotionColor,
                            //             ),),
                            //
                            //           Row(
                            //             children: [
                            //               SizedBox(
                            //                 width: 560.w,
                            //               ),
                            //               Container(
                            //                 child: Text(
                            //                     '실외',
                            //                     style: TextStyle(
                            //                       fontFamily: 'GamjaFlower',
                            //                       color:
                            //                       weatherFontColorReal,
                            //                       fontSize: 40.sp,
                            //                       fontWeight: FontWeight.w400,
                            //                       fontStyle: FontStyle.normal,
                            //                     )),
                            //                 margin: EdgeInsets.only(
                            //                     top: 35.w),
                            //               ),
                            //               SizedBox(
                            //                 width: 87.w,
                            //               ),
                            //               Container(
                            //                 child: Text(
                            //                     '실내',
                            //                     style: TextStyle(
                            //                       fontFamily: 'GamjaFlower',
                            //                       color:
                            //                       weatherFontColorReal,
                            //                       fontSize: 40.sp,
                            //                       fontWeight: FontWeight.w400,
                            //                       fontStyle: FontStyle.normal,
                            //                     )),
                            //                 margin: EdgeInsets.only(
                            //                     top: 35.w),
                            //               ),
                            //
                            //             ],
                            //           ),
                            //         ]
                            //
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class AirData extends StatefulWidget {
  const AirData({Key? key,
    required this.name,
    required this.data,
    required this.data2,
    required this.nameColor,
    required this.dataColor,
    required this.emotionColor,
  }) : super(key: key);
  final String name;
  final String data;
  final String data2;
  final Color nameColor;
  final Color dataColor;
  final Color emotionColor;

  @override
  State<AirData> createState() => _AirDataState();
}

class _AirDataState extends State<AirData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 391.w,
      height: 50.w,
      decoration: BoxDecoration(
          color: Colors.white,
          // shape: BoxShape.circle,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.w), bottomLeft: Radius.circular(20.w)),
          boxShadow: [
            BoxShadow(
                color: Color(0x29464646),
                offset: Offset(0, 3),
                blurRadius: 3
            )
          ]
      ),
      child: Row(
        children: [
          Container(
            width: 100.w,
            child: Text(widget.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  color: widget.nameColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                )),
          ),
          // margin: EdgeInsets.only(top: 117.w),
          // SizedBox(width: 0.w,),
          Container(
            width: 135.w,
            height: 50.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    widget.data,
                    textAlign:TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'GamjaFlower',
                      color:
                      widget.dataColor,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    )),
                if(widget.data == '좋음')...[
                  SvgPicture.asset('assets/images/borabora/airple_weather/dust_emotion/good_emotion.svg',
                  color: widget.emotionColor,
                  width: 26.w,),
                ]else if(widget.data == '보통')...[
                  SvgPicture.asset('assets/images/borabora/airple_weather/dust_emotion/normal_emotion.svg',
                    color: widget.emotionColor,
                    width: 26.w,),
                ]else if(widget.data == '나쁨')...[
                  SvgPicture.asset('assets/images/borabora/airple_weather/dust_emotion/bad_emotion.svg',
                    color: widget.emotionColor,
                    width: 26.w,),
                ]else if(widget.data == '매우나쁨')...[
                  SvgPicture.asset('assets/images/borabora/airple_weather/dust_emotion/verybad_emotion.svg',
                    color: widget.emotionColor,
                    width: 26.w,),
                ]
              ],
            ),
            // margin: EdgeInsets.only(
            //     top: 26.w),
          ),
          SizedBox(
            width: 20.w,
          ),
          Container(
            width: 135.w,
            height: 50.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                   widget.data2,
                    style: TextStyle(
                      fontFamily: 'GamjaFlower',
                      color:
                      widget.dataColor,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    )),
                if(widget.data2 == '좋음')...[
                  SvgPicture.asset('assets/images/borabora/airple_weather/dust_emotion/good_emotion.svg',
                    color: widget.emotionColor,
                    width: 26.w,),
                ]else if(widget.data2 == '보통')...[
                  SvgPicture.asset('assets/images/borabora/airple_weather/dust_emotion/normal_emotion.svg',
                    color: widget.emotionColor,
                    width: 26.w,),
                ]else if(widget.data2 == '나쁨')...[
                  SvgPicture.asset('assets/images/borabora/airple_weather/dust_emotion/bad_emotion.svg',
                    color: widget.emotionColor,
                    width: 26.w,),
                ]else if(widget.data2 == '매우나쁨')...[
                  SvgPicture.asset('assets/images/borabora/airple_weather/dust_emotion/verybad_emotion.svg',
                    color: widget.emotionColor,
                    width: 26.w,),
                ]
              ],
            ),
            // margin: EdgeInsets.only(
            //     top: 26.w),
          ),
        ],
      ),
    );
  }
}
