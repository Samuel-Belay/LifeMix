import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  Future<void> signIn() async {
    try {
      _user = await _googleSignIn.signIn();
      notifyListeners();
    } catch (e) {
      print("Sign-in error: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      print("Sign-out error: $e");
    }
  }
}
