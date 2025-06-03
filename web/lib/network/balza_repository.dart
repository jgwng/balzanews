import 'dart:convert';
import 'package:balzanewsweb/model/article.dart';
import 'package:balzanewsweb/network/balza_client.dart';
import 'package:http/http.dart' as http;

class BalzaRepository {
  static final BalzaRepository _instance = BalzaRepository._internal();

  factory BalzaRepository() => _instance;

  late final http.Client _client;

  BalzaRepository._internal() {
    _client = InterceptedClient(http.Client());
  }

  Future<List<Article>?> getArticles(String url, {int? pageSize}) async {
    try{
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
      final response = await _client.get(uri);

      if (response.statusCode != 200) {
        return [];
      }

      var data = json.decode(response.body);
      List items = data['items'] ?? [];
      return items.map<Article>((e) => Article.fromJson(e)).toList();
    }catch(e){
      return null;
    }
  }

  Future<String?> getHtml(String? url) async {
    try{
      if (url == null) return null;

      final uri = Uri.https('balzanewss.web.app', '/proxy', {'url': url});
      final response = await _client.get(uri);

      if (response.statusCode != 200) return null;
      return response.body;
    }catch(e){
      return null;
    }
  }
}

