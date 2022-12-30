import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthHelper {
  FirebaseAuthHelper._();

  static final FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper._();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> userSignInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential = await auth.signInWithCredential(credential);
    return userCredential.user;
  }

  Future<User?> userSignUp(
      {required String email, required String password}) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  Future<void> updateUserName({required String displayName}) async {
    await auth.currentUser!.updateDisplayName(displayName);
  }

  Future<void> updateEmail({required String newEmail}) async {
    await auth.currentUser!.updateEmail(newEmail);
  }

  Future<void> updatePassword({required String newPassword}) async {
    await auth.currentUser!.updatePassword(newPassword);
  }

  Future<User?> userSignIn(
      {required String email, required String password}) async {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<void> userSignOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
  }
}
