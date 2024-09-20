import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Inicializa el sistema de notificaciones.
  static Future<void> initNotifications() async {
    AwesomeNotifications().initialize(
      null, // Cambia esto si es necesario
      [
        NotificationChannel(
          channelKey: 'maintenance_channel',
          channelName: 'Mantenimiento',
          channelDescription: 'Recordatorios de mantenimiento',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High, // Alta prioridad
          playSound: false, // Sonido personalizado opcional
          vibrationPattern:
              highVibrationPattern, // Patrón de vibración personalizado
        ),
      ],
    );

    // Solicita permisos si no han sido concedidos
    await checkAndRequestNotificationPermissions();
  }

  // Función para verificar y solicitar permisos de notificaciones.
  static Future<void> checkAndRequestNotificationPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      // Solicita los permisos
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  // Inicializa las zonas horarias.
  static void initializeTimeZone() {
    tz.initializeTimeZones();
  }

  // Función para programar una notificación.
  static Future<void> scheduleNotification(DateTime scheduledDate, String title,
      String body, int notificationId) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId, // ID único para cada notificación
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
        preciseAlarm: true, // Permite notificaciones precisas
      ),
    );
  }
}
