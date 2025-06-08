class AppVersionInfo {
  String? appName;
  String? version;
  String? buildNumber;
  String? packageName;
  bool? forceUpdate;
  List<String>? updateNotes;

  AppVersionInfo(
      {this.appName,
        this.version,
        this.buildNumber,
        this.packageName,
        this.forceUpdate,
        this.updateNotes,
      });

  AppVersionInfo.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    version = json['version'];
    buildNumber = json['build_number'];
    packageName = json['package_name'];
    forceUpdate = json['forceUpdate'];
    updateNotes = json['updateNotes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_name'] = appName;
    data['version'] = version;
    data['build_number'] = buildNumber;
    data['package_name'] = packageName;
    data['forceUpdate'] = forceUpdate;
    data['updateNotes'] = updateNotes;
    return data;
  }
}