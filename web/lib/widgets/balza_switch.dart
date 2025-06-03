import 'package:balzanewsweb/core/size.dart';
import 'package:flutter/material.dart';


class BalzaSwitch extends StatefulWidget {

  const BalzaSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.activeColor,
    this.disActiveColor,
    this.isDisable = false,
  });

  /// 스위치의 현제값
  final bool value;

  /// 스위치 값 변경에 대한 콜백
  final void Function(bool value) onChanged;

  /// 활성화 색상
  final Color activeColor;
  final Color? disActiveColor;

  final bool isDisable;

  @override
  _BalzaSwitchState createState() => _BalzaSwitchState();
}

class _BalzaSwitchState extends State<BalzaSwitch>
    with SingleTickerProviderStateMixin {

  final width = 44.s;
  final height = 24.s;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedContainer(
        duration: widget.isDisable
            ? const Duration()
            : const Duration(milliseconds: 250),
        width: 44.s,
        height: 24.s,
        alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height),
          color: widget.value
              ? widget.activeColor
              : (widget.disActiveColor ?? Color(0xFF787880).withAlpha(84)),
        ),
        padding: EdgeInsets.all(2.s),
        child: Container(
          width: height - 4,
          height: height - 4,
          decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(width),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFFFFFFF),
                  blurRadius: 2,
                  offset: Offset(1, 0),
                ),
              ]),
        ),
      ),
    );
  }
}
