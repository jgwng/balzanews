import 'package:balzanewsweb/core/consts.dart';
import 'package:balzanewsweb/util/platform_util.dart';
import 'package:balzanewsweb/widgets/pwa_banner.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

OverlayEntry? _pwaBannerOverlay;

void showPwaInstallBanner(BuildContext context) {
  if (_pwaBannerOverlay != null) return; // prevent duplicate banners

  _pwaBannerOverlay = OverlayEntry(
    builder: (context) => Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: PwaInstallBanner(
        onClose: removePwaInstallBanner,
        onInstall: removePwaInstallBanner,
      ),
    ),
  );

  Overlay.of(context, rootOverlay: true).insert(_pwaBannerOverlay!);
}

void removePwaInstallBanner() {
  _pwaBannerOverlay?.remove();
  _pwaBannerOverlay = null;
}

bool get shouldShowPwaBanner {
  if(PlatformUtil.isPWA || PlatformUtil.isDesktopWeb) return false;

  final lastShown = html.window.localStorage[AppKeys.LAST_DATE_PWA_BANNER_SHOWN];

  final today = DateTime.now();
  final todayStr = '${today.year}-${today.month}-${today.day}';

  return lastShown != todayStr;
}

void updatePwaBannerLastShown() {
  final today = DateTime.now();
  final todayStr = '${today.year}-${today.month}-${today.day}';

  html.window.localStorage[AppKeys.LAST_DATE_PWA_BANNER_SHOWN] = todayStr;
}
