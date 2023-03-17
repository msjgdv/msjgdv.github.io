import 'package:flutter/material.dart';
import 'package:treasure_map/f_environment/environment_setting.dart';
import 'package:treasure_map/provider/app_management.dart';
import 'package:treasure_map/widgets/login_route.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



import 'f_environment/widget/environment_api.dart';
import 'provider/app_management.dart';
import 'widgets/login_route.dart';
import 'widgets/menu_bar.dart';
import 'f_environment/main.dart';

class IEnvironment extends StatefulWidget {
  const IEnvironment({Key? key}) : super(key: key);

  @override
  State<IEnvironment> createState() => _IEnvironmentState();
}

class _IEnvironmentState extends State<IEnvironment> {
  GlobalKey<ScaffoldState> _scaffoldState =
  GlobalKey<ScaffoldState>(); //appbar없는 menubar용

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
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.w,
                    ),

                    Container(
                      width: 0.w,
                      height: 400.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.w)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SubServiceButton(name: '보라보라', nextPage:  0, icon: 'assets/icons/icon_borabora.svg',),
                                SizedBox(
                                  width: 135.5.w,
                                ),
                                SubServiceButton(name: '아이환경설정', nextPage:  1, icon: 'assets/icons/icon_borabora_setting.svg',),
                              ]
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 72.w,
                        ),
                        GestureDetector(
                          onTap: (){
                            loginRoute(context, Provider.of<UserInfo>(context, listen: false).role);
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Icon(Icons.arrow_back_ios_new, color: Colors.white,),
                                SizedBox(
                                  width: 35.w,
                                ),
                                Text("이전",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 26.sp,
                                    color: Color(0xff393838),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
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

class SubServiceButton extends StatefulWidget {
  const SubServiceButton({Key? key,
    required this.name,
    required this.nextPage,
    required this.icon,
  }) : super(key: key);
  final String name;
  final int nextPage;
  final String icon;

  @override
  State<SubServiceButton> createState() => _SubServiceButtonState();
}

class _SubServiceButtonState extends State<SubServiceButton> {
  late var envResponse;
  late var attendResponse;
  late var mainDataResponse;

  getDataAndRoute() async{
    envResponse = await callEnvApi(context, 0);
    attendResponse = await callEnvApi(context, 1);
    mainDataResponse = await callEnvApi(context, 2);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SmartInfoPanelMain(envResponse: envResponse,attendResponse: attendResponse, mainDataResponse: mainDataResponse)),
    );
  }

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
              if(widget.nextPage == 0){
                getDataAndRoute();
              }else{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EnvironmentSetting()),
                );
                // loginRoute(context, Provider.of<UserInfo>(context, listen: false).role);
              }
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
              fontSize: 20.sp,
              fontWeight: FontWeight.w700),
        )
      ],
    );
  }
}


