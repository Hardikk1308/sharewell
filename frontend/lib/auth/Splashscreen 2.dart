import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup.dart';

class SplashScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/splash 2.png',
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Be the link',
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Give with',
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ShareWell',
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "List extra food or clothes in seconds. NGOs collect and distribute to those in need. Track your donations and see real change.",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 90.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => Signup(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff673AB7),
                            padding: EdgeInsets.symmetric(
                              horizontal: 60.0,
                              vertical: 20.0,
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => Signup(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                              color: Color(0xff673AB7),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
