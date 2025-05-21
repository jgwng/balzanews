import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/util/platform/general/general_safe_area.dart'
if (dart.library.html) 'package:balzanewsweb/util/platform/web/web_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/util/platform_util.dart';
import 'package:balzanewsweb/util/device_padding.dart';

class HtmlIframeViewer extends StatefulWidget {
  final String htmlContent;

  HtmlIframeViewer({required this.htmlContent});

  @override
  _HtmlIframeViewerState createState() => _HtmlIframeViewerState();
}

class _HtmlIframeViewerState extends State<HtmlIframeViewer> {
  final String fontFamily = AppFonts.medium;
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<double> scrollPercentage = ValueNotifier(0);
  double? bottom;
  @override
  void initState() {
    super.initState();
    if(PlatformUtil.isPWA){
      bottom = bottomInset();
    }
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    scrollPercentage.dispose();
    super.dispose();
  }

  void scrollListener() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (maxScroll > 0) {
      final percentage = (currentScroll / maxScroll);
      scrollPercentage.value = percentage;
      print('Scroll Percentage: ${(percentage * 100).toStringAsFixed(2)}%');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
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
          )
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: ValueListenableBuilder<double>(
            valueListenable: scrollPercentage,
            builder: (context, value, _) =>
                LinearProgressIndicator(
                  value: value.clamp(0, 1),
                  backgroundColor: Colors.grey[300],
                  color: Theme.of(context).primaryColor,
                  minHeight: 4,
                ),
          ),
        ),
      ),
      body: PlatformSafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child:  Html(
            data: widget.htmlContent,
            style: {
              "p": Style(
                  padding: HtmlPaddings.all(6),
                  color: Colors.black,
                  fontFamily: fontFamily,
                  fontSize: FontSize.medium),
              "h1": Style(
                  padding: HtmlPaddings.all(6),
                  color: Colors.black,
                  fontFamily: fontFamily,
                  fontSize: FontSize.xLarge),
              "h2": Style(
                  padding: HtmlPaddings.all(6),
                  color: Colors.black,
                  fontFamily: fontFamily,
                  fontSize: FontSize.xLarge),
              "h4": Style(
                  padding: HtmlPaddings.all(6),
                  color: Colors.black,
                  fontFamily: fontFamily,
                  fontSize: FontSize.xLarge),
              "h5": Style(
                  padding: HtmlPaddings.all(6),
                  color: Colors.black,
                  fontFamily: fontFamily,
                  fontSize: FontSize.xLarge),
              "h6": Style(
                  padding: HtmlPaddings.all(6),
                  color: Colors.black,
                  fontFamily: fontFamily,
                  fontSize: FontSize.xLarge),
              "em": Style(
                  padding: HtmlPaddings.zero,
                  color: Colors.black,
                  fontFamily: fontFamily),
              "blockquote em": Style(
                  padding: HtmlPaddings.zero,
                  color: Colors.black,
                  fontFamily: fontFamily,
                  fontStyle: FontStyle.normal),
              "blockquote": Style(
                  color: Colors.black,
                  padding: HtmlPaddings.zero,
                  fontFamily: fontFamily),
            },
          ),
        ),
      ),
      floatingActionButton: ValueListenableBuilder<double>(
        valueListenable: scrollPercentage,
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
                  scrollController.animateTo(
                    0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.linear,
                  );
                },
                child: Container(
                  width: 56,
                  height: 56,
                  margin: EdgeInsets.only(bottom: bottom ?? 0),
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
