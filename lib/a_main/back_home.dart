import 'package:flutter/material.dart';
import 'package:treasure_map/provider/app_management.dart';
import 'package:treasure_map/widgets/login_route.dart';
import 'package:provider/provider.dart';

class BackHome extends StatefulWidget {
  const BackHome({Key? key}) : super(key: key);

  @override
  State<BackHome> createState() => _BackHomeState();
}

class _BackHomeState extends State<BackHome> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
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
                  fontSize: 30,
                  color: Color(0xff393838),
                ),
              ),
            ),
          ),
        ));
  }
}
