import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final VoidCallback logoutCallback;

  const MyDrawer({super.key, required this.logoutCallback});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/me.jpg'),
                  radius: 30,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Hi Hardik",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Donor",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Menu Items
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Donation History'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red), // Logout Icon
            title: const Text("Logout",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                    decorationColor: Colors.red
                )),
            onTap: logoutCallback, // Call logout function
          ),
        ],
      ),
    );
  }
}
