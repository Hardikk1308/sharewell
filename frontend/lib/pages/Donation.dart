import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import '../constant/App_Colour.dart';
import 'Homepage.dart';

class DonationListingPage extends StatefulWidget {
  const DonationListingPage({super.key});

  @override
  _DonationListingPageState createState() => _DonationListingPageState();
}

class _DonationListingPageState extends State<DonationListingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _expirationDateController =
      TextEditingController();
  final TextEditingController _expirationTimeController =
      TextEditingController();


      void _submitForm() async {
  if (_formKey.currentState!.validate() && isChecked) {
    try {
      // Reference Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Data to be stored in Firestore
      Map<String, dynamic> donationData = {
        "title": _titleController.text.trim(),
        "description": _descriptionController.text.trim(),
        "type": _typeController.text.trim(),
        "vegQuantity": isVegSelected ? vegQuantity : 0,
        "nonVegQuantity": isNonVegSelected ? nonVegQuantity : 0,
        "expirationDate": _expirationDateController.text.trim(),
        "expirationTime": _expirationTimeController.text.trim(),
        "timestamp": FieldValue.serverTimestamp(),
      };

      // Store data in Firestore
      await firestore.collection("donations").add(donationData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Donation Listed Successfully!")),
      );

      // Clear fields after submission
      _titleController.clear();
      _descriptionController.clear();
      _typeController.clear();
      _expirationDateController.clear();
      _expirationTimeController.clear();
      setState(() {
        isVegSelected = false;
        isNonVegSelected = false;
        isChecked = false;
        vegQuantity = 5;
        nonVegQuantity = 5;
      });

      // Navigate to Homepage after successful submission
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please fill all details and confirm hygiene.")),
    );
  }
}


  int vegQuantity = 5;
  int nonVegQuantity = 5;
  bool isVegSelected = false;
  bool isNonVegSelected = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          "Listing Type: Donation",
        ),
        titleTextStyle: GoogleFonts.bricolageGrotesque(
          fontSize: 25,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField("Add Title", "Add food title", _titleController),
              buildTextField("Description", "Eg: tomatoes from the garden.",
                  _descriptionController,
                  maxLines: 3),
              buildTextField(
                  "Type of Food", "Cooked Food-Veg & NonVeg", _typeController),
              SizedBox(height: 16),
              Text("Food Quantity",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              buildQuantitySelector("Veg", isVegSelected, vegQuantity,
                  (bool? value) {
                setState(() {
                  isVegSelected = value ?? false;
                });
              }, (int value) {
                setState(() {
                  vegQuantity = value;
                });
              }),
              buildQuantitySelector("Non-Veg", isNonVegSelected, nonVegQuantity,
                  (bool? value) {
                setState(() {
                  isNonVegSelected = value ?? false;
                });
              }, (int value) {
                setState(() {
                  nonVegQuantity = value;
                });
              }),
              SizedBox(height: 16),
              Text("Photos:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt, size: 40),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt, size: 40),
                    onPressed: () {},
                  ),
                  Text("+Add more", style: TextStyle(color: Colors.blue)),
                ],
              ),
              SizedBox(height: 16),
              buildDateTimePicker(
                  "Expiration Date", _expirationDateController, true),
              buildDateTimePicker(
                  "Expiration Time", _expirationTimeController, false),
              SizedBox(
                height: 20,
              ),
              Text(
                'Analyse the food quality and hygiene before listing',
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                        fontStyle: FontStyle.italic

                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Homepage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Check",
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  )),
                   SizedBox(height: 8,
                  ),
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                 
                  Expanded(
                    child: Text(
                      "I assure that the food quality and hygiene has been maintained",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,  
                        fontStyle: FontStyle.italic
                        )
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _submitForm,
                child: Text("Submit",
                style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, String hint, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            maxLines: maxLines,
            validator: (value) =>
                value!.isEmpty ? "Field cannot be empty" : null,
          ),
        ],
      ),
    );
  }

  Widget buildQuantitySelector(String title, bool isSelected, int quantity,
      Function(bool?) onChanged, Function(int) onQuantityChanged) {
    return Row(
      children: [
        Checkbox(value: isSelected, onChanged: onChanged),
        Text(title),
        Spacer(),
        IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              if (quantity > 0) onQuantityChanged(quantity - 1);
            }),
        Text("$quantity"),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            onQuantityChanged(quantity + 1);
          },
        ),
      ],
    );
  }

  Widget buildDateTimePicker(
      String label, TextEditingController controller, bool isDate) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.calendar_today),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                controller.text =
                    intl.DateFormat('dd MMM, yyyy').format(pickedDate);
              }
            },
          ),
        ],
      ),
    );
  }
}
