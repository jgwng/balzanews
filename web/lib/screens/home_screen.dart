import 'package:balzanewsweb/core/consts.dart';
import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/helper/device_info_helper.dart';
import 'package:balzanewsweb/model/article.dart';
import 'package:balzanewsweb/network/balza_repository.dart';
import 'package:balzanewsweb/screens/article_viewer_screen.dart';
import 'package:balzanewsweb/widgets/animated_list_view.dart';
import 'package:balzanewsweb/widgets/balza_app_bar.dart';
import 'package:balzanewsweb/widgets/bottomSheet/corp_select_bottom_sheet.dart';
import 'package:balzanewsweb/util/platform/general/general_safe_area.dart'
if (dart.library.html) 'package:balzanewsweb/util/platform/web/web_safe_area.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  List<Article> topStories = [];
  Future? initData;
  int selectedIndex = 0;
  BalzaRepository repository = BalzaRepository();
  ValueNotifier<bool> isLoading= ValueNotifier(true);
  late ValueNotifier<TechCorps> techCorp;
  double? bottomPadding = 0;

  @override
  void initState() {
    techCorp= ValueNotifier(TechCorps.values[selectedIndex]);
    initData = fetchArticles();
    bottomPadding = (DeviceInfoHelper().bottomPadding ?? 0 + 24).s;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BalzaAppBar(
        actions: [
          InkWell(
            onTap: (){},
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.settings,
                size: 28,
              ),
            ),
          )
        ],
      ),
      body: PlatformSafeArea(
          child : Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.s),
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: [
                balzaTitle('현재 신문사'),
                buildCurrentCorp(),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 8.s,
                  ),
                ),
                balzaTitle('주요 뉴스'),
                buildArticles(),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: bottomPadding ?? 24.s,
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

  Widget balzaTitle(String text){
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 28.s, bottom: 12.s),
        child: Text(
          text,
          style: AppStyles.w700.copyWith(
              fontSize: 20.fs
          ),
        ),
      ),
    );
  }

  Widget buildCurrentCorp(){
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
                  builder: (context,value,_){
                    return Text(
                        value.name,
                        style: AppStyles.w700.copyWith(
                            fontSize: 16.fs
                        )
                    );
                  }),
              Icon(
                Icons.arrow_drop_down_sharp,
                size: 24.s,
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildArticles(){
    return ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context,value,_){
          if(value == true){
            return SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (topStories.isEmpty) {
            return SliverToBoxAdapter(
              child: const SizedBox(),
            );
          }
          return SliverToBoxAdapter(
            child: AnimatedStaggeredListView(
              articleList: topStories,
            ),
          );
        });
  }

  Future<void> fetchArticles() async{
    isLoading.value = true;
    var articles = await repository.getArticles(techCorp.value.rssUrl);
    topStories = articles;
    isLoading.value = false;
  }

  void onTapCorpSelect() async{
    var result = await showCorpSelectBottomSheet(context);
    if (result != null) {
      if (selectedIndex == result) return;
      selectedIndex = result;
      techCorp.value = TechCorps.values[result];
      fetchArticles();
    }
  }
}
