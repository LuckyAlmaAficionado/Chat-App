import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchC> {
  SearchView({Key? key}) : super(key: key);

  final TextEditingController searchC = TextEditingController();
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(145),
          child: AppBar(
            backgroundColor: Colors.blue[900],
            title: const Text('Search'),
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back),
            ),
            flexibleSpace: Padding(
              padding: const EdgeInsets.fromLTRB(10, 50, 10, 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextField(
                  onChanged: (value) => controller.searchFriend(
                    value,
                    authC.user.value.email!,
                  ),
                  autocorrect: false,
                  controller: searchC,
                  cursorColor: Colors.blue[900],
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    hintText: 'Search new friend here...',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.search,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Obx(
          () => controller.tempSearch.length == 0
              ? Center(
                  child: Container(
                  width: Get.width * 0.7,
                  height: Get.width * 0.7,
                  child: Column(
                    children: [
                      Lottie.asset('assets/lottie/friendship.json'),
                      Text(
                        'Nama Tidak Ditemukan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ))
              : ListView.builder(
                  itemCount: controller.tempSearch.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black26,
                          child: controller.tempSearch[index]['photoUrl'] !=
                                  null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    controller.tempSearch[index]['photoUrl'],
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  'assets/logo/user.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                        title: Text(
                          '${controller.tempSearch[index]['name']}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${controller.tempSearch[index]['email']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        trailing: GestureDetector(
                            onTap: () => authC.addNewConnection(
                                controller.tempSearch[index]['email']),
                            child: Chip(label: Text('message'))),
                      ),
                    );
                  },
                ),
        ));
  }
}
