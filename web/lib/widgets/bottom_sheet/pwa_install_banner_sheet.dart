import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/widgets/balza_button.dart';
import 'package:flutter/material.dart';

class PwaInstallBannerSheet extends StatelessWidget {
  const PwaInstallBannerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: 24.s,right: 24.s,top: 24.s),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ Logo
          Image.network(
            '/blog.webp',
            width: 80,
            height: 80,
          ),
          SizedBox(height: 16.s),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: "홈 화면에서 한 번에 접속!\n"),
                TextSpan(
                  text: "개발자 뉴스",
                  style: AppStyles.w500
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18.fs),
                ),
                TextSpan(text: "를 편하게 볼 수 있어요"),
              ],
            ),
            textAlign: TextAlign.center,
            style: AppStyles.w500.copyWith(fontSize: 18.fs),
          ),
          SizedBox(height: 16.s),
          // ✅ Main button
          BalzaButton(
            onPressed: () {
              Navigator.pop(context,true);
            },
            buttonText: '바로가기 추가하기',
            backgroundColor: AppThemes.pointColor,
            height: 52.s,
          ),
          SizedBox(height: 16.s),
          BalzaButton(
            onPressed: () {
              Navigator.pop(context,false);
            },
            buttonText: '오늘은 그냥 볼께요',
            buttonTextColor: AppThemes.fontColor,
            backgroundColor: Colors.transparent,
            height: 36.s,
            isMedium: true,
          ),
          SizedBox(height: 16.s),
        ],
      ),
    );
  }
}
