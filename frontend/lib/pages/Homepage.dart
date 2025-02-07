import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For decoding JSON responses
import '../auth/login.dart';
import '../constant/App_Colour.dart';
import '../constant/SideNavgationbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  File? _image;
  String? _expiryDate; // To store the expiry date fetched from the backend
  bool _isLoading = false; // To show a loading indicator during API call
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Loginpage()),
    );
  }

  Future<void> _captureImage() async {
    // Request camera permission
    var status = await Permission.camera.request();

    if (status.isGranted) {
      // Capture image using camera
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _expiryDate = null; // Reset expiry date when a new image is captured
        });
        // Send image to backend for processing
        await _sendImageToFastAPI(_image!);
      }
    } else if (status.isPermanentlyDenied) {
      // Show a dialog to guide the user to app settings
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera permission permanently denied. Please enable it in settings.")),
      );
      openAppSettings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera permission denied")),
      );
    }
  }

  Future<void> _sendImageToFastAPI(File image) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://5853-2402-8100-29d3-5475-1549-62a3-77a9-7af4.ngrok-free.app/detect-expiry/'), // Replace with your backend URL
      );

      // Attach the image file to the request
      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      // Send the request to the backend
      var response = await request.send();

      if (response.statusCode == 200) {
        // Parse the response from the backend
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);

        setState(() {
          _expiryDate = jsonResponse['expiry_date']; // Extract expiry date from response
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Expiry date detected successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to detect expiry date. Status code: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred while sending image: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        drawer: MyDrawer(logoutCallback: _logout), // Side Navigation Drawer
        body: Builder(
          builder: (context) => Column(
            children: [
              SizedBox(height: 50), // Space for status bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.black, size: 30), // Custom Drawer Icon
                      onPressed: () {
                        Scaffold.of(context).openDrawer(); // Open drawer manually
                      },
                    ),
                    Text(
                      'Hi ${user?.displayName ?? "User"}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _captureImage,
                icon: Icon(Icons.camera_alt),
                label: Text("Scan Expiry Date"),
              ),
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(), // Show loading indicator during API call
                ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.file(_image!),
                ),
              if (_expiryDate != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Detected Expiry Date:\n$_expiryDate",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
