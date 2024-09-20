import 'package:equipo5/provider/storage_provider.dart';
import 'package:equipo5/router/router_configure.dart';
import 'package:equipo5/services/firestore_service.dart';
import 'package:equipo5/utils/notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService.initializeTimeZone();
  await NotificationService.initNotifications();
  ActivityService activityService = ActivityService();
  activityService.enableOfflinePersistence();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => StorageProvider()),
  ], child: const MyApp()));
}

var uuid = const Uuid();
var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
