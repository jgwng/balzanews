import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/model/article.dart';
import 'package:balzanewsweb/screens/article_viewer_screen.dart';
import 'package:flutter/material.dart';

import '../core/resources.dart';

class AnimatedStaggeredListView extends StatefulWidget {
  final Duration initialDelay;
  final Duration itemDelay;
  final List<Article> articleList;
  final bool useLink;

  const AnimatedStaggeredListView({
    super.key,
    required this.articleList,
    this.useLink = false,
    this.initialDelay = const Duration(milliseconds: 300),
    this.itemDelay = const Duration(milliseconds: 100),
  });

  @override
  State<AnimatedStaggeredListView> createState() =>
      _AnimatedStaggeredListViewState();
}

class _AnimatedStaggeredListViewState extends State<AnimatedStaggeredListView>
    with TickerProviderStateMixin {
  final List<bool> _isVisible = [];

  @override
  void initState() {
    super.initState();
    _isVisible.addAll(List.generate(widget.articleList.length, (_) => false));
    _triggerAnimations();
  }
  @override
  void didUpdateWidget(covariant AnimatedStaggeredListView oldWidget){
    super.didUpdateWidget(oldWidget);
    if(widget.articleList != oldWidget.articleList){
      _isVisible.clear();
      _isVisible.addAll(List.generate(widget.articleList.length, (_) => false));
      _triggerAnimations();
    }
  }

  void _triggerAnimations() async {
    await Future.delayed(widget.initialDelay);
    for (int i = 0; i < widget.articleList.length; i++) {
      await Future.delayed(widget.itemDelay);
      if (mounted) {
        setState(() {
          _isVisible[i] = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: widget.articleList.length,
      shrinkWrap: true,
      primary: false,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 12.s,
        );
      },
      itemBuilder: (context, index) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _isVisible[index] ? 1 : 0,
          curve: Curves.easeOut,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            offset: _isVisible[index] ? Offset.zero : const Offset(0, 0.1),
            child: InkWell(
                onTap: () => onTapArticleSelect(index),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.s),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: AppThemes.borderColor)),
                  child: Text(
                    (widget.articleList[index].title ?? '').replaceAll('&amp;', ''),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.w700.copyWith(
                        fontSize: 16.fs
                    ),
                  ),
                )))
        );
      },
    );
  }

  void onTapArticleSelect(int index){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ArticleViewerScreen(
              feed: widget.articleList[index],
              useLink: widget.useLink,
            )));
  }
}
