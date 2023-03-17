import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/e_growth/atti/widget/child_select_btn.dart';
import 'package:treasure_map/e_growth/atti/widget/report_page_header.dart';
import 'package:treasure_map/e_growth/atti/widget/report_text_style.dart';
import 'package:treasure_map/provider/atti_child_data_management.dart';
import 'package:treasure_map/provider/report_data_management.dart';
import 'package:treasure_map/widgets/custom_container.dart';
import '../../../widgets/id_to.dart';
import '../widget/report_graph1_2.dart';
import 'package:provider/provider.dart';

class AttiC extends StatefulWidget {
  const AttiC({
    Key? key,
    required this.changeScreen,
    this.beforeWidget,
    this.name = "",
  }) : super(key: key);
  final Function(Widget) changeScreen;
  final Widget? beforeWidget;

  final String name;

  @override
  State<AttiC> createState() => _AttiCState();
}

class _AttiCState extends State<AttiC> {
  List<int> arrowDirection = [];
  int allCountConnect = 0;

  int headCount = 1;
  int lineCount = 0;
  int modulo = 0;
  bool onOff = false;

  int inClassNumber = 0;

  changeChild(int index){
    setState(() {
      inClassNumber = index;
    });
    dataSet();
  }


  dataSet(){
    arrowDirection.clear();
    setState(() {
      for (int i = 0;
      i <
          Provider.of<ReportDataManagement>(context, listen: false)
              .reportData.last['positiveGraph'][inClassNumber]
              .length;
      i++) {
        arrowDirection.add(4);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataSet();
    headCount = Provider.of<ReportDataManagement>(context, listen: false).reportData.last['headCount'];
    lineCount = (headCount/8).floor();
    modulo = headCount%8;
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int j = 0;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.w),
          bottomLeft: Radius.circular(50.w),
        ),
        color: Color(0xffFCFCFC),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                // color: Color(0xfffcfcfc),
                height: 50.w,
              ),
              if(Provider.of<ReportDataManagement>(context, listen: false).reportData.last['headCount'] == inClassNumber + 1)...[
                ReportPageHeader(
                  title: '(이/가) 좋아하는 친구들',
                  changeScreen: widget.changeScreen,
                  nextPage: false,
                  beforeWidget: widget.beforeWidget,
                  name: Provider.of<AttiChildDataManagement>(context, listen: false)
                      .childList[inClassNumber]
                      .name,
                  // afterWidget: AttiC(changeScreen: widget.changeScreen, inClassNumber: inClassNumber + 1, beforeWidget: widget,),
                ),
              ]else...[
                ReportPageHeader(
                  title: '(이/가) 좋아하는 친구들',
                  changeScreen: widget.changeScreen,
                  nextPage: false,
                  beforeWidget: widget.beforeWidget,
                  name: Provider.of<AttiChildDataManagement>(context, listen: false)
                      .childList[inClassNumber]
                      .name,
                  // afterWidget: AttiC(changeScreen: widget.changeScreen, inClassNumber: inClassNumber + 1, beforeWidget: widget,),
                ),
              ],


              Expanded(
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView(
                      physics: const RangeMaintainingScrollPhysics(),
                children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 59.w,
                        ),
                        Container(
                          width: 550.w,
                          height: 550.w,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.w, color: Color(0x663BFD7E)),
                            borderRadius: BorderRadius.all(Radius.circular(20.w)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x29B1B1B1),
                                blurRadius: 6,
                                offset: Offset(-2, 2), // changes position of shadow
                              ),
                              BoxShadow(
                                color: Color(0x1a3BFD7E),
                                blurRadius: 8,
                                // spreadRadius: -12.0,
                                offset: Offset(-7, 7), // changes position of shadow
                              ),
                              BoxShadow(
                                color: Color(0xffffffff),
                                blurRadius: 5,
                                spreadRadius: -3.0,
                                offset: Offset(0, 0), // changes position of shadow
                              ),
                            ],
                            // color: Colors.white
                          ),
                          child: Report3Graph(
                            linkedChild: Provider.of<ReportDataManagement>(context,
                                    listen: false)
                                .reportData.last['positiveGraph'][inClassNumber].cast<int>(),
                            childCount: Provider.of<ReportDataManagement>(context,
                                    listen: false)
                                .reportData.last['positiveGraph'][inClassNumber]
                                .length,
                            arrowDirection: arrowDirection,
                            inClassNumber: inClassNumber,
                          ),
                        ),
                        SizedBox(
                          width: 50.w,
                        ),
                        Column(
                          children: [
                            Center(
                                child: Container(
                              width: 400.w,
                              child: RichText(
                                text: TextSpan(
                                  text: Provider.of<AttiChildDataManagement>(context, listen: false).childList[inClassNumber].name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.sp,
                                    color: Color(0xff393838),
                                  ),
                                  children: <TextSpan>[
                                if(Provider.of<ReportDataManagement>(context,
                                    listen: false)
                                    .reportData.last['positiveGraph'][inClassNumber].length == 0)...[
                                  TextSpan(text: "(이/가) 좋아하는 친구는 없습니다."),
                        ]else...[
                                    TextSpan(text: "(이/가) 좋아하는 친구는 "),
                                    for (int i = 0; i < Provider.of<ReportDataManagement>(context,
                                        listen: false)
                                        .reportData.last['positiveGraph'][inClassNumber].length; i++) ...[
                                      TextSpan(
                                        text: Provider.of<IdTo>(context, listen: false).IdToName(Provider.of<ReportDataManagement>(context,
                                            listen: false)
                                            .reportData.last['positiveGraph'][inClassNumber][i], context),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff393838)),
                                      ),
                                      if (i != Provider.of<ReportDataManagement>(context,
                                          listen: false)
                                          .reportData.last['positiveGraph'][inClassNumber].length - 1) ...[
                                        TextSpan(
                                          text: ", ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xff393838)),
                                        ),
                                      ]
                                    ],
                                    TextSpan(
                                        text: "입니다.\n"
                                            ),
                                    ],
                                  ], // textAlign: TextAlign.center,
                                ),
                              ),
                            ))
                          ],
                        )
                      ],
                    ),
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          color: Color(0xfffcfcfc),
                          height: 10.w,
                          width: 39.w,
                        )
                      ],
                    )),
                    Container(
                      height: 50.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50.w),
                        ),
                        color: Color(0xffFCFCFC),
                      ),
                    ),
                ],
              ),
                  )),

            ],
          ),

          for(int i=0;i<lineCount;i++)...[
            for(int k = 0; k<8;k++, j++)...[
              AnimatedPositioned(
                duration: Duration(milliseconds: 1000 + j*30),
                curve: Curves.fastOutSlowIn,
                left: onOff != true ? -1000.w : (29 + 85*i).w,
                top: (20 + 91*k).w,
                child: ChildSelectBtn(inClassNumber : k + i *8, changeScreen: widget.changeScreen, beforeWidget: widget, goWidget: 0,changeChild : changeChild),
              )
            ],
          ],
          for(int k = 0; k<modulo;k++, j++)...[
            AnimatedPositioned(
              duration: Duration(milliseconds: 1000 + j*30),
              curve: Curves.fastOutSlowIn,
              left: onOff != true ? -1000.w : (29 + 85*lineCount).w,
              top: (20 + 91*k).w,
              child: ChildSelectBtn(inClassNumber : j, changeScreen: widget.changeScreen,beforeWidget: widget, goWidget: 0,changeChild : changeChild),

            )
          ],
          AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              top: 350.w,
              left: onOff != true ? 20.w : (29 + 85*lineCount + 90).w,
              child: GestureDetector(
                  onTap: (){
                    setState(() {
                      onOff = !onOff;
                    });
                  },
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: onOff ? Colors.white : Colors.transparent,
                        border: onOff ? Border.all(color: Color(0xffA666FC), width: 1.w) : Border.all(color: Colors.transparent,width: 0)
                    ),
                    child: Center(
                      child: Icon(onOff ? Icons.arrow_back_ios_new_outlined : Icons.arrow_forward_ios_outlined,
                        color: const Color(0xffA666FC),
                        size: 30.w,),
                    ),
                  ))),
        ],
      ),
    );
  }
}
