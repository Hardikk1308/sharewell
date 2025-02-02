import 'package:flutter/material.dart';
import '../common/basic_app_buttons.dart';
import '../constant/App_Colour.dart';
import '../constant/customtextfield.dart';
import '../pages/Homepage.dart';


class IndividualForm extends StatelessWidget {
  IndividualForm({super.key});

  final TextEditingController individualNameController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController NumberController = TextEditingController();
  final TextEditingController AddressController = TextEditingController();
  final TextEditingController PincodeController = TextEditingController();
  final TextEditingController CityController = TextEditingController();
  final TextEditingController AadharcardController = TextEditingController();
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
              Icon(Icons.check_circle,
                  color: Colors.green, size: 60), // Success icon
              SizedBox(height: 20),
              Text(
                "Donor successfully created!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: const Text(
              "Individual Name",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          CustomFormField(
            Keyboard: TextInputType.text,
            labelText: 'Name',
            hintText: 'Enter Your Name',
            controller: individualNameController,
            icon: Icons.person,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text("Email",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                )),
          ),
          SizedBox(
            height: 5,
          ),
          CustomFormField(
            Keyboard: TextInputType.emailAddress,
            labelText: 'Email',
            hintText: 'Enter Email',
            controller: emailController,
            icon: Icons.email,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "Aadhar Card Number",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          CustomFormField(
            Keyboard: TextInputType.number,
            labelText: 'Aadhar car Number',
            hintText: 'Enter Phone Number',
            controller: AadharcardController,
            icon: Icons.credit_card,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "Phone Number",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          CustomFormField(
            Keyboard: TextInputType.phone,
            labelText: 'Phone Number',
            hintText: 'Enter Phone Number',
            controller: NumberController,
            icon: Icons.phone,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text("Address",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                )),
          ),
          SizedBox(
            height: 5,
          ),
          CustomFormField(
            Keyboard: TextInputType.streetAddress,
            labelText: 'Address',
            hintText: 'Enter Address',
            controller: AddressController,
            icon: Icons.location_on,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text("Pincode",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                )),
          ),
          SizedBox(
            height: 5,
          ),
          CustomFormField(
            Keyboard: TextInputType.number,
            labelText: 'Pincode',
            hintText: 'Enter Pincode',
            controller: PincodeController,
            icon: Icons.pin,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "City",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          CustomFormField(
            Keyboard: TextInputType.number,
            labelText: 'City',
            hintText: 'Enter your city',
            controller: CityController,
            icon: Icons.location_city,
          ),
          const SizedBox(height: 40),
          Center(
            child: BasicAppButton(
              text: 'Submit',
              onPressed: () {
                _showSuccessDialog(context);
              },
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
