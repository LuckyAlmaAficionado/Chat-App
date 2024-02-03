import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    controller.emailC.text = authC.user.value.email ?? "";
    controller.nameC.text = authC.user.value.name ?? "";
    controller.statusC.text = authC.user.value.status ?? '';
    return Scaffold(
        appBar: AppBar(
          title: const Text('Change Profile'),
          backgroundColor: Colors.blue[900],
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                // INFO: Change Profilex
                authC.changeProfile(
                  controller.nameC.text,
                  controller.statusC.text,
                );
              },
              icon: Icon(Icons.save),
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: AvatarGlow(
                duration: const Duration(seconds: 5),
                glowRadiusFactor: 0.09,
                glowColor: Colors.blue,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: AssetImage('assets/logo/user.png'),
                    ),
                  ),
                ),
              ),
            ),
            const Gap(60),
            TextField(
              controller: controller.emailC,
              cursorColor: Colors.black,
              readOnly: true,
              decoration: InputDecoration(
                label: Text('Email'),
                labelStyle: GoogleFonts.outfit(
                  color: Colors.black,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
            ),
            const Gap(20),
            TextField(
              controller: controller.nameC,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                label: Text('Name'),
                labelStyle: GoogleFonts.outfit(
                  color: Colors.black,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
            ),
            const Gap(20),
            TextField(
              controller: controller.statusC,
              cursorColor: Colors.black,
              onEditingComplete: () {
                // INFO: Change Profilex
                authC.changeProfile(
                  controller.nameC.text,
                  controller.statusC.text,
                );
              },
              decoration: InputDecoration(
                label: Text('Status'),
                labelStyle: GoogleFonts.outfit(
                  color: Colors.black,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
            ),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('No Image'),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Choosen...',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Gap(20),
            Container(
              width: Get.width,
              child: ElevatedButton(
                onPressed: () {
                  // INFO: Change Profilex
                  authC.changeProfile(
                    controller.nameC.text,
                    controller.statusC.text,
                  );
                },
                child: Text('UPDATE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  textStyle: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
