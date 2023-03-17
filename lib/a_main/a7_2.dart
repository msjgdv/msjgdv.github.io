import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/api/admin.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:http/http.dart' as http;
import '../provider/app_management.dart';
import '../widgets/menu_bar.dart';

class A7_2 extends StatefulWidget {
  const A7_2({
    Key? key,
    required this.nextPage,
  }) : super(key: key);
  final Widget nextPage;

  @override
  State<A7_2> createState() => _A7_2State();
}

class _A7_2State extends State<A7_2> {
  final GlobalKey<ScaffoldState> _scaffoldState =
      GlobalKey<ScaffoldState>(); //appbar없는 menubar용
  static const autoLoginStorage = FlutterSecureStorage();
  var classAges = <dynamic>{};

  List<ClassInfo> classInfo = [];
  bool agePage = true;
  List<String> className = [];
  List<int> classId = [];
  List<dynamic> classAgeList = [];

  ApiUrl apiUrl = ApiUrl();

  selectAge(bool data) {
    setState(() {
      agePage = data;
    });
  }
  var schoolYearData;
  int nowYear = 0;
  List<int> yearData = [];

  List<DropdownMenuItem<int>> yearList() {
    return yearData
        .map<DropdownMenuItem<int>>(
          (e) =>
          DropdownMenuItem(
            enabled: true,
            alignment: Alignment.centerLeft,
            value: e,
            child: Text(
              '      $e 학년도',
              style: TextStyle(
                  color: Color(0xff393838),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
    ).toList();
  }

  getSchoolYear() async{
    http.Response res = await api(apiUrl.schedule, 'get', 'signInToken', {}, context);

    if(res.statusCode == 200) {
      var schoolYearRB = utf8.decode(res.bodyBytes);
      schoolYearData = jsonDecode(schoolYearRB);
      print(schoolYearData);
      setState(() {
        yearData = schoolYearData['years'].cast<int>();
        nowYear = yearData.last;
        // for (int i = 0; i < 100; i++) {
        //   if (yearData.indexWhere((year) => year == getToday()) != -1) {
        //     nowYear = yearData.last;
        //     break;
        //   }
        // }
      });

      print(nowYear);
      getClassInfo(nowYear);
    }
  }


  getClassInfo(int year) async {
    http.Response res = await api('${apiUrl.getClass}/$year', 'get', 'signInToken', {}, context);
    if(res.statusCode == 200){
      var classRB = utf8.decode(res.bodyBytes);
      var classData = jsonDecode(classRB);
      classInfo.clear();
      classAges.clear();
      setState(() {
        for (int i = 0; i < classData.length; i++) {
          classInfo.add(ClassInfo(
              name: classData[i]['name'],
              teacher: classData[i]['teacher'],
              comment: classData[i]['comment'],
              count: classData[i]['count'],
              age: classData[i]['age'],
              id: classData[i]['id'],
              year: classData[i]['year'],
              tid: classData[i]['tid']));
          classAges.add(classInfo[i].age);
        }
        agePage = true;
      });
      classAgeList = classAges.toList();
    }
  }

  setAgeClass(String classAge) {
    setState(() {
      className.clear();
      classId.clear();
      for (int i = 0; i < classInfo.length; i++) {
        if (classInfo[i].age.contains(classAge)) {
          className.add(classInfo[i].name);
          classId.add(classInfo[i].id);
        }
      }
    });
  }

  @override
  void initState() {
    getSchoolYear();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(Image.asset('assets/backgrounds/main_page.png').image, context);
    return WillPopScope(
        onWillPop: () async => false,
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset('assets/backgrounds/main_page.png').image,
            )),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              key: _scaffoldState,
              endDrawer: const MenuDrawer(),
              body: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: ListView(
            physics: const RangeMaintainingScrollPhysics(),
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(1100.w, 48.19.w, 0.w, 0.w),
                      child: IconButton(
                          onPressed: () {
                            _scaffoldState.currentState?.openEndDrawer();
                          },
                          icon: SvgPicture.asset('./assets/icons/icon_menu.svg',
                              width: 33.w, height: 27.8.w)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/logo/full_orange.svg',
                          width: 250.w,
                          // height: 145.w,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40.w,
                          width: 150.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.w)),
                            color: Colors.white,
                            // border: Border.all(color: widget.borderColor, width: 1.w),
                            boxShadow: [
                                BoxShadow(
                                  color: Color(0x29000000),
                                  blurRadius: 6,
                                  offset: Offset(1, 1),
                                ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              Container(
                                width: 140.w,
                                child: DropdownButton(
                                  isExpanded: true,
                                  menuMaxHeight: 300.w,
                                  value: nowYear,
                                  elevation: 16,
                                  items: yearList(),
                                  onChanged: (value) {
                                    setState(() {
                                      nowYear = value as int;
                                      getClassInfo(nowYear);

                                    });


                                  },
                                  icon: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 25.w,
                                        color: Color(0xff393838),
                                      ),
                                    ],
                                  ),
                                  alignment: AlignmentDirectional.topCenter,
                                  underline: SizedBox.shrink(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: agePage
                          ? [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 0;
                                      i < classAgeList.length ~/ 6;
                                      i++) ...[
                                    for (int j = 0; j < 6; j++) ...[
                                      MainServiceButton(
                                        age: classAgeList[i * 6 + j],
                                        nextPage: widget.nextPage,
                                        selectAge: selectAge,
                                        agePage: agePage,
                                        setClassName: setAgeClass,
                                      ),
                                      if (j != 5) ...[
                                        SizedBox(width: 45.w),
                                      ]
                                    ],
                                  ],
                                ],
                              ),
                              if (classAgeList.length ~/ 6 == 1) ...[
                                SizedBox(height: 30.w),
                              ],
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = classAgeList.length % 6 - 1;
                                      i >= 0;
                                      i--) ...[
                                    MainServiceButton(
                                      age: classAgeList[
                                          classAgeList.length - i - 1],
                                      nextPage: widget.nextPage,
                                      selectAge: selectAge,
                                      agePage: agePage,
                                      setClassName: setAgeClass,
                                    ),
                                    if (i != 0) ...[
                                      SizedBox(width: 45.w),
                                    ]
                                  ],
                                ],
                              )
                            ]
                          : [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 0;
                                      i < className.length ~/ 6;
                                      i++) ...[
                                    for (int j = 0; j < 6; j++) ...[
                                      MainServiceButton(
                                          age: className[i * 6 + j],
                                          nextPage: widget.nextPage,
                                          cid: classId[i * 6 + j],
                                          selectAge: selectAge,
                                          agePage: agePage,
                                          setClassName: setAgeClass),
                                      if (j != 5) ...[
                                        SizedBox(width: 45.w),
                                      ]
                                    ],
                                  ],
                                ],
                              ),
                              if (className.length ~/ 6 == 1) ...[
                                SizedBox(height: 75.w),
                              ],
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = className.length % 6 - 1;
                                      i >= 0;
                                      i--) ...[
                                    MainServiceButton(
                                        age: className[className.length - i -1],
                                        nextPage: widget.nextPage,
                                        cid: classId[className.length - i -1],
                                        selectAge: selectAge,
                                        agePage: agePage,
                                        setClassName: setAgeClass),
                                    if (i != 0) ...[
                                      SizedBox(width: 100.w),
                                    ]
                                  ],
                                ],
                              ),

                            ],
                    )
                  ],
                ),
              ),
            )));
  }
}

class MainServiceButton extends StatefulWidget {
  const MainServiceButton({
    Key? key,
    required this.age,
    required this.nextPage,
    this.cid = 0,
    required this.agePage,
    required this.selectAge,
    required this.setClassName,
  }) : super(key: key);
  final String age;
  final Widget nextPage;
  final int cid;
  final bool agePage;
  final Function(bool) selectAge;
  final Function(String) setClassName;

  @override
  State<MainServiceButton> createState() => _MainServiceButtonState();
}

class _MainServiceButtonState extends State<MainServiceButton> {
  int imageNumber = 6;

  List<String> childAgeImage = [
    'assets/icons/icon_0years.svg',
    'assets/icons/icon_1years.svg',
    'assets/icons/icon_2years.svg',
    'assets/icons/icon_3years.svg',
    'assets/icons/icon_4years.svg',
    'assets/icons/icon_5years.svg',
    'assets/icons/icon_teacher.svg'
  ];

  @override
  void initState() {
      if(widget.age.split("~").length == 2){
        for(int i = 0; i<widget.age.split("~").length;i++) {
          if(i==1){
            imageNumber = int.parse(widget.age.split("~")[i].split('세반')[0]);
          }
        }
      }
      if(widget.age.split("~").length == 1){
        for(int j = 0; j<widget.age.split("~")[0].split('만').length;j++){
          if(j==1){
            imageNumber = int.parse(widget.age.split("~")[0].split('만')[j].split('세반')[0]);
          }
        }
      }


    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.w)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x294D4D4D),
                  blurRadius: 4,
                  offset: Offset(2, 2), // changes position of shadow
                ),
              ]),
          width: 150.w,
          height: 150.w,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xffffffff)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.w),
                  ))),
              onPressed: () {
                widget.agePage
                    ? {
                        widget.selectAge(!(widget.agePage)),
                        widget.setClassName(widget.age),
                      }
                    : {
                        // Provider.of<UserInfo>(context, listen: false)
                        //     .value
                        //     .clear(),

                        Provider.of<UserInfo>(context, listen: false)
                            .value[0] = widget.cid,
                  Provider.of<UserInfo>(context, listen: false)
                      .value[2] = widget.age,

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => widget.nextPage),
                        ),
                      };
              },
              child: Center(
                child: widget.agePage ?
                SvgPicture.asset(childAgeImage[imageNumber]):
                Text(
                  widget.age,
                  style: TextStyle(
                      color: const Color(0xff46423C),
                      fontSize: 20.w,
                      fontWeight: FontWeight.w700),
                ),
              )),
        ),
        widget.agePage ?
        SizedBox(height: 15.w,):SizedBox(height: 0.w,),
        widget.agePage ?
        Text(
          widget.age,
          style: TextStyle(
              color: const Color(0xff46423C),
              fontSize: 20.w,
              fontWeight: FontWeight.w700),
        ):Container(),
      ],
    );
  }
}
