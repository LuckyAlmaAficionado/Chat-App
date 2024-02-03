import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          leadingWidth: 90,
          leading: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(100),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Gap(15),
                  Icon(Icons.arrow_back),
                  const Gap(10),
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/logo/google.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lorem Ipsum',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'status lorem',
                style: TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ),
          centerTitle: false,
        ),
        // ignore: deprecated_member_use
        body: WillPopScope(
          onWillPop: () {
            if (controller.isShowEmoji.isTrue) {
              controller.isShowEmoji.value = false;
            } else {
              Get.back();
            }
            return Future.value(false);
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: Get.width,
                  child: ListView(
                    reverse: true,
                    children: [
                      ItemChat(
                        isSender: true,
                        text: 'Aku sang lengenda',
                        time: '19:00 PM',
                      ),
                      ItemChat(
                        isSender: false,
                        text: 'Kalo aku apa berarti',
                        time: '19:00 PM',
                      ),
                      ItemChat(
                        isSender: false,
                        text: 'Kalo aku apa berarti',
                        time: '19:00 PM',
                      ),
                    ],
                  ),
                ),
              ),

              // textfield & send button
              Container(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    new Expanded(
                      child: TextField(
                        controller: controller.chatC,
                        focusNode: controller.focusNode,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            onPressed: () {
                              controller.focusNode.unfocus();
                              controller.isShowEmoji.toggle();
                            },
                            icon: Icon(Icons.emoji_emotions_outlined),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Material(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.blue[900],
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(100),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Obx(() => (controller.isShowEmoji.isTrue)
                  ? Container(
                      height: 325,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          controller.addEmojiToChat(emoji);
                        },
                        onBackspacePressed: () {
                          controller.deleteEmoji();
                          // Do something when the user taps the backspace button (optional)
                          // Set it to null to hide the Backspace-Button
                        },
                        config: Config(
                          columns: 7,
                          emojiSizeMax: 32 *
                              (foundation.defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? 1.30
                                  : 1.0),
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          gridPadding: EdgeInsets.zero,
                          initCategory: Category.SMILEYS,
                          bgColor: Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          backspaceColor: Colors.blue,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          recentTabBehavior: RecentTabBehavior.RECENT,
                          recentsLimit: 28,
                          noRecents: const Text(
                            'No Recents',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black26),
                            textAlign: TextAlign.center,
                          ), // Needs to be const Widget
                          loadingIndicator: const SizedBox
                              .shrink(), // Needs to be const Widget
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                        ),
                      ),
                    )
                  : SizedBox()),
            ],
          ),
        ));
  }
}

class ItemChat extends StatelessWidget {
  const ItemChat({
    super.key,
    required this.isSender,
    required this.text,
    required this.time,
  });

  final bool isSender;
  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 20,
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: isSender ? Radius.circular(10) : Radius.circular(0),
                bottomRight:
                    !isSender ? Radius.circular(10) : Radius.circular(0),
              ),
              color: Colors.blue[900],
            ),
            padding: const EdgeInsets.all(15.0),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Text(time),
        ],
      ),
    );
  }
}
