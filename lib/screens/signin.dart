import 'package:chat_app_yt_shivam_gupta_may/screens/forgot_password.dart';
import 'package:chat_app_yt_shivam_gupta_may/screens/signup.dart';
import 'package:chat_app_yt_shivam_gupta_may/services/database.dart';
import 'package:chat_app_yt_shivam_gupta_may/services/shared_preferance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class SingIn extends StatefulWidget {
  const SingIn({super.key});

  @override
  State<SingIn> createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  final _emailForLogin = TextEditingController();
  final _passwordForLogin = TextEditingController();

  String? name;
  String? email;
  String? id;
  String? userName;

  userLogIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailForLogin.text, password: _passwordForLogin.text);

      QuerySnapshot querySnapshot =
          await DatabaseMethod().getUserbyEmail(_emailForLogin.text);

      name = "${querySnapshot.docs[0]["name"]}";
      email = "${querySnapshot.docs[0]["email"]}";
      id = "${querySnapshot.docs[0]["id"]}";
      userName = "${querySnapshot.docs[0]["username"]}";

      await SharedPreferanceHelper().saveUserName(userName!);
      await SharedPreferanceHelper().saveUserEmail(email!);
      await SharedPreferanceHelper().saveUserId(id!);
      await SharedPreferanceHelper().saveUserDisplayName(name!);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'No User Found For the Email id',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'Password is Wrong for the Given Email',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        )));
      }
    }
  }

  final _formKey = GlobalKey<FormState>();

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
                      'SignIn',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Login to your Account ',
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
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.black38)),
                              child: TextFormField(
                                validator: validateEmail,
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailForLogin,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.black38)),
                              child: TextFormField(
                                controller: _passwordForLogin,
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
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.password_outlined)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPassword()));
                              },
                              child: Container(
                                alignment: Alignment.bottomRight,
                                child: const Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    userLogIn();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF7f30f3),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Text(
                                    'SignIn',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Don\'t have an account?'),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Signup()));
                                    },
                                    child: Text('Sign-up Now'))
                              ],
                            )
                          ],
                        ),
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
