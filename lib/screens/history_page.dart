import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../components/multi_componentes.dart';
import '../models/activity.dart';
import '../utils/category_icon.dart';

int calcularDiasRestantes(DateTime fechaMantenimiento) {
  DateTime fechaActual = DateTime.now();
  return fechaMantenimiento.difference(fechaActual).inDays;
}

Color obtenerColorCard(int diasRestantes) {
  if (diasRestantes < 7) {
    return Colors.red;
  } else {
    return Colors.green;
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<Activity> activities = [
    // Agrega tus datos aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarMenu(title: "Lista de Mantenimiento"),
      drawer: DrawerMenu(),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];

          // Programar notificación usando awesome_notifications
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: index, // Utiliza un ID único para cada notificación
              channelKey:
                  'maintenance_channel', // Asegúrate de que este canal exista en tu configuración
              title: 'Recordatorio de Mantenimiento',
              body:
                  'La tarea ${activity.name} está programada para el ${DateFormat('yyyy-MM-dd').format(activity.nextReminder)}.',
              notificationLayout: NotificationLayout.BigText,
            ),
            schedule: NotificationCalendar(
              year: activity.nextReminder.year,
              month: activity.nextReminder.month,
              day: activity.nextReminder.day,
              hour: activity.nextReminder.hour,
              minute: activity.nextReminder.minute,
              second: activity.nextReminder.second,
              millisecond: activity.nextReminder.millisecond,
              preciseAlarm: true,
            ),
          );

          // ignore: unnecessary_null_comparison
          int diasRestantes = activity.nextReminder != null
              ? calcularDiasRestantes(activity.nextReminder)
              : 999;

          Color colorCard = obtenerColorCard(diasRestantes);

          return Card(
            color: colorCard,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4.0,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              leading: CategoryIcon(category: activity.category),
              title: Text(
                activity.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...[
                    Text(
                      activity.description,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    'Última fecha: ${DateFormat('yyyy-MM-dd').format(activity.lastPerformed)}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Próxima fecha: ${DateFormat('yyyy-MM-dd').format(activity.nextReminder)}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              trailing: Wrap(
                spacing: 12,
                children: <Widget>[
                  IconButton(
                    icon: activity.isPending == true
                        ? const Icon(Icons.check_box_outline_blank,
                            color: Colors.blue)
                        : const Icon(Icons.check_box, color: Colors.blue),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onPressed: () {
                      context.go('/details/${activity.id}');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
