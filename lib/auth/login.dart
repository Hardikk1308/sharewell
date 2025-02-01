import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shareweel_app/auth/signup.dart';
import 'package:shareweel_app/pages/Homepage.dart';

import '../common/basic_app_buttons.dart';
import '../constant/customtextfield.dart';


class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isChecked = false;

  Future<void> _login() async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print(userCredential);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Homepage()));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? 'Login failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login page",
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
                validator: (p0) =>
                    !p0!.contains('@') ? 'Please enter a valid email' : null,
              ),
              const SizedBox(height: 20),
              CustomFormField(
                labelText: 'Password',
                hintText: 'Enter your password',
                obscureText: true,
                controller: passwordController,
                validator: (p0) => p0!.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
        
              // Add a button to login
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      }),
                  const Padding(
                    padding: EdgeInsets.only(right: 60.0),
                    child: Text('Remember me',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                  TextButton(
                      onPressed: () {}, child: const Text('Forgot Password?',
                      style: TextStyle(color: Colors.blue, fontSize: 16))),
                ],
              ),
              const SizedBox(height: 20),
        
              BasicAppButton(
                text: 'Login',
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Homepage()));
        
                  await _login();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Signup())),
                  child: RichText(
                      text: const TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Signup',
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
    );
  }
}
