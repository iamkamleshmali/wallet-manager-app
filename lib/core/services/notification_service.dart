import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../constants/app_constants.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int _dailyReminderNotificationId = 8001;
  static const String _channelId = 'wallet_manager_daily_reminder';
  static const String _channelName = 'Daily Transaction Reminders';
  static const String _channelDescription =
      'Gentle daily reminders in the evening to log your transactions.';

  bool _initialized = false;

  /// Initializes the local notification plugin and configures timezone data.
  Future<void> init() async {
    if (_initialized) return;

    try {
      tz.initializeTimeZones();
      // Configure local timezone (fallback safely if needed)
      try {
        final String localName = DateTime.now().timeZoneName;
        // In most environments, tz.local is already initialized; fallback safely:
        tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
      } catch (_) {
        try {
          tz.setLocalLocation(tz.local);
        } catch (_) {}
      }

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification clicked: ${response.payload}');
        },
      );

      _initialized = true;

      // Check user preferences and schedule if enabled
      final isEnabled = await isReminderEnabled();
      if (isEnabled) {
        await scheduleDailyReminder();
      }
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
  }

  /// Checks if daily reminder is enabled (defaults to true)
  Future<bool> isReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.prefReminderEnabled) ?? true;
  }

  /// Sets daily reminder enabled state and updates scheduling
  Future<void> setReminderEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefReminderEnabled, enabled);

    if (enabled) {
      await requestNotificationPermission();
      await scheduleDailyReminder();
    } else {
      await cancelDailyReminder();
    }
  }

  /// Retrieves user configured reminder hour (default: 20 -> 8:00 PM)
  Future<int> getReminderHour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppConstants.prefReminderHour) ?? 20;
  }

  /// Retrieves user configured reminder minute (default: 0)
  Future<int> getReminderMinute() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppConstants.prefReminderMinute) ?? 0;
  }

  /// Sets reminder time and reschedules
  Future<void> setReminderTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefReminderHour, hour);
    await prefs.setInt(AppConstants.prefReminderMinute, minute);

    final isEnabled = await isReminderEnabled();
    if (isEnabled) {
      await scheduleDailyReminder(hour: hour, minute: minute);
    }
  }

  /// Requests notification permission on Android 13+ (API 33+)
  Future<bool> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        final result = await Permission.notification.request();
        return result.isGranted;
      }
      return true;
    }
    return true;
  }

  /// Schedules the daily evening reminder at specified or default time (8:00 PM).
  /// Uses inexact daily repeating schedule so SCHEDULE_EXACT_ALARM is not needed.
  Future<void> scheduleDailyReminder({int? hour, int? minute}) async {
    try {
      final targetHour = hour ?? await getReminderHour();
      final targetMinute = minute ?? await getReminderMinute();

      // Cancel previous schedule first to avoid duplicate notifications
      await cancelDailyReminder();

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        showWhen: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final scheduledTime = _nextInstanceOfTime(targetHour, targetMinute);

      await _notificationsPlugin.zonedSchedule(
        _dailyReminderNotificationId,
        'Wallet Manager',
        'आज का record किया क्या? 💰',
        scheduledTime,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.inexact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint('Daily reminder scheduled for $targetHour:${targetMinute.toString().padLeft(2, '0')}');
    } catch (e) {
      debugPrint('Failed to schedule daily reminder: $e');
    }
  }

  /// Cancels any existing scheduled daily reminder
  Future<void> cancelDailyReminder() async {
    try {
      await _notificationsPlugin.cancel(_dailyReminderNotificationId);
      debugPrint('Daily reminder cancelled');
    } catch (e) {
      debugPrint('Failed to cancel daily reminder: $e');
    }
  }

  /// Calculates the next occurrence of specified hour and minute in local time.
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
