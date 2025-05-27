import 'dart:async';
import 'package:balzanewsweb/core/consts.dart';
import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/helper/app_theme_helper.dart';
import 'package:balzanewsweb/helper/device_info_helper.dart';
import 'package:balzanewsweb/helper/local_db_helper.dart';
import 'package:balzanewsweb/model/article.dart';
import 'package:balzanewsweb/util/debouncer.dart';
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
  const ArticleViewerScreen({super.key, required this.article});

  final Article article;

  @override
  State<ArticleViewerScreen> createState() => _ArticleViewerScreenState();
}

class _ArticleViewerScreenState extends State<ArticleViewerScreen> {
  late final html.IFrameElement _iFrameElement;
  late final String viewID;
  final ValueNotifier<double> scrollPercentage = ValueNotifier(0);
  final LocalDBHelper db = LocalDBHelper();
  late StreamSubscription<html.MessageEvent> _messageSub;
  bool isReady = false;
  DeBouncer deBouncer = DeBouncer(milliSeconds: 300);

  @override
  void initState() {
    super.initState();
    viewID = 'iframe-${DateTime.now().hashCode}';
    buildIframeElement();
  }

  @override
  void dispose() {
    _messageSub.cancel();
    super.dispose();
  }

  Future<void> buildIframeElement() async {
    String? srcDoc = await HtmlUtil()
        .convertFeedIntoHtml(widget.article, widget.article.useLink);
    if (srcDoc == null) return;

    _iFrameElement = html.IFrameElement()
      ..srcdoc = srcDoc
      ..style.border = 'none'
      ..style.height = '100%'
      ..style.width = '100%';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      viewID,
      (int viewId) => _iFrameElement,
    );
    var isBookmark =
        await db.get(AppKeys.ARTICLE_BOOKMARK_STORE, widget.article.link ?? '');
    if (isBookmark == null) {
      widget.article.bookMarkYN.value = false;
    } else {
      widget.article.bookMarkYN.value = true;
    }
    _messageSub = html.window.onMessage.listen((event) {
      final data = event.data;
      if (data is Map && data['type'] == 'scroll') {
        scrollPercentage.value =
            (data['scrollPercentage'] as num).toDouble() / 100;
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
      backgroundColor: (widget.article.useLink == true)
          ? AppThemeHelper.light.scaffoldBackgroundColor
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: BalzaAppBar(
        title: '기사 읽기',
        actions: [
          if (PlatformUtil.isDebugPWA == true)
            InkWell(
              onTap: () {
                widget.article.bookMarkYN.value =
                    !widget.article.bookMarkYN.value;
                deBouncer.run(onTapBookmarkData);
              },
              child: ValueListenableBuilder(
                  valueListenable: widget.article.bookMarkYN,
                  builder: (_, value, __) {
                    return Icon(
                      widget.article.bookMarkYN.value == true
                          ? Icons.bookmark_outlined
                          : Icons.bookmark_border,
                      size: 28,
                    );
                  }),
            )
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(8.s),
            child: ValueListenableBuilder(
                valueListenable: scrollPercentage,
                builder: (context, value, _) {
                  return ArticleProgressBar(
                    height: 8,
                    duration: 250,
                    percentage: scrollPercentage.value,
                  );
                })),
      ),
      body: PlatformSafeArea(
          child: (isReady == false)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                      horizontal: PlatformUtil.isDesktopWeb ? 0 : 24),
                  child: HtmlElementView(key: UniqueKey(), viewType: viewID),
                )),
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
                  margin: EdgeInsets.only(
                      bottom: DeviceInfoHelper().bottomPadding ?? 0),
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
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void onTapBookmarkData() {
    String store = AppKeys.ARTICLE_BOOKMARK_STORE;
    String key = widget.article.link ?? '';
    if (widget.article.bookMarkYN.value == false) {
      db.delete(store, key);
    } else {
      db.put(store, key, widget.article.toJson());
    }
  }
}
