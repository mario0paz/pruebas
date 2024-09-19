import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Inicializa el sistema de notificaciones.
  static Future<void> initNotifications() async {
    AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon', // Cambia esto si es necesario
      [
        NotificationChannel(
          channelKey: 'maintenance_channel',
          channelName: 'Mantenimiento',
          channelDescription: 'Recordatorios de mantenimiento',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
        )
      ],
    );
  }

  // Inicializa las zonas horarias.
  static void initializeTimeZone() {
    tz.initializeTimeZones();
  }

  // Función para programar una notificación.
  static Future<void> scheduleNotification(
      DateTime scheduledDate, String title, String body) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0, // ID de la notificación
        channelKey: 'maintenance_channel', // Canal de notificación
        title: title, // Título de la notificación
        body: body, // Cuerpo de la notificación
      ),
      schedule: NotificationCalendar(
        year: scheduledDate.year,
        month: scheduledDate.month,
        day: scheduledDate.day,
        hour: scheduledDate.hour,
        minute: scheduledDate.minute,
        second: scheduledDate.second,
        millisecond: scheduledDate.millisecond,
        timeZone: tz.local.name,
        preciseAlarm:
            true, // Permite que la notificación se dispare con precisión
      ),
    );
  }
}
