class AppVersionInfo {
  String? appName;
  String? version;
  String? buildNumber;
  String? packageName;
  bool? forceUpdate;

  AppVersionInfo(
      {this.appName,
        this.version,
        this.buildNumber,
        this.packageName,
        this.forceUpdate,
      });

  AppVersionInfo.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    version = json['version'];
    buildNumber = json['build_number'];
    packageName = json['package_name'];
    forceUpdate = json['force_update'];
  }
}