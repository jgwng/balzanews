import 'package:balzanewsweb/model/feed.dart';
import 'package:balzanewsweb/network/balza_repository.dart';
import 'package:http/http.dart' as http;

class HtmlUtil{
 String contentHtml(String content) => '''
      <html lang="ko">
      <head>
        <title></title>
        <style>
          html, body {
            margin: 0;
            padding: 0;
            overflow-x: hidden;
            overflow-y: auto;
            width: 100%;
            height: auto;
            box-sizing: border-box;
          }
          img {
            width: 100%;
            max-width: 100%;
            box-sizing: inherit;
          }
          figure {
            margin: 0;
            padding: 0;
            text-align: center;
          }
          .content{
            margin-left:24px;
            margin-right:24px;
            margin-top:2rem;
          }
        </style>
      </head>
      <body>
        <div class="content" id="contents">
           ${content}
        </div>
        $injectionScript
        </html>
      ''';

 final String injectionScript = '''
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
      
      window.addEventListener('message', receiveMsgFromParent );
      function receiveMsgFromParent(e) {
        if (e.data && e.data.type === 'scrollTop') {
          window.scrollTo({ top: 0, behavior: 'smooth' });
        }
      }
    </script>
  ''';

 Future<String?> convertFeedIntoHtml(Feed? feed, bool useLink) async{
   if(feed == null) return null;

   if(useLink == false){
      return contentHtml(feed.content ?? '');
    }else{
      String? body = await BalzaRepository().getHtml(feed.link);
      if(body == null) return '';

      String htmlWithScript = body.replaceFirst(
        RegExp(r'</body>', caseSensitive: false),
        '$injectionScript</body>',
      );
      return htmlWithScript;
    }
 }
}