import 'package:chat_app_yt_shivam_gupta_may/services/shared_preferance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getUserbyEmail(String Email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: Email)
        .get();
  }

  Future<QuerySnapshot> getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }

  Future<Stream<QuerySnapshot>> getDetailsByChatroomId(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("users")
        .snapshots();
  }

  Future<QuerySnapshot> Search(String username) async {
    var resulte = await FirebaseFirestore.instance
        .collection("users")
        .where('searchKey', isEqualTo: username.toUpperCase())
        .get();
    return resulte;
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapshot.exists) {
      return true;
    } else {
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessage(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  updateLastMesssageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    try {
      String? myUsername = await SharedPreferanceHelper().getUserName();
      // log('database getChatRoom username:: $myUsername');

      if (myUsername != null) {
        // Perform an initial fetch to log the current chatrooms
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("chatrooms")
            .orderBy("time", descending: true)
            .where("users", arrayContains: myUsername)
            .get();

        // log('  database page // getChatRoom method // Checking no of List= ${querySnapshot.docs.length}');

        if (querySnapshot.docs.isNotEmpty) {
          print(querySnapshot.docs.first.data());
          // log('database getChatRoom ${querySnapshot.docs.first.data()}');
        }

        // Return the stream of chatrooms for real-time updates
        return FirebaseFirestore.instance
            .collection("chatrooms")
            .orderBy("time", descending: true)
            .where("users", arrayContains: myUsername.toUpperCase())
            .snapshots();
      } else {
        // log('Error: Username is null');
        throw Exception('Username is null');
      }
    } catch (e) {
      // log('Error fetching chat rooms: $e');
      rethrow;
    }
  }
}
