import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/login.dart';
import '../constant/App_Colour.dart';

class VolunteerHomePage extends StatefulWidget {
  const VolunteerHomePage({super.key});

  @override
  State<VolunteerHomePage> createState() => _VolunteerHomePageState();
}

class _VolunteerHomePageState extends State<VolunteerHomePage> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Loginpage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("You are a Volunteer",
                  style: GoogleFonts.bricolageGrotesque(
                      fontSize: 20, color: Colors.black)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        drawer: _buildDrawer(context),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            accountName:
                Text("Abhishek", style: GoogleFonts.poppins(fontSize: 16)),
            accountEmail:
                Text("volunteer", style: GoogleFonts.poppins(fontSize: 14)),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/him.jpg'),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
            ),
            title: Text("Home", style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
            ),
            title: Text("Profile", style: GoogleFonts.poppins()),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.history,
            ),
            title: Text("Order History", style: GoogleFonts.poppins()),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.help,
            ),
            title: Text("Help & Support", style: GoogleFonts.poppins()),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title:
                Text("Logout", style: GoogleFonts.poppins(color: Colors.red)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statBox("12", "No. of orders delivered"),
                _statBox("4", "Feedback received"),
                _statBox("200", "Points earned"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text("Request to deliver",
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          _deliveryRequestCard("Individual ABC", "Food City - 4 people"),
          _deliveryRequestCard("NGO ABC", "Food City - 4 people"),
          const SizedBox(height: 20),
          Text("Volunteer with these NGOs near you",
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          _ngoCard("NGO Bhavan", "2.5 km away", "20 people"),
          _ngoCard("NGO Bhavan", "3.2 km away", "30 people"),
          const SizedBox(height: 20),
          Text("Community",
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          Row(
            children: [
              Expanded(
                  child: _communityCard("We visit places to serve people")),
              const SizedBox(width: 10),
              Expanded(
                  child: _communityCard("We visit places to serve people")),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text("FAQs",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600)),
          ),
          _faqTile("Who will pick up the food?"),
          _faqTile("Can we perform one-time donations?"),
        ],
      ),
    );
  }

  Widget _statBox(String number, String label) {
    return Column(
      children: [
        Text(number,
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _deliveryRequestCard(String name, String location) {
    return Card(
      color: AppColors.background,
      shadowColor: Colors.deepPurple[500],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title:
            Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        subtitle: Text(location, style: GoogleFonts.poppins()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: Icon(Icons.close, color: Colors.red), onPressed: () {}),
            IconButton(
                icon: Icon(Icons.check, color: Colors.green), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _ngoCard(String name, String distance, String volunteers) {
    return Card(
      color: AppColors.background,
      elevation: 2,
      shadowColor: Colors.deepPurple[500],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title:
            Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        subtitle: Text("$distance • $volunteers people",
            style: GoogleFonts.poppins()),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(
            "Connect",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _communityCard(String text) {
    return Card(
      shadowColor: Colors.deepPurple[500],
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/community 1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text,
                style: GoogleFonts.poppins(), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget _faqTile(String question) {
    return Card(
      shadowColor: Colors.deepPurple[500],
      color: AppColors.background,
      child: ExpansionTile(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(question,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        ),
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Answer to the question goes here.")),
        ],
      ),
    );
  }
}
