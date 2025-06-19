import 'dart:io';

import 'package:calendar_flutter_mcp_server/auth/auth_environment.dart';
import 'package:calendar_flutter_mcp_server/auth/auth_manager.dart';
import 'package:calendar_flutter_mcp_server/core/constants/server_constants.dart';
import 'package:calendar_flutter_mcp_server/core/tools.dart';
import 'package:mcp_dart/mcp_dart.dart';

void main() async {
  final Map<String, String> env = Platform.environment;

  final (tenantToken, tenantId, externalUserId) = (
    env['TENANT_ACCESS_TOKEN'],
    env['TENANT_ID'],
    env['EXTERNAL_USER_ID'],
  );

  if (tenantToken == null || tenantId == null || externalUserId == null) {
    throw Exception('Missing environment variables');
  }

  AuthEnvironment().tenantAccessToken = tenantToken;
  AuthEnvironment().tenantId = tenantId;
  AuthEnvironment().externalUserId = externalUserId;

  final authManager = AuthManager();
  await authManager.authenticate();

  McpServer server = McpServer(
    Implementation(
      name: ServerConstants.serverName,
      version: ServerConstants.serverVersion,
    ),
    options: ServerOptions(
      capabilities: ServerCapabilities(
        resources: ServerCapabilitiesResources(),
        tools: ServerCapabilitiesTools(),
      ),
    ),
  );

  for (final tool in Tools.values) {
    server.tool(
      tool.name,
      description: tool.description,
      inputSchemaProperties: tool.inputSchemaProperties,
      callback: tool.callback,
    );
  }

  server.connect(StdioServerTransport());
}
