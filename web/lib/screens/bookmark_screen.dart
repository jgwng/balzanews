import 'package:balzanewsweb/core/consts.dart';
import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/routes.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/helper/local_db_helper.dart';
import 'package:balzanewsweb/model/article.dart';
import 'package:balzanewsweb/widgets/animated_list_view.dart';
import 'package:balzanewsweb/widgets/balza_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final LocalDBHelper db = LocalDBHelper();
  final ValueNotifier<bool> isLoading = ValueNotifier(true);
  List<Article> totalArticles = [];
  ValueNotifier<List<Article>> articles = ValueNotifier([]);
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  final ValueNotifier<List<String>> corps = ValueNotifier(['전체']);

  @override
  void initState(){
    super.initState();
    getBookmarkArticles();
  }

  Future<void> getBookmarkArticles() async{
    isLoading.value = true;
    totalArticles = await db.getAllValues(AppKeys.ARTICLE_BOOKMARK_STORE);
    articles.value = totalArticles;
    for(Article article in totalArticles){
      String techCorp = article.techCorp ?? '';
      if(corps.value.contains(techCorp) == false){
        corps.value.add(techCorp);
      }
    }
    isLoading.value = false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BalzaAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.s),
        child: CustomScrollView(
          slivers: [
            buildCorps(),
            buildArticles()
          ],
        ),
      ),
    );
  }

  Widget buildCorps(){
    return ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, value, _) {
          if (value == true) {
            return SliverFillRemaining(
              child: const SizedBox(),
            );
          }
          if(totalArticles.isEmpty){
            return SliverToBoxAdapter(
              child: const SizedBox(),
            );
          }
          if (articles.value.isEmpty) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wysiwyg,
                    size: 128,
                    color: Theme.of(context).colorScheme.surfaceDim,
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  Text(
                    '지금은 아무것도 없지만,\n곧 당신만의 기술 도서관이 채워질 거예요.',
                    textAlign: TextAlign.center,
                    style: AppStyles.w700.copyWith(
                      color: Theme.of(context).colorScheme.surfaceDim,
                      fontSize: 20.fs,
                    ),
                  ),
                ],
              ),
            );
          }
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 52.s,
              child: ValueListenableBuilder(
                  valueListenable: corps,
                  builder: (_,value,__){
                    return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 10.s),
                        itemBuilder: (ctx,index){
                          return InkWell(
                            onTap: () => onTapTechCorp(index),
                            child: ValueListenableBuilder(
                                valueListenable: currentIndex,
                                builder: (_,value,__){
                                  return Container(
                                    height: 40.s,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(horizontal: 12.s),
                                    decoration: BoxDecoration(
                                        color: index == currentIndex.value ? AppThemes.pointColor : AppThemes.pointColor.withAlpha(40),
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Text(
                                      corps.value[index],
                                      textAlign: TextAlign.center,
                                      style: AppStyles.w700.copyWith(
                                        color: index == currentIndex.value ? Colors.white : AppThemes.fontColor,
                                      ),
                                    ),
                                  );
                                }),
                          );
                        },
                        separatorBuilder: (ctx,i){
                          return SizedBox(
                            width: 8.s,
                          );
                        },
                        itemCount: corps.value.length);
                  }),
            ),
          );
        });
  }
  Widget buildArticles() {
    return ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, value, _) {
          if (value == true) {
            return SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (articles.value.isEmpty) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      Icons.wysiwyg,
                      size: 128,
                      color: Theme.of(context).colorScheme.surfaceDim,
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  Text(
                    '지금은 아무것도 없지만,\n곧 당신만의 기술 도서관이 채워질 거예요.',
                    textAlign: TextAlign.center,
                    style: AppStyles.w700.copyWith(
                      color: Theme.of(context).colorScheme.surfaceDim,
                      fontSize: 20.fs,
                    ),
                  ),
                ],
              ),
            );
          }
          return SliverToBoxAdapter(
            child: ValueListenableBuilder(
                valueListenable: articles,
                builder: (_,value,__){
                  return Padding(
                    padding: EdgeInsets.only(top: 6.s),
                    child: AnimatedStaggeredListView(
                      articleList: articles.value,
                      onTapItem: (index) => onTapBookmarkArticles(index),
                    ),
                  );
                }),
          );
        });
  }

  void onTapTechCorp(int index){
    currentIndex.value = index;
    if(corps.value.length == 2){
      articles.value = totalArticles;
    }else{
      if(index == 0){
        articles.value = totalArticles;
        return;
      }
      List<Article> selectArticles = totalArticles.where((element) => (element.techCorp ?? '') == corps.value[index]).toList();
      articles.value = selectArticles;
    }
  }

  void onTapBookmarkArticles(int index) async {
    try {
      await context.push(AppRoutes.article,extra: {
        'article' : articles.value[index]
      });
      var result = await db.get(
        AppKeys.ARTICLE_BOOKMARK_STORE,
        articles.value[index].link ?? '',
      );
      if (result == null) {
        String articleCorp = articles.value[index].techCorp ?? '';
        final updatedList = List<Article>.from(articles.value)..removeAt(index);
        articles.value = updatedList;
        int corpIndex = articles.value.indexWhere((element) => (element.techCorp == articleCorp));
        if(corpIndex < 0){
          final updatedCorps = List<String>.from(corps.value)..remove(articleCorp);
          corps.value = updatedCorps;
          print('corps : ${corps.value}');
          currentIndex.value = 0;
        }
      }
    } catch (e) {
      debugPrint('e : ${e.toString()}');
    }
  }

}
