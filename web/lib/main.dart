import 'package:balzanewsweb/bootstrap.dart';
import 'package:balzanewsweb/helper/app_theme_helper.dart';
import 'package:balzanewsweb/model/article.dart';
import 'package:balzanewsweb/screens/article_viewer_screen.dart';
import 'package:balzanewsweb/screens/bookmark_screen.dart';
import 'package:balzanewsweb/screens/home_screen.dart';
import 'package:balzanewsweb/screens/setting_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() async{
  await bootstrap();
  runApp(DevNewsApp());
}


class DevNewsApp extends StatelessWidget {
  const DevNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppThemeHelper.themeMode,
      builder: (_, mode, __) {
        return MaterialApp.router(
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          routeInformationProvider: _router.routeInformationProvider,
          theme: AppThemeHelper.light,
          darkTheme: AppThemeHelper.dark,
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          scrollBehavior: CustomScrollBehavior(),
        );
      },
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/article',
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
      path: '/bookmark',
      builder: (context, state){
        return BookmarkScreen();
      },
    ),
    GoRoute(
      path: '/setting',
      builder: (context, state){
        return SettingScreen();
      },
    )
  ],
);

class CustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

