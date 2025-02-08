import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../common/basic_app_buttons.dart';
import '../constant/App_Colour.dart';
import '../constant/customtextfield.dart';
import '../pages/Home_page_donars.dart';

class IndividualForm extends StatefulWidget {
  const IndividualForm({super.key});

  @override
  _IndividualFormState createState() => _IndividualFormState();
}

class _IndividualFormState extends State<IndividualForm> {
  final TextEditingController individualNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController aadharcardController = TextEditingController();
  final List<File> _images = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      String fileName = 'aadhar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = _storage.ref().child('aadhar_images/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _saveData() async {
    if (individualNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        numberController.text.isEmpty ||
        addressController.text.isEmpty ||
        pincodeController.text.isEmpty ||
        cityController.text.isEmpty ||
        aadharcardController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    List<String> imageUrls = [];
    for (File image in _images) {
      String? imageUrl = await _uploadImage(image);
      if (imageUrl != null) imageUrls.add(imageUrl);
    }

    await _firestore.collection('donors').add({
      'name': individualNameController.text,
      'email': emailController.text,
      'phone': numberController.text,
      'address': addressController.text,
      'pincode': pincodeController.text,
      'city': cityController.text,
      'aadhar_number': aadharcardController.text,
      'aadhar_images': imageUrls,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 20),
              Text(
                "Donor successfully created!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DonorDashboard()));
                },
                style: ElevatedButton.styleFrom(
                  elevation: 6,
                  backgroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Individual Name"),
          _buildTextField(individualNameController, 'Name', 'Enter Your Name', Icons.person),
          _buildLabel("Email"),
          _buildTextField(emailController, 'Email', 'Enter Email', Icons.email),
          _buildLabel("Aadhar Card Number"),
          _buildTextField(aadharcardController, 'Aadhar Card Number', 'Enter Aadhar Number', Icons.credit_card),
          _buildLabel("Phone Number"),
          _buildTextField(numberController, 'Phone Number', 'Enter Phone Number', Icons.phone),
          _buildLabel("Address"),
          _buildTextField(addressController, 'Address', 'Enter Address', Icons.location_on),
          _buildLabel("Pincode"),
          _buildTextField(pincodeController, 'Pincode', 'Enter Pincode', Icons.pin),
          _buildLabel("City"),
          _buildTextField(cityController, 'City', 'Enter your city', Icons.location_city),
          SizedBox(height: 20),
          _buildLabel("Upload Aadhar Card Image"),
          _buildImageUploader(),
          SizedBox(height: 40),
          Center(
            child: BasicAppButton(
              text: 'Submit',
              onPressed: _saveData,
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

  Widget _buildImageUploader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.add_a_photo, color: Colors.white),
            label: Text("Attach Image"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          _images.isNotEmpty
              ? Wrap(
                  spacing: 10,
                  children: _images.map((image) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(image, fit: BoxFit.cover),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _images.remove(image);
                            });
                          },
                        ),
                      ],
                    );
                  }).toList(),
                )
              : Text("No images selected", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
