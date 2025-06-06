import 'dart:js_interop_unsafe';

import 'package:balzanewsweb/core/consts.dart';
import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/routes.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/helper/app_theme_helper.dart';
import 'package:balzanewsweb/helper/device_info_helper.dart';
import 'package:balzanewsweb/helper/local_db_helper.dart';
import 'package:balzanewsweb/helper/pwa_install_helper.dart';
import 'package:balzanewsweb/model/article.dart';
import 'package:balzanewsweb/network/balza_repository.dart';
import 'package:balzanewsweb/util/platform_util.dart';
import 'package:balzanewsweb/widgets/animated_list_view.dart';
import 'package:balzanewsweb/widgets/balza_app_bar.dart';
import 'package:balzanewsweb/widgets/balza_button.dart';
import 'package:balzanewsweb/widgets/bottomSheet/corp_select_bottom_sheet.dart';
import 'package:balzanewsweb/util/platform/general/general_safe_area.dart'
    if (dart.library.html) 'package:balzanewsweb/util/platform/web/web_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:js' as js;
import 'dart:html' as html;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Article>? topStories;

  Future? initData;
  int selectedIndex = 0;
  BalzaRepository repository = BalzaRepository();
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  late ValueNotifier<TechCorps> techCorp;
  double? bottomPadding = 0;
  PWAInstallHelper installHelper = PWAInstallHelper();
  @override
  void initState() {
    String lastIndex = html.window.localStorage[AppKeys.LAST_SELECT_CORP_INDEX] ?? '0';
    selectedIndex = int.tryParse(lastIndex) ?? 0;
    techCorp = ValueNotifier(TechCorps.values[selectedIndex]);
    initData = fetchArticles();
    bottomPadding = (DeviceInfoHelper().bottomPadding ?? 0 + 24).s;
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      js.context.callMethod('clearAppBadge');
      await Future.delayed(Duration(milliseconds: 400));
      if (installHelper.shouldShowPwaBanner) {
        installHelper.showBanner();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BalzaAppBar(
        leading: const SizedBox(),
        actions: actions(),
      ),
      body: PlatformSafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.s),
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            balzaTitle('현재 신문사'),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 12.s,
              ),
            ),
            buildCurrentCorp(),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 8.s,
              ),
            ),
            balzaTitle('주요 뉴스'),
            buildArticles(),
            if(topStories?.isNotEmpty ?? false)
            SliverToBoxAdapter(
              child: SizedBox(
                height: bottomPadding ?? 24.s,
              ),
            ),
          ],
        ),
      )),
    );
  }

  List<Widget> actions(){
    if(PlatformUtil.isDebugPWA){
      return [
          InkWell(
            onTap: () {
              AppRoutes.globalKey.currentContext!.push(AppRoutes.bookmark);
            },
            child: Icon(
              Icons.bookmark_rounded,
              size: 28.s,
            ),
          ),
        SizedBox(
          width: 20.s,
        ),
        InkWell(
          onTap: () {
            context.push(AppRoutes.setting);
          },
          child: Icon(
            Icons.settings,
            size: 28.s,
          ),
        )
      ];
    }
    return [
      InkWell(
        onTap: () {
          AppThemeHelper.change();
        },
        child: Icon(
          AppThemeHelper.themeMode.value == ThemeMode.light
              ? Icons.dark_mode
              : Icons.light_mode,
          size: 28.s,
        ),
      )
    ];
  }

  Widget balzaTitle(String text) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 28.s),
        child: Text(
          text,
          style: AppStyles.w700.copyWith(
              color: Theme.of(context).colorScheme.surfaceDim,
              fontSize: 20.fs),
        ),
      ),
    );
  }

  Widget buildCurrentCorp() {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: onTapCorpSelect,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.s),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AppThemes.borderColor)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueListenableBuilder(
                  valueListenable: techCorp,
                  builder: (context, value, _) {
                    return Text(value.name,
                        style: AppStyles.w700.copyWith(
                            color: Theme.of(context).colorScheme.surfaceDim,
                            fontSize: 16.fs));
                  }),
              Icon(
                Icons.arrow_drop_down_sharp,
                size: 24.s,
                color: Theme.of(context).colorScheme.surfaceDim,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildArticles() {
    return ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, value, _) {
          if (value == true) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppThemes.pointColor,
                ),
              ),
            );
          }
          if(topStories == null){
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 80.s,
                  ),
                  SizedBox(
                    height: 16.s,
                  ),
                  Text('네트워크에 접속할 수 없습니다.',style: AppStyles.w700.copyWith(
                    fontSize: 20.fs,
                  )),
                  SizedBox(
                    height: 8.s,
                  ),
                  Text('네트워크 연결 상태를 확인해주세요.',style: AppStyles.w500.copyWith(
                      fontSize: 16.fs
                  )),
                  SizedBox(
                    height: 16.s,
                  ),
                  BalzaButton(
                    onPressed: fetchArticles,
                    width: 160.s,
                    height: 52.s,
                    buttonText: '다시 불러오기',
                    backgroundColor: AppThemes.pointColor,
                  )
                ],
              ),
            );
          }
          if (topStories?.isEmpty ?? true) {
            return SliverToBoxAdapter(
              child: const SizedBox(),
            );
          }
          return SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 12.s),
              child: AnimatedStaggeredListView(
                articleList: topStories!,
                onTapItem: (index) => onTapArticleSelect(index),
              ),
            ),
          );
        });
  }

  Future<void> fetchArticles() async {
    isLoading.value = true;
    var articles = await repository.getArticles(techCorp.value.rssUrl);

    if(articles == null){
      isLoading.value = false;
      return;
    }

    topStories = articles;
    for (Article article in topStories!) {
      article.useLink = techCorp.value.useLink;
      if(PlatformUtil.isDebugPWA == true){
        var result = await LocalDBHelper().get(AppKeys.ARTICLE_HISTORY_STORE, article.link ?? '');
        if (result != null) {
          article.readYn.value = true;
        } else {
          article.readYn.value = false;
        }
      }
    }
    isLoading.value = false;
  }

  void onTapCorpSelect() async {
    var result = await showCorpSelectBottomSheet(context);
    if (result != null) {
      if (selectedIndex == result) return;
      selectedIndex = result;
      html.window.localStorage[AppKeys.LAST_SELECT_CORP_INDEX] = '$selectedIndex';
      techCorp.value = TechCorps.values[result];
      fetchArticles();
    }
  }

  void onTapArticleSelect(int index) {
    Article article = topStories![index];
    article.techCorp = techCorp.value.name;
    if (article.readYn.value == false) {
      article.readYn.value = true;
      LocalDBHelper().put(
          AppKeys.ARTICLE_HISTORY_STORE, article.link ?? '', article.toJson());
    }
    context.push(AppRoutes.article,extra: {
      'article' : article
    });
  }
}
