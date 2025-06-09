import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/model/article.dart';
import 'package:flutter/material.dart';

class AnimatedArticleTile extends StatefulWidget {
  final Article article;
  final int index;
  final Duration delay;
  final VoidCallback? onTap;

  const AnimatedArticleTile({
    super.key,
    required this.article,
    required this.index,
    required this.delay,
    this.onTap,
  });

  @override
  State<AnimatedArticleTile> createState() => _AnimatedArticleTileState();
}

class _AnimatedArticleTileState extends State<AnimatedArticleTile>
    with SingleTickerProviderStateMixin {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _visible ? 1 : 0,
      curve: Curves.easeOut,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 500),
        offset: _visible ? Offset.zero : const Offset(0, 0.1),
        curve: Curves.easeOut,
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.s),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: AppThemes.borderColor),
            ),
            child: ValueListenableBuilder(
              valueListenable: widget.article.readYn,
              builder: (_, value, __) => Text(
                (widget.article.title ?? '').replaceAll('&amp;', ''),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.w700.copyWith(
                  fontSize: 16.fs,
                  color: (value == true)
                      ? Theme.of(context).colorScheme.surfaceBright
                      : Theme.of(context).colorScheme.surfaceDim,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
