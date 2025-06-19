/// MCP 툴들의 입력 스키마 정의
abstract final class ToolSchemas {
  static const Map<String, dynamic> empty = {};

  // 공통 필드 정의
  static const Map<String, dynamic> scheduleIdField = {
    'type': 'string',
    'description': '스케줄 ID',
  };

  static const Map<String, dynamic> eventIdField = {
    'type': 'string',
    'description': '일정 ID',
  };

  static const Map<String, dynamic> titleField = {
    'type': 'string',
    'description': '제목',
  };

  static const Map<String, dynamic> scheduleTypeField = {
    'type': 'string',
    'enum': ['CALENDAR', 'TIMETABLE'],
    'description': '스케줄 타입',
  };

  static const Map<String, dynamic> recurrenceField = {
    'type': 'object',
    'nullable': true,
    'description': '반복 일정 정보',
    'properties': {
      'cycleType': {
        'type': 'string',
        'enum': ['DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY'],
        'description': '반복 주기 타입'
      },
      'endType': {
        'type': 'string',
        'enum': ['END_BY_COUNT', 'END_BY_DATE', 'INFINITE'],
        'description': '반복 종료 타입'
      },
      'repeatCount': {
        'type': 'number',
        'nullable': true,
        'description': '반복 횟수 (END_BY_COUNT일 때 필수)'
      },
      'recurrenceEndDate': {
        'type': 'string',
        'nullable': true,
        'description': '반복 종료 날짜 (yyyy-MM-dd, END_BY_DATE일 때 필수)'
      },
      'mon': {
        'type': 'boolean',
        'nullable': true,
        'description': '월요일 반복 여부 (WEEKLY일 때 사용)'
      },
      'tue': {
        'type': 'boolean',
        'nullable': true,
        'description': '화요일 반복 여부 (WEEKLY일 때 사용)'
      },
      'wed': {
        'type': 'boolean',
        'nullable': true,
        'description': '수요일 반복 여부 (WEEKLY일 때 사용)'
      },
      'thu': {
        'type': 'boolean',
        'nullable': true,
        'description': '목요일 반복 여부 (WEEKLY일 때 사용)'
      },
      'fri': {
        'type': 'boolean',
        'nullable': true,
        'description': '금요일 반복 여부 (WEEKLY일 때 사용)'
      },
      'sat': {
        'type': 'boolean',
        'nullable': true,
        'description': '토요일 반복 여부 (WEEKLY일 때 사용)'
      },
      'sun': {
        'type': 'boolean',
        'nullable': true,
        'description': '일요일 반복 여부 (WEEKLY일 때 사용)'
      },
    },
    'required': ['cycleType', 'endType']
  };

  // 툴별 스키마 정의
  static const Map<String, dynamic> getSchedules = {
    'random_string': {
      'type': 'string',
      'description': 'Dummy parameter for no-parameter tools',
    }
  };

  static const Map<String, dynamic> createSchedule = {
    'title': titleField,
    'scheduleType': scheduleTypeField,
  };

  static const Map<String, dynamic> deleteSchedule = {
    'scheduleId': scheduleIdField,
  };

  static const Map<String, dynamic> updateSchedule = {
    'scheduleId': scheduleIdField,
    'title': titleField,
  };

  static const Map<String, dynamic> getEvents = {
    'startMonth': {
      'type': 'string',
      'description': '시작 월 (yyyy-MM)',
    },
    'endMonth': {
      'type': 'string',
      'description': '종료 월 (yyyy-MM)',
    },
    'calendarIds': {
      'type': 'string',
      'nullable': true,
      'description': '캘린더 ID 목록 (쉼표로 구분)',
    },
    'timetableIds': {
      'type': 'string',
      'nullable': true,
      'description': '시간표 ID 목록 (쉼표로 구분)',
    },
  };

  static const Map<String, dynamic> createEvent = {
    'scheduleId': scheduleIdField,
    'isRecurring': {
      'type': 'boolean',
      'description': '반복 일정 여부',
    },
    'isAllDay': {
      'type': 'boolean',
      'description': '종일 일정 여부',
    },
    'originalInstanceStartDate': {
      'type': 'string',
      'description': '원본 일정 시작 시각 (yyyy-MM-dd HH:mm:ss)',
    },
    'originalInstanceEndDate': {
      'type': 'string',
      'description': '원본 일정 종료 시각 (yyyy-MM-dd HH:mm:ss)',
    },
    'title': titleField,
    'location': {
      'type': 'string',
      'nullable': true,
      'description': '일정 장소',
    },
    'colorType': {
      'type': 'number',
      'description': '일정 색상 타입',
    },
    'notificationSettingType': {
      'type': 'number',
      'nullable': true,
      'description': '알림 설정 타입',
    },
    'memo': {
      'type': 'string',
      'nullable': true,
      'description': '메모 (최대 500자)',
    },
    'recurrence': recurrenceField,
  };

  static const Map<String, dynamic> updateEvent = {
    'scheduleId': scheduleIdField,
    'eventId': eventIdField,
    'eventUpdateType': {
      'type': 'number',
      'description': '이벤트 수정 타입 (1: 일정 전체 수정, 2: 이 일정만 수정, 3: 이후 일정 모두 수정)',
    },
    'targetScheduleId': {
      'type': 'number',
      'nullable': true,
      'description': '일정이 속한 스케줄을 변경할 때 요청하는 스케줄 ID',
    },
    'targetInstanceStartDate': {
      'type': 'string',
      'nullable': true,
      'description':
          '기존 일정의 인스턴스 중 수정할 인스턴스의 시작 시각 (eventUpdateType이 2나 3일 경우 필수)',
    },
    'isRecurring': {
      'type': 'boolean',
      'description': '수정할 새 일정의 반복 여부',
    },
    'isAllDay': {
      'type': 'boolean',
      'description': '수정할 새 일정의 종일 일정 여부',
    },
    'originalInstanceStartDate': {
      'type': 'string',
      'description': '수정할 새 일정의 시작 시각',
    },
    'originalInstanceEndDate': {
      'type': 'string',
      'description': '수정할 새 일정의 종료 시각',
    },
    'title': titleField,
    'location': {
      'type': 'string',
      'nullable': true,
      'description': '수정할 새 일정의 장소',
    },
    'colorType': {
      'type': 'number',
      'description': '수정할 새 일정의 색상 타입',
    },
    'notificationSettingType': {
      'type': 'number',
      'nullable': true,
      'description': '수정할 새 일정의 알림 설정 타입',
    },
    'memo': {
      'type': 'string',
      'nullable': true,
      'description': '수정할 새 일정의 메모',
    },
    'recurrence': {
      'type': 'object',
      'nullable': true,
      'description': '수정할 새 일정의 반복 정보',
      'properties': {
        'cycleType': {
          'type': 'string',
          'enum': ['DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY'],
          'description': '수정할 새 일정의 반복 주기 타입'
        },
        'endType': {
          'type': 'string',
          'enum': ['END_BY_COUNT', 'END_BY_DATE', 'INFINITE'],
          'description': '수정할 새 일정의 반복 종료 타입'
        },
        'repeatCount': {
          'type': 'number',
          'nullable': true,
          'description': '수정할 새 일정의 반복 횟수 (END_BY_COUNT일 때 필수)'
        },
        'recurrenceEndDate': {
          'type': 'string',
          'nullable': true,
          'description': '수정할 새 일정의 반복 종료 날짜 (yyyy-MM-dd, END_BY_DATE일 때 필수)'
        },
        'mon': {
          'type': 'boolean',
          'nullable': true,
          'description': '수정할 새 일정의 월요일 반복 여부 (WEEKLY일 때 사용)'
        },
        'tue': {
          'type': 'boolean',
          'nullable': true,
          'description': '수정할 새 일정의 화요일 반복 여부 (WEEKLY일 때 사용)'
        },
        'wed': {
          'type': 'boolean',
          'nullable': true,
          'description': '수정할 새 일정의 수요일 반복 여부 (WEEKLY일 때 사용)'
        },
        'thu': {
          'type': 'boolean',
          'nullable': true,
          'description': '수정할 새 일정의 목요일 반복 여부 (WEEKLY일 때 사용)'
        },
        'fri': {
          'type': 'boolean',
          'nullable': true,
          'description': '수정할 새 일정의 금요일 반복 여부 (WEEKLY일 때 사용)'
        },
        'sat': {
          'type': 'boolean',
          'nullable': true,
          'description': '수정할 새 일정의 토요일 반복 여부 (WEEKLY일 때 사용)'
        },
        'sun': {
          'type': 'boolean',
          'nullable': true,
          'description': '수정할 새 일정의 일요일 반복 여부 (WEEKLY일 때 사용)'
        },
      },
      'required': ['cycleType', 'endType']
    },
  };

  static const Map<String, dynamic> deleteEvent = {
    'scheduleId': scheduleIdField,
    'eventId': eventIdField,
    'eventDeleteType': {
      'type': 'number',
      'description': '이벤트 삭제 타입 (1: 일정 전체 삭제, 2: 이 일정만 삭제, 3: 이후 일정 모두 삭제)',
    },
    'targetInstanceStartDate': {
      'type': 'string',
      'nullable': true,
      'description':
          '기존 일정의 인스턴스 중 삭제할 인스턴스의 시작 시각 (eventDeleteType이 2나 3일 경우 필수)',
    },
  };
}
