import 'dart:developer';
import 'package:chat_app_yt_shivam_gupta_may/screens/home.dart';
import 'package:chat_app_yt_shivam_gupta_may/services/database.dart';
import 'package:chat_app_yt_shivam_gupta_may/services/shared_preferance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passWordController = TextEditingController();
  final _confirmPassWordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  registration() async {
    // log('You have enter into registraion function with ${_emailController.text}  ${_passWordController.text}');
    if (_passWordController.text == _confirmPassWordController.text) {
      log('You have enter into registraion function with ${_emailController.text}  ${_passWordController.text}');
      try {
        log('${_passWordController} ${_emailController}');
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passWordController.text);

        log('${_passWordController} ${_emailController}');

        String id = randomAlphaNumeric(10);
        String user = _emailController.text.replaceAll('@gmail.com', '');
        String updateUserName = user.toUpperCase();
        String firstletter = user.substring(0, 1).toUpperCase();

        Map<String, dynamic> userInfoMap = {
          "name": user,
          "email": _emailController.text,
          "password": _passWordController.text,
          "username": updateUserName,
          "searchKey": firstletter,
          "id": id
        };
        // database data entry
        await DatabaseMethod().addUserDetails(userInfoMap, id);

        // shared preferwnce data entry
        await SharedPreferanceHelper().saveUserId(id);
        await SharedPreferanceHelper().saveUserEmail(_emailController.text);
        await SharedPreferanceHelper().saveUserName(updateUserName);
        await SharedPreferanceHelper().saveUserDisplayName(user);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'Registration Successfully',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )));

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
            'Weak Password',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                'Account already Exist',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )));
        }
        ;
      }
    }
  }

  String? validateEmail(String? value) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.0,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF7f30f3), Color(0xFF6380fb)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(
                          MediaQuery.of(context).size.width, 105))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'SignUp',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Create a new Account ',
                      style: TextStyle(
                          color: Color(0xFFbbb0ff),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    height: MediaQuery.of(context).size.height / 1.55,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Name',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            // margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.black38)),
                            child: TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Your Name';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.person)),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Email',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            // margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.black38)),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              validator: validateEmail,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.email_outlined)),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Password',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            // margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.black38)),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                final regex = RegExp(r'^\d{6,}');
                                if (value == null ||
                                    value.isEmpty ||
                                    !regex.hasMatch(value)) {
                                  return 'Password must be at least 6 digits.';
                                }
                                return null; // No error
                              },
                              controller: _passWordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.password_outlined)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Confirm Password',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            // margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.black38)),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                final regex = RegExp(r'^\d{6,}');
                                if (value == null ||
                                    value.isEmpty ||
                                    !regex.hasMatch(value)) {
                                  return 'Password must be at least 6 digits.';
                                }
                                return null; // No error
                              },
                              controller: _confirmPassWordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.password_outlined)),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                log('Signup tapped');

                                if (_formKey.currentState!.validate()) {
                                  registration();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF7f30f3),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Text(
                                  'SignUp',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
