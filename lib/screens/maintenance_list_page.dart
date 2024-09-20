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
    _loadActivities();
  }

  _loadActivities() {
    _activityService.getUserActivities().then((value) {
      setState(() {
        activities = value;
      });
    });
  }

  void isPendingChange(String activityId) async {
    await _activityService.updateActivityPending(activityId, false);
    setState(() {
      activities.removeWhere((activity) => activity.id == activityId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pendingActivities =
        activities.where((activity) => activity.isPending == true).toList();
    return Scaffold(
      appBar: const AppBarMenu(title: "Lista de Mantenimiento"),
      drawer: DrawerMenu(),
      body: activities.isEmpty
          ? const Center(
              child: Text(
                'No tienes tareas de mantenimiento aún.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: pendingActivities.length,
              itemBuilder: (context, index) {
                final activity = pendingActivities[index];

                // Crear notificación de recordatorio
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

                int diasRestantes =
                    calcularDiasRestantes(activity.nextReminder);
                Color colorBorde = obtenerColorBorde(diasRestantes);

                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: BorderSide(
                        color: colorBorde.withOpacity(0.8), width: 2.0),
                  ),
                  elevation: 10.0,
                  shadowColor: Colors.black.withOpacity(0.2),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, colorBorde.withOpacity(0.05)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      leading: CircleAvatar(
                        backgroundColor: colorBorde.withOpacity(0.2),
                        radius: 30,
                        child: CategoryIcon(category: activity.category),
                      ),
                      title: Text(
                        activity.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            activity.description,
                            style: const TextStyle(
                                fontSize: 14.0, color: Colors.black54),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Última: ${DateFormat('yyyy-MM-dd').format(activity.lastPerformed)}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(width: 16),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Próxima: ${DateFormat('yyyy-MM-dd').format(activity.nextReminder)}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Wrap(
                        spacing: 12,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isPendingChange(activity.id);
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: activity.isPending == true
                                    ? Colors.white
                                    : Colors.blue.withOpacity(0.8),
                                border: Border.all(
                                  color: activity.isPending == true
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2.0,
                                ),
                              ),
                              child: activity.isPending == true
                                  ? const Icon(Icons.check_box_outline_blank,
                                      color: Colors.blue)
                                  : const Icon(Icons.check_box,
                                      color: Colors.white),
                            ),
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.more_vert, color: Colors.grey),
                            onPressed: () {
                              context.go('/details/${activity.id}');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
