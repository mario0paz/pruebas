import 'package:equipo5/provider/storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class DrawerMenu extends StatelessWidget {
  DrawerMenu({super.key});

  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final storageProvider =
        // ignore: use_build_context_synchronously
        Provider.of<StorageProvider>(context, listen: false);

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              storageProvider.name ?? 'No disponible',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              storageProvider.email ?? 'Sin correo',
              style: const TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: storageProvider.photoUrl != null
                  ? ClipOval(
                      child: Image.network(
                        storageProvider.photoUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.account_circle,
                      size: 60,
                      color: Colors.grey,
                    ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8.0),
              children: <Widget>[
                _createDrawerItem(
                  icon: Icons.home,
                  text: 'Home',
                  onTap: () => context.go('/maintenance'),
                ),
                _createDrawerItem(
                  icon: Icons.psychology_alt_rounded,
                  text: 'Mantenimientos pasados',
                  onTap: () => context.go('/history'),
                ),
                _createDrawerItem(
                  icon: Icons.settings,
                  text: 'Settings',
                  onTap: () => context.go('/settings'),
                ),
                const Divider(),
                _createDrawerItem(
                  icon: Icons.logout,
                  text: 'Sign Out',
                  onTap: () {
                    auth.signOut(context);
                    context.goNamed('loginPage');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      GestureTapCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      horizontalTitleGap: 10.0,
      dense: true,
    );
  }
}

class AppBarMenu extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarMenu({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4, // Añade una ligera sombra para dar más profundidad
      backgroundColor:
          const Color(0xFF526566), // Color más moderno y profesional
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      centerTitle: true, // Centra el título
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white, // Asegura que el texto del título sea blanco
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: () => context.go('/newManten'),
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(
              20), // Bordes redondeados para un toque más moderno
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
      60.0); // Aumenta ligeramente la altura para un mejor diseño visual
}

class AppBarMenuOthers extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarMenuOthers({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final storageProvider =
        // ignore: use_build_context_synchronously
        Provider.of<StorageProvider>(context, listen: false);

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      centerTitle: true, // Centra el título del AppBar
      backgroundColor: Colors.blue.shade700, // Fondo azul personalizado
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: storageProvider.photoUrl != null
                ? ClipOval(
                    child: Image.network(
                      storageProvider.photoUrl!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.account_circle,
                    size: 30,
                    color: Colors.grey,
                  ),
          ),
        ),
      ],
      elevation: 4.0, // Añade una sombra sutil
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
