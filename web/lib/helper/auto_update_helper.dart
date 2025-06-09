import 'dart:convert';
import 'dart:js_interop' as js_interop;
import 'package:balzanewsweb/core/consts.dart';
import 'package:balzanewsweb/model/app_version_info.dart';
import 'package:balzanewsweb/widgets/bottom_sheet/version_update_induce_bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:web/web.dart' as web;

class AutoUpdateHelper {
  const AutoUpdateHelper();

  static final _localStorage = web.window.localStorage;
  static const _currentVersionNumber = AppKeys.APP_CURRENT_VERSION_NUMBER;
  static const _currentBuildNumber = AppKeys.APP_CURRENT_VERSION_BUILD_NUMBER;

  Future<void> updateIfNecessary() async {
    final updateInfo = await checkNeedUpdate();

    if (updateInfo.$1 == false) {
      return;
    }

    if(updateInfo.$1 == true){
      bool isForceUpdate = updateInfo.$2 ?? false;
      var result = await showVersionUpdateInduceBottomSheet(isForceUpdate);
      if(result == true){
        reloadApp();
      }
    }
  }


  Future<(bool?, bool?)> checkNeedUpdate() async {
    if(kDebugMode == true) return (false, false);

    final currentVersionNumber = _getSavedVersionNumber();
    final currentBuildNumber = _getSavedBuildNumber();

    final remoteVersionInfo = await _getRemoteBuildNumber();

    debugPrint('Current Build number: $currentBuildNumber');
    debugPrint('Remote Build number: $remoteVersionInfo');

    final remoteVersionNumber = remoteVersionInfo.version;
    final remoteBuildNumber = remoteVersionInfo.buildNumber;

    if(currentVersionNumber == null){
      saveInfo(remoteVersionNumber, remoteBuildNumber);
      return (false, false);
    }

    if (remoteVersionNumber == currentVersionNumber && currentBuildNumber == remoteBuildNumber) {
      saveInfo(remoteVersionNumber, remoteBuildNumber);
      return (false, false);
    }

    saveInfo(remoteVersionNumber, remoteBuildNumber);
    return (true, remoteVersionInfo.forceUpdate ?? false);
  }

  Future<AppVersionInfo> _getRemoteBuildNumber() async {
    const versionPath = 'https://balzanewss.web.app/version.json';
    final response = await http.get(Uri.parse(versionPath));
    final appData = json.decode(response.body);
    final versionInfo = AppVersionInfo.fromJson(appData);
    return versionInfo;
  }

  void saveInfo(String? versionNumber, String? buildNumber){
    _saveVersionNumber(versionNumber ?? '');
    _saveBuildNumber(buildNumber ?? '');
  }

  String? _getSavedVersionNumber() => _localStorage.getItem(_currentVersionNumber);

  void _saveVersionNumber(String buildNumber) => _localStorage.setItem(_currentVersionNumber, buildNumber);

  String? _getSavedBuildNumber() => _localStorage.getItem(_currentBuildNumber);

  void _saveBuildNumber(String buildNumber) => _localStorage.setItem(_currentBuildNumber, buildNumber);

  Future<void> reloadApp() async {
    final registrationsPromise = web.window.navigator.serviceWorker.getRegistrations();

    final registrations = (await registrationsPromise.toDart).toDart;

    for (final registration in registrations) {
      registration.unregister();
    }

    web.window.location.reload();
  }

}