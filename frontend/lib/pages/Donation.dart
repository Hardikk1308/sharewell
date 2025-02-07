import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../constant/App_Colour.dart';

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
        title: Text("Listing Type: Donation"),
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
                onPressed: () {
                  
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Donation Listed Successfully!")),
                    );
                  }
                },
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
