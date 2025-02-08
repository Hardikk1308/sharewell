import 'package:flutter/material.dart';
import '../../Receiversform/Individual.dart';
import '../../Receiversform/NGOS..dart';
import '../../common/Cards/Card 1.dart';
import '../../constant/App_Colour.dart';

class ReceiversPage extends StatefulWidget {
  const ReceiversPage({super.key});

  @override
  _ReceiversPageState createState() => _ReceiversPageState();
}

class _ReceiversPageState extends State<ReceiversPage> {
  String selectedType = ""; // Store the selected type

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: const Text("Receiver Type")),
          titleTextStyle: TextStyle(
            // color: AppColors.primary,
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xffFFFFFF),
        ),
        backgroundColor: AppColors.background,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SelectionCard(
                  image: "assets/images/ngo1.png",
                  text: "NGO's/Trust",
                  isSelected: selectedType == "Receiver",
                  onTap: () {
                    setState(() {
                      selectedType = "Receiver";
                    });
                  },
                ),
                const SizedBox(width: 20),
                SelectionCard(
                  image: "assets/images/individual.png",
                  text: "Individual",
                  isSelected: selectedType == "Individual",
                  onTap: () {
                    setState(() {
                      selectedType = "Individual";
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: selectedType == "Receiver"
                  ? NGOS()
                  : selectedType == "Individual"
                      ? Individual_Form()
                      : const Center(
                          child: Text("Select a Donor Type"),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
