import 'package:firebase_auth/firebase_auth.dart';

class authMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await auth.currentUser;
  }
}
