import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '/pages/auth/login.dart';
import '/utils/routes.dart';
import '/utils/storage.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: userInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Drawer(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Drawer(
            child: Center(
              child: Text('Error fetching user information'),
            ),
          );
        } else {
          final user = snapshot.data!;
          return Drawer(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                  ),
                  accountName: Text(
                    '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}' !=
                            ' '
                        ? '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'
                        : 'Jane Doe',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  accountEmail: Text(
                    user['email'] ?? 'No Email',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.orange,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Account'),
                  onTap: () {},
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Logout'),
                  onTap: () {
                    const FlutterSecureStorage().deleteAll();
                    Navigator.pushReplacement(
                      context,
                      PageBuilder.createPageRoute(const LoginPage()),
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
