import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/activity.dart'; 
import 'package:treasure_map/environment.dart';
import 'package:treasure_map/play.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../grow.dart';
import '../widgets/menu_bar.dart';
import 'back_home.dart';


class A6_1 extends StatefulWidget {
  const A6_1({Key? key}) : super(key: key);

  @override
  State<A6_1> createState() => _A6_1State();
}

class _A6_1State extends State<A6_1> {
  GlobalKey<ScaffoldState> _scaffoldState =
  GlobalKey<ScaffoldState>(); //appbar없는 menubar용
  static final autoLoginStorage = FlutterSecureStorage();

  List<String> MainServiceIcons = [
    "assets/icons/icon_iactivite.svg",
    "assets/icons/icon_iplay.svg",
    "assets/icons/icon_idevelopment.svg",
    "assets/icons/icon_iteacher.svg",
    "assets/icons/icon_iparent.svg",
    "assets/icons/icon_ienvironment.svg",
  ];

  List<String> MainServiceNames = [
    "아이생활",
    "아이놀이",
    "아이발달",
    "아이교사",
    "아이부모",
    "아이환경",
  ];

  List<Widget> MainServiceRouth = [
    IActivity(),
    BackHome(),
    IGrow(),
    IPlay(),
    BackHome(),
    IEnvironment(),
  ];

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
              endDrawer: MenuDrawer(),
              body: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: ListView(
            physics: const RangeMaintainingScrollPhysics(),
                  children: [
                    Container(
                      margin:
                      EdgeInsets.fromLTRB(1100.w, 48.19.w, 0.w, 0.w),
                      child: IconButton(
                          onPressed: () {
                            _scaffoldState.currentState?.openEndDrawer();
                          },
                          icon: SvgPicture.asset(
                              './assets/icons/icon_menu.svg',
                              width: 33.w,
                              height: 27.8.w)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/logo/full_orange.svg',
                          width: 250.w,
                          // height: 145.w,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for(int i = 0; i<MainServiceIcons.length;i++)...[
                          MainServiceButton(name: MainServiceNames[i], nextPage: MainServiceRouth[i], icon: MainServiceIcons[i],),
                          if(i != MainServiceIcons.length - 1)...[
                            SizedBox(
                              width: 40.w,
                            )
                          ]
                        ]
                      ],
                    )


                  ],
                ),
              ),
            )
        )
    );
  }
}

class MainServiceButton extends StatefulWidget {
  const MainServiceButton({Key? key,
    required this.name,
    required this.nextPage,
    required this.icon,
  }) : super(key: key);
  final String name;
  final Widget nextPage;
  final String icon;

  @override
  State<MainServiceButton> createState() => _MainServiceButtonState();
}

class _MainServiceButtonState extends State<MainServiceButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.w)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x294D4D4D),
                  blurRadius: 4,
                  offset: Offset(2, 2), // changes position of shadow
                ),
              ]
          ),
          width: 150.w,
          height: 150.w,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(
                    const Color(0xffffffff)),
                shape: MaterialStateProperty.all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.w),
                    ))),
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => widget.nextPage),
              );

            },
            child: Padding(padding: EdgeInsets.all(10.w),
              child: SvgPicture.asset(widget.icon),
            ),
          ),
        ),
        SizedBox(
          height: 30.w,
        ),
        Text(
          widget.name,
          style: TextStyle(
              color: Color(0xff46423C),
              fontSize: 20.w,
              fontWeight: FontWeight.w700),
        )
      ],
    );
  }
}


