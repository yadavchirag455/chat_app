import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailForDirectLogin = TextEditingController();

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

  resetPassword() {
    try {
      FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailForDirectLogin.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        'Password Reset Email is Sent to Your Mail',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      )));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          'This is User Not Found Please Register',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        )));
      }
    }
  }

  final _formkey = GlobalKey<FormState>();
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
                      'Forgot Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Reset Your Password',
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
                    height: MediaQuery.of(context).size.height / 3.5,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Form(
                      key: _formkey,
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
                              child: TextFormField(
                                validator: validateEmail,
                                controller: _emailForDirectLogin,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.email_outlined)),
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.black38)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // const Text(
                            //   'Password',
                            //   style: TextStyle(
                            //       color: Colors.black,
                            //       fontWeight: FontWeight.w500,
                            //       fontSize: 18),
                            // ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // Container(
                            //   // margin: const EdgeInsets.symmetric(horizontal: 20),
                            //   padding:
                            //       const EdgeInsets.symmetric(horizontal: 10),
                            //   decoration: BoxDecoration(
                            //       border: Border.all(
                            //           width: 1, color: Colors.black38)),
                            //   child: TextFormField(
                            //     // controller: _passwordForLogin,
                            //     validator: (value) {
                            //       final regex = RegExp(r'^\d{6,}');
                            //       if (value == null ||
                            //           value.isEmpty ||
                            //           !regex.hasMatch(value)) {
                            //         return 'Password must be at least 6 digits.';
                            //       }
                            //       return null; // No error
                            //     },
                            //     obscureText: true,
                            //     decoration: InputDecoration(
                            //         border: InputBorder.none,
                            //         prefixIcon: Icon(Icons.password_outlined)),
                            //   ),
                            // ),
                            // Container(
                            //   alignment: Alignment.bottomRight,
                            //   child: const Text(
                            //     'Forgot Password',
                            //     style: TextStyle(
                            //         color: Colors.black,
                            //         fontWeight: FontWeight.w500,
                            //         fontSize: 18),
                            //   ),
                            // ),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (_formkey.currentState!.validate()) {
                                    resetPassword();
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF7f30f3),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Text(
                                    'Send Email',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text('Don\'t have an account?'),
                            //     TextButton(
                            //         onPressed: () {
                            //           Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                   builder: (context) => Signup()));
                            //         },
                            //         child: Text('Sign-up Now'))
                            //   ],
                            // )
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
