class AppConfig {
  static const String version = '2.0.0';
  static const String githubOwner = 'Dioklez';
  static const String githubRepo = 'AdministracionKatyDecor';
  static const String appName = 'KatyDecor Admin';
  static const String githubToken =
      String.fromEnvironment('GITHUB_TOKEN', defaultValue: '');
}
