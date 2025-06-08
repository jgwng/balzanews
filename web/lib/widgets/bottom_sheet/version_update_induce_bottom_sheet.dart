import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/routes.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/helper/device_info_helper.dart';
import 'package:balzanewsweb/util/device_util.dart';
import 'package:balzanewsweb/widgets/balza_button.dart';
import 'package:flutter/material.dart';

Future<void> showVersionUpdateInduceBottomSheet() async{
  var context = AppRoutes.globalKey.currentContext!;
  var height  = DeviceInfoHelper().height ?? MediaQuery.of(context).size.height;

  var result = await showModalBottomSheet(
    constraints: BoxConstraints(
        maxHeight: height * 0.5
    ),
    isDismissible: false,
    backgroundColor: Theme.of(context).colorScheme.surface,
    context: context,
    isScrollControlled: true,
    // Allows dynamic height
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return VersionUpdateInduceBottomSheet(
      );
    },
  );
  return result;
}

class VersionUpdateInduceBottomSheet extends StatelessWidget {
  const VersionUpdateInduceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: 24.s,right: 24.s),
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
          Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "지금이 바로 ",
                  ),
                  TextSpan(
                    text: "업데이트",
                    style: AppStyles.w700
                        .copyWith(fontSize: 20.fs),
                  ),
                  TextSpan(
                    text: "할 타이밍!\n",
                  ),
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
          ),
          SizedBox(
            height: 16.s,
          ),
          BalzaButton(
            onPressed: () {
              Navigator.pop(context,true);
            },
            buttonText: '업데이트',
            backgroundColor: AppThemes.pointColor,
            height: 52.s,
          ),
          SizedBox(height: 16.s),
          SizedBox(
            height: bottomInset(),
          )
        ],
      ),
    );
  }
}
