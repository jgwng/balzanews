import 'dart:convert';
import 'package:balzanewsweb/model/article.dart';
import 'package:http/http.dart' as http;

class BalzaRepository {
  static final BalzaRepository _instance = BalzaRepository._internal();

  factory BalzaRepository() {
    return _instance;
  }

  BalzaRepository._internal() {}

  Future<List<Article>> getArticles(String url, {int? pageSize}) async {
    const String apiKey = String.fromEnvironment("API_KEY");
    var queryParameters = {
      'rss_url': url,
      'count': '${pageSize ?? 25}',
      'api_key': apiKey,
    };

    if (apiKey.isEmpty) {
      queryParameters.removeWhere((key, value) => key != 'rss_url');
    }

    final uri = Uri.https('api.rss2json.com', '/v1/api.json', queryParameters);
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      return [];
    }
    var data = json.decode(response.body);
    List items = data['items'] ?? [];
    List<Article> articles =
        items.map((element) => Article.fromJson(element)).toList();
    return articles;
  }

  Future<String?> getHtml(String? url) async {
    if (url == null) return null;
    final queryParameters = {'url': url};
    final uri = Uri.https('balzanewss.web.app', '/proxy', queryParameters);
    final response = await http.get(uri);
    if (response.statusCode != 200) return null;
    return response.body;
  }
}
