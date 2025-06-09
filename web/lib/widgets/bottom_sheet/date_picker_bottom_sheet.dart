import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/util/device_util.dart';
import 'package:balzanewsweb/util/platform_util.dart';
import 'package:balzanewsweb/widgets/balza_button.dart';
import 'package:flutter/material.dart';
import 'package:balzanewsweb/widgets/date_picker/custom_date_picker.dart';
import 'package:balzanewsweb/widgets/date_picker/date_picker_theme.dart';

typedef DateCallback = Function(DateTime dateTime);

Future<DateTime?> showDatePickerBottomSheet(BuildContext context, {
  DateCallback? onConfirm,
  bool isTimeMode = false,
  DateTime? minDateTime,
  DateTime? maxDateTime,
  required DateTime initDateTime,
  String? dateFormat,
  String? title,
  String? confirm,
  String? cancel,
  int? minuteDivider,
  bool onMonthChangeStartWithFirstDate = false,
  bool useGrow = false,
}) async {

  DateTime? result = await showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (context){
      return _DatePickerBottomSheet(
        onConfirm: onConfirm,
        isTimeMode: isTimeMode,
        minDateTime: minDateTime,
        maxDateTime: maxDateTime,
        initDateTime: initDateTime,
        dateFormat: dateFormat,
        title: title,
        confirm: confirm,
        cancel: cancel,
        minuteDivider: minuteDivider,
        onMonthChangeStartWithFirstDate: onMonthChangeStartWithFirstDate,
        useGrow: useGrow,
      );
    }
  );
  return result;
}

// ignore: must_be_immutable
class _DatePickerBottomSheet extends StatefulWidget {
  _DatePickerBottomSheet({
    this.onConfirm,
    this.isTimeMode = false,
    this.minDateTime,
    this.maxDateTime,
    required this.initDateTime,
    this.dateFormat,
    this.title,
    this.confirm,
    this.cancel,
    this.minuteDivider,
    this.onMonthChangeStartWithFirstDate = false,
    this.useGrow = false,
  });

  DateCallback? onConfirm;
  bool isTimeMode = false;
  DateTime? minDateTime;
  DateTime? maxDateTime;
  DateTime initDateTime;
  String? dateFormat;
  String? title;
  String? confirm;
  String? cancel;
  int? minuteDivider;
  bool onMonthChangeStartWithFirstDate = false;
  bool useGrow = false;

  @override
  State<_DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<_DatePickerBottomSheet> {
  late DateTime _date;

  @override
  Widget build(BuildContext context) {
    _date = widget.initDateTime;
    return SafeArea(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _header(),
        _body(),
        SizedBox(height: 8.s),
        _bottomButtons(),
        SizedBox(height: 8),
        if(PlatformUtil.isPWA)
        SizedBox(
            height: bottomInset(),
        )
      ],
    ));
  }

  Widget _header() {
    return Column(
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
          '시간 설정 ',
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
      ],
    );
  }

  Widget _body() {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child:  CustomDatePicker(
        onMonthChangeStartWithFirstDate: widget.onMonthChangeStartWithFirstDate,
        minDateTime: widget.minDateTime,
        maxDateTime: widget.maxDateTime,
        minuteDivider: widget.minuteDivider ?? 1,
        initDateTime: widget.initDateTime,
        dateFormat: widget.dateFormat ?? 'yyyy년-MM월-dd일',
        pickerTheme: DateTimePickerTheme(
            showTitle: false,
            titleHeight: 0,
            backgroundColor:  Theme.of(context).colorScheme.surface,
            itemHeight: 48,
            pickerHeight: 194,
            selectionOverlay: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.symmetric(
                  horizontal: BorderSide(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
            ),
            itemTextStyle: AppStyles.w500.copyWith(
              fontSize: 18.fs,
              height: 24 / 18,
              color: Theme.of(context).colorScheme.surfaceDim
            )),
        onChange: (dateTime, selectedIndex) {
          _date = dateTime;
        },
      ),
    );
  }

  Widget _bottomButtons() {
    return Container(
      height: 56.s,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: BalzaButton(
              onPressed: (){
                Navigator.pop(context);
              },
              buttonText: '취소',
              buttonTextColor: AppThemes.fontColor,
              backgroundColor:AppThemes.pointColor.withAlpha(80)
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: BalzaButton(
                onPressed: (){
                  Navigator.pop(context, _date);
                },
                buttonText: '확인',
                backgroundColor:AppThemes.pointColor
            ),
          ),
        ],
      ),
    );
  }
}
