import 'package:balzanewsweb/core/consts.dart';
import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/helper/app_theme_helper.dart';
import 'package:balzanewsweb/util/common_util.dart';
import 'package:balzanewsweb/util/platform/general/general_safe_area.dart';
import 'package:balzanewsweb/widgets/balza_app_bar.dart';
import 'package:balzanewsweb/widgets/balza_button.dart';
import 'package:balzanewsweb/widgets/balza_switch.dart';
import 'package:balzanewsweb/widgets/bottomSheet/date_picker_bottom_sheet.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'dart:html' as html;

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  ValueNotifier<bool> isDarkMode = ValueNotifier(true);
  ValueNotifier<bool> isAlarmGranted = ValueNotifier(false);
  ValueNotifier<List<String>> alarmList = ValueNotifier([]);

  String? token;

  @override
  void initState(){
    super.initState();
    initFetchInfo();
  }

  void initFetchInfo() async{
    isDarkMode.value = AppThemeHelper.themeMode.value == ThemeMode.dark;
    final currentPermission = html.Notification.permission;
    if(currentPermission == 'granted'){
      isAlarmGranted.value = true;
      token = html.window.localStorage[AppKeys.PWA_PUSH_TOKEN];
      registerServiceWorker();
      final alarm = html.window.localStorage[AppKeys.PUSH_ALARM_LIST] ?? '';
      if(alarm.isNotEmpty){
        alarmList.value = sortTimeList(alarm.split(','));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BalzaAppBar(),
      body: PlatformSafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.s),
          child: Column(
            children: [
              SizedBox(
                height: 54.s,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '다크모드',
                      style: AppStyles.w700.copyWith(
                          color: Theme.of(context).colorScheme.surfaceDim,
                          fontSize: 20.fs),
                    ),
                    ValueListenableBuilder(
                        valueListenable: isDarkMode,
                        builder: (_, value, __) {
                          return BalzaSwitch(
                              value: isDarkMode.value,
                              onChanged: (value) {
                                isDarkMode.value = !isDarkMode.value;
                                AppThemeHelper.change();
                              },
                              activeColor: AppThemes.pointColor);
                        })
                  ],
                ),
              ),
              SizedBox(
                height: 54.s,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '알림 설정',
                      style: AppStyles.w700.copyWith(
                          color: Theme.of(context).colorScheme.surfaceDim,
                          fontSize: 20.fs),
                    ),
                    ValueListenableBuilder(
                        valueListenable: isAlarmGranted,
                        builder: (_, value, __) {
                          return BalzaSwitch(
                              value: isAlarmGranted.value,
                              onChanged: (value) {
                                setAlarmPermission();
                              },
                              activeColor: AppThemes.pointColor);
                        })
                  ],
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: isAlarmGranted,
                  builder: (_,value,__){
                    if(isAlarmGranted.value == false){
                      return const SizedBox();
                    }
                    return Column(
                      children: [
                        ValueListenableBuilder(
                            valueListenable: alarmList,
                            builder: (_,value,__){
                              return GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: alarmList.value.length,
                                  primary: false,
                                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 4.s,
                                      crossAxisSpacing: 12.s,
                                      mainAxisExtent: 48.s
                                  ),
                                  itemBuilder: (ctx,index){
                                    return InkWell(
                                      onTap: (){
                                        js.context.callMethod('removeUserToken',[token,alarmList.value[index]]);
                                        final updatedList = List<String>.from(alarmList.value)..removeAt(index);
                                        alarmList.value = updatedList;
                                        html.window.localStorage[AppKeys.PUSH_ALARM_LIST] = alarmList.value.join(',');
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(horizontal: 16.s),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.0),
                                            border: Border.all(color: AppThemes.borderColor)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(alarmList.value[index],style: AppStyles.w700.copyWith(
                                                fontSize: 20.fs
                                            ),),
                                            Icon(Icons.close_rounded,size: 24,)
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                        Padding(
                          padding: EdgeInsets.only(top: 12.s),
                          child: BalzaButton(
                            onPressed: setAlarmList,
                            buttonText: '알람 추가하기',
                            backgroundColor: AppThemes.pointColor,
                            height: 40.s,
                          ),
                        )
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void setAlarmPermission() async{
    if(isAlarmGranted.value == true){
      html.window.localStorage[AppKeys.PUSH_ALARM_LIST] = '';
      for(var v in alarmList.value){
        js.context.callMethod('removeUserToken',[token,v]);
      }
      isAlarmGranted.value = false;
    }else{
      final currentPermission = html.Notification.permission;
      if(currentPermission == 'granted'){
        isAlarmGranted.value = true;
        registerServiceWorker();
        await fetchToken();
        final alarm = html.window.localStorage[AppKeys.PUSH_ALARM_LIST] ?? '';
        if(alarm.isNotEmpty){
          alarmList.value = sortTimeList(alarm.split(','));
        }
        return;
      }
      if (currentPermission == 'default'){
        final requested = await html.Notification.requestPermission();
        if(requested == 'granted'){
          isAlarmGranted.value = true;
          registerServiceWorker();
          await fetchToken();
        }
      }
    }
  }

  void setAlarmList() async{
    var result = await showDatePickerBottomSheet(
      context,
      minDateTime: DateTime.now().copyWith(hour: 0,minute: 0),
      initDateTime: DateTime.now().copyWith(hour: 12, minute: 0),
      maxDateTime: DateTime.now().add(Duration(days: 1)).copyWith(hour: 0,minute: 0),
      dateFormat: 'HH-mm',
      minuteDivider: 30,
    );
    if(result != null){
      String alarmTime = '${result.hour}:${result.minute.toString().padLeft(2, '0')}';
      if(alarmList.value.contains(alarmTime) == false){
        js.context.callMethod('saveUserToken',[token,alarmTime]);
        alarmList.value = sortTimeList([...alarmList.value,alarmTime]);
        html.window.localStorage[AppKeys.PUSH_ALARM_LIST] = alarmList.value.join(',');
      }
    }
  }

  void registerServiceWorker() {
    final navigator = js.context['navigator'];
    if (navigator != null && navigator.hasProperty('serviceWorker')) {
      navigator['serviceWorker'].callMethod('register', ['firebase-messaging-sw.js']);
      debugPrint('ServiceWorker registered');
    } else {
      debugPrint('ServiceWorker not supported in this browser');
    }
  }

  Future<void> fetchToken() async {
    String? token = html.window.localStorage[AppKeys.PWA_PUSH_TOKEN];
    if(token != null){
      return;
    }
    final fcmToken = await FirebaseMessaging.instance.getToken(
        vapidKey: 'BLWmQrqAEQY8mCXQMhL9g18T2eiLnODTstn3fZte3TwGzwMiqEnlGdzn_cjXSU7d-RuIxQjJkxZoEuQ-PT8lTlU'
    );
    if (fcmToken != null) {
      token = fcmToken;
      html.window.localStorage[AppKeys.PWA_PUSH_TOKEN] = fcmToken;
    }
  }
}
