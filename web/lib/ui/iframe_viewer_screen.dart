import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:flutter_html/flutter_html.dart';

class IframeWidget extends StatefulWidget {
  final String link;

  const IframeWidget({super.key, required this.link});

  @override
  State<IframeWidget> createState() => _IframeWidgetState();
}

class _IframeWidgetState extends State<IframeWidget> {
  late final html.IFrameElement _iFrameElement;
  late final String viewID;
  final ValueNotifier<double> scrollPercentage = ValueNotifier(0);
  late StreamSubscription<html.MessageEvent> _messageSub;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    viewID = 'iframe-${widget.link.hashCode}';
    testFunction();
  }

  Future<void> testFunction() async {
    final String proxyUrl = 'https://proxy-wq2lg5j6kq-uc.a.run.app/proxy?url=${Uri.encodeComponent('https://medium.com/p/de149ad7b7f6')}';
    final String localUrl = 'https://balzanewss.web.app/proxy?url=${widget.link}';
    final result = await http.get(Uri.parse(localUrl));
    final injectionScript = '''
    <script>
      window.addEventListener('scroll', () => {
        const scrollTop = window.scrollY || document.documentElement.scrollTop;
        const scrollHeight = document.documentElement.scrollHeight;
        const clientHeight = window.innerHeight;

        const scrollPercentage = Math.min(100,
          Math.round((scrollTop / (scrollHeight - clientHeight)) * 100)
        );

        parent.postMessage({
          type: 'scroll',
          y: scrollTop,
          scrollPercentage: scrollPercentage
        }, '*');
      });
    </script>
  ''';

    // ✅ Inject the script into HTML body
    String htmlWithScript = result.body.replaceFirst(
      RegExp(r'</body>', caseSensitive: false),
      '$injectionScript</body>',
    );

    _iFrameElement = html.IFrameElement()
      ..srcdoc = htmlWithScript
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
  void dispose(){
    _messageSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: 24,
          ),
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
      body:  (isReady == false) ? Center(
        child: CircularProgressIndicator(),
      ) : HtmlElementView(viewType: viewID),
    );
  }
}
