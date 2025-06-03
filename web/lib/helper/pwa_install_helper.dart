import 'dart:html' as html;
import 'dart:js' as js;

import 'package:balzanewsweb/core/consts.dart';
import 'package:balzanewsweb/core/routes.dart';
import 'package:balzanewsweb/widgets/bottomSheet/ios_pwa_install_notice_sheet.dart';
import 'package:balzanewsweb/widgets/bottomSheet/pwa_install_banner_sheet.dart';
import 'package:flutter/material.dart';

import '../util/platform_util.dart';
class PWAInstallHelper{
  static final PWAInstallHelper _instance = PWAInstallHelper._internal();
  PWAInstallHelper._internal();
  factory PWAInstallHelper() {
    return _instance;
  }

  bool get shouldShowPwaBanner {
    if (PlatformUtil.isPWA || PlatformUtil.isDesktopWeb) return false;

    final lastShown =
    html.window.localStorage[AppKeys.LAST_DATE_PWA_BANNER_SHOWN];

    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';

    return lastShown != todayStr;
  }

  void updatePwaBannerLastShown() {
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';

    html.window.localStorage[AppKeys.LAST_DATE_PWA_BANNER_SHOWN] = todayStr;
  }

  void showBanner() async{
    var result = await showModalBottomSheet(
      context: AppRoutes.globalKey.currentContext!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (_) => PwaInstallBannerSheet(),
    );
    updatePwaBannerLastShown();
    if(result == true){
      if(true){
        return showModalBottomSheet(
          context: AppRoutes.globalKey.currentContext!,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          backgroundColor: Colors.transparent,
          isScrollControlled: false,
          builder: (_) => PWAIOSNoticeInstallSheet(),
        );
      }else if(PlatformUtil.isAOSWeb || PlatformUtil.isDesktopWeb){
        js.context.callMethod('triggerInstallPrompt');
      }
    }
  }


}