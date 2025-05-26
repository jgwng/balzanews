import 'package:balzanewsweb/core/consts.dart';
import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/helper/local_db_helper.dart';
import 'package:balzanewsweb/model/article.dart';
import 'package:balzanewsweb/screens/article_viewer_screen.dart';
import 'package:balzanewsweb/widgets/animated_list_view.dart';
import 'package:balzanewsweb/widgets/balza_app_bar.dart';
import 'package:flutter/material.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final LocalDBHelper db = LocalDBHelper();
  final ValueNotifier<bool> isLoading = ValueNotifier(true);
  ValueNotifier<List<Article>> articles = ValueNotifier([]);

  @override
  void initState(){
    super.initState();
    getBookmarkArticles();
  }

  Future<void> getBookmarkArticles() async{
    isLoading.value = true;
    articles.value = await db.getAllValues(AppKeys.ARTICLE_BOOKMARK_STORE);
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
            buildArticles()
          ],
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
                    padding: EdgeInsets.only(top: 24.s),
                    child: AnimatedStaggeredListView(
                      articleList: articles.value,
                      onTapItem: (index) => onTapBookmarkArticles(index),
                    ),
                  );
                }),
          );
        });
  }


  void onTapBookmarkArticles(int index) async {
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticleViewerScreen(
            article: articles.value[index],
          ),
        ),
      );

      var result = await db.get(
        AppKeys.ARTICLE_BOOKMARK_STORE,
        articles.value[index].link ?? '',
      );

      if (result == null) {
        final updatedList = List<Article>.from(articles.value)..removeAt(index);
        articles.value = updatedList; // 🔥 Notify listeners
      }
    } catch (e) {
      debugPrint('e : ${e.toString()}');
    }
  }

}
