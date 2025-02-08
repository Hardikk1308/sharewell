import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../common/basic_app_buttons.dart';
import '../constant/App_Colour.dart';
import '../constant/customtextfield.dart';
import '../pages/Role.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Signup with Google
  Future<UserCredential> signupwithgoogle() async {
    try {
      await GoogleSignIn().signOut();
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception("Google sign-in aborted by user");
      }
      final googleAuth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(cred);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-in failed: ${e.toString()}')),
      );
      rethrow;
    }
  }

  // Signup with email and password
 Future<void> signUpUser(String email, String password, String name, String role) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Get the user's UID
    String uid = userCredential.user!.uid;

    // Store user details in Firestore
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'role': role, // Assign role here (e.g., "admin", "donor", "receiver")
      'timestamp': FieldValue.serverTimestamp(),
    });

    print("User Registered and Role Assigned!");
  } catch (e) {
    print("Error: $e");
  }
}

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/signup.png'),
                const Text(
                  "Let's get you started!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  Keyboard: TextInputType.emailAddress,

                  icon: Icons.email,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty';
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}")
                        .hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  Keyboard: TextInputType.text,

                  icon: Icons.lock,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  Keyboard: TextInputType.text,
                  icon: Icons.lock,
                  labelText: 'Confirm Password',
                  hintText: 'Confirm password',
                  obscureText: true,
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm Password cannot be empty';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                BasicAppButton(
                  text: 'Signup',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signUpUser(
                        emailController.text,
                        passwordController.text,
                        'User Name', // Replace with actual user name
                        'User Role'  // Replace with actual user role
                      );
                    }
                  },
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await signupwithgoogle();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Role()),
                    );
                  },
                  child: Container(
                    height: 45,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/search.png',
                            height: 20, width: 30),
                        const SizedBox(width: 10),
                        const Text(
                          'Sign up with Google',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Loginpage())),
                    child: RichText(
                        text: const TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.deepPurple,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
