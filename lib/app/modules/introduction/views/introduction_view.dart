import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Berinteraksi dengan mudah",
            body: "Kamu hanya perlu dirumah saja untuk mendapatkan teman baru.",
            image: Container(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset('assets/lottie/interaction.json'),
              ),
            ),
          ),
          PageViewModel(
            title: "Temukan sahabat baru",
            body:
                "Jika kamu memang jodoh karena aplikasi ini, kami sangat bahagia.",
            image: Container(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset('assets/lottie/friendship.json'),
              ),
            ),
          ),
          PageViewModel(
            title: "Aplikasi bebas biaya",
            body: "Kamu tidak perlu khawatir aplikasi ini bebas biaya apapun.",
            image: Container(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset('assets/lottie/payment.json'),
              ),
            ),
          ),
          PageViewModel(
            title: "Gabung sekarang juga",
            body:
                "Daftarkan diri kamu untuk menjadi bagian dari kami, kami akan menghubungkan dengan banyak teman lainnya.",
            image: Container(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset('assets/lottie/join.json'),
              ),
            ),
          ),
        ],
        showSkipButton: true,
        skip: const Text('Skip'),
        next: const Icon(Icons.skip_next),
        done:
            const Text("Login", style: TextStyle(fontWeight: FontWeight.w700)),
        onDone: () {
          // On Done button pressed
          Get.offAllNamed(Routes.LOGIN);
        },
        dotsDecorator: DotsDecorator(
          size: const Size.square(7.0),
          activeSize: const Size(15.0, 7.0),
          activeColor: HexColor('#39A7FF'),
          color: HexColor('E0F4FF'),
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }
}
