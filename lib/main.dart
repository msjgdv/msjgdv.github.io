import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/provider/admin_info.dart';
import 'package:treasure_map/provider/app_management.dart';
import 'package:treasure_map/provider/atti_child_data_management.dart';
import 'package:treasure_map/provider/child_data_management.dart';

import 'package:treasure_map/provider/parent_data_management.dart';
import 'package:treasure_map/provider/record_management.dart';
import 'package:treasure_map/provider/report_data_management.dart';

import 'package:treasure_map/provider/survey_data_management.dart';
import 'package:treasure_map/widgets/api.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:treasure_map/widgets/id_to.dart';
import 'package:treasure_map/widgets/login_route.dart';

import 'package:http/http.dart' as http;

import 'a_main/a1.dart';

import 'provider/class_data_management.dart';
import 'provider/teacher_data_management.dart';

final supportedLocales = [const Locale('en', 'US'), const Locale('ko', 'KR')];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminInfo()),
        ChangeNotifierProvider(create: (_) => ChildDataManagement()),
        ChangeNotifierProvider(create: (_) => AttiChildDataManagement()),
        ChangeNotifierProvider(create: (_) => TeacherDataManagement()),
        ChangeNotifierProvider(create: (_) => ClassDataManagement()),
        ChangeNotifierProvider(create: (_) => ParentDataManagement()),
        ChangeNotifierProvider(create: (_) => RecordDataManagement()),
        ChangeNotifierProvider(create: (_) => UserInfo()),
        ChangeNotifierProvider(create: (_) => SurveyDataManagement()),
        ChangeNotifierProvider(create: (_) => ReportDataManagement()),
        ChangeNotifierProvider(create: (_) => IdTo()),
      ],
      child: EasyLocalization(
          supportedLocales: supportedLocales,
          path: 'assets/translations',
          fallbackLocale: const Locale('en', 'US'),
          child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
      designSize: const Size(1240, 790),
      builder: (ctx, child) {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft]);
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          theme: ThemeData(
            fontFamily: 'NotoSansKR',

          ),
          home: const MyPage(),
        );
      });
}

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? userID; //user의 정보를 저장하기 위한 변수
  String? userPW;
  static const autoLoginStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    loadingStart();
  }

  loadingStart() async {
    ApiUrl apiUrl = ApiUrl();
    http.Response versionRes =
        await api(apiUrl.version, 'get', '', {}, context);

    if (versionRes.statusCode == 200) {
      var versionRB = utf8.decode(versionRes.bodyBytes);
      var versionData = jsonDecode(versionRB);
      print(versionData);
      final info = await PackageInfo.fromPlatform();
      if (info.version == versionData["version"]) {
        userID = (await autoLoginStorage.read(key: "id"));
        userPW = (await autoLoginStorage.read(key: "password"));
        if (userID != null) {
          http.Response autoLoginRes = await api(
              apiUrl.loginIn,
              'post',
              '',
              {
                'email': userID,
                'password': userPW,
              },
              context);
          if (autoLoginRes.statusCode == 200) {
            var autoLoginRB = utf8.decode(autoLoginRes.bodyBytes);
            var autoLoginData = jsonDecode(autoLoginRB);
            await autoLoginStorage.write(
                key: "signInToken", value: autoLoginData['token']);
            await autoLoginStorage.write(
                key: "cookie", value: autoLoginRes.headers['set-cookie']!);

            http.Response statusRes =
                await api(apiUrl.status, 'get', 'signInToken', {}, context);
            if (statusRes.statusCode == 200) {
              var statusRB = utf8.decode(statusRes.bodyBytes);
              var statusData = jsonDecode(statusRB);
              Provider.of<UserInfo>(context, listen: false).role =
                  statusData["type"];
              Provider.of<UserInfo>(context, listen: false).service =
                  statusData['status'];
              Provider.of<UserInfo>(context, listen: false).value =
                  statusData['value'];

              http.Response adminRes =
                  await api(apiUrl.loginIn, 'get', 'signInToken', {}, context);
              if (adminRes.statusCode == 200) {
                var adminRB = utf8.decode(adminRes.bodyBytes);
                var adminData = jsonDecode(adminRB);

                Image _image = await imageApi(
                    adminData["imagePath"],
                    'signInToken',
                    context);

                Provider.of<AdminInfo>(context, listen: false).infoUpdate(
                    adminData["email"],
                    adminData["name"],
                    adminData["phoneNumber"],
                    _image,
                    adminData["comment"] ?? '');
                loginRoute(context,
                    Provider.of<UserInfo>(context, listen: false).role);
              }
            }
          }else{
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const A1()));
          }
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const A1()));
        }
      } else {
        exitPopupDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(
        Image.asset('assets/backgrounds/loading_page.png').image, context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: Image.asset('assets/backgrounds/loading_page.png').image,
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 80.72.w),
                  child: SvgPicture.asset('assets/icons/icon_aijoa_logo.svg'),
                  width: 156.41.w,
                  height: 115.71.w,
                ),
                Container(
                  margin: EdgeInsets.only(top: 32.57.w),
                  child: SvgPicture.asset('assets/icons/icon_treasurebox.svg'),
                  width: 287.w,
                  height: 262.w,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void exitPopupDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("현재 버전이 낮아 홈페이지에서 업데이트를 진행해 주세요."),
          actions: [
            Center(
              child: TextButton(
                child: const Text("예"),
                onPressed: () {
                  exit(0);
                },
              ),
            )
          ],
        );
      });
}
