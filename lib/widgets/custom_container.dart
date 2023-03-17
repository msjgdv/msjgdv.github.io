import 'package:flutter/material.dart';

class CustomContainer extends StatefulWidget {

  const CustomContainer({
    Key? key,
    this.cBorderColor = Colors.white,
    this.cBorderRadius = BorderRadius.zero,
    this.cShadowColor = const Color(0xFFffffff),
    this.cShadowBlurRadius = 0.0,
    this.cShadowOffset = Offset.zero,
    this.cShadowSpreadRadius = 0.0,
    this.cTotalWidth = 0.0,
    this.cTotalHeight = 0.0,
    this.cTopBorderWidth = 0.0,
    this.cLeftBorderWidth = 0.0,
    this.cRightBorderWidth = 0.0,
    this.cBottomBorderWidth = 0.0,
    this.cInsideColor = const Color(0xFFffffff),
    this.childWidget,
  }) : super(key: key);
  final Color cBorderColor;

  final BorderRadius cBorderRadius;
  final double cTotalWidth;
  final double cTotalHeight;
  final double cTopBorderWidth;
  final double cLeftBorderWidth;
  final double cRightBorderWidth;
  final double cBottomBorderWidth;
  final Color cInsideColor;
  final childWidget;
  final Color cShadowColor;
  final double cShadowSpreadRadius;
  final double cShadowBlurRadius;
  final Offset cShadowOffset;

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.cTotalWidth,
          height: widget.cTotalHeight,
          decoration: BoxDecoration(
              color: widget.cBorderColor,
              borderRadius: widget.cBorderRadius,
              boxShadow: [
                BoxShadow(
                  color: widget.cShadowColor,
                  spreadRadius: widget.cShadowSpreadRadius,
                  blurRadius: widget.cShadowBlurRadius,
                  offset: widget.cShadowOffset,
                )
              ]),
        ),
        Container(
          margin: EdgeInsets.only(
            top: widget.cTopBorderWidth,
            left: widget.cLeftBorderWidth,
            right: widget.cRightBorderWidth,
            bottom: widget.cBottomBorderWidth,
          ),
          width: widget.cTotalWidth - widget.cLeftBorderWidth - widget.cRightBorderWidth,
          height: widget.cTotalHeight - widget.cTopBorderWidth - widget.cBottomBorderWidth,
          decoration: BoxDecoration(
            color: widget.cInsideColor,
            borderRadius: widget.cBorderRadius
          ),
          child: widget.childWidget,
        )
      ],
    );
  }
}
