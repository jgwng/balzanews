import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/util/device_padding.dart';
import 'package:balzanewsweb/util/platform_util.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../core/resources.dart';

class BalzaArticleViewer extends StatelessWidget {
   BalzaArticleViewer(
      {super.key, this.body, this.scrollPercentage, this.onTapFab}){
    if(PlatformUtil.isPWA){
      bottomPadding = bottomInset();
    }
  }

  double? bottomPadding;

  final Widget? body;
  final ValueNotifier<double>? scrollPercentage;
  final VoidCallback? onTapFab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white, // Add this to suppress Material 3 default tint
        scrolledUnderElevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: 24,
          ),
        ),
        title:  Text("기사 읽기",style: AppStyles.w700.copyWith(
          fontSize: 24.fs,
        )),
        bottom: bottomWidget(),
      ),
      body: body ?? const SizedBox(),
      floatingActionButton: fab(),
    );
  }

  PreferredSize? bottomWidget() {
    if (scrollPercentage == null) return null;

    return PreferredSize(
      preferredSize: const Size.fromHeight(4),
      child: ValueListenableBuilder<double>(
        valueListenable: scrollPercentage!,
        builder: (context, value, _) => LinearProgressIndicator(
          value: value.clamp(0, 1),
          backgroundColor: Colors.grey[300],
          color: Theme.of(context).primaryColor,
          minHeight: 4,
        ),
      ),
    );
  }

  Widget? fab() {
    if (scrollPercentage == null) {
      return null;
    }
    return PointerInterceptor(
      child: ValueListenableBuilder<double>(
        valueListenable: scrollPercentage!,
        builder: (context, value, _) {
          if (value >= 0.05) {
            return Material(
              type: MaterialType.transparency,
              borderRadius: BorderRadius.circular(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(8.0),
                splashColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                onTap: () {
                  if(onTapFab != null){
                    onTapFab!();
                  }
                },
                child: Container(
                  width: 56,
                  height: 56,
                  margin: EdgeInsets.only(bottom: bottomPadding ?? 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Color(0xFFDDDDDD),
                    ),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: 42,
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
