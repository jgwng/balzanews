import 'dart:async';
import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/helper/device_info_helper.dart';
import 'package:balzanewsweb/model/article.dart';
import 'package:balzanewsweb/util/device_util.dart';
import 'package:balzanewsweb/util/html_util.dart';
import 'package:balzanewsweb/widgets/article_progress_bar.dart';
import 'package:balzanewsweb/widgets/balza_app_bar.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:html' as html;

import 'package:http/http.dart' as http;
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:balzanewsweb/util/platform/general/general_safe_area.dart'
if (dart.library.html) 'package:balzanewsweb/util/platform/web/web_safe_area.dart';
import '../util/platform_util.dart';

class ArticleViewerScreen extends StatefulWidget {
  const ArticleViewerScreen({super.key, this.feed,this.useLink});
  final Article? feed;
  final bool? useLink;

  @override
  State<ArticleViewerScreen> createState() => _ArticleViewerScreenState();
}

class _ArticleViewerScreenState extends State<ArticleViewerScreen> {
  late final html.IFrameElement _iFrameElement;
  late final String viewID;
  final ValueNotifier<double> scrollPercentage = ValueNotifier(0);
  late StreamSubscription<html.MessageEvent> _messageSub;
  bool isReady = false;

  @override
  void initState(){
    super.initState();
    viewID = 'iframe-${widget.feed?.link?.hashCode ?? ''}';
    buildIframeElement();
  }

  @override
  void dispose(){
    _messageSub.cancel();
    super.dispose();
  }

  Future<void> buildIframeElement() async{
    if(widget.feed == null) return;
    String? srcDoc = await HtmlUtil().convertFeedIntoHtml(widget.feed, widget.useLink ?? false);
    if(srcDoc == null) return;

    _iFrameElement = html.IFrameElement()
      ..srcdoc = srcDoc
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      viewID,
          (int viewId) => _iFrameElement,
    );

    _messageSub = html.window.onMessage.listen((event) {
      final data = event.data;
      if (data is Map && data['type'] == 'scroll') {
        scrollPercentage.value = (data['scrollPercentage'] as num).toDouble() / 100;
      }
    });

    setState(() {
      isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: BalzaAppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: 24,
          ),
        ),
        title: '기사 읽기',
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(8.s),
            child: ValueListenableBuilder(
                valueListenable: scrollPercentage,
                builder: (context,value,_){
                  return ArticleProgressBar(
                    height: 8,
                    duration: 250,
                    percentage: scrollPercentage.value,
                  );
                })),
      ),
      body: PlatformSafeArea(
          child: (isReady == false) ? Center(
            child: CircularProgressIndicator(),
          ) :  HtmlElementView(viewType: viewID)
      ),
      floatingActionButton: fab(),
    );
  }

  Widget? fab() {
    return PointerInterceptor(
      child: ValueListenableBuilder<double>(
        valueListenable: scrollPercentage,
        builder: (context, value, _) {
          return AnimatedOpacity(
            curve: Curves.linear,
            opacity: value >= 0.05 ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: Material(
              type: MaterialType.transparency,
              borderRadius: BorderRadius.circular(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(8.0),
                splashColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                onTap: () {
                  _iFrameElement.contentWindow?.postMessage({
                    'type': 'scrollTop',
                  }, '*');
                },
                child: Container(
                  width: 56.s,
                  height: 56.s,
                  margin: EdgeInsets.only(bottom: DeviceInfoHelper().bottomPadding ?? 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: AppThemes.borderColor,
                    ),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: 42,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}



