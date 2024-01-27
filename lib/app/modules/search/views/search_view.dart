import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchC> {
  SearchView({Key? key}) : super(key: key);

  final TextEditingController searchC = TextEditingController();

  final List<Widget> friends = List.generate(
    1,
    (index) => Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.black26,
          child: Image.asset(
            'assets/logo/user.png',
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          'Orang ke ${index + 1}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'orang${index + 1}@gmail.com',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        trailing: GestureDetector(
            onTap: () => Get.toNamed(Routes.CHAT_ROOM),
            child: Chip(label: Text('message'))),
      ),
    ),
  );

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
      body: (friends.length == 0)
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
              itemCount: friends.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) => friends[index],
            ),
    );
  }
}
