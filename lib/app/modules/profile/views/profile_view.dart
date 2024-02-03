import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back),
          ),
          title: const Text('ProfileView'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                authC.logout();
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  AvatarGlow(
                    duration: const Duration(milliseconds: 500),
                    glowRadiusFactor: 0.15,
                    glowColor: Colors.blue,
                    child: Container(
                      width: 175,
                      height: 175,
                      decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: AssetImage('assets/logo/user.png'),
                          )),
                    ),
                  ),
                  const Gap(15),
                  Text(
                    'Lorem Ipsum',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Lorem.Ipsum@gmail.com',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(100),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        onTap: () => Get.toNamed(Routes.UPDATE_STATUS),
                        leading: Icon(Icons.note_add_outlined),
                        trailing: Icon(
                          Icons.arrow_right,
                          color: Colors.blue[900],
                        ),
                        title: Text(
                          'Update Status',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: () => Get.toNamed(Routes.CHANGE_PROFILE),
                        leading: Icon(Icons.person),
                        trailing: Icon(
                          Icons.arrow_right,
                          color: Colors.blue[900],
                        ),
                        title: Text(
                          'Change Profile',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: () {},
                        leading: Icon(Icons.color_lens_sharp),
                        trailing: Text('Light'),
                        title: Text(
                          'Change Theme',
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Text('Chat App', style: TextStyle(color: Colors.grey)),
                  Text('V.1.0', style: TextStyle(color: Colors.grey))
                ],
              ),
            ),
          ],
        ));
  }
}
