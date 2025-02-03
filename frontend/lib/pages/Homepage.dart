import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
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
        });
        _sendImageToFastAPI(_image!);
      }
    } else {
      print("Camera permission denied");
    }
  }

  Future<void> _sendImageToFastAPI(File image) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://127.0.0.1:8000/detect-expiry/'),
  );

  request.files.add(await http.MultipartFile.fromPath('file', image.path));

  var response = await request.send();
  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    print("Server Response: $responseData");
  } else {
    print("Image upload failed with status code: ${response.statusCode}");
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
                padding: const EdgeInsets.only(),
                child: IconButton(
                  icon: Icon(Icons.menu,
                      color: Colors.black, size: 30), // Custom Drawer Icon
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // Open drawer manually
                  },
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
