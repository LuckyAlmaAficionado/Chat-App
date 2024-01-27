import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final List<Widget> myChats = List.generate(
    20,
    (index) => Card(
      child: ListTile(
        onTap: () => Get.toNamed(Routes.CHAT_ROOM),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.black26,
          child: Image.asset(
            'assets/logo/user.png',
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          'Orang ke $index',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Status orang ke $index',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        trailing: Chip(label: Text('3')),
      ),
    ),
  ).reversed.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Material(
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black38,
                  ),
                ),
              ),
              margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chats',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Material(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(100),
                    child: InkWell(
                      onTap: () => Get.toNamed(Routes.PROFILE),
                      borderRadius: BorderRadius.circular(100),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.person,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: myChats.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) => myChats[index],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SEARCH),
        child: Icon(Icons.search),
        backgroundColor: Colors.black12,
      ),
    );
  }
}
