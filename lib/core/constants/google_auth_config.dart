/// Web OAuth Client ID (cũng là GOOGLE_CLIENT_ID của backend), truyền khi build/run:
/// flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=xxxx.apps.googleusercontent.com
class GoogleAuthConfig {
  GoogleAuthConfig._();

  // Keep this value in sync with the OAuth Web client ID configured in Google
  // Cloud Console and the backend's GOOGLE_CLIENT_ID.
  static const String serverClientId = "255505581971-3mkb234vp4e9upsrhecb6hr714kh0tli.apps.googleusercontent.com";
}