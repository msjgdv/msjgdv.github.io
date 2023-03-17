import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:treasure_map/f_environment/widget/environment_api.dart';
import 'package:treasure_map/widgets/api.dart';

import '../provider/app_management.dart';
import '../widgets/login_route.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import '../widgets/menu_bar.dart';

class EnvironmentSetting extends StatefulWidget {
  const EnvironmentSetting({Key? key}) : super(key: key);

  @override
  State<EnvironmentSetting> createState() => _EnvironmentSettingState();
}

class _EnvironmentSettingState extends State<EnvironmentSetting> {
  GlobalKey<ScaffoldState> _scaffoldState =
      GlobalKey<ScaffoldState>(); //appbar없는 menubar용
  static final autoLoginStorage = FlutterSecureStorage();
  
  ApiUrl apiUrl = ApiUrl();

  int tap = 0;

  List<Widget> settingWidget = [];

  late dynamic mainDataResponse;

  int noticePage = 0;
  List<Image?> noticeImage = [];
  List<Image?> eventImage = [];
  List<int> noticePathNumber = [];

  dataSetting() async {
    noticeImage.clear();
    eventImage.clear();

    final token = await autoLoginStorage.read(key: "signInToken");
    Map<String, String> headers = new Map();
    headers['authorization'] = token!;
    mainDataResponse = await callEnvApi(context, 3);
    int j = 0;
    for (int i = 0; i < 30; i++) {
      if (mainDataResponse["noticePathNumbers"].contains(i + 1)) {
        noticeImage.add(
          await imageApi(mainDataResponse["noticePaths"][j], 'signInToken', context)
          );
        j++;
      } else {
        noticeImage.add(null);
      }
    }
    j = 0;
    for (int i = 0; i < 8; i++) {
      if (mainDataResponse["eventImageNumbers"].contains(i + 1)) {
        eventImage.add(
            await imageApi(mainDataResponse["eventImagePaths"][j], 'signInToken', context)
    );
        j++;
      } else {
        eventImage.add(null);
      }
    }
    setState(() {
      settingWidget = [
        NoticePanel(
          noticeImage: noticeImage,
          dataSetting: dataSetting,
        ),
        EventPanel(
          eventImage: eventImage,
          dataSetting: dataSetting,
        ),
        AdPanel(),
      ];
    });
  }

  @override
  void initState() {
    dataSetting();
    settingWidget = [
      NoticePanel(
        noticeImage: noticeImage,
        dataSetting: dataSetting,
      ),
      EventPanel(
        eventImage: eventImage,
        dataSetting: dataSetting,
      ),
      // AdPanel(),
    ];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCF9F4),
      key: _scaffoldState,
      endDrawer: MenuDrawer(),
      body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: ListView(
              physics: const RangeMaintainingScrollPhysics(),
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 57.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        loginRoute(context,
                            Provider.of<UserInfo>(context, listen: false).role);
                      },
                      child: SizedBox(
                        child: SvgPicture.asset(
                          'assets/logo/full_orange.svg',
                          width: 136.8.w,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          964.w,
                          48.19.w - MediaQuery.of(context).padding.top,
                          0.w,
                          0.w),
                      child: IconButton(
                          onPressed: () {
                            _scaffoldState.currentState?.openEndDrawer();
                          },
                          icon: SvgPicture.asset('./assets/icons/icon_menu.svg',
                              width: 33.w, height: 27.8.w)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.w,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 57.w,
                    ),
                    Container(
                      width: 400.w,
                      height: 54.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.w)),
                      ),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                              curve: Curves.fastOutSlowIn,
                              left: tap == 0
                                  ? 0
                                  : tap == 1
                                      ? 200.w
                                      : 400.w,
                              child: GestureDetector(
                                onTap: () {
                                  // tapTapBtn(tap);
                                },
                                child: Container(
                                  width: 200.w,
                                  height: 54.w,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFED796),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.w)),
                                  ),
                                ),
                              ),
                              duration: Duration(milliseconds: 500)),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tap = 0;
                                  });
                                },
                                child: Container(
                                  width: 200.w,
                                  height: 54.w,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.w),
                                        bottomLeft: Radius.circular(20.w)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "게시판",
                                      style: TextStyle(
                                        color: Color(0xff5C5C5C),
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tap = 1;
                                  });
                                },
                                child: Container(
                                  width: 200.w,
                                  height: 54.w,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      "행사페이지",
                                      style: TextStyle(
                                        color: Color(0xff5C5C5C),
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     setState(() {
                              //       tap = 2;
                              //     });
                              //   },
                              //   child: Container(
                              //     width: 200.w,
                              //     height: 54.w,
                              //     decoration: BoxDecoration(
                              //       color: Colors.transparent,
                              //       borderRadius: BorderRadius.only(
                              //           topRight: Radius.circular(20.w),
                              //           bottomRight: Radius.circular(20.w)),
                              //     ),
                              //     child: Center(
                              //       child: Text(
                              //         "광고",
                              //         style: TextStyle(
                              //           color: Color(0xff5C5C5C),
                              //           fontSize: 22.sp,
                              //           fontWeight: FontWeight.w700,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 84.w,
                ),
                settingWidget[tap],
              ])),
    );
  }
}

class NoticePanel extends StatefulWidget {
  const NoticePanel({
    Key? key,
    required this.noticeImage,
    required this.dataSetting,
  }) : super(key: key);
  final List<Image?> noticeImage;
  final Function() dataSetting;

  @override
  State<NoticePanel> createState() => _NoticePanelState();
}

class _NoticePanelState extends State<NoticePanel> {
  int noticePage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 426.18.w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 85.w,
          ),
          noticePage == 0
              ? SizedBox(
                  width: 15.w,
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      noticePage--;
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/icons/icon_back.svg',
                    width: 15.w,
                  ),
                ),
          SizedBox(
            width: 45.w,
          ),
          if (widget.noticeImage.length == 30) ...[
            NoticePlace(
              index: noticePage * 3 + 0,
              noticeImage: widget.noticeImage,
              dataSetting: widget.dataSetting,
            ),
            SizedBox(
              width: 23.87.w,
            ),
            NoticePlace(
              index: noticePage * 3 + 1,
              noticeImage: widget.noticeImage,
              dataSetting: widget.dataSetting,
            ),
            SizedBox(
              width: 23.87.w,
            ),
            NoticePlace(
              index: noticePage * 3 + 2,
              noticeImage: widget.noticeImage,
              dataSetting: widget.dataSetting,
            ),
          ],
          SizedBox(
            width: 45.w,
          ),
          noticePage == 9
              ? SizedBox(
                  width: 15.w,
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      noticePage++;
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/icons/icon_next.svg',
                    width: 15.w,
                  ),
                ),
        ],
      ),
    );
  }
}

class NoticePlace extends StatefulWidget {
  const NoticePlace({
    Key? key,
    required this.index,
    // required this.insertImage,
    required this.noticeImage,
    required this.dataSetting,
  }) : super(key: key);
  final int index;

  // final Function(File, int, String) insertImage;
  final List<Image?> noticeImage;
  final Function() dataSetting;

  @override
  State<NoticePlace> createState() => _NoticePlaceState();
}

class _NoticePlaceState extends State<NoticePlace> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var image = await pickImage(context, 8.5, 14, true);
        insertImage(image, widget.index, 'notice', context, widget.dataSetting);
      },
      child: Container(
        width: 300.33.w,
        height: 426.18.w,
        child: Stack(
          children: [
            Positioned(
                top: 13.08.w,
                left: 4.2.w,
                child: WidgetMask(
                  blendMode: BlendMode.srcATop,
                  childSaveLayer: true,
                  mask: widget.noticeImage[widget.index] == null
                      ? Image.asset(
                          "assets/images/borabora/childlifedata/void_page.png")
                      : widget.noticeImage[widget.index]!,
                  child: Container(
                    width: 291.91.w,
                    height: 413.33.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.w)),
                    ),
                  ),
                )),
            SvgPicture.asset(
                'assets/images/borabora/childlifedata/info_page_deco.svg'),
            widget.noticeImage[widget.index] == null
                ? Positioned(
                    top: 204.75.w,
                    left: 135.16.w,
                    child: SvgPicture.asset(
                      'assets/icons/icon_plus.svg',
                      width: 30.w,
                    ))
                : Positioned(
                    top: 30.w,
                    right: 20.w,
                    child: GestureDetector(
                      onTap: () {
                        deleteImage(context, "notice", widget.index,
                            widget.dataSetting);
                      },
                      child: Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x29B1B1B1),
                                blurRadius: 6,
                                offset: Offset(-2, 2),
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.remove_outlined,
                            size: 30.w,
                            color: Color(0xffA666FB),
                          )),
                    ))
          ],
        ),
      ),
    );
  }
}

class EventPanel extends StatefulWidget {
  const EventPanel({
    Key? key,
    required this.dataSetting,
    required this.eventImage,
  }) : super(key: key);
  final List<Image?> eventImage;
  final Function() dataSetting;

  @override
  State<EventPanel> createState() => _EventPanelState();
}

class _EventPanelState extends State<EventPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 384.w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 229.w,
          ),
          Column(
            children: [
              Row(
                children: [
                  for (int i = 0; i < 4; i++) ...[
                    if (i != 0) ...[
                      SizedBox(
                        width: 18.w,
                      ),
                    ],
                    EventPlace(
                      index: i,
                      eventImage: widget.eventImage,
                      dataSetting: widget.dataSetting,
                    ),
                  ],
                ],
              ),
              SizedBox(
                height: 18.w,
              ),
              Row(
                children: [
                  for (int i = 4; i < 8; i++) ...[
                    if (i != 4) ...[
                      SizedBox(
                        width: 18.w,
                      ),
                    ],
                    EventPlace(
                      index: i,
                      eventImage: widget.eventImage,
                      dataSetting: widget.dataSetting,
                    ),
                  ],
                ],
              )
            ],
          ),
          SizedBox(
            width: 225.w,
          ),
        ],
      ),
    );
  }
}

class EventPlace extends StatefulWidget {
  const EventPlace({
    Key? key,
    required this.dataSetting,
    required this.eventImage,
    required this.index,
  }) : super(key: key);
  final int index;
  final List<Image?> eventImage;
  final Function() dataSetting;

  @override
  State<EventPlace> createState() => _EventPlaceState();
}

class _EventPlaceState extends State<EventPlace> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var image = await pickImage(context, 1, 1, true);
        insertImage(image, widget.index, 'event', context, widget.dataSetting);
      },
      child: Container(
        width: 183.w,
        height: 183.w,
        child: widget.eventImage[widget.index] == null
            ? Container(
                width: 183.w,
                height: 183.w,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.w, color: Color(0xff707070)),
                  color: Colors.white,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/icon_plus.svg',
                    width: 30.w,
                  ),
                ),
              )
            : Stack(
                children: [
                  Container(
                    width: 183.w,
                    height: 183.w,
                    child: widget.eventImage[widget.index]!,
                  ),
                  Positioned(
                      top: 10.w,
                      right: 10.w,
                      child: GestureDetector(
                        onTap: () {
                          deleteImage(context, "event", widget.index,
                              widget.dataSetting);
                        },
                        child: Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x29B1B1B1),
                                  blurRadius: 6,
                                  offset: Offset(-2, 2),
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.remove_outlined,
                              size: 30.w,
                              color: Color(0xffA666FB),
                            )),
                      ))
                ],
              ),
      ),
    );
  }
}

class AdPanel extends StatefulWidget {
  const AdPanel({Key? key}) : super(key: key);

  @override
  State<AdPanel> createState() => _AdPanelState();
}

class _AdPanelState extends State<AdPanel> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

deleteImage(context, String type, int number, Function() dataSetting) async {
  ApiUrl apiUrl = ApiUrl();  

  http.Response res = await api('${apiUrl.infoPanelImage}?type=$type&number=${number+1}', 'delete', 'signInToken', {}, context);
  if(res.statusCode == 200){
    dataSetting();
  }

}

insertImage(File image, int number, String type, context,
    Function() dataSetting) async {
  ApiUrl apiUrl = ApiUrl();
  imagePostApi(apiUrl.infoPanelImage, 'signInToken', {"number": (number + 1).toString(),
    "type": type,}, image, 'post',context, dataSetting);
}

Future pickImage(
    context, double ratioX, double ratioY, bool lockAspectRatio) async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemp = File(image.path);
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageTemp.path,
      aspectRatio: CropAspectRatio(ratioX: ratioX, ratioY: ratioY),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: lockAspectRatio),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    return File(croppedFile!.path);
  } on PlatformException catch (e) {
    print('Failed to pick image: $e');
  }
}
