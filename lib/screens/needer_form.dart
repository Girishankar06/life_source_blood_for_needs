import 'package:bloodbank/reusable_widgets/reusable_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Needer_form extends StatefulWidget {
  final String email;
  Needer_form(this.email);

  @override
  _Needer_formstate createState() => _Needer_formstate(email);
}

class _Needer_formstate extends State<Needer_form> {
  final String email;
  _Needer_formstate(this.email);

  String bg1 = "";
  String bg2 = "";
  String first = "";
  String age1 = "";
  String email1 = "";
  String phone = "";
  String add1 = "";
  String add2 = "";
  String state = "";
  String country = "";
  String phone2 = "";

  final TextEditingController _firstnameTextController =
      TextEditingController();
  final TextEditingController _ageTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _add1TextController = TextEditingController();
  final TextEditingController _add2TextController = TextEditingController();
  final TextEditingController _stateTextController = TextEditingController();
  final TextEditingController _countryTextController = TextEditingController();
  final TextEditingController _phone2TextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text('Register for blood',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              profiletextfield("Name", false, _firstnameTextController),
              const SizedBox(height: 20),
              profiletextfield("Age", false, _ageTextController),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                items: <String>["A", "B", "AB", "O"]
                    .map((e) => DropdownMenuItem(child: Text(e), value: e))
                    .toList(),
                onChanged: (String? val) {
                  setState(() {
                    bg1 = val!;
                  });
                },
                icon: const Icon(Icons.arrow_drop_down_circle,
                    color: Colors.black),
                decoration: const InputDecoration(
                  hintText: "Blood Type",
                  hintStyle: TextStyle(color: Colors.black38, fontSize: 15),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                items: <String>["+", "-"]
                    .map((e) => DropdownMenuItem(child: Text(e), value: e))
                    .toList(),
                onChanged: (String? val) {
                  setState(() {
                    bg2 = val!;
                  });
                },
                icon: const Icon(Icons.arrow_drop_down_circle,
                    color: Colors.black),
                decoration: const InputDecoration(
                  hintText: "Antigen",
                  hintStyle: TextStyle(color: Colors.black38, fontSize: 15),
                ),
              ),
              const SizedBox(height: 20),
              profiletextfield("Email", false, _emailTextController),
              const SizedBox(height: 20),
              profiletextfield("Phone", false, _phoneTextController),
              const SizedBox(height: 20),
              profiletextfield("Address Line 1", false, _add1TextController),
              const SizedBox(height: 20),
              profiletextfield("Address Line 2", false, _add2TextController),
              const SizedBox(height: 20),
              profiletextfield("State", false, _stateTextController),
              const SizedBox(height: 20),
              profiletextfield("Country", false, _countryTextController),
              const SizedBox(height: 20),
              profiletextfield("Phone number 2", false, _phone2TextController),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => validateAndSubmit(),
                child: Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black12,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(95, 10, 20, 0),
                    child: Text(
                      "Submit",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void validateAndSubmit() async {
    first = _firstnameTextController.text;
    age1 = _ageTextController.text;
    email1 = _emailTextController.text;
    phone = _phoneTextController.text;
    add1 = _add1TextController.text;
    add2 = _add2TextController.text;
    phone2 = _phone2TextController.text;
    state = _stateTextController.text;
    country = _countryTextController.text;

    if (first.isEmpty) {
      showError('Firstname is empty');
    } else if (age1.isEmpty) {
      showError('Age is empty');
    } else if (bg1.isEmpty) {
      showError('Blood group is empty');
    } else if (bg2.isEmpty) {
      showError('Antigen is empty');
    } else if (email1.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
            .hasMatch(email1)) {
      showError('Enter a valid email');
    } else if (phone.isEmpty || !RegExp(r"^[0-9]+$").hasMatch(phone)) {
      showError('Enter a valid phone');
    } else if (add1.isEmpty) {
      showError('Address line 1 is empty');
    } else if (state.isEmpty) {
      showError('State is empty');
    } else if (country.isEmpty) {
      showError('Country is empty');
    } else {
      try {
        await createUser();
      } catch (e) {
        showError('Error submitting data');
      }
    }
  }

  Future<void> createUser() async {
    final user = FirebaseFirestore.instance.collection('needer').doc(email);
    final json = {
      'first': first,
      'age': int.tryParse(age1) ?? 0,
      'email': email1,
      'phone': phone,
      'add1': add1,
      'add2': add2,
      'state': state,
      'country': country,
      'phone2': phone2,
      'blood': bg1,
      'antigen': bg2,
    };
    await user.set(json);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Submitted')));
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
