import 'package:equipo5/provider/storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class DrawerMenu extends StatelessWidget {
  DrawerMenu({super.key});

  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final storageProvider =
        // ignore: use_build_context_synchronously
        Provider.of<StorageProvider>(context, listen: false);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child:
                // here we can add a image porfile of the user and name of the user
                Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: storageProvider.photoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            storageProvider.photoUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.account_circle,
                          size: 50,
                          color: Colors.grey,
                        ),
                ),
                const SizedBox(height: 10),
                Text(
                  storageProvider.name ?? 'No ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              context.go('/maintenance');
            },
          ),
          ListTile(
            leading: const Icon(Icons.psychology_alt_rounded),
            title: const Text('Mantenimientos pasados'),
            onTap: () {
              context.go('/history');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              context.go('/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              auth.signOut(context);
              context.goNamed('loginPage');
            },
          ),

          // Añadir más ListTiles para otras rutas
        ],
      ),
    );
  }
}

class AppBarMenu extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarMenu({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => context.go('/newManten'),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
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
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      actions: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: storageProvider.photoUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    storageProvider.photoUrl!,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(
                  Icons.account_circle,
                  size: 20,
                  color: Colors.grey,
                ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
