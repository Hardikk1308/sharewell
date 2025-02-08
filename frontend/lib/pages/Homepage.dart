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
  String? _expiryDate; // To store expiry date from backend
  bool _isLoading = false;
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
    var status = await Permission.camera.request();

    if (status.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _expiryDate = null; // Reset expiry date
        });
        await _sendImageToFastAPI(_image!);
      }
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera permission permanently denied. Enable it in settings.")),
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
      _isLoading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://7486-117-203-246-41.ngrok-free.app/analyze-food/'),
      );

      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);

        setState(() {
          _expiryDate = jsonResponse['expiry_date']; // Extract expiry date
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Expiry date detected successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to detect expiry date. Status: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        drawer: MyDrawer(logoutCallback: _logout),
        body: Builder(
          builder: (context) => Column(
            children: [
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.black, size: 30),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    Text(
                      'Hi ${user?.displayName ?? "User"}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  child: CircularProgressIndicator(),
                ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.file(_image!),
                ),
              if (_expiryDate != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: 1.0,
                    child: Card(
                      color: Colors.green.shade100,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Detected Expiry Date",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _expiryDate!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
