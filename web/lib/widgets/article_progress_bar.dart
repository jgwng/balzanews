import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ArticleProgressBar extends StatefulWidget{
  final int? duration;
  final double? percentage;
  final double? height;

  const ArticleProgressBar({
    super.key,
    this.duration,
    this.height,
    this.percentage
  });

  @override
  State<ArticleProgressBar> createState() => _ArticleProgressBarState();

}
class _ArticleProgressBarState extends State<ArticleProgressBar> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late Animation<double> progressAnimation;
  final ValueNotifier<double> progressPercentage = ValueNotifier(0);
  double _previousRatio = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration ?? 250),
    );
    _setAnimation(0);
  }

  void _setAnimation(double newRatio) {
    progressPercentage.value = newRatio;
    final curved = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    progressAnimation = Tween<double>(
      begin: _previousRatio,
      end: newRatio,
    ).animate(curved);
    _animController
      ..reset()
      ..forward();
    _previousRatio = newRatio;
  }

  @override
  void didUpdateWidget(covariant ArticleProgressBar oldWidget){
    if(oldWidget.percentage == widget.percentage) return;
    super.didUpdateWidget(oldWidget);
    _setAnimation(widget.percentage ?? 0);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: widget.height ?? 4.s,
          color: Colors.grey[300],
        ),
        AnimatedBuilder(
          animation: _animController,
          builder: (context,child) {
             return _buildAnimatedBar();
          }
        ),
      ],
    );
  }

  Widget _buildAnimatedBar() {
    return Container(
      width: MediaQuery.of(context).size.width * progressAnimation.value,
      height: widget.height ?? 4.s,
      decoration: BoxDecoration(
        color: AppThemes.pointColor,
      ),
    );
  }
}

