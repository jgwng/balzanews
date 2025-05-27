import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      title: title != null
          ? Text(title!,style: AppStyles.w700.copyWith(
            fontSize: 17.fs,
          color: Theme.of(context).colorScheme.surfaceDim
      )): null,
      leading: leading ?? InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios_rounded,
          size: 24,
        ),
      ),
      actions: [
        ...actions,
        if(actions.isNotEmpty)
        SizedBox(
          width: 20,
        )
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.s);
}
