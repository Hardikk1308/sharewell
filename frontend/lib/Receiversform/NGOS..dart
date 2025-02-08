import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../common/basic_app_buttons.dart';
import '../constant/App_Colour.dart';
import '../constant/customtextfield.dart';
import '../pages/Home_page_receiver.dart';

class NGOS extends StatefulWidget {
  const NGOS({super.key});

  @override
  State<NGOS> createState() => _NGOSState();
}

class _NGOSState extends State<NGOS> {
  final TextEditingController EnterpriseController = TextEditingController();
  final TextEditingController OwnersNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController NumberController = TextEditingController();
  final TextEditingController AddressController = TextEditingController();
  final TextEditingController PincodeController = TextEditingController();
  final TextEditingController CityController = TextEditingController();
  final TextEditingController GovernmentidController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _submitData() async {
    try {
      // Ensure user is logged in
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in. Please sign in.");
      }

      // Collect form data
      Map<String, dynamic> restaurantData = {
        "restaurantName": EnterpriseController.text.trim(),
        "ownerName": OwnersNameController.text.trim(),
        "email": emailController.text.trim(),
        "phoneNumber": NumberController.text.trim(),
        "address": AddressController.text.trim(),
        "pincode": PincodeController.text.trim(),
        "city": CityController.text.trim(),
        "govern": GovernmentidController.text.trim(),
        "userId": user.uid, // Store user ID for security
      };

      // Store data in Firestore
      await _firestore.collection("restaurants").add(restaurantData);

      // Show success dialog
      _showSuccessDialog(context);
    } catch (e) {
      print("Error submitting data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting data: $e")),
      );
    }
  }

  @override
  void dispose() {
    EnterpriseController.dispose();
    OwnersNameController.dispose();
    emailController.dispose();
    NumberController.dispose();
    AddressController.dispose();
    PincodeController.dispose();
    CityController.dispose();
    GovernmentidController.dispose();
    super.dispose();
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 20),
              Text(
                "Receiver successfully created!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReceiverHomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 6,
                  backgroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Enterprise Name"),
            _buildTextField(EnterpriseController, 'Enterprise Name',
                'Enter Enterprise Name', Icons.business_outlined),
            _buildLabel("Owner Name"),
            _buildTextField(OwnersNameController, 'Owner Name',
                'Enter Owner Name', Icons.person),
            _buildLabel("Email"),
            _buildTextField(
                emailController, 'Email', 'Enter Email', Icons.mail),
            _buildLabel("Phone Number"),
            _buildTextField(NumberController, 'Phone Number',
                'Enter Phone Number', Icons.call),
            _buildLabel("Address"),
            _buildTextField(AddressController, 'Address', 'Enter Address',
                Icons.location_on),
            _buildLabel("PinCode"),
            _buildTextField(
                PincodeController, 'PinCode', 'Enter PinCode', Icons.pin),
            _buildLabel("City"),
            _buildTextField(
                CityController, 'City', 'Enter City', Icons.location_city),
            _buildLabel("License Number"),
            _buildTextField(GovernmentidController, 'License Number',
                'License Number', Icons.badge),
            SizedBox(height: 40),
            Center(
              child: BasicAppButton(
                text: 'Submit',
                onPressed: () {
                  _showSuccessDialog(context);
                },
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
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

  Widget _buildTextField(TextEditingController controller, String labelText,
      String hintText, IconData icon) {
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
