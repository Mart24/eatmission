import 'package:firebase_auth/firebase_auth.dart';

// This is the authentication to Firebase
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().map(
            (User user) => user?.uid,
      );

  // GET UID
  Future<String> getCurrentUID() async {
    return (_firebaseAuth.currentUser).uid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(String email, String password,
      String name) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update the username
    await updateUserName(name, authResult.user);
    return authResult.user.uid;
  }

  Future updateUserName(String name, User currentUser) async {
    await currentUser.updateDisplayName(name);
    await currentUser.reload();
  }

  // Email & Password Sign In
  Future<String> signInWithEmailAndPassword(String email,
      String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password))
        .user
        .uid;
  }

  // Sign Out
  signOut() async {
    return await _firebaseAuth.signOut();
  }

  // Reset Password
  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
  // GOOGLE

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Naam kan niet leeg zijn";
    }
    if (value.length < 2) {
      return "Minsten 2 tekens lang";
    }
    if (value.length > 50) {
      return "Niet langer dan 50 tekens";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email kan niet leeg zijn";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Wachtwoord kan niet leeg zijn";
    }
    return null;
  }
}
