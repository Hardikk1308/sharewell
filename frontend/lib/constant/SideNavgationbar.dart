import 'package:flutter/material.dart';

// Side Navigation Drawer
class MyDrawer extends StatelessWidget {
  final VoidCallback logoutCallback;

  const MyDrawer({super.key, required this.logoutCallback});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("User Name"),
            accountEmail: Text("user@example.com"),
            currentAccountPicture: CircleAvatar(
              // backgroundImage: AssetImage("assets/profile.jpg"),
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: logoutCallback,
          ),
        ],
      ),
    );
  }
}
