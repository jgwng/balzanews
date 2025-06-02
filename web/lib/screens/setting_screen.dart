import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:balzanewsweb/helper/app_theme_helper.dart';
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
  ValueNotifier<bool> isAlarmSetting = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BalzaAppBar(),
      body: PlatformSafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: 54,
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
                height: 54,
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
                        valueListenable: isAlarmSetting,
                        builder: (_, value, __) {
                          return BalzaSwitch(
                              value: isAlarmSetting.value,
                              onChanged: (value) {
                                isAlarmSetting.value = !isAlarmSetting.value;
                                if (isAlarmSetting.value == true) {
                                  registerServiceWorker();
                                  checkPushPermission();
                                }
                              },
                              activeColor: AppThemes.pointColor);
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkPushPermission() async {
    final currentPermission = html.Notification.permission;
    if (currentPermission == 'default') {
      final requested = await html.Notification.requestPermission();
      debugPrint('Requested permission: $requested');
      if(requested == 'granted'){
        await saveTokenToFirestore();
      }
    } else {}
  }

  void registerServiceWorker() {
    final navigator = js.context['navigator'];
    if (navigator != null && navigator.hasProperty('serviceWorker')) {
      navigator['serviceWorker']
          .callMethod('register', ['firebase-messaging-sw.js']);
      debugPrint('ServiceWorker registered');
    } else {
      debugPrint('ServiceWorker not supported in this browser');
    }
  }

  Future<void> saveTokenToFirestore() async {
    final fcmToken = await FirebaseMessaging.instance.getToken(
        vapidKey: 'BLWmQrqAEQY8mCXQMhL9g18T2eiLnODTstn3fZte3TwGzwMiqEnlGdzn_cjXSU7d-RuIxQjJkxZoEuQ-PT8lTlU'
    );
    if (fcmToken != null) {
      js.context.callMethod('saveUserToken',[fcmToken,"12:00"]);
    }
  }
}
