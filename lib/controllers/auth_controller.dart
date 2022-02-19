import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:safecampus/controllers/profile_controller.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  void onInit() {
    super.onInit();
    Get.put(UserController());
    authStateChanges().listen((user) {
      if (user == null) {
        userController.user = null;
      } else {
        userController.listenProfile();
        userController.listenAssesments();
        userController.listenContacts();
      }
      userController.update();
    });
  }

  Stream<bool> checkUserVerified() async* {
    bool verified = false;
    while (!verified) {
      await Future.delayed(const Duration(seconds: 5));
      if (currentUser != null) {
        await currentUser!.reload();
        verified = currentUser!.emailVerified;
        if (verified) yield true;
      }
    }
  }

  User? get currentUser => _firebaseAuth.currentUser;

  String? get uid => currentUser?.uid;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    return userCredential.user;
  }

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<String> resetPassword({required String email}) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email).then((value) => "Success").catchError((error) {
      return error.code.toString();
    });
  }

  signInwithPhoneNumber(String phoneNumber) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+44 7123 123 456',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: (String verificationId, int? forceResendingToken) {},
      verificationFailed: (FirebaseAuthException error) {},
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

AuthController auth = AuthController.instance;
