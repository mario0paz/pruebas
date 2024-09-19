import 'package:equipo5/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../components/multi_componentes.dart';
import '../provider/storage_provider.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarMenuOthers(title: "Configuraciones"),
      drawer: DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de encabezado
            Center(
              child: Image.asset(
                'assets/icons/settings_icon.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Ajusta tus preferencias y configuraciones aquí.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Cuenta'),
                    subtitle: const Text('Manejo de tu cuenta'),
                    onTap: () {},
                  ),
                  const Divider(),
                  SwitchListTile(
                    secondary: const Icon(Icons.brightness_6),
                    title: const Text('Modo oscuro'),
                    subtitle: const Text('Activa o desactiva el modo oscuro'),
                    value: themeProvider.themeMode == ThemeMode.dark, 
                    onChanged: (bool value) {
                      themeProvider.toggleTheme(value); 
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notificación'),
                    subtitle: const Text('Manejo de configuraciones'),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Cerrar Sesión'),
                    onTap: () {
                      auth.signOut(context);
                      context.pushNamed('loginPage');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
