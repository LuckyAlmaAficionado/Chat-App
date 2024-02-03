import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'package:chatapp/app/utils/error_screen.dart';
import 'package:chatapp/app/utils/loading_screen.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final authC = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // ... ketika error lakukan
        if (snapshot.hasError) {
          return ErrorScreen();
        }

        // ... ketika koneksi sudah selesai
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            title: 'Chat App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: false,
              textTheme: GoogleFonts.outfitTextTheme(),
              primaryTextTheme: GoogleFonts.outfitTextTheme(),
            ),
            initialRoute: Routes.CHAT_ROOM,
            getPages: AppPages.routes,
          );
          // return FutureBuilder(
          //   future: Future.delayed(const Duration(seconds: 2)),
          //   builder: (context, snapshot) {
          //     // ... ketika koneksi selesai
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       return Obx(
          //         () => GetMaterialApp(
          //           debugShowCheckedModeBanner: false,
          //           theme: ThemeData(
          //             useMaterial3: false,
          //             textTheme: GoogleFonts.outfitTextTheme(),
          //           ),
          //           title: "Chat-App",
          //           initialRoute: authC.isSkipIntro.isTrue
          //               ? authC.isAuth.isTrue
          //                   ? Routes.HOME
          //                   : Routes.LOGIN
          //               : Routes.INTRODUCTION,
          //           getPages: AppPages.routes,
          //         ),
          //       );
          //     }

          //     // ... ketika koneksi loading
          //     return SplashScreen();
          //   },
          // );
        }

        // ... ketika koneksi belum selesai selesai
        return LoadingScreen();
      },
    );
  }
}
