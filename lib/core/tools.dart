import 'package:calendar_flutter_mcp_server/auth/auth_manager.dart';
import 'package:calendar_flutter_mcp_server/core/constants/rest_api_constants.dart';
import 'package:calendar_flutter_mcp_server/core/schemas/tool_schemas.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mcp_dart/mcp_dart.dart';

part 'tools.freezed.dart';

@freezed
sealed class Tools with _$Tools {
  const Tools._();

  factory Tools.getSchedules() = GetSchedules;
  factory Tools.createSchedule() = CreateSchedule;
  factory Tools.deleteSchedule() = DeleteSchedule;
  factory Tools.updateSchedule() = UpdateSchedule;
  factory Tools.getEvents() = GetEvents;
  factory Tools.createEvent() = CreateEvent;
  factory Tools.updateEvent() = UpdateEvent;
  factory Tools.deleteEvent() = DeleteEvent;

  String get name => when(
        getSchedules: () => 'get_schedules',
        createSchedule: () => 'create_schedule',
        deleteSchedule: () => 'delete_schedule',
        updateSchedule: () => 'update_schedule',
        getEvents: () => 'get_events',
        createEvent: () => 'create_event',
        updateEvent: () => 'update_event',
        deleteEvent: () => 'delete_event',
      );

  String get description => when(
        getSchedules: () => '스케줄(캘린더, 시간표) 리스트 조회',
        createSchedule: () => '스케줄(캘린더, 시간표) 생성',
        deleteSchedule: () => '스케줄(캘린더, 시간표) 삭제',
        updateSchedule: () => '스케줄(캘린더, 시간표) 설정 수정',
        getEvents: () => '스케줄(캘린더, 시간표) 일정 조회',
        createEvent: () => '스케줄(캘린더, 시간표) 일정 생성',
        updateEvent: () => '스케줄(캘린더, 시간표) 일정 수정',
        deleteEvent: () => '스케줄(캘린더, 시간표) 일정 삭제',
      );

  Map<String, dynamic> get inputSchemaProperties => when(
        getSchedules: () => ToolSchemas.empty,
        createSchedule: () => ToolSchemas.createSchedule,
        deleteSchedule: () => ToolSchemas.deleteSchedule,
        updateSchedule: () => ToolSchemas.updateSchedule,
        getEvents: () => ToolSchemas.getEvents,
        createEvent: () => ToolSchemas.createEvent,
        updateEvent: () => ToolSchemas.updateEvent,
        deleteEvent: () => ToolSchemas.deleteEvent,
      );

  Future<CallToolResult> callback({Map<String, dynamic>? args, dynamic extra}) {
    return when(
      getSchedules: () => _getSchedulesCallback(args: args, extra: extra),
      createSchedule: () => _createScheduleCallback(args: args, extra: extra),
      deleteSchedule: () => _deleteScheduleCallback(args: args, extra: extra),
      updateSchedule: () => _updateScheduleCallback(args: args, extra: extra),
      getEvents: () => _getEventsCallback(args: args, extra: extra),
      createEvent: () => _createEventCallback(args: args, extra: extra),
      updateEvent: () => _updateEventCallback(args: args, extra: extra),
      deleteEvent: () => _deleteEventCallback(args: args, extra: extra),
    );
  }

  // Private execution methods
  Future<CallToolResult> _getSchedulesCallback({
    Map<String, dynamic>? args,
    dynamic extra,
  }) async {
    final res = await AuthManager().authorizedRequest(
      'GET',
      '${RestApiConstants.calendarModuleUrl}/v1/schedules',
    );

    if (res.statusCode != null &&
        res.statusCode! >= 200 &&
        res.statusCode! < 300) {
      return CallToolResult.fromContent(
          content: [TextContent(text: res.data.toString())]);
    } else {
      return CallToolResult.fromContent(
          content: [TextContent(text: 'Error: ${res.statusCode} ${res.data}')]);
    }
  }

  Future<CallToolResult> _createScheduleCallback({
    Map<String, dynamic>? args,
    dynamic extra,
  }) async {
    final res = await AuthManager().authorizedRequest(
      'POST',
      '${RestApiConstants.calendarModuleUrl}/v1/schedules',
      data: args,
    );

    try {
      return CallToolResult.fromContent(
        content: [TextContent(text: res.data.toString())],
      );
    } catch (e, stackTrace) {
      return CallToolResult.fromContent(
        content: [TextContent(text: 'Error: $e $stackTrace')],
      );
    }
  }

  Future<CallToolResult> _deleteScheduleCallback({
    Map<String, dynamic>? args,
    dynamic extra,
  }) async {
    final scheduleId = args?['scheduleId'];
    if (scheduleId == null) {
      return CallToolResult.fromContent(
        content: [TextContent(text: 'Error: scheduleId is required')],
      );
    }
    try {
      final res = await AuthManager().authorizedRequest(
        'DELETE',
        '${RestApiConstants.calendarModuleUrl}/v1/schedules/$scheduleId',
      );
      return CallToolResult.fromContent(
        content: [TextContent(text: res.data.toString())],
      );
    } catch (e, stackTrace) {
      return CallToolResult.fromContent(
        content: [TextContent(text: 'Error: $e $stackTrace')],
      );
    }
  }

  Future<CallToolResult> _updateScheduleCallback({
    Map<String, dynamic>? args,
    dynamic extra,
  }) async {
    final scheduleId = args?['scheduleId'];
    if (scheduleId == null) {
      return CallToolResult.fromContent(
          content: [TextContent(text: 'Error: scheduleId is required')]);
    }

    final res = await AuthManager().authorizedRequest(
      'PATCH',
      '${RestApiConstants.calendarModuleUrl}/v1/schedules/$scheduleId',
      data: args,
    );
    try {
      return CallToolResult.fromContent(
        content: [TextContent(text: res.data.toString())],
      );
    } catch (e, stackTrace) {
      return CallToolResult.fromContent(
        content: [TextContent(text: 'Error: $e $stackTrace')],
      );
    }
  }

  Future<CallToolResult> _getEventsCallback({
    Map<String, dynamic>? args,
    dynamic extra,
  }) async {
    final res = await AuthManager().authorizedRequest(
      'GET',
      '${RestApiConstants.calendarModuleUrl}/v1/schedules/events',
    );

    try {
      return CallToolResult.fromContent(
          content: [TextContent(text: res.data.toString())]);
    } catch (e, stackTrace) {
      return CallToolResult.fromContent(
        content: [TextContent(text: 'Error: $e $stackTrace')],
      );
    }
  }

  Future<CallToolResult> _createEventCallback({
    Map<String, dynamic>? args,
    dynamic extra,
  }) async {
    final scheduleId = args?['scheduleId'];
    if (scheduleId == null) {
      return CallToolResult.fromContent(
          content: [TextContent(text: 'Error: scheduleId is required')]);
    }

    final res = await AuthManager().authorizedRequest(
      'POST',
      '${RestApiConstants.calendarModuleUrl}/v1/schedules/$scheduleId/events',
      data: args,
    );

    try {
      return CallToolResult.fromContent(
        content: [TextContent(text: res.data.toString())],
      );
    } catch (e, stackTrace) {
      return CallToolResult.fromContent(
        content: [TextContent(text: 'Error: $e $stackTrace')],
      );
    }
  }

  Future<CallToolResult> _updateEventCallback({
    Map<String, dynamic>? args,
    dynamic extra,
  }) async {
    final scheduleId = args?['scheduleId'];
    final eventId = args?['eventId'];

    if (scheduleId == null || eventId == null) {
      return CallToolResult.fromContent(content: [
        TextContent(text: 'Error: scheduleId and eventId are required')
      ]);
    }

    final res = await AuthManager().authorizedRequest(
      'PUT',
      '${RestApiConstants.calendarModuleUrl}/v1/schedules/$scheduleId/events/$eventId',
      data: args,
    );

    try {
      return CallToolResult.fromContent(
          content: [TextContent(text: res.data.toString())]);
    } catch (e, stackTrace) {
      return CallToolResult.fromContent(
        content: [TextContent(text: 'Error: $e $stackTrace')],
      );
    }
  }

  Future<CallToolResult> _deleteEventCallback({
    Map<String, dynamic>? args,
    dynamic extra,
  }) async {
    final scheduleId = args?['scheduleId'];
    final eventId = args?['eventId'];

    if (scheduleId == null || eventId == null) {
      return CallToolResult.fromContent(content: [
        TextContent(text: 'Error: scheduleId and eventId are required')
      ]);
    }

    final res = await AuthManager().authorizedRequest(
      'DELETE',
      '${RestApiConstants.calendarModuleUrl}/v1/schedules/$scheduleId/events/$eventId',
    );

    try {
      return CallToolResult.fromContent(
        content: [TextContent(text: res.data.toString())],
      );
    } catch (e, stackTrace) {
      return CallToolResult.fromContent(
        content: [TextContent(text: 'Error: $e $stackTrace')],
      );
    }
  }

  // Static utility methods
  static List<Tools> values = [
    Tools.getSchedules(),
    Tools.createSchedule(),
    Tools.deleteSchedule(),
    Tools.updateSchedule(),
    Tools.getEvents(),
    Tools.createEvent(),
    Tools.updateEvent(),
    Tools.deleteEvent(),
  ];

  static Tools? findByName(String name) {
    try {
      return values.firstWhere((tool) => tool.name == name);
    } catch (e) {
      return null;
    }
  }
}
