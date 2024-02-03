import 'package:chatapp/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  RxBool isSkipIntro = false.obs;
  RxBool isAuth = false.obs;

  // googleSignIn

  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;

  // firebase
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ....
  Future<void> firstInitialized() async {
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });
    await skipIntro().then((value) {
      if (value) {
        isSkipIntro.value = true;
      }
    });
  }

  // cek apakah intro akan di skip
  Future<bool> skipIntro() async {
    // mengubah isIntro menjadi true
    final box = GetStorage();
    if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
      return true;
    }
    return false;
  }

  // cek apakah sudah login
  Future<bool> autoLogin() async {
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void login() async {
    // buat fungsi untuk login google ....

    try {
      // untuk menghandle kebocoran data user sebelum login
      await _googleSignIn.signOut();

      // untuk mendapatkan google account
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      // cek kondisi apakah sedang signIn
      final isSignIn = await _googleSignIn.isSignedIn();

      if (isSignIn) {
        // kondisi login berhasil
        print('KONDISI BERHASIL LOGIN DENGAN AKUN: $_currentUser');

        // mendapatkan authentication
        final googleAuth = await _currentUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth!.idToken,
          accessToken: googleAuth.accessToken,
        );

        // mendapatkan user credential dan menyimpan data ke firebaseauth
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        print('USER CREDENTIAL');
        print(userCredential);

        // masukan data ke firebase
        CollectionReference ref = firestore.collection('users');
        ref.doc(_currentUser!.email).set({
          "uid": userCredential!.user!.uid,
          "name": _currentUser?.displayName,
          "email": _currentUser?.email,
          "photoUrl": _currentUser?.photoUrl,
          "status": "",
          "creationTime":
              userCredential!.user!.metadata.creationTime?.toIso8601String(),
          "lastSignInTime":
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
          "updateTime": DateTime.now().toIso8601String(),
        });

        // simpan status user sudah pernah login & tidak akan menampilkan introduction lagi
        final box = GetStorage();
        if (box.read('skipIntro') != null) {
          box.remove('skipIntro');
        }
        box.write('skipIntro', true);

        // ....
        // isAuth(true);
        Get.offAllNamed(Routes.HOME);
      } else {
        print('TIDAK BERHASIL LOGIN');
      }
    } catch (error) {
      print('error nih bos $error');
    }

    // ...
    // Get.offAllNamed(Routes.HOME);
  }

  void logout() async {
    // sign out account ...
    await _googleSignIn.signOut();
    // direct to login ...
    Get.offAllNamed(Routes.LOGIN);
  }
}
