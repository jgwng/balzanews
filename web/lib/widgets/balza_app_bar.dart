import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:flutter/material.dart';

class BalzaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget> actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  const BalzaAppBar(
      {super.key,
        this.title,
        this.leading,
        this.actions = const [],
        this.bottom
      });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      surfaceTintColor: Colors.white, // Add this to suppress Material 3 default tint
      scrolledUnderElevation: 0,
      title: title != null
          ? Text(title!,style: AppStyles.w700.copyWith(
      fontSize: 24.fs,
      )): null,
      leading: leading,
      actions: actions,
      backgroundColor: Colors.transparent,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.s);
}
