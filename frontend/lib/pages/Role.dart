import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../common/basic_app_buttons.dart';
import 'Signupdetails/ReceviersPage.dart';
import 'Signupdetails/DonarsPage.dart';
import 'Signupdetails/Volunteerspage.dart';

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
      String title, String subtitle, String option, double width) {
    bool isSelected = selectedOption == option;

    return GestureDetector(
      onTap: () => selectOption(option),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        width: width,
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? Color(0xff673AB7) : Colors.grey[400],
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                 style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                 style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
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
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth * 0.9; // Adjust the width as needed

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              "Choose your Role",
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              color: Colors.black38,
              thickness: 1,
              ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildSelectableContainer(
                      "Donor",
                      "I have something to donate to the needy",
                      "Donor",
                      containerWidth),
                  buildSelectableContainer(
                      "Receiver",
                      "I am a charitable organization",
                      "Receiver",
                      containerWidth),
                  buildSelectableContainer(
                      "Volunteer",
                      "Wanted to help the needy people",
                      "Volunteer",
                      containerWidth),
                ],
              ),
            ),
            SizedBox(height: 300),
            BasicAppButton(
              text: 'Continue',
              onPressed: () {
                Widget nextPage;
                if (selectedOption == "Receiver") {
                  nextPage = ReceiversPage();
                } else if (selectedOption == "Donor") {
                  nextPage = Donarspage();
                } else {
                  nextPage = VolunteerDetailsPage();
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
      ),
    );
  }
}
