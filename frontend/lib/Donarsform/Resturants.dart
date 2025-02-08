import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../common/basic_app_buttons.dart';
import '../constant/App_Colour.dart';
import '../constant/customtextfield.dart';
import '../pages/Home_page_donars.dart';

class RestaurantForm extends StatefulWidget {
  const RestaurantForm({super.key});

  @override
  _RestaurantFormState createState() => _RestaurantFormState();
}

class _RestaurantFormState extends State<RestaurantForm> {
  final TextEditingController restaurantNameController = TextEditingController();
  final TextEditingController ownersNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController gstinController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _submitData() async {
    try {
      // Collecting form data
      Map<String, dynamic> restaurantData = {
        "restaurantName": restaurantNameController.text.trim(),
        "ownerName": ownersNameController.text.trim(),
        "email": emailController.text.trim(),
        "phoneNumber": numberController.text.trim(),
        "address": addressController.text.trim(),
        "pincode": pincodeController.text.trim(),
        "city": cityController.text.trim(),
        "gstin": gstinController.text.trim(),
        "timestamp": FieldValue.serverTimestamp(), // Adds timestamp
      };

      // Store data in Firestore
      await _firestore.collection("restaurants").add(restaurantData);

      // Show success dialog
      _showSuccessDialog(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting data: $e")),
      );
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle,
                  color: Colors.green, size: 60), // Success icon
              const SizedBox(height: 20),
              const Text(
                "Restaurant successfully created!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DonorDashboard()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 6,
                  backgroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: CustomFormField(
        Keyboard: keyboardType,
        labelText: label,
        hintText: hint,
        controller: controller,
        icon: icon,
      ),
    );
  }

 @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Resturant Name"),
          _buildTextField(restaurantNameController, 'Name', 'Enter Resturant Name', Icons.restaurant),
          _buildLabel("Owner Name"),
          _buildTextField(ownersNameController, 'Name', 'Enter Your Name', Icons.person),
          _buildLabel("Email"),
          _buildTextField(emailController, 'Email', 'Enter Email', Icons.credit_card),
          _buildLabel("Phone Number"),
          _buildTextField(numberController, 'Phone Number', 'Enter Phone Number', Icons.phone),
          _buildLabel("Address"),
          _buildTextField(addressController, 'Address', 'Enter Address', Icons.location_on),
          _buildLabel("Pincode"),
          _buildTextField(pincodeController, 'Pincode', 'Enter Pincode', Icons.pin),
          _buildLabel("City"),
          _buildTextField(cityController, 'City', 'Enter your city', Icons.location_city),
          _buildLabel("GSTIN Number"),
          _buildTextField(gstinController, 'GSTIN', 'Enter your GSTIN Number', Icons.numbers),
          Center(
            child: BasicAppButton(
              text: 'Submit',
              onPressed: _submitData,
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, String hintText, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: CustomFormField(
        Keyboard: TextInputType.text,
        labelText: labelText,
        hintText: hintText,
        controller: controller,
        icon: icon,
      ),
    );
  }
}
