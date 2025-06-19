abstract final class RestApiConstants {
  static const String _protocol = 'https';
  static const String _timespreadBaseUrl = 'test.timespread.co.kr';
  static const String _calendarModuleBaseUrl = 'api.calendar-module.com';

  static String get timespreadUrl => '$_protocol://$_timespreadBaseUrl';
  static String get calendarModuleUrl => '$_protocol://$_calendarModuleBaseUrl';
}
