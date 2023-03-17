import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:treasure_map/provider/app_management.dart';
import 'package:treasure_map/widgets/login_route.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SoundTest extends StatefulWidget {
  const SoundTest({Key? key}) : super(key: key);

  @override
  State<SoundTest> createState() => _SoundTestState();
}

class _SoundTestState extends State<SoundTest> {
  AudioPlayer player = AudioPlayer();
  String audioasset = 'assets/sound/effect/4-3. Merry_Go_Silent_Film_Light.mp3';


  soundPlayer() async {
    ByteData bytes = await rootBundle.load(audioasset);
    Uint8List audiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    await player.setSourceBytes(audiobytes);
    player.resume();
  }

  Timer t = Timer(Duration(milliseconds: 5000), () {});

  @override
  void initState() {
    t = Timer(Duration(milliseconds: 5000), () {
      soundPlayer();
    });


    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          player.stop();
          t.cancel();
          loginRoute(context, Provider.of<UserInfo>(context, listen: false).role);
        },
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Center(
              child: Text("개발 중 입니다.",
                style: TextStyle(
                  fontSize: 30.sp,
                  color: Color(0xff393838),
                ),
              ),
            ),
          ),
        ));
  }
}
