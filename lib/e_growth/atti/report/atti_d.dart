import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/e_growth/atti/widget/child_select_btn.dart';
import 'package:treasure_map/e_growth/atti/widget/report_page_header.dart';
import 'package:treasure_map/e_growth/atti/widget/report_text_style.dart';
import 'package:treasure_map/widgets/custom_container.dart';
import '../../../provider/atti_child_data_management.dart';
import '../../../provider/report_data_management.dart';
import '../../../widgets/id_to.dart';
import '../widget/report_graph1_2.dart';
import 'package:provider/provider.dart';

class AttiD extends StatefulWidget {
  const AttiD({
    Key? key,
    required this.changeScreen,
    this.beforeWidget,
    this.name = "",
  }) : super(key: key);
  final Function(Widget) changeScreen;
  final Widget? beforeWidget;
  final String name;

  @override
  State<AttiD> createState() => _AttiDState();
}

class _AttiDState extends State<AttiD> {
  List<int> relationShip = [];
  List<int> arrowDirection = [];
  int allCountConnect = 0;
  double allCountDegreeCentrality = 0;
  double allCountBetweennessCentrality = 0;
  double allCountClosenessCentrality = 0;

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
    relationShip.clear();
    setState(() {
      for (int i = 0;
      i <
          Provider.of<ReportDataManagement>(context, listen: false)
              .reportData.last['connectionGraph'][inClassNumber][0]
              .length;
      i++) {
        relationShip.add(Provider.of<ReportDataManagement>(context, listen: false)
            .reportData.last['connectionGraph'][inClassNumber][0][i]);
        arrowDirection.add(0);
      }
      for (int i = 0;
      i <
          Provider.of<ReportDataManagement>(context, listen: false)
              .reportData.last['connectionGraph'][inClassNumber][1]
              .length;
      i++) {
        relationShip.add(Provider.of<ReportDataManagement>(context, listen: false)
            .reportData.last['connectionGraph'][inClassNumber][1][i]);
        arrowDirection.add(1);
      }
      for (int i = 0;
      i <
          Provider.of<ReportDataManagement>(context, listen: false)
              .reportData.last['connectionGraph'][inClassNumber][2]
              .length;
      i++) {
        relationShip.add(Provider.of<ReportDataManagement>(context, listen: false)
            .reportData.last['connectionGraph'][inClassNumber][2][i]);
        arrowDirection.add(2);
      }


      for (int i = 0; i < context.read<ReportDataManagement>().reportData.last['headCount']; i++) {
        for (int j = 0; j < 3; j++) {
          for (int k = 0;
          k <
              context
                  .read<ReportDataManagement>()
                  .reportData.last['connectionGraph'][i][j]
                  .length;
          k++) {
            allCountConnect++;
          }
        }
        allCountDegreeCentrality +=
        context.read<ReportDataManagement>().reportData.last['degreeCentrality'][i];
        allCountBetweennessCentrality +=
        context.read<ReportDataManagement>().reportData.last['betweennessCentrality'][i];
        allCountClosenessCentrality +=
        context.read<ReportDataManagement>().reportData.last['closenessCentrality'][i];

      }
    });

  }

  @override
  void initState() {
    dataSet();
    headCount = Provider.of<ReportDataManagement>(context, listen: false).reportData.last['headCount'];
    lineCount = (headCount/8).floor();
    modulo = headCount%8;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int j =0;
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
              ReportPageHeader(
                title: '(와/과) 또래 간 연결 및 영향수준',
                changeScreen: widget.changeScreen,
                nextPage: false,
                beforeWidget: widget.beforeWidget,
                name: Provider.of<AttiChildDataManagement>(context, listen: false)
                    .childList[inClassNumber]
                    .name,
              ),
              Expanded(
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView(
                      physics: const RangeMaintainingScrollPhysics(),
                children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 59.w,
                          height: 550.w,
                          color: Color(0xffFCFCFC),
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
                            linkedChild: relationShip,
                            childCount: relationShip.length,
                            arrowDirection: arrowDirection,
                            inClassNumber: inClassNumber,
                          ),
                        ),
                        SizedBox(
                          width: 30.w,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                CustomContainer(
                                  cBorderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.w)),
                                  cLeftBorderWidth: 1.w,
                                  cTopBorderWidth: 1.w,
                                  cTotalWidth: 111.w,
                                  cTotalHeight: 50.w,
                                  cBorderColor: Color(0x6D3BFD7E),
                                  cInsideColor: Color(0xffE2FFE5),
                                  childWidget: Center(
                                    child: Text('연결된 친구 수',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393838),
                                    ),
                                    ),
                                  ),
                                ),
                                CustomContainer(
                                  cLeftBorderWidth: 1.w,
                                  cTopBorderWidth: 1.w,
                                  cTotalWidth: 111.w,
                                  cTotalHeight: 50.w,
                                  cBorderColor: Color(0x6D3BFD7E),
                                  cInsideColor: Color(0xffE2FFE5),
                                  childWidget: Center(
                                    child: Text('연결중심성',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff393838),
                                      ),),
                                  ),
                                ),
                                CustomContainer(
                                  cLeftBorderWidth: 1.w,
                                  cTopBorderWidth: 1.w,
                                  cTotalWidth: 111.w,
                                  cTotalHeight: 50.w,
                                  cBorderColor: Color(0x6D3BFD7E),
                                  cInsideColor: Color(0xffE2FFE5),
                                  childWidget: Center(
                                    child: Text('매개역할 수준',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff393838),
                                      ),),
                                  ),
                                ),
                                CustomContainer(
                                  cBorderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20.w)),
                                  cLeftBorderWidth: 1.w,
                                  cTopBorderWidth: 1.w,
                                  cRightBorderWidth: 1.w,
                                  cTotalWidth: 111.w,
                                  cTotalHeight: 50.w,
                                  cBorderColor: Color(0x6D3BFD7E),
                                  cInsideColor: Color(0xffE2FFE5),
                                  childWidget: Center(
                                    child: Text('영향력 수준',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff393838),
                                      ),),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CustomContainer(
                                  cBorderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20.w)),
                                  cLeftBorderWidth: 1.w,
                                  cBottomBorderWidth: 1.w,
                                  cTotalWidth: 111.w,
                                  cTotalHeight: 50.w,
                                  cBorderColor: Color(0x6D3BFD7E),
                                  cInsideColor: Colors.white,
                                  childWidget: Center(
                                    child: Text(relationShip.length.toString() + "명/" +
                                            (allCountConnect /
                                                context
                                                    .read<ReportDataManagement>()
                                                    .reportData.last['headCount'])
                                                .toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff393838),
                                      ),)
                                  ),
                                ),
                                CustomContainer(
                                  cLeftBorderWidth: 1.w,
                                  cBottomBorderWidth: 1.w,
                                  cTotalWidth: 111.w,
                                  cTotalHeight: 50.w,
                                  cBorderColor: Color(0x6D3BFD7E),
                                  cInsideColor: Colors.white,
                                  childWidget: Center(
                                    child: Text(
                                        context
                                            .read<ReportDataManagement>()
                                            .reportData.last['degreeCentrality'][
                                        inClassNumber]
                                            .toStringAsFixed(2) +
                                            '/' +
                                            (allCountDegreeCentrality /
                                                context
                                                    .read<ReportDataManagement>()
                                                    .reportData.last['headCount'])
                                                .toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff393838),
                                      ),

                                    ),
                                  ),
                                ),
                                CustomContainer(
                                  cLeftBorderWidth: 1.w,
                                  cBottomBorderWidth: 1.w,
                                  cTotalWidth: 111.w,
                                  cTotalHeight: 50.w,
                                  cBorderColor: Color(0x6D3BFD7E),
                                  cInsideColor: Colors.white,
                                  childWidget: Center(
                                    child: Text(
                                                                        context
                                            .read<ReportDataManagement>()
                                            .reportData.last['betweennessCentrality'][
                                        inClassNumber]
                                            .toStringAsFixed(2) +
                                            '/' +
                                            (allCountBetweennessCentrality /
                                                context
                                                    .read<ReportDataManagement>()
                                                    .reportData.last['headCount'])
                                                .toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff393838),
                                      ),
                                    ),
                                  ),
                                ),
                                CustomContainer(
                                  cBorderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20.w)),
                                  cLeftBorderWidth: 1.w,
                                  cBottomBorderWidth: 1.w,
                                  cRightBorderWidth: 1.w,
                                  cTotalWidth: 111.w,
                                  cTotalHeight: 50.w,
                                  cBorderColor: Color(0x6D3BFD7E),
                                  cInsideColor: Colors.white,
                                  childWidget: Center(
                                    child: Text(
                                                                        context
                                            .read<ReportDataManagement>()
                                            .reportData.last['closenessCentrality'][
                                        inClassNumber]
                                            .toStringAsFixed(2) +
                                            '/' +
                                            (allCountClosenessCentrality /
                                                context
                                                    .read<ReportDataManagement>()
                                                    .reportData.last['headCount'])
                                                .toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff393838),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 100.w,
                            ),
                            Container(
                              width: 444.w,
                              child: RichText(
                                text: TextSpan(
                                  text: '우리반에서 또래가 연결된 평균 수는 ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.w,
                                    color: Color(0xff393838),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                    (allCountConnect /
                                    context
                                        .read<ReportDataManagement>()
                                        .reportData.last['headCount'])
                                    .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff393838)),
                                    ),
                                    TextSpan(
                                        text: "명이고, "+

                                                Provider.of<AttiChildDataManagement>(context,listen: false).childList[
                                                inClassNumber].name
                                                +
                                            "(와/과) 연결된 친구는 "),
                                    TextSpan(
                                      text: '총 '+
                                          relationShip.length.toString()+
                                          '명',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff393838)),
                                    ),
                                    TextSpan(text: "입니다."),
                                  ], // textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 34.w,
                            ),
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 11.w,
                                        ),
                                        Container(
                                          width: 8.w,
                                          height: 8.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffA666FC),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 19.w,
                                    ),
                                    Container(
                                      width: 400.w,
                                      child: RichText(
                                        text: TextSpan(
                                          text: Provider.of<AttiChildDataManagement>(context,listen: false).childList[
                                          inClassNumber].name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18.w,
                                            color: Color(0xff393838),
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(text: "(은/는) "),
                                            for (int i = 0; i < Provider.of<ReportDataManagement>(context, listen:  false).reportData.last['connectionGraph'][inClassNumber][0].length; i++) ...[
                                              TextSpan(
                                                text:
                                                Provider.of<IdTo>(context, listen:  false).IdToName(Provider.of<ReportDataManagement>(context, listen:  false).reportData.last['connectionGraph'][inClassNumber][0][i], context)
                                                ,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xff393838)),
                                              ),
                                              if (i != Provider.of<ReportDataManagement>(context, listen:  false).reportData.last['connectionGraph'][inClassNumber][0].length - 1) ...[
                                                TextSpan(
                                                  text: ", ",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      color: Color(0xff393838)),
                                                ),
                                              ]
                                            ],
                                            TextSpan(
                                              text: '(와/과) 긍정적인 관계',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff393838)),
                                            ),
                                            TextSpan(text: "입니다."),
                                          ], // textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 11.w,
                                        ),
                                        Container(
                                          width: 8.w,
                                          height: 8.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffA666FC),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 19.w,
                                    ),
                                    Container(
                                      width: 400.w,
                                      child: RichText(
                                        text: TextSpan(
                                          text: Provider.of<AttiChildDataManagement>(context,listen: false).childList[
                                          inClassNumber].name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18.w,
                                            color: Color(0xff393838),
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(text: "(은/는) "),
                                            for (int i = 0; i < Provider.of<ReportDataManagement>(context, listen:  false).reportData.last['connectionGraph'][inClassNumber][1].length; i++) ...[
                                              TextSpan(
                                                text: Provider.of<IdTo>(context, listen:  false).IdToName(Provider.of<ReportDataManagement>(context, listen:  false).reportData.last['connectionGraph'][inClassNumber][1][i], context),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xff393838)),
                                              ),
                                              if (i != Provider.of<ReportDataManagement>(context, listen:  false).reportData.last['connectionGraph'][inClassNumber][1].length - 1) ...[
                                                TextSpan(
                                                  text: ", ",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      color: Color(0xff393838)),
                                                ),
                                              ]
                                            ],
                                            TextSpan(
                                              text: '에게 관심',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff393838)),
                                            ),
                                            TextSpan(text: "이 있습니다."),
                                          ], // textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 11.w,
                                        ),
                                        Container(
                                          width: 8.w,
                                          height: 8.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffA666FC),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 19.w,
                                    ),
                                    Container(
                                      width: 400.w,
                                      child: RichText(
                                        text: TextSpan(
                                          text: Provider.of<AttiChildDataManagement>(context,listen: false).childList[
    inClassNumber].name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18.w,
                                            color: Color(0xff393838),
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(text: "에게 "),
                                            TextSpan(
                                              text: '관심이 있는 친구는 ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff393838)),
                                            ),
                                            for (int i = 0; i < Provider.of<ReportDataManagement>(context, listen:  false).reportData.last['connectionGraph'][inClassNumber][2].length; i++) ...[
                                              TextSpan(
                                                text: Provider.of<IdTo>(context, listen:  false).IdToName(Provider.of<ReportDataManagement>(context, listen:  false).reportData.last['connectionGraph'][inClassNumber][2][i], context),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xff393838)),
                                              ),
                                              if (i != Provider.of<ReportDataManagement>(context, listen:  false).reportData.last['connectionGraph'][inClassNumber][2].length - 1) ...[
                                                TextSpan(
                                                  text: ", ",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      color: Color(0xff393838)),
                                                ),
                                              ]
                                            ],
                                            TextSpan(text: "입니다."),
                                          ], // textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 11.w,
                                        ),
                                        Container(
                                          width: 8.w,
                                          height: 8.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffA666FC),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 19.w,
                                    ),
                                    Container(
                                      width: 400.w,
                                      child: RichText(
                                        text: TextSpan(
                                          text: Provider.of<AttiChildDataManagement>(context,listen: false).childList[
                                          inClassNumber].name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18.w,
                                            color: Color(0xff393838),
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(text: "(은/는) 학급에서 "),
                                            TextSpan(
                                              text: '중간자 역할빈도가 ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff393838)),
                                            ),


                            if (context.read<ReportDataManagement>().reportData.last['high70_between'] <
                                context
                                    .read<ReportDataManagement>()
                                    .reportData.last['betweennessCentrality'][inClassNumber]) ...[
                              TextSpan(
                                text: '높고', style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff393838)),
                              ),
                            ] else if (context
                                .read<ReportDataManagement>()
                                .reportData.last['high70_between'] >=
                                context
                                    .read<ReportDataManagement>()
                                    .reportData.last['betweennessCentrality'][
                                inClassNumber] &&
                                context
                                    .read<ReportDataManagement>()
                                    .reportData.last['betweennessCentrality'][
                                inClassNumber] >=
                                    context
                                        .read<ReportDataManagement>()
                                        .reportData.last['low70_between']) ...[
                              TextSpan(
                                text: '중간이고', style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff393838)),
                              ),
                            ] else if (context
                                .read<ReportDataManagement>()
                                .reportData.last['betweennessCentrality'][inClassNumber] <=
                                context
                                    .read<ReportDataManagement>()
                                    .reportData.last['low70_between']) ...[
                              TextSpan(
                                text: '낮고', style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff393838)),
                              ),
                            ],
                                            TextSpan(
                                              text: ' 우리반 전체',
                                            ),
                                            TextSpan(
                                              text: ' 또래관계의 영향력은 ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xff393838)),
                                            ),
                            if (context.read<ReportDataManagement>().reportData.last['high70_close'] <=
                                context
                                    .read<ReportDataManagement>()
                                    .reportData.last['closenessCentrality'][inClassNumber]) ...[
                              TextSpan(
                                text: '높은',   style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff393838)),
                              ),
                            ] else if (context
                                .read<ReportDataManagement>()
                                .reportData.last['high70_close'] >=
                                context
                                    .read<ReportDataManagement>()
                                    .reportData.last['closenessCentrality'][inClassNumber] &&
                                context.read<ReportDataManagement>().reportData.last['low70_close'] <
                                    context
                                        .read<ReportDataManagement>()
                                        .reportData.last['closenessCentrality'][
                                    inClassNumber]) ...[
                              TextSpan(
                                text: '중간',   style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff393838)),
                              ),
                            ] else if (context
                                .read<ReportDataManagement>()
                                .reportData.last['low70_close'] >=
                                context
                                    .read<ReportDataManagement>()
                                    .reportData.last['closenessCentrality'][inClassNumber]) ...[
                              TextSpan(
                                text: '낮은',   style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff393838)),
                              ),
                            ],
                            TextSpan(
                              text: '수준입니다.',
                            ),

                                          ], // textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
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
                  ))
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
