import 'package:balzanewsweb/core/consts.dart';
import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/helper/device_info_helper.dart';
import 'package:flutter/material.dart';

Future<int?> showCorpSelectBottomSheet(BuildContext context) async{

  var height  = DeviceInfoHelper().height ?? MediaQuery.of(context).size.height;
  var result = await showModalBottomSheet(
    //웹페이지에서 전체 너비를 가지도록 설정하기 위해 추가
    constraints: BoxConstraints(
      maxHeight: height * 0.5
    ),
    backgroundColor: Theme.of(context).colorScheme.surface,
    context: context,
    isScrollControlled: true,
    // Allows dynamic height
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return CorpSelectBottomSheet(
        sheetHeight : height,
      );
    },
  );
  return result;
}

class CorpSelectBottomSheet extends StatelessWidget{
  final double sheetHeight;

  CorpSelectBottomSheet({super.key, required this.sheetHeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sheetHeight, // 60% screen height
      child: Column(
        children: [
          SizedBox(
            height: 12.s,
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
          Text(
            '신문사 선택',
            textAlign: TextAlign.center,
            style: AppStyles.w700.copyWith(
              fontSize: 18.fs,
              height: 24 / 18,
              color: Theme.of(context).colorScheme.surfaceDim,
              letterSpacing: -0.6.fs,
            ),
          ),
          SizedBox(
            height: 12.s,
          ),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: TechCorps.values.length,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      Navigator.pop(context, index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color:AppThemes.borderColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(TechCorps.values[index].name,
                          style: AppStyles.w700.copyWith(
                              fontSize: 16.fs,
                              color: Theme.of(context).colorScheme.surfaceDim
                          ),
                        ),
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

}