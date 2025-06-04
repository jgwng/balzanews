import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/model/article.dart';
import 'package:balzanewsweb/widgets/animated_list_item.dart';
import 'package:flutter/material.dart';

class AnimatedStaggeredListView extends StatefulWidget {
  final Duration initialDelay;
  final Duration itemDelay;
  final List<Article> articleList;
  final Function(int)? onTapItem;

  const AnimatedStaggeredListView({
    super.key,
    required this.articleList,
    this.onTapItem,
    this.initialDelay = const Duration(milliseconds: 300),
    this.itemDelay = const Duration(milliseconds: 100),
  });

  @override
  State<AnimatedStaggeredListView> createState() =>
      _AnimatedStaggeredListViewState();
}

class _AnimatedStaggeredListViewState extends State<AnimatedStaggeredListView>
    with TickerProviderStateMixin {

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
        return AnimatedArticleTile(
          article: widget.articleList[index],
          index: index,
          delay: widget.initialDelay + widget.itemDelay * index,
          onTap: () => widget.onTapItem?.call(index),
        );
      },
    );
  }
}
