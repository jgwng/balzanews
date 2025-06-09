import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/routes.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/helper/device_info_helper.dart';
import 'package:balzanewsweb/util/device_util.dart';
import 'package:balzanewsweb/widgets/balza_button.dart';
import 'package:flutter/material.dart';

Future<bool?> showVersionUpdateInduceBottomSheet(bool isForce) async{
  var context = AppRoutes.globalKey.currentContext!;
  var height  = DeviceInfoHelper().height ?? MediaQuery.of(context).size.height;

  var result = await showModalBottomSheet(
    constraints: BoxConstraints(
        maxHeight: height * 0.5
    ),
    isDismissible: (isForce) ? false : true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    context: context,
    isScrollControlled: true,
    // Allows dynamic height
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return VersionUpdateInduceBottomSheet(
        isForce : isForce
      );
    },
  );
  return result;
}

class VersionUpdateInduceBottomSheet extends StatelessWidget {
  final bool isForce;

  const VersionUpdateInduceBottomSheet(
      {super.key,
        required this.isForce,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.s),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20.s,
          ),
          Container(
            width: 40.s,
            height: 4.s,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(
            height: 12.s,
          ),
          Text('새로운 버전이 업데이트 되었어요!',
            textAlign: TextAlign.center,
            style: AppStyles.w700.copyWith(fontSize: 20.fs),),
          SizedBox(height: 16.s),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFFDE00), // yellow
                Color(0xFFFD5900), // orange
              ],
            ).createShader(bounds),
            blendMode: BlendMode.srcIn,
            child:  Icon(
              Icons.notifications_on_rounded,
              size: 90.s,
            ),
          ),
          SizedBox(height: 16.s),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "새로워진 ",
                ),
                TextSpan(
                  text: "개발자 뉴스",
                  style: AppStyles.w700
                      .copyWith(fontSize: 20.fs),
                ),
                TextSpan(
                  text: "를 만나보세요.",
                )
              ],
            ),
            textAlign: TextAlign.left,
            style: AppStyles.w500.copyWith(fontSize: 18.fs),
          ),
          SizedBox(
            height: 16.s,
          ),
          bottomButtons(context),
          SizedBox(
            height: bottomInset() + 16.s,
          )
        ],
      ),
    );
  }


  Widget bottomButtons(BuildContext context){
    if(isForce == true){
      return SizedBox(
        height: 52.s,
        child: BalzaButton(
          onPressed: () {
            Navigator.pop(context,true);
          },
          buttonText: '업데이트',
          backgroundColor: AppThemes.pointColor,
        ),
      );
    }
    return SizedBox(
      height: 52.s,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: BalzaButton(
                onPressed: (){
                  Navigator.pop(context,false);
                },
                buttonText: '다음에 하기',
                buttonTextColor: AppThemes.fontColor,
                backgroundColor:AppThemes.pointColor.withAlpha(80)
            ),
          ),
          SizedBox(width: 8.s),
          Expanded(
            child: BalzaButton(
                onPressed: (){
                  Navigator.pop(context, true);
                },
                buttonText: '업데이트',
                backgroundColor:AppThemes.pointColor
            ),
          ),
        ],
      ),
    );
  }
}
