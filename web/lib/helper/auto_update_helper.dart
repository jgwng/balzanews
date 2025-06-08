import 'dart:convert';
import 'dart:js_interop' as js_interop;


import 'package:balzanewsweb/core/consts.dart';
import 'package:balzanewsweb/core/routes.dart';
import 'package:balzanewsweb/model/app_version_info.dart';
import 'package:balzanewsweb/widgets/bottom_sheet/version_update_induce_bottom_sheet.dart';
import 'package:balzanewsweb/widgets/dialog/update_notes_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web/web.dart' as web;

class AutoUpdateHelper {
  const AutoUpdateHelper();

  static final _localStorage = web.window.localStorage;
  static const _currentVersionNumber = AppKeys.APP_CURRENT_VERSION_NUMBER;
  static const _currentBuildNumber = AppKeys.APP_CURRENT_VERSION_BUILD_NUMBER;

  Future<void> updateIfNecessary() async {
    final shouldUpdate = await checkNeedUpdate();

    if (!shouldUpdate) {
      checkUpdateNotes();
      return;
    }

    if(shouldUpdate == true){
      await showVersionUpdateInduceBottomSheet();
      reloadApp();
    }
  }

  Future<bool> checkNeedUpdate() async {
    if(kDebugMode == true) return false;

    final currentVersionNumber = _getSavedVersionNumber();
    final currentBuildNumber = _getSavedBuildNumber();

    if(currentVersionNumber == null) return false;

    final remoteVersionInfo = await _getRemoteBuildNumber();

    debugPrint('Current Build number: $currentBuildNumber');
    debugPrint('Remote Build number: $remoteVersionInfo');

    final remoteVersionNumber = remoteVersionInfo.version;
    final remoteBuildNumber = remoteVersionInfo.buildNumber;

    if (remoteVersionNumber == currentVersionNumber && currentBuildNumber == remoteBuildNumber) {
      return false;
    }

    debugPrint('New build number: $remoteBuildNumber');

    _saveVersionNumber(remoteVersionNumber ?? '');
    _saveBuildNumber(remoteBuildNumber ?? '');
    _saveUpdateNotes(remoteVersionInfo.updateNotes ?? []);
    return true;
  }

  Future<AppVersionInfo> _getRemoteBuildNumber() async {
    const versionPath = '/version.json';

    final response = await http.get(Uri.parse(versionPath));
    final appData = json.decode(response.body);
    final versionInfo = AppVersionInfo.fromJson(appData);
    return versionInfo;
  }

  String? _getSavedVersionNumber() => _localStorage.getItem(_currentVersionNumber);

  void _saveVersionNumber(String buildNumber) => _localStorage.setItem(_currentVersionNumber, buildNumber);

  String? _getSavedBuildNumber() => _localStorage.getItem(_currentBuildNumber);

  void _saveBuildNumber(String buildNumber) => _localStorage.setItem(_currentBuildNumber, buildNumber);

  void _saveUpdateNotes(List<String> notes) {
    _localStorage.setItem(AppKeys.APP_VERSION_UPDATE_NOTES, jsonEncode(notes));
  }

  Future<void> reloadApp() async {
    final registrationsPromise = web.window.navigator.serviceWorker.getRegistrations();

    final registrations = (await registrationsPromise.toDart).toDart;

    for (final registration in registrations) {
      registration.unregister();
    }

    web.window.location.reload();
  }

  Future<void> checkUpdateNotes() async{
    final raw = _localStorage.getItem(AppKeys.APP_VERSION_UPDATE_NOTES);
    if (raw == null) return;
    final updateNotes = List<String>.from(jsonDecode(raw));
    if(updateNotes.isEmpty) return;

    Future.delayed(Duration(milliseconds: 300), () {
      showDialog(
        context: AppRoutes.globalKey.currentContext!,
        builder: (_) => UpdateNotesDialog(notes: updateNotes),
      );
      _localStorage.removeItem(AppKeys.APP_VERSION_UPDATE_NOTES);
    });
    return;
  }


}