import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../common/basic_app_buttons.dart';
import '../constant/App_Colour.dart';
import '../pages/Volunteers_homepage.dart';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({super.key});

  @override
  _AvailabilityPageState createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  String _selectedTimeSlot = "";
  final List<String> _timeSlots = [
    "Morning 9 to 11",
    "Afternoon 1 to 3",
    "Afternoon 1 to 3",
    "Afternoon 1 to 3"
  ];
  final List<bool> _selectedDays = List.filled(7, false);
  bool _allWeekdays = false;
  bool _allWeekend = false;
  bool _anyDay = false;

  void _submitForm() {
    if (_selectedTimeSlot.isEmpty) {
      _showDialog("Error", "Please select a time slot.");
    } else {
      _showDialog("Success", "Your availability has been submitted!");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            "Select your availability",
            style: GoogleFonts.bricolageGrotesque(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.background,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Select your availability",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                Column(
                  children: _timeSlots.map((slot) {
                    return RadioListTile(
                      title: Text(slot),
                      value: slot,
                      groupValue: _selectedTimeSlot,
                      onChanged: (value) {
                        setState(() {
                          _selectedTimeSlot = value!;
                        });
                      },
                    );
                  }).toList(),
                ),

                SizedBox(height: 15),

                // Day & Date Selection
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Day & Date",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      )),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                      ["S", "M", "T", "W", "T", "F", "S"].asMap().entries.map(
                    (entry) {
                      int index = entry.key;
                      String day = entry.value;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDays[index] = !_selectedDays[index];
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _selectedDays[index]
                                ? Colors.blue
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(day,
                              style: TextStyle(
                                  color: _selectedDays[index]
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      );
                    },
                  ).toList(),
                ),
                SizedBox(height: 10),

                CheckboxListTile(
                  title: Text("All Weekdays"),
                  value: _allWeekdays,
                  onChanged: (value) {
                    setState(() {
                      _allWeekdays = value!;
                      _allWeekend = false;
                      _anyDay = false;
                    });
                  },
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 2,
                  endIndent: 2,
                ),
                CheckboxListTile(
                  title: Text("All Weekend"),
                  value: _allWeekend,
                  onChanged: (value) {
                    setState(() {
                      _allWeekend = value!;
                      _allWeekdays = false;
                      _anyDay = false;
                    });
                  },
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 2,
                  endIndent: 2,
                ),
                CheckboxListTile(
                  title: Text("Any Day"),
                  value: _anyDay,
                  onChanged: (value) {
                    setState(() {
                      _anyDay = value!;
                      _allWeekdays = false;
                      _allWeekend = false;
                    });
                  },
                ),
                SizedBox(height: 20),

                const SizedBox(height: 20),
                Center(
                  child: BasicAppButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Volunteers(),
                        ),
                      );
                    },
                    text: 'Continue',
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
