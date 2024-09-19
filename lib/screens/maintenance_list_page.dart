import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../components/multi_componentes.dart';
import '../models/activity.dart';
import '../services/firestore_service.dart';
import '../utils/category_icon.dart';

int calcularDiasRestantes(DateTime fechaMantenimiento) {
  DateTime fechaActual = DateTime.now();
  return fechaMantenimiento.difference(fechaActual).inDays;
}

Color obtenerColorBorde(int diasRestantes) {
  if (diasRestantes < 7) {
    return Colors.red; // Rojo si quedan menos de 7 días
  } else if (diasRestantes < 30) {
    return Colors.orange; // Naranja si quedan menos de 30 días
  } else {
    return Colors.green; // Verde si quedan 30 días o más
  }
}

class MaintenanceListPage extends StatefulWidget {
  const MaintenanceListPage({super.key});

  @override
  State<MaintenanceListPage> createState() => _MaintenanceListPageState();
}

class _MaintenanceListPageState extends State<MaintenanceListPage> {
  final ActivityService _activityService = ActivityService();
  late List<Activity> activities = [];

  @override
  void initState() {
    super.initState();
    _activityService.getUserActivities().then((value) {
      setState(() {
        activities = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarMenu(title: "Lista de Mantenimiento"),
      drawer: DrawerMenu(),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];

          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: index,
              channelKey: 'maintenance_channel',
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

          int diasRestantes = calcularDiasRestantes(activity.nextReminder);

          // Obtiene el color del borde según los días restantes
          Color colorBorde = obtenerColorBorde(diasRestantes);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(color: colorBorde, width: 3.0),
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
