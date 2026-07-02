class AppRoutes {
  const AppRoutes._();

  static const home = '/';
  static const create = '/create';
  static const library = '/library';
  static const studio = '/studio';
  static const profile = '/profile';
  static const welcome = '/welcome';
  static const login = '/login';
  static const tools = '/tools';
  static const pricing = '/pricing';
  static const settings = '/settings';

  static const toolDetailPath = '/tools/:toolId';
  static const templateDetailPath = '/templates/:templateId';
  static const resultPath = '/result/:assetId';

  static String toolDetail(String toolId) => '/tools/$toolId';
  static String templateDetail(String templateId) => '/templates/$templateId';
  static String result(String assetId) => '/result/$assetId';
}
