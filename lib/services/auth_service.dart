import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  // 4. Forgot Password Logic
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

  // 5. Google Sign-In Logic
  Future<String?> signInWithGoogle() async {
    try {
      UserCredential result;

      if (kIsWeb) {
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        result = await _auth.signInWithPopup(authProvider);
      } else {
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

  // 6. Change Password (NEW)
  // 6. Change Password Logic
  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return "No user is currently logged in.";

      // Step 1: Re-authenticate user to prove their identity
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Step 2: Update to the new password
      await user.updatePassword(newPassword);

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message; // Returns Firebase errors (e.g., "Wrong password")
    } catch (e) {
      return e.toString();
    }
  }

  // 7. Delete Account (NEW)
  Future<String?> deleteAccount({String? password}) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return "No user logged in";

      // Check if user signed in with Google or Email/Password
      bool isGoogleUser = user.providerData.any((userInfo) => userInfo.providerId == 'google.com');

      // Re-authenticate before deletion
      if (isGoogleUser) {
        if (kIsWeb) {
          GoogleAuthProvider authProvider = GoogleAuthProvider();
          await user.reauthenticateWithPopup(authProvider);
        } else {
          final GoogleSignIn googleSignIn = GoogleSignIn();
          final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
          if (googleUser != null) {
            final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
            final AuthCredential credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );
            await user.reauthenticateWithCredential(credential);
          } else {
            return "Google re-authentication canceled.";
          }
        }
      } else {
        if (password == null || password.isEmpty) return "Password is required to delete account.";
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
      }

      // Delete from Firestore
      await _firestore.collection('users').doc(user.uid).delete();
      // Delete Auth record
      await user.delete();

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
}