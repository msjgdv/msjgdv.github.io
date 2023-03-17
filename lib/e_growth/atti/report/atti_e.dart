import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:treasure_map/provider/report_data_management.dart';

import '../widget/peer_graphview.dart';
import '../widget/report_page_header.dart';

class AttiE extends StatefulWidget {
  const AttiE({
    Key? key,
    required this.changeScreen,
    this.beforeWidget,
    this.name = "",
  }) : super(key: key);
  final Function(Widget) changeScreen;
  final Widget? beforeWidget;
  final String name;

  @override
  State<AttiE> createState() => _AttiEState();
}

class _AttiEState extends State<AttiE> {

  List<List<int>> networkEdge = [];
  List<int> networkAloneEdge = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    networkAloneEdge =  Provider.of<ReportDataManagement>(context,
        listen: false)
        .reportData.last['positiveNetworkAloneEdge'].cast<int>();
    // var networkEdgeFromJson = Provider.of<ReportDataManagement>(context,
    //     listen: false)
    //     .reportData.last['positiveNetworkEdge'].cast<List<int>>();
    // networkEdge = List<List<int>>.from(networkEdgeFromJson);
    for(int i = 0;i<Provider.of<ReportDataManagement>(context,
        listen: false)
        .reportData.last['positiveNetworkEdge'].length;i++){
      networkEdge.add([]);
      networkEdge[i] = Provider.of<ReportDataManagement>(context,
          listen: false)
          .reportData.last['positiveNetworkEdge'][i].cast<int>();
    }

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.w),
          bottomLeft: Radius.circular(50.w),
        ),
        color: Color(0xffFCFCFC),
      ),
      child: Column(
        children: [
          Container(
            // color: Color(0xfffcfcfc),
            height: 50.w,
          ),
          ReportPageHeader(
            title: '우리반 또래관계도',
            changeScreen: widget.changeScreen,
            nextPage: false,
            beforeWidget: widget.beforeWidget,
          ),
          Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: ListView(
                  physics: const RangeMaintainingScrollPhysics(),
            children: [
                Row(
                  children: [
                    Container(
                      width: 59.w,
                      color: Color(0xffFCFCFC),
                      height: 550.w,
                    ),
                    Container(
                      width: 1021.w,
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
                      child: Container(
                        margin: EdgeInsets.all(50.w),
                        // width: 800.w,
                        // height: 400.w,
                        child: GraphClusterViewPage(
                          NetworkEdge: networkEdge,
                          NetWorkAloneEdge: networkAloneEdge,
                        ),
                      ),
                    ),
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
    );
  }
}
