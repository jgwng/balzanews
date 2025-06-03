import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:html' as html;
class InterceptedClient extends http.BaseClient {
  final http.Client _inner;

  InterceptedClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {

    bool isConnected = html.window.navigator.onLine ?? false;
    if(isConnected == false){
      throw SocketException('No Connection Worked');
    }
    final response = await _inner.send(request);
    return response;
  }
}
