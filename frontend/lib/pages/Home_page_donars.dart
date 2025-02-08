import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/login.dart';
import '../constant/App_Colour.dart';
import '../constant/SideNavgationbar.dart';
import 'Donation.dart';

class DonorDashboard extends StatefulWidget {
  const DonorDashboard({super.key});

  @override
  State<DonorDashboard> createState() => _DonorDashboardState();
}

class _DonorDashboardState extends State<DonorDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      child: Stack(children: [
        Scaffold(
          key: _scaffoldKey,
          drawer: MyDrawer(
            logoutCallback: () {
              _logout();
            },
          ),
          backgroundColor: Colors.white,
      
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildStatsSection(),
                const SizedBox(height: 20),
                _buildTabBar(),
                const SizedBox(height: 20),
                _buildTabView(),
                const SizedBox(height: 30),
                _buildDonationHistory(),
                const SizedBox(height: 20),
                _buildCommunitySection(),
                const SizedBox(height: 20),
                _buildNearbyNGOs(),
                const SizedBox(height: 20),
                _buildFAQSection(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20, bottom: 30),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              backgroundColor: Colors.deepPurple,
              onPressed: () {}, child: Icon(Icons.chat,
            color: Colors.white,)),
          ),
        ),
      ]),
    );
  }

  Widget _buildTabBar() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: "My Post"),
            Tab(text: "Receivers Requests"),
          ],
        ),
        const SizedBox(height: 10),
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

  Widget _buildReceiversRequestsTab() {
    return Container(
      height: 150, // Adjust height as needed
      width: 500,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: 'Smile Foundation',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                    text: '  Requested for the food ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle accept action
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(30, 30),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Accept', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle reject action
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(30, 30),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Reject', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: 'Abhishek Foundation',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                    text: '  Requested for the food ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle accept action
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(30, 30),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Accept', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle reject action
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(30, 30),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Reject', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 30),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You are a Donor",
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Icon(Icons.settings, color: Colors.black),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("No. of Donors", "500"),
          _buildStatItem("Feedback Received", "500"),
          _buildStatItem("Points Earned", "1000"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

Widget _buildDonationHistory() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text("Listing Type: Donation",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Spacer(),
          TextButton(
              onPressed: () {},
              child: Text(
                "View All",
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w400),
              )),
        ],
      ),
      Card(
        color: AppColors.background,
        elevation: 4,
        child: ListTile(
          leading: Image.asset(
            "assets/images/rice.png",
            fit: BoxFit.cover,
          ),
          title: Text("Rice bowl with curry"),
          subtitle: Text("Completed"),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("₹ 324800"),
              Text("3 Days Ago", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildNearbyNGOs() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("NGOs Near You",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      Card(
        color: AppColors.background,
        elevation: 4,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                "assets/images/ngo.png",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("NGO Bhavan"),
                Text("2.5 km away"),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: Text("Donate",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color.fromARGB(255, 230, 229, 229),
                  ),
                  child: Text("Contact",
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildCommunitySection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text("Community",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Spacer(),
          TextButton(
              onPressed: () {},
              child: Text(
                "See All",
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w400),
              )),
        ],
      ),
      Row(
        children: [
          _buildCommunityCard("We visit places to serve people"),
          _buildCommunityCard("We visit places to serve people"),
        ],
      ),
    ],
  );
}

Widget _buildCommunityCard(String title) {
  return Expanded(
    child: Card(
      color: AppColors.background,
      elevation: 4,
      child: Column(
        children: [
          Image.asset("assets/images/community 1.png"),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(title),
          ),
        ],
      ),
    ),
  );
}

Widget _buildFAQSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("FAQs", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      Card(
        elevation: 2,
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
        elevation: 2,
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
