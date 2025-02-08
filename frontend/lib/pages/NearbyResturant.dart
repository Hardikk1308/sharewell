import 'package:flutter/material.dart';

class FoodDonorsListPage extends StatefulWidget {
  const FoodDonorsListPage({super.key});

  @override
  _FoodDonorsListPageState createState() => _FoodDonorsListPageState();
}

class _FoodDonorsListPageState extends State<FoodDonorsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of food donors"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: 10),
            _buildFoodCategoryFilter(),
            SizedBox(height: 10),
            Expanded(child: _buildDonorsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search for donors...",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildFoodCategoryFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Food Categories", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        PopupMenuButton<String>(
          icon: Icon(Icons.filter_list),
          onSelected: (value) {},
          itemBuilder: (context) => [
            PopupMenuItem(value: "All", child: Text("All")),
            PopupMenuItem(value: "Veg", child: Text("Veg")),
            PopupMenuItem(value: "Frozen food", child: Text("Frozen food")),
            PopupMenuItem(value: "Cooked Food", child: Text("Cooked Food")),
            PopupMenuItem(value: "Packaged Food", child: Text("Packaged Food")),
          ],
        ),
      ],
    );
  }

  Widget _buildDonorsList() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return _buildDonorItem();
      },
    );
  }

  Widget _buildDonorItem() {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset("assets/images/restaurant 1.png", height: 120, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Donor’s Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                    SizedBox(width: 5),
                    Text("12A, Vasant Kunj, New Delhi, 110070", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 5),
                Text("Food requirement: 20 people", style: TextStyle(fontSize: 14, color: Colors.black87)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: Text("View Details"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                      child: Text("Donate", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
  }
