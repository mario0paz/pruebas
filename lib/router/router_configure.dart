import 'package:equipo5/funcionality/add_manten.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/edit_manten.dart';
import '../screens/index.dart';
import '../screens/history_page.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'loginPage',
      builder: (BuildContext context, GoRouterState state) {
        return const PageLoginScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details/:id',
          builder: (BuildContext context, GoRouterState state) {
            final String id = state.pathParameters['id']!;
            return ActivityDetailPage(id: id);
          },
        ),
        GoRoute(
            path: 'editManten/:id',
            builder: (BuildContext context, GoRouterState state) {
              final String id = state.pathParameters['id']!;
              return EditManten(id: id);
            }),
        GoRoute(
          path: 'maintenance',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const MaintenanceListPage();
          },
        ),
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsPage();
          },
        ),
        GoRoute(
            path: 'newManten',
            builder: (BuildContext context, GoRouterState state) {
              return const AddManten();
            }),
        GoRoute(
            path: 'history',
            builder: (BuildContext context, GoRouterState state) {
              return const HistoryPage();
            }),
      ],
    ),
  ],
);
