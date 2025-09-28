import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthService> authservice = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email, password, and username
  Future<UserCredential> signUp(
      {required String email,
      required String password,
      required String userName}) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

//Save user info to firestore
    if (userCredential.user != null) {
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "uid": userCredential.user!.uid,
        "name": userName,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
    return userCredential;
  }

  // Login
  Future<UserCredential> login(
      {required String email, required String password}) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  //Reset Password with Email
  Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  //Update Username
  Future<void> updateUsername({required String userName}) async {
    await currentUser!.updateDisplayName(userName);

    //update firestore
    await _firestore.collection("users").doc(currentUser!.uid).update({
      "name": userName,
    });
  }

  //Delete Account
  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);

    //Delete from firestore
    await _firestore.collection("users").doc(currentUser!.uid).delete();

    //Delete from Firebase Auth
    await currentUser!.delete();
    await _auth.signOut();
  }

  // Reset password with current password
  Future<void> resetPasswordWithCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
