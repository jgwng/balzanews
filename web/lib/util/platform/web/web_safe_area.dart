
import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/util/device_padding.dart';
import 'package:balzanewsweb/util/platform_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformSafeArea extends StatefulWidget {
  const PlatformSafeArea(
      {super.key,
        this.top,
        this.bottom,
        this.left,
        this.right,
        this.maintainBottomViewPadding,
        this.child});
  final bool? top;
  final bool? bottom;
  final bool? left;
  final bool? right;
  final bool? maintainBottomViewPadding;
  final Widget? child;

  @override
  _PlatformSafeAreaState createState() => _PlatformSafeAreaState();
}

class _PlatformSafeAreaState extends State<PlatformSafeArea> {
  double bottom = 34;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bottom = bottomInset();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (PlatformUtil.isPWA) {
      return Container(
        color: AppThemes.backgroundColor,
        margin: EdgeInsets.only(bottom: (widget.bottom ?? true) ? bottom : 0),
        child: widget.child ?? Container(),
      );
    }
    return SafeArea(
      top: widget.top ?? true,
      bottom: widget.bottom ?? true,
      left: widget.left ?? true,
      right: widget.right ?? true,
      child: widget.child ?? Container(),
    );
  }
}
