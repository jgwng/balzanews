import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:flutter/material.dart';

class BalzaButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final String? buttonText;
  final Color? backgroundColor;
  final Color? buttonTextColor;

  const BalzaButton({super.key,
    required this.onPressed,
    this.height,
    this.width,
    this.buttonText,
    this.buttonTextColor,
    this.backgroundColor,
  });

  @override
  State<BalzaButton> createState() => _BalzaButtonState();
}

class _BalzaButtonState extends State<BalzaButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.width,
          height: widget.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(12)
          ),
          child:  Text(widget.buttonText ?? '',
              style: AppStyles.w700.copyWith(
              color: widget.buttonTextColor ?? Colors.white,
              fontSize: 20.fs
          )),
        ),
      ),
    );
  }
}
