import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart'; // NEW IMPORT
import 'package:flutter/foundation.dart' show kIsWeb;
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Sign Up Logic
  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String preferredLanguage, // 'en', 'hi', or 'gu'
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'lang': preferredLanguage,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // 2. Login Logic
  Future<String?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // 3. Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 4. Forgot Password Logic (NEW)
  Future<String?> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // 5. Google Sign-In Logic (NEW)
  // 5. Google Sign-In Logic (Hybrid for Web & Android)
  Future<String?> signInWithGoogle() async {
    try {
      UserCredential result;

      if (kIsWeb) {
        // --- CHROME / WEB FLOW ---
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        result = await _auth.signInWithPopup(authProvider);
      } else {
        // --- ANDROID / PLAY STORE FLOW ---
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) return "User canceled";

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        result = await _auth.signInWithCredential(credential);
      }

      // --- SAVE USER TO FIRESTORE (Same for both) ---
      User? user = result.user;
      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (!doc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': user.displayName ?? "User",
            'email': user.email,
            'lang': 'en',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
      return "success";
    } catch (e) {
      return e.toString();
    }
  }
}