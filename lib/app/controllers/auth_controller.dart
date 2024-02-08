import 'package:chatapp/app/data/models/users_model.dart';
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

  // user model
  var user = UsersModel().obs;

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
        // get user sign in
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);

        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        // masukan data ke firebase
        CollectionReference ref = firestore.collection('users');

        // update lastSignInTime...
        await ref.doc(_currentUser!.email).update({
          "lastSignInTime":
              userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        });

        print('get simple email: ${_googleSignIn.currentUser!.email}');

        final currentUser = await ref.doc(_currentUser!.email).get();
        final curUserData = currentUser.data() as Map<String, dynamic>;

        user.value = UsersModel.fromJson(curUserData);
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

        final checkUser = await ref.doc(_currentUser!.email).get();

        String name =
            "${_currentUser?.displayName?.substring(0, 1).toUpperCase()}${_currentUser?.displayName?.substring(1)}";

        if (checkUser.data() == null) {
          await ref.doc(_currentUser!.email).set({
            "uid": userCredential!.user!.uid,
            "name": name,
            "keyName": _currentUser?.displayName?.substring(0, 1).toUpperCase(),
            "email": _currentUser?.email,
            "photoUrl": _currentUser?.photoUrl,
            "status": "",
            "creationTime":
                userCredential!.user!.metadata.creationTime?.toIso8601String(),
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            "updateTime": DateTime.now().toIso8601String(),
            "chats": [],
          });
        } else {
          await ref.doc(_currentUser!.email).update({
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
          });
        }

        final currentUser = await ref.doc(_currentUser!.email).get();
        final curUserData = currentUser.data() as Map<String, dynamic>;
        print(curUserData);

        user.value = UsersModel.fromJson(curUserData);

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

  // profile ......
  void changeProfile(String name, String status) async {
    try {
      CollectionReference ref = await firestore.collection('users');

      String date = DateTime.now().toIso8601String();

      ref.doc(_currentUser?.email).update({
        "name": "${name.substring(0, 1).toUpperCase()}${name.substring(1)}",
        "keyName": name.substring(0, 1).toUpperCase(),
        "status": status,
        "lastSignInTime":
            userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        "updateTime": date,
      });

      user.update((val) {
        val?.name = name;
        val?.status = status;
        val?.keyName = name.substring(0, 1).toUpperCase();
        val?.lastSignInTime =
            userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
        val?.updatedTime = date;
      });
    } catch (e) {
      throw ('Error changeProfile: $e');
    }
  }

  void updateStatus(String status) async {
    try {
      CollectionReference ref = await firestore.collection('users');

      String date = DateTime.now().toIso8601String();

      ref.doc(_currentUser?.email).update({
        "status": status,
        "lastSignInTime":
            userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
        "updateTime": date,
      });

      user.update((val) {
        val?.status = status;
        val?.lastSignInTime =
            userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
        val?.updatedTime = date;
      });
    } catch (e) {
      throw ('Error changeProfile: $e');
    }
  }

  // search ....
  void addNewConnection(String friendEmail) async {
    bool flagNewConnection = false;
    String date = DateTime.now().toIso8601String();

    // .... collection reference
    CollectionReference chatsRef = await firestore.collection('chats');
    CollectionReference ref = firestore.collection('users');
    var chat_id;

    final docUser = await ref.doc(_currentUser!.email).get();
    final docChats =
        await (docUser.data() as Map<String, dynamic>)['chats'] as List;

    if (docChats.length != 0) {
      // cek jika pengguna sudah pernah menambahkan teman siapa saja
      docChats.forEach((element) {
        if (element['connection'].toString() == friendEmail) {
          chat_id = element['chat_id'];
        }
      });

      // .....
      if (chat_id != null) {
        // sudah pernah memiliki koneksi
        flagNewConnection = false;
        Get.toNamed(Routes.CHAT_ROOM, arguments: chat_id);
      } else {
        // jika belum pernah memiliki
        // buat koneksi
        flagNewConnection = true;
      }
    } else {
      // tidak pernah menambahkan teman
      // buat koneksi ....
      flagNewConnection = true;
    }

    // jika tidak pernah membuat konkesi
    if (flagNewConnection) {
      // .... cek dari chats collection => connections => mereka berdua
      final chatDocs = await chatsRef.where(
        'connections',
        whereIn: [
          {
            _currentUser!.email,
            friendEmail,
          },
          {
            friendEmail,
            _currentUser!.email,
          },
        ],
      ).get();

      if (chatDocs.docs.length != 0) {
        // terdapat data chats
        final chatDataId = chatDocs.docs[0].id;
        final chatsData = chatDocs.docs[0].data() as Map<String, dynamic>;

        // data yang lama jangan di replace tapi di tambahkan
        print(docChats.length);
        docChats.add({
          "connection": friendEmail,
          "chat_id": chatDataId,
          "lastTime": date,
        });
        print(docChats.length);
        docChats.forEach((element) {
          print(element);
        });

        // .....
        await ref.doc(_currentUser!.email).update({'chats': docChats});

        // update lokal
        user.update((val) {
          val!.chats = docChats as List<ChatUser>;
        });

        chat_id = chatDataId;
        user.refresh();
      } else {
        // tidak ada data chats
        // ..... sudah pernah memiliki koneksi email
        // ..... belum pernah memiliki koneksi email

        // .. membuat sebuah koneksi doc chats
        final docIdChat = await chatsRef.add({
          "connections": {
            _currentUser!.email,
            friendEmail,
          },
          "total_chats": 0,
          "total_read": 0,
          "total_unread": 0,
          "chat": [],
          "lastTime": date,
        });

        docChats.add({
          "connection": friendEmail,
          "chat_id": docIdChat.id,
          "lastTime": date,
        });

        //....
        await ref.doc(_currentUser?.email).update({
          "chats": docChats,
        });

        user.update((user) {
          user!.chats = docChats as List<ChatUser>;
        });

        // create new chat id
        chat_id = docIdChat.id;

        user.refresh();
      }

      print(chat_id);

      Get.toNamed(Routes.CHAT_ROOM, arguments: chat_id);
    }
  }
}
