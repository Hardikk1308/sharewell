import 'package:flutter/material.dart';
import 'package:shareweel_app/common/basic_app_buttons.dart';
import 'package:shareweel_app/pages/Signupdetails/Donarspage.dart';
import 'package:shareweel_app/pages/Signupdetails/Recevierspage.dart';
import 'package:shareweel_app/pages/Signupdetails/Volunteerspage.dart';

class Role extends StatefulWidget {
  const Role({super.key});

  @override
  _RoleState createState() => _RoleState();
}

class _RoleState extends State<Role> {
  String selectedOption = "Receiver"; // Default selected option

  void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  Widget buildSelectableContainer(
      String title, String subtitle, String option) {
    bool isSelected = selectedOption == option;

    return GestureDetector(
      onTap: () => selectOption(option),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.black : Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          SizedBox(height: 50),
          Text(
            "Choose your Role",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                buildSelectableContainer("Donor",
                    "I have something to donate to the needy", "Donor"),
                buildSelectableContainer(
                    "Receiver", "I am a charitable organization", "Receiver"),
                buildSelectableContainer(
                    "Volunteer",
                    "Wanted to help the needy by volunteering",
                    "Volunteer"),
              ],
            ),
          ),
          SizedBox(height: 300),
          BasicAppButton(
            text: 'Continue',
            onPressed: () {
              Widget nextPage;
              if (selectedOption == "Donor") {
                nextPage = DonorPage();
              } else if (selectedOption == "Receiver") {
                nextPage = Receviers();
              } else {
                nextPage = Volunteers();
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => nextPage,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
