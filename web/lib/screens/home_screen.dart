import 'package:balzanewsweb/core/consts.dart';
import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/model/feed.dart';
import 'package:balzanewsweb/network/balza_repository.dart';
import 'package:balzanewsweb/screens/article_viewer_screen.dart';
import 'package:balzanewsweb/util/device_util.dart';
import 'package:balzanewsweb/util/platform_util.dart';
import 'package:balzanewsweb/widgets/bottomSheet/corp_select_bottom_sheet.dart';
import 'package:balzanewsweb/util/platform/general/general_safe_area.dart'
if (dart.library.html) 'package:balzanewsweb/util/platform/web/web_safe_area.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  List<Feed> topStories = [];
  Future? initData;
  int selectedIndex = 8;
  var techCorp = TechCorps.values[8];
  BalzaRepository repository = BalzaRepository();
  double? bottomPadding = 0;
  @override
  void initState() {
    initData = fetchArticles();
    if(PlatformUtil.isPWA){
      bottomPadding = (bottomInset()+24).s;
    }else{
      bottomPadding = 24.s;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          '',
          style: TextStyle(fontFamily: AppFonts.bold),
        ),
      ),
      body: PlatformSafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.s),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              balzaTitle('현재 신문사'),
              buildCurrentCorp(),
              SizedBox(
                height: 8.s,
              ),
              balzaTitle('주요 뉴스'),
              buildArticles(),
              SizedBox(
                height: bottomPadding ?? 24.s,
              )
            ],
          ),
        )
      ),
    );
  }

  Widget balzaTitle(String text){
    return Padding(
      padding: EdgeInsets.only(top: 28.s, bottom: 12.s),
      child: Text(
        text,
        style: AppStyles.w700.copyWith(
          fontSize: 20.fs
        ),
      ),
    );
  }

  Widget buildCurrentCorp(){
    return InkWell(
      onTap: onTapCorpSelect,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: AppThemes.borderColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              techCorp.name,
              style: AppStyles.w700.copyWith(
                fontSize: 16.fs
              )
            ),
            Icon(
              Icons.arrow_drop_down_sharp,
              size: 24,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  Widget buildArticles(){
    return FutureBuilder(
      future: initData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (topStories.isEmpty) {
          return const SizedBox();
        }
        return ListView.separated(
          itemCount: topStories.length,
          shrinkWrap: true,
          primary: false,
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 12.s,
            );
          },
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () => onTapArticleSelect(index),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.s, vertical: 12.s),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: AppThemes.borderColor)),
                  child: Text(
                    (topStories[index].title ?? '')
                        .replaceAll('&amp;', ''),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.w700.copyWith(
                      fontSize: 16.fs
                    ),
                  ),
                ));
          },
        );
      },
    );
  }
  Future<void> fetchArticles() async{
    var articles = await repository.getArticles(techCorp.rssUrl);
    setState(() {
      topStories = articles;
    });
  }
  void onTapCorpSelect() async{
    var result = await showCorpSelectBottomSheet(context);
    if (result != null) {
      if (selectedIndex == result) return;
      selectedIndex = result;
      techCorp = TechCorps.values[result];
      fetchArticles();
    }
  }

  void onTapArticleSelect(int index){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ArticleViewerScreen(
                feed: topStories[index],
                useLink: techCorp.useLink,
              )));
  }
}
