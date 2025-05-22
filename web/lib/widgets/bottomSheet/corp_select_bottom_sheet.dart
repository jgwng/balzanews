import 'package:balzanewsweb/core/consts.dart';
import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:flutter/material.dart';

Future<int?> showCorpSelectBottomSheet(BuildContext context) async{
  var result = await showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    isScrollControlled: true,
    // Allows dynamic height
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return CorpSelectBottomSheet();
    },
  );
  return result;
}

class CorpSelectBottomSheet extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6, // 60% screen height
      child: Column(
        children: [
          SizedBox(
            height: 12.s,
          ),
          Container(
            width: 40.s,
            height: 4.s,
            decoration: BoxDecoration(
              color: Colors.grey[400],
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
              letterSpacing: -0.6.fs,
            ),
          ),
          SizedBox(
            height: 12.s,
          ),
          const Divider(height: 1),
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
                              fontSize: 16.fs
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