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
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            title: const Text("Logout"),
            onTap: logoutCallback, // Call logout function
          ),
        ],
      ),
    );
  }
}
