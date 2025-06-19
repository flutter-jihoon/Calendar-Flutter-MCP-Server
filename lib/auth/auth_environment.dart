class AuthEnvironment {
  static final AuthEnvironment _instance = AuthEnvironment._internal();
  factory AuthEnvironment() => _instance;
  AuthEnvironment._internal();

  String? _tenantAccessToken;
  String? _tenantId;
  String? _externalUserId;

  set tenantAccessToken(String tenantAccessToken) =>
      _tenantAccessToken = tenantAccessToken;
  set tenantId(String tenantId) => _tenantId = tenantId;
  set externalUserId(String externalUserId) => _externalUserId = externalUserId;

  String get tenantAccessToken => _tenantAccessToken!;
  String get tenantId => _tenantId!;
  String get externalUserId => _externalUserId!;
}
