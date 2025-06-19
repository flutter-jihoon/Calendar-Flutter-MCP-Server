import 'package:calendar_flutter_mcp_server/auth/auth_environment.dart';
import 'package:calendar_flutter_mcp_server/core/constants/rest_api_constants.dart';
import 'package:dio/dio.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;

  AuthManager._internal() {
    _dio = Dio();
    _setupInterceptors();
  }

  late final Dio _dio;
  String? _tenantToken;
  String? _accessToken;
  String? _refreshToken;

  Future<void> authenticate() async {
    await _getTenantToken();
    await _getModuleTokens();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          options.headers['tenant-id'] = AuthEnvironment().tenantId;
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await refreshModuleTokens();
            final options = error.requestOptions;
            options.headers['Authorization'] = 'Bearer $_accessToken';
            try {
              final response = await _dio.fetch(options);
              handler.resolve(response);
            } catch (e) {
              handler.next(error);
            }
          } else {
            handler.next(error);
          }
        },
      ),
    );
  }

  Future<void> _getTenantToken() async {
    final response = await _dio.post(
      '${RestApiConstants.timespreadUrl}/calendar/one-time-token',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${AuthEnvironment().tenantAccessToken}'
        },
      ),
    );
    _tenantToken = response.data['token'];
  }

  Future<void> _getModuleTokens() async {
    final response = await _dio.post(
      '${RestApiConstants.calendarModuleUrl}/v1/auth/token',
      data: {'tenantToken': _tenantToken},
      options: Options(
        headers: {
          'tenant-id': AuthEnvironment().tenantId,
          'Content-Type': 'application/json'
        },
      ),
    );
    final data = response.data;
    _accessToken = data['result']['accessToken'];
    _refreshToken = data['result']['refreshToken'];
  }

  Future<void> refreshModuleTokens() async {
    try {
      final response = await _dio.put(
        '${RestApiConstants.calendarModuleUrl}/auth/token/refresh',
        data: {
          'refreshToken': _refreshToken,
          'externalUserId': AuthEnvironment().externalUserId,
        },
        options: Options(
          headers: {
            'tenant-id': AuthEnvironment().tenantId,
            'Content-Type': 'application/json'
          },
        ),
      );
      final data = response.data;
      _accessToken = data['accessToken'];
      _refreshToken = data['refreshToken'];
    } catch (e) {
      await authenticate();
    }
  }

  Future<Response> authorizedRequest(
    String method,
    String url, {
    Map<String, String>? headers,
    dynamic data,
  }) async {
    final options = Options(
      method: method.toUpperCase(),
      headers: headers,
    );

    return await _dio.request(
      url,
      data: data,
      options: options,
    );
  }

  Dio get dio => _dio;
}
