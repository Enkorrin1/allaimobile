class Env {
  const Env._();

  static const appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );
  static const webBaseUrl = String.fromEnvironment(
    'WEB_BASE_URL',
    defaultValue: 'https://allai.market',
  );
}
