import 'package:balzanewsweb/core/routes.dart';
import 'package:balzanewsweb/model/article.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;
import 'dart:js_util' as js_util;

class NavigationHelper{
  static final NavigationHelper _instance = NavigationHelper._internal();

  factory NavigationHelper() => _instance;

  NavigationHelper._internal();
  void initMoving(){
    final state = js_util.getProperty(html.window, 'messageData');

    if (state == null) {
      debugPrint('❌ window.messageData is null');
      return;
    } else {
      final type = js_util.getProperty(state, 'type');
      if (type == 'moveScreen') {
        moveScreen(state['url'] ?? '');
      }
      js_util.setProperty(html.window, 'messageData', null);
    }
  }

  void moveScreen(String url){
    if(url.isEmpty) return;

    final context = AppRoutes.globalKey.currentContext;
    if(context == null) return;

    final uri = Uri.parse(url);
    final path = uri.path;
    final queryParameters = uri.queryParameters;

    final String currentUrl = GoRouterState.of(context).uri.toString();

    if(currentUrl == path){
      return;
    }

    switch(path){
      case AppRoutes.bookmark:
        context.push(AppRoutes.bookmark);
        return;
      case AppRoutes.setting:
        context.push(AppRoutes.setting);
        return;
      case AppRoutes.article:
        context.push(AppRoutes.article,extra: {
          'article' : Article(
            useLink: true,
            link: queryParameters['link'],
            techCorp: queryParameters['techCorp']
          )
        });
    }
  }
}