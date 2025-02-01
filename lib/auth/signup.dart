import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shareweel_app/common/basic_app_buttons.dart';
import 'package:shareweel_app/pages/Homepage.dart';
import '../constant/customtextfield.dart';
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
  Future<void> _signup() async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print(userCredential);
      // Navigate to homepage after successful signup
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Homepage()));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? 'Signup failed')));
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Signup",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  controller: emailController,
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  obscureText: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  labelText: 'Confirm Password',
                  hintText: 'Confirm password',
                  obscureText: true,
                  controller: confirmPasswordController,
                ),

                // Add a button to login
                const SizedBox(height: 25),

                BasicAppButton(
                  text: 'Signup',
                  onPressed: () async {
                    await _signup();
                    if (passwordController.text.trim() ==
                        confirmPasswordController.text.trim()) {
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                        // Navigate to homepage or show success message
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Homepage()));
                      } on FirebaseAuthException {
                        // Handle errors (e.g., weak password, email already in use)
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Passwords do not match')),
                      );
                    }
                  },
                ),
                const Divider(
                  color: Colors.black54,
                  height: 50,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await signupwithgoogle();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Homepage()));
                      },
                      child:  Container(
                        // radius: 30,
                        height: 50,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey[200],
                          image: const DecorationImage(
                            image: AssetImage('assets/images/googl.jpeg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                 
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Loginpage())),
                    child: RichText(
                        text: const TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Colors.blue,
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
