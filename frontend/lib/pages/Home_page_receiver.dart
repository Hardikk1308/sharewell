import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/login.dart';
import '../constant/App_Colour.dart';
import '../constant/Sidenav.dart';
import 'Donation.dart';
import 'NearbyResturant.dart';

class ReceiverHomePage extends StatefulWidget {
  const ReceiverHomePage({super.key});

  @override
  State<ReceiverHomePage> createState() => _ReceiverHomePageState();
}

class _ReceiverHomePageState extends State<ReceiverHomePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: MyDrawer1(logoutCallback: () {
          _logout();
        }),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
              Text("Your are a Receiver",
                  style: GoogleFonts.bricolageGrotesque(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(Icons.settings, color: Colors.black),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsCard(),
              SizedBox(height: 20),
              _buildTabBar(),
              SizedBox(height: 20),
              _buildTabView(),
              SizedBox(height: 20),
              _buildFoodDonorsSection(),
              SizedBox(height: 20),
              _buildCommunitySection(),
              SizedBox(height: 20),
              _buildFAQ(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.deepPurple,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.deepPurple,
      tabs: [
        Tab(text: "My Post"),
        Tab(text: "Donors Requests"),
      ],
    );
  }

  Widget _buildTabView() {
    return SizedBox(
      height: 200, // Adjust height as needed
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildMyPostTab(), // First tab content
          _buildReceiversRequestsTab(), // Second tab content
        ],
      ),
    );
  }

  Widget _buildReceiversRequestsTab() {
    return Center(
      child: Container(
        height: 200,
        width: 500,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No requests yet", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            const Text("You have no donor requests at the moment.",
                style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildMyPostTab() {
    return Center(
      child: Container(
        height: 200,
        width: 500,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Nothing till now", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            const Text("Do you have something to donate?",
                style: TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Create Donation Post",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DonationListingPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      color: Colors.purple[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem("No. of orders received", "500"),
            Container(height: 40, width: 1, color: Colors.white),
            _buildStatItem("Points earned", "500"),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.black54, fontSize: 14)),
        SizedBox(height: 5),
        Text(value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFoodDonorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Food donors Near You",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodDonorsListPage()),
                );
              },
              child: Text(
                "See More",
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        _buildFoodDonorItem(),
        _buildFoodDonorItem(),
      ],
    );
  }

  Widget _buildFoodDonorItem() {
    return Card(
      elevation: 3,
      color: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset('assets/images/restaurant 1.png',
                        height: 100)),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Restaurants Name 1",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text("2.5km"),
                    Text("340 meals served till now"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                OutlinedButton(onPressed: () {}, child: Text("View Details")),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: Text(
                    "Connect",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Community",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            TextButton(
              onPressed: () {},
              child: Text(
                "View Feed",
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 210, // Adjust height as needed
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  5, (index) => _buildCommunityItem()), // Multiple items
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCommunityItem() {
    return Container(
      width: 156,
      margin: EdgeInsets.only(right: 10),
      child: Card(
        elevation: 3,
        color: AppColors.background,
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                child: Image.asset('assets/images/receiver.png', height: 102)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("We visit places to serve people"),
            ),
            TextButton(onPressed: () {}, child: Text("Know More")),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQ() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("FAQ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 10),
        _buildFAQSection(),
      ],
    );
  }

  Widget _buildFAQSection() {
    return Column(
      children: [
        Card(
          color: AppColors.background,
          child: ExpansionTile(
            title: Text(
              "Who will pick up the food?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("NGOs will coordinate pickup."),
                  ))
            ],
          ),
        ),
        Card(
          color: AppColors.background,
          child: ExpansionTile(
            title: Text(
              "Can we perform one-time donations?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("Yes, one-time donations are supported."),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
