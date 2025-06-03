import 'package:balzanewsweb/model/article.dart';
import 'package:balzanewsweb/screens/article_viewer_screen.dart';
import 'package:balzanewsweb/screens/bookmark_screen.dart';
import 'package:balzanewsweb/screens/home_screen.dart';
import 'package:balzanewsweb/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes{
  static const String home = '/';
  static const String article = '/article';
  static const String bookmark = '/bookmark';
  static const String setting = '/setting';

  static GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();
}

final router = GoRouter(
  navigatorKey: AppRoutes.globalKey,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.article,
      builder: (context, state){
        late final Article article;

        if (state.extra is Map<String, dynamic>) {
          final extraMap = state.extra as Map<String, dynamic>;
          if (extraMap['article'] is Map<String, dynamic>) {
            article = Article.fromJson(extraMap['article']);
          } else if (extraMap['article'] is Article) {
            article = extraMap['article'];
          } else {
            throw Exception('Invalid article format');
          }
        } else if (state.extra is Article) {
          article = state.extra as Article;
        } else {
          throw Exception('Invalid state.extra format');
        }
        return ArticleViewerScreen(article: article);
      },
    ),
    GoRoute(
      path: AppRoutes.bookmark,
      builder: (context, state){
        return BookmarkScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.setting,
      builder: (context, state){
        return SettingScreen();
      },
    )
  ],
);
