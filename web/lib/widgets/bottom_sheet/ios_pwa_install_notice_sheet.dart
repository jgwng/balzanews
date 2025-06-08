import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PWAIOSNoticeInstallSheet extends StatelessWidget {
  const PWAIOSNoticeInstallSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.s, right: 16.s, bottom: 16.s),
      child: ClipPath(
        clipper: BubbleWithPointerClipper(),
        child: Container(
          padding:
              EdgeInsets.only(left: 8.s, right: 8.s, top: 20.s, bottom: 10.s),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '홈 화면에 추가하는 방법',
                textAlign: TextAlign.left,
                style: AppStyles.w700.copyWith(fontSize: 20.fs),
              ),
              SizedBox(
                height: 24.s,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.s),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.share, color: Color(0xFF007AFF),size: 24),
                    SizedBox(width: 8.s),
                    RichText(
                      text: TextSpan(
                        style: AppStyles.w700.copyWith(
                          fontSize: 16.fs,
                          color: AppThemes.fontColor,
                        ),
                        children: [
                          const TextSpan(text: '1) 하단 메뉴에서 '),
                          TextSpan(
                            text: "'공유'",
                            style: AppStyles.w700
                                .copyWith(color: AppThemes.pointColor),
                          ),
                          const TextSpan(text: ' 버튼을 눌러주세요'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.s),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.s),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.plus_app,size: 24,),
                    SizedBox(width: 8.s),
                    RichText(
                      text: TextSpan(
                        style: AppStyles.w700.copyWith(
                          fontSize: 16.fs,
                          color: AppThemes.fontColor,
                        ),
                        children: [
                          const TextSpan(text: '2) '),
                          TextSpan(
                            text: "'홈 화면에 추가'",
                            style: AppStyles.w700
                                .copyWith(color: AppThemes.pointColor),
                          ),
                          const TextSpan(text: '를 눌러주세요'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.s),
            ],
          ),
        ),
      ),
    );
  }
}

class BubbleWithPointerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 16;
    const double pointerWidth = 40;
    const double pointerHeight = 20;

    final Path path = Path();
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - pointerHeight - radius);
    path.quadraticBezierTo(size.width, size.height - pointerHeight,
        size.width - radius, size.height - pointerHeight);

    // Bottom pointer
    path.lineTo(size.width / 2 + pointerWidth / 2, size.height - pointerHeight);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 - pointerWidth / 2, size.height - pointerHeight);

    path.lineTo(radius, size.height - pointerHeight);
    path.quadraticBezierTo(0, size.height - pointerHeight, 0,
        size.height - pointerHeight - radius);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
