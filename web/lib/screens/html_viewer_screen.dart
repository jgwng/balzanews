import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/util/platform/general/general_safe_area.dart'
if (dart.library.html) 'package:balzanewsweb/util/platform/web/web_safe_area.dart';
import 'package:balzanewsweb/widgets/balza_article_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
    return BalzaArticleViewer(
      scrollPercentage: scrollPercentage,
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
      onTapFab: (){
        scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.linear,
        );
      },
    );
  }
}
