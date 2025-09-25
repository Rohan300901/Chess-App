import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../helper/constants.dart';
import '../models/user_model.dart';

class AuthenticationProvider extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  bool _isSignedIn = false;
  String? _uId = "";
  UserModel? _user;


  //Getters Methods.........
  bool get isLoading => _isLoading;
  bool get isSignedIn => _isSignedIn;
  String? get uId => _uId;
  UserModel? get user => _user;

  void setIsLoadin (bool value){
    _isLoading = value;
    notifyListeners();
  }
  void setIsSignIn(bool value){
    _isSignedIn = value;
    notifyListeners();
  }

  Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required Function onError,
  }) async {
    setIsLoadin(true);
    notifyListeners();
    try {
      UserCredential _userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _uId = _userCredential.user!.uid;
      notifyListeners();
      return _userCredential;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered. Please log in instead.';
          break;
        case 'invalid-email':
          message = 'Invalid email format. Please enter a valid email.';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          message = 'Password is too weak. Use at least 6 characters.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;
        case 'network-request-failed':
          message = 'No internet connection. Please check your network.';
          break;
        default:
          message = e.message ?? 'Signup failed. Please try again.';
      }
      onError(message);
      setIsLoadin(false);
      notifyListeners();
    } on FirebaseException catch (e) {
      String message;
      switch (e.code) {
        case 'permission-denied':
          message = 'Permission denied. Please contact support.';
          break;
        case 'unavailable':
          message = 'Firestore service unavailable. Please try again later.';
          break;
        case 'cancelled':
          message = 'Request was cancelled. Please retry.';
          break;
        case 'deadline-exceeded':
          message = 'The request timed out. Try again.';
          break;
        case 'already-exists':
          message = 'User data already exists.';
          break;
        case 'internal':
          message = 'Internal server error. Please try again.';
          break;
        default:
          message = e.message ?? 'Failed to save data. Please try again.';
      }
      onError(message);
      setIsLoadin(false);
      notifyListeners();
    }
  }
  Future<UserCredential?> saveUserDatatoFireStore({
    required UserModel currentUser,
    void Function()? onSuccess,
    required Function(String) onError,
  }) async {
    try {
      _user = currentUser;
      currentUser.createdAt = DateTime.now().millisecondsSinceEpoch.toString();

      await _firestore.collection(Constants.user).doc(uId).set(currentUser.toJson());
      if (onSuccess != null) {
        onSuccess();
      }
      setIsLoadin(false);
      notifyListeners();
    }  on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered. Please log in instead.';
          break;
        case 'invalid-email':
          message = 'Invalid email format. Please enter a valid email.';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          message = 'Password is too weak. Use at least 6 characters.';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;
        case 'network-request-failed':
          message = 'No internet connection. Please check your network.';
          break;
        default:
          message = e.message ?? 'Signup failed. Please try again.';
      }
      onError(message);
      setIsLoadin(false);
      notifyListeners();
    } on FirebaseException catch (e) {
      String message;
      switch (e.code) {
        case 'permission-denied':
          message = 'Permission denied. Please contact support.';
          break;
        case 'unavailable':
          message = 'Firestore service unavailable. Please try again later.';
          break;
        case 'cancelled':
          message = 'Request was cancelled. Please retry.';
          break;
        case 'deadline-exceeded':
          message = 'The request timed out. Try again.';
          break;
        case 'already-exists':
          message = 'User data already exists.';
          break;
        case 'internal':
          message = 'Internal server error. Please try again.';
          break;
        default:
          message = e.message ?? 'Failed to save data. Please try again.';
      }
      onError(message);
      setIsLoadin(false);
      notifyListeners();
    }
  }




  //Sign out - the Current User
  Future<void> signOut() async{
    await _auth.signOut();
    setIsSignIn(false);
    notifyListeners();
  }
  Future<UserCredential?> logInUserWithEmailAndPassword({
    required String email,
    required String password,
    required Function(String) onError,
  }) async {
    try {
      setIsLoadin(true);
      notifyListeners();
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _uId = _userCredential.user!.uid;
      setIsLoadin(false);
      notifyListeners();
      return _userCredential;
    }on FirebaseException catch (e){
      String message;

      switch (e.code) {
        case "invalid-email":
          message = "The email address is badly formatted.";
          break;
        case "user-not-found":
          message = "No account found with this email.";
          break;
        case "wrong-password":
          message = "Incorrect password. Please try again.";
          break;
        case "too-many-requests":
          message = "Too many failed attempts. Please try again later.";
          break;
        case "network-request-failed":
          message = "Network error. Check your internet connection.";
          break;
        case "user-disabled":
          message = "This account has been disabled.";
          break;
        case 'invalid-credential':
          message = 'Authentication credential is invalid or expired. Please try signing in again.';
          break;
        default:
          message = "An unexpected error occurred. Please try again.";
      }
      onError(message);
      print("Error before Message: $e");
      setIsLoadin(false);
      notifyListeners();
      return null;
    }
  }

}