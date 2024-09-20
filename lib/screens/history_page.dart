import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../components/multi_componentes.dart';
import '../models/activity.dart';
import '../services/firestore_service.dart';
import '../utils/category_icon.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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

  @override
  Widget build(BuildContext context) {
    final completedActivities = activities
        .where((activity) => !(activity.isPending ??
            true)) // Usa el operador de coalescencia nula para manejar valores nulos
        .toList();

    return Scaffold(
      appBar: const AppBarMenu(title: "Historial de Mantenimiento"),
      drawer: DrawerMenu(),
      body: ListView.builder(
        itemCount: completedActivities.length,
        itemBuilder: (context, index) {
          final activity = completedActivities[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(color: Colors.blue.withOpacity(0.8), width: 2.0),
            ),
            elevation: 10.0,
            shadowColor: Colors.black.withOpacity(0.2),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.2),
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
                            ),
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onPressed: () {
                    context.go('/details/${activity.id}');
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
