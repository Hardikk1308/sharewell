import 'package:flutter/material.dart';
import '../common/basic_app_buttons.dart';
import '../constant/App_Colour.dart';
import '../constant/customtextfield.dart';
import '../pages/Home_page_receiver.dart';

class NGOS extends StatefulWidget {
  const NGOS({super.key});

  @override
  State<NGOS> createState() => _NGOSState();
}

class _NGOSState extends State<NGOS> {
  final TextEditingController EnterpriseController = TextEditingController();
  final TextEditingController OwnersNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController NumberController = TextEditingController();
  final TextEditingController AddressController = TextEditingController();
  final TextEditingController PincodeController = TextEditingController();
  final TextEditingController CityController = TextEditingController();
  final TextEditingController GovernmentidController = TextEditingController();

  String? selectedGovID;
  List<String> govIDOptions = [
    'Aadhar Card',
    'PAN Card',
    'Voter ID',
  ];

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
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 20),
              Text(
                "Receiver successfully created!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePageReceiver()),
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
            _buildLabel("Enterprise Name"),
            _buildTextField(EnterpriseController, 'Enterprise Name',
                'Enter Enterprise Name', Icons.business_outlined),
            _buildLabel("Owner Name"),
            _buildTextField(OwnersNameController, 'Owner Name',
                'Enter Owner Name', Icons.person),
            _buildLabel("Email"),
            _buildTextField(
                emailController, 'Email', 'Enter Email', Icons.mail),
            _buildLabel("Phone Number"),
            _buildTextField(NumberController, 'Phone Number',
                'Enter Phone Number', Icons.call),
            _buildLabel("Address"),
            _buildTextField(AddressController, 'Address', 'Enter Address',
                Icons.location_on),
            _buildLabel("PinCode"),
            _buildTextField(
                PincodeController, 'PinCode', 'Enter PinCode', Icons.pin),
            _buildLabel("City"),
            _buildTextField(
                CityController, 'City', 'Enter City', Icons.location_city),
            _buildLabel("Government ID"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
                value: selectedGovID,
                hint: Text("Select Government ID"),
                items: govIDOptions.map((String id) {
                  return DropdownMenuItem<String>(
                    value: id,
                    child: Text(id),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGovID = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            _buildLabel('Government ID number'),
            _buildTextField(GovernmentidController, 'Government ID number',
                'Enter Number', Icons.numbers),
            SizedBox(height: 40),
            Center(
              child: BasicAppButton(
                text: 'Submit',
                onPressed: () {
                  _showSuccessDialog(context);
                },
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
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

  Widget _buildTextField(TextEditingController controller, String labelText,
      String hintText, IconData icon) {
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
}
