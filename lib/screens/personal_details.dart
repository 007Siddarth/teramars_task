import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails(
      {super.key, required this.formKey, required this.onNext});
  final GlobalKey<FormState> formKey;
  final Function(bool) onNext;
  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  void onNextClicked() {
    // Call the callback function and pass true to indicate next step
    widget.onNext(false);
  }

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();

    super.dispose();
  }

  void userDetails() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      if (widget.formKey.currentState!.validate()) {
        // Get the values from the text controllers
        String firstName = firstNameController.text;
        String lastName = lastNameController.text;

        String userUid = FirebaseAuth.instance.currentUser!.uid;

        // Add personal details data to Firestore collection
        await FirebaseFirestore.instance.collection('users').doc(userUid).set({
          'firstName': firstName,
          'lastName': lastName,
          'courseValue': selectedCourseValue,
        });
        Navigator.of(context).pop();
      }
    } on FirebaseException catch (e) {
      showErrorMessage(e.code);
      Navigator.of(context).pop();
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // void userDetails() {
  //   if (widget.formKey.currentState!.validate()) {
  //     // Get the values from the text controllers
  //     String firstName = firstNameController.text.trim();
  //     String lastName = lastNameController.text.trim();

  //     // Call the onSaveUserDetails callback with the user details
  //     print(firstName);

  //     widget.onSaveUserDetails(firstName, lastName, selectedCourseValue);
  //   }
  // }

  List<Map<String, String>> dropDownListData = [
    {"title": "BA", "value": "1"},
    {"title": "MCA", "value": "2"},
    {"title": "B.Tech", "value": "3"},
    {"title": "M.Tech", "value": "4"},
  ];

  String selectedCourseValue = "";

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.of(context).viewInsets;

    return SingleChildScrollView(
      reverse: true, // Scrolls content upwards
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20 + padding.bottom), // Add padding for keyboard
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Let Us Know You Better..',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    'First Name', // 3. Log In Text
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                child: TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                  ),
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    'Last Name', // 3. Log In Text
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                child: TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                  ),
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your Last name";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              buildRegisterDropdown(),

              //
              //
              //
              //
              //
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (widget.formKey.currentState!.validate()) {
                          userDetails();
                        }
                        onNextClicked();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRegisterDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Register As',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '*',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          child: InputDecorator(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              value: selectedCourseValue,
              isDense: true,
              isExpanded: true,
              menuMaxHeight: 200,
              borderRadius: BorderRadius.circular(20.0),
              items: [
                const DropdownMenuItem<String>(
                  value: "",
                  child: Text("-Select-"),
                ),
                ...dropDownListData.map((e) {
                  return DropdownMenuItem<String>(
                    value: e['value']!,
                    child: Text(e['title']!),
                  );
                }),
              ],
              onChanged: (newValue) {
                setState(() {
                  selectedCourseValue = newValue!;
                });
              },
            ),
          ),
        ),
        // Display error message if no option is selected
        if (selectedCourseValue.isEmpty)
          const Padding(
            padding: EdgeInsets.only(left: 5, top: 2),
            child: Text(
              'Please select an option',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
