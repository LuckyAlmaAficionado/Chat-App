import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SearchC extends GetxController {
  // ....

  var queryAwal = [].obs;
  var tempSearch = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void searchFriend(String data, String email) async {
    print("Search: $data");

    // tanya apakah data ini kosong?
    if (data.length == 0) {
      queryAwal.value = [];
      tempSearch.value = [];
    } else {
      var capitalize = data.substring(0, 1).toUpperCase() + data.substring(1);
      print(capitalize);

      // fungsi akan dijalankan pertama kali
      if (queryAwal.length == 0 && data.length == 1) {
        //.......
        CollectionReference ref = await firestore.collection('users');

        // mengambil query
        final keyNameResult = await ref
            .where('keyName', isEqualTo: data.substring(0, 1).toUpperCase())
            .where('email', isNotEqualTo: email)
            .get();

        print("total data ada berapa ${keyNameResult.docs.length}");

        if (keyNameResult.docs.isNotEmpty) {
          for (int i = 0; i < keyNameResult.docs.length; i++) {
            queryAwal.add(keyNameResult.docs[i].data() as Map<String, dynamic>);
          }

          // print
          print("Query result: $queryAwal");
        }
      }

      // jika tidak kosong maka lakukan
      if (queryAwal.length != 0) {
        tempSearch.value = [];
        queryAwal.forEach((element) {
          print(element);

          print(element['name'].toString().startsWith(capitalize));
          if (element['name'].startsWith(capitalize)) {
            tempSearch.add(element);
          }
        });
      }
    }

    tempSearch.refresh();
    queryAwal.refresh();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
