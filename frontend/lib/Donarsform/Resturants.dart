import 'package:flutter/material.dart';
import '../common/basic_app_buttons.dart';
import '../constant/App_Colour.dart';
import '../constant/customtextfield.dart';
import '../pages/Homepage.dart';

class RestaurantForm extends StatefulWidget {
  const RestaurantForm({super.key});

  @override
  State<RestaurantForm> createState() => _RestaurantFormState();
}

class _RestaurantFormState extends State<RestaurantForm> {
  final TextEditingController restaurantNameController =
      TextEditingController();
  final TextEditingController OwnersNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController NumberController = TextEditingController();
  final TextEditingController AddressController = TextEditingController();
  final TextEditingController PincodeController = TextEditingController();
  final TextEditingController CityController = TextEditingController();
  final TextEditingController GSTINController = TextEditingController();
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: const Text(
                "Restaurant Name",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 5),
            CustomFormField(
              Keyboard: TextInputType.text,
              labelText: 'Restaurant Name',
              hintText: 'Enter Restaurant Name',
              controller: restaurantNameController,
              icon: Icons.restaurant,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: const Text("Owner Name",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            SizedBox(height: 5),
            CustomFormField(
              Keyboard: TextInputType.text,
              labelText: 'Owner Name',
              hintText: 'Enter Owner Name',
              controller: OwnersNameController,
              icon: Icons.person,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: const Text(
                "Email Name",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 5),
            CustomFormField(
              Keyboard: TextInputType.emailAddress,
              labelText: 'Email Name',
              hintText: 'Enter Email Name',
              controller: emailController,
              icon: Icons.mail,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: const Text(
                "Phone Number",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            CustomFormField(
              Keyboard: TextInputType.number,
              labelText: 'Phone Number',
              hintText: 'Phone Number',
              controller: NumberController,
              icon: Icons.call,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: const Text(
                "Address",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            CustomFormField(
              Keyboard: TextInputType.text,
              labelText: 'Address',
              hintText: 'Enter Address',
              controller: AddressController,
              icon: Icons.location_on,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: const Text(
                "PinCode",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            CustomFormField(
              Keyboard: TextInputType.number,
              labelText: 'PinCode',
              hintText: 'Enter PinCode',
              controller: PincodeController,
              icon: Icons.pin,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: const Text(
                "City",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            CustomFormField(
              Keyboard: TextInputType.text,
              labelText: 'City',
              hintText: 'Enter City ',
              controller:CityController,
              icon: Icons.location_city,
            ),
             SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: const Text(
                "GSTIN Number",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            CustomFormField(
              Keyboard: TextInputType.number,
              labelText: 'GSTIN Number',
              hintText: 'GSTIN Number',
              controller: GSTINController,
              icon: Icons.numbers,
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: BasicAppButton(
                text: 'Submit',
                onPressed: () {
                  _showSuccessDialog(context);
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
